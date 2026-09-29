# `_context/` – Protokoll (Gedächtnis zwischen Claude-Code-Sessions)

Dieser Ordner ist das **einzige** Langzeitgedächtnis. Jede Session beginnt hier und endet hier. Ziel: minimale Tokens pro Session, keine verlorenen Entscheidungen.

## Dateien
| Datei | Inhalt | Schreibweise | Max. Länge |
|---|---|---|---|
| `status.md` | Wo stehen wir? Meilenstein, letzte/nächste Aufgabe (mit Plan-Zeilennummer), **`Laufend:`-Checkpoint**, Blocker, Muss-Termine, letzte Messwerte, Wartet-auf-Luis | **überschreiben** (Zeile `Laufend:` nach jedem Schritt ersetzen) | 40 Zeilen |
| `entscheidungen.md` | Alle Entscheidungen (Recherche, Luis, Plan, Spike-Ergebnisse, Fallbacks) | **anhängen**, nie löschen; Revision als neue Zeile „ersetzt E-xxx“ | unbegrenzt, 1 Zeile je Eintrag |
| `offene_fragen.md` | Offene Punkte mit Verantwortlichem und Frist | Status ändern (offen → erledigt + Antwort) | – |
| `playtests.md` | Selbsttests je Meilenstein, Test 1, Test 2, Thumbnail-Test | anhängen | – |
| `budgets.md` | Harte Grenzen + Messwerte je Meilenstein | Spalte je Meilenstein füllen | – |
| `mcp_werkzeuge.md` | (ab M0-03) MCP-Werkzeuge, Fähigkeitsmatrix C1–C18 (+ C5b), Device-Asset-Pfade D01–D19, Pfade (Log, Blender, Backup), UEFN-Version, gefundene Property-Namen | ergänzen | 120 Zeilen |
| `api_digest.md` | (ab M0-04) Verse-Signaturen aus den Digests | ergänzen | 150 Zeilen |
| `regeln_digest.md` | (ab M0-06) Epic-Regeln verdichtet | ergänzen | 60 Zeilen |

## Ablauf je Session
1. **Lesen:** `status.md` (erst `Laufend:` fortsetzen) → (bei Bedarf gezielt) andere Dateien → **nur die Aufgaben des Blocks** aus dem Bauplan per `sed` (aufgabengenau, `CLAUDE.md` §1).
2. **Arbeiten:** Aufgabenblock (1–2 Aufgaben bzw. ≤ 3 h Plan-Dauer). **Kontingent-Checkpoint nach jedem nummerierten Schritt** (`CLAUDE.md` §2a): Zeile `Laufend: <Aufgabe> Schritt n/m · erledigt … · nächster Befehl …` in `status.md` + `git commit -m "WIP <Aufgabe> s<n>"`.
3. **Schreiben:** `status.md` überschreiben (`Laufend:` entfernen); Entscheidungen anhängen; Fragen aktualisieren; bei Messungen `budgets.md`; bei Tests `playtests.md`.
4. **Commit** (`M<n>-<nn>: …`; M0 auf `spike/m0`, danach `dev`).

## Formate
- Entscheidung: `| E-0xx | 2026-10-06 | <Entscheidung> | <Grund/Messwert> | <Quelle: Plan §/GDD §/Messung/Luis> |`
- Frage: `| Q-<BEREICH>-<n> | <Frage> | <Wer> | <Frist> | offen/erledigt | <Antwort> |`
- Selbsttest: `### Selbsttest M<n> (<Datum>)` + Zeilen `AT-… PASS/FAIL`, Sichtprüfung Luis (Stichpunkte), Budget-Verweis.

## Regeln
- Nichts doppelt speichern: Details stehen im Bauplan/GDD; hier nur Stand, Entscheidungen, Messwerte.
- Keine Log-Auszüge > 10 Zeilen hier ablegen.
- Luis darf jede Datei lesen und ändern; seine Einträge haben Vorrang (mit „Luis:“ markieren).
