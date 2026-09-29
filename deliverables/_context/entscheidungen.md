# Entscheidungen (nur anhängen)

Format: `| ID | Datum | Entscheidung | Grund / Messwert | Quelle |`
Quellen-Kürzel: **Bericht** = `reports/Brainrot Map Marktanalyse UEFN.md` · **RT** = `research/red_team_review.md` · **Feas** = `research/uefn_feasibility.md` · **GDD** = `docs/GDD_Fuse_and_Fight.md` · **LP** = `docs/Launch_Plan_Phase_H.md` · **Plan** = `docs/BAUPLAN_Claude_Code.md` · **Luis** = Vorgabe von Luis.

## A. Recherche-Ergebnisse (Stand 29.09.2026, alle Zahlen aus Such-Snippets, nicht gemessen)
| ID | Datum | Entscheidung / Befund | Grund / Messwert | Quelle |
|---|---|---|---|---|
| E-001 | 2026-09-29 | Markt: Brainrot-Hits auf Roblox fielen von ≈ 25,8 Mio. CCU (2025) auf < 100.000 bei Neustarts 2026; Kernschleife der Hits = Sammeln + Einkommen + aktives Verb | Snippets (TRACKER-RELAYED) | Bericht A1–A3 |
| E-002 | 2026-09-29 | Fortnite: STEAL THE BRAINROT Allzeit-Peak 1.087.974 (11.01.2026), D1 ≈ 9,87 %; FIGHT THE BRAINROT 211K (Aug. 2026); GROW THE BRAINROT 53.218 (23.09.2026) | Snippets | Bericht, Datenqualität |
| E-003 | 2026-09-29 | Fusion ist auf Roblox und Fortnite bereits **Nebenmechanik** (Fuse Machine), nicht Hauptverb → reine „Fuse“-Idee zu schwach | Red-Team-Befund | RT §0–1 |
| E-004 | 2026-09-29 | Matrix nach Red Team: Fuse 5,65 vs. Fish/Fight/Steal-Hybrid ≈ 6,15 → Empfehlung „anpassen“ zu **Fuse & Fight** | RT §2–5 | RT |
| E-005 | 2026-09-29 | Technik: Persistenz per `weak_map(player, t)`, max. 2 Player-weak_maps (VERIFIED), ≈ 128 KB je Map (LIKELY); Schema nur durch Felder mit Default erweiterbar (VERIFIED) | Doku-Snippets | Feas §1 |
| E-006 | 2026-09-29 | Technik: Speichergrenze 100.000 Einheiten, nur zur Editierzeit messbar (VERIFIED); Unreal MCP in UEFN v42 (VERIFIED); Timing Insights v42 (VERIFIED) | Doku-Snippets | Feas §6, §10 |
| E-007 | 2026-09-29 | Technik: Skelett-Animation auf zur Laufzeit erzeugten Entities spielt laut Forum nicht → **keine Skelett-Animation**; statische Teile + Material-WPO + Verse-`MoveTo` | Forum (LIKELY) | Feas §3, RT §4, GDD 11 |
| E-008 | 2026-09-29 | IP: Tung Tung Tung Sahur / Ballerina Cappuccina sind lizenzierte Epic-Skins, Marken angemeldet → **nur eigene Figuren und Namen**, Sperrliste | Bericht E4 | Bericht, GDD Anhang A |
| E-009 | 2026-09-29 | Regeln: Glücksrad-Verkauf verboten (20.01.2026), bezahlter Zufall problematisch → **IIT nur deterministisch** | Regel-Snippets | Bericht E3, GDD 9 |
| E-010 | 2026-09-29 | IIT-Umsatz 100 % bis 31.01.2027, danach 50 % → Planung mit 50 % | fortnite.com-Snippet | Bericht, GDD 9 |
| E-011 | 2026-09-29 | Cinematic „Instigator Only“ nicht parallel für mehrere Spieler (Forum) → Reveals als UI pro Spieler | Forum (LIKELY) | Feas §4 |
| E-012 | 2026-09-29 | Coqui XTTS-v2 nicht kommerziell → **Kokoro-82M (Apache-2.0)** für Namens-Silben | Lizenz-Snippets | Feas §10, GDD 12 |

## B. Vorgaben und Antworten von Luis
| ID | Datum | Entscheidung | Grund | Quelle |
|---|---|---|---|---|
| E-020 | 2026-09-29 | Richtung **„Fuse & Fight“** freigegeben | Red-Team-Empfehlung | Luis, GDD Kopf |
| E-021 | 2026-09-29 | Creator-Name/Code „haske“; Luis ist 18+ | Voraussetzung IIT | Luis, LP 8.6 |
| E-022 | 2026-09-29 | Claude-Pro-Kontingent ist der Engpass → token-sparsamer Plan, große Arbeitsblöcke, `_context/`-Protokoll | – | Luis |
| E-023 | 2026-09-29 | Luis: 40 h/Woche, Blender-Kenntnisse ≈ keine → **alle Assets per Blender-Python headless** | – | Luis |
| E-024 | 2026-09-29 | Testen: kein Dauer-Mikrotesten; Claude Code testet nur am Meilenstein-Ende; Menschen-Tests: **3 Tester an 2 Terminen** (≈ Woche 5 Kernschleife, ≈ Woche 9 RC) | – | Luis |
| E-025 | 2026-09-29 | „Meisterwerk zuerst, Risiko akzeptieren“ | – | Luis |
| E-026 | 2026-09-29 | Zeitraum ≈ 9,5 Wochen: Bau ab **Do 01.10.2026**, Feature-Freeze **So 15.11.**, Einreichung **Do 03.12.**, Publish **Do 10.12.2026** | ersetzt GDD „Einreichung ≤ 05.12.“ (Puffer bis 07.12. laut LP 4.2) | Luis, LP 4.1 |
| E-027 | 2026-09-29 | Live-Ops im Build vorproduziert: 8 Event-Wochen zeitgesteuert (10.12.2026–03.02.2027) | – | Luis, GDD 7.4 |
| E-028 | 2026-09-29 | IIT von Anfang an, nur faire deterministische Angebote | – | Luis, GDD 9 |
| E-029 | 2026-09-29 | Keine gekauften Assets, kein externes Backend, nur kostenlose Werkzeuge mit geklärter Lizenz | – | Luis |

## C. Design-Entscheidungen (GDD v1.0)
| ID | Datum | Entscheidung | Grund | Quelle |
|---|---|---|---|---|
| E-040 | 2026-09-29 | Titel **FUSE THE BRAINROT**, Ersatz „FUSE THE BRAINROTS!“ falls exakt belegt | Klon-Abstand zu „Fight The Brainrot“ | GDD 1.1 |
| E-041 | 2026-09-29 | 8 Arten × 3 Teile = 24 Meshes, 512 Kombinationen; Seltenheit nur über 7 Material-Instanzen | Speicher/Umfang | GDD 4.1 |
| E-042 | 2026-09-29 | 40 Basis-, 40 Event-, 8 Geheim-Kreaturen; 1.000 Hybrid-Namen, 0 Sperrlisten-Treffer | `catalog_gen.py` | GDD 4, `data/` |
| E-043 | 2026-09-29 | Zweites Verb: Solo-Wellen am Plot + Koop-Server-Boss alle 7 min (75 s); Spielerverb **Hype-Takt** (Feuer-Taste im Takt), Fallbacks SMASH-Knopf → Hype-Meter | RT §4 | GDD 2.4 |
| E-044 | 2026-09-29 | Währungen Münzen/Kerne/Event-Tokens, **keine Premium-Währung** | IIT-Fairness | GDD 5.1 |
| E-045 | 2026-09-29 | Wirtschaftsparameter GDD 5.8; Simulation: erste Rebirth Median 2:25 h, erster Boss 10:20, erste Fusion 3:25 (Bot) | `economy_sim.py --runs 10` | GDD 5.9 |
| E-046 | 2026-09-29 | Kein Stehlen, kein Handel, keine Verluste | Markt, Spielerschutz | GDD 6, 8 |
| E-047 | 2026-09-29 | 14 IIT-Angebote 100–900 V-Bucks (Tabelle GDD 9 maßgeblich; Kernentscheidung nennt 13 ohne Münz-Rausch) | Regeln 4.4.x | GDD 9 |
| E-048 | 2026-09-29 | Max. 16 Spieler, 16 Plots im Ring r = 12.500 cm, Hub in der Mitte | Koop-Boss | GDD 11 |
| E-049 | 2026-09-29 | Save-Schema v1 mit `Version`, eine Root-Klasse, zweite weak_map als Reserve | Feas §1 | GDD 16.3 |
| E-050 | 2026-09-29 | Kill-Kriterien Woche 1 / Woche 2 / Test 1 / Test 2 / Discover-Test | RT §4 | GDD 14.1 |

## D. Plan-Entscheidungen (Bauplan Phase G)
| ID | Datum | Entscheidung | Grund | Quelle |
|---|---|---|---|---|
| E-060 | 2026-09-29 | Meilensteine M0–M8 (M0 Spike bis Di 06.10., Test 1 Sa 31.10., Save-Freeze Di 10.11., Feature-Freeze So 15.11., Test 2 Sa 28.11., Einreichung Do 03.12.) | Luis-Termine | Plan §1 |
| E-061 | 2026-09-29 | P-01: Blindtest 16.–22.11. aus LP entfällt; private Version ab 23.11. für freies Spielen der Tester | E-024 | Plan §1 |
| E-062 | 2026-09-29 | P-02: Echte 16-Spieler-Last erst nach Launch; vorher 16 **Bot-Plots** als Last-Simulation | kein Tester-Pool | Plan §2.3 |
| E-063 | 2026-09-29 | P-03: Devices per Verse-Tag + Position finden; Fallback `@editable`-Arrays | wenig Handarbeit | Plan §4.7 |
| E-064 | 2026-09-29 | P-04: WPO-Bob einheitlich 6 cm / 0,8 Hz (MI je Seltenheit, nicht je Art) | Material-Anzahl | Plan §5.4 |
| E-065 | 2026-09-29 | P-05 (vorläufig bis G0): Verse-UI als Standard, UMG nur wenn MCP Widgets bauen kann | automatisierbar | Plan §5.8 |
| E-066 | 2026-09-29 | P-06: „2 s halten“-Gesten durch Bestätigungsdialog ersetzt (Halten in Verse-UI unbelegt) | UNVERIFIED | Plan M1-10 |
| E-067 | 2026-09-29 | P-07: Kamera-Shake als UI-Wackeln | Kamera pro Spieler unbelegt | Plan M6-04 |
| E-068 | 2026-09-29 | Anzeige-Technik wird im Spike entschieden: A Pool (GDD) / B Scene-Graph-Tausch / C SpawnProp; Fallback-Leiter F1–F6 mit Zahlen | Kernrisiko R3 | Plan M0.3 |
| E-069 | 2026-09-29 | Spawn: 16 Spawner auf den Plots, Verse teleportiert zum zugewiesenen Plot; Teleports per `TeleportTo` statt Teleporter-Devices | weniger Devices | Plan Anhang D |
| E-070 | 2026-09-29 | Daten → Verse per `tools/gen_verse_tables.py` in Marker-Bereiche; Golden Values aus Python als Autotest | keine Handarbeit, Kontingent | Plan §4.1 |
| E-071 | 2026-09-29 | Namensschema `SM_FTB_<Art>_<Head\|Body\|Accessory>` (wie `gen_species_parts.py`); Blender 1 BU = 1 cm, FBX-Import Skalierung 1,0; Blick −Y in Blender → Soll +X in UE, Korrektur nur über `export_fbx.py --rotate-z` | Konsistenz | Plan §5.2 |
| E-072 | 2026-09-29 | Musik primär aus UEFN-Bibliothek (kein eigener Speicher), eigene LMMS-Musik optional | Speicher, Aufwand | Plan §5.6 |
| E-073 | 2026-09-29 | Test-Report per Geheim-Code `TESTREPORT` für private Versionen (dort keine Logs lesbar) | Messbarkeit Test 1/2 | Plan M3-08 |
| E-074 | 2026-09-29 | Git: `main` + `dev`, kein Feature-Branching (Binärdateien), LFS für uasset/umap/fbx/wav/png; UEFN-Revision-Control aus | Solo-Projekt | Plan §6 |

## E. Ergebnisse ab Bau-Start
<!-- Claude Code hängt hier an: G0-Ergebnis, Digest-Befunde, Markt-Check, Test-1-Entscheidung usw. -->
