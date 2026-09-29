# Playtests und Selbsttests

## Regeln
- Claude Code testet **nur am Meilenstein-Ende** (Autoplay-Szenarien, Plan Anhang T) plus ≤ 15 min Sichtprüfung durch Luis.
- Menschen-Tests: **Test 1 Sa 31.10.2026** (Kernschleife), **Test 2 Sa 28.11.2026** (Release Candidate; Ausweichtermin Fr 27.11. oder So 29.11. **ersetzt** den 28.11. nur bei Ausfall, Q-REL-2). 3 Tester + Luis. Keine weiteren Tester-Termine.
- In privaten Versionen sind Logs nicht lesbar → Messung über **Test-Report** (Menü-Terminal → „TEST-REPORT“, sichtbar bei `TestReportEnabled=true`; ab M5 zusätzlich Code `TESTREPORT`), Stoppuhr und Beobachtung.

---

## Thumbnail-Klick-Test (Frist So 11.10.; Mockups aus M0-07b bis Mi 07.10. 18:00)
| Motiv | Stimmen | Anteil | Beste Vergleichs-Insel (Stimmen) | Ergebnis |
|---|---|---|---|---|
| mock_A (A + B = Hybrid) | | | | |
| mock_B (Hybrid-Trio vs. Boss) | | | | |
| mock_C (Winter) | | | | |
Kill-Regel (GDD 14.1): alle eigenen < 50 % der besten Vergleichsrate → Branding überarbeiten.

---

## Selbsttests
<!-- Vorlage je Meilenstein:
### Selbsttest M<n> (<Datum>)
- AT-…: PASS/FAIL (Kurzinfo)
- 16B: Δp95 = … ms, Hänger/min = …
- Luis-Sichtprüfung: …
- Budgets: siehe budgets.md Spalte M<n>
-->

---

## Test 1 – Sa 31.10.2026 (Kernschleife)
**Build:** Tag `m3-test1` (private Version, `DebugMode=false`, `TestReportEnabled=true`) · **Tester:** T1 (PC/Maus), T2 (Konsole/Controller), T3 (Handy/Touch; Touch vorher per Rauchtest M3-11 geprüft) + Luis
**Ablauf (13:00–16:00):** 13:00 Einzel-Session ohne Hilfe – **Tester dürfen jederzeit aufhören**, Stoppuhr bis zum freiwilligen Ende, Obergrenze 60 min (Discord-Stream) → 14:05 Koop-Session 45 min (Boss gemeinsam) → 14:55 Test-Report-Screenshot (**Menü-Terminal → TEST-REPORT**) → 15:00 Fragebogen.
**Tester-Anleitung (wörtlich):** „Spiel, als hättest du die Insel in Discover gefunden. Sag laut, was du denkst. Ich helfe nicht, außer du steckst 2 Minuten fest.“

### Messbogen
| Messung | Ziel (GDD 14.1) | T1 | T2 | T3 | Erfüllt? |
|---|---|---|---|---|---|
| Zeit bis erste Kreatur | < 0:30 | | | | |
| Zeit bis erstes Upgrade | < 2:00 | | | | |
| Zeit bis erste Fusion (gestartet) | < 5:00 | | | | |
| Zweite Fusion ohne Aufforderung | ≥ 2 von 3 | | | | |
| Session-Länge Einzel bis zum **freiwilligen** Ende (max. 60 min) | Median > 20 min | | | | |
| Kampf-Spaß (1–5) | ≥ 4 bei ≥ 2 | | | | |
| Perfekt-Quote Hype-Takt (Test-Report) | ≥ 15 % | | | | |
| Stellen, an denen gefragt/gestockt wurde (Minute + was) | – | | | | |
| Bugs (Minute + was) | 0 Blocker | | | | |

### Fragebogen (5 + 2 Fragen)
1. Was war das Coolste? 2. Was nervt? 3. Welchen Hybriden würdest du jemandem zeigen? 4. Würdest du morgen weiterspielen? 5. Hast du an einen Kauf gedacht – warum (nicht)? 6. Kampf-Spaß 1–5? 7. Würdest du freiwillig noch mal fusionieren – warum?

### Auswertung / Entscheidung (M4-03)
<!-- Ziele verfehlt: … → Entscheidung: … (auch in entscheidungen.md) -->
Hinweis: Die GDD-5.9-Regel „Verlassen zwischen 60 und 120 min → Rebirth 150M“ ist mit Test 1 nicht messbar (Obergrenze 60 min) → Entscheidung nach Launch über Analytics `session_min_30` / Portal-Spielzeit.

---

## Test 2 – Sa 28.11.2026 (Release Candidate)
**Build:** Tag `m7-rc1` (private Version ab Mo 23.11.) · Plattformen wie Test 1
**Termin:** Sa 28.11. · Ausweichtermin (vorab in M0-01b vereinbart, ersetzt den 28.11. nur bei Ausfall): _____ (Fr 27.11. 17:00–21:00 oder So 29.11. 11:00–18:30)
**Ablauf:** Session 1 11:00–12:30 → Save-Notiz (Münzen, Kerne, Anzahl Kreaturen, Index) → Session 2 17:00–18:30 (darin 18:00 Koop-Boss mit allen 4) → Save-Vergleich → Fragebogen + Test-Report. (Fr 27.11.: Session 1 17:00–18:15, Session 2 19:45–21:00, Boss 20:30.)

### Go/No-Go (Plan M8-03 + GDD 14.1; LP 4.2 „Rückkehr Tag 2“ nur Info)
| Kriterium | T1 | T2 | T3 | Luis | Ergebnis |
|---|---|---|---|---|---|
| Kein Blocker | | | | | |
| Kein Save-Verlust (Session 1 → 2 identisch) | | | | | |
| Kein Absturz | | | | | |
| Erste Fusion < 5 min | | | | | |
| Controller-Durchlauf komplett (T2) | | | | | |
| Touch-Durchlauf komplett (T3) | | | | | |
| IIT-Flows (M7-07) ok | | | | | |
| Private Saves getrennt von Edit-Session? (Info) | | | | | |
| Info: Tester am Folgetag von selbst zurück? (kein Kriterium) | | | | | |
**Entscheidung (spätestens Mo 30.11.):** Go → Einreichung Do 03.12. · No-Go → Fix, Einreichung spätestens Mo 07.12.
