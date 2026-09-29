# CLAUDE.md – FUSE THE BRAINROT (UEFN-Projekt `FuseTheBrainrot`)

Du bist der Bau-Agent für Luis’ Fortnite-UEFN-Insel „FUSE THE BRAINROT“. Luis hat 40 h/Woche, keine Blender-Kenntnisse und ein begrenztes Claude-Pro-Kontingent. Du arbeitest ohne Rückfragen nach dem Bauplan. Sprache mit Luis: Deutsch, kurz.

## 1. Session-Start (immer, in dieser Reihenfolge, sonst nichts)
1. `_context/status.md` lesen (aktueller Meilenstein, nächste Aufgabe, Blocker).
2. Nur wenn die Aufgabe es braucht: `_context/offene_fragen.md`, `_context/budgets.md`, `_context/api_digest.md`, `_context/mcp_werkzeuge.md` (gezielt per `grep`, nicht ganz).
3. Den Abschnitt des aktuellen Meilensteins aus dem Plan – **nie den ganzen Plan**:
   `sed -n '/^## M3 ·/,/^## M4 ·/p' docs/BAUPLAN_Claude_Code.md` (für M8: Ende-Muster `/^## Anhang D/`).
4. Anhänge nur zeilenweise: `grep -n "^| D07 " docs/BAUPLAN_Claude_Code.md`.
5. GDD (`docs/GDD_Fuse_and_Fight.md`) nur abschnittsweise per `sed -n '/^### 4.6/,/^### 4.7/p'`. Das GDD ist die Quelle der Wahrheit für Design, der Bauplan für Technik.

## 2. Token-Ökonomie (hart)
- Pro Session **ein Block aus 2–4 Aufgaben** desselben Meilensteins; danach Kontext aktualisieren, committen, Session beenden.
- Große Dateien nie in den Kontext laden (CSV, Logs, Digests, JSON-Antworten). Immer per Skript/`grep`/`head` filtern.
- Logs **nur** über `python tools/log_check.py [--test|--perf|--build] [--since N]` (≤ 40 Zeilen).
- Keine ausführlichen Erklärungen in Antworten; Ergebnisse stehen in Dateien.
- Verse-Referenz-Skizzen (`docs/verse_reference/*.verse`) nur die Datei öffnen, an der du arbeitest.
- Kein Mikrotesten: kompilieren ja, spielen nur im Meilenstein-Selbsttest (Plan §2.2).

## 3. Unreal MCP
- Welche Werkzeuge es gibt und was sie können, steht in `_context/mcp_werkzeuge.md` (Matrix C1–C17 aus M0-03). Nicht erneut erkunden.
- **Bündeln:** viele Actors in einem Aufruf bzw. einer Schleife; Transforms vorher per Python berechnen (`tools/place_plots.py`), dann in Batches platzieren.
- Vor dem Ändern eines Devices die Property-Namen per MCP lesen (C15), nicht raten. Gefundene Namen in `mcp_werkzeuge.md` ergänzen.
- Fehlt eine MCP-Fähigkeit: erzeuge für Luis eine **Klickliste** (≤ 10 nummerierte Schritte, exakte Werte) und arbeite an der nächsten unabhängigen Aufgabe weiter.
- UEFN vor Git-Commits speichern (*Save All*); nie committen, während „Push Changes“ läuft.

## 4. Nie raten
- Epic-API-Signaturen nur aus `_context/api_digest.md` oder direkt aus den `*.digest.verse`-Dateien. Nicht gefunden → Fallback aus dem Bauplan nehmen, als Entscheidung eintragen.
- Einstellungsnamen in Details-Panels: MCP-Property-Liste; sonst Klickliste für Luis mit dem Hinweis „UNVERIFIED“.
- Zahlen (Wirtschaft, Quoten, Layout) kommen aus dem GDD bzw. aus `data/*` über `tools/gen_verse_tables.py`. Keine Hand-Edits in `# BEGIN GEN … # END GEN`.
- Balance-Änderungen immer zuerst in `data/economy_sim.py --params …` simulieren.
- Nur wenn es **keinen** Fallback gibt: Frage in `_context/offene_fragen.md` (mit Vorschlag + Frist) und weiter mit der nächsten Aufgabe.

## 5. Verse-Regeln
- Genau 11 Dateien in `Content/Verse/`: `ftb_types, ftb_save, ftb_economy, ftb_fusion, ftb_creature_pool, ftb_combat, ftb_ui, ftb_shop_iit, ftb_time, ftb_events, ftb_game_manager` (`.verse`). Nur `ftb_game_manager` ist ein `creative_device`.
- Logging-Format `[FTB][LEVEL][MOD] schluessel=wert`; keine Logs und keine Saves im Tick; Schleifenraten laut Budget B15; kein `Sleep(0.0)` außer Frame-Probe (Debug).
- Save-Schema: eine Root-Klasse, eine weak_map, zweite weak_map **nicht** anlegen. Nach dem Freeze (Di 10.11.2026) nur Felder mit Literal-Default **anhängen**.
- Vor jedem Meilenstein-Commit Checkliste Plan §4.8.

## 6. Assets
- 3D nur per Blender headless: `& "<blender.exe>" -b -P blender\<skript>.py -- <parameter>` (Pfad in `mcp_werkzeuge.md`). Namensschema `SM_FTB_<Art>_<Head|Body|Accessory>`. Import-Einstellungen Plan §5.3.
- Keine gekauften Assets, keine fremde IP, keine Namen aus der Sperrliste (GDD Anhang A). Nur Werkzeuge aus Plan Anhang W.

## 7. Nach jeder Aufgabe (Pflicht, kurz)
1. `_context/status.md` **überschreiben** (≤ 40 Zeilen: Meilenstein, erledigt, nächste Aufgabe, Blocker, letzte Messwerte).
2. Neue Entscheidungen an `_context/entscheidungen.md` **anhängen** (eine Zeile: ID, Datum, Entscheidung, Grund, Quelle).
3. Geklärte Fragen in `offene_fragen.md` auf „erledigt“ setzen (mit Antwort).
4. `git add -A && git commit -m "M<n>-<nn>: <titel>"` auf Zweig `dev`.
5. Am Meilenstein-Ende zusätzlich: Budgets eintragen, `playtests.md` (Selbsttest), Backup + Merge + Tag (Plan §6.4).

## 8. Grenzen
- Kein Publish, keine Einreichung, keine Portal-Änderungen, keine Käufe – das macht Luis.
- Keine Löschung von Content außerhalb der aktuellen Aufgabe; Spike-Reste nur in M0-17.
- Termine: Test 1 Sa 31.10., Feature-Freeze So 15.11., Test 2 Sa 28.11., Einreichung Do 03.12.2026.
