# Review: BAUPLAN_Claude_Code.md (G1.0) – Baubarkeit ohne Rückfrage

**Reviewer:** unabhängig (nicht Autor) · **Datum:** 29.09.2026 · **Geprüft:** `BAUPLAN_Claude_Code.md`, `CLAUDE.md`, `_context/*`, `verse_reference/*`, `blender/*`, `GDD_Fuse_and_Fight.md`, `data/*`, zusätzlich `Launch_Plan_Phase_H.md` (wird im Plan referenziert).
**Leitfrage je Aufgabe:** Könnte ein lokaler Claude Code mit Unreal MCP in UEFN diese Aufgabe ohne Rückfrage bauen? Wo fehlt ein Wert, ein Pfad, eine Einstellung, eine Abnahmegrenze oder eine Abhängigkeit?
**Der Plan wurde nicht geändert.** Alle Fixes sind Vorschläge.

Stichproben, die **ohne Befund** blieben: Wochentage/KW aller Termine; Epoch-Werte `1796860800` (Do 10.12.2026 00:00 UTC) und `1790812800` (01.10.2026); Device-Summe Anhang D (249); Namens-Index `(K−1)·100+(B−1)·10+(A−1)` passt zur Sortierung von `hybrid_names.csv` (1.000 Zeilen); Katalog 40/40/8; Boss-Konstanten 420/200/480/75 s in GDD 5.8, `ftb_types.verse` und Plan; Hype-Fenster ±150/±350 ms, +100 ms; Wellenformel; Stall 30/50 + 6 Pads = 56 Save-Slots; B-Budgets zwischen Plan §3 und `budgets.md`.

**Zählung:** Blocker 3 · Hoch 13 · Mittel 20 · Niedrig 12 · gesamt 48

---

## Blocker

### R-01 · Blocker · `economy_sim.py --params` kann keine Parameter überschreiben
- **Fundstelle:** `CLAUDE.md` §4 („Balance-Änderungen immer zuerst in `data/economy_sim.py --params …`“); Plan M0.3 F2 (`economy_sim.py --params pads_max=5`); M4-04 (`--runs 10 --params <änderung>`); `data/economy_sim.py` Z. 468–470.
- **Problem:** `--params` gibt nur die Parametertabelle als Markdown aus und beendet das Programm (im Scratch-Test mit `--runs 10 --params pads_max=5` geprüft: es kommt nur die Tabelle). Überschreiben ist nicht implementiert. Einen Parameter `pads_max` gibt es nicht; die Pad-Anzahl ergibt sich aus `pads_start` + `len(pad_costs)`. Jeder Lauf überschreibt außerdem die Referenzdatei `data/economy_sim_output.csv`. Der vorgeschriebene Balancing-Ablauf (M4-04) und die Fallback-Stufe F2 sind so nicht ausführbar. Nach der Regel „nur Parameter über `--params`“ darf Claude Code das Skript aber auch nicht ändern.
- **Fix:** Neue Aufgabe in M1-01 (+0,5 h): Claude Code erweitert `economy_sim.py` um `--set key=value` (mehrfach; Wert per `json.loads`, z. B. `--set pad_costs=[150,3000,60000]` für F2), dazu `--out <pfad>` (Standard `research/sim/<datum>.csv`, nie `data/economy_sim_output.csv`) und `--dump-json data/econ_params.json` (siehe R-31). In `CLAUDE.md` §4, M0.3 F2 und M4-04 `--params` durch `--set` ersetzen. F2 konkret: `--set pad_costs=[150,3000,60000]`.

### R-02 · Blocker · Test-Report ist in Test 1 nicht erreichbar
- **Fundstelle:** M3-08 („Code `TESTREPORT` im Code-Terminal (ab M5; bis dahin Menü-Knopf nur bei `DebugMode`)“); M3-11 („`DebugMode=false` aber Test-Report an“); `_context/playtests.md` Test 1 (14:40 „Test-Report-Screenshot (Code `TESTREPORT`)“); M5-03 (Code-Terminal entsteht erst in M5).
- **Problem:** Am Sa 31.10. gibt es kein Code-Terminal. Der Menü-Knopf erscheint nur bei `DebugMode=true`, der Test-1-Build läuft aber mit `DebugMode=false`. Einen Schalter „Test-Report an“ gibt es nicht. Damit lassen sich die Perfekt-Quote und die Zeitmarken (GDD 14.1, Kill-Kriterien Test 1) in der privaten Version nicht messen, weil dort keine Logs lesbar sind (E-073).
- **Fix:** In M0-10 Schritt 2 ein zusätzliches `@editable TestReportEnabled:logic=false` anlegen. M3-08 ändern: Der Menü-Knopf „TEST-REPORT“ im Menü-Terminal D05 erscheint bei `TestReportEnabled?`, unabhängig von `DebugMode`. M3-11 ändern: `DebugMode=false`, `TestReportEnabled=true`. Ab M5 zusätzlich der Code `TESTREPORT`, wenn `TestReportEnabled?`. M8-06 ändern: `TestReportEnabled=false`. `playtests.md` Test 1, Zeile 14:40: „Menü-Terminal → TEST-REPORT“ statt Code.

### R-03 · Blocker · Die Thumbnail-Mockups kommen zu spät für den Klick-Test (Kill-Kriterium Woche 2)
- **Fundstelle:** M1-12 (vorletzte Aufgabe in M1, Mi 07.–Di 13.10.); M1-Luis-Tabelle „Do 08.10. Thumbnail-Klick-Test … Ergebnis bis So 11.10.“; `offene_fragen.md` Q-MKT-4 (Frist So 11.10.); GDD 14.1 (Woche 2).
- **Problem:** Die Aufgaben laufen in ID-Reihenfolge und in Blöcken zu 2–4 Aufgaben. Dann entsteht M1-12 frühestens am Mo 12.10., also nach der Frist. Das Kill-Kriterium „Branding überarbeiten vor dem Asset-Großbau“ lässt sich so nicht rechtzeitig bewerten. Die Abhängigkeit ist nur M0-07, die Aufgabe könnte also früh laufen.
- **Fix:** M1-12 nach M0 verschieben, als **M0-07b** (direkt nach M0-07, spätestens Di 06.10.), und in `status.md` als Muss-Termin „bis Mi 07.10. 18:00“ vermerken. In M1 die Zeile löschen und den Verweis ändern.

---

## Hoch

### R-04 · Hoch · Shell-Syntax passt nicht zum Werkzeug von Claude Code unter Windows
- **Fundstelle:** `CLAUDE.md` §1/§6 (`sed`, `grep` und daneben `& "<blender.exe>" -b -P blender\<skript>.py`); M0-04 (`Get-ChildItem`, `Select-String`, `$env:`); §2.2 (Logpfad per `Get-ChildItem`); M0-07; §6.4 (`tools/backup.ps1`).
- **Problem:** Das Bash-Werkzeug von Claude Code läuft unter Windows in Git Bash. PowerShell-Syntax (`&`, `$env:…`, `Get-ChildItem`) schlägt dort fehl, und `sed`/`grep` gibt es in PowerShell nicht. Welche Shell gilt, legt der Plan nirgends fest. Jede erste Ausführung kostet dann Fehlversuche und Kontingent.
- **Fix:** In `CLAUDE.md` einen neuen §0 „Shell“ einfügen: „Befehle laufen in Git Bash. PowerShell nur als `powershell.exe -NoProfile -Command "<befehl>"`. Blender: `"/c/Program Files/Blender Foundation/Blender 4.2/blender.exe" -b -P blender/gen_species_parts.py -- --out blender/out --lods` (Pfad aus `mcp_werkzeuge.md`). Python: `python` (winget-Installation).“ Die PowerShell-Blöcke in M0-04 und §2.2 in `powershell.exe -Command '…'` einbetten.

### R-05 · Hoch · Für das Master-Material fehlt der Knotengraph; MCP-Materialbau ist ungeprüft
- **Fundstelle:** M0-08 Schritt 3 („sonst Klickliste … max. 15 Knoten; Liste in `materials_spec.md` falls vorhanden“); `blender/materials_spec.md` §3 (nur Parameter, kein Graph); Plan §5.4 (WPO-Formel).
- **Problem:** Eine Knotenliste gibt es nirgends. Ob MCP (C5) Material-Graphen bauen kann, ist offen (C5 prüft nur „Material/MI anlegen + Parameter setzen“). Claude Code müsste den Graphen selbst entwerfen und Luis per Klickliste bauen lassen. Das ist eine Designleistung mit hohem Rückfragerisiko und kostet viele Tokens.
- **Fix:** In `materials_spec.md` einen §3a „Knotengraph“ ergänzen (≤ 15 Knoten), z. B.: TexSample(`Palette`, UV0) → Lerp(A=Tex, B=VertexColor.RGB, Alpha=`UseVertexColor`) → Lerp(A=Basis, B=Basis×`TintColor`, Alpha=`TintStrength`×VertexColor.A) → BaseColor; `Metallic`/`Roughness` → Pins; Fresnel(Exponent=`FresnelExponent`) × `FresnelColor` × `FresnelIntensity` + Basis × `EmissiveBoost` + TexSample(`T_FTB_Noise`, Panner(Speed=`StarfieldPanSpeed`)) × `NoiseSparkle` → Emissive; WPO: AppendVector(0,0, sin(2π·`BobFrequency`·Time + Frac(Dot(Floor(ObjectPosition.xy/500),(0,37;0,37)))·2π)·`BobAmplitude`). Im M0-03 prüft C5 zusätzlich „Material-Ausdrucksknoten anlegen und verbinden (ja/nein)“.

### R-06 · Hoch · Niagara: keine MCP-Fähigkeit, keine Werte, keine Bau-Aufgabe
- **Fundstelle:** §5.7 (22 Systeme, „aus UEFN-Niagara-Vorlagen“); M0-03 Matrix C1–C17 (kein Punkt für Niagara); M1-09, M2-03, M2-05, M3-04, M3-05, M6-03 (Systeme werden nur genannt).
- **Problem:** Es fehlen: (a) ein Fähigkeitspunkt „Niagara-System aus Vorlage duplizieren und Parameter setzen“; (b) je System Vorlage, Farbe (Hex), Partikelzahl, Lebensdauer und Größe. Nur die Budgetgrenzen B17 stehen fest. `NS_FTB_Portal` ist keiner Aufgabe zugeordnet. Ohne diese Angaben muss Claude Code je System raten oder Luis fragen.
- **Fix:** (1) M0-03 um **C18 „Niagara-System duplizieren + User-/Emitter-Parameter setzen“** erweitern. (2) In Anhang A die Tabelle „V01–V22“ ergänzen: Name | Vorlage (Simple Sprite Burst / Fountain / Beam) | Farbe | Burst | Lebensdauer | Größe. Die Farben kommen aus GDD 4.2 (Reveal_R0…R6 = Seltenheits-Hex) bzw. GDD 13, z. B. `Reveal_R0` #B8C2CC/24/1,0 s, `Reveal_R6` #00E5FF→#FF3DF2/64/4,0 s, `CoinPop` #FFC93C/8/0,6 s, `KernDrop` #3EF2D6/6/1,0 s. (3) Eine eigene Aufgabe **M1-09b „Niagara-Grundsatz (Klickliste falls C18 = nein)“** mit allen 22 Systemen in einer Klickliste (Duplikat + 3 Werte je System); `Portal` gehört zu M3-02.

### R-07 · Hoch · Der Spike misst mit Assets, die in M0 noch nicht existieren
- **Fundstelle:** M0.1 Parameter (`SimWaves`: „6 Gegner-Props mit `MoveTo` je Plot“; `SimBeams`: „alle 3 s ein `NS_FTB_Beam`-Spawn je Plot“); M0.3 Schritt 1 (verbindlich mit `SimWaves=an, SimBeams=an`); Gegner-Meshes erst in M3-01, `NS_FTB_Beam` erst in M3-05.
- **Problem:** Keine M0-Aufgabe erzeugt Gegner-Stellvertreter oder `NS_FTB_Beam`. Die G0-Messung ist entweder nicht ausführbar oder zu niedrig, weil Last fehlt.
- **Fix:** M0-08 um zwei Schritte erweitern: (a) Gegner-Stellvertreter = `SM_FTB_Capsule` (A39, 300 Tris; in M0-07 mit erzeugen), 6 je Plot als Props bzw. Spawn; (b) `NS_FTB_Beam` aus der Vorlage „Beam“, Länge 12.500 cm, CPU-Sim, Lebensdauer 1,0 s (bzw. Klickliste). Die Abnahme von M0-08 ergänzen: „Capsule + NS_FTB_Beam vorhanden“.

### R-08 · Hoch · Der Marktbericht fehlt im Repo; M0-05 und Luis-Aufgaben verweisen darauf
- **Fundstelle:** M0-02 Schritt 2 (kopiert nur `deliverables/` und `research_notes/`); M0.6 („Recherche-Paket (`deliverables/`, `research_notes/`)“); M0-05 („25 Codes aus Bericht ‚Nachprüfung 1‘“); M0.6/M3-Luis („R0-1/R0-2“, „C-2“, „E-1 aus der Bericht-Aufnahmeliste“); `entscheidungen.md`-Quelle „Bericht“ = `reports/Brainrot Map Marktanalyse UEFN.md`.
- **Problem:** Der Bericht liegt unter `reports/` und wird weder ins Paket noch ins Repo kopiert. Die Codeliste für M0-05 ist damit nicht auffindbar; die Überschrift heißt im Bericht außerdem „Nachprüfung aus offenem Netz“ (Z. 26), nicht „Nachprüfung 1“. Auch die Pfade in `research_notes/` enthalten einen Unterordner mit Leerzeichen.
- **Fix:** M0.6/Anhang L: Luis legt `reports/` zusätzlich nach `C:\FTB_paket\`. M0-02 Schritt 2 ergänzen: `reports/Brainrot Map Marktanalyse UEFN.md` → `research/bericht_marktanalyse.md`; `research_notes/Brainrot Map Marktanalyse UEFN/*.md` → `research/`. M0-05 Schritt 2: „Codes aus `research/bericht_marktanalyse.md`, Abschnitt ‚Nachprüfung aus offenem Netz‘ (per `grep -n -E '[0-9]{4}-[0-9]{4}-[0-9]{4}'`)“.

### R-09 · Hoch · Codes und Event-Inhalte im Launch-Plan widersprechen GDD und Plan
- **Fundstelle:** `Launch_Plan_Phase_H.md` §4.3 Tag 0 („Starter-Code `FUSE1`“) und §5 Tabelle U1–U8 (`FUSE1`, `HYBRID`, `FROST26`, `SNOWFUSE`, …, Joker-Codes; Frost-Ei als „neue Event-Art mit 3 Teilen“, „Januar-Ei“ als neue Art, „10 versteckte Kombinationen“, Wochenend-Event Fr–So); GDD 7.2/7.4 (16 Codes wie `HALLOHASKE`, `FUSEFUN` …; Bonus-Arten W3/W6; 8 Geheim-Rezepte; Wochenende Sa–So); Plan M5-03/M5-04, M8-07.
- **Problem:** Luis veröffentlicht Codes und Ankündigungen nach dem Launch-Plan. Die Codes dort funktionieren im Build nicht (`data/codes.csv` = GDD). Plan M8-07 übernimmt aus dem Launch-Plan nur §1. Welche Quelle für Codes und Kalender gilt, ist nirgends festgelegt.
- **Fix:** Neue Plan-Entscheidung **P-08** (in `entscheidungen.md` eintragen): „Codes, Event-Inhalte und Wochenendzeiten gelten laut GDD 7.2/7.4; Launch-Plan §5 und die Code-Beispiele in §4.3 sind überholt; Joker-Codes entfallen.“ M8-07 ergänzen: Claude Code erzeugt `docs/code_kalender.md` aus `data/codes.csv` (Code, Woche, gültig ab/bis UTC, Belohnung) als Posting-Vorlage für Luis. Alternativ die 4 Joker-Codes mit Namen in `data/codes.csv` aufnehmen (Gültigkeit ab W1, dauerhaft).

### R-10 · Hoch · Test 2 kann auf den Chapter-8-Start fallen (Server-Downtime)
- **Fundstelle:** M8-02 (Sa 28.11.); M8-05 („Chapter 8: 28.11. oder 05.12.“); `offene_fragen.md` Q-REL-2 (Frist Mo 16.11.); M0-01 Schritt 11 (Tester nur für 31.10. und 28.11. eingeladen).
- **Problem:** Beginnt Chapter 8 am 28.11., ist Fortnite an diesem Tag typischerweise stundenlang offline, und UEFN braucht eventuell ein Update und einen Re-Upload. Der zweite und letzte Menschen-Test fällt dann aus; einen Ersatztermin mit den 3 Testern gibt es nicht. Die Vorgabe „3 Tester, 2 Termine“ lässt keinen dritten Termin zu, deshalb muss der Ausweichtermin vorab vereinbart sein.
- **Fix:** M0-01 Schritt 11 ergänzen: „Ausweichtermin für Test 2: **Fr 27.11. 17:00–21:00** oder **So 29.11. 11:00–18:30** gleich mit vereinbaren“. Q-REL-2 ergänzen: „Ist Chapter 8 = 28.11. bestätigt → Test 2 auf den Ausweichtermin; M8-03 Go/No-Go spätestens Mo 30.11.“ M8-05 als feste Aufgabe am Tag nach dem Chapter-Start einplanen.

### R-11 · Hoch · Die B1-Hochrechnung in G0 nutzt ungemessene Werte und lässt Assets aus
- **Fundstelle:** M0-17 Schritt 2 (`Messwert + 21 × Kosten(1 Niagara) + Audio-Schätzung (Sekunden × gemessene Kosten einer 10-s-WAV) + 15.000 + 5.000`); M0.3 (Kill-/Fallback-Entscheidung hängt an B1).
- **Problem:** Keine M0-Aufgabe misst „Kosten 1 Niagara“ oder „10-s-WAV“. Es fehlt die geplante Audio-Sekundenzahl. Nicht enthalten sind: 4 Gegner-Meshes, 3 Boss-Meshes (je ≤ 25.000 Tris), A38–A49 (12 Props inkl. Statue ≤ 8.000 Tris), 42+ UI-Texturen, 6 Bonus-Mesh-Teile. Die G0-Entscheidung (F-Leiter, Kill bei > 70.000) wird damit willkürlich.
- **Fix:** In M0-08 Schritt 7 ergänzen: 1 × `NS_FTB_Beam` (siehe R-07) und 1 Test-WAV (`gen_sfx.py`, 10 s mono 22,05 kHz) importieren, Memory Calculation vor/nach → Deltas in `budgets.md`. Formel in M0-17 ersetzen: `B1_proj = Messwert + 21·ΔNiagara + (Σ geplante Audio-s ÷ 10)·ΔWAV10 + (Σ geplante Nicht-Kreatur-Tris ÷ Σ Kreatur-Tris(38.400))·ΔMeshes_M0 + 42·ΔIcon256 + 15.000 + 5.000` mit Σ Audio ≈ 30×1,2 + 31×1,5 + 8×4 ≈ 115 s (Musik aus der Bibliothek = 0) und Σ Nicht-Kreatur-Tris ≈ 4×2.000 + 3×25.000 + 11×1.500 + 8.000 = 107.500.

### R-12 · Hoch · Bonus-Arten mit Variante A sprengen B10; B9-Grün ist mit A nicht erreichbar
- **Fundstelle:** §3 B9 (≤ 3.500 grün), B10 (A ≤ 2.304, rot > 2.500); M6-02 („Bonus-Arten nur wenn B1 < 50.000“); M0.1 (A = 24 Teile je Pad); GDD 4.1 Instanzen.
- **Problem:** Mit 10 Arten braucht Variante A je Pad 30 Teile, also 16 × 6 × 30 = 2.880 Props (> 2.500 = rot). M6-02 prüft nur B1. Zusätzlich liegt Variante A bereits ohne Bonus-Arten über B9-Grün: 2.304 Teile + 384 Gegner + 192 Drops + ≈ 600 Deko + 249 Devices + 256 Boden-Kacheln + 96 Pads + ≈ 144 Plot-Props ≈ 4.200. Die G0-Regel „Grün“ prüft B9 nicht, später wird B9 aber gelb bzw. unklar.
- **Fix:** M6-02 Bedingung ersetzen: „Bonus-Arten nur wenn B1 < 50.000 **und** (Variante ≠ A **oder** F1 aktiv, d. h. `DisplayPerPlot=3` → 16 × 3 × 30 = 1.440)“. B9 in §3 an die Variante koppeln: „A: grün ≤ 4.500 / gelb ≤ 5.000; B/C: ≤ 3.500“. In M0.3 Schritt 1 „B9 ≤ Varianten-Grenze“ als Grün-Bedingung ergänzen.

### R-13 · Hoch · Bonus-Arten: keine Geometrie; Ersatz-Zuordnung für E3/E6 fehlt
- **Fundstelle:** M6-02 (`blender/gen_species_parts.py` „Arten 9/10“; „sonst Paketeulo/Bassotto als Event-MI-Varianten bestehender Arten“); `gen_species_parts.py` (`--species` „leer = alle 8“, kein Eintrag für Paketeulo/Bassotto); `brainrot_catalog.csv` E3-11…15 (Form „Paket“, Kopf H9) und E6-26…30 (Form „Bass“); Plan §4.2 (`Form` 1–6 Event, nur 6 Event-MIs).
- **Problem:** (a) Für Art 9/10 fehlen im `SPECIES`-Dict Maße und Primitive; GDD 4.4 liefert nur Konzepttexte. Claude Code müsste Figuren entwerfen. (b) Ohne Bonus-Arten ist offen, auf welche Art und welches MI E3/E6 abgebildet werden. (c) Die Formen „Paket“/„Bass“ haben kein Event-MI, und die Zuordnung Form-Code → MI ist nicht festgelegt.
- **Fix:** (a) In M6-02 Maße vorgeben oder die Aufgabe streichen. Vorschlag: Paketeulo = Körper Würfel 90×90×90 + 2 flache Flügel-Quader, Kopf Kugel Ø 70 + Schleifen-Torus, Acc Band-Zylinder; Bassotto = Körper liegender Zylinder Ø 60 × 140 + Lautsprecher-Kreis, Kopf Kapsel 50×70 + 2 Kopfhörer-Ringe, Acc Zylinder-Schwanz; Palette laut GDD 11. (b) Fallback festlegen: E3-11…15 → Art 8 Bzzkoffro + `MI_FTB_Event_Festi`-Tint #D32F2F; E6-26…30 → Art 5 Diskolama + neues MI `MI_FTB_Event_Bass` (#8D5A3B). (c) In §4.2 festlegen: `Form` 1 Gründer, 2 Frosti, 3 Paket, 4 Funki, 5 Schleimi, 6 Bass, 7 Kosmi, 8 Festi, 9 Sternen; das Packformat hat 32 Werte, das reicht.

### R-14 · Hoch · Kein Abbruch- und Checkpoint-Protokoll bei erschöpftem Claude-Pro-Kontingent
- **Fundstelle:** `CLAUDE.md` §2 („Pro Session ein Block aus 2–4 Aufgaben“); §1 Plan („2 Sessions pro Tag“); viele Aufgaben mit 2 h.
- **Problem:** 2–4 Aufgaben à 1,5–2 h mit MCP-Aufrufen, Compile-Schleifen und Logs passen kaum in ein 5-h-Fenster von Claude Pro. Endet das Kontingent mitten in einer Aufgabe, gibt es weder Zwischenstand in `status.md` noch einen Commit. Die nächste Session muss dann neu erkunden, und das kostet doppelt.
- **Fix:** `CLAUDE.md` §2 ändern: „Block = **1–2 Aufgaben oder ≤ 3 h Plan-Dauer**. Nach **jedem nummerierten Schritt** eine Zeile in `status.md` → `Laufend: M1-06 Schritt 3/6, Datei X kompiliert: ja/nein` und `git commit -m "WIP M1-06 s3"`. Bei Session-Start zuerst `Laufend:` fortsetzen.“ Den Richtwert in §1 anpassen: Sessions M0 10–12, M3 14–16 (Summe prüfen).

### R-15 · Hoch · Aufgaben über 2 h (Schema §2.1 verletzt)
- **Fundstelle:** M0-11 (2.304 Props platzieren + 24 Tags + Einsortieren + Show/Hide/SetMaterial + Bot-Schleife + Messung); M1-04 (neues Skript mit 10 Meshes + Export + Import + 16 Plots bestücken); M1-06 (9 Systeme); M2-05 (14 MIs + 7 Niagara); M3-05 (Boss mit 12 Teilregeln); M6-02 (40 Event-Kreaturen, 8 Modifikatoren, Aufgaben, Kosmetik, Bonus-Arten, Stinger).
- **Problem:** Realistisch 3–5 h je Aufgabe. Zusammen mit R-14 bricht die Aufgabe eher ab, und die Abnahme ist nicht an einem Stück prüfbar.
- **Fix:** Aufteilen: M0-11a Platzieren + Tags (per MCP-Batch), M0-11b Verse-Pool + Messung. M1-04a `gen_misc_meshes.py` + Import, M1-04b Platzierung. M1-06a Einkommen/Eier/Brut/Pity, M1-06b Level/Totem/Pads/Stall/Freilassen. M2-05a MIs, M2-05b Niagara (mit R-06). M3-05a Zeitplan/Landung/HP/Teilnahme/Belohnung, M3-05b Sync-Smash/Stampfer/Hype-Zone/Beams/Flucht/Aufhol-Hilfe. M6-02a Event-Daten + Modifikatoren, M6-02b Bonus-Arten/Deko/Stinger. Jeweils mit eigener Abnahme.

### R-16 · Hoch · Asset-Referenzen in Verse (Materialien, Props, Meshes) sind nicht geregelt
- **Fundstelle:** M0-11 („`SetMaterial`“); M0-13 (`SpawnProp(BP-Asset, …)`); M0-12 (`mesh_component`-Unterklasse); `verse_reference/ftb_creature_pool.verse` Z. 81–83 (`@editable RarityMaterials:[]material`, UNVERIFIED); M0-04 (sucht keine Asset-Symbole).
- **Problem:** Wie Verse die 7 MIs, 24 BPs oder Meshes anspricht, fehlt: über die vom Editor erzeugte `Assets.digest.verse` des Projekts (Modulpfad aus Ordnernamen) oder über `@editable`. Ohne diese Angabe sind P1, Variante B und C nicht umsetzbar, und der Fallback fehlt.
- **Fix:** M0-04 Schritt 2 um eine Gruppe ergänzen: „Projekt-Assets: in `<Projekt>/**/Assets.digest.verse` nach `MI_FTB_Rarity_|BP_FTB_|SM_FTB_` suchen, Modulpfad (z. B. `FTB.Materials.MI_FTB_Rarity_0`) in `api_digest.md` eintragen“ (erst nach M0-08 sinnvoll → Abh. M0-08 ergänzen oder als M0-16-Schritt). Fallback: `@editable RarityMaterials:[]material` + `@editable PartAssets:[]creative_prop_asset`, per MCP C3 befüllt, sonst Luis-Klickliste (7 + 24 Einträge ≈ 10 min).

---

## Mittel

### R-17 · Mittel · Rotationsformel nach W8: Off-by-one gegenüber der Referenz
- **Fundstelle:** M5-04 (`Rotation nach W8: 2 + ((idx−8) mod 7)`); `verse_reference/ftb_time.verse` Z. 86–90 (`2 + Mod[Raw − 8 − 1, 7]`, Raw 1-basiert).
- **Problem:** Mit 1-basiertem Wochenindex (W9 → idx 9) ergibt die Plan-Formel W3 statt W2 (GDD 7.4: „Rotation W2–W8“). Die Basis von `idx` ist im Plan nicht definiert. AT-M5-4 und AT-M7-5 würden je nach Lesart PASS oder FAIL melden.
- **Fix:** M5-04 ändern auf: „`EventWeek = Raw` für 1 ≤ Raw ≤ 8; für Raw ≥ 9: `2 + ((Raw − 9) mod 7)`; Raw = `floor((t − 1796860800)/604800) + 1` (1-basiert, wie `ftb_time.verse` `RotateWeek`)“. AT-M5-4 um Sollwerte ergänzen: Raw 9 → W2, Raw 15 → W8, Raw 16 → W2.

### R-18 · Mittel · Kreatur-Skalierung ×1,15 wird durch Lunge und Landen zurückgesetzt
- **Fundstelle:** §5.2 Einheiten („Verse skaliert die Teile im Pool einheitlich ×1,15 (Konstante in `ftb_creature_pool.verse`)“); `verse_reference/ftb_creature_pool.verse` Z. 135–154 (Lunge/Landen mit absoluten Skalen 1,15/1,0 und `2.0 − Sz`); die Konstante fehlt in der Referenz.
- **Problem:** `MoveTo` setzt absolute Transforms. Nach dem ersten Lunge steht die Kreatur mit Skalierung 1,0 da und schrumpft sichtbar. Die Montage-Offsets (`mounts`) müssen ebenfalls ×1,15 skaliert werden, sonst schweben oder versinken Kopf und Accessoire.
- **Fix:** M1-07 Schritt ergänzen: „Konstante `DisplayScale:float = 1.15`; alle Skalen in Lunge/Landen als `DisplayScale × (1,15 | 0,87 | 1,0)`; Offsets aus `mounts` × `DisplayScale`; AT-Prüfung: Skalierung nach 10 Lunges = 1,15 ± 0,01.“

### R-19 · Mittel · Materialparameter und Texturimport: Plan und `materials_spec.md` widersprechen sich
- **Fundstelle:** §5.4 (Parameter `RarityTint, FresnelPower, EmissiveStrength, CrystalOpacity, CosmicTex, CosmicPan, BobAmpCm, BobFreqHz, SquashAmp, PhaseGridCm, RainbowOn`; Bob „4 cm“); `materials_spec.md` §3–5 (`TintColor/TintStrength, FresnelExponent/Intensity, EmissiveBoost, NoiseSparkle, StarfieldPanSpeed, BobAmplitude, BobFrequency, SquashAmount`, zusätzlich `DitherOpacity`, `StarfieldColorA`, `RainbowShimmer` ohne Definition in §3); `entscheidungen.md` E-064 („6 cm / 0,8 Hz“); §5.5 `T_FTB_Palette` (UserInterface2D, keine Mips, Nearest) gegen `materials_spec.md` §6 (Default BC1, Mips ja); Seltenheits-Symbole 256² (§5.5) gegen 128² (`materials_spec.md` §6, GDD 10.2).
- **Problem:** Der Plan erklärt `materials_spec.md` für maßgeblich, nennt aber andere Namen und Werte. Claude Code kann nicht entscheiden, welche Namen im Material gelten.
- **Fix:** §5.4 Parameterliste durch „Namen exakt laut `materials_spec.md` §3“ ersetzen und §3 dort um `DitherOpacity` (Scalar, 0,6), `StarfieldColorA` (Vector, #00E5FF), `RainbowShimmer` (Scalar 0/1), `PhaseGridCm` (500) ergänzen. E-064 per neuer Zeile „ersetzt E-064: 4 cm / 0,8 Hz“ korrigieren. §5.5 Palette: „UserInterface2D, keine Mips, Filter Nearest“ als verbindlich in `materials_spec.md` §6 übernehmen. Symbole einheitlich 128².

### R-20 · Mittel · Ablage von `parts_layout.json` und Palette; `T_FTB_Noise` hat keinen Generator
- **Fundstelle:** M0-07 Dateien (`art_src/T_FTB_Palette.png`, `art_src/T_FTB_Noise.png`, `data/parts_layout.json`); §6.2 (`blender/out/` ist ignoriert); §4.1 (Generator liest `data/parts_layout.json`); `gen_species_parts.py` (schreibt nur nach `--out`, keine Noise-Textur).
- **Problem:** Ein Kopierschritt nach `data/` und `art_src/` fehlt, und `blender/out` wird nicht versioniert. `T_FTB_Noise.png` erzeugt kein Skript.
- **Fix:** M0-07 Schritt 2b: `cp blender/out/parts_layout.json data/ && cp blender/out/T_FTB_Palette.png art_src/`. Schritt 2c: `tools/gen_ui_tex.py` (A66, stdlib zlib-PNG) schon in M0-07 anlegen, ergänzt um `--noise`: 512×512 Graustufen, Value-Noise 4 Oktaven, Seed 7 → `art_src/T_FTB_Noise.png`.

### R-21 · Mittel · `--lods` erzeugt 48 zusätzliche FBX; der Import ist mehrdeutig
- **Fundstelle:** M0-07 Schritt 2 (immer `--lods`); §5.2 LOD („Primär UE-Reduktion … Fallback `--lods`“); §5.3 Fallback 2 („Luis zieht den Ordner `blender/out/fbx` in den Content Browser“); `blender/README.md` (48 `_LOD1/_LOD2`-Dateien).
- **Problem:** Beim Import des ganzen Ordners entstehen 72 Static Meshes (48 LOD-Dateien als eigene Assets). Das kostet Speicher (B1) und verfälscht die Messung.
- **Fix:** M0-07: `--lods` nur, wenn C6 (LOD-Reduktion per MCP) = nein. Sonst die FBX-Ausgabe trennen: `export_fbx.py -- --out blender/out/fbx` exportiert LODs nach `blender/out/fbx_lod/` (Skriptpatch: `is_lod` → Unterordner). §5.3: „nur `blender/out/fbx/*.fbx` (24 Dateien) importieren“.

### R-22 · Mittel · Abhängigkeitsfehler M0-02 ↔ M0-03 (Logpfad) sowie fehlender Zweig `dev`
- **Fundstelle:** M0-02 Schritt 4 (`log_check.py` nutzt den „Pfad aus `mcp_werkzeuge.md`“), die Datei entsteht erst in M0-03; M0-02 Abnahme `python tools/log_check.py --since 5`; M0-02 Schritt 6 legt nur `main` und `spike/m0` an; M0-17 „Merge `spike/m0` → `dev`“; `CLAUDE.md` §7.4 „auf Zweig `dev`“.
- **Problem:** M0-02 ist so nicht abnehmbar, und der Zweig `dev` existiert beim ersten Merge nicht. `CLAUDE.md` schreibt für M0 den falschen Zweig vor.
- **Fix:** M0-02 Abh. „M0-01, M0-03“ oder `log_check.py` mit Standardpfad `%LOCALAPPDATA%/UnrealEditorFortnite/Saved/Logs/UnrealEditorFortnite.log` + `--log <pfad>`. Schritt 6: `git branch dev && git checkout -b spike/m0`. `CLAUDE.md` §7.4: „auf `spike/m0` in M0, sonst `dev`“.

### R-23 · Mittel · Device-Klassen und Graybox-Assets ohne Pfad für die MCP-Platzierung
- **Fundstelle:** M0-09 Assets („Graybox aus UEFN-Galerie: Boden-Platten 1.000, Zylinder Ø 300 × 40“); Anhang D (nur Verse-Klassen, keine Editor-Asset-Pfade); M0-03 Matrix C1.
- **Problem:** C1 („Actor aus Asset platzieren“) braucht Asset-Pfade. Welche Galerie-Assets und welche Device-Blueprints gemeint sind, steht nirgends. Claude Code muss suchen und wählen.
- **Fix:** M0-03 Schritt 4b: „Per MCP die Asset-Pfade für D01–D19 suchen (Name enthält `Button`, `Player_Spawner`, `Input_Trigger`, `Audio_Player`, `Billboard`, `Barrier`, `Analytics`) und als Tabelle `Dxx | Asset-Pfad` in `mcp_werkzeuge.md` eintragen.“ Graybox ohne Galerie: `SM_FTB_Pad` (Ø 300 × 40) und neu `SM_FTB_Tile` (1.000 × 1.000 × 20) schon in M0-07 per `gen_misc_meshes.py` erzeugen (Primitive, Palette Gras #7BD957).

### R-24 · Mittel · Token: Der Meilenstein-Abschnitt wird bei jedem Session-Start komplett geladen
- **Fundstelle:** `CLAUDE.md` §1.3 (`sed -n '/^## M3 ·/,/^## M4 ·/p'`); Plan Kopf.
- **Problem:** M0 umfasst ≈ 300 Zeilen (≈ 10–12 k Tokens), M1–M3 je ≈ 120–130 Zeilen. Bei 8–14 Sessions je Meilenstein ist das der größte Fixkostenblock.
- **Fix:** `CLAUDE.md` §1.3 ändern: „Nur die Aufgaben des Blocks: `sed -n '/^#### M1-06 /,/^#### M1-07 /p' docs/BAUPLAN_Claude_Code.md`; Meilenstein-Kopf (Ziel/Endzustand) nur in der ersten Session des Meilensteins; M0.1–M0.3 nur in M0-10…M0-17.“ In `status.md` die Zeile „Nächste Aufgabe“ immer mit Zeilennummer (`grep -n`) führen.

### R-25 · Mittel · Token: Die Digest-Suche in M0-04 ist unbegrenzt
- **Fundstelle:** M0-04 Schritt 2 (Muster `tag\b`, `entity\b`, `camera`, `profile`, `Submit` mit 2 Kontextzeilen über alle Digests).
- **Problem:** Diese Muster treffen in den Fortnite-/Verse-Digests hunderte bis tausende Zeilen. Selbst gefiltert sprengt das den Kontext.
- **Fix:** Schritt 2: „Ausgabe je Gruppe in `logs/digest_<gruppe>.txt` schreiben (nicht in den Kontext), dann nur `wc -l` + die ersten 25 Treffer je Gruppe lesen; zu breite Muster ersetzen: `tag\b` → `class\(tag\)|WithTag`, `entity\b` → `entity<|:= class\(entity`, `camera` → `camera_device|Shake`“.

### R-26 · Mittel · Token: M0-05 ruft bis zu 26 fortnite.gg-Seiten per WebFetch ab
- **Fundstelle:** M0-05 Schritt 4.
- **Problem:** Für das Kill-Kriterium sind nur wenige Codes entscheidend. 26 WebFetches kosten viel Kontingent.
- **Fix:** Schritt 4 begrenzen: „Nur für BE A BRAINROT (6931-5304-1207), Kick a Lucky Rot und die ≤ 3 Fusion-first-Treffer aus Schritt 3 (max. 5 WebFetches, Prompt: ‚nur 30-Tage-Peak und Datum‘)“.

### R-27 · Mittel · Test-1-Protokoll kann zwei Messgrößen nicht liefern
- **Fundstelle:** `playtests.md` Test 1 (Einzel-Session fest 45 min; Messung „Session-Länge Einzel, Median > 20 min“); GDD 5.9 („Test 1 misst: Verlassen > 50 % der Tester zwischen 60 und 120 min → Rebirth-Kosten 150M“); M4-03.
- **Problem:** Ist die Dauer vorgegeben, sagt sie nichts über freiwilliges Weiterspielen. Den Abbruch zwischen 60 und 120 min erreicht kein Tester, weil beide Sessions je 45 min dauern. Die GDD-Regel „Rebirth 150M“ lässt sich deshalb nie auslösen.
- **Fix:** `playtests.md`/M4-01: „Einzel-Session: Tester dürfen jederzeit aufhören; Stoppuhr bis zum freiwilligen Ende, Obergrenze 60 min.“ M4-03 ergänzen: „GDD-5.9-Regel (60–120 min) ist mit Test 1 nicht messbar → erst nach Launch anhand der Analytics `session_min_30`/Portal-Spielzeit (LP 4.3) entscheiden; in `entscheidungen.md` eintragen.“

### R-28 · Mittel · Touch wird vor Test 1 nie geprüft; der Mobile-Fallback verletzt die Test-Vorgabe
- **Fundstelle:** `playtests.md` Test 1 (T3 = Handy/Touch); M3-11 (nur S, C, 2P); §2.3 M („sonst an Testtag 2 über einen Tester mit Handy“); M7-03/M7-Luis („notfalls mit Tester-Handy per Discord“, Mi 18.11.).
- **Problem:** T3 spielt am 31.10. eine ungeprüfte Touch-Fassung, was Blocker-Risiko für ein Drittel des Tests bedeutet. Der M7-Fallback setzt einen Tester außerhalb der 2 Termine ein (Vorgabe E-024), oder Touch-Fehler fallen erst am 28.11. auf, 5 Tage vor der Einreichung.
- **Fix:** M0-01 Schritt 8 ergänzen: „Luis stellt ein eigenes Android-Gerät/Tablet mit Fortnite bereit (Epic Games Store App)“. M3-11 um „M: 10-min-Touch-Rauchtest der privaten Version auf Luis’ Gerät (Ei kaufen, Fusion, Welle)“ ergänzen. Den Tester-Fallback in §2.3/M7 streichen und ersetzen durch „kein Gerät → Touch-Ziele nur per Layout-Check (Button ≥ 12 % H) + Test 2“.

### R-29 · Mittel · Launch-Plan-Soft-Launch (23.–27.11.) ist nicht formell ersetzt
- **Fundstelle:** Plan P-01 (streicht nur den Blindtest 16.–22.11.); `Launch_Plan_Phase_H.md` §4.2 (tägliche Tester-Aufgaben 23.–27.11., Go-Kriterium „≥ 2 von 3 am Tag 2 von selbst zurückgekommen“); `playtests.md` Go/No-Go „(LP 4.2 + GDD 14.1)“; M8-03 (ohne D1-Kriterium).
- **Problem:** Zwei Dokumente stellen widersprüchliche Anforderungen an die 3 Tester. Unklar bleibt, ob das Rückkehr-Kriterium für Go/No-Go gilt.
- **Fix:** P-01 erweitern (und in `entscheidungen.md` als E-Zeile): „LP-4.2-Messplan 23.–27.11. entfällt als Pflicht; Go/No-Go = M8-03-Liste; das Kriterium ‚Rückkehr Tag 2‘ ist nur Info (optional, falls Tester freiwillig spielen)“.

### R-30 · Mittel · Zeitpunkt des Token-Umtauschs ist mehrdeutig
- **Fundstelle:** M5-04 („Wochenende-Ende: Reste 1:5 in Kerne“); GDD 5.1 („Nach Wochenende“), GDD 7.4 („Event-Ende: Reste werden 1:5 … getauscht“); Event-Woche Do–Mi, Wochenende Sa–So.
- **Problem:** Wird schon am Sonntag umgetauscht, sind Event-Eier Mo–Mi nicht mehr kaufbar. Beim Tausch am Wochenende-Ende gibt es zweimal Tokens pro Woche. AT-M7-5 prüft den „Token-Umtausch am Wochenende-Ende“.
- **Fix:** Festlegen: „Umtausch beim ersten Join nach Ende der Event-Woche (Do 00:00 UTC der Folgewoche, `LastEventWeekSeen < EventWeek`)“. M5-04 und AT-M7-5 entsprechend anpassen.

### R-31 · Mittel · Die Referenzwerte für M1-06 (±10 %) haben keine Python-Quelle; `econ_params.json` wird per Hand abgetippt
- **Fundstelle:** M1-06 Abnahme („innerhalb ±10 % des Python-Werts für denselben Kauf-Plan“); M1-01 Schritt 1 (`econ_params.json` „1:1 aus GDD 5.8 … per `sed`“).
- **Problem:** Welches Skript den Kauf-Plan spiegelt, ist nicht festgelegt (`economy_sim.decide()` hat eine eigene Strategie). Das Abtippen der Tabelle aus dem GDD kostet Tokens und birgt Übertragungsfehler, obwohl dieselben Werte maschinenlesbar in `economy_sim.P` stehen.
- **Fix:** M1-01: `python -c "import sys; sys.path.insert(0,'data'); import economy_sim, json; json.dump(economy_sim.P, open('data/econ_params.json','w'), indent=1)"` (bzw. `--dump-json`, R-01); GDD 5.8 dient nur zum Gegencheck per `--check`. `gen_golden.py` um `--scenario m1_10min` ergänzen: fester Kauf-Plan (Starter-Waffelino, 3 Wiesen-Eier, Pad 3, 5 Level-Ups) → erwartete Münzen nach 600 s; derselbe Plan im Verse-Autoplay AT-M1-1.

### R-32 · Mittel · Position doppelt belegt: Herz-Knopf D07 und Plot-Schild D16 bei (+2.000, +600)
- **Fundstelle:** Anhang D D07 und D16; M1-04 (D16 „an (+2.000, +600)“); GDD 11 („Plot-Tor + Schild (+2.000, ±600)“); M2-09 („BESUCHEN = `TeleportTo` Plot-Tor“).
- **Problem:** Zwei Devices stehen an derselben Stelle. Das Teleport-Ziel „Plot-Tor“ hat keine Koordinate.
- **Fix:** D16 Plot-Schild auf (+2.000, +600, Höhe 350), D07 Herz auf (+2.000, −600) (Tor-Gegenseite laut GDD ±600); Besuchs-Ziel = lokal (+2.300, 0), Blick −X (in Richtung Plot).

### R-33 · Mittel · Keine Regel für UEFN-Updates vor M8
- **Fundstelle:** M8-05 (nur „Chapter 8“); `CLAUDE.md` (keine Regel).
- **Problem:** UEFN aktualisiert sich zwischen Oktober und November voraussichtlich 2–3-mal. Digests und APIs können sich ändern, und `api_digest.md` veraltet.
- **Fix:** `CLAUDE.md` §3 ergänzen: „Nach jedem UEFN-Update (Version in `mcp_werkzeuge.md` vergleichen): M8-05-Rauchtest (Verse-Build, `log_check.py --build`, AT-Kurzlauf `AutoTest=100`) als erste Aufgabe; geänderte Signaturen in `api_digest.md` nachziehen.“

### R-34 · Mittel · Widersprüchliche Bonus-Arten-Schwelle in M0.3 Schritt 3
- **Fundstelle:** M0.3 Schritt 3 S2 („Bonus-Arten streichen (−6 Meshes, GDD-Kill-Schalter: nur erlaubt bei Messung < 50 % = < 50.000)“); §3 B1 (grün ≤ 45.000); M6-02.
- **Problem:** Der Satz sagt, das Streichen sei „nur erlaubt“ unter 50.000. Gemeint ist, dass die Arten nur dann erlaubt sind. Zwischen 45.001 und 50.000 (B1 gelb) verlangt S2 das Streichen, M6-02 erlaubt die Arten aber.
- **Fix:** S2 umformulieren: „S2 Bonus-Arten streichen (−6 Meshes). GDD-Kill-Schalter: Bonus-Arten nur, wenn B1-Projektion < 45.000 (grün)“ und M6-02 auf „< 45.000“ angleichen (oder beide auf 50.000 und B1-Gelb dafür akzeptieren; einmal festlegen).

### R-35 · Mittel · Musikauswahl verlangt Hören, Claude Code kann nicht hören
- **Fundstelle:** M3-07 Assets („je Zustand ein Loop passend zu GDD 12 (Tempo/Stil); gewählte Asset-Namen in `entscheidungen.md`“).
- **Problem:** Claude Code kann Musik-Assets nur nach Namen auswählen. Ob Tempo und Stil passen, lässt sich so nicht prüfen, eine Rückfrage ist nötig.
- **Fix:** M3-07 Schritt 0: „Claude Code listet per MCP je Zustand 3 Kandidaten (Name + Länge) → Klickliste für Luis ‚anhören, Nr. wählen‘ (10 min); Standard ohne Antwort bis Folgetag: Kandidat 1.“ Luis-Tabelle M3 um 10 min ergänzen.

### R-36 · Mittel · AutoTest-Sammelläufe sind nicht definiert
- **Fundstelle:** Anhang T (`AutoTest = 100` = „alle Szenarien des aktuellen Meilensteins“); M4-08 („AT-M1…M3 komplett“); M5-08 („AT-M1…M5“); M6-09 („alle AT“); M8-04 („AT-Kurzlauf“).
- **Problem:** Wie Szenarien mehrerer Meilensteine in einem Lauf ausgeführt werden und was „AT-Kurzlauf“ umfasst, bleibt offen. Einzelläufe kosten jeweils einen Session-Start durch Luis.
- **Fix:** Anhang T ergänzen: `AutoTest = 200` = alle Regressions-Szenarien 1–41 außer Sichtproben (90–93, 20) und Langlauf (70); `AutoTest = 201` = Kurzlauf (1, 2, 3, 11, 21, 31, 37). M4-08/M5-08/M6-09 auf 200, M7-08/M8-04 auf 201 verweisen.

---

## Niedrig

### R-37 · Niedrig · B16 verweist auf ein nicht existierendes Szenario
- **Fundstelle:** §3 B16 („Test AT-M5-5“); Anhang T (nur AT-M5-5a = IIT, AT-M5-7 = Save-Freeze).
- **Fix:** B16-Messmethode auf „AT-M5-7 (37), vorher AT-M0-94 (94)“ ändern.

### R-38 · Niedrig · Falsche Asset-ID für den Metronom-Klick
- **Fundstelle:** M3-03 Assets („Metronom-Klick A134“); Anhang A (A134 = `A_FTB_UI_Buy`); M0-15 („1 Audio-Player mit Klick“).
- **Fix:** Neue Zeile A165 `A_FTB_UI_Metronome` (gen_sfx, 30 ms, 1 kHz) in Anhang A; M3-03 auf A165; D14 „UI“ von 8 auf 9 (B19 bleibt ≤ 70).

### R-39 · Niedrig · Falsche Abhängigkeit und fehlender Interpreter-Pfad bei den TTS-Silben
- **Fundstelle:** M2-07 Abh. („M0-01 (Kokoro installiert)“); M2-Luis (Kokoro-Installation Mi 14.10. nach `C:\FTB_tts`).
- **Fix:** Abh. „M2-Luis Kokoro-Installation (Mi 14.10.), M2-01“; Schritt 1 Aufruf: `/c/FTB_tts/Scripts/python.exe tools/tts_syllables.py --out audio_src/syl`.

### R-40 · Niedrig · ffmpeg-`loudnorm` erreicht die Abnahme „−12 dBFS ±1“ nicht zuverlässig
- **Fundstelle:** M2-07 Schritt 2 (`loudnorm=I=-16:TP=-12`); Abnahme „Pegel −12 dBFS ±1“.
- **Problem:** Einpassiges `loudnorm` auf Clips unter 1,2 s regelt ungenau und zielt auf Lautheit, nicht auf den Spitzenpegel.
- **Fix:** Zweistufig: `ffmpeg -i in.wav -af volumedetect -f null -` → `max_volume` lesen → `-af "volume=<−12 − max_volume>dB"`; `loudnorm` streichen. Für die Musik (M6-05) bleibt `loudnorm=I=-18`.

### R-41 · Niedrig · M0-01: Dauer widersprüchlich, Blender-Installation unscharf
- **Fundstelle:** M0-01 (1,5 h) gegen M0.6 (3 h); Schritt 4 („`winget search Blender` → Paket mit Version 4.2.x wählen“).
- **Fix:** Dauer einheitlich 3 h (der UEFN-Download allein dauert länger als 1 h). Blender fest: Download `https://download.blender.org/release/Blender4.2/` → `blender-4.2.x-windows-x64.msi` (neueste 4.2.x), Standardpfad wie angegeben.

### R-42 · Niedrig · [CC]-Aufgaben mit versteckten Luis-Schritten
- **Fundstelle:** M0-02 Schritt 3 (Luis legt eine Verse-Datei an); M0-16 (AT-M0-94 „Rejoin durch Luis“); M0-09 Test S (Luis spawnt).
- **Fix:** Markierung auf [CC+Luis] ändern und in M0.6 aufnehmen (je 5 min), damit Claude Code nicht blockiert wartet.

### R-43 · Niedrig · Doppelte bzw. unklare Zuordnungen in Anhang A und bei den Devices
- **Fundstelle:** M1-04 Assets „A38–A49“ (A45 Drop erst M3-01, A49 Statue erst M6-06); D16 Plot-Schild ×16 in M1-04 **und** M2-09.
- **Fix:** M1-04 → „A38–A44, A46–A48“; M2-09 Devices → „D16 (vorhanden aus M1-04), nur Text-Logik“.

### R-44 · Niedrig · Tutorial-Schritt wandert von `Stats/Settings` in ein neues Feld
- **Fundstelle:** M1-11 („Schritt im Save `Stats`/`Settings`“); M5-07 (neues Feld `TutorialStep:int = 0`).
- **Problem:** Wie der Wert migriert wird, ist nicht festgelegt. Private Saves aus Test 1 würden das Tutorial neu starten.
- **Fix:** In M1-11 gleich ein eigenes Feld `TutorialStep:int = 0` anhängen (vor dem Freeze erlaubt) und in M5-07 streichen.

### R-45 · Niedrig · Hype-Zone: Scheibe in der Referenz, Ring in Plan und GDD
- **Fundstelle:** `verse_reference/ftb_combat.verse` Z. 24/189 (`Distance ≤ 3000`); M3-05/GDD 2.4.4 (Ring r = 2.000–3.000).
- **Fix:** M3-05: „`InHypeZone` = 2.000 ≤ Distanz ≤ 3.000 (xy)“; die Referenz als bewusst abweichend markieren.

### R-46 · Niedrig · Späteinsteiger-Regel beim Boss fehlt
- **Fundstelle:** GDD 8 („Wer innerhalb von 45 s nach Start dazukommt, bekommt die volle Belohnung“); M3-05 (nicht enthalten).
- **Fix:** M3-05 Schritt ergänzen: „Beitritt ≤ 45 s nach Landung → Belohnungsfaktor 1,0 (unabhängig von der Anwesenheitszeit)“; AT-M3-4 um den Fall ergänzen.

### R-47 · Niedrig · `budgets.md` ohne Spalte M4; Ersatztitel uneinheitlich
- **Fundstelle:** `_context/budgets.md` (Spalten M0–M3, M5–M8); M4-08 „Meilenstein-Ende“; E-040 („FUSE THE BRAINROTS!“) gegen Launch-Plan 1.2 („BRAINROT FUSION LAB“), Q-MKT-3.
- **Fix:** Spalte M4 ergänzen. Ersatztitel einmal festlegen (Vorschlag: E-040 gilt, LP 1.2 per P-08-Zeile überschreiben).

### R-48 · Niedrig · `billboard_device.SetText` ohne Fallback
- **Fundstelle:** M2-09 API („`billboard_device.SetText` Digest“).
- **Fix:** Fallback ergänzen: „fehlt `SetText` → statischer Text ‚PLOT <Nr.>‘ per MCP-Property (C3); dynamische Infos nur im Plots-Tab S15“.

---

## Zusammenfassung Human-Test-Vorgabe (3 Tester, 2 Termine)
Grundsätzlich eingehalten (P-01, E-024, Tests Sa 31.10./Sa 28.11.). Verletzt oder gefährdet durch: R-10 (kein Ausweichtermin bei Chapter-8-Start), R-28 (Tester-Handy außerhalb der Termine als Fallback), R-29 (LP-Soft-Launch-Tagesplan nicht formell gestrichen). Test 1 ist ohne R-02 nicht messbar.

## Zusammenfassung Token-Effizienz
Gute Grundlage (Generatoren, `log_check.py`, `_context`-Protokoll, Autoplay statt Mikrotest). Größte Hebel: R-14 (Checkpoints, kleinere Blöcke), R-24 (aufgabengenaues `sed`), R-25/R-26 (Digest-/WebFetch-Begrenzung), R-31 (Parameter aus `economy_sim.P` exportieren statt abtippen), R-01 (Sim-Overrides statt Skript-Umbauten im Einzelfall).
