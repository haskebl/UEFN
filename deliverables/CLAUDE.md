# CLAUDE.md – FUSE THE BRAINROT (UEFN-Projekt `FuseTheBrainrot`)

Du bist der Bau-Agent für Luis’ Fortnite-UEFN-Insel „FUSE THE BRAINROT“. Luis hat 40 h/Woche, keine Blender-Kenntnisse und ein begrenztes Claude-Pro-Kontingent. Du arbeitest ohne Rückfragen nach dem Bauplan. Sprache mit Luis: Deutsch, kurz.

## 0. Shell (Windows)
- Deine Befehle laufen in **Git Bash** (bash-Syntax: `ls`, `grep`, `sed`, `find`, `cp`, Pfade mit `/`). PowerShell-Syntax (`$env:…`, `Get-ChildItem`, `&`) funktioniert dort **nicht**.
- PowerShell nur eingebettet: `powershell.exe -NoProfile -Command "<befehl>"` bzw. für Skripte `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/backup.ps1 -Milestone M1`.
- Windows-Pfade aus Umgebungsvariablen umwandeln: `"$(cygpath -u "$LOCALAPPDATA")"`, `"$(cygpath -u "$USERPROFILE")"`. Laufwerk C: = `/c/`.
- Blender: `BLENDER="/c/Program Files/Blender Foundation/Blender 4.2/blender.exe"` (echter Pfad in `_context/mcp_werkzeuge.md`), Aufruf `"$BLENDER" -b -P blender/gen_species_parts.py -- --out blender/out`.
- Python: `python` (winget-Installation; `python3` gibt es unter Windows evtl. nicht). Kokoro-TTS nur mit `/c/FTB_tts/Scripts/python.exe`.

## 1. Session-Start (immer, in dieser Reihenfolge, sonst nichts)
1. `_context/status.md` lesen (aktueller Meilenstein, nächste Aufgabe, Blocker). **Steht dort eine Zeile `Laufend:`, zuerst diese Aufgabe ab dem genannten Schritt fortsetzen** (§2a).
2. Nur wenn die Aufgabe es braucht: `_context/offene_fragen.md`, `_context/budgets.md`, `_context/api_digest.md`, `_context/mcp_werkzeuge.md` (gezielt per `grep`, nicht ganz).
3. Aus dem Plan **nur die Aufgaben des Blocks** – nie den ganzen Plan, nie den ganzen Meilenstein:
   `sed -n '/^#### M1-06a /,/^#### M1-07 /p' docs/BAUPLAN_Claude_Code.md` (Ende-Muster = nächste Aufgabe; Zeilennummer steht in `status.md`, Zeile „Nächste Aufgabe“).
   Meilenstein-Kopf (Ziel/Endzustand) nur in der ersten Session eines Meilensteins: `sed -n '/^## M3 ·/,/^#### M3-01 /p' docs/BAUPLAN_Claude_Code.md`. M0.1–M0.3 nur in M0-10…M0-17.
4. Anhänge nur zeilenweise: `grep -n "^| D07 " docs/BAUPLAN_Claude_Code.md`.
5. GDD (`docs/GDD_Fuse_and_Fight.md`) nur abschnittsweise per `sed -n '/^### 4.6/,/^### 4.7/p'`. Das GDD ist die Quelle der Wahrheit für Design, der Bauplan für Technik.

## 2. Token-Ökonomie (hart)
- Pro Session **ein Block aus 1–2 Aufgaben bzw. ≤ 3 h Plan-Dauer** desselben Meilensteins; danach Kontext aktualisieren, committen, Session beenden.
- Große Dateien nie in den Kontext laden (CSV, Logs, Digests, JSON-Antworten). Immer per Skript/`grep`/`head` filtern; breite Suchen erst in eine Datei unter `logs/` schreiben, dann `wc -l` + `head -25`.
- Logs **nur** über `python tools/log_check.py [--test|--perf|--build] [--since N]` (≤ 40 Zeilen).
- Keine ausführlichen Erklärungen in Antworten; Ergebnisse stehen in Dateien.
- Verse-Referenz-Skizzen (`docs/verse_reference/*.verse`) nur die Datei öffnen, an der du arbeitest.
- Kein Mikrotesten: kompilieren ja, spielen nur im Meilenstein-Selbsttest (Plan §2.2).
- WebFetch sparsam: nur wo der Plan es nennt, mit engem Prompt („nur X und Datum“), Obergrenze laut Aufgabe.

## 2a. Kontingent-Checkpoint (Claude-Pro-Limit kann mitten in einer Aufgabe enden)
Jede Aufgabe ist **fortsetzbar**. Checkpoints sind die **nummerierten Schritte** der Aufgabe (bei Batch-Arbeit zusätzlich nach jedem Batch).
1. **Nach jedem Schritt** in `_context/status.md` die Zeile ersetzen:
   `Laufend: M1-06a Schritt 3/4 · erledigt: <1 Satz> · nächster Befehl: <exakter Befehl> · Verse kompiliert: ja/nein/n. a.`
   und sofort committen: `git add -A && git commit -m "WIP M1-06a s3"` (UEFN vorher *Save All*; nie während „Push Changes“).
2. **Vor teuren Schritten** (MCP-Batch, Compile-Schleife, WebFetch, Blender-Lauf) zuerst den Checkpoint schreiben, dann ausführen.
3. **Merkt Claude Code, dass das Kontingent knapp wird** (lange Session, Warnung), wird kein neuer Schritt begonnen: Checkpoint schreiben, committen, Session beenden.
4. **Session-Start nach Abbruch:** `Laufend:` lesen → `git status` + `git log -1 --oneline` → ab dem genannten Schritt weiter; nichts neu erkunden, was im Checkpoint steht. Halb erledigte MCP-Batches: vorhandene Actors per Name/Tag zählen und nur den Rest platzieren (Schritte sind idempotent zu schreiben).
5. Aufgabe fertig → `Laufend:` löschen, normale Pflichten aus §7.

## 3. Unreal MCP
- Welche Werkzeuge es gibt und was sie können, steht in `_context/mcp_werkzeuge.md` (Matrix C1–C18 aus M0-03, dazu Device-Asset-Pfade D01–D19). Nicht erneut erkunden.
- **Bündeln:** viele Actors in einem Aufruf bzw. einer Schleife; Transforms vorher per Python berechnen (`tools/place_plots.py`), dann in Batches platzieren.
- Vor dem Ändern eines Devices die Property-Namen per MCP lesen (C15), nicht raten. Gefundene Namen in `mcp_werkzeuge.md` ergänzen.
- Fehlt eine MCP-Fähigkeit: erzeuge für Luis eine **Klickliste** (≤ 10 nummerierte Schritte, exakte Werte) und arbeite an der nächsten unabhängigen Aufgabe weiter.
- UEFN vor Git-Commits speichern (*Save All*); nie committen, während „Push Changes“ läuft.
- **UEFN-Updates:** Bei jedem Session-Start mit UEFN die Version (*Help → About* bzw. MCP) mit `mcp_werkzeuge.md` vergleichen. Neue Version → **M8-05-Rauchtest als erste Aufgabe** (Verse-Build, `python tools/log_check.py --build`, `AutoTest=201`), geänderte Signaturen in `api_digest.md` nachziehen, neue Version eintragen.

## 4. Nie raten
- Epic-API-Signaturen nur aus `_context/api_digest.md` oder direkt aus den `*.digest.verse`-Dateien. Nicht gefunden → Fallback aus dem Bauplan nehmen, als Entscheidung eintragen.
- Einstellungsnamen in Details-Panels: MCP-Property-Liste; sonst Klickliste für Luis mit dem Hinweis „UNVERIFIED“.
- Zahlen (Wirtschaft, Quoten, Layout) kommen aus dem GDD bzw. aus `data/*` über `tools/gen_verse_tables.py`. Keine Hand-Edits in `# BEGIN GEN … # END GEN`.
- Balance-Änderungen immer zuerst simulieren, **ohne das Skript zu ändern**: `python data/economy_sim.py --runs 10 --set key=wert [--set …]` (Werte als JSON, z. B. `--set pads_max=5`, `--set 'pad_costs=[150,3000,60000]'`) oder `--params <datei.json>`. Mit Overrides landet die CSV in `research/sim/`; die Referenz `data/economy_sim_output.csv` wird nie überschrieben. Übernahme in Verse: dieselben Overrides + `--dump-json data/econ_params.json`, dann Generator. `--show-params` zeigt die Tabelle.
- Nur wenn es **keinen** Fallback gibt: Frage in `_context/offene_fragen.md` (mit Vorschlag + Frist) und weiter mit der nächsten Aufgabe.

## 5. Verse-Regeln
- Genau 11 Dateien in `Content/Verse/`: `ftb_types, ftb_save, ftb_economy, ftb_fusion, ftb_creature_pool, ftb_combat, ftb_ui, ftb_shop_iit, ftb_time, ftb_events, ftb_game_manager` (`.verse`). Nur `ftb_game_manager` ist ein `creative_device`.
- Logging-Format `[FTB][LEVEL][MOD] schluessel=wert`; keine Logs und keine Saves im Tick; Schleifenraten laut Budget B15; kein `Sleep(0.0)` außer Frame-Probe (Debug).
- Save-Schema: eine Root-Klasse, eine weak_map, zweite weak_map **nicht** anlegen. Nach dem Freeze (Di 10.11.2026) nur Felder mit Literal-Default **anhängen**.
- Vor jedem Meilenstein-Commit Checkliste Plan §4.8.

## 6. Assets
- 3D nur per Blender headless (Git Bash, §0): `"$BLENDER" -b -P blender/<skript>.py -- <parameter>`. Namensschema `SM_FTB_<Art>_<Head|Body|Accessory>`. Import-Einstellungen Plan §5.3 (nur `blender/out/fbx/*.fbx`, nie `fbx_lod/` als eigene Assets).
- Keine gekauften Assets, keine fremde IP, keine Namen aus der Sperrliste (GDD Anhang A). Nur Werkzeuge aus Plan Anhang W.

## 7. Nach jeder Aufgabe (Pflicht, kurz)
1. `_context/status.md` **überschreiben** (≤ 40 Zeilen: Meilenstein, erledigt, nächste Aufgabe **mit Zeilennummer** (`grep -n "^#### M1-07 " docs/BAUPLAN_Claude_Code.md`), Blocker, letzte Messwerte; `Laufend:` entfernen).
2. Neue Entscheidungen an `_context/entscheidungen.md` **anhängen** (eine Zeile: ID, Datum, Entscheidung, Grund, Quelle).
3. Geklärte Fragen in `offene_fragen.md` auf „erledigt“ setzen (mit Antwort).
4. `git add -A && git commit -m "M<n>-<nn>: <titel>"` – in M0 auf Zweig **`spike/m0`**, ab M1 auf **`dev`**.
5. Am Meilenstein-Ende zusätzlich: Budgets eintragen, `playtests.md` (Selbsttest), Backup + Merge + Tag (Plan §6.4).

## 8. Grenzen
- Kein Publish, keine Einreichung, keine Portal-Änderungen, keine Käufe – das macht Luis.
- Keine Löschung von Content außerhalb der aktuellen Aufgabe; Spike-Reste nur in M0-17.
- Termine: Test 1 Sa 31.10., Feature-Freeze So 15.11., Test 2 Sa 28.11. (Ausweichtermin Fr 27.11. oder So 29.11. ersetzt ihn nur bei Ausfall), Einreichung Do 03.12.2026.
- Menschen-Tests: nur 3 Tester an 2 Terminen – keine zusätzlichen Tester-Sessions einplanen.
