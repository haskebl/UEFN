# Budgets (harte Grenzen) und Messwerte

Grenzen = Plan §3 (dort die Messmethode). Claude Code füllt am Ende **jedes** Meilensteins die Spalte. Farbe: G = grün, Y = gelb (Maßnahme nennen), R = rot (Meilenstein nicht fertig).

| # | Budget | Grün | Gelb | Rot | M0 | M1 | M2 | M3 | M5 | M6 | M7 | M8 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| B1 | Speicher gesamt (Einheiten; M0 = Projektion) | ≤ 45.000 | ≤ 70.000 | > 70.000 | | | | | | | | |
| B2 | Tris LOD0 Kopf/Körper/Acc (max. gemessen) | 1.500/2.500/800 | +10 % | +20 % | | | | | | | | |
| B3 | Tris je Kreatur (max.) | ≤ 4.800 | ≤ 5.300 | > 5.800 | | | | | | | | |
| B4 | Gegner/Boss/Ei/Kapsel (max.) | 2.000/25.000/600/300 | +10 % | +20 % | | | | | | | | |
| B5 | LODs Kreatur-Teile | 3 Stufen | – | fehlend | | | | | | | | |
| B6 | größte Textur | ≤ 1024² | – | > 1024² | | | | | | | | |
| B7 | eigene Texturen | ≤ 80 | ≤ 120 | > 120 | | | | | | | | |
| B8 | Devices gesamt | ≤ 260 | ≤ 300 | > 300 | | | | | | | | |
| B9 | platzierte Actors gesamt | ≤ 3.500 | ≤ 5.000 | > 5.000 | | | | | | | | |
| B10 | Kreatur-Teil-Objekte (Variante) | A ≤ 2.304 / B,C ≤ 288 | – | A > 2.500 / B,C > 350 | | | | | | | | |
| B11 | sichtbare Gegner je Plot | ≤ 6 | – | > 6 | | | | | | | | |
| B12 | gleichzeitige Lunges je Plot | ≤ 3 | – | > 3 | | | | | | | | |
| B13 | Server-Frame Δp95 (16B) / Hänger > 300 ms pro min | ≤ +8 ms / ≤ 3 | ≤ +25 ms | > +25 ms / > 3 | | | | | | | | |
| B14 | Verse: Tausch / Plot-Aufbau / OnBegin | ≤ 2 ms / 15 ms / 5 s | ×2 | ×4 | | | | | | | | |
| B15 | Schleifenraten eingehalten (Checkliste §4.8) | ja | – | nein | | | | | | | | |
| B16 | Save Worst-Case ×2: FitsInPlayerMap / Schätzung | true / ≤ 16 KB | ≤ 32 KB | false | | | | | | | | |
| B17 | Niagara: Systeme / CPU-Sim / max. Partikel je Burst | ≤ 24 / ja / ≤ 64 | – | GPU oder > 128 | | | | | | | | |
| B18 | Audio WAV gesamt | ≤ 40 MB | ≤ 60 MB | > 60 MB | | | | | | | | |
| B19 | Audio-Player-Devices | ≤ 70 | ≤ 90 | > 90 | | | | | | | | |
| B20 | Session-Start bis spielbar | ≤ 3 min | ≤ 5 min | > 8 min | | | | | | | | |
| B21 | Client-FPS Luis-PC (Blick vom Hub) | ≥ 60 | ≥ 45 | < 45 | | | | | | | | |

## Messprotokoll (anhängen)
<!-- | Datum | MS | Messung | Wert | Bedingung (Variante, BotPlots, DisplayPerPlot, …) | Folge | -->
| Datum | MS | Messung | Wert | Bedingung | Folge |
|---|---|---|---|---|---|

## Spike-Messungen G0 (M0-11…M0-17)
| Variante | BotPlots | DisplayPerPlot | B1-Projektion | Δp95 ms | Hänger/min | Tausch ms | Plot-Aufbau ms | OnBegin s | Actors | Ergebnis |
|---|---|---|---|---|---|---|---|---|---|---|
| Baseline | 0 | – | | (p95 = … ms) | | | | | | – |
| A Pool | 16 | 6 | | | | | | | | |
| B Scene Graph | 16 | 6 | | | | | | | | |
| C SpawnProp | 16 | 6 | | | | | | | | |
| (Fallback F1…) | | | | | | | | | | |
