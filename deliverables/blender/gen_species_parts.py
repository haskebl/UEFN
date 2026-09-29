#!/usr/bin/env python3
# =====================================================================
# REFERENZ — UNGEPRÜFT bis in UEFN kompiliert
# gen_species_parts.py  (FUSE THE BRAINROT)
#
# Erzeugt prozedural die 8 Arten × 3 Teile (Kopf / Körper / Accessoire)
# als Low-Poly-"Glossy Toy"-Meshes aus Primitiven + Modifiern (GDD §4.4, §11).
#
# Aufruf (Blender 4.x, headless):
#   blender -b -P gen_species_parts.py -- --out ./out [--species Waffelino,Frogurko] [--lods]
# Ohne Blender (nur Parameter-/Sockel-Tabelle prüfen, kein bpy nötig):
#   python3 gen_species_parts.py --dry-run
#
# Konventionen (bitte in UEFN prüfen, siehe README.md):
#   * Einheiten: Szene scale_length = 0.01, length_unit = CENTIMETERS
#     -> 1 Blender-Unit (BU) = 1 cm. Alle Maße im SPECIES-Dict sind cm.
#     FBX-Export mit apply_unit_scale + FBX_SCALE_UNITS => Import in UEFN 1:1
#     (Import-Skalierung 1.0, kein ×100-Problem).
#   * Blickrichtung der Kreatur: -Y (Blender-"Front"), oben: +Z.
#   * Pivot = Montagepunkt: Körper unten Mitte (Pad-Oberfläche), Kopf an der
#     Hals-Unterseite, Accessoire am Montagepunkt (Rücken/Hals/Kopf-oben/Gesicht).
#   * Sockel: Empties "SOCKET_<Name>" als Kinder des Meshes (UE-FBX-Konvention
#     für Static-Mesh-Sockets, in UEFN LIKELY). Verse benutzt NICHT die
#     Sockets, sondern die Offset-Tabelle (parts_layout.json ->
#     ftb_creature_pool.verse). Verse-lokal: X = -Y_bl (vorwärts),
#     Y = -X_bl (rechts), Z = Z_bl (oben).
#   * Material: EIN Master-Material "M_FTB_Creature" für alle Teile.
#     Farbe über Paletten-UVs (Textur T_FTB_Palette 256×64, 16×4 Zellen à 16 px)
#     UND Vertex-Farbe (RGB = Palettenfarbe, A = 1 Körperfarbe / 0 Augen,
#     damit Seltenheits-Formen die Augen nicht vergolden).
#   * Dreiecks-Budget (GDD §4.1): Kopf ≤ 1500, Körper ≤ 2500, Accessoire ≤ 800.
#     Wird überschritten -> automatischer Decimate + Warnung im Log.
# =====================================================================

import sys
import os
import json
import math
import argparse

try:
    import bpy
    import bmesh
    from mathutils import Matrix, Vector, Euler
except ImportError:  # Dry-Run ohne Blender
    bpy = None

# ---------------------------------------------------------------------
# Palette: 16 Spalten × 4 Zeilen. Zeile 0 = Primärfarben, Zeile 1 =
# Sekundärfarben der 10 Arten (GDD §11), Zeile 2 = gemeinsame Farben.
# ---------------------------------------------------------------------
PALETTE_W, PALETTE_H, CELL = 256, 64, 16
SPECIES_COLORS = [  # (primär, sekundär), Reihenfolge = Art-ID 1..10
    ("#E8A94B", "#7A4A1E"), ("#6BBF3A", "#D9F2B4"), ("#E53935", "#FFD54F"), ("#FFE08A", "#E4572E"),
    ("#C9D6E3", "#FF4FD8"), ("#22263A", "#FF7A1A"), ("#7E8BA8", "#FFF36B"), ("#FFC107", "#3E2723"),
    ("#D32F2F", "#FFFFFF"), ("#8D5A3B", "#212121"),
]
SHARED = {  # Zeile 2
    "EW": "#FFFFFF", "EB": "#15151F", "WH": "#F7F4EF", "MT": "#B8BCC6", "GL": "#BFE9FF",
    "PK": "#FF8FB1", "AMB": "#D9861C", "RD": "#E53935", "DG": "#2E7D32", "BR": "#6B3E1F",
    "YL": "#FFD23F", "RB": "#7C4DFF",
}
EYE_KEYS = {"EW", "EB"}  # Vertex-Alpha 0 -> Rarity-Material lässt diese Flächen unverändert

BUDGET = {"Head": 1500, "Body": 2500, "Accessory": 800}
SLOTS = ["Head", "Body", "Accessory"]


def hex_rgb(h):
    h = h.lstrip("#")
    return tuple(int(h[i:i + 2], 16) / 255.0 for i in (0, 2, 4))


def cell_of(species_idx, key):
    """Palettenzelle (Spalte, Zeile) für Farbschlüssel P/S/gemeinsam."""
    if key == "P":
        return species_idx, 0
    if key == "S":
        return species_idx, 1
    return list(SHARED).index(key), 2


def color_of(species_idx, key):
    if key == "P":
        return hex_rgb(SPECIES_COLORS[species_idx][0])
    if key == "S":
        return hex_rgb(SPECIES_COLORS[species_idx][1])
    return hex_rgb(SHARED[key])


# ---------------------------------------------------------------------
# Primitive-Helfer. d = Abmessungen (cm), r = Rotation (Grad), c = Farbe.
# ---------------------------------------------------------------------
def prim(t, loc, d, c="P", r=(0, 0, 0), seg=None, r2=None):
    return {"t": t, "loc": loc, "d": d, "r": r, "c": c, "seg": seg, "r2": r2}


def eyes(z, y, spread, rad):
    """Einheitlicher Augenstil (GDD §11): große Glanzaugen, Pupille, Glanzpunkt."""
    out = []
    for sx in (-1, 1):
        x = sx * spread
        out.append(prim("sphere", (x, y, z), (2 * rad, 1.4 * rad, 2 * rad), "EW", seg=(12, 8)))
        out.append(prim("sphere", (x, y - 0.6 * rad, z - 0.1 * rad), (rad, 0.5 * rad, rad), "EB", seg=(10, 6)))
        out.append(prim("sphere", (x + 0.25 * rad, y - 0.85 * rad, z + 0.25 * rad), (0.3 * rad,) * 3, "EW", seg=(6, 4)))
    return out


def ring(n, radius, z, d, c, t="sphere", y0=0.0, a0=0.0, a1=360.0):
    out = []
    for i in range(n):
        a = math.radians(a0 + (a1 - a0) * i / max(1, n if a1 - a0 >= 360 else n - 1))
        out.append(prim(t, (radius * math.cos(a), y0 + radius * math.sin(a), z), d, c, seg=(8, 6)))
    return out


# ---------------------------------------------------------------------
# SPECIES: parametrische Beschreibung je Art (GDD §4.4 Teile-Spalte).
# sockets: Blender-Koordinaten in cm, relativ zum Pivot des jeweiligen Teils.
# acc_mount: an welchem Sockel das Accessoire sitzt.
# ---------------------------------------------------------------------
SPECIES = {
    "Waffelino": {  # Waffeleisen-Maus
        "id": 1, "acc_mount": "Back",
        "Head": [prim("sphere", (0, 0, 42), (84, 78, 80)),
                 prim("cyl", (-34, 4, 82), (40, 40, 8), r=(90, 0, -15)), prim("cyl", (34, 4, 82), (40, 40, 8), r=(90, 0, 15)),
                 prim("cyl", (-34, 0, 82), (28, 28, 4), "S", r=(90, 0, -15)), prim("cyl", (34, 0, 82), (28, 28, 4), "S", r=(90, 0, 15)),
                 prim("sphere", (0, -36, 34), (34, 28, 26)), prim("sphere", (0, -50, 38), (10, 8, 8), "PK")] + eyes(50, -34, 16, 11),
        "Body": [prim("cube", (0, 0, 40), (90, 80, 30)), prim("cube", (0, 4, 64), (88, 78, 20), r=(-8, 0, 0)),
                 prim("cyl", (0, 40, 56), (12, 12, 70), "MT", r=(0, 90, 0))]
                + [prim("cube", (x, 4, 75), (4, 70, 3), "S") for x in (-24, 0, 24)]
                + [prim("cyl", (sx * 30, sy * 25, 12), (16, 16, 24), "S") for sx in (-1, 1) for sy in (-1, 1)],
        "Accessory": [prim("cyl", (0, 14, 0), (26, 26, 44), "AMB"), prim("cyl", (0, 14, 28), (10, 10, 12), "AMB"),
                      prim("cyl", (0, 14, 36), (12, 12, 6), "RD"),
                      prim("cube", (-10, 2, 10), (4, 6, 40), "S"), prim("cube", (10, 2, 10), (4, 6, 40), "S")],
        "sockets": {"Body": {"Head": (0, 0, 80), "Back": (0, 40, 50), "Neck": (0, -30, 78)},
                    "Head": {"HeadTop": (0, 0, 100), "Face": (0, -40, 40)}},
    },
    "Frogurko": {  # Gurkenglas-Frosch
        "id": 2, "acc_mount": "HeadTop",
        "Head": [prim("sphere", (0, 0, 34), (78, 70, 66)), prim("cube", (0, -34, 22), (40, 4, 4), "EB")]
                + ring(5, 30, 30, (10, 10, 10), "S") + eyes(62, -22, 20, 14),
        "Body": [prim("cyl", (0, 0, 52), (80, 80, 76), "GL"), prim("cyl", (0, 0, 50), (50, 50, 60), "P"),
                 prim("cyl", (0, 0, 86), (70, 70, 8), "MT"),
                 prim("sphere", (-38, 10, 16), (30, 44, 24)), prim("sphere", (38, 10, 16), (30, 44, 24)),
                 prim("cyl", (-22, -30, 8), (14, 14, 16)), prim("cyl", (22, -30, 8), (14, 14, 16))],
        "Accessory": [prim("torus", (0, 0, 4), (40, 40, 8), "DG")]
                     + [dict(p, t="cone") for p in ring(5, 20, 14, (8, 8, 22), "DG")],
        "sockets": {"Body": {"Head": (0, 0, 90), "Back": (0, 40, 50), "Neck": (0, -35, 85)},
                    "Head": {"HeadTop": (0, 0, 72), "Face": (0, -38, 35)}},
    },
    "Idrantoro": {  # Hydranten-Stier
        "id": 3, "acc_mount": "Neck",
        "Head": [prim("sphere", (0, 0, 40), (80, 76, 72)), prim("cube", (0, -36, 28), (50, 26, 32), "S"),
                 prim("cone", (-44, 0, 62), (14, 14, 36), "MT", r=(0, -70, 0)), prim("cone", (44, 0, 62), (14, 14, 36), "MT", r=(0, 70, 0)),
                 prim("cyl", (0, 0, 78), (22, 22, 8), "S")] + eyes(52, -34, 18, 11),
        "Body": [prim("cyl", (0, 0, 52), (76, 76, 76)), prim("cyl", (0, 0, 88), (82, 82, 8), "S"),
                 prim("cyl", (-42, 0, 58), (18, 18, 16), "S", r=(0, 90, 0)), prim("cyl", (42, 0, 58), (18, 18, 16), "S", r=(0, 90, 0))]
                + [prim("cyl", (sx * 22, sy * 20, 7), (18, 18, 14), "EB") for sx in (-1, 1) for sy in (-1, 1)],
        "Accessory": [prim("torus", (0, 30, 0), (76, 76, 14), "RD"), prim("cyl", (14, -4, -20), (12, 12, 30), "RD"),
                      prim("cone", (14, -4, -38), (12, 12, 12), "MT", r=(180, 0, 0))],
        "sockets": {"Body": {"Head": (0, 0, 95), "Back": (0, 38, 55), "Neck": (0, -34, 90)},
                    "Head": {"HeadTop": (0, 0, 82), "Face": (0, -40, 40)}},
    },
    "Tagliatakel": {  # Nudel-Oktopus
        "id": 4, "acc_mount": "Neck",
        "Head": [prim("sphere", (0, 0, 44), (86, 80, 88), "S"), prim("torus", (0, 0, 86), (60, 60, 20), "P"),
                 prim("torus", (0, 0, 94), (36, 36, 14), "P")] + eyes(46, -38, 18, 12),
        "Body": [prim("cone", (0, 0, 34), (110, 110, 60), "WH", r2=0.4), prim("torus", (0, 0, 10), (114, 114, 10), "WH")]
                + [dict(p, t="cyl", d=(8, 8, 40), r=(90, 0, i * 45 + 90)) for i, p in enumerate(ring(8, 48, 8, (8, 8, 40), "P"))],
        "Accessory": ring(7, 30, -4, (12, 12, 12), "BR", y0=22, a0=200, a1=340),
        "sockets": {"Body": {"Head": (0, 0, 65), "Back": (0, 45, 40), "Neck": (0, -30, 62)},
                    "Head": {"HeadTop": (0, 0, 100), "Face": (0, -40, 40)}},
    },
    "Diskolama": {  # Discokugel-Lama
        "id": 5, "acc_mount": "Face",
        "Head": [prim("sphere", (0, -6, 48), (56, 70, 96)), prim("sphere", (0, -34, 40), (40, 30, 30)),
                 prim("cone", (-16, 6, 98), (12, 10, 30)), prim("cone", (16, 6, 98), (12, 10, 30)),
                 prim("sphere", (0, 4, 92), (46, 46, 40), "MT", seg=(10, 8))] + eyes(60, -30, 14, 10),
        "Body": [prim("sphere", (0, 4, 72), (70, 96, 60)), prim("cyl", (0, -30, 86), (34, 34, 30))]
                + [prim("cyl", (sx * 20, sy, 20), (14, 14, 44)) for sx in (-1, 1) for sy in (-26, 34)]
                + [prim("cyl", (sx * 20, sy, 3), (16, 16, 6), "S") for sx in (-1, 1) for sy in (-26, 34)],
        "Accessory": [prim("cube", (-12, -4, 0), (20, 6, 14), "EB"), prim("cube", (12, -4, 0), (20, 6, 14), "EB"),
                      prim("cube", (0, -4, 4), (8, 4, 4), "S"),
                      prim("cube", (-24, 10, 2), (3, 26, 3), "S"), prim("cube", (24, 10, 2), (3, 26, 3), "S"),
                      prim("cube", (-12, -4, -10), (22, 8, 6), "S"), prim("cube", (12, -4, -10), (22, 8, 6), "S")],
        "sockets": {"Body": {"Head": (0, 0, 100), "Back": (0, 40, 75), "Neck": (0, -40, 95)},
                    "Head": {"HeadTop": (0, 0, 110), "Face": (0, -35, 55)}},
    },
    "Razzopingu": {  # Raketen-Pinguin
        "id": 6, "acc_mount": "Neck",
        "Head": [prim("sphere", (0, 0, 40), (74, 70, 78)), prim("sphere", (0, -14, 36), (58, 50, 60), "WH"),
                 prim("cone", (0, -40, 32), (16, 22, 16), "S", r=(90, 0, 0)),
                 prim("cyl", (-14, -30, 56), (22, 22, 8), "BR", r=(90, 0, 0)), prim("cyl", (14, -30, 56), (22, 22, 8), "BR", r=(90, 0, 0)),
                 prim("torus", (0, 0, 56), (76, 76, 6), "BR")] + eyes(56, -34, 14, 7),
        "Body": [prim("cyl", (0, 0, 50), (70, 70, 70)), prim("sphere", (0, 0, 85), (70, 70, 24)),
                 prim("sphere", (0, -12, 48), (50, 40, 60), "WH"), prim("cone", (0, 0, 8), (40, 40, 16), "MT", r=(180, 0, 0)),
                 prim("cube", (0, 34, 24), (40, 8, 30))]
                + [dict(p, t="cube", d=(6, 26, 30), r=(0, 0, i * 120 + 90)) for i, p in enumerate(ring(3, 36, 20, (6, 26, 30), "S"))],
        "Accessory": [prim("cone", (-10, -4, 0), (16, 10, 16), "S", r=(0, 90, 0)), prim("cone", (10, -4, 0), (16, 10, 16), "S", r=(0, -90, 0)),
                      prim("sphere", (0, -6, 0), (8, 8, 8), "S"),
                      prim("cone", (-22, -4, 0), (8, 8, 12), "YL", r=(0, 90, 0)), prim("cone", (22, -4, 0), (8, 8, 12), "YL", r=(0, -90, 0))],
        "sockets": {"Body": {"Head": (0, 0, 95), "Back": (0, 35, 55), "Neck": (0, -32, 88)},
                    "Head": {"HeadTop": (0, 0, 82), "Face": (0, -38, 45)}},
    },
    "Wolkowal": {  # Gewitterwolken-Wal
        "id": 7, "acc_mount": "Back",
        "Head": [prim("sphere", (0, -6, 36), (90, 80, 70)), prim("sphere", (-22, 6, 62), (36, 36, 30)),
                 prim("sphere", (22, 6, 62), (36, 36, 30)), prim("sphere", (0, 10, 70), (36, 36, 30)),
                 prim("cyl", (0, 12, 76), (10, 10, 6), "EB"), prim("sphere", (-30, -38, 26), (14, 6, 10), "PK"),
                 prim("sphere", (30, -38, 26), (14, 6, 10), "PK")] + eyes(40, -40, 24, 10),
        "Body": [prim("sphere", (0, 0, 54), (100, 80, 60)), prim("sphere", (-40, 10, 46), (50, 50, 44)),
                 prim("sphere", (40, 10, 46), (50, 50, 44)), prim("sphere", (0, 30, 40), (60, 50, 40)),
                 prim("cube", (0, 56, 50), (60, 10, 20))]
                + [prim("cyl", (x, 0, 12), (4, 4, 16), "GL") for x in (-30, -15, 0, 15, 30)],
        "Accessory": [prim("cyl", (0, 6, 30), (4, 4, 60), "MT"), prim("cone", (0, 6, 64), (80, 80, 24), "S", r2=0.05),
                      prim("torus", (0, 6, 56), (78, 78, 6), "RD"), prim("torus", (0, 6, 60), (60, 60, 5), "RB")],
        "sockets": {"Body": {"Head": (0, 0, 85), "Back": (0, 45, 60), "Neck": (0, -40, 80)},
                    "Head": {"HeadTop": (0, 0, 78), "Face": (0, -45, 35)}},
    },
    "Bzzkoffro": {  # Koffer-Hummel
        "id": 8, "acc_mount": "Back",
        "Head": [prim("sphere", (0, 0, 38), (76, 72, 76)),
                 prim("cyl", (0, 0, 74), (70, 70, 4), "S"), prim("cyl", (0, 0, 84), (44, 44, 18), "S"),
                 prim("cyl", (0, 0, 78), (45, 45, 5), "RD"),
                 prim("cyl", (-14, 0, 80), (4, 4, 24), "EB", r=(0, -20, 0)), prim("cyl", (14, 0, 80), (4, 4, 24), "EB", r=(0, 20, 0))]
                + eyes(44, -34, 16, 13),
        "Body": [prim("cube", (0, 0, 42), (80, 45, 64)), prim("cube", (0, 0, 30), (82, 47, 6), "S"),
                 prim("cube", (0, 0, 54), (82, 47, 6), "S"), prim("torus", (44, 0, 50), (24, 24, 4), "EB", r=(0, 90, 0))]
                + [prim("cyl", (sx * 30, sy * 16, 6), (12, 12, 8), "EB", r=(0, 90, 0)) for sx in (-1, 1) for sy in (-1, 1)],
        "Accessory": [prim("cube", (-24, 10, 14), (44, 3, 28), "GL", r=(0, -30, 0)), prim("cube", (24, 10, 14), (44, 3, 28), "GL", r=(0, 30, 0)),
                      prim("cube", (-28, 8, 18), (10, 2, 8), "RD", r=(0, -30, 0)), prim("cube", (26, 8, 10), (10, 2, 8), "YL", r=(0, 30, 0))],
        "sockets": {"Body": {"Head": (0, 0, 75), "Back": (0, 23, 50), "Neck": (0, -23, 72)},
                    "Head": {"HeadTop": (0, 0, 95), "Face": (0, -38, 40)}},
    },
}


def to_verse_local(v):
    """Blender (x, y, z) -> Verse-lokal (vorwärts, rechts, oben)."""
    x, y, z = v
    return (-y, -x, z)


def layout_table():
    """Offset-Tabelle für ftb_creature_pool.verse (auch ohne Blender erzeugbar)."""
    out = {}
    for name, sp in SPECIES.items():
        out[name] = {
            "id": sp["id"], "acc_mount": sp["acc_mount"],
            "sockets_blender_cm": sp["sockets"],
            "sockets_verse_local_cm": {slot: {k: to_verse_local(v) for k, v in socks.items()}
                                       for slot, socks in sp["sockets"].items()},
        }
    return out


# =====================================================================
# Ab hier nur mit Blender (bpy)
# =====================================================================
def setup_scene():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    us = bpy.context.scene.unit_settings
    us.system = "METRIC"
    us.scale_length = 0.01          # 1 BU = 1 cm
    us.length_unit = "CENTIMETERS"


def add_primitive(bm, p, species_idx):
    """Erzeugt ein Primitiv in bm und gibt (neue Faces, Farbschlüssel) zurück."""
    t, d = p["t"], p["d"]
    before = set(bm.faces)
    if t == "sphere":
        u, v = p["seg"] or (12, 8)
        res = bmesh.ops.create_uvsphere(bm, u_segments=u, v_segments=v, radius=0.5)
    elif t == "cube":
        res = bmesh.ops.create_cube(bm, size=1.0)
    elif t in ("cyl", "cone"):
        segs = (p["seg"] or (16,))[0]
        r2 = 0.5 if t == "cyl" else 0.5 * (p["r2"] or 0.0)
        res = bmesh.ops.create_cone(bm, cap_ends=True, cap_tris=False, segments=segs,
                                    radius1=0.5, radius2=r2, depth=1.0)
    elif t == "torus":
        res = {"verts": make_torus(bm, d)}
        d = (1.0, 1.0, 1.0)  # Maße schon eingebaut
    else:
        raise ValueError("Unbekanntes Primitiv: " + t)
    verts = res["verts"]
    rx, ry, rz = (math.radians(a) for a in p["r"])
    mat = (Matrix.Translation(Vector(p["loc"])) @ Euler((rx, ry, rz), "XYZ").to_matrix().to_4x4()
           @ Matrix.Diagonal(Vector((d[0], d[1], d[2], 1.0))))
    bmesh.ops.transform(bm, matrix=mat, verts=verts)
    return [f for f in bm.faces if f not in before], p["c"]


def make_torus(bm, d, major_seg=16, minor_seg=6):
    """Torus: d = (Außendurchmesser X, Außendurchmesser Y, Rohrdicke)."""
    tube = d[2] / 2.0
    rx, ry = d[0] / 2.0 - tube, d[1] / 2.0 - tube
    grid = []
    for i in range(major_seg):
        a = 2 * math.pi * i / major_seg
        row = []
        for j in range(minor_seg):
            b = 2 * math.pi * j / minor_seg
            k = 1.0 + (tube * math.cos(b)) / max(rx, 1e-3)
            row.append(bm.verts.new((rx * k * math.cos(a), ry * k * math.sin(a), tube * math.sin(b))))
        grid.append(row)
    for i in range(major_seg):
        for j in range(minor_seg):
            a, b = grid[i][j], grid[(i + 1) % major_seg][j]
            c, e = grid[(i + 1) % major_seg][(j + 1) % minor_seg], grid[i][(j + 1) % minor_seg]
            bm.faces.new((a, b, c, e))
    return [v for row in grid for v in row]


def tri_count(obj):
    deps = bpy.context.evaluated_depsgraph_get()
    ev = obj.evaluated_get(deps)
    me = ev.to_mesh()
    me.calc_loop_triangles()
    n = len(me.loop_triangles)
    ev.to_mesh_clear()
    return n


def apply_modifiers(obj):
    for o in bpy.context.selected_objects:
        o.select_set(False)
    bpy.context.view_layer.objects.active = obj
    obj.select_set(True)
    for m in list(obj.modifiers):
        bpy.ops.object.modifier_apply(modifier=m.name)


def paint_and_uv(obj, face_keys, species_idx):
    """Paletten-UVs (Fläche -> innere 50 % ihrer Zelle, planar projiziert) + Vertex-Farbe."""
    me = obj.data
    uv = me.uv_layers.new(name="UVMap")
    col = me.color_attributes.new(name="Col", type="BYTE_COLOR", domain="CORNER")
    bb_min = Vector((min(v.co[i] for v in me.vertices) for i in range(3)))
    bb_size = Vector((max(max(v.co[i] for v in me.vertices) - bb_min[i], 1e-3) for i in range(3)))
    for poly in me.polygons:
        key = face_keys.get(poly.index, "P")
        cx, cy = cell_of(species_idx, key)
        r, g, b = color_of(species_idx, key)
        alpha = 0.0 if key in EYE_KEYS else 1.0
        n = poly.normal
        ax = max(range(3), key=lambda i: abs(n[i]))
        u_i, v_i = [i for i in range(3) if i != ax]
        for li in poly.loop_indices:
            co = me.vertices[me.loops[li].vertex_index].co
            fu = (co[u_i] - bb_min[u_i]) / bb_size[u_i]
            fv = (co[v_i] - bb_min[v_i]) / bb_size[v_i]
            # innere Hälfte der Zelle -> kein Farbbluten bei Mip-Maps
            px = (cx + 0.25 + 0.5 * fu) * CELL
            py = (cy + 0.25 + 0.5 * fv) * CELL
            uv.data[li].uv = (px / PALETTE_W, 1.0 - py / PALETTE_H)
            col.data[li].color = (r, g, b, alpha)


def build_part(species, sp, slot, master_mat, lods):
    idx = sp["id"] - 1
    name = f"SM_FTB_{species}_{slot}"
    bm = bmesh.new()
    face_keys_bm = []
    for p in sp[slot]:
        faces, key = add_primitive(bm, p, idx)
        face_keys_bm += [(f, key) for f in faces]
    for f, key in face_keys_bm:
        f.material_index = 0
    bm.faces.index_update()
    bm.faces.ensure_lookup_table()
    key_by_face = {f.index: key for f, key in face_keys_bm}
    me = bpy.data.meshes.new(name)
    bm.to_mesh(me)
    bm.free()
    obj = bpy.data.objects.new(name, me)
    bpy.context.collection.objects.link(obj)
    me.materials.append(master_mat)
    # Glossy-Toy-Rundung: Bevel nur an harten Kanten (Würfel/Zylinder), GDD §11
    bev = obj.modifiers.new("Bevel", "BEVEL")
    bev.width = 3.0
    bev.segments = 2
    bev.limit_method = "ANGLE"
    bev.angle_limit = math.radians(40)
    bev.harden_normals = False
    tri_before = tri_count(obj)
    if tri_before > BUDGET[slot]:
        obj.modifiers.remove(bev)  # Bevel kostet zu viel -> weglassen
    # Farbzuordnung: Bevel erzeugt neue Flächen -> Schlüssel per nächstem Ursprungs-Face
    face_centers = [(me.polygons[i].center.copy(), k) for i, k in key_by_face.items()]
    apply_modifiers(obj)
    me = obj.data
    face_keys = {}
    for poly in me.polygons:
        best = min(face_centers, key=lambda fc: (fc[0] - poly.center).length_squared)
        face_keys[poly.index] = best[1]
    # Budget prüfen, notfalls dezimieren
    tris = tri_count(obj)
    if tris > BUDGET[slot]:
        dec = obj.modifiers.new("Decimate", "DECIMATE")
        dec.ratio = BUDGET[slot] / tris * 0.95
        print(f"[WARN] {name}: {tris} Tris > Budget {BUDGET[slot]} -> Decimate {dec.ratio:.2f}")
        apply_modifiers(obj)
        me = obj.data
        face_keys = {p.index: min(face_centers, key=lambda fc: (fc[0] - p.center).length_squared)[1] for p in me.polygons}
        tris = tri_count(obj)
    paint_and_uv(obj, face_keys, idx)
    shade_smooth(obj)
    add_sockets(obj, sp, slot)
    if lods:
        for lvl, ratio in ((1, 0.5), (2, 0.2)):
            lod = obj.copy()
            lod.data = obj.data.copy()
            lod.name = f"{name}_LOD{lvl}"
            bpy.context.collection.objects.link(lod)
            d = lod.modifiers.new("Decimate", "DECIMATE")
            d.ratio = ratio
            apply_modifiers(lod)
    return obj, tris


def shade_smooth(obj):
    for p in obj.data.polygons:
        p.use_smooth = True
    for o in bpy.context.selected_objects:
        o.select_set(False)
    obj.select_set(True)
    bpy.context.view_layer.objects.active = obj
    try:  # Blender ≥ 4.1
        bpy.ops.object.shade_smooth_by_angle(angle=math.radians(40))
    except (AttributeError, RuntimeError):
        if hasattr(obj.data, "use_auto_smooth"):  # Blender 4.0
            obj.data.use_auto_smooth = True
            obj.data.auto_smooth_angle = math.radians(40)


def add_sockets(obj, sp, slot):
    for sname, pos in sp["sockets"].get(slot, {}).items():
        e = bpy.data.objects.new(f"SOCKET_{sname}", None)
        e.empty_display_type = "ARROWS"
        e.empty_display_size = 10.0
        e.location = pos
        e.parent = obj
        bpy.context.collection.objects.link(e)


def make_palette(out_dir):
    img = bpy.data.images.new("T_FTB_Palette", PALETTE_W, PALETTE_H, alpha=True)
    px = [0.0] * (PALETTE_W * PALETTE_H * 4)

    def fill(cx, cy, rgb):
        for y in range(cy * CELL, (cy + 1) * CELL):
            for x in range(cx * CELL, (cx + 1) * CELL):
                i = ((PALETTE_H - 1 - y) * PALETTE_W + x) * 4
                px[i:i + 4] = [rgb[0], rgb[1], rgb[2], 1.0]
    for s, (p, sec) in enumerate(SPECIES_COLORS):
        fill(s, 0, hex_rgb(p))
        fill(s, 1, hex_rgb(sec))
    for k, h in SHARED.items():
        fill(list(SHARED).index(k), 2, hex_rgb(h))
    img.pixels = px
    img.filepath_raw = os.path.join(out_dir, "T_FTB_Palette.png")
    img.file_format = "PNG"
    img.save()


def parse_args():
    argv = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else sys.argv[1:]
    ap = argparse.ArgumentParser(description="FTB Species-Teile erzeugen")
    ap.add_argument("--out", default="./ftb_out")
    ap.add_argument("--species", default="", help="Kommagetrennt, leer = alle 8")
    ap.add_argument("--lods", action="store_true", help="LOD1 50 %% / LOD2 20 %% als eigene Meshes")
    ap.add_argument("--dry-run", action="store_true", help="nur Layout-JSON ausgeben (ohne bpy)")
    return ap.parse_args(argv)


def main():
    args = parse_args()
    if args.dry_run or bpy is None:
        print(json.dumps(layout_table(), indent=1))
        if bpy is None and not args.dry_run:
            print("Kein bpy gefunden: bitte mit 'blender -b -P gen_species_parts.py -- ...' starten.")
        return
    os.makedirs(args.out, exist_ok=True)
    setup_scene()
    mat = bpy.data.materials.new("M_FTB_Creature")  # Platzhalter; echtes Material in UEFN (materials_spec.md)
    wanted = [s for s in args.species.split(",") if s] or list(SPECIES)
    report, ok = [], True
    for species in wanted:
        sp = SPECIES[species]
        coll = bpy.data.collections.new(species)
        bpy.context.scene.collection.children.link(coll)
        bpy.context.view_layer.active_layer_collection = bpy.context.view_layer.layer_collection.children[species]
        for slot in SLOTS:
            obj, tris = build_part(species, sp, slot, mat, args.lods)
            within = tris <= BUDGET[slot]
            ok &= within
            report.append({"name": obj.name, "slot": slot, "tris": tris, "budget": BUDGET[slot], "ok": within})
            print(f"{obj.name:32s} {tris:5d} Tris / {BUDGET[slot]} {'OK' if within else 'ZU VIEL'}")
    make_palette(args.out)
    with open(os.path.join(args.out, "parts_layout.json"), "w", encoding="utf-8") as f:
        json.dump({"unit": "cm", "forward_blender": "-Y", "parts": report, "layout": layout_table()}, f, indent=1)
    bpy.ops.wm.save_as_mainfile(filepath=os.path.abspath(os.path.join(args.out, "ftb_species_parts.blend")))
    total = sum(r["tris"] for r in report)
    print(f"FERTIG: {len(report)} Teile, {total} Tris gesamt (Plan ≈ 38.400), Budget {'OK' if ok else 'VERLETZT'}")


if __name__ == "__main__":
    main()
