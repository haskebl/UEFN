# Playtests und Selbsttests

## Regeln
- Claude Code testet **nur am Meilenstein-Ende** (Autoplay-Szenarien, Plan Anhang T) plus ≤ 15 min Sichtprüfung durch Luis.
- Menschen-Tests: **Test 1 Sa 31.10.2026** (Kernschleife), **Test 2 Sa 28.11.2026** (Release Candidate). 3 Tester + Luis.
- In privaten Versionen sind Logs nicht lesbar → Messung über **Test-Report** (Code `TESTREPORT`), Stoppuhr und Beobachtung.

---

## Thumbnail-Klick-Test (Frist So 11.10.)
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
**Build:** Tag `m3-test1` (private Version) · **Tester:** T1 (PC/Maus), T2 (Konsole/Controller), T3 (Handy/Touch) + Luis
**Ablauf:** 13:00 Einzel-Session 45 min ohne Hilfe (Discord-Stream, Stoppuhr) → 13:50 Koop-Session 45 min (Boss gemeinsam) → 14:40 Test-Report-Screenshot → 14:45 Fragebogen.
**Tester-Anleitung (wörtlich):** „Spiel, als hättest du die Insel in Discover gefunden. Sag laut, was du denkst. Ich helfe nicht, außer du steckst 2 Minuten fest.“

### Messbogen
| Messung | Ziel (GDD 14.1) | T1 | T2 | T3 | Erfüllt? |
|---|---|---|---|---|---|
| Zeit bis erste Kreatur | < 0:30 | | | | |
| Zeit bis erstes Upgrade | < 2:00 | | | | |
| Zeit bis erste Fusion (gestartet) | < 5:00 | | | | |
| Zweite Fusion ohne Aufforderung | ≥ 2 von 3 | | | | |
| Session-Länge Einzel (freiwillig weitergespielt?) | Median > 20 min | | | | |
| Kampf-Spaß (1–5) | ≥ 4 bei ≥ 2 | | | | |
| Perfekt-Quote Hype-Takt (Test-Report) | ≥ 15 % | | | | |
| Stellen, an denen gefragt/gestockt wurde (Minute + was) | – | | | | |
| Bugs (Minute + was) | 0 Blocker | | | | |

### Fragebogen (5 + 2 Fragen)
1. Was war das Coolste? 2. Was nervt? 3. Welchen Hybriden würdest du jemandem zeigen? 4. Würdest du morgen weiterspielen? 5. Hast du an einen Kauf gedacht – warum (nicht)? 6. Kampf-Spaß 1–5? 7. Würdest du freiwillig noch mal fusionieren – warum?

### Auswertung / Entscheidung (M4-03)
<!-- Ziele verfehlt: … → Entscheidung: … (auch in entscheidungen.md) -->

---

## Test 2 – Sa 28.11.2026 (Release Candidate)
**Build:** Tag `m7-rc1` (private Version ab Mo 23.11.) · Plattformen wie Test 1
**Ablauf:** Session 1 11:00–12:30 → Save-Notiz (Münzen, Kerne, Anzahl Kreaturen, Index) → Session 2 17:00–18:30 → Save-Vergleich → 18:00 Koop-Boss mit allen 4 → Fragebogen + Test-Report.

### Go/No-Go (LP 4.2 + GDD 14.1)
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
**Entscheidung:** Go → Einreichung Do 03.12. · No-Go → Fix, Einreichung spätestens Mo 07.12.
