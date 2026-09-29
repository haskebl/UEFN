# Material-Spezifikation Kreaturen (FUSE THE BRAINROT)

> REFERENZ — UNGEPRÜFT bis in UEFN kompiliert. Wird von Claude Code im UEFN-Material-Editor gebaut. Quelle der Wahrheit: `GDD_Fuse_and_Fight.md` §4.1, §4.2, §11.

## 1. Überblick

| Asset | Typ | Zweck |
|---|---|---|
| `M_FTB_Creature` | Master-Material (Opaque, Default Lit) | alle 24 Kreatur-Teile, 7 Seltenheiten, Event-Formen |
| `M_FTB_Creature_Crystal` | Kopie mit Blend Mode **Masked** + Dither | nur für Seltenheit 3 „Kristall“ (halbtransparent per Dither statt Translucent, weil billiger und sortierfrei) |
| `MI_FTB_Rarity_0` … `MI_FTB_Rarity_6` | Material-Instanzen | Klassik, Neon, Gold, Kristall, Königlich, Mythisch, Kosmisch |
| `MI_FTB_Event_Frosti/Funki/Schleimi/Kosmi/Festi/Gruender` | Material-Instanzen | Event-Formen (nur Parameter, keine neuen Meshes) |
| `T_FTB_Palette` | Textur 256×64, von `gen_species_parts.py` erzeugt | Farbfelder (16×4 Zellen à 16 px) |
| `T_FTB_Noise` | Textur 512×512, Graustufen-Rauschen | Kristall-Glitzer, Kosmos-Sternenfeld |

Der Tausch der Instanz zur Laufzeit läuft über `creative_prop.SetMaterial` (LIKELY, GDD §4.2). Der Fallback ist ein Aura-Ring am Pad; die Teile behalten dann `MI_FTB_Rarity_0`.

## 2. Eingänge aus dem Mesh

| Kanal | Inhalt | Verwendung |
|---|---|---|
| UV0 | Paletten-UV (jede Fläche liegt in der inneren Hälfte ihrer Farbzelle) | `T_FTB_Palette` → Basisfarbe |
| Vertex Color RGB | dieselbe Palettenfarbe | Fallback, falls Texturimport scheitert (`UseVertexColor` = 1) |
| Vertex Color A | 1 = Körperfarbe, 0 = Augen (Weiß/Schwarz) | `RarityMask`: Seltenheits-Effekte wirken nur, wo A = 1. Augen bleiben immer lesbar. |

## 3. Parameter von `M_FTB_Creature`

| Parameter | Typ | Default | Wirkung |
|---|---|---|---|
| `UseVertexColor` | Scalar 0/1 | 0 | 0 = Palette-Textur, 1 = Vertex-Farbe |
| `TintColor` | Vector | (1,1,1) | multipliziert die Basisfarbe (nur wo Maske = 1) |
| `TintStrength` | Scalar | 0 | 0 = Originalfarbe, 1 = voll auf `TintColor` (Gold, Event) |
| `Metallic` | Scalar | 0 | |
| `Roughness` | Scalar | 0.55 | |
| `FresnelColor` | Vector | (0,0,0) | Kantenleuchten |
| `FresnelExponent` | Scalar | 3 | |
| `FresnelIntensity` | Scalar | 0 | |
| `EmissiveBoost` | Scalar | 0 | Emissive = Basisfarbe × Boost (Neon) |
| `NoiseSparkle` | Scalar | 0 | Glitzer aus `T_FTB_Noise` (Kristall, Kosmos) |
| `StarfieldPanSpeed` | Scalar | 0 | Kosmos: Noise im Screen-Space verschieben |
| `StarfieldColorA` / `B` | Vector | `#00E5FF` / `#FF3DF2` | Verlauf Kosmos |
| `RainbowShimmer` | Scalar 0/1 | 0 | Regenbogen-Hybrid (GDD §4.8), per MI oder MID |
| `BobAmplitude` | Scalar (cm) | 4 | WPO-Idle: Sinus auf Z |
| `BobFrequency` | Scalar (Hz) | 0.8 | |
| `SquashAmount` | Scalar | 0.05 | WPO: Z-Stauchung synchron zum Bob |
| `DitherOpacity` | Scalar | 1 | nur Crystal-Variante (0.6) |

**WPO-Idle (LIKELY in UEFN, GDD §11):** `Offset.Z = BobAmplitude * sin(2π · BobFrequency · Time + Phase)`. Die Phase stammt aus der **Objekt-Position** (Object Position node, gerastert auf 500 cm: `floor(ObjPos / 500)` → Hash). Damit laufen Kopf, Körper und Accessoire derselben Kreatur synchron, weil sie auf demselben Pad stehen. Die Squash-Komponente skaliert die lokale Z-Höhe relativ zum Pad-Boden. Die Art-spezifischen Animationen aus GDD §4.5 („Frosch-Sprung“, „Summ-Zittern 12 Hz“ …) werden über `BobAmplitude`/`BobFrequency` pro Art angenähert; mehr ist ohne Rigging nicht geplant.
**Fallback:** WPO aus, Verse-`MoveTo`-Bob nur auf dem eigenen und dem angesehenen Plot.

## 4. Seltenheits-Instanzen (GDD §4.2)

| MI | Seltenheit | Tint / Strength | Metallic | Roughness | Fresnel (Farbe, Intensität) | Emissive | Sparkle | Sonstiges |
|---|---|---|---|---|---|---|---|---|
| `MI_FTB_Rarity_0` Klassik | Gewöhnlich `#B8C2CC` | – / 0 | 0 | 0.55 | – / 0 | 0 | 0 | mattes Plastik |
| `MI_FTB_Rarity_1` Neon | Ungewöhnlich `#5BD45B` | – / 0 | 0 | 0.4 | `#5BD45B` / 0.4 | 0.15 | 0 | Emissive-Kanten |
| `MI_FTB_Rarity_2` Gold | Selten `#3AA0FF` | `#FFC93C` / 0.7 | 1.0 | 0.25 | `#FFF1B0` / 0.2 | 0 | 0 | Gold-Metallic |
| `MI_FTB_Rarity_3` Kristall | Episch `#B056FF` | `#D9B8FF` / 0.4 | 0.2 | 0.1 | `#B056FF` / 0.8 | 0.1 | 0.5 | Parent `M_FTB_Creature_Crystal`, `DitherOpacity` 0.6 |
| `MI_FTB_Rarity_4` Königlich | Legendär `#FFB319` | `#FFB319` / 0.6 | 1.0 | 0.2 | `#FFE08A` / 0.5 | 0.1 | 0.2 | + Niagara-Krone am Pad (nicht im Material) |
| `MI_FTB_Rarity_5` Mythisch | Mythisch `#FF3D6E` | `#FF3D6E` / 0.35 | 0.3 | 0.3 | `#FF3D6E` / 1.0 | 0.3 | 0.3 | + Aura/Partikelschweif (Niagara) |
| `MI_FTB_Rarity_6` Kosmisch | Geheim | `#0B0B14` / 0.85 | 0.0 | 0.3 | `#00E5FF` / 1.0 | 0.6 | 1.0 | `StarfieldPanSpeed` 0.05, Halo per Niagara |

Farbenblind-Regel (GDD §8): Die Seltenheit ist zusätzlich immer als Symbol und Text im UI sichtbar. Das Material allein ist nie die einzige Information.

## 5. Event-Instanzen (GDD §7.4)

| MI | Woche | Tint | Besonderheit |
|---|---|---|---|
| `MI_FTB_Event_Gruender` | W1 | `#FFD23F` / 0.3 | goldene Banderole per Fresnel |
| `MI_FTB_Event_Frosti` | W2 | `#BFE9FF` / 0.5 | Sparkle 0.6, Roughness 0.15 |
| `MI_FTB_Event_Funki` | W4 | `#FF9F1C` / 0.3 | Emissive 0.3, Sparkle 0.8 |
| `MI_FTB_Event_Schleimi` | W5 | `#7CFF4F` / 0.45 | Roughness 0.05, Bob-Amplitude ×1,5 |
| `MI_FTB_Event_Kosmi` | W7 | wie Rarity_6, aber `StarfieldColorA` `#7C4DFF` | |
| `MI_FTB_Event_Festi` | W8 | – | `RainbowShimmer` 1 |

## 6. Texturauflösungen und Import

| Textur | Auflösung | Kompression | sRGB | Mips | Hinweis |
|---|---|---|---|---|---|
| `T_FTB_Palette` | 256 × 64 | Default (BC1/DXT1) oder **UserInterface2D/VectorDisplacement**, falls Farbbluten sichtbar | ja | ja, Filter **Nearest** falls Kanten bluten | Zellen 16 px, UVs nutzen nur die innere Hälfte |
| `T_FTB_Noise` | 512 × 512 | Grayscale (G8) | nein | ja | Kristall, Kosmos |
| UI-Teil-Icons (24) | 256 × 256 | UserInterface2D | ja | nein | orthografische Blender-Renders (GDD §10.2) |
| Seltenheits-Symbole (7) | 128 × 128 | UserInterface2D | ja | nein | ● ◆ ▲ ★ ♛ ✦ ∞ als Textur |

Speicher: Diese Texturen sind zusammen deutlich unter 1 MB. Das Speicherrisiko liegt bei den ≈ 3.500 Props, nicht bei Texturen (GDD §4.1).

## 7. Mesh-Import in UEFN (Einstellungen)

- Import Uniform Scale **1.0** (die Szene ist in cm), **Convert Scene** an, Force Front X Axis aus.
- Normal Import Method: **Import Normals**; Generate Lightmap UVs aus (Lumen, keine Lightmaps).
- Nanite: **aus** für die Kreatur-Teile (klein, WPO-animiert). Für Bosse ebenfalls aus (GDD §4.1).
- LODs: entweder die Blender-LODs (`_LOD1`, `_LOD2`) als LOD-Stufen zuweisen oder UE-Auto-LOD mit 50 % / 20 %.
- Kollision: **keine** (Kreaturen sind Deko, Spieler laufen nicht dagegen) oder einfache Box. Das spart Physik-Kosten bei 2.304 Props.
- Sockel: Sie kommen aus den `SOCKET_*`-Empties. Verse nutzt sie **nicht**; sie dienen nur der visuellen Kontrolle im Static-Mesh-Editor.
