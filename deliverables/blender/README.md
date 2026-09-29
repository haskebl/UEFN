# Blender-Pipeline: Kreatur-Teile (FUSE THE BRAINROT)

> REFERENZ — UNGEPRÜFT bis in UEFN kompiliert. Die Python-Syntax wurde mit `python3 -m py_compile` geprüft und `--dry-run` wurde ohne Blender ausgeführt. **Blender selbst lief hier nicht.**

## Dateien

| Datei | Zweck |
|---|---|
| `gen_species_parts.py` | Baut 8 Arten × 3 Teile (`SM_FTB_<Art>_Head/Body/Accessory`) aus Primitiven und Modifiern. Dazu kommen Paletten-UVs, Vertex-Farben, Sockel-Empties, eine Tris-Budgetprüfung, optionale LODs, `T_FTB_Palette.png` und `parts_layout.json`. |
| `export_fbx.py` | Exportiert je Mesh eine FBX mit UE-freundlichen Einstellungen und schreibt `manifest.json` (Name, Tris, Bounds, Sockel). |
| `materials_spec.md` | Master-Material, Seltenheits- und Event-Instanzen, Texturauflösungen, Import-Einstellungen für UEFN. |

## Blender installieren

- Blender **4.x** (getestet ist nur die Syntax; die API-Stellen sind für 4.0–4.2 geschrieben), kostenlos von blender.org.
- **Lizenz:** Blender selbst steht unter der GPL. Mit Blender **erzeugte Assets** (Meshes, FBX, PNG) sind **nicht** GPL-gebunden und gehören dem Ersteller. Das gilt auch für diese Skripte als Werkzeug. Die Ausgaben dürfen also ohne Einschränkung in UEFN veröffentlicht werden.
- Keine Add-ons nötig. FBX-Export (`io_scene_fbx`) ist standardmäßig aktiv.

## Ausführen (headless)

```bash
# 1) Teile erzeugen (alle 8 Arten). --lods NUR, wenn UEFN keine LOD-Reduktion anbietet
#    (Plan M0-03 Fähigkeit C6 = nein); sonst ohne --lods.
blender -b -P gen_species_parts.py -- --out ./ftb_out [--lods]

# nur zwei Arten zum Testen
blender -b -P gen_species_parts.py -- --out ./ftb_out --species Waffelino,Frogurko

# 2) FBX-Export aus der erzeugten .blend (LOD-Dateien landen getrennt in ./ftb_out/fbx_lod)
blender -b ./ftb_out/ftb_species_parts.blend -P export_fbx.py -- --out ./ftb_out/fbx

# Ohne Blender: Sockel-/Offset-Tabelle prüfen (für ftb_creature_pool.verse)
python3 gen_species_parts.py --dry-run
```

## Erwartete Ausgaben

```
ftb_out/
  ftb_species_parts.blend        # alle Teile, eine Collection je Art
  T_FTB_Palette.png              # 256×64, 16×4 Farbzellen
  parts_layout.json              # Tris je Teil + Sockel (Blender-cm und Verse-lokal)
  fbx/
    SM_FTB_Waffelino_Head.fbx … SM_FTB_Bzzkoffro_Accessory.fbx   (24 Dateien)
    manifest.json                                                  (listet auch LODs, Pfad relativ, is_lod)
  fbx_lod/
    SM_FTB_*_LOD1.fbx / _LOD2.fbx                                  (nur mit --lods, 48 Dateien; NICHT als eigene Assets importieren,
                                                                     sondern im Static-Mesh-Editor als LOD 1/2 zuweisen)
```

Die Konsole zeigt pro Teil `Tris / Budget OK|ZU VIEL` und am Ende die Gesamtsumme. Der Plan liegt bei ≈ 38.400 Tris für LOD0.

Namensschema: Die Aufgabe verlangt `SM_FTB_<Art>_<Slot>`. Das GDD (§11) nennt `SM_H01_Waffelino` usw. Falls Verse-Asset-Pfade schon so heißen, einfach die Präfixe mappen: `Head` = H, `Body` = K, `Accessory` = A, die Art-ID zweistellig.

## Konventionen

| Thema | Festlegung |
|---|---|
| Einheit | 1 BU = 1 cm (`scale_length = 0.01`, `length_unit = CENTIMETERS`). Alle Maße im `SPECIES`-Dict sind cm. |
| FBX-Skalierung | `apply_unit_scale=True`, `apply_scale_options='FBX_SCALE_UNITS'`, `global_scale=1.0`, Import in UEFN mit 1.0 |
| Achsen | Modelliert mit Blick nach **−Y**, oben **+Z**. Export `axis_forward='-Z'`, `axis_up='Y'` (Blender-Standard) und UEFN „Convert Scene“. **Die Blickrichtung in UEFN ist UNVERIFIED.** Falls falsch: `export_fbx.py --rotate-z 90` (bzw. −90/180). |
| Glättung | Smooth by Angle 40°, Export `mesh_smooth_type='FACE'`, keine Leaf Bones, Triangulierung beim Export |
| Pivot | Körper: unten Mitte (Pad-Oberfläche). Kopf: Hals-Unterseite. Accessoire: sein Montagepunkt. |
| Sockel | Empties `SOCKET_Head`, `SOCKET_Back`, `SOCKET_Neck` am Körper sowie `SOCKET_HeadTop` und `SOCKET_Face` am Kopf. UE macht daraus Static-Mesh-Sockel (LIKELY). |
| Anschluss-Logik | Kopf sitzt auf `Body.SOCKET_Head`. Das Accessoire sitzt je nach Art auf Back, Neck, HeadTop (+ Kopf-Offset) oder Face (+ Kopf-Offset). Dieselben Zahlen stehen in `ftb_creature_pool.verse` (Verse-lokal: X = −Y_bl, Y = −X_bl, Z = Z_bl). |
| Material | Ein Slot, `M_FTB_Creature`. Die Farbe kommt aus der Paletten-UV plus Vertex-Farbe; Alpha 0 = Augen. |
| Budget | Kopf ≤ 1.500, Körper ≤ 2.500, Accessoire ≤ 800 Tris. Bei Überschreitung wird zuerst Bevel entfernt, dann automatisch dezimiert (Warnung im Log). |

## Validierungs-Checkliste

1. [ ] `blender -b -P gen_species_parts.py -- --out ./ftb_out` läuft ohne Traceback, es gibt 24 Zeilen mit „OK“.
2. [ ] Die Gesamt-Tris (LOD0) liegen bei ≤ 38.400. Kein Teil braucht Decimate, sonst die Primitiv-Segmente im Dict senken.
3. [ ] Die `.blend` öffnen: Jede Art steht aufrecht, der Kopf sitzt auf dem Körper, das Accessoire an der richtigen Stelle. Zum Prüfen die drei Teile einer Art an die Sockel schieben.
4. [ ] Die Silhouette ist aus 30 m erkennbar (Kamera 3.000 BU entfernt, GDD §11). Maus-Ohren, Glas, Hydrant, Nudelarme, Kugel, Rakete, Wolke und Koffer müssen unterscheidbar sein.
5. [ ] Im Material-Preview mit `T_FTB_Palette` stimmen die Farben (Primär/Sekundär laut GDD §11), die Augen sind weiß/schwarz.
6. [ ] `python3 gen_species_parts.py --dry-run` stimmt mit den Tabellen in `verse_reference/ftb_creature_pool.verse` überein (nach Änderungen die Verse-Tabelle aus `parts_layout.json` neu erzeugen).
7. [ ] `export_fbx.py` schreibt 24 FBX + `manifest.json` in `fbx/` (LODs nur in `fbx_lod/`). Die Sockel heißen exakt `SOCKET_*` (ohne `.001`).
8. [ ] UEFN-Import (Skalierung 1.0): Die Körperhöhe liegt bei ≈ 65–100 cm, die gesamte Kreatur bei ≈ 1,6–2,1 m (GDD: 1,8–2,4 m, Verse skaliert im Pool mit `DisplayScale = 1.15`, Bauplan M1-07). Kein ×100-Fehler.
9. [ ] Blickrichtung in UEFN notieren. Weicht sie ab, **nur** mit `--rotate-z` neu exportieren (Bauplan §5.2; Pad-Marker werden nie gedreht).
10. [ ] Static-Mesh-Editor: Die Sockel sind sichtbar, der Pivot liegt am erwarteten Punkt, es gibt keine Smoothing-Group-Warnung.
11. [ ] Launch Memory Calculation vor und nach dem Import vergleichen (Kill-Kriterium W1: Hochrechnung ≤ 70 %).
