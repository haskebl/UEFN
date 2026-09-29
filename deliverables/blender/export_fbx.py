#!/usr/bin/env python3
# =====================================================================
# REFERENZ — UNGEPRÜFT bis in UEFN kompiliert
# export_fbx.py  (FUSE THE BRAINROT)
#
# Batch-FBX-Export: eine .fbx je Mesh (SM_FTB_*), UE-freundliche Einstellungen,
# dazu manifest.json (Name, Tris, Bounds, Sockel, Datei).
#
# Aufruf:
#   blender -b ./ftb_out/ftb_species_parts.blend -P export_fbx.py -- --out ./ftb_out/fbx [--rotate-z 0] [--prefix SM_FTB_] [--lod-out <ordner>]
#
# LOD-Dateien (*_LOD1/_LOD2, nur falls gen_species_parts.py mit --lods lief) landen
# NICHT in --out, sondern in --lod-out (Standard: Geschwisterordner "<out>_lod",
# z. B. blender/out/fbx_lod). So importiert "ganzen Ordner blender/out/fbx ziehen"
# genau die 24 LOD0-Meshes und keine 48 LOD-Dateien als eigene Assets.
#
# Export-Einstellungen (bewusst, bitte nicht "optimieren" ohne Test in UEFN):
#   axis_forward = '-Z', axis_up = 'Y'   Blender-FBX-Standard; UEFN-Importer mit
#                                        "Convert Scene" rechnet Y-up -> Z-up um.
#   apply_unit_scale = True, apply_scale_options = 'FBX_SCALE_UNITS', global_scale = 1.0
#                                        Szene ist 1 BU = 1 cm -> FBX UnitScale = cm
#                                        -> UEFN-Import mit Skalierung 1.0.
#   bake_space_transform = False         (Achsen nicht in Mesh-Daten backen)
#   use_mesh_modifiers = True            (falls noch Modifier offen sind)
#   mesh_smooth_type = 'FACE'            Smoothing-Groups pro Fläche (UE warnt sonst
#                                        "No smoothing group information").
#   use_triangles = True                 Tri-Zahl im Manifest = Tri-Zahl in UEFN.
#   add_leaf_bones = False, object_types = {'MESH','EMPTY'}  (Empties = SOCKET_*)
#   path_mode = 'STRIP', embed_textures = False  (Palette separat importieren)
# Blickrichtung: Kreaturen schauen in Blender nach -Y. Wohin sie in UEFN
#   schauen, ist UNVERIFIED -> erster Import prüfen; falls falsch, mit
#   --rotate-z 90 / -90 / 180 exportieren (Rotation wird vor dem Export
#   angewendet, Pivot bleibt).
# =====================================================================

import sys
import os
import json
import math
import argparse

try:
    import bpy
    from mathutils import Matrix, Vector
except ImportError:
    bpy = None

FBX_SETTINGS = dict(
    use_selection=True,
    object_types={"MESH", "EMPTY"},
    use_mesh_modifiers=True,
    mesh_smooth_type="FACE",
    use_triangles=True,
    use_tspace=False,
    add_leaf_bones=False,
    axis_forward="-Z",
    axis_up="Y",
    apply_unit_scale=True,
    apply_scale_options="FBX_SCALE_UNITS",
    global_scale=1.0,
    bake_space_transform=False,
    path_mode="STRIP",
    embed_textures=False,
    use_custom_props=False,
)


def parse_args():
    argv = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else sys.argv[1:]
    ap = argparse.ArgumentParser(description="FTB FBX-Batch-Export")
    ap.add_argument("--out", default="./ftb_out/fbx")
    ap.add_argument("--prefix", default="SM_FTB_")
    ap.add_argument("--rotate-z", type=float, default=0.0, help="Grad, vor dem Export angewendet")
    ap.add_argument("--lod-out", default="", help="Zielordner fuer *_LOD1/_LOD2 (Standard: <out>_lod)")
    args = ap.parse_args(argv)
    if not args.lod_out:
        args.lod_out = os.path.normpath(args.out).rstrip("/\\") + "_lod"
    return args


def tri_count(obj):
    deps = bpy.context.evaluated_depsgraph_get()
    ev = obj.evaluated_get(deps)
    me = ev.to_mesh()
    me.calc_loop_triangles()
    n = len(me.loop_triangles)
    ev.to_mesh_clear()
    return n


def bounds_cm(obj):
    """Lokale AABB in cm (1 BU = 1 cm) + UE-Größe (X/Y/Z)."""
    xs = [v.co.x for v in obj.data.vertices]
    ys = [v.co.y for v in obj.data.vertices]
    zs = [v.co.z for v in obj.data.vertices]
    mn, mx = [min(xs), min(ys), min(zs)], [max(xs), max(ys), max(zs)]
    return {"min": [round(a, 2) for a in mn], "max": [round(a, 2) for a in mx],
            "size": [round(b - a, 2) for a, b in zip(mn, mx)]}


def deselect_all():
    for o in bpy.context.selected_objects:
        o.select_set(False)


def main():
    args = parse_args()
    if bpy is None:
        print("Kein bpy: mit 'blender -b <datei.blend> -P export_fbx.py -- --out <ordner>' starten.")
        return
    os.makedirs(args.out, exist_ok=True)
    us = bpy.context.scene.unit_settings
    if abs(us.scale_length - 0.01) > 1e-6:
        print(f"[WARN] scale_length = {us.scale_length} (erwartet 0.01 für 1 BU = 1 cm)")
    meshes = sorted((o for o in bpy.data.objects if o.type == "MESH" and o.name.startswith(args.prefix)),
                    key=lambda o: o.name)
    manifest = {"unit": "cm", "fbx_settings": {k: (sorted(v) if isinstance(v, set) else v) for k, v in FBX_SETTINGS.items()},
                "rotate_z_deg": args.rotate_z, "meshes": []}
    # Sockel-Namen sind pro Teil gleich (SOCKET_Head …); Blender hängt ".001" an.
    # Deshalb alle Empties zuerst temporär umbenennen und je Export exakt benennen.
    base_names = {}
    for i, e in enumerate(o for o in bpy.data.objects if o.type == "EMPTY" and o.name.startswith("SOCKET_")):
        base_names[e] = e.name.split(".")[0]
        e.name = f"_ftb_sock_{i}"
    for obj in meshes:
        # Pivot = Objekt-Ursprung; für den Export an den Weltursprung setzen
        saved = obj.matrix_world.copy()
        obj.matrix_world = Matrix.Rotation(math.radians(args.rotate_z), 4, "Z")
        deselect_all()
        obj.select_set(True)
        sockets = [c for c in obj.children if c in base_names]
        temp_names = {c: c.name for c in sockets}
        for c in sockets:
            c.name = base_names[c]      # exakt "SOCKET_<Name>" -> UE-Sockelname "<Name>"
            c.select_set(True)
        bpy.context.view_layer.objects.active = obj
        bpy.context.view_layer.update()
        is_lod = "_LOD" in obj.name
        target = args.lod_out if is_lod else args.out
        os.makedirs(target, exist_ok=True)
        path = os.path.join(target, obj.name + ".fbx")
        bpy.ops.export_scene.fbx(filepath=os.path.abspath(path), **FBX_SETTINGS)
        manifest["meshes"].append({
            "name": obj.name,
            "file": os.path.relpath(path, args.out).replace("\\", "/"),
            "tris": tri_count(obj),
            "bounds_cm": bounds_cm(obj),
            "sockets_cm": {c.name: [round(x, 2) for x in c.location] for c in sockets},
            "is_lod": is_lod,
        })
        obj.matrix_world = saved
        for c in sockets:
            c.name = temp_names[c]
        print(f"exportiert: {path}")
    for e, base in base_names.items():   # .blend nicht verändert zurücklassen (wird nicht gespeichert)
        e.name = base
    with open(os.path.join(args.out, "manifest.json"), "w", encoding="utf-8") as f:
        json.dump(manifest, f, indent=1)
    total = sum(m["tris"] for m in manifest["meshes"] if not m["is_lod"])
    print(f"FERTIG: {len(manifest['meshes'])} FBX, LOD0-Tris gesamt {total}, manifest.json geschrieben")


if __name__ == "__main__":
    main()
