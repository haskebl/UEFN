# BAUPLAN (Phase G): FUSE THE BRAINROT für lokales Claude Code + Unreal MCP

**Projekt:** UEFN-Insel `FuseTheBrainrot` von Luis (Creator „haske“) · **Stand:** 29.09.2026 · **Plan-Version:** G1.0
**Quelle der Wahrheit für Design:** `docs/GDD_Fuse_and_Fight.md` (im Repo; Original: `deliverables/GDD_Fuse_and_Fight.md`). Dieser Bauplan legt fest, **wie** gebaut wird. Bei Widerspruch zum Design gilt das GDD, außer eine Zeile unten steht ausdrücklich unter „Plan-Entscheidung“ (sie ist dann auch in `_context/entscheidungen.md` eingetragen).
**Weitere Quellen:** `docs/Launch_Plan_Phase_H.md` (Termine: **Einreichung Do 03.12.2026**, **Publish Do 10.12.2026 16:00 MEZ**), `research/uefn_feasibility.md`, `research/red_team_review.md`, `data/*` (Katalog, Namen, `economy_sim.py`), Referenz-Code `deliverables/verse_reference/ftb_*.verse`, Blender-Skripte `deliverables/blender/` (`gen_species_parts.py`, `export_fbx.py`, `materials_spec.md`, `README.md`).

> **Für Claude Code: Diese Datei NIE ganz lesen.** Pro Session nur `_context/*` (siehe `CLAUDE.md`) plus den Abschnitt des aktuellen Meilensteins, z. B.:
> `sed -n '/^## M2 ·/,/^## M3 ·/p' docs/BAUPLAN_Claude_Code.md`
> Für M8 lautet das Ende-Muster `/^## Anhang D/`. Querverweise auf Anhänge (Devices `D..`, Assets `A..`, Szenarien `AT-..`) gezielt per `grep -n "^| D07 " docs/BAUPLAN_Claude_Code.md` nachschlagen. Kapitel 1–7 nur lesen, wenn eine Aufgabe ausdrücklich darauf verweist.

---

## Inhalt
1. Zeitplan und Meilensteine (Übersicht)
2. Aufgaben-Schema, Teststufen, Autoplay-Selbsttest
3. Budgets mit harten Grenzen
4. Verse-Architektur
5. Asset-Pipeline (Blender → UEFN, Material, Audio, VFX, UI)
6. Projektstruktur und Git
7. Kontext-Pflege (`_context/`-Protokoll) und Arbeitsweise
- **M0 · Setup, Tech-Spikes, Datenprüfung**
- **M1 · Graybox-Kernschleife (1 Spieler)**
- **M2 · Fusion, Index, Namen, Look**
- **M3 · Kampf: Wellen, Hype-Takt, Boss v1 (Test-1-Build)**
- **M4 · Test 1 und Kern-Iteration**
- **M5 · Meta, Live-Ops-Technik, IIT, Save-Freeze**
- **M6 · Inhalt, Juice, Feature-Freeze**
- **M7 · Polish, Performance, Plattformen (RC-Kandidat)**
- **M8 · Release Candidate, Test 2, Einreichung**
- Anhang D · Device-Katalog
- Anhang A · Asset-Katalog
- Anhang T · Autoplay-Szenarien und Log-Format
- Anhang W · Werkzeuge und Lizenzen
- Anhang L · Aufgaben für Luis (Gesamtliste mit Datum)

---

## 1. Zeitplan und Meilensteine

Heute ist Di 29.09.2026. Bau-Start ist **Do 01.10.2026**. Luis hat **40 h/Woche**. Claude-Code-Kontingent (Claude Pro) ist der Engpass: Richtwert **2 Sessions pro Tag**, je Session **ein Block aus 2–4 Aufgaben**.

| MS | Zeitraum (KW) | Ergebnis (spielbar, selbst getestet) | Gate / Abnahme | Claude-Sessions (Richtwert) | Luis-Stunden (Richtwert) |
|---|---|---|---|---|---|
| **M0** | Do 01.10. – Di 06.10. (KW 40–41) | Repo, MCP, Digest-Fakten, Markt-/Regel-Check, **Spike** (Anzeige-Varianten A/B/C, Material, WPO, MoveTo, Feuer-Taste, Save, Zeit-API) gemessen | **G0 Di 06.10.:** Kill-/Fallback-Entscheidung nach Tabelle M0.3 | 8–10 | 14 |
| **M1** | Mi 07.10. – Di 13.10. (KW 41–42) | Graybox: 1 Spieler spawnt auf eigenem Plot, Starter-Ei, Eier kaufen, brüten, Pads, Einkommen, Level-Up, Totem, Stall, Speichern/Laden | **G1:** AT-M1 grün, Rejoin-Zustand identisch | 10–12 | 8 |
| **M2** | Mi 14.10. – Di 20.10. (KW 42–43) | Fusion mit Vorschau + Reveal, Namens-Lookup + TTS-Chant, Index, alle 24 Teile + Icons + 7 Seltenheits-MIs, 16 Plots parallel | **G2:** AT-M2 grün, 16B-Messung grün | 10–12 | 6 |
| **M3** | Mi 21.10. – Do 29.10. (KW 43–44) | Wellen, Gegner, Hype-Takt, Drops, Boss B1 (Koop), Musik-Basis, Analytics, Tutorial bis Boss | **G3 Do 29.10.:** Test-1-Build als private Version hochgeladen | 12–14 | 8 |
| **M4** | Fr 30.10. – Mi 04.11. (KW 44–45) | **Test 1 Sa 31.10.** (3 Tester, Kernschleife), Auswertung, Balancing, Fixes | **G4:** Kill-Kriterien Test 1 (GDD 14.1) bewertet, Fixes drin | 6–8 | 12 |
| **M5** | Do 05.11. – Di 10.11. (KW 45–46) | Rebirth, Tagesbelohnung/Streak, Codes, Event-Kalender-Technik, IIT-Shop, Rückkehr-Bonus, Dösen | **G5 Di 10.11.: Save-Schema-Freeze** | 10–12 | 5 |
| **M6** | Mi 11.11. – So 15.11. (KW 46) | Bosse B2/B3 + 4 Varianten, 8 Event-Wochen als Daten, Hub, Plot-Themen, Juice, Audio, Optionen | **G6 So 15.11.: Feature-Freeze** | 8–10 | 5 |
| **M7** | Mo 16.11. – So 22.11. (KW 47) | Performance/Speicher final, Controller, Touch/Mobile, DE/EN, Zeit-Unlock-Tests, IIT-Debugtest | **G7 So 22.11.:** RC-Kandidat, private Version Mo 23.11. | 8–10 | 10 |
| **M8** | Mo 23.11. – Do 03.12. (KW 48–49) | **Test 2 Sa 28.11.** (RC), Fixes, Debug aus, Store-Seite, **Einreichung Do 03.12.** | **G8:** Go/No-Go (Launch-Plan 4.2) → eingereicht | 6–8 | 14 |
| Launch | Do 10.12. 16:00 MEZ | Publish, Event-Woche W1 läuft zeitgesteuert | Launch-Plan Phase H | – | – |

**Feste Termine:** Test 1 **Sa 31.10.2026**, Feature-Freeze **So 15.11.2026**, Test 2 **Sa 28.11.2026**, Einreichung **Do 03.12.2026** (Puffer bis spätestens Mo 07.12., Launch-Plan 4.2), Publish **Do 10.12.2026**.
**Plan-Entscheidung P-01:** Der Blindtest 16.–22.11. aus dem Launch-Plan entfällt zugunsten von Luis’ Vorgabe „3 Tester an 2 Terminen“. Die private Version ab Mo 23.11. dürfen die Tester frei spielen (optional, kein Pflichttermin).

**Puffer-Regel:** Jeder Meilenstein darf höchstens 1 Tag überziehen. Überzieht er mehr, greift die Schnittliste (GDD 16.4) in dieser Reihenfolge: Bonus-Arten → Anfeuern → Lokalisierung EN → Boss-Varianten W5/W7 → Kamera-Shake → Event-Wochen 5–8 als Rotation. **Nie geschnitten:** Fusion mit Vorschau, Wellen, 1 Boss, Save, faire IIT, Tutorial.

---

## 2. Aufgaben-Schema, Teststufen, Autoplay-Selbsttest

### 2.1 Aufgaben-Schema (jede Aufgabe ≤ ~2 h)

```
#### M<n>-<nn> · <Titel> (<Dauer>) [Wer: CC | Luis | CC+Luis]
- Abh.:     Aufgaben-IDs, die fertig sein müssen
- Dateien:  exakte Pfade (Verse unter Content/Verse/, Tools unter tools/)
- Devices:  Katalog-ID aus Anhang D + Anzahl + Abweichungen vom Katalog
- Assets:   Katalog-ID aus Anhang A oder Dateiname/Ordner/Format
- Schritte: nummeriert, ausführbar ohne Rückfrage
- Abnahme:  messbar (Zahl, Log-Zeile, Zustand)
- Test:     S=Solo · 2P=zwei Spieler · 16B=16 Bot-Plots · C=Controller · M=Mobile Preview
            (ausgeführt im Meilenstein-Selbsttest, nicht sofort)
- API:      VERIFIED / UNVERIFIED (+ Fallback)
```

**Status-Labels für APIs:**
- **VERIFIED** = in offizieller Epic-Doku belegt **oder** in M0-04 im Verse-Digest gefunden (dann „VERIFIED (Digest)“). `_context/api_digest.md` ist ab M0 die Referenz für Signaturen.
- **UNVERIFIED** = nicht belegt (auch „LIKELY“ aus der Recherche zählt hier als UNVERIFIED). **Jede** UNVERIFIED-Stelle hat einen Fallback. Claude Code rät keine Signaturen: erst `api_digest.md`, dann Digest-Grep, dann Fallback.
- Einstellungsnamen in UEFN-Details-Panels, die nicht belegt sind, stehen als: *„UNVERIFIED – prüfe im Details-Panel; Fallback: …“*. Findet Claude Code den Namen per MCP (Property-Liste des Actors), trägt es ihn in `_context/mcp_werkzeuge.md` ein.

### 2.2 Teststufen (kein Dauer-Mikrotesten)

| Stufe | Wann | Wer | Wie |
|---|---|---|---|
| **Kompilieren** | nach jeder Verse-Änderung (billig) | CC | Verse-Build per MCP; Fallback: Luis klickt *Verse → Build Verse Code*, CC liest Fehler aus dem Log (`tools/log_check.py --build`) |
| **Meilenstein-Selbsttest** | **nur am Meilenstein-Ende** (1 Session) | CC (+ Luis 2 Klicks + ≤ 15 min Sichtprüfung) | Session starten, Autoplay-Szenarien (Anhang T) laufen im Server-Verse, CC wertet nur `[FTB]`-Logzeilen aus |
| **Messlauf 16B** | M0, M2, M3, M6, M7 | CC | `BotPlots=16`: 15 Plots ohne Spieler laufen mit voller Anzeige, Wellen und Boss; Frame-Zeit-Probe misst Server-Last |
| **Menschen-Test** | **Sa 31.10.** und **Sa 28.11.** | Luis + 3 Tester | Protokoll in `_context/playtests.md` |

**Warum Autoplay:** Claude Code kann den Fortnite-Client nicht bedienen. Deshalb enthält `ftb_game_manager.verse` einen Debug-Harness (nur bei `DebugMode = true`): Er steuert den Plot des ersten Spielers über dieselben Service-Funktionen wie die UI (Ei kaufen, brüten, fusionieren, Welle starten …), beschleunigt Zeit über `DebugTimeScale` und schreibt pro Prüfung **eine** Logzeile `[FTB][TEST][<ID>] PASS|FAIL <Kurzinfo>`. Luis muss nur die Session starten und im Client stehen bleiben.

**Session-Start für Selbsttests (Fallback, falls MCP keine Session starten kann):** Luis klickt in UEFN *Launch Session* (bzw. *Push Changes*, wenn die Session schon läuft) und wartet, bis er im Spiel ist. Dann schreibt er „läuft“ an Claude Code. Nach Ende des Szenarios (CC meldet) beendet Luis die Session.

**Log-Datei:** UEFN schreibt Verse-`Print`/`log`-Ausgaben ins Output Log. Pfad UNVERIFIED – vermutlich `%LOCALAPPDATA%\UnrealEditorFortnite\Saved\Logs\UnrealEditorFortnite.log`; M0-03 findet den echten Pfad (`Get-ChildItem $env:LOCALAPPDATA -Recurse -Filter *.log | Sort LastWriteTime -Desc | Select -First 5`) und trägt ihn in `_context/mcp_werkzeuge.md` ein. Fallback: Luis kopiert das Output-Log-Fenster (Filter „FTB“) in `logs/manual_<datum>.txt`.

### 2.3 Teststufen je Kanal
- **S (Solo):** immer per Autoplay.
- **2P:** Luis mit zweitem Epic-Konto auf zweitem Gerät in derselben Session. Ob ein zweites Konto einer UEFN-Edit-Session beitreten kann, ist UNVERIFIED (M0-15 prüft). Fallback: 2P erst im privaten Playtest-Build (M3 Ende) und an den Testtagen.
- **16B:** Bot-Plots, siehe oben. Echte 16 Spieler gibt es erst nach dem Launch; das ist akzeptiertes Risiko (P-02).
- **C (Controller):** Luis schließt ein Gamepad an den PC an. Pflicht in M0 (Probe), M3, M7, M8.
- **M (Mobile Preview):** UEFN-Mobile-Preview (v39+, Menüpfad UNVERIFIED – prüfe unter *Launch Session*-Optionen bzw. Editor-Einstellungen; Fallback: private Version auf Luis’ Handy mit Fortnite-App, falls Fortnite dort verfügbar, sonst an Testtag 2 über einen Tester mit Handy). Pflicht in M7, M8.

---

## 3. Budgets mit harten Grenzen

Claude Code prüft **jede Zeile** am Ende jedes Meilensteins und trägt Messwerte in `_context/budgets.md` ein (Spalte des Meilensteins). **ROT = Meilenstein nicht abgeschlossen**, bis Fallback angewendet ist.

| # | Budget | Grün (Ziel) | Gelb (Fallback planen) | Rot (harte Grenze) | Messmethode |
|---|---|---|---|---|---|
| B1 | Speicher gesamt (Launch Memory Calculation) | ≤ 45.000 | 45.001–70.000 | > 70.000 (Projektion) | *Project → Launch Memory Calculation*; Top-100 unter *Window → Message Log → Memory Test Results* (VERIFIED). MCP-Aufruf UNVERIFIED, Fallback Luis-Klick |
| B2 | Dreiecke LOD0: Kopf / Körper / Accessoire | ≤ 1.500 / 2.500 / 800 | +10 % | +20 % | `blender/out/parts_layout.json` (Skript) + Static-Mesh-Editor |
| B3 | Dreiecke je Kreatur (3 Teile) | ≤ 4.800 | ≤ 5.300 | > 5.800 | Summe B2 |
| B4 | Gegner / Mini-Boss / Server-Boss / Ei / Kapsel | ≤ 2.000 / (Gegner skaliert) / 25.000 / 600 / 300 | +10 % | +20 % | wie B2 |
| B5 | LODs Kreatur-Teile | 3 Stufen (100 / 50 / 20 %), Screen Size 1,0 / 0,5 / 0,2 | – | fehlende LODs | Static-Mesh-Editor |
| B6 | Texturen | Palette 256×64, Noise 512², Icons 256², UI ≤ 256², nichts > 1024² | – | eine Textur > 1024² | `tools/budget_check.py` (liest PNG-Header in `art_src/`) |
| B7 | Eigene Texturen gesamt | ≤ 80 | 81–120 | > 120 | Zählung Content-Ordner |
| B8 | Devices gesamt (alle Typen) | ≤ 260 | 261–300 | > 300 | MCP-Actor-Liste, Filter Device-Klassen |
| B9 | Platzierte Actors gesamt (Props + Devices + Deko) | ≤ 3.500 | 3.501–5.000 | > 5.000 | MCP-Actor-Zählung (Grenze selbst gesetzt; offizielles Limit UNVERIFIED) |
| B10 | Aktive Kreatur-Teil-Objekte (Variante aus M0) | A: ≤ 2.304 platziert · B/C: ≤ 288 Laufzeit | – | A > 2.500 · B/C > 350 | Verse-Zähler `[FTB][PERF] parts=` |
| B11 | Gleichzeitig sichtbare Gegner je Plot | ≤ 6 | – | > 6 | Verse-Assert |
| B12 | Gleichzeitige `MoveTo`-Lunges je Plot | ≤ 3 | – | > 3 | Verse-Assert |
| B13 | Server-Frame-Zeit, Δp95 gegenüber leerer Insel (16B, Welle + Boss) | ≤ +8 ms | +8 bis +25 ms | > +25 ms **oder** > 3 Hänger > 300 ms pro Minute | Frame-Probe (M0-10) `[FTB][PERF] frame p50/p95/max` |
| B14 | Verse-Kosten: Kreatur tauschen / Plot neu aufbauen / OnBegin | ≤ 2 ms / ≤ 15 ms / ≤ 5 s | ×2 | ×4 | `GetSimulationElapsedTime`-Deltas im Debug |
| B15 | Verse-Schleifenraten | Einkommen 1 Hz (eine Schleife für alle Spieler) · Kampf 4 Hz **nur** auf Plots mit aktiver Welle · Boss 4 Hz · Münz-Ticker im HUD ≤ 10 Hz nur für den eigenen Zähler (Referenz `ftb_ui.verse`), alle übrigen HUD-Felder ≤ 2 Hz (bei B13 gelb: Ticker auf 2 Hz) · Hype-Ring alle 3,0 s · Idle-Prüfung 0,1 Hz · Hype-Zone 2 Hz nur während Boss · Sammel-Save alle 30 s + Sofort-Saves bei Schlüsselereignissen (höchstens 1 Sofort-Save/5 s je Spieler) | – | jede Schleife mit `Sleep(0.0)` außer Frame-Probe im Debug | Code-Review-Checkliste 4.8 |
| B16 | Save-Größe (Worst Case ×2) | `FitsInPlayerMap` = true, Schätzung ≤ 16 KB | ≤ 32 KB | FitsInPlayerMap false | Test AT-M5-5 |
| B17 | Niagara | ≤ 24 Systeme, CPU-Sim, ≤ 64 Partikel je Burst, Lebensdauer ≤ 2 s (Reveal ≤ 4 s), ≤ 6 Dauer-Auren je Plot | – | GPU-Sim oder > 128 Partikel | Niagara-Editor |
| B18 | Audio | SFX/Stimmen WAV mono 22,05 kHz ≤ 3 s; Musik WAV stereo 44,1 kHz ≤ 90 s; gesamt ≤ 40 MB WAV | ≤ 60 MB | > 60 MB | `tools/budget_check.py` |
| B19 | Audio-Player-Devices | ≤ 70 | 71–90 | > 90 | wie B8 |
| B20 | Session-Start (Launch Session bis spielbar) | ≤ 3 min | ≤ 5 min | > 8 min | Stoppuhr Luis/CC |
| B21 | Client-FPS Luis-PC, Blick vom Hub auf alle Plots | ≥ 60 | 45–59 | < 45 | Fortnite-Option „FPS anzeigen“ (Name UNVERIFIED) |

---

## 4. Verse-Architektur

### 4.1 Modulübersicht (exakt diese Dateien unter `Content/Verse/` im Projekt `FuseTheBrainrot`)

Alle 11 Dateien liegen im selben Ordner und damit im selben Verse-Modul; sie brauchen untereinander kein `using`. Referenz-Skizzen gleichen Namens liegen in `deliverables/verse_reference/` (im Repo: `docs/verse_reference/`). **Die Skizzen sind nicht kompiliert**: Namen von Klassen und Funktionen daraus übernehmen, Signaturen von Epic-APIs aber immer gegen `_context/api_digest.md` prüfen.

| Datei | Verantwortung | Wichtigste Typen / Funktionen (Namen wie in der Referenz) | Generierte Bereiche |
|---|---|---|---|
| `ftb_types.verse` | Konstanten, Enums, Katalog, Datensätze, Hilfen, Logging | `ftb_rarity`, `ftb_slot`, `ftb_creature` (struct), `ftb_player_state` (Laufzeit-Klasse je Spieler), Art-IDs, Katalog-Tabellen, `ftb_log`-Kanal + `FtbLog(Mod, Msg)` | `# BEGIN GEN catalog` … `# END GEN catalog` (Arten, Seltenheiten, 88 Kreaturen, Ei-Quoten) |
| `ftb_save.verse` | Persistenz: eine Root-Klasse, eine weak_map, Migration, Commit-Politik | `ftb_save_root` (`class<final><persistable>`), `var FtbSaves:weak_map(player, ftb_save_root)`, `PackCreature`/`UnpackCreature`, Bit-Hilfen, `MigrateSave`, `LoadSave`, `CommitSave`, `BuildSave`, `ApplySave`, `TryCommitState` | – |
| `ftb_economy.verse` | Einkommen, Kosten, Eier/Quoten/Pity, Level-Up, Totem, Pads, Freilassen, Rebirth-Regeln, Belohnungsformeln, `FormatBig` | `IncomePerSecondLive`, `IncomeTick`, `RollEggRarity`, `LevelUpCost`, `PadCost`, `TotemCost`, `CanRebirth`, `WaveRewardCoins`, `FormatBig` | `# BEGIN GEN econ` (Parametertabelle GDD 5.8) |
| `ftb_fusion.verse` | Fusionsregeln, Vorschau, Resonanz + Pity, Geheim-Rezepte, Namens-Lookup, Fusions-Timer, Index-Buchung | `fusion_preview`, `PreviewFusion`, `StartFusion`, `CollectFusion`, `HybridName(H,B,A)`, `SecretRecipeFor` | `# BEGIN GEN names` (1.000 Namen, Silben-IDs), `# BEGIN GEN secret` |
| `ftb_creature_pool.verse` | Welt-Darstellung: Kreaturen auf Pads, Gegner, Eier, Drops; Teil-Offsets; Material je Seltenheit; Lunges; Plot-Geometrie | `plot_geo` (Plot-Index → Welt-Transform), `creature_display` (Schnittstelle) mit Implementierung der M0-Siegervariante, `ShowCreature`, `HideCreature`, `Lunge`, `ShowEnemy`, `MoveEnemyAlongLane` | `# BEGIN GEN mounts` (Offsets aus `data/parts_layout.json`) |
| `ftb_combat.verse` | Wellen je Plot (0,25-s-Sim), Gegner-Pool-Logik, Hype-Takt-Messung, Team-Wahl, Drops, Boss-Direktor (Server), Hype-Zone | `wave_director`, `hype_service`, `boss_director`, `WaveStrength(w)`, `BossHP` | – |
| `ftb_ui.verse` | HUD und alle Panels (S0–S19), Toasts, Texte (`<localizes>`), Controller-Fokus-Reihenfolge | `player_ui` je Spieler, `ShowPanel`, `ShowToast`, `UpdateHud`, Text-Messages | – |
| `ftb_shop_iit.verse` | IIT: Items/Angebote nach Epic-Vorlage, Kauf, Abgleich beim Join, Pending-Flag, Verbrauch „Münz-Rausch“ | Klassen **wörtlich aus Epic-Vorlage** (Namen UNVERIFIED bis M0-04), `shop_service.Reconcile(P)`, `OnPurchasesChanged` | Angebotsliste (14 Angebote GDD §9) |
| `ftb_time.verse` | Zeitquelle abstrahiert: echte UTC-Zeit, falls vorhanden, sonst Fallback; Debug-Offset | `time_service`: `NowUtc()`, `DayIndex()`, `EventWeek()`, `IsReturnWeek()`, `TimeSource` (EPOCH/SESSION/PLAYTIME), `DebugOffsetSec` | Konstanten `EventW1StartUtc = 1796860800` (Do 10.12.2026 00:00 UTC) |
| `ftb_events.verse` | Tagesbelohnung + Streak, Codes, Event-Wochen (Eier, Kreaturen, Modifikatoren, Aufgaben, Token-Umtausch), Rückkehr-Bonus, Analytics-Wrapper | `events_service`, `ClaimDaily`, `RedeemCode`, `ActiveModifiers`, `Track(P, EventId)` | `# BEGIN GEN events` (Kalender, Codes aus `data/events.csv`, `data/codes.csv`) |
| `ftb_game_manager.verse` | **Einziges `creative_device`.** Startet alle Services, findet Devices, Spieler-Join/-Leave, Plot-Zuweisung, Teleports, Dösen, Debug-Harness (Autoplay, Bot-Plots, Frame-Probe) | `ftb_game_manager := class(creative_device)` mit `@editable`-Debug-Schaltern, `OnBegin`, `OnPlayerAdded`, `OnPlayerRemoved`, `RunAutoplay`, `FrameProbe` | – |

**Generator:** `tools/gen_verse_tables.py` liest `data/brainrot_catalog.csv`, `data/hybrid_names.csv`, `data/econ_params.json` (aus GDD 5.8, einmalig in M1-01 angelegt), `data/events.csv`, `data/codes.csv`, `data/parts_layout.json` und ersetzt **nur** den Text zwischen `# BEGIN GEN <name>` und `# END GEN <name>`. Handgeschriebener Code außerhalb der Marker bleibt unberührt. Nie Hand-Edits innerhalb der Marker.

### 4.2 Datenmodell

**Laufzeit (nicht persistent), je Spieler `ftb_player_state`:** Plot-Index (0–15), Kreaturliste (`[]ftb_creature`), Pad-Belegung, Team-Lock, Brutplätze, Fusions-Slots, Münzen/Kerne/Tokens, Rebirths, Totem, Wellenstand, Pity-Zähler, Index-Bitworte, Tages-/Streak-Daten, Code-Bitfeld, IIT-Besitz (aus Entitlements), Optionen, Statistik, `Dirty:logic`, `LastCommit:float`, Idle-Zeit, Hype-Zustand, UI-Referenzen.
**Plot (nicht persistent), `plot_geo` + Anzeige:** Welt-Transform des Plots, Pad-Transforms, Lane-Punkte, Device-Referenzen (per Tag gefunden), Besitzer (`?player`), Bot-Flag.

**`ftb_creature` (Laufzeit-struct):** `Head, Body, Acc` (Art 1–10), `Rarity` (0–6), `Level` (1–150), `Gen` (0–10), `Form` (0 = normal, 1–6 Event-Form, 7 = Sternen-Form IIT), `Flags` (Bit0 Neben-Trait, Bit1 Regenbogen, Bit2 Geheim-Rezept), `SideAcc` (Art des Neben-Traits).

### 4.3 Persistenz-Schema v1 (Freeze **Di 10.11.2026**)

Eine Root-Klasse `ftb_save_root := class<final><persistable>` in **einer** weak_map `FtbSaves`. **Die zweite erlaubte Player-weak_map wird nicht angelegt** (Reserve für Notfall-Migration). Felder exakt wie in `deliverables/verse_reference/ftb_save.verse` (Version, Coins, Kerne, Tokens[8], Rebirths, Totem, Pads, BestWave, Creatures[≤56 gepackt], PadSlots[6], Brood, Fusing, IndexBits[32 Worte à 32 Bit], BaseIdx, EventIdx, SecretIdx, EggPity[10], ResPity, DailyDay, Streak, LastDay, StreakShieldWeek, SessionsOK, CodesClaimed, EventClaims[8], IITMirror, IITPendingConsume, CoinRushSeconds, Settings, Stats[8], LastSeenEpoch, PlaySeconds, LastSessionActiveSec).

| Regel | Umsetzung |
|---|---|
| Version | `Version:int = 1`; `CurrentSaveVersion` im Code. Beim Laden immer `MigrateSave` |
| Evolution | Nach dem **ersten öffentlichen Publish** nur Felder **mit Literal-Default** ergänzen. Nie umbenennen, entfernen oder Typ ändern (VERIFIED). Defaults nie aus Modul-Konstanten (Linker-Fehler laut Forum, UNVERIFIED) |
| Packen | Verse hat keine Bit-Operatoren (UNVERIFIED) → gemischte Basis per `Quotient[]`/`Mod[]` (Referenz) |
| Größe | Rohdaten ≈ 1,3 KB, mit 3×-Overhead ≈ 4 KB; Budget B16: Worst-Case ×2 muss `FitsInPlayerMap` bestehen; Ziel ≤ 16 KB (≈ 12 % von ~128 KB, 128 KB UNVERIFIED) |
| Commit-Politik | Sofort bei: Kauf (IIT), Fusion fertig, Rebirth, Code, Tagesbelohnung, Leave. Sonst Dirty-Flag + Sammel-Commit im 30-s-Takt (Save-Schleife der Referenz `ftb_game_manager.verse`). `FitsInPlayerMap` nur beim Commit nach Wachstum (neue Kreatur, Index) – nicht pro Tick (Forum: langsam) |
| Fehler | Laden schlägt fehl → frischer Save + `[FTB][ERROR][SAVE] load_failed` + Flag, **kein** Überschreiben, bis der Spieler eine Aktion macht (Schutz vor Leerschreiben bei temporären Fehlern) |
| Private vs. öffentlich | Ob private Versionen getrennte Saves haben: UNVERIFIED → Test in M8-02. Fallback: Debug-Befehl „Save zurücksetzen“ nur bei `DebugMode` |

### 4.4 Ereignisflüsse

1. **Join:** `PlayerAddedEvent` → freien Plot wählen (niedrigster Index) → `LoadSave` + `MigrateSave` → `ApplySave` in `ftb_player_state` → `shop_service.Reconcile` (Entitlements) → Zeitquelle: Tages-/Rückkehr-Logik → Plot aufbauen (`creature_display.ShowCreature` × Pads) → `TeleportTo` Plot-Spawn → HUD anlegen → Tutorial-Schritt aus Save.
2. **Einkommens-Tick (1 Hz, eine Schleife):** für jeden Spieler `IncomeTick(dt × DebugTimeScale)` → Münzen += → Dirty → HUD-Feld (≤ 2 Hz).
3. **Ei kaufen:** Button D03 → Panel S1 → Kauf prüft Preis und Brutplatz → Münzen −, Brood-Eintrag → Brut-Timer (Spielzeit) → fertig: Nest-Interaktion D02 oder Auto-Brut → `RollEggRarity` (Pity) → Kreatur → Reveal S2 → Pad/Stall → Index → Commit.
4. **Fusion:** D04 → S5 → `PreviewFusion` (deterministisch bis auf Resonanz; Quote angezeigt) → Bestätigen: Kosten abziehen, Eltern aus Liste, Job in Fusing → Ablauf → „Einsammeln“ → Resonanzwurf → Ergebnis → Reveal S6 + Silben-Chant → Index → Commit sofort.
5. **Welle:** D06 oder HUD-Knopf → `wave_director(Plot).Start(w)` → Gegner einblenden + `MoveTo` entlang Lane (1 Aufruf je Gegner) → 4-Hz-Sim: Team-DPS × Hype → Gegner fallen → Drops → Ende nach Sieg oder 25 s → Belohnung → Commit (Sammel).
6. **Hype:** alle 3,0 s Ring (UI) → Input-Trigger `PressedEvent(agent)` → Server misst Abstand zum Zielzeitpunkt (+100 ms Kompensation) → Multiplikator für 3 s.
7. **Boss (global):** Server-Uhr `boss_offset_s=200`, dann alle 420 s → T−60 s HUD → Landung → Teilnehmer = Spieler mit Spielzeit ≥ 480 s und (≥ 1 Takt-Druck oder ≥ 20 s anwesend) → HP-Neuberechnung in den ersten 20 s → Phasen → Ende → Belohnung je Teilnehmer → Commit sofort.
8. **Kauf (IIT):** Shop S13 → `BuyOffer` → **nur** `OnPurchasesChanged` gewährt → Pending-Flag löschen → IITMirror → Commit sofort.
9. **Leave:** `PlayerRemovedEvent` → Commit sofort → Plot leeren (Hide/Dispose) → Plot frei.

### 4.5 Fehlerbehandlung
- Keine Laufzeitfehler durch Array-Zugriffe: jeder Zugriff in Failure-Kontext (`if (X := A[I])`), Default-Werte über Hilfen `AtI`/`AtF` (Referenz).
- Unbekannte IDs → Fallback-Kreatur „Waffelino Gewöhnlich“ + **einmalige** Logzeile `[FTB][ERROR][<Mod>] bad_id=<n>` (Deduplizieren über Zähler).
- `GetMinPurchaseAge` einmal pro Session in Failure-Kontext (Absturzbericht im Forum, UNVERIFIED).
- Jede `spawn{}`-Schleife hat eine Abbruchbedingung (Spieler weg → Schleife endet), keine verwaisten Tasks.
- Nie `Err()`; stattdessen Log + sicherer Zustand.

### 4.6 Logging-Regeln (Token-Ökonomie!)
- Format: `[FTB][<LEVEL>][<MOD>] <kurzer_schlüssel>=<wert> …` · LEVEL ∈ `INFO|WARN|ERROR|TEST|PERF`.
- **Keine Logs in Ticks.** Ausnahme `PERF`: höchstens 1 Zeile/10 s und nur bei `DebugMode`.
- `INFO` nur bei Join/Leave/Meilenstein-Ereignissen; im Release-Build (`DebugMode=false`) nur `WARN`/`ERROR`.
- Claude Code liest Logs **nur** über `python tools/log_check.py [--since <min>] [--test] [--perf] [--build]` (≤ 40 Zeilen Ausgabe, dedupliziert). Nie das volle Log in den Kontext laden.

### 4.7 Device-Referenzen
**Plan-Entscheidung P-03 (Reihenfolge, Wahl in M0-16 nach MCP-Fähigkeit C3/C16):**
1. **Referenz-Muster** `@editable Plots:[]ftb_plot` (verschachtelte Klasse je Plot mit Device-/Prop-Referenzen, siehe `docs/verse_reference/ftb_game_manager.verse` und `ftb_creature_pool.verse`) – nur wenn MCP verschachtelte `@editable`-Arrays befüllen kann (2.304 Prop-Referenzen per Hand sind ausgeschlossen).
2. Sonst **Verse-Tags**: Devices und Props werden per Tag gefunden (Tag-Klassen in `ftb_game_manager.verse`, z. B. `ftb_tag_btn_egg := class(tag){}`), die Plot-Zuordnung ergibt sich aus der Position (nächster Plot-Mittelpunkt). Tag-Such-API (`GetCreativeObjectsWithTag` bzw. Nachfolger `FindCreativeObjectsWithTag`): UNVERIFIED bis M0-04.
3. Sonst flache `@editable`-Arrays nur für Devices (16 Einträge je Typ, Luis-Klickliste ≈ 20 min) und für Kreatur-Teile Variante C (SpawnProp, keine platzierten Referenzen nötig).
Teleports laufen immer über `TeleportTo` (das Feld `GateTeleporter` der Referenz entfällt).

### 4.8 Code-Review-Checkliste (vor jedem Meilenstein-Commit, 5 min)
1. Keine `Sleep(0.0)`-Schleife außer `FrameProbe` (nur Debug). 2. Jede Schleife endet, wenn Spieler/Plot weg. 3. Keine Logs im Tick. 4. Kein Commit im Tick. 5. Alle Epic-APIs stehen in `api_digest.md`. 6. Generierte Bereiche unverändert seit Generator-Lauf (`python tools/gen_verse_tables.py --check`). 7. `DebugMode`-Code ist hinter `if (DebugMode?)`.

---

## 5. Asset-Pipeline

### 5.1 Grundsätze
- **Alle eigenen 3D-Assets entstehen per Blender-Python headless:** `blender -b -P <skript>.py -- <parameter>`. Luis modelliert nichts. Claude Code ruft Blender selbst über die Shell auf (lokal installiert).
- Blender-Version: **Blender 4.2 LTS** (GPL-3.0; die erzeugten Dateien gehören Luis). Pfad in `_context/mcp_werkzeuge.md` festhalten.
- Parameter der Skripte stehen in `blender/README.md` (vom Skript-Autor). **Weichen Namen dort von diesem Plan ab, gilt für UEFN-Assetnamen dieser Plan**; Claude Code passt nur den Export-Namen an (Option im Skript oder Umbenennen nach Export) und trägt die Abweichung in `entscheidungen.md` ein.

### 5.2 Blender-Konventionen

| Punkt | Festlegung |
|---|---|
| Einheiten | Wie in den Skripten: **1 BU = 1 cm** (`scale_length = 0.01`, Länge Zentimeter). FBX-Export `apply_unit_scale=True`, `apply_scale_options='FBX_SCALE_UNITS'`, `global_scale=1.0` → UEFN-Import mit Skalierung **1,0**. Kreatur laut Skript ≈ 1,6–2,1 m; GDD will 1,8–2,4 m → Verse skaliert die Teile im Pool einheitlich ×1,15 (Konstante in `ftb_creature_pool.verse`) |
| Achsen | Modell schaut in Blender nach **−Y**, oben +Z. FBX-Export Standard (`axis_forward='-Z'`, `axis_up='Y'`), UEFN-Import mit „Convert Scene“. Soll-Blickrichtung in UE: **+X**. Nach dem ersten Import prüfen (M0-08); falls falsch: **nur** per `export_fbx.py --rotate-z 90\|-90\|180` neu exportieren (nie zusätzlich Pads drehen – `blender/README.md` Punkt 9) |
| Pivot | **Körper:** unten Mitte (Pad-Oberfläche). **Kopf:** Hals-Unterseite. **Accessoire:** eigener Montagepunkt. Sockel-Empties `SOCKET_Head`, `SOCKET_Back`, `SOCKET_Neck` (Körper) und `SOCKET_HeadTop`, `SOCKET_Face` (Kopf). Verse nutzt **nicht** die UE-Sockel, sondern die Offset-Tabelle aus `blender/out/parts_layout.json` (Feld `sockets_verse_local_cm`) → Generator-Marker `mounts` |
| Topologie | Parametrische Primitive, Bevel 5 cm, Subdivision 1, Decimate auf Budget B2; Normals: Auto Smooth 40° |
| UV | Paletten-UVs: jede Fläche in die innere Hälfte einer Farbzelle von `T_FTB_Palette` (256×64 = **16×4 Zellen à 16 px**) + Vertex-Farbe als Rückfall (`UseVertexColor`). Belegung: `gen_species_parts.py` / `blender/materials_spec.md` |
| Namen | `SM_FTB_<Art>_<Slot>` mit Slot ∈ `Head\|Body\|Accessory` (wie `gen_species_parts.py`, z. B. `SM_FTB_Waffelino_Accessory`). Gegner `SM_FTB_Enemy_<Name>`, Bosse `SM_FTB_Boss_<Name>`, Sonstiges `SM_FTB_<Ding>`; Fallback-Mesh `SM_FTB_<Art>_Merged` (nur falls Fallback F4) |
| LOD | **Primär:** UE-Reduktion im Static-Mesh-Editor (LOD-Anzahl 3; LOD1 50 % Tris, Screen Size 0,5; LOD2 20 %, Screen Size 0,2). Ob UEFN „Reduction Settings“ anbietet: UNVERIFIED → **Fallback:** `gen_species_parts.py --lods` erzeugt `_LOD1`/`_LOD2`-FBX, Import als LODs im Static-Mesh-Editor |
| Export | `export_fbx.py`: eine FBX je Mesh nach `blender/out/fbx/<Name>.fbx` (Aufruf mit `--out blender/out/fbx`), Smoothing = Face, trianguliert, keine Leaf Bones, Empties = Sockel; schreibt `manifest.json` |
| Bericht | `parts_layout.json` (Tris je Teil, Sockel) + `fbx/manifest.json` (Name, Tris, Bounds) – Grundlage für Budget B2–B4 (`tools/budget_check.py` liest beide) |

### 5.3 UEFN-Import-Einstellungen (FBX, Static Mesh)
Ordner: `Content/FTB/Meshes/<Creatures|Enemies|Bosses|Props>/`. Einstellungen (UEFN nutzt je nach Version den Interchange-Importer; Namen UNVERIFIED – prüfe im Import-Dialog; Fallback: gleichwertige Option):
- Skeletal Mesh: aus · Combine Meshes: an · **Convert Scene: an** · Force Front X Axis: aus (Blickrichtung wird nur über `--rotate-z` korrigiert, 5.2) · Convert Scene Unit: an · Uniform Scale 1,0 · Sockel importieren: an (schadet nicht)
- Materialien importieren: **aus** („Do not create material“) · Texturen importieren: aus
- Auto Generate Collision: **aus** (Teile ohne Kollision; Pads/Plot haben eigene) · Nanite: **aus** · Lightmap-UVs generieren: aus
- Danach je Mesh: LOD-Einstellungen (5.2), Material-Slot 0 = passende MI.
- **Props für Verse:** Für Variante A/C braucht jedes Mesh eine Creative-Prop-Blueprint `BP_FTB_<Name>` in `Content/FTB/Props/` (Elternklasse im UEFN-Dialog „Creative Prop“/`BuildingProp` – UNVERIFIED; M0-03 prüft per MCP). Einstellungen: Can Be Damaged = aus, Kollision = keine, Schatten werfen = an. Für Variante B (Scene Graph) keine BP nötig: Mesh wird als `mesh_component`-Unterklasse in Verse sichtbar (UNVERIFIED, M0-12).
- Import per MCP (Werkzeug laut `mcp_werkzeuge.md`); Fallback: UEFN-Python (`unreal.AssetImportTask`, nur mit Python-Beta-Zugang); Fallback 2: Luis zieht den Ordner `blender/out/fbx` in den Content Browser und bestätigt den Dialog mit den obigen Werten (Klickliste von CC).

### 5.4 Materialien (Details: `blender/materials_spec.md`)
- **Maßgeblich ist `blender/materials_spec.md`** (Parameter, Instanzwerte, Textur-Importwerte); hier nur die Kurzfassung.
- **Master `M_FTB_Creature`** (Default Lit, Opaque) + Kopie **`M_FTB_Creature_Crystal`** (Masked + Dither, nur Seltenheit 3), Two Sided aus. Parameter: `Palette` (Tex), `RarityTint` (Vec), `Metallic`, `Roughness`, `FresnelColor`, `FresnelPower`, `EmissiveStrength`, `CrystalOpacity` (Dither-Maske), `CosmicTex` (T_FTB_Noise), `CosmicPan`, `BobAmpCm`, `BobFreqHz`, `SquashAmp`, `PhaseGridCm` = 500, `RainbowOn`.
- **WPO-Idle:** `Z += sin(2π·BobFreqHz·Time + Phase)·BobAmpCm`, `Phase = frac(floor(ObjectPosition.xy / PhaseGridCm) · 0,37)·2π` → Kopf, Körper, Accessoire auf demselben Pad laufen synchron (GDD 11). Amplitude je Art als MI-Parameter nicht möglich (MI je Seltenheit!) → **Plan-Entscheidung P-04:** Bob-Parameter hängen an der Seltenheits-MI (nicht an der Art): Standard 4 cm / 0,8 Hz laut `materials_spec.md`; art-typische Bewegung über Verse-Lunges/Hüpfer. Echte Art-Werte bräuchten 7 × 8 MIs – nur, falls B1 grün und Zeit übrig (nach Feature-Freeze nicht mehr). Eigene WPO-Materialien in UEFN: UNVERIFIED → M0-14.
- **7 Seltenheits-MIs** `MI_FTB_Rarity_0` … `MI_FTB_Rarity_6` (Werte GDD 4.2), **6 Event-MIs** `MI_FTB_Event_Gruender|Frosti|Funki|Schleimi|Kosmi|Festi`, **1 IIT-MI** `MI_FTB_Sternen`.
- `M_FTB_Enemy` (Grau-Violett `#6D6A86`, Glitch-Kanten emissiv `#9CFF3A`) + MIs `MI_FTB_Boss_<Variante>`; `M_FTB_Prop` (Palette, unlit-frei, für Eier/Nest/Maschinen); `M_FTB_VFX_Add` (Unlit, Additive, für Niagara).
- **Laufzeit-Tausch** `SetMaterial` (Prop) bzw. Material am `mesh_component`: UNVERIFIED → M0-14. Fallback: Teile bleiben Klassik, Seltenheit per Niagara-Aura-Ring am Pad + Namensschild-Farbe (GDD 4.2).

### 5.5 Texturen

| Asset | Größe | Kompression | Mips | Filter | Gruppe |
|---|---|---|---|---|---|
| `T_FTB_Palette` | 256×64 PNG sRGB | UserInterface2D (RGBA) | keine | Nearest | World |
| `T_FTB_Noise` | 512×512 PNG Graustufen | Masks/Grayscale, sRGB aus | an | Bilinear | World |
| `T_FTB_Icon_<Art>_<Slot>` (24), `T_FTB_Icon_<Waehrung>` (3), `T_FTB_Rar_<0..6>` (7), `T_FTB_Egg_<Stufe>` (8) | 256×256 PNG RGBA | UserInterface2D | keine | Bilinear | UI |
| `T_FTB_UI_Panel9` (9-Slice), `T_FTB_UI_Ring` | 128×128 | UserInterface2D | keine | Bilinear | UI |

Icons rendert `blender/gen_icons.py` (Claude Code schreibt es in M2-06, falls nicht vorhanden): orthografische Kamera, transparenter Hintergrund, Eevee (Fallback Cycles CPU, 16 Samples), 256².

### 5.6 Audio
| Kategorie | Werkzeug (Lizenz) | Format | Pfad |
|---|---|---|---|
| 30 Namens-Silben (10 Arten × Präfix/Mitte/Suffix) | **Kokoro-82M** (Apache-2.0), italienische Stimmen (`if_sara`, `im_nicola`; Voicepack-Lizenz prüft Luis, LIKELY Apache-2.0) + **ffmpeg** (LGPL/GPL, nur Werkzeug) für Pitch +4…+9 HT, Chorus, −12 dBFS | WAV mono 22,05 kHz 16 bit | `audio_src/syl/` → `Content/FTB/Audio/Syllables/A_FTB_Syl_<Art>_<P\|M\|S>` |
| UI-Sounds (8), Fanfaren (7), Stinger (8) | `tools/gen_sfx.py` (Python stdlib `wave` + Sinus/Rauschen; 100 % eigen). Ergänzend **jsfxr/sfxr** (MIT) oder **ChipTone** (SFB Games; kommerzielle Nutzung der Sounds erlaubt – LIKELY, Luis prüft Hinweis auf der Seite) | WAV mono 22,05 kHz | `Content/FTB/Audio/UI\|Fanfare\|Stinger/` |
| Kreatur-Laute (8) | Luis’ Handy-Aufnahmen, ffmpeg Pitch | WAV mono 22,05 kHz | `Content/FTB/Audio/Vox/A_FTB_Vox_<Art>` |
| Musik (4 Zustände) | **Primär UEFN-Musik-Assets/Patchwork** (Epic-Assets erlaubt; kein eigener Speicher). Optional **LMMS** (GPL-2.0, Werkzeug) mit **CC0**-Samples (freesound.org, Filter CC0) nur wenn B1 grün | WAV stereo 44,1 kHz, Loop | `Content/FTB/Audio/Music/` |
| **Verboten** | Coqui XTTS-v2 (nicht kommerziell), Stimmklone, virale Brainrot-Audios/Chants | – | – |

Import: WAV → SoundWave; Musik-Loops „Looping“ an. Wiedergabe über Audio-Player-Devices (D12–D15) mit `Register(Agent)`/`Play` für Pro-Spieler-Sound (Register VERIFIED; Pro-Spieler-Hörbarkeit UNVERIFIED → Fallback global).

### 5.7 VFX (Niagara)
- Aus UEFN-Niagara-Vorlagen (Simple Sprite Burst / Fountain), **CPU-Sim**, feste Bounds, Local Space, Budget B17. Spawn aus Verse per `SpawnParticleSystem` (VERIFIED), Dauer-Effekte über zurückgegebenes `cancelable` beenden (Rückgabetyp UNVERIFIED → Digest).
- Liste (Namen `NS_FTB_…`): `Reveal_R0`…`Reveal_R6` (7), `CoinPop`, `KernDrop`, `Beam` (vorab auf Länge Plot→Hub ausgerichtet; alle Plots liegen auf r = 12.500, daher **eine** Länge), `Crown`, `Aura_Mythic`, `Halo_Cosmic`, `Hit`, `EnemyDeath`, `Portal`, `BossLanding`, `Confetti`, `Zzz`, `Resonance`, `Arrow`, `Lightning` = 22 Systeme.
- Verse kann Niagara-User-Parameter nicht setzen (UNVERIFIED) → Farben sind je System fest; deshalb 7 Reveal-Systeme.

### 5.8 UI-Technik
**Plan-Entscheidung P-05 (vorläufig, final in G0):** **Verse-UI** (`canvas`, `stack_box`, `overlay`, `text_block`, `texture_block`, `button_loud/regular/quiet`, `AddWidget` mit `ui_input_mode.All`; VERIFIED) ist der Standard, weil Claude Code sie vollständig als Code bauen kann. **UMG** nur für Reveal-Animation und Toasts, und nur wenn M0-03 zeigt, dass MCP Widget-Blueprints samt Verse-Fields anlegen kann. Sonst Verse-UI mit einfachen Code-Animationen (Sichtbarkeit/Positions-Schritte in 50-ms-Takten, max. 6 Schritte). Layout-Zahlen (Positionen in % der Safe Zone, Farben, Schriftgrößen) exakt aus GDD 10.

---

## 6. Projektstruktur und Git

### 6.1 Ordnerbaum (Git-Root = UEFN-Projektordner)

Standardpfad Windows (LIKELY, in M0-01 bestätigen): `C:\Users\<Luis>\Documents\Fortnite Projects\FuseTheBrainrot\`

```
FuseTheBrainrot/
├─ CLAUDE.md                      ← Arbeitsanweisung für Claude Code (aus deliverables/CLAUDE.md)
├─ _context/                      ← Gedächtnis (Protokoll Kapitel 7)
│  ├─ README.md  status.md  entscheidungen.md  offene_fragen.md
│  ├─ playtests.md  budgets.md
│  └─ mcp_werkzeuge.md  api_digest.md  regeln_digest.md   (entstehen in M0)
├─ docs/                          ← BAUPLAN_Claude_Code.md, GDD_Fuse_and_Fight.md,
│  │                                 Launch_Plan_Phase_H.md, verse_reference/*.verse
├─ research/                      ← uefn_feasibility.md, red_team_review.md, eco/<datum>/*.json
├─ data/                          ← brainrot_catalog.csv, hybrid_names.csv, economy_sim.py,
│                                    catalog_gen.py, econ_params.json, events.csv, codes.csv, parts_layout.json
├─ tools/                         ← gen_verse_tables.py, log_check.py, eco_pull.py, gen_sfx.py,
│                                    tts_syllables.py, budget_check.py, backup.ps1, place_plots.py
├─ blender/                       ← gen_species_parts.py, export_fbx.py, materials_spec.md, README.md,
│  │                                 gen_misc_meshes.py, gen_icons.py, gen_thumbs.py
│  └─ out/                        ← (ignoriert) ftb_species_parts.blend, fbx/ (+ manifest.json), icons/, thumbs/, parts_layout.json, T_FTB_Palette.png
├─ art_src/                       ← PNG-Quellen (Palette, Noise, Icons) – LFS
├─ audio_src/                     ← WAV-Quellen (syl/, ui/, vox/, music/) – LFS
├─ logs/                          ← (ignoriert) manuelle Log-Auszüge
├─ FuseTheBrainrot.uefnproject
├─ Plugins/FuseTheBrainrot/
│  ├─ FuseTheBrainrot.uplugin
│  └─ Content/
│     ├─ Verse/                   ← die 11 ftb_*.verse
│     ├─ FTB/Meshes|Props|Materials|Textures|VFX|Audio|UI/
│     ├─ __ExternalActors__/      ← Level-Actors (One File Per Actor) – MUSS versioniert werden
│     └─ __ExternalObjects__/     ← MUSS versioniert werden
├─ Saved/  Intermediate/  DerivedDataCache/   ← ignoriert
```
Ob `Content/Verse/` im Plugin-Content liegt (wie oben) oder im Projekt-Root: UNVERIFIED → M0-02 legt den Ordner dort an, wo UEFN neue Verse-Dateien erzeugt (*Verse Explorer → Neue Datei* anlegen und Pfad prüfen).

### 6.2 `.gitignore`
```
Saved/
Intermediate/
DerivedDataCache/
Binaries/
*.log
logs/
blender/out/
.venv*/
__pycache__/
*.tmp
*.bak
*.mp4
*.mkv
research/eco/**/raw_*.json
```
**Nicht ignorieren:** `__ExternalActors__/`, `__ExternalObjects__/`, `*.uasset`, `*.umap`, `.urc`-freie Projektdateien.

### 6.3 `.gitattributes` (Git LFS)
```
*.uasset filter=lfs diff=lfs merge=lfs -text
*.umap   filter=lfs diff=lfs merge=lfs -text
*.fbx    filter=lfs diff=lfs merge=lfs -text
*.wav    filter=lfs diff=lfs merge=lfs -text
*.png    filter=lfs diff=lfs merge=lfs -text
*.blend  filter=lfs diff=lfs merge=lfs -text
```
**Git LFS** ist kostenlos (Open Source). GitHub gibt im Free-Plan ein begrenztes LFS-Kontingent (Stand-Wissen: **10 GiB Speicher + 10 GiB Bandbreite/Monat**, UNVERIFIED – Luis prüft unter *Settings → Billing*). Schätzung Projektgröße: < 2 GiB. Fallback: zusätzlich lokales Bare-Repo auf externer Platte (`git remote add backup D:\FTB_git.git`).

### 6.4 Branches und Commit-Rhythmus
- **`main`** = immer der letzte abgeschlossene Meilenstein (spielbar). **`dev`** = Arbeitszweig. Keine Feature-Branches (Binärdateien lassen sich nicht mergen). Einzige Ausnahme: `spike/m0` in M0, wird nach G0 in `dev` gemergt oder verworfen.
- **Commit nach jeder Aufgabe:** `M1-08: Einkommen, Eier, Brut` (+ Leerzeile + 1–3 Stichpunkte). Vorher UEFN *File → Save All*. Wenn UEFN Dateien sperrt: erst speichern, dann committen; nie während „Push Changes“ läuft.
- **Meilenstein-Ende:** (1) `tools/backup.ps1 -Milestone M<n>` (ZIP ohne Saved/Intermediate nach `D:\FTB_Backups\FTB_M<n>_<yyyyMMdd>.zip`; Laufwerk in `mcp_werkzeuge.md` einstellen), (2) `git checkout main && git merge --ff-only dev && git tag m<n>-done && git push --all && git push --tags`, (3) `_context/status.md` aktualisieren.
- **UEFN Revision Control (URC):** aus (Luis arbeitet allein; Git ist die einzige Versionskontrolle). Einstellungsort UNVERIFIED – prüfe beim Projekt-Anlegen; Fallback: URC-Dateien (`.urc*`) in `.gitignore`.

---

## 7. Kontext-Pflege (`_context/`) und Arbeitsweise

Das vollständige Protokoll steht in `_context/README.md`, die Arbeitsregeln in `CLAUDE.md`. Kurzfassung:
1. **Session-Start:** `CLAUDE.md` (automatisch) → `_context/status.md` → nur bei Bedarf `offene_fragen.md`/`budgets.md` → aktueller Meilenstein-Abschnitt dieses Plans (per `sed`). Nichts sonst.
2. **Während der Arbeit:** MCP-Aufrufe bündeln (Schleifen/Batch-Werkzeuge statt Einzelaufrufe), Logs nur über `tools/log_check.py`, keine großen Dateien in den Kontext (CSV nur per Skript).
3. **Nach jeder Aufgabe:** `status.md` überschreiben (≤ 40 Zeilen), neue Entscheidungen an `entscheidungen.md` anhängen, geklärte Fragen in `offene_fragen.md` schließen, Commit.
4. **Nie raten:** Unklare API → Digest; unklare Einstellung → MCP-Property-Liste; sonst Fallback aus diesem Plan nehmen und als Entscheidung eintragen. Nur wenn **kein** Fallback existiert: Frage an Luis in `offene_fragen.md` + Weiterarbeit an der nächsten unabhängigen Aufgabe.

---
## M0 · Setup, Tech-Spikes, Datenprüfung (Do 01.10. – Di 06.10.2026, KW 40–41)

**Ziel:** Werkzeuge laufen, harte Fakten statt Annahmen (Digest, Markt, Regeln), und der **Spike** beantwortet messbar: Trägt die Kreatur-Darstellung 16 Spieler × 6 Pads × 3 Teile? Ergebnis ist eine Entscheidung nach Tabelle M0.3 an **G0 (Di 06.10.)**.
**Spielbarer Endzustand:** Graybox-Insel mit 16 Plots, auf denen Kreaturen aus 2×2×2 Teilen wechseln, eine Probe-Welle läuft und ein Save überlebt einen Rejoin.
**Arbeitszweig:** `spike/m0` (danach `dev`).

### M0.1 Spike-Design (was gemessen wird)

**Drei Anzeige-Varianten** (alle im selben Level, umschaltbar über `@editable SpikeVariant` im Game-Manager):

| Variante | Prinzip | Objekte bei 16 Plots × 6 Pads | Erwartete Stärke | Erwartete Schwäche |
|---|---|---|---|---|
| **A – Pool (GDD)** | Je Pad alle 24 Teil-Props vorplatziert, Verse `Hide()`/`Show()` | 2.304 Teil-Props | kein Spawn zur Laufzeit | viele Actors, Replikation, Start-Zeit |
| **B – Scene-Graph-Tausch** | Je Pad 3 Entities; Verse tauscht die `mesh_component` (Teil-Mesh als Komponenten-Klasse) | 288 Entities | wenig Objekte | Scene Graph ist Beta; Material-/Mesh-Tausch UNVERIFIED |
| **C – SpawnProp** | Teile werden bei Bedarf per `SpawnProp` erzeugt, bei Wechsel `Dispose()` | ≤ 288 Laufzeit-Props | wenig Objekte, einfache Level | Spawn-Latenz, evtl. Laufzeit-Limit (UNVERIFIED) |

**Stellvertreter-Assets:** Alle 24 Teile werden bereits in M0 per Skript erzeugt (kostet nur Rechenzeit) und importiert – damit ist der Speicher realistisch. Die Spike-Logik nutzt davon 2 Arten (Waffelino, Frogurko) × 3 Slots = „2×2×2“. Für Variante A werden je Pad trotzdem 24 Props platziert (die 24 echten Teile), damit die Objektzahl stimmt.

**Parameter des Messlaufs** (`@editable` im Game-Manager, nur `DebugMode`):
`SpikeVariant` (1/2/3) · `BotPlots` (0–16) · `DisplayPerPlot` (1–6) · `SwapIntervalSec` (Standard 2,0; jeder Bot-Plot tauscht alle 2 s eine Kreatur komplett) · `SimWaves` (an: 4-Hz-Kampf-Sim + 6 Gegner-Props mit `MoveTo` je Plot) · `SimBeams` (an: alle 3 s ein `NS_FTB_Beam`-Spawn je Plot) · `UseMerged` (Fallback F4).

**Messgrößen:**
| ID | Messung | Methode | Logzeile |
|---|---|---|---|
| X1 | Speicher gesamt | Launch Memory Calculation | (Luis/MCP → `budgets.md`) |
| X2 | Server-Frame-Zeit p50/p95/max, 60-s-Fenster | Frame-Probe: `loop { T0 := GetSimulationElapsedTime(); Sleep(0.0); dt := GetSimulationElapsedTime() − T0 }` | `[FTB][PERF][SPIKE] v=A plots=16 disp=6 p50=… p95=… max=… hitches300=…` |
| X3 | Baseline ohne Last | X2 mit `BotPlots=0` | `…][BASE] p50=… p95=…` |
| X4 | Kosten „Kreatur tauschen“ / „Plot neu aufbauen“ | Zeitdifferenz um den Aufruf (Mittel über 100 Aufrufe) | `[FTB][PERF][SWAP] one=…ms plot=…ms` |
| X5 | OnBegin-Dauer (Pool verstecken/aufbauen) | Zeit bis „ready“ | `[FTB][PERF][INIT] s=…` |
| X6 | Actor-Zahl gesamt | MCP-Zählung | → `budgets.md` B9 |
| X7 | Client-Eindruck | Luis: Blick vom Hub, 60 s; FPS-Anzeige; sichtbares Aufploppen ja/nein | → `playtests.md` (Selbsttest) |

**Frame-Probe-Hinweis:** Server-Ticks laufen mit fester Rate (≈ 30 Hz → ≈ 33 ms). Deshalb wird **Δ gegen die Baseline X3** bewertet, nicht der Absolutwert.

### M0.2 Weitere Spikes (je eine Probe mit Fallback)
| Probe | Prüfung | Bestanden wenn | Fallback |
|---|---|---|---|
| P1 Material-Tausch | `SetMaterial` auf Prop (A/C) bzw. Material der `mesh_component` (B) | 3 Teile wechseln sichtbar auf R3-Kristall innerhalb 0,5 s (Luis-Sicht) | Klassik-Material fest + Niagara-Aura-Ring + Rahmenfarbe (GDD 4.2) |
| P2 WPO-Bob | eigenes Material mit WPO | Teile wippen synchron (Luis-Sicht, 10 s) | Verse-`MoveTo`-Bob 0,5-s-Takt nur eigener/angesehener Plot |
| P3 MoveTo + Skalierung | Lunge 0,25 s hin/zurück mit Scale 1,0→1,15→1,0 | Aufruf gelingt, Squash sichtbar | nur Positions-Lunge |
| P4 Hide/Show | Prop verschwindet auf dem Client und blockiert nicht | sichtbar weg, kein Schatten | `TeleportTo` nach (0,0,−20.000) |
| P5 Feuer-Taste | Input Trigger D10 auf „Feuer“; Luis haut 20× auf ein Metronom (Ton + HUD-Blitz alle 3,0 s) | `PressedEvent` bei Maus links **und** RT; nach Kalibrierung (+100 ms) ≥ 60 % der 20 Drücke in ±150 ms; Spitzhacke schwingt weiter | 1) Verse-UI-Button „SMASH“ 2) Hype-Meter (8× tippen in 3 s) |
| P6 Controller-Fokus | Test-Panel mit 3 `button_loud` in `stack_box` | Luis erreicht alle 3 mit Steuerkreuz, A löst aus, Panel schließt über eigenen Knopf | nur Welt-Terminals + Panels mit ≤ 2 großen Knöpfen, Schließen-Knopf immer fokussiert zuerst |
| P7 Save | Save mit 56 Kreaturen + voller Index, Rejoin | Werte identisch; `FitsInPlayerMap` = true mit Worst-Case ×2 | Index-Worte halbieren (nur R1-Hybride), Stall 50→40 |
| P8 Zeit-API | Digest-Treffer + Laufzeitwert | `NowUtc` liegt ±1 Tag an `date -u +%s` (01.10.2026 ≈ 1.790.812.800) und steigt 60 ± 2 in 60 s | Session-Kalender + wöchentliches Mikro-Update + Spielzeit-Freischaltung (GDD 7.1/7.4) |
| P9 Spielername | Digest: Anzeigename als Text? | Name erscheint auf Billboard | Plot-Nummern statt Namen (Schild, Plots-Tab, Rangliste) |
| P10 Tag-Suche | 16 Buttons per Tag gefunden | 16/16, Plot-Zuordnung korrekt | `@editable`-Arrays (4.7) |
| P11 2. Spieler | zweites Konto tritt Edit-Session bei | Beitritt klappt | 2P erst im privaten Build (M3) |
| P12 IIT-Symbole | Digest-Namen/Signaturen | alle 6 Funktionen + Klassen gefunden | Epic-Vorlage wörtlich kopieren; Shop hinter Schalter `IITEnabled` |

### M0.3 Entscheidungstabelle G0 (verbindlich, ohne Rückfrage anwenden)

**Schritt 1 – Variante wählen.** Jede Variante wird mit `BotPlots=16, DisplayPerPlot=6, SimWaves=an, SimBeams=an` gemessen.
- Grün heißt: B1-Projektion ≤ 45.000 **und** Δp95 ≤ +8 ms **und** max. 3 Hänger > 300 ms/min **und** X4 ≤ 2 ms/15 ms **und** X5 ≤ 5 s **und** P4 (A) bzw. Tausch (B/C) funktioniert.
- Unter allen grünen Varianten gewinnt die mit dem **kleinsten Δp95**; liegen zwei innerhalb 2 ms, gewinnt die mit **weniger Objekten** (C/B vor A).
- Ist keine grün, weiter mit Schritt 2 auf der Variante mit dem kleinsten Δp95.

**Schritt 2 – Fallback-Leiter** (nacheinander, nach jeder Stufe neu messen; ≈ 20 min je Stufe, nur Parameter):

| Stufe | Maßnahme | Parameter | Spielauswirkung | Nötige Nacharbeit |
|---|---|---|---|---|
| F1 | Nur die 3 Team-Kreaturen voll anzeigen, Pads 4–6 zeigen eine **Kapsel** (`SM_FTB_Capsule`, 1 Prop, Seltenheitsfarbe per MI) | `DisplayPerPlot=3` | Einkommen/Pads unverändert, nur Optik | Kapsel-Mesh (10 min Skript) |
| F2 | 5 statt 6 Pads | Pads-Maximum 5 | Einkommen −1 Pad | `economy_sim.py --params pads_max=5` + neue Pad-Kosten (GDD-Leiter Stufe 1) |
| F3 | Max. **12** Spieler (12 Plots, 30°-Abstand) | `BotPlots=12` | weniger Koop-Masse beim Boss | Plot-Layout 12er-Ring |
| F4 | Zusammengefügte Anzeige: je Pad nur „reine“ Art als **Merged-Mesh** (1 Prop je Kreatur, 8 Merged-Meshes); Hybrid-Look nur im UI-Porträt und auf **einem** Schaukasten-Pad je Plot | `UseMerged=an` | Hybrid-Optik in der Welt reduziert | 8 Merged-Meshes (Skript), Schaukasten-Logik |
| F5 | Max. **8** Spieler | `BotPlots=8` | Server kleiner | 8er-Ring |
| F6 | **Kill-Eskalation:** Luis entscheidet zwischen „Fight-naher Hybrid“ (Red Team §5) und Weiterbau mit F5 + reduzierter Optik | – | – | Claude Code schreibt 1-Seiten-Entscheidungsvorlage in `offene_fragen.md` |

**Schritt 3 – Speicher allein** (falls B1 gelb/rot, unabhängig von der Variante; Instanzen kosten kaum Speicher, einzigartige Assets schon):
S1 eigene Musik weglassen (UEFN-Bibliothek) → S2 Bonus-Arten streichen (−6 Meshes, GDD-Kill-Schalter: nur erlaubt bei Messung < 50 % = < 50.000) → S3 Gegner-Meshes 4→2 (Varianten über MI/Skalierung) → S4 Bosse 3→1 Mesh + MIs → S5 LOD0-Tris −30 % (Skript-Parameter) → S6 Audio auf 16 kHz. Danach Projektion > 70.000 → F6.

**Schritt 4 – Einzel-Proben P1–P12:** Fallback automatisch übernehmen, in `entscheidungen.md` eintragen, betroffene GDD-Stelle notieren. **Kein Kill** durch P1–P12 (nur P5 + P6 zusammen gescheitert → Hinweis an Luis, Weiterbau mit Fallbacks).

**Markt-Kill (aus M0-05):** Fusion-first-Map > 5.000 Peak in 30 Tagen **oder** BE A BRAINROT (6931-5304-1207) / Kick a Lucky Rot > 10.000 mit Fuse-Feature (GDD 14.1) → **kein Baustopp**, aber Claude Code schreibt die Entscheidungsvorlage „Fusion wird Beiwerk, Kampf Hauptverb“ für Luis; Weiterbau am Kern (Wellen/Boss) ist davon unberührt.

### M0.4 Aufgaben

#### M0-01 · Installation, Konten, UEFN-Projekt (1,5 h) [Luis]
- **Abh.:** –
- **Dateien:** – (Projektordner entsteht)
- **Devices/Assets:** –
- **Schritte (PowerShell als normaler Nutzer):**
  1. `winget install -e --id Git.Git` (enthält Git LFS) · `git lfs install`
  2. `winget install -e --id Python.Python.3.12`
  3. `winget install -e --id Gyan.FFmpeg`
  4. Blender 4.2 LTS: `winget search Blender` → Paket mit Version 4.2.x wählen, sonst Installer von blender.org (4.2 LTS). Pfad notieren (Standard `C:\Program Files\Blender Foundation\Blender 4.2\blender.exe`).
  5. `winget install -e --id GitHub.cli` · `gh auth login` · privates Repo anlegen: `gh repo create FuseTheBrainrot --private`
  6. UEFN starten (Version ≥ 42.00, *Help → About* notieren) → *New Project* → Vorlage **Blank** (bzw. „Leere Insel“) → Name **`FuseTheBrainrot`** → Pfad notieren.
  7. Unreal MCP in UEFN aktivieren und mit Claude Code verbinden **genau nach Epic-Doku** (Suchbegriff „Unreal MCP UEFN“ auf dev.epicgames.com; Menüpfade UNVERIFIED). Claude Code kann dabei helfen: Luis startet `claude` im Projektordner und schreibt „Hilf mir, das Unreal MCP laut Epic-Doku zu verbinden“.
  8. Gamepad bereitlegen; zweites Epic-Konto anlegen (kostenlos, für 2P-Tests).
  9. Python-Editor-Scripting-Beta beantragen (Forum-Thread „Python Editor Scripting Beta Access Request UEFN“) – nur Rückfallebene, Antwort nicht abwarten.
  10. **Fortnite Developer Program** beitreten: create.fortnite.com/enroll (18+, Zahlungsnachweis laut Launch-Plan 8.1). Nötig für IIT; Status in `offene_fragen.md` Q-IIT-1 eintragen.
  11. Die 3 Tester für **Sa 31.10.** und **Sa 28.11.** einladen (je 3 h, eine Person mit Controller/Konsole, eine mit Handy).
- **Abnahme:** `git --version`, `git lfs version`, `python --version`, `ffmpeg -version`, Blender-Pfad, UEFN-Version stehen in `_context/mcp_werkzeuge.md` (CC trägt ein); MCP-Werkzeugliste in Claude Code sichtbar (`/mcp`).
- **Test:** –
- **API:** Unreal MCP in UEFN v42 VERIFIED (Release Notes 42.00); genaue Aktivierung UNVERIFIED → Fallback: ohne MCP arbeitet CC mit Dateien + Klicklisten für Luis (deutlich langsamer; dann M0.3-Messungen trotzdem durchführen).

#### M0-02 · Repo-Aufbau, Git/LFS, Kontext einspielen (1 h) [CC]
- **Abh.:** M0-01
- **Dateien:** `.gitignore`, `.gitattributes` (Inhalt 6.2/6.3), `CLAUDE.md`, `_context/*`, `docs/*`, `research/*`, `data/*`, `blender/*`, `tools/backup.ps1`, `tools/log_check.py`
- **Schritte:**
  1. Im Projektordner `git init -b main`, `.gitattributes` vor dem ersten `git add` anlegen, `git lfs track` prüfen (`git lfs ls-files` nach Commit).
  2. Aus dem Recherche-Paket (von Luis in `C:\FTB_paket\` entpackt; enthält `deliverables/` und `research_notes/`) kopieren: `deliverables/CLAUDE.md` → Root; `deliverables/_context/` → `_context/`; `BAUPLAN_Claude_Code.md`, `GDD_Fuse_and_Fight.md`, `Launch_Plan_Phase_H.md`, `verse_reference/` → `docs/`; `deliverables/data/*` → `data/`; `deliverables/blender/*` → `blender/`; `uefn_feasibility.md`, `red_team_review.md` → `research/`.
  3. `Content/Verse/`-Ort ermitteln (6.1-Hinweis): Luis legt im Verse Explorer eine Datei `ftb_game_manager.verse` an (Rechtsklick → *Add new Verse file* → „Verse Device“), CC prüft den Pfad auf der Platte und verschiebt sie ggf. in den Unterordner `Verse/` (UEFN aktualisieren lassen: *Verse → Build*).
  4. `tools/log_check.py` schreiben (stdlib): findet neueste UEFN-Logdatei (Pfad aus `mcp_werkzeuge.md`), filtert `[FTB]`, Optionen `--since N` (Minuten), `--test`, `--perf`, `--build` (Verse-Compilerfehler: Zeilen mit `error`/`.verse(`), dedupliziert, max. 40 Zeilen.
  5. `tools/backup.ps1 -Milestone <M>` schreiben (Compress-Archive ohne Saved/Intermediate/DerivedDataCache nach `<BackupDir>\FTB_<M>_<yyyyMMdd>.zip`, BackupDir-Parameter mit Standard `D:\FTB_Backups`, fällt auf `$env:USERPROFILE\FTB_Backups` zurück).
  6. Erster Commit „M0-02: Repo-Grundstruktur“, `git remote add origin <gh-url>`, Push; Zweig `spike/m0` anlegen.
- **Abnahme:** `git lfs ls-files` zeigt die Projekt-`.uasset`/`.umap`; Push erfolgreich; `python tools/log_check.py --since 5` läuft ohne Fehler.
- **Test:** –
- **API:** –

#### M0-03 · MCP-Werkzeug-Inventar und Fähigkeitsmatrix (1 h) [CC]
- **Abh.:** M0-01
- **Dateien:** `_context/mcp_werkzeuge.md` (neu)
- **Schritte:**
  1. Werkzeugliste des Unreal-MCP abrufen (nur Namen + 1 Zeile Zweck) und eintragen.
  2. Fähigkeiten einzeln mit **einem** Mini-Aufruf prüfen und als Ja/Nein/Workaround eintragen:
     C1 Actor aus Asset platzieren · C2 Transform setzen · C3 Device-Property setzen (inkl. Verse-`@editable`) · C4 Datei importieren (FBX/WAV/PNG) · C5 Material/MI anlegen + Parameter setzen · C6 Static-Mesh-Einstellungen (LOD, Kollision, Nanite) · C7 Verse bauen + Fehler lesen · C8 Session starten/„Push Changes“ · C9 Log lesen · C10 Memory Calculation auslösen/lesen · C11 Blueprint aus Mesh (Creative Prop) · C12 UMG-Widget anlegen/ändern · C13 Python ausführen · C14 viele Actors in einem Aufruf (Batch) · C15 Actor-Properties auflisten (für Einstellungsnamen) · C16 Verse-Tag an Actor hängen · C17 Viewport-Screenshot.
  3. Für jedes „Nein“ den Fallback aus diesem Plan notieren (meist: Klickliste für Luis, generiert von CC, ≤ 10 Schritte).
  4. Logdatei-Pfad (2.2) und Blender-Pfad eintragen.
- **Abnahme:** Matrix C1–C17 vollständig; Test-Actor wieder gelöscht.
- **Test:** –
- **API:** alles hier ist Selbstprüfung; Ergebnis macht nachfolgende Schritte VERIFIED/UNVERIFIED.

#### M0-04 · Verse-Digest-Fakten (1,5 h) [CC]
- **Abh.:** M0-01
- **Dateien:** `_context/api_digest.md` (neu)
- **Schritte:**
  1. Digests finden: `Get-ChildItem "$env:LOCALAPPDATA","$env:USERPROFILE\Documents\Fortnite Projects","${env:ProgramFiles}\Epic Games" -Recurse -Filter *.digest.verse -ErrorAction SilentlyContinue | Select FullName`.
  2. Je Suchgruppe `Select-String -Pattern` (nur Trefferzeile + 2 Kontextzeilen):
     - Zeit: `Epoch|UtcNow|DateTime|Timestamp|GetSecondsSince|WallClock|RealTime|GetSimulationElapsedTime`
     - IIT: `BuyOffer|OnPurchasesChanged|GetPurchasedEntitlements|ConsumeEntitlement|ShowOffersDialog|GetMinPurchaseAge|entitlement|_offer|Marketplace`
     - Props: `SetMaterial|SpawnProp|Hide\(|Show\(|MoveTo|TeleportTo|Dispose|IsValid|creative_prop<`
     - Tags: `GetCreativeObjectsWithTag|FindCreativeObjectsWithTag|tag\b|creative_object_interface`
     - Input: `input_trigger_device|PressedEvent|ReleasedEvent|input_action|player_input`
     - Scene Graph: `mesh_component|AddComponents|RemoveComponent|SetMesh|entity\b|material_component`
     - UI: `AddWidget|RemoveWidget|ui_input_mode|player_ui_slot|button_loud|text_block|texture_block|SetText|OnClick|stack_box|canvas_slot`
     - Persistenz: `FitsInPlayerMap|persistable`
     - Name: `GetDisplayName|DisplayName|player_name|Localize|agent_name`
     - Diagnose/Zufall: `log_channel|profile|GetRandomInt|GetRandomFloat`
     - Devices: `button_device|billboard_device|audio_player_device|Register\(|analytics_device|Submit|player_spawner_device|SpawnParticleSystem|cancelable`
     - Kamera: `camera|Shake`
  3. `api_digest.md` im Format `| Symbol | Signatur (1 Zeile) | Digest-Datei | Status |` – nur Gefundenes, Status „VERIFIED (Digest)“; Nicht-Gefundenes in eine zweite Tabelle „fehlt“ mit dem Fallback aus diesem Plan.
  4. P8 (Zeit), P9 (Name), P10 (Tags), P12 (IIT) auf Digest-Ebene vorbewerten.
- **Abnahme:** ≥ 40 Symbole mit Signatur; alle 12 Gruppen bearbeitet; Datei ≤ 150 Zeilen.
- **Test:** –
- **API:** macht aus UNVERIFIED → VERIFIED (Digest) oder Fallback.

#### M0-05 · Markt-Daten aus offenem Netz (Ecosystem API) (1,5 h) [CC]
- **Abh.:** M0-02
- **Dateien:** `tools/eco_pull.py`, `research/eco/2026-10-0X/summary.csv`, Kurzfazit in `entscheidungen.md`
- **Schritte:**
  1. Probe: `curl -s https://api.fortnite.com/ecosystem/v1/islands/3225-0366-8885` und `…/metrics/day` (Muster aus Bericht, Pfad UNVERIFIED). Antwortschlüssel notieren (nicht die ganze Antwort).
  2. `tools/eco_pull.py` (stdlib `urllib`, 1 Anfrage/s): für die 25 Codes aus Bericht „Nachprüfung 1“ plus `6931-5304-1207` (BE A BRAINROT) Tagesmetriken der letzten 7 Tage (API liefert laut Launch-Plan nur 7 Tage) abrufen; Rohdaten nach `research/eco/<datum>/raw_<code>.json` (ignoriert), Zusammenfassung `summary.csv`: code, title, max_peak_ccu_7d, avg_minutes_per_player, retention_d1, retention_d7.
  3. Inselsuche: Falls die API eine Inselliste liefert (`/ecosystem/v1/islands?size=…`, UNVERIFIED), höchstens 30 Seiten nach Titeln mit `fuse|fusion|merge|breed|hybrid|hatch|egg|evolve` filtern und diese Codes mit abrufen. Kick-a-Lucky-Rot-Code so finden; sonst `offene_fragen.md` Q-MKT-2 (Luis sucht auf fortnite.gg).
  4. 30-Tage-Peaks liefert die API nicht: fortnite.gg per WebFetch versuchen (`https://fortnite.gg/island?code=<code>`); bei Sperre → Luis-Aufgabe R0-1/R0-2 (Bericht, Anhang „Aufnahmeliste“).
  5. Kill-Kriterium Markt (M0.3) bewerten; 5 Zeilen Fazit in `entscheidungen.md`.
- **Abnahme:** `summary.csv` mit ≥ 20 Codes; Fazit mit klarer Aussage „Markt-Kill ja/nein/unklar (fehlt: …)“.
- **Test:** –
- **API:** Ecosystem API öffentlich (Launch-Plan: OFFICIAL/CLAIMED); Pfade UNVERIFIED → Fallback fortnite.gg manuell (Luis, 20 min).

#### M0-06 · Regeln lesen und verdichten (1 h) [CC]
- **Abh.:** –
- **Dateien:** `_context/regeln_digest.md` (≤ 60 Zeilen)
- **Schritte:** WebFetch nacheinander: legal.epicgames.com/fortnite/developer-rules, …/developer-rules-change-log, dev.epicgames.com IIT Restrictions, Monetization Guidelines, Thumbnail Image Policies, Persistence Best Practices. Extrahieren: 1.x (Metadaten, **1.9.1** Duplikate), 3.x Inhalte relevant für Kreaturen/Kampf, **4.4.7/4.4.9/4.4.12/4.4.13/4.4.14**, alle Änderungen nach 29.04.2026, Preisgrenzen V-Bucks, 128-KB-/2-weak_map-Grenze, Thumbnail-Maße. Jede Zeile mit Quelle + Datum.
- **Abnahme:** Jeder der 14 IIT-Angebote (GDD 9) ist gegen die Regeln mit ✔/✖ markiert; Abweichung → Eintrag in `offene_fragen.md` + Vorschlag.
- **Test:** –
- **API:** Seiten erreichbar im offenen Netz (Cloud war gesperrt). Fallback bei Sperre: Luis öffnet die Seiten und speichert sie als PDF nach `research/rules/`, CC liest die PDFs.

#### M0-07 · Blender-Rauchtest + alle 24 Teile + Palette (1,5 h) [CC]
- **Abh.:** M0-01, M0-02
- **Dateien:** `blender/gen_species_parts.py`, `blender/export_fbx.py` (vorhanden), `blender/out/*`, `art_src/T_FTB_Palette.png`, `art_src/T_FTB_Noise.png`, `data/parts_layout.json`
- **Assets:** A01–A24 (Kreatur-Teile), A60 Palette, A61 Noise
- **Schritte:**
  1. `blender/README.md` lesen (nur Parameter-Abschnitt).
  2. `& "<blender.exe>" -b -P blender\gen_species_parts.py -- --out blender\out --lods` dann `& "<blender.exe>" -b blender\out\ftb_species_parts.blend -P blender\export_fbx.py -- --out blender\out\fbx`.
  3. Validierungs-Checkliste `blender/README.md` Punkte 1, 2, 6, 7 abarbeiten (ohne die .blend zu öffnen).
  4. Budget-Check: `python tools/budget_check.py --layout blender/out/parts_layout.json --manifest blender/out/fbx/manifest.json` (Skript neu, prüft B2–B4, B6).
- **Abnahme:** 24 FBX + `manifest.json`, alle Teile im Budget B2, `parts_layout.json` mit Sockeln für 8 Arten, `T_FTB_Palette.png`.
- **Test:** –
- **API:** Blender headless VERIFIED (Standard-Blender). Fallback bei Skriptfehler in Fremdskript: Fehler + Stacktrace (≤ 20 Zeilen) lesen, minimal patchen, Patch in `entscheidungen.md` notieren.

#### M0-08 · Import, Master-Material, 3 Spike-MIs (2 h) [CC]
- **Abh.:** M0-03, M0-07
- **Dateien:** Content `FTB/Meshes/Creatures/`, `FTB/Materials/`, `FTB/Textures/`
- **Assets:** A01–A24, A60, A61, A70 `M_FTB_Creature`, A71 `MI_FTB_Rarity_0`, A73 `MI_FTB_Rarity_2`, A74 `MI_FTB_Rarity_3` (Parent `M_FTB_Creature_Crystal`)
- **Schritte:**
  1. Import mit Einstellungen 5.3 (Batch-Werkzeug laut `mcp_werkzeuge.md`).
  2. Texturen importieren, Einstellungen 5.5.
  3. `M_FTB_Creature` laut `blender/materials_spec.md` + 5.4 anlegen (per MCP C5; sonst Klickliste für Luis mit exakten Knoten – max. 15 Knoten; Liste in `materials_spec.md` falls vorhanden verwenden).
  4. 3 MIs mit Werten aus GDD 4.2.
  5. LOD-Einstellungen (5.2) auf allen 24 Meshes; Nanite aus.
  6. Für Variante A/C: 24 Creative-Prop-BPs `BP_FTB_<Art>_<Slot>` (C11); sonst Klickliste (Rechtsklick Mesh → *Create Blueprint* … UNVERIFIED Menü; Fallback: Luis erstellt einen BP, CC dupliziert per MCP und tauscht das Mesh).
- **Abnahme:** 24 Meshes mit MI, 3 LODs; 24 BPs (falls A/C möglich); Memory Calculation einmal gelaufen (Zwischenwert in `budgets.md`).
- **Test:** –
- **API:** Material-Editor/WPO in UEFN UNVERIFIED (P2) → Fallback 5.4.

#### M0-09 · Graybox-Layout: Hub + 16 Plots + Pads + Plot-Devices (1,5 h) [CC]
- **Abh.:** M0-03
- **Dateien:** `tools/place_plots.py` (erzeugt eine Liste aus Transforms nach GDD 11; Ausgabe JSON, die CC dann per MCP-Batch platziert)
- **Devices:** D01 ×16, D02–D08 je ×16, D00 Island Settings
- **Assets:** Graybox aus UEFN-Galerie: Boden-Platten (Plot 4.000×4.000 als 4×4 Kacheln à 1.000), Zylinder Ø 300 × 40 für Pads (6 je Plot), Hub-Scheibe r = 4.000
- **Schritte:**
  1. Plot-Mittelpunkte: `P_i = (12.500·cos(22,5°·i), 12.500·sin(22,5°·i), 0)`, Plot-Rotation so, dass lokales +X zur Mitte zeigt (Gier = 22,5°·i + 180°).
  2. Lokale Positionen je Plot aus GDD 11 (Plot-Layout-Tabelle) transformieren; Devices laut Anhang D platzieren und Tags setzen (C16) bzw. Namen `FTB_P<ii>_<Typ>` vergeben (für Fallback-Arrays).
  3. Island Settings D00 setzen.
  4. Actor-Zahl notieren (B9).
- **Abnahme:** 16 Plots mit je 6 Pads + 7 Buttons + 1 Spawner; Spieler spawnt auf einem Plot; Actor-Zählung in `budgets.md`.
- **Test:** S (Luis spawnt; 1 min)
- **API:** Tag-Setzen per MCP UNVERIFIED → Fallback Namensschema + `@editable`-Arrays.

#### M0-10 · Verse-Grundgerüst + Debug-Harness + Frame-Probe (2 h) [CC]
- **Abh.:** M0-04, M0-09
- **Dateien:** `Content/Verse/ftb_types.verse` (Logging, Konstanten-Minimum), `Content/Verse/ftb_game_manager.verse`
- **Devices:** Verse-Device `ftb_game_manager` ×1 in den Hub (D19)
- **Schritte:**
  1. `ftb_log`-Kanal + `FtbLog`-Hilfe (4.6-Format).
  2. Game-Manager mit `@editable`: `DebugMode:logic=true`, `DebugTimeScale:float=1.0`, `AutoTest:int=0`, `SpikeVariant:int=1`, `BotPlots:int=0`, `DisplayPerPlot:int=6`, `SwapIntervalSec:float=2.0`, `SimWaves:logic=false`, `SimBeams:logic=false`, `UseMerged:logic=false`.
  3. `FrameProbe` (nur bei `DebugMode`): 60-s-Fenster, Ausgabe X2/X3 wie M0.1.
  4. Plot-Geometrie `plot_geo` (Transforms aus 1.) in `ftb_creature_pool.verse` anlegen.
  5. Join/Leave: Plot zuweisen, `TeleportTo` auf Plot-Spawn.
- **Abnahme:** Kompiliert; Log zeigt `[FTB][INFO][GM] ready plots=16` und nach 60 s `[FTB][PERF][BASE] …`.
- **Test:** S
- **API:** `GetSimulationElapsedTime`, `Sleep`, `PlayerAddedEvent`, `TeleportTo` – Status aus `api_digest.md`; Fallback für Frame-Probe: Timing Insights (v42, VERIFIED) durch Luis (Klickliste).

#### M0-11 · Variante A: Pool-Props (2 h) [CC]
- **Abh.:** M0-08, M0-09, M0-10
- **Dateien:** `Content/Verse/ftb_creature_pool.verse` (`display_pool_props`)
- **Assets:** 24 BPs × 96 Pads = 2.304 platzierte Props (Batch per MCP C14; Position = Pad-Mitte + Offset aus `parts_layout.json`, gestaffelt versteckt)
- **Schritte:** Platzieren (in 16 Batches à 144), Tag je Teil-Typ (`ftb_tag_part_<Art>_<Slot>`), in Verse per Tag + Nähe zum Pad einsortieren, beim Start alle `Hide()`, `ShowCreature(Plot,Pad,C)` zeigt 3 Teile + `SetMaterial`, Bot-Plot-Tauschschleife.
- **Abnahme:** X2/X4/X5 geloggt für `BotPlots=16`; Actor-Zahl (X6).
- **Test:** 16B, S (Luis sieht 60 s vom Hub: Aufploppen? FPS?)
- **API:** `Hide/Show` UNVERIFIED (P4) → `TeleportTo` unter die Map; `SetMaterial` UNVERIFIED (P1).

#### M0-12 · Variante B: Scene-Graph-Mesh-Tausch (2 h) [CC]
- **Abh.:** M0-08, M0-10
- **Dateien:** `Content/Verse/ftb_creature_pool.verse` (`display_scene_graph`)
- **Schritte:** Scene Graph für das Projekt aktivieren (Ort UNVERIFIED – prüfe *Project Settings*/Feature-Flags; bei Unklarheit Doku „Scene Graph“ per WebFetch), je Pad 3 Entities (Laufzeit) mit `mesh_component`-Unterklasse des Teil-Meshes; Tausch = Komponente entfernen/hinzufügen; Material setzen; Bot-Schleife wie A.
- **Abnahme:** X2/X4/X5 für B geloggt **oder** dokumentiert „nicht machbar, weil …“ (1 Zeile) nach max. 2 h.
- **Test:** 16B, S
- **API:** `mesh_component`-Unterklassen aus Assets, `AddComponents`: UNVERIFIED → Variante B entfällt.

#### M0-13 · Variante C: SpawnProp bei Bedarf (1 h) [CC]
- **Abh.:** M0-08, M0-10
- **Dateien:** `Content/Verse/ftb_creature_pool.verse` (`display_spawned`)
- **Schritte:** `SpawnProp(BP-Asset, Transform)` je Teil, `Dispose()` beim Tausch; Fehlercode des Spawns loggen (Limit-Erkennung); Bot-Schleife.
- **Abnahme:** X2/X4/X5 geloggt; maximale gleichzeitige Spawns ohne Fehler (Zahl) in `budgets.md`.
- **Test:** 16B
- **API:** `SpawnProp` VERIFIED laut Recherche als LIKELY → Digest; Laufzeit-Limit UNVERIFIED → gemessen.

#### M0-14 · Proben P1–P4: Material, WPO, MoveTo+Scale, Hide (1,5 h) [CC+Luis]
- **Abh.:** M0-11 (oder M0-13)
- **Dateien:** `ftb_creature_pool.verse` (Probe-Funktionen hinter `AutoTest=90..93`)
- **Schritte:** AT-M0-90…93 (Anhang T) ausführen; Luis schaut je 20 s und antwortet „ja/nein“ je Probe.
- **Abnahme:** 4 Ergebnisse in `entscheidungen.md` (mit Fallback bei „nein“).
- **Test:** S
- **API:** siehe M0.2.

#### M0-15 · Proben P5, P6, P11: Feuer-Taste, Controller-Fokus, 2. Spieler (1,5 h) [CC+Luis]
- **Abh.:** M0-10
- **Dateien:** `ftb_combat.verse` (`hype_service` Probe-Modus: Metronom alle 3,0 s, Offsets loggen `[FTB][TEST][P5] off_ms=…`), `ftb_ui.verse` (Test-Panel P6)
- **Devices:** D10 Input Trigger „Hype“ (Katalog), 1 Audio-Player mit Klick (UEFN-Bibliothek)
- **Schritte:** Luis: 20 Drücke mit Maus, 20 mit Gamepad RT; P6 mit Gamepad; P11: zweites Konto versucht beizutreten (Luis beschreibt kurz, was passiert).
- **Abnahme:** Trefferquote ±150 ms je Eingabe geloggt, P6/P11 ja/nein.
- **Test:** S, C
- **API:** Input-Trigger-Option „Fire“ UNVERIFIED → Fallback-Kette (P5).

#### M0-16 · Proben P7–P10, P12: Save, Zeit, Name, Tags, IIT (1,5 h) [CC]
- **Abh.:** M0-04, M0-10
- **Dateien:** `Content/Verse/ftb_save.verse` (Schema v1 aus Referenz übernehmen), `ftb_time.verse` (`time_service` mit Quelle EPOCH falls vorhanden), `ftb_shop_iit.verse` (nur Kompilier-Probe der Symbole)
- **Schritte:** AT-M0-94 (Save Worst-Case, Rejoin durch Luis), AT-M0-95 (Zeit: Wert + Steigung), P9 Billboard-Test, P10 Tag-Zählung, P12 kompiliert eine Minimal-Nutzung der IIT-Symbole (danach auskommentieren).
- **Abnahme:** 5 Ergebnisse mit Fallback-Entscheidung.
- **Test:** S
- **API:** siehe M0.2.

#### M0-17 · Messlauf, Entscheidung G0, Aufräumen (2 h) [CC+Luis]
- **Abh.:** M0-11…M0-16, M0-05, M0-06
- **Dateien:** `_context/budgets.md`, `_context/entscheidungen.md`, `_context/status.md`
- **Schritte:**
  1. Luis: *Launch Memory Calculation* (falls nicht per MCP) → Wert melden.
  2. B1-Projektion: `Messwert + 21 × Kosten(1 Niagara) + Audio-Schätzung (Sekunden × gemessene Kosten einer 10-s-WAV) + 15.000 Umgebungsreserve + 5.000 UI-Reserve`.
  3. Tabelle M0.3 abarbeiten (inkl. Fallback-Leiter falls nötig).
  4. Verlierer-Varianten-Code entfernen, Spike-Props der Verlierer löschen; nur die Sieger-Implementierung von `creature_display` bleibt.
  5. `entscheidungen.md`: E-Einträge „G0: Variante …, Stufe …, Proben …“; `status.md` → M1.
  6. Merge `spike/m0` → `dev`, dann Meilenstein-Ende (6.4).
- **Abnahme:** Entscheidung eindeutig; alle Budget-Zeilen B1, B8–B10, B13, B14 gemessen.
- **Test:** 16B (finaler Lauf der Siegervariante)
- **API:** –

### M0.5 Meilenstein-Selbsttest M0
AT-M0-90…95 grün oder mit Fallback entschieden; Frame-Probe der Siegervariante innerhalb Grenze; Save-Rejoin ok.

### M0.6 Aufgaben für Luis (M0)
| Wann | Aufgabe | Dauer |
|---|---|---|
| Do 01.10. | M0-01 komplett (Installationen, UEFN-Projekt, MCP verbinden, Developer Program, Python-Beta-Antrag, Tester einladen) | 3 h |
| Do 01.10. | Recherche-Paket (`deliverables/`, `research_notes/`) nach `C:\FTB_paket\` legen | 5 min |
| Fr 02.10. | UEFN-Klicklisten abarbeiten, die CC in M0-03/M0-08 erzeugt (nur falls MCP Lücken hat) | 0–2 h |
| Fr 02.10. | fortnite.gg: Titel „Fuse the Brainrot“ suchen (GDD 1.1); R0-1/R0-2-Screenshots (Bericht, Aufnahmeliste) falls M0-05 fortnite.gg nicht lesen kann → `research/eco/screens/` | 45 min |
| Sa/So 03.–04.10. | Sessions starten für Messläufe (je 2 Klicks), Sichtproben P1–P4 (je 20 s), P5 (40 Drücke), P6, P11 | 1,5 h |
| Mo 05.10. | Launch Memory Calculation klicken (falls kein MCP) | 10 min |
| Di 06.10. | G0-Ergebnis lesen; nur bei F6 entscheiden | 15 min |

---
## M1 · Graybox-Kernschleife, 1 Spieler (Mi 07.10. – Di 13.10.2026, KW 41–42)

**Ziel:** Die Sekunden-Schleife aus GDD 2.1 und die ersten 2 Minuten aus GDD 3.1/3.2 (ohne Kampf/Fusion) funktionieren für einen Spieler auf der Graybox. Alle Zahlen kommen aus generierten Tabellen.
**Spielbarer Endzustand:** Spawn auf eigenem Plot → Starter-Ei (skriptiert Waffelino) < 30 s → Einkommen tickt → Wiesen-/Sumpf-Ei kaufen, brüten, Reveal → Pads 1–3, Level-Up, Totem, Stall, Freilassen → Leave/Rejoin stellt alles wieder her.
**Vorbedingung:** G0 entschieden (Anzeige-Variante + Fallback-Stufe stehen in `entscheidungen.md`).

#### M1-01 · Daten-Generator + Golden Values (2 h) [CC]
- **Abh.:** M0-17
- **Dateien:** `tools/gen_verse_tables.py`, `tools/gen_golden.py`, `data/econ_params.json`, Marker-Bereiche in `ftb_types.verse`, `ftb_economy.verse`, `ftb_fusion.verse`, `ftb_creature_pool.verse`
- **Schritte:**
  1. `data/econ_params.json` 1:1 aus GDD 5.8 (Claude liest nur diese Tabelle per `sed -n '/^### 5.8/,/^### 5.9/p' docs/GDD_Fuse_and_Fight.md`) plus Ei-Tabelle GDD 4.3 und Seltenheits-Tabelle 4.2.
  2. Generator (stdlib `csv`, `json`): schreibt Marker `catalog` (10 Arten mit Faktoren, 7 Seltenheiten, 88 Kreaturen als Array von Tupeln/Structs, 8 Eier), `econ`, `names` (Array Index `(K−1)·100+(B−1)·10+(A−1)` → Name; Silben-IDs je Art), `secret` (8 Rezepte GDD 4.8), `mounts`. Option `--check` meldet Abweichungen ohne zu schreiben.
  3. `gen_golden.py`: berechnet mit den Formeln aus `economy_sim.py` 30 Referenzwerte (Einkommen je Seltenheit/Level/Gen, Level-Kosten, Totem-Kosten, Pad-Kosten, Rebirth-Kosten n=0..3, Wellenstärke w=1,10,50, `fmt()` für 12 Zahlen) → schreibt sie als Verse-Array in den Marker `golden` in `ftb_game_manager.verse`.
- **Abnahme:** Generator idempotent (2. Lauf = keine Änderung); Verse kompiliert.
- **Test:** S → AT-M1-2 (Golden Values: Verse-Ergebnis = Python ± 0,1 %)
- **API:** – (reines Verse)

#### M1-02 · Typen, Katalogzugriff, FormatBig (1,5 h) [CC]
- **Abh.:** M1-01
- **Dateien:** `Content/Verse/ftb_types.verse`, `Content/Verse/ftb_economy.verse` (`FormatBig`)
- **Schritte:** Referenz `docs/verse_reference/ftb_types.verse` übernehmen; Zugriffsfunktionen `SpeciesDef(Id)`, `RarityDef(R)`, `EggDef(Tier)`, `CreatureName(C)` (rein → Basisname je Seltenheit aus Katalog; sonst `HybridName`; Titel-Präfix ab Legendär); `FormatBig` 1:1 nach `fmt()`.
- **Abnahme:** Golden-Values für `fmt()` 12/12 PASS.
- **Test:** S (AT-M1-2)
- **API:** –

#### M1-03 · Save-Service v1 (2 h) [CC]
- **Abh.:** M1-02, M0-16
- **Dateien:** `Content/Verse/ftb_save.verse`
- **Schritte:** Schema 4.3 aus Referenz; `LoadSave`/`MigrateSave`/`ApplySave`/`BuildSave`/`TryCommitState`; Commit-Politik 4.3 (Sofort-Ereignisse + Sammel-Commit alle 30 s über `Dirty`); Lade-Fehler-Schutz; Debug-Befehl `AutoTest=99` = Save des ersten Spielers zurücksetzen.
- **Abnahme:** AT-M1-3 PASS (Rundreise: Zustand → Save → neuer State → identisch, 40 Felder verglichen).
- **Test:** S, Rejoin durch Luis im Selbsttest
- **API:** `weak_map`, `persistable`, `FitsInPlayerMap` VERIFIED (Doku) + Digest.

#### M1-04 · Plot-Aufbau final (Graybox) + Welt-Objekte (2 h) [CC]
- **Abh.:** M0-09, M0-17
- **Dateien:** `tools/place_plots.py` (erweitern), `blender/gen_misc_meshes.py` (neu: Pad, Nest, Ei, Ei-Automat, Fusions-Maschine, Totem-Segment, Plot-Kern, Portal, Kapsel, 3D-Pfeil; einfache Primitive, Palette-UVs, Budget je ≤ 1.500 Tris)
- **Assets:** A38–A49 (Anhang A), Import nach 5.3, MI `MI_FTB_Prop`
- **Devices:** unverändert D01–D08 (Katalog), plus D16 Billboard ×16 (Plot-Schild) an (+2.000, +600) lokal
- **Schritte:** Meshes erzeugen/exportieren/importieren; je Plot platzieren: Pads als Keks-Sockel (Pad 1–2 sichtbar, 3–6 versenkt −60 cm, „steigt aus dem Boden“ beim Kauf per `MoveTo`), Nest, Ei-Automat, Maschine, Totem, Kern, Portal, Pfeil (versteckt).
- **Abnahme:** 16 identische Plots; Actor-Zahl ≤ B9; Memory-Zwischenwert in `budgets.md`.
- **Test:** S (Sichtprüfung Luis im Selbsttest)
- **API:** –

#### M1-05 · Game-Manager: Join/Leave, Plots, Teleport, Dösen (1,5 h) [CC]
- **Abh.:** M1-03, M1-04
- **Dateien:** `Content/Verse/ftb_game_manager.verse`
- **Devices:** D01 ×16, D08 ×16 (Boss-Teleporter-Knopf, vorerst Hub-Besuch), Hub-Rückkehr D09c ×4
- **Schritte:** Fluss 4.4 Nr. 1 und 9; Plot-Wahl niedrigster freier Index; `TeleportTo`; Dösen: alle 10 s Position/Blick vergleichen, nach 300 s ohne Änderung und ohne Hype-Druck → Einkommen ×0,25, HUD-Hinweis (GDD 8); Bot-Plots bleiben für Messungen verfügbar.
- **Abnahme:** AT-M1-1 Schritt „Plot zugewiesen + teleportiert“ PASS; Dösen per `DebugTimeScale=60` in 10 s ausgelöst.
- **Test:** S, 16B (Join mit 15 Bot-Plots belegt → Spieler bekommt Plot 16)
- **API:** `PlayerAddedEvent`, `PlayerRemovedEvent`, `fort_character.TeleportTo`, `GetTransform` – Digest.

#### M1-06 · Wirtschaft: Einkommen, Eier, Brut, Pity, Level-Up, Totem, Pads, Stall, Freilassen (2 h) [CC]
- **Abh.:** M1-02, M1-05
- **Dateien:** `Content/Verse/ftb_economy.verse`
- **Devices:** D02 ×16 (Nest), D03 ×16 (Ei-Automat) – `InteractedWithEvent` abonnieren
- **Schritte:** Referenz übernehmen; eine 1-Hz-Schleife für alle Spieler (B15); Brut-Timer in Spielzeit (auch nach Rejoin fortgesetzt, Restsekunden im Save); `RollEggRarity` mit sichtbarem Pity (50. Schlupf); Art-Verteilung GDD 4.3; Stall-Limit 30 (IIT 50); Freilassen → Kerne; Pads 3–6 mit Kosten; Totem.
- **Abnahme:** AT-M1-1 (Wirtschaftsteil) PASS; Einkommen nach 10 simulierten Minuten mit festem Zufalls-Seed im Debug innerhalb ±10 % des Python-Werts für denselben Kauf-Plan (Szenario-Skript kauft deterministisch).
- **Test:** S, 16B (Einkommens-Schleife mit 16 Plots: Kosten ≤ 2 ms/Tick, `[FTB][PERF][ECO]`)
- **API:** `GetRandomInt/GetRandomFloat` (Digest); `button_device.InteractedWithEvent` VERIFIED (Standard-Device-API) + Digest.

#### M1-07 · Anzeige: Kreaturen auf Pads (produktiv) (2 h) [CC]
- **Abh.:** M0-17, M1-04, M1-06
- **Dateien:** `Content/Verse/ftb_creature_pool.verse`
- **Assets:** A01–A24, A71–A77 (fehlende 4 Seltenheits-MIs hier anlegen, Werte GDD 4.2), A39 Kapsel (falls F1)
- **Schritte:** Sieger-Variante aus G0 produktiv machen: `ShowCreature(Plot, Pad, C)` = Körper auf Pad, Kopf/Acc per Offset-Tabelle (`mounts`), MI je Seltenheit (bzw. Fallback-Aura), „Landen“-Juice (Squash per `MoveTo`-Skalierung oder Positions-Hüpfer), Ei im Nest mit Wackel-Rotation ±8° während Brut; Plot-Neuaufbau aus Save beim Join.
- **Abnahme:** Kreatur erscheint ≤ 0,5 s nach Reveal-Bestätigung korrekt zusammengesetzt (Luis-Sicht); X4 ≤ B14.
- **Test:** S, 16B
- **API:** laut G0.

#### M1-08 · UI 1: HUD S0 + Toasts + Tutorial-Karte S19 (2 h) [CC]
- **Abh.:** M1-06
- **Dateien:** `Content/Verse/ftb_ui.verse`
- **Schritte:** Verse-UI (P-05); HUD-Elemente GDD 10.3 S0 (Münzen, „+x/s“, Kerne, Nächstes Ziel, Toast-Stapel max. 3 à 2,5 s); Münz-Ticker ≤ 10 Hz, übrige Felder ≤ 2 Hz (B15); Texte als `<localizes>`-Messages (EN als Standard, DE-Übersetzung vorbereitet in M7); Seltenheit immer Symbol + Text; Safe-Zone-Prozentwerte aus GDD.
- **Abnahme:** HUD sichtbar, keine Überlappung mit unteren Ecken (30 % B × 35 % H frei), Zahlen = FormatBig.
- **Test:** S, C (HUD nicht interaktiv → Bewegung frei), M (in M7)
- **API:** Verse-UI VERIFIED; Fortnite-Schriften in Verse-UI UNVERIFIED → Standardschrift.

#### M1-09 · UI 2: Ei-Automat S1 + Schlupf-Reveal S2 (2 h) [CC]
- **Abh.:** M1-08
- **Dateien:** `Content/Verse/ftb_ui.verse`
- **Schritte:** S1 mit 4 Ei-Karten (Quoten-Tabelle 7 Zeilen, Pity „12/50“, Zustände leistbar/zu teuer/gesperrt), „KAUFEN ×1/×3“, Fokus-Reihenfolge GDD; S2 Reveal: Abdunkeln, Risse-Stufen (als 3 Bildwechsel), Namensbanner, Seltenheits-Symbol, „Aufs Pad“/„In den Stall“, Auto-Schließen bis Ungewöhnlich nach 1,5 s, Überspringen nach 400 ms; Reveal-Niagara `NS_FTB_Reveal_R<n>` am Nest (nur R0–R2 in M1, Rest M2).
- **Abnahme:** Kauf-Flow per Autoplay (UI-unabhängige Service-Aufrufe) und per Hand (Luis: 1 Kauf mit Maus, 1 mit Gamepad).
- **Test:** S, C
- **API:** `AddWidget(…, player_ui_slot{InputMode := ui_input_mode.All})` VERIFIED; Controller-Fokus laut P6.

#### M1-10 · UI 3: Stall S3/S4 minimal + Pad-Verwaltung (1,5 h) [CC]
- **Abh.:** M1-09
- **Dateien:** `Content/Verse/ftb_ui.verse`, Menü-Terminal D05
- **Schritte:** Menü mit Tab „Stall“: Raster 6×5 Karten (Porträt vorerst Text + Seltenheitsfarbe; Icons folgen M2), Detail S4 mit „AUFS PAD“, „LEVEL-UP <Kosten>“, „FREILASSEN (+n ◆)“ (2 s halten: Verse-Timer zwischen Press und Release nicht verfügbar → **Fallback-Entwurf:** Freilassen = Knopf + Bestätigungsdialog „Wirklich?“), Sortierung nach Einkommen.
- **Abnahme:** Pad-Tausch, Level-Up, Freilassen funktionieren und speichern.
- **Test:** S, C
- **API:** Halten-Geste in Verse-UI UNVERIFIED → Bestätigungsdialog (Plan-Entscheidung P-06).

#### M1-11 · Tutorial Minute 0–2 (1,5 h) [CC]
- **Abh.:** M1-07, M1-09
- **Dateien:** `Content/Verse/ftb_game_manager.verse` (Tutorial-Zustandsmaschine; Schritt im Save `Stats`/`Settings`), `ftb_ui.verse`
- **Schritte:** GDD 3.1: Starter-Ei immer Waffelino Gewöhnlich (5 s Brut), 3D-Pfeil (A48 + `NS_FTB_Arrow`) über Nest → Ei-Automat → Pad-Kauf; eine Anweisung gleichzeitig; Kampf-/Fusionsschritte folgen in M2/M3.
- **Abnahme:** AT-M1-1: erste Kreatur ≤ 30 s Spielzeit, erstes gekauftes Ei ≤ 45 s, erstes Level-Up ≤ 120 s (Autoplay mit menschlichen Wartezeiten 3 s je Aktion).
- **Test:** S
- **API:** –

#### M1-12 · Thumbnail-Mockups für den Klick-Test (1 h) [CC]
- **Abh.:** M0-07
- **Dateien:** `blender/gen_thumbs.py` → `blender/out/thumbs/mock_A.png`, `mock_B.png`, `mock_C.png` (1920×1080)
- **Schritte:** Blender-Szene: Motiv A „Kreatur + Kreatur = leuchtender Hybrid“ (ohne Pfeile! Launch-Plan 0.2), B „Hybrid-Trio haut riesigen Boss-Schatten“, C Winter-Variante; Hintergrund Himmel-Verlauf `#5EC8FF→#CFF3FF`; Titel-Schrift bleibt leer (Luis setzt Text in Canva/GIMP, falls gewünscht).
- **Abnahme:** 3 PNGs, ≤ 5 MB, 16:9.
- **Test:** –
- **API:** –

#### M1-13 · Meilenstein-Selbsttest M1 + Budgets + Abschluss (1,5 h) [CC+Luis]
- **Abh.:** M1-01…M1-11
- **Schritte:** Code-Review-Checkliste 4.8; Session (Luis 2 Klicks); `AutoTest=1,2,3` nacheinander; Luis: Leave + Rejoin + 5-min-Sichtprüfung mit Liste „Spawn richtig? Starter-Ei? Kreatur korrekt zusammengesetzt? HUD lesbar? Kauf mit Gamepad?“; 16B-Messlauf; `budgets.md` Spalte M1; Meilenstein-Ende 6.4.
- **Abnahme (G1):** AT-M1-1/2/3 PASS; B1, B8, B9, B13, B15 grün oder gelb mit Maßnahme; Rejoin identisch.
- **Test:** S, C, 16B

### M1 · Aufgaben für Luis
| Wann | Aufgabe | Dauer |
|---|---|---|
| Mi 07.10. | Klicklisten aus M1-04/M1-08 (nur falls MCP Lücken) | 0–1 h |
| Do 08.10. | **Thumbnail-Klick-Test** (GDD 14.1 Woche 2): mock A/B/C gegen 3 Top-Brainrot-Thumbnails (Screenshots von fortnite.gg) als Umfrage an ≥ 20 Personen (WhatsApp/Discord-Umfrage „Welche Insel würdest du anklicken?“), Ergebnis bis **So 11.10.** in `_context/playtests.md` | 1 h |
| Di 13.10. | Selbsttest-Session: 2 Klicks, Rejoin, 5-min-Sichtprüfung, 2 Käufe (Maus/Gamepad) | 30 min |

---

## M2 · Fusion, Index, Namen, Look (Mi 14.10. – Di 20.10.2026, KW 42–43)

**Ziel:** Das Alleinstellungsmerkmal steht: Fusion mit Teilewahl und Pflicht-Vorschau, gesungener Name, Index, alle Seltenheits-Looks, Icons, 16 Plots parallel.
**Spielbarer Endzustand:** Spieler fusioniert zwei Kreaturen mit freier Teilewahl, sieht vorher Name/Werte/Resonanz-Quote, erlebt Reveal mit Silben-Chant, Index zählt, Hybrid steht korrekt auf dem Pad; 16 Bot-Plots laufen parallel.

#### M2-01 · Fusions-Kern (2 h) [CC]
- **Abh.:** M1-13
- **Dateien:** `Content/Verse/ftb_fusion.verse`
- **Schritte:** GDD 4.6/4.8: Kosten `120 × Einkommen_Basis[r] × Rebirth-Mult` + Kerne je Seltenheit; Dauer je Seltenheit (Spielzeit, im Save); Ergebnis-Seltenheit (höhere; gleiche → Resonanz 20 %, Pity 5; max. Mythisch; Geheim nur Rezept mit 2 mythischen Eltern); Level = max, Gen = max+1 (≤ 10), Neben-Trait ab Gen 5 bzw. Spiegel-Fusion; Reinheits-Bonus, Regenbogen-Flag; Auto-Vorschlag „Ziel Einkommen/Kampf“; `PreviewFusion` ist **reine Funktion** (gleiches Ergebnis wie `StartFusion` bis auf Resonanzwurf).
- **Abnahme:** AT-M2-1 (20 Regeltests: Downgrade nie, Resonanz-Pity greift beim 5., Geheim-Rezept G01 ergibt Geheim, Gen-Deckel, Kostenformel = Golden Value).
- **Test:** S
- **API:** –

#### M2-02 · Fusions-UI S5 + Stall-Picker + Reveal S6 (2 h) [CC]
- **Abh.:** M2-01, M2-06
- **Dateien:** `Content/Verse/ftb_ui.verse`
- **Devices:** D04 ×16 (Fusions-Maschine)
- **Schritte:** Layout GDD S5 (Eltern links/rechts, 3 Zeilen A/B-Umschalter, Wirkungstext, Vorschau mit Porträt aus 3 übereinander gelegten Teil-Icons, Werte mit Differenz ▲/=, „20 % Resonanz → Episch (3/5)“, Badge „INDEX: NEU!“, Kostenzeile, „FUSIONIEREN“); laufende Fusion: Restzeit + „Einsammeln“; S6: Karten-Zusammenflug (3 Positionsschritte), Flash (entfällt bei „Reduzierte Blitze“), Silben einzeln (je 180 ms) + Stempel „NEU!“.
- **Abnahme:** Kompletter Fusionsfluss per Hand (Luis im Selbsttest, Maus + Gamepad) und per AT-M2-2.
- **Test:** S, C
- **API:** Verse-UI VERIFIED; Bild-Überlagerung in `overlay` VERIFIED (Doku UI-Modul).

#### M2-03 · Fusions-Maschine in der Welt (1 h) [CC]
- **Abh.:** M2-01
- **Dateien:** `ftb_creature_pool.verse`
- **Assets:** A43 Fusions-Maschine, `NS_FTB_Lightning`, `NS_FTB_Confetti`
- **Schritte:** Eltern verschwinden vom Pad (Hide), Maschine „rattert“ (Rotation ±3° per `MoveTo`, 1× pro 2 s, nur wenn ein Spieler ≤ 30 m ist), Blitz-VFX alle 4 s, fertig: Konfetti + Billboard „FERTIG!“ (D16 der Maschine, falls Billboard-Budget reicht; sonst Toast).
- **Abnahme:** keine Schleife läuft, wenn keine Fusion aktiv ist.
- **Test:** S, 16B
- **API:** –

#### M2-04 · Index S9 + Bonus (1,5 h) [CC]
- **Abh.:** M2-01
- **Dateien:** `ftb_fusion.verse` (Buchung), `ftb_ui.verse` (Tab „Index“)
- **Schritte:** Bit-Buchung (Hybride nach Formel aus Referenz, Basis 40, Event 40, Geheim 8); Einkommensbonus +0,4 %/Eintrag, Deckel +100 %; Untertabs Arten/Hybride (Kapitel-Wahl 8 Köpfe, 8×8-Raster)/Geheim/Event/Bestiarium; Meilensteine 25…500 mit Gratis-Ei + Titel (Titel = Text im Namensschild, keine Accolades).
- **Abnahme:** AT-M2-3: 30 zufällige Fusionen → Index-Zähler = Anzahl eindeutiger Kombis; Bonus korrekt.
- **Test:** S, C
- **API:** –

#### M2-05 · Seltenheits- und Event-Looks + Auren (2 h) [CC]
- **Abh.:** M0-08
- **Dateien:** Content `FTB/Materials/`, `FTB/VFX/`
- **Assets:** A71–A77 final, A78–A83 Event-MIs, A84 `MI_FTB_Sternen`, `NS_FTB_Reveal_R3…R6`, `NS_FTB_Crown`, `NS_FTB_Aura_Mythic`, `NS_FTB_Halo_Cosmic`, `NS_FTB_Resonance`
- **Schritte:** Parameter laut GDD 4.2 und `materials_spec.md`; Kosmisch: Sternenfeld-Panning mit `T_FTB_Noise`; Event-MIs: Farbton-Verschiebung + Muster (Frost-Weiß, Funken-Emissive, Schleim-Grün, Kosmos, Festival-Konfetti, Gründer-Gold); Niagara nach 5.7.
- **Abnahme:** Alle 14 MIs + 7 Reveal-Systeme vorhanden; Luis-Sichtprüfung im Selbsttest (Showroom-Pad im Hub zeigt 7 Seltenheiten nebeneinander, `AutoTest=20`).
- **Test:** S, M (Kristall-Dither auf Mobile in M7)
- **API:** Masked + Dither in UEFN-Material UNVERIFIED → Fallback: Kristall als opak mit starkem Fresnel.

#### M2-06 · Icons rendern + importieren (1,5 h) [CC]
- **Abh.:** M0-07
- **Dateien:** `blender/gen_icons.py` → `art_src/icons/*.png`
- **Assets:** A62 (24 Teil-Icons, je Slot so gerendert, dass Kopf-/Körper-/Acc-Icon im 256²-Raster übereinander ein Porträt ergeben: gemeinsamer Kamera-Ausschnitt, Körper-Montagepunkte aus `parts_layout.json`), A63 Währungen (3), A64 Seltenheits-Symbole (7: ● ◆ ▲ ★ ♛ ✦ ∞ als Textur), A65 Ei-Icons (8)
- **Abnahme:** 42 PNG 256² RGBA, B6/B7 eingehalten; Porträt-Probe (3 Icons übereinander) sieht zusammenhängend aus (Luis 10 s).
- **Test:** –
- **API:** –

#### M2-07 · TTS-Silben + Chant (2 h) [CC]
- **Abh.:** M0-01 (Kokoro installiert, siehe Luis-Aufgaben), M2-01
- **Dateien:** `tools/tts_syllables.py`, `audio_src/syl/*.wav`, `ftb_ui.verse`/`ftb_fusion.verse` (Chant-Abfolge)
- **Devices:** D13 Audio-Player „Silbe“ ×30 (Katalog)
- **Assets:** A100–A129 `A_FTB_Syl_<Art>_<P|M|S>`
- **Schritte:**
  1. Silben aus Katalog (GDD 4.4 „Silben P/M/S“, 10 Arten) → Kokoro `lang_code='i'`, Stimme `if_sara` (Art 1–5) / `im_nicola` (Art 6–10) → WAV 24 kHz.
  2. ffmpeg je Datei: `ffmpeg -y -i in.wav -af "asetrate=24000*2^(<HT>/12),aresample=22050,chorus=0.6:0.9:50:0.4:0.25:2,loudnorm=I=-16:TP=-12" -ac 1 -ar 22050 out.wav` mit HT = 4 + (Art mod 6).
  3. Import, 30 Audio-Player (spatialization aus, Register-Modus), Chant: Präfix(Kopf) → 180 ms → Mitte(Körper) → 180 ms → Suffix(Acc) für den Instigator.
- **Abnahme:** 30 WAV ≤ 1,2 s, Pegel −12 dBFS ±1; Chant hörbar im Reveal (Luis 1 min).
- **Test:** S
- **API:** `audio_player_device.Register/Play` VERIFIED (Register) + Digest; Nur-für-Spieler-Hörbarkeit UNVERIFIED → Fallback: Silben spatial am Plot abspielen (Nachbarn hören leise mit).

#### M2-08 · UI-Sounds + Fanfaren (1,5 h) [CC]
- **Abh.:** M0-02
- **Dateien:** `tools/gen_sfx.py` → `audio_src/ui/*.wav`, `audio_src/fanfare/*.wav`
- **Devices:** D14 Audio-Player „UI“ ×8, „Fanfare“ ×7
- **Assets:** A130–A137 UI (Klick 40 ms, Fokus 20 ms, Panel auf 180 ms, Panel zu 120 ms, Kauf 400 ms, Fehler 150 ms, Münz-Tick, Kern-Pling), A138–A144 Fanfaren (0,4/0,6/0,9/1,4/2,2/2,8/4,0 s; Geheim mit Bass-Drop)
- **Abnahme:** 15 WAV, Pegel laut GDD 12 (Effekte Spitze −6 dBFS).
- **Test:** S
- **API:** –

#### M2-09 · 16 Plots parallel, Plots-Tab S15, Herzen, Plot-Schilder (1,5 h) [CC]
- **Abh.:** M1-13
- **Dateien:** `ftb_game_manager.verse`, `ftb_ui.verse`, `ftb_events.verse` (Herz-Zähler Session)
- **Devices:** D07 ×16 (Herz), D16 ×16 (Plot-Schild)
- **Schritte:** Plots-Tab mit Liste (Plot-Nr., Name falls P9 bestanden, stärkster Hybrid, Herzen) + „BESUCHEN“ = `TeleportTo` Plot-Tor; Herz geben (1× je Plot und Session, max. 15 Kerne); Schild-Text per `SetText`.
- **Abnahme:** 16B: alle Schilder aktualisieren; Besuch teleportiert korrekt.
- **Test:** S, 16B, 2P (falls P11 bestanden)
- **API:** `billboard_device.SetText` Digest; Spielername laut P9.

#### M2-10 · Tutorial bis erste Fusion + Selbsttest M2 (1,5 h) [CC+Luis]
- **Abh.:** M2-01…M2-09
- **Schritte:** Tutorial-Schritt „Fusion freigeschaltet“ vorerst nach 5 gekauften Eiern (Welle 5 folgt in M3), Pfeil zur Maschine, Vorschlag vorausgewählt; Selbsttest: AT-M2-1…3, 16B-Messlauf, Luis-Sichtprüfung (Fusion mit Gamepad, Chant, 7-Seltenheiten-Showroom), `budgets.md` M2, Meilenstein-Ende.
- **Abnahme (G2):** AT-M2 PASS; erste Fusion im Autoplay (menschliche Wartezeiten) ≤ 5:00; B1 ≤ 45.000 (sonst M0.3 Schritt 3).
- **Test:** S, C, 16B

### M2 · Aufgaben für Luis
| Wann | Aufgabe | Dauer |
|---|---|---|
| Mi 14.10. | Kokoro installieren: `py -3.12 -m venv C:\FTB_tts` · `C:\FTB_tts\Scripts\pip install "kokoro>=0.9.4" soundfile` · eSpeak NG installieren (Installer von github.com/espeak-ng/espeak-ng/releases; GPL-3.0, nur Werkzeug) | 20 min |
| Mi 14.10. | Kokoro-Lizenz prüfen: Modellkarte huggingface.co/hexgrad/Kokoro-82M lesen (Apache-2.0 für Gewichte **und** Voicepacks?) → Ergebnis in `offene_fragen.md` Q-AUD-1 | 10 min |
| Do 15.10. | 8 Kreatur-Laute mit dem Handy aufnehmen (Knusper-Klick+Fiepen, Quaken+Glas-Plopp, Muhen+Zischen, Schlürfen+Blubb, Summen+Disco-Pling, Tröt+Fauchen, Walgesang+Donner, Brummen+Reißverschluss; je 1–2 s, leiser Raum) → `audio_src/vox/raw/` | 30 min |
| Di 20.10. | Selbsttest: 2 Klicks, Fusion mit Gamepad, Chant anhören, Showroom ansehen | 30 min |

---
## M3 · Kampf: Wellen, Hype-Takt, Boss v1 (Mi 21.10. – Do 29.10.2026, KW 43–44)

**Ziel:** Das zweite Verb (Red Team §4) ist spielbar: Solo-Wellen am Plot mit Hype-Takt und Koop-Server-Boss B1. Dazu Musik-Basis, Analytics und ein Tutorial bis zum ersten Boss.
**Spielbarer Endzustand = Test-1-Build:** Die Kernschleife der ersten 30 Minuten (GDD 3.1–3.3, ohne Rebirth/Kalender/Codes/Shop) ist komplett spielbar, auch mit mehreren Spielern.

#### M3-01 · Gegner- und Boss-Meshes (2 h) [CC]
- **Abh.:** M1-04
- **Dateien:** `blender/gen_misc_meshes.py` (erweitern)
- **Assets:** A31 `SM_FTB_Enemy_Staubfussel` (Fussel-Knäuel), A32 `…_Kabelwurm` (Kabel mit Stecker-Kopf), A33 `…_Dosenpanzer` (Blechdose auf Rollen), A34 `…_Ploppblase` (Blase mit Schild-Ring) – je ≤ 2.000 Tris, Höhe 1,2–2 m; A35 `SM_FTB_Boss_Kabelsalat` (Kabelknoten mit Krone, 30 m, ≤ 25.000 Tris); A45 `SM_FTB_Drop_Kern`; Material `M_FTB_Enemy` + `MI_FTB_Enemy_Base`
- **Schritte:** Erzeugen, Budget-Report, Import (5.3), Anzeige-Variante aus G0 auch für Gegner nutzen (A: Pool 4 Typen × 6 je Plot; C: Spawn).
- **Abnahme:** B4 grün; 1 Mini-Boss = Dosenpanzer mit Skalierung 3,0 (kein eigenes Mesh).
- **Test:** –
- **API:** –

#### M3-02 · Wellen-Direktor (2 h) [CC]
- **Abh.:** M3-01, M1-07
- **Dateien:** `Content/Verse/ftb_combat.verse` (`wave_director`), `ftb_creature_pool.verse` (`ShowEnemy`, `MoveEnemyAlongLane`)
- **Devices:** D06 ×16 (KAMPF!-Knopf)
- **Schritte:** GDD 2.4.3: Gegnerzahl `3 + floor(w/10)`, max. 8, höchstens 6 gleichzeitig sichtbar, Pulse bei t = 0/6/12 s; jede 5. Welle Tank, jede 10. Mini-Boss + Meilenstein-Ei; `W(w)`, Gesamt-HP `25·W(w)`; 4-Hz-Sim nur während aktiver Welle (B15); Gegner-Bewegung = **ein** `MoveTo` je Gegner über die Lane-Dauer (25 s bzw. 18 s Kabelwurm), Tod → `Hide` + `NS_FTB_EnemyDeath`; Schwächen-Multiplikatoren je Rolle (Tabelle GDD 2.4.3); Knockout (Dosenpanzer), Schild (Ploppblase, 3 Treffer).
- **Abnahme:** AT-M3-1: Welle w=1…12 mit festem Team; Sieg ⇔ `Σ KK · Hype ≥ W(w)` (±1 Tick); kein Gegner bleibt nach Wellenende sichtbar.
- **Test:** S, 16B (16 gleichzeitige Wellen)
- **API:** `MoveTo(Position, Rotation, Dauer)` Digest; bei Performance-Problemen (B13 gelb) Gegner nur für Plot-Besitzer + Besucher im Umkreis 60 m bewegen (Rest: nur HUD-Balken).

#### M3-03 · Hype-Takt (2 h) [CC]
- **Abh.:** M0-15, M3-02
- **Dateien:** `ftb_combat.verse` (`hype_service`), `ftb_ui.verse` (Takt-Ring in S7)
- **Devices:** D10 ×1 (Input Trigger „Hype“, Einstellungen laut P5-Ergebnis)
- **Assets:** `T_FTB_UI_Ring`, Metronom-Klick A134
- **Schritte:** Ring alle 3,0 s; Schrumpfen in 6 Bildschritten à 200 ms (Server-Takt); Zielzeitpunkt = letzter Schritt; Bewertung serverseitig mit +100 ms Kompensation: Perfekt ±150 ms ×1,5, Gut ±350 ms ×1,25, sonst ×1,0; ein Druck pro Fenster; Diskolama-Accessoire +20 % Fensterbreite; Tutorial-Zeitlupe beim ersten Ring (Ring 2× langsamer); Statistik Perfekt-Quote je Spieler (für Test 1). Fallback-Schalter `HypeMode` (0 = Feuer, 1 = SMASH-Knopf, 2 = Hype-Meter) mit allen drei Wegen implementiert (Knopf und Meter sind wenige Zeilen).
- **Abnahme:** AT-M3-2 (simulierte Drücke mit Offsets −400…+400 ms → richtige Stufe); Luis im Selbsttest: Perfekt-Quote nach 10 Ringen ≥ 30 % (Maus) und ≥ 20 % (Gamepad).
- **Test:** S, C, 2P (Anfeuern folgt M6-03)
- **API:** laut P5.

#### M3-04 · Team, Lunges, Drops, Belohnungen (1,5 h) [CC]
- **Abh.:** M3-02, M3-03
- **Dateien:** `ftb_combat.verse`, `ftb_economy.verse` (Belohnungsformeln GDD 5.7), `ftb_creature_pool.verse` (`Lunge`)
- **Assets:** `NS_FTB_Hit`, `NS_FTB_KernDrop`, A45 Drop
- **Schritte:** Team = 3 höchste KK oder Team-Lock (Stall-Detail „Ins Team“); Lunges max. 3 gleichzeitig je Plot (B12); übrige Pad-Kreaturen „jubeln“ (Hüpfer alle 2 s, nur wenn Besitzer ≤ 40 m); Drops fliegen magnetisch (≤ 4 m, Distanzprüfung 4 Hz nur während Welle); Erstabschluss/Wiederholung/Niederlage-Trostpreis + Tipp-Karte; Kerne erstmals erklärt.
- **Abnahme:** AT-M3-3 Belohnungen = Golden Values.
- **Test:** S, 16B
- **API:** –

#### M3-05 · Boss-Direktor B1 (2 h) [CC]
- **Abh.:** M3-04
- **Dateien:** `ftb_combat.verse` (`boss_director`)
- **Assets:** A35, `NS_FTB_Beam`, `NS_FTB_BossLanding`, `NS_FTB_Confetti`
- **Schritte:** Zeitplan: erster Boss bei Server-Zeit 200 s + k·420 s, Dauer 75 s; Countdown ab T−60 s, Glocke T−10 s; Landung per `MoveTo` von z = 10.000 auf 0 in 1,5 s; Teilnahme ab 480 s Spielzeit (sonst Zuschauer-Kiste 30 s Einkommen); HP = `60 s · Σ(KK_Team · 1,25)`, Neuberechnung in den ersten 20 s bei Beitritt; Sync-Smash bei 66 %/33 % (8 s, ≥ 50 % Perfekt → ×2 für 5 s); Stampfer alle 10 s (Knockout-Regel); Hype-Zone r = 2.000–3.000 um (0,0) (Positionsprüfung 2 Hz) +25 %; Strahl je teilnehmendem Plot (vorab ausgerichtetes `NS_FTB_Beam`, alle 1,5 s neu); Belohnung GDD 5.7 inkl. Boss-Ei; Flucht bei Nicht-Sieg (≥ 60 %); Aufhol-Hilfe (+50 % Boss-Münzen unter 20 % des Medians).
- **Abnahme:** AT-M3-4 (Solo-Boss mit festem Team: HP-Formel, Phasen, Belohnung); 16B: 16 Bot-Teams „nehmen teil“ (simulierte KK), B13 grün.
- **Test:** S, 16B, 2P (falls möglich)
- **API:** `SpawnParticleSystem` VERIFIED; Rotation-Parameter Digest.

#### M3-06 · Wellen-HUD S7 + Boss-HUD S8 (1,5 h) [CC]
- **Abh.:** M3-03, M3-05
- **Dateien:** `ftb_ui.verse`
- **Schritte:** Layout GDD S7/S8 (Welle-Nr., HP-Balken, Timer, Combo-Zähler statt Weltschadenszahlen, Ergebnistext, Gegnertyp-Icons mit Konter-Hinweis, Boss-Pille im S0, „SYNC 7/12“, Hype-Zone „+25 %“, Ergebnis-Panel mit „Boss-Ei öffnen“); Updates ≤ 2 Hz; KAMPF!-Knopf auch als HUD-Knopf (nur bei geöffnetem Plot-Menü, da HUD nicht interaktiv ist).
- **Abnahme:** keine UI-Überlappung mit Joystick-/Feuer-Zonen (Mobile-Maße, M7 prüft auf Gerät).
- **Test:** S, C
- **API:** Verse-UI VERIFIED.

#### M3-07 · Musik-Basis + Audio-Direktor (1,5 h) [CC]
- **Abh.:** M2-08
- **Dateien:** `ftb_ui.verse` (Audio-Direktor-Teil: Musikzustand je Spieler)
- **Devices:** D12 ×4 (Musik Plot/Welle/Boss/Hub)
- **Assets:** Musik aus UEFN-Bibliothek (kein eigener Speicher): je Zustand ein Loop passend zu GDD 12 (Tempo/Stil); gewählte Asset-Namen in `entscheidungen.md`
- **Schritte:** Zustandswechsel mit 1 s Pause statt Crossfade (Crossfade UNVERIFIED); pro Spieler per `Register`, Boss global; Ducking bei Reveals: Musik-Device `SetVolume`, falls vorhanden (Digest), sonst weglassen.
- **Abnahme:** Zustände wechseln korrekt (Luis-Sicht 2 min).
- **Test:** S
- **API:** Pro-Spieler-Musik UNVERIFIED → Fallback globale Musik (Plot/Boss).

#### M3-08 · Analytics-Events (1 h) [CC]
- **Abh.:** M1-06
- **Dateien:** `ftb_events.verse` (`Track`)
- **Devices:** D15 ×16 (Analytics), Event-Namen: `egg_first_hatch, first_upgrade, fuse_1, fuse_2, fuse_5, wave_first_start, wave_first_clear, wave_10, boss_join, boss_kill, rebirth_1, index_10, offer_dialog_open, code_redeem, session_min_10, session_min_30` (Launch-Plan 4.2 + GDD 16.4)
- **Schritte:** Je Ereignis einmal pro Spieler (Flags in `Stats`), `Submit(Agent)`; zusätzlich **Test-Report**: geheimer Code `TESTREPORT` im Code-Terminal (ab M5; bis dahin Menü-Knopf nur bei `DebugMode`) zeigt die eigenen Zeitstempel (erste Kreatur, erstes Upgrade, erste/zweite Fusion, erste Welle, erster Boss, Session-Minuten, Perfekt-Quote) – für Tests in privaten Versionen, wo Logs nicht lesbar sind.
- **Abnahme:** Test-Report zeigt plausible Werte nach AT-M1-1-Lauf.
- **Test:** S
- **API:** `analytics_device.Submit` Digest; Zählung in privaten Versionen UNVERIFIED → Test-Report ist der Fallback.

#### M3-09 · Tutorial bis Boss (1,5 h) [CC]
- **Abh.:** M3-04, M3-05, M2-10
- **Dateien:** `ftb_game_manager.verse`, `ftb_ui.verse`
- **Schritte:** GDD 3.2/3.3 umsetzen: KAMPF!-Knopf pulsiert bei 0:40, erste Welle unverlierbar (Gegner-HP ×0,3), Takt-Ring-Tutorial, Fusion nach Welle 5 (`fusion_unlock_wave`), Maschine fährt aus dem Boden (`MoveTo` z −600 → 0), Hype-Zone-Hinweis bei 9:00, Boss-Countdown-Hinweis, Tagesbelohnungs-Hinweis erst ab 12 min (Platzhalter bis M5).
- **Abnahme:** AT-M1-1 erweitert zu AT-M3-5: erste Welle ≤ 1:10, erste Fusion gestartet ≤ 5:00, erster Boss ≤ 15:00 (Spielzeit, menschliche Wartezeiten).
- **Test:** S
- **API:** –

#### M3-10 · Messlauf 16B + Budgets (1,5 h) [CC]
- **Abh.:** M3-02…M3-06
- **Schritte:** `BotPlots=16`, alle 16 Plots mit Dauerwellen, Boss aktiv, Beams an; 3 Messfenster à 60 s; Memory Calculation; `budgets.md` M3. Bei Gelb/Rot: Maßnahmen aus B13-Zeile (Gegner-Bewegung nur nahe Plots, Jubel-Hüpfer aus, Beam-Intervall 3 s).
- **Abnahme:** B1, B9–B15, B17 grün oder mit umgesetzter Maßnahme gelb.
- **Test:** 16B

#### M3-11 · Test-1-Build + Selbsttest M3 (1,5 h) [CC+Luis]
- **Abh.:** M3-01…M3-10
- **Schritte:** Selbsttest (AT-M3-1…5, Luis-Sichtprüfung: Welle mit Maus und Gamepad, Boss solo); `DebugMode=false` aber Test-Report an; Commit + Tag `m3-test1`; Luis lädt eine **private Version** hoch (Creator Portal) und legt die Tester-Zugänge an; `playtests.md` Abschnitt Test 1 vorbereiten (Protokoll steht in M4-01).
- **Abnahme (G3, Do 29.10.):** private Version startet bei Luis auf PC; 2P mit zweitem Konto geprüft (in der privaten Version).
- **Test:** S, C, 2P

### M3 · Aufgaben für Luis
| Wann | Aufgabe | Dauer |
|---|---|---|
| Do 22.10. | Optional als Referenz: Aufnahmen C-2 (Bosskampf Fight The Brainrot) und E-1 (Welle Garden vs Brainrots) aus der Bericht-Aufnahmeliste, je 45 s → `research/rec/` | 30 min |
| Di 27.10. | Hype-Takt-Gefühlstest: 3 Wellen mit Maus, 3 mit Gamepad; Note 1–5 in `playtests.md` | 20 min |
| Do 29.10. | **Private Version hochladen:** UEFN *Publish → Create private version* bzw. Creator Portal (genaue Bezeichnung UNVERIFIED, Launch-Plan 8.3); Tester als Playtester hinzufügen; Einladungs-/Inselcode an Tester | 45 min |
| Do 29.10. | Selbsttest-Session + 2P mit zweitem Konto in der privaten Version | 45 min |

---

## M4 · Test 1 und Kern-Iteration (Fr 30.10. – Mi 04.11.2026, KW 44–45)

**Ziel:** Kernschleife mit Menschen messen (GDD 14.1, Zeile Test 1), Kill-Kriterien anwenden, höchstens diese eine Iterationsphase nutzen.
**Spielbarer Endzustand:** Test-1-Build plus Fixes und Balancing; alle Kill-Kriterien bewertet.

#### M4-01 · Testvorbereitung (1 h) [CC]
- **Abh.:** M3-11
- **Dateien:** `_context/playtests.md` (Abschnitt „Test 1“ ausfüllen: Ablauf, Fragen, Messbogen)
- **Schritte:** Tester-Anleitung (5 Sätze, ohne Spielerklärung: „Spiel, als hättest du die Insel in Discover gefunden. Sag laut, was du denkst.“), Ablauf: 13:00 Einzel-Session 45 min ohne Hilfe (Luis schaut per Discord-Stream, Stoppuhr), 13:50 Koop-Session 45 min alle zusammen (Boss), 14:40 Test-Report-Screenshot (`TESTREPORT`), 14:45 Fragebogen (5 Fragen Launch-Plan 4.2 + „Kampf-Spaß 1–5“ + „Würdest du freiwillig noch mal fusionieren? Warum?“).
- **Abnahme:** `playtests.md` Test-1-Abschnitt vollständig; Luis hat den Link.
- **Test:** –

#### M4-02 · Test 1 durchführen (Sa 31.10., 3 h) [Luis]
- **Abh.:** M4-01
- **Schritte:** Laut `playtests.md`; Beobachtungen stichpunktartig (Minute + Beobachtung); Test-Reports (3 Screenshots) + Fragebögen nach `playtests/test1/` (Ordner im Repo, PNG per LFS).
- **Abnahme:** 3 Test-Reports, 3 Fragebögen, Beobachtungsliste.

#### M4-03 · Auswertung + Kill-Entscheidung (1 h) [CC]
- **Abh.:** M4-02
- **Dateien:** `_context/playtests.md`, `_context/entscheidungen.md`
- **Schritte:** Ziele gegen Messung (GDD 14.1): erste Fusion < 5 min; ≥ 2 von 3 fusionieren unaufgefordert ein 2. Mal; Median-Session > 20 min; Kampf-Spaß ≥ 4/5 bei ≥ 2; Perfekt-Quote ≥ 15 %. Entscheidungsregeln:
  - Perfekt-Quote < 15 % → Fenster ±250/±500 ms (sofort, M4-05); nach M4 erneut < 15 % im Selbsttest-Gefühl von Luis → `HypeMode=2` (Hype-Meter).
  - 0–1 Ziele verfehlt → Fixes in M4-05…07, weiter nach Plan.
  - **≥ 2 Ziele verfehlt → Scope-Schnitt ab sofort:** Bonus-Arten raus, Event-Kalender 4 Wochen (W5–W8 als Rotation), nur Boss B1 (+ MI-Varianten). M4 wird die einzige Iterationsphase.
  - Bug-Liste priorisieren: Blocker > Datenverlust > Verständnis-Hürden (Stellen, an denen ≥ 2 Tester fragten) > Balance > Optik.
- **Abnahme:** Entscheidung in `entscheidungen.md`, Fix-Liste mit ≤ 12 Einträgen in `status.md`.

#### M4-04 · Balancing mit Simulation (1,5 h) [CC]
- **Abh.:** M4-03
- **Dateien:** `data/econ_params.json`, `data/economy_sim.py` (nur Parameter über `--params`), Generator-Lauf
- **Schritte:** Jede Parameteränderung zuerst `python data/economy_sim.py --runs 10 --params <änderung>`; Ziele GDD 5.9 (erste Rebirth 2–3 h, 10-h-/50-h-Ziele) müssen halten; dann `gen_verse_tables.py` + `gen_golden.py`; Änderungen in `entscheidungen.md` (alt → neu, Grund).
- **Abnahme:** Sim-Ziele ✔; Golden Values PASS.
- **Test:** S (AT-M1-2)

#### M4-05 · Fix-Slot 1 (2 h) · M4-06 · Fix-Slot 2 (2 h) · M4-07 · Fix-Slot 3 (2 h) [CC]
- **Abh.:** M4-03
- **Schritte:** Je Slot die obersten Einträge der Fix-Liste; jeder Fix mit Commit `M4-0x: <fix>`; kein neues Feature.
- **Abnahme:** Blocker = 0; Verständnis-Hürden adressiert (Tutorial-Texte/Pfeile).
- **Test:** zugehörige AT-Szenarien.

#### M4-08 · Selbsttest M4 (1 h) [CC+Luis]
- **Schritte:** AT-M1…M3 komplett, 16B kurz (60 s), Meilenstein-Ende.
- **Abnahme (G4):** alle AT PASS; Entscheidung Test 1 umgesetzt.

### M4 · Aufgaben für Luis
| Wann | Aufgabe | Dauer |
|---|---|---|
| Fr 30.10. | Tester-Termin bestätigen, Discord-Stream-Kanal, Anleitung verschicken | 20 min |
| **Sa 31.10.** | **Test 1** (M4-02) | 3 h |
| So 01.11. | Ergebnisse ins Repo (`playtests/test1/`), 10 min Gespräch mit CC über Eindrücke (CC fragt gezielt) | 30 min |
| Mi 04.11. | Selbsttest-Session | 20 min |

---

## M5 · Meta, Live-Ops-Technik, IIT, Save-Freeze (Do 05.11. – Di 10.11.2026, KW 45–46)

**Ziel:** Alle Systeme, die Daten im Save brauchen, sind drin; danach ist das Save-Schema eingefroren.
**Spielbarer Endzustand:** Rebirth, Tagesbelohnung/Streak (bzw. Treue-Kalender), Codes, Event-Woche mit Event-Ei (per Debug-Zeit), IIT-Shop (im Debug mit Grant/Remove), Rückkehr-Bonus.

#### M5-01 · Rebirth + S10 (2 h) [CC]
- **Abh.:** M4-08
- **Dateien:** `ftb_economy.verse` (`CanRebirth`, `DoRebirth`), `ftb_ui.verse` (S10, Rebirth-Balken im HUD ab 25 %)
- **Schritte:** GDD 5.6: Kosten `300M·4,25^n` + Welle ≥ `20+10n`; Behalten/Zurücksetzen exakt; übrige Kreaturen → Kerne (Freilassen-Wert); min(1+n, 6) stärkste bleiben (Level 1, Gen bleibt); ×1,45; Level-Cap +5; Ei-Stufen bei 2/5/9/14; Auto-Brut ab 1; Titel; Bestätigung: „REBIRTH“ + Bestätigungsdialog (P-06); Juice: Plot-Weiß-Flash (UI), `NS_FTB_Resonance` groß.
- **Abnahme:** AT-M5-1 (Zustand vorher/nachher, 25 Prüfungen).
- **Test:** S, C

#### M5-02 · Zeitquelle + Tagesbelohnung/Streak S11 (2 h) [CC]
- **Abh.:** M0-16
- **Dateien:** `ftb_time.verse`, `ftb_events.verse`, `ftb_ui.verse` (Tab „Kalender“)
- **Schritte:** `time_service` mit Quelle laut P8: EPOCH (UTC-Tag = floor(t/86.400)) oder SESSION-Fallback (Tag = Session mit ≥ 15 aktiven Minuten, max. 1 je Session, Name „Treue-Kalender“, keine Streak); `DebugOffsetSec` (nur Debug); 7-Tage-Schleife GDD 7.1 inkl. Streak-Schutz 1×/Woche; Belohnungen einkommens-skaliert; Popup frühestens ab 12 min Spielzeit am ersten Tag.
- **Abnahme:** AT-M5-2 (Tage 1–8 per Offset, Streak, Schutz, Lücke von 2 Tagen).
- **Test:** S
- **API:** P8-Ergebnis.

#### M5-03 · Code-Terminal S12 (1,5 h) [CC]
- **Abh.:** M5-02
- **Dateien:** `data/codes.csv` (16 Codes GDD 7.2 + `TESTREPORT` debug-only-Flag), `ftb_events.verse` (`RedeemCode`), `ftb_ui.verse` (Bildschirm-Tastatur 6×6)
- **Devices:** D09a Code-Terminal ×1 (Hub (0, +3.200))
- **Schritte:** Gültigkeit: ab Wochenstart 21 Tage, `HALLOHASKE` dauerhaft; einmal je Spieler (Bitfeld); Belohnung einkommens-skaliert; Feedback gültig/unbekannt/abgelaufen/schon eingelöst; Fokus-Start auf OK.
- **Abnahme:** AT-M5-3 (alle 16 Codes über 10 Wochen Offset: richtige Gültigkeit).
- **Test:** S, C

#### M5-04 · Event-Kalender-Technik (2 h) [CC]
- **Abh.:** M5-02
- **Dateien:** `data/events.csv` (8 Wochen: Thema, Event-Ei, 5 Kreatur-IDs E1-01…E8-40, Quoten 35/30/20/12/3 bzw. 35/30/20/14,5/0,5, Pity 20, Boss-Variante, Wochenend-Modifikator, Aufgabe, Gratis-Kosmetik), `ftb_events.verse`, `ftb_time.verse` (`EventWeek()`, Rotation nach W8: `2 + ((idx−8) mod 7)` mit Flag „Rückkehr-Woche“)
- **Schritte:** W1-Start `1796860800` (Do 10.12.2026 00:00 UTC), Woche = 604.800 s; Wochenende Sa–So (UTC); Event-Tokens (Boss 20, Tag 6: 50, Codes 50, Kern-Tausch 10:1 max. 50/Tag, Aufgabe 100); Wochenende-Ende: Reste 1:5 in Kerne; Event-Ei nur gegen Tokens; Event-Kreaturen = Katalog-Kreatur + Event-MI (keine neuen Stats). Fallback ohne Zeit-API: `CurrentEventWeek`-Konstante (Mikro-Update, GDD 7.4 Fallback A) **und** Spielzeit-Freischaltung (Fallback B) als Schalter `EventSource`.
- **Abnahme:** AT-M5-4 (Offset auf jede der 8 Wochen + 3 Rotationswochen: richtige Kreaturen/Quoten/Modifikatoren).
- **Test:** S
- **API:** P8.

#### M5-05 · IIT-Shop (2 h) [CC]
- **Abh.:** M0-16, M0-06
- **Dateien:** `ftb_shop_iit.verse`, `ftb_ui.verse` (Tab „Shop“ S13, Kiosk D09b)
- **Schritte:** Epic-IIT-Vorlage (Doku „In-Island Transactions Device Template“) **wörtlich** übernehmen, dann die 14 Angebote GDD 9 (IDs, Preise, `Consumable`/`MaxCount`, `ConsequentialToGameplay`, Texte mit „Gibt einen Gameplay-Vorteil: …“); Gewähren **nur** in `OnPurchasesChanged`; Pending-Flag; `Reconcile` beim Join mit `GetPurchasedEntitlements`; `GetMinPurchaseAge` einmal je Session im Failure-Kontext → „Nicht verfügbar“; Münz-Rausch zählt **aktive** Minuten, `ConsumeEntitlement` nach Aktivierung; Deckel ×2,5 Pad-Münzen; Sternenwaffel zählt nicht zum Index; Schalter `IITEnabled` (aus → Shop zeigt „Bald verfügbar“, keine IIT-Aufrufe).
- **Abnahme:** Kompiliert; AT-M5-5a (Effekte der 14 Items über Debug-Grant ohne IIT-API).
- **Test:** S (echter Debug-Kauf in M7-07)
- **API:** Signaturen aus P12/`api_digest.md`; Fallback: `IITEnabled=false` bis Luis berechtigt ist.

#### M5-06 · Rückkehr-Bonus S18, Komfort-Items, Dösen-Regeln (1,5 h) [CC]
- **Abh.:** M5-02, M5-05
- **Dateien:** `ftb_economy.verse`, `ftb_ui.verse`
- **Schritte:** Mit Zeit-API: Offline-Einkommen 10 % × min(Offline, 8 h); ohne: Rückkehr-Bonus 5 min + 1 Ei, nur wenn vorige Session ≥ 10 aktive Minuten; S18 mit „EINSAMMELN“; Auto-Welle (max. 10, dann Eingabe), Auto-Brut (ab Rebirth 1), Turbo-Brüter, 2. Brutplatz, 2. Fusions-Slot, Stall 50; Dösen blockiert Wellen/Boss-Belohnung.
- **Abnahme:** AT-M5-6.
- **Test:** S

#### M5-07 · Save-Schema-Review + Freeze (1,5 h) [CC]
- **Abh.:** M5-01…M5-06
- **Dateien:** `ftb_save.verse`, `_context/entscheidungen.md` (Eintrag „Save v1 eingefroren“ mit Feldliste)
- **Schritte:** Felder ergänzen, die die Referenz noch nicht hat (Default = Literal): `TutorialStep:int = 0`, `Cosmetics:[]int = array{}` (Bitworte: 7 Pad-Farben, Titel, Banner, Plot-Deko), `ActiveCosmetics:int = 0` (gepackt: Farbe, Titel, Banner), `Hearts:int = 0`, `IndexMilestones:int = 0`, `LastEventWeekSeen:int = -1`, `TeamLock:[]int = array{}`, `AnalyticsFlags:int = 0`; Worst-Case ×2 bauen und `FitsInPlayerMap` prüfen (B16); Migrationstest: ein in M1 erzeugter Save lädt fehlerfrei (Luis-Konto hat einen).
- **Abnahme (G5, Di 10.11.):** AT-M5-7 PASS; Feldliste eingefroren; ab jetzt nur noch Felder **anhängen**.
- **Test:** S

#### M5-08 · Selbsttest M5 (1 h) [CC+Luis]
- **Schritte:** AT-M1…M5, Luis-Sichtprüfung (Rebirth-Screen, Kalender, Code-Tastatur mit Gamepad, Shop-Anzeige), Meilenstein-Ende.
- **Abnahme:** alle AT PASS.

### M5 · Aufgaben für Luis
| Wann | Aufgabe | Dauer |
|---|---|---|
| Do 05.11. | Developer-Program-/IIT-Status prüfen (Creator Portal); falls noch nicht berechtigt: Support-Ticket, Status in `offene_fragen.md` Q-IIT-1 | 20 min |
| Do 05.11. | Regel-Zusammenfassung `_context/regeln_digest.md` (Abschnitt IIT) lesen und mit „ok“ bestätigen | 15 min |
| Di 10.11. | Selbsttest-Session inkl. Code-Tastatur mit Gamepad | 30 min |

---
## M6 · Inhalt, Juice, Feature-Freeze (Mi 11.11. – So 15.11.2026, KW 46)

**Ziel:** Alles, was zum Release gehört, ist drin – danach nur noch Bugs, Balance, Event-Daten.
**Spielbarer Endzustand:** Feature-komplette Insel inkl. 3 Bosse, 8 vorproduzierter Event-Wochen, Hub, Plot-Themen, Juice, Audio, Optionen.

#### M6-01 · Bosse B2/B3 + Varianten + Rotation (2 h) [CC]
- **Abh.:** M5-08
- **Dateien:** `blender/gen_misc_meshes.py`, `ftb_combat.verse`
- **Assets:** A36 `SM_FTB_Boss_Mikrowellora`, A37 `SM_FTB_Boss_StaubsaugerBaron` (je ≤ 25.000 Tris); MIs `MI_FTB_Boss_Frost`, `…_Geschenk`, `…_Funken`, `…_Schleim`, `…_Disco`, `…_Meteor` (GDD 7.4)
- **Schritte:** Rotation B1→B2→B3; Event-Woche wählt Variante; W8 „Boss-Parade“ (3 Bosse nacheinander, je 75 s, gemeinsame Belohnung ×1,5); W2 Boss alle 5 min (Modifikator).
- **Abnahme:** AT-M6-1 (Wochen-Offset → richtige Boss-Variante/Intervall). Speicher-Messung nach Import (S4-Fallback bereit).
- **Test:** S, 16B
- **API:** –

#### M6-02 · Event-Inhalte + Bonus-Arten (2 h) [CC]
- **Abh.:** M5-04, M6-01
- **Dateien:** `data/events.csv` (final), `ftb_events.verse`, `blender/gen_species_parts.py` (Arten 9/10 nur bei B1 < 50.000)
- **Assets:** Event-Ei-Icons (8), Stinger A145–A152 (`gen_sfx.py`), Plot-Deko „Geschenkestapel“ und Himmel-Deko „Sternschnuppen“ (Niagara, global), Bonus-Arten A25–A30 + Silben (bereits A100–A129 enthalten)
- **Schritte:** 40 Event-Kreaturen als (Katalog-ID, Event-MI) prüfen; Wochenend-Modifikatoren (doppelte Kerne, Boss 5 min, +50 % Boss-Eier, Resonanz 30 %, Ploppblasen-Wellen +50 % Kerne, Hype-Fenster +30 %, Geheim-Quote ×2, alle Rezept-Hinweise) im Code; Event-Aufgaben je Woche; Gratis-Kosmetik; **Bonus-Arten nur wenn B1-Messwert < 50.000** (GDD Kill-Schalter), sonst Paketeulo/Bassotto als Event-MI-Varianten bestehender Arten (Plan-Entscheidung, falls nötig, eintragen).
- **Abnahme:** AT-M5-4 erneut grün mit finalen Daten; Speicher gemessen.
- **Test:** S

#### M6-03 · Juice-Pass 1: Reveal, Wirtschaft, Fusion (2 h) [CC]
- **Abh.:** M5-08
- **Dateien:** `ftb_ui.verse`, `ftb_creature_pool.verse`
- **Assets:** `NS_FTB_CoinPop` (max. 2/s je Pad), `NS_FTB_Zzz`, `NS_FTB_Resonance`, restliche Reveal-Stufen
- **Schritte:** GDD 13 Zeilen „Münz-Tick“ bis „Index: neuer Eintrag“ + „Level-Up“, „Totem-Upgrade“, „Pad freigeschaltet“; Anfeuern (Hype-Druck auf fremdem Plot während dessen Welle: +10 % Schaden, +1 Kern je Welle, max. 10/Session).
- **Abnahme:** Luis-Sichtprüfung (Juice-Checkliste GDD 13, 15 Zeilen abhaken).
- **Test:** S, 2P (Anfeuern)

#### M6-04 · Juice-Pass 2: Kampf, Boss, Meta (1,5 h) [CC]
- **Abh.:** M6-03
- **Schritte:** GDD 13 Zeilen „Welle Start“ bis „IIT-Kauf abgeschlossen“; Kamera-Shake → **UI-Wackeln** (Plan-Entscheidung P-07: Kamera-Device pro Spieler UNVERIFIED, Schnittliste Punkt 5), Stärke × Options-Regler; „Reduzierte Blitze“ respektieren.
- **Abnahme:** wie M6-03.
- **Test:** S

#### M6-05 · Audio-Pass (1,5 h) [CC]
- **Abh.:** M3-07, M2-07
- **Dateien:** `tools/gen_sfx.py`, `ftb_ui.verse` (Audio-Direktor)
- **Devices:** D14 „Vox“ ×8, „Stinger“ ×8
- **Schritte:** Luis-Laute (`audio_src/vox/raw/`) per ffmpeg normalisieren (−12 dBFS) + Pitch je Art; Event-Stinger; Mix-Pegel GDD 12 (Musik −18 LUFS: `loudnorm=I=-18`); Münz-Tick max. 8/s gesamt; eigene Musik (LMMS) nur wenn B1 grün **und** Luis sie liefert, sonst UEFN-Bibliothek bleibt.
- **Abnahme:** B18/B19 grün; Luis 3-min-Hörprobe.
- **Test:** S

#### M6-06 · Hub + Umgebung (2 h) [CC]
- **Abh.:** M5-08
- **Dateien:** `tools/place_plots.py` (Hub-Teil)
- **Devices:** D09a–d (Code-Terminal, IIT-Kiosk, Event-Statue/Kalender, Hub-Rückkehr ×4), D16 ×4 (Ranglisten-Tafel: Höchste Welle, Index, Stärkster Hybrid, Boss-Teilnahmen) + ×1 Event-Tafel, D17 Barriere (Außenring), D18 Tageszeit
- **Assets:** A49 Fusionsmaschinen-Statue (18 m, Skript, ≤ 8.000 Tris); Umgebung nur UEFN-Galerie (Pastell-Pflaster, Lichterketten, Zuckerwatte-Hügel, Wolkenklippen); Licht GDD 11 (Sonne 50°, `#FFE6B0`, Höhennebel `#D9D2FF`)
- **Schritte:** Hub-Layout GDD 11 (Boss-Landekreis r = 1.500, Hype-Zone-Ring r = 2.000–3.000 als Bodenmarkierung, Terminals auf ±3.200); Ringstraße r = 9.000, Breite 800; Außenring ab r = 15.500 mit Barriere; Ranglisten-Tafel alle 30 s aktualisieren.
- **Abnahme:** B8/B9 grün; Speicher-Messung; FPS B21 vom Hub.
- **Test:** S, 16B, M (Sicht)
- **API:** Barrier-Device-Maximalgröße UNVERIFIED → mehrere Barrieren bzw. unsichtbare Blocking-Galerie-Wände.

#### M6-07 · Plot-Deko + IIT-Plot-Themen + Pad-Farben (2 h) [CC]
- **Abh.:** M6-06, M5-05
- **Assets:** 3 Themen (Neon-Nacht, Zuckerwatte-Wolke, Vulkan-Grill) = je 1 MI-Satz für Boden/Zaun/Pad-Ringe + höchstens 6 Themen-Props je Plot (Galerie oder Skript); 7 Pad-Farben = MIs `MI_FTB_Pad_<Farbe>`
- **Schritte:** Themen über dieselbe Anzeige-Technik wie G0 (A: vorplatziert und versteckt; C: bei Bedarf spawnen); Pad-Farben per Material-Tausch (P1) oder Fallback: farbiger Niagara-Ring.
- **Abnahme:** B9/B10 grün; Theme-Wechsel ≤ 1 s.
- **Test:** S, 16B

#### M6-08 · Optionen S14, Barrierefreiheit, Credits, Accolades (1,5 h) [CC]
- **Abh.:** M6-04
- **Dateien:** `ftb_ui.verse`, `ftb_events.verse`
- **Schritte:** Lautstärken (−/+ in 10 Stufen, Audio-Device-Lautstärke falls per Verse setzbar, sonst Musik an/aus), Reduzierte Blitze, UI-Wackeln 0–100 %, Zahlenformat (K/M/B oder 1,2e15), Hotkey-Hinweise, Tutorial neu starten; Credits inkl. „Stimmen: Kokoro-82M (Apache-2.0)“; Accolades nur für aktive Meilensteine (erste Fusion, Welle 10/25/50/100, Boss-Sieg, Rebirth) – **optional**, Device „Accolades“ (Name/Setting UNVERIFIED; Fallback weglassen).
- **Abnahme:** Optionen persistieren (`Settings`).
- **Test:** S, C

#### M6-09 · Selbsttest + Feature-Freeze (1,5 h) [CC+Luis]
- **Schritte:** alle AT, 16B-Volllast, Memory Calculation, `budgets.md` M6, Code-Review 4.8, Tag `m6-freeze`.
- **Abnahme (G6, So 15.11.):** Feature-komplett; alle Budgets grün/gelb mit Maßnahme; ab jetzt Commit-Präfix `FIX:`/`BAL:`/`DATA:`.

### M6 · Aufgaben für Luis
| Wann | Aufgabe | Dauer |
|---|---|---|
| Do 12.11. | Optional: eigene Musik in LMMS (nur wenn Lust; CC nutzt sonst Bibliothek) | 0–4 h |
| Sa 14.11. | Juice-Checkliste GDD 13 durchspielen, Hörprobe | 45 min |
| So 15.11. | Feature-Freeze bestätigen („Freeze ok“ an CC) | 5 min |

---

## M7 · Polish, Performance, Plattformen (Mo 16.11. – So 22.11.2026, KW 47)

**Ziel:** RC-Kandidat: stabil auf allen Eingaben, im Budget, zweisprachig, Zeit-Freischaltung nachgewiesen.
**Spielbarer Endzustand:** RC-Kandidat als private Version (Upload Mo 23.11.).

#### M7-01 · Performance- und Speicher-Endmessung (2 h) [CC]
- **Abh.:** M6-09
- **Schritte:** 16B Volllast (Wellen auf allen Plots, Boss-Parade, W7-Modifikatoren, alle Auren); 3×60 s; Memory Calculation + Top-100-Liste; bei Gelb: Maßnahmen aus M0.3 Schritt 3 / B13; Timing-Insights-Aufnahme durch Luis (Klickliste, optional).
- **Abnahme:** alle Budgets B1–B21 eingetragen, keine Zeile rot.
- **Test:** 16B

#### M7-02 · Controller-Durchgang (1,5 h) [CC+Luis]
- **Abh.:** M6-09
- **Schritte:** CC erzeugt Checkliste aller Panels (S1–S19) mit Fokus-Reihenfolge laut GDD; Luis spielt 30 min nur mit Gamepad, notiert unerreichbare Elemente; CC fixt (Fokus-Startknopf, weniger Knöpfe je Panel, Schließen erreichbar).
- **Abnahme:** 0 unerreichbare Funktionen.
- **Test:** C
- **API:** Controller-Fokus UNVERIFIED → Fallback: Panels auf ≤ 2 Ebenen, Welt-Terminals als Einstieg.

#### M7-03 · Touch-/Mobile-Durchgang (1,5 h) [CC+Luis]
- **Abh.:** M6-09
- **Schritte:** Mobile Preview (oder private Version auf Handy); Prüfungen: Primär-Buttons ≥ 12 % H, untere Ecken frei, Texte ≥ 2,6 % H lesbar, Kristall-Material ok, FPS spürbar flüssig; Fixes.
- **Abnahme:** Kernschleife (Ei → Fusion → Welle → Boss) komplett per Touch.
- **Test:** M

#### M7-04 · Lokalisierung DE/EN (1,5 h) [CC]
- **Abh.:** M6-09
- **Dateien:** `ftb_ui.verse` (alle `<localizes>`-Texte), UEFN-Lokalisierungswerkzeug (Ablauf UNVERIFIED – Doku „Localization in UEFN“ per WebFetch)
- **Schritte:** Englisch = Quelltext; Deutsch per Lokalisierungs-Export/Import; Namen der Kreaturen bleiben unübersetzt; Zahlenformat mit Punkt (GDD 5.4).
- **Abnahme:** Client auf Deutsch zeigt deutsche Texte (Luis 5 min).
- **Test:** S
- **API:** UNVERIFIED → Fallback: nur Englisch, deutsche Inselbeschreibung (GDD 10.2, Schnittliste Punkt 3).

#### M7-05 · Zeit-Freischaltung nachweisen (1,5 h) [CC]
- **Abh.:** M5-04, M6-02
- **Schritte:** AT-M7-5: `DebugOffsetSec` durch 12 Zeitpunkte (vor Launch, jede Woche W1–W8 Mo/Sa, W9–W11 Rotation), je Zeitpunkt: aktive Woche, Event-Ei, Codes gültig/abgelaufen, Wochenend-Modifikator, Token-Umtausch am Wochenende-Ende, Tagesbelohnung-Tag; Ergebnis-Tabelle in `playtests.md`.
- **Abnahme:** 12/12 PASS.
- **Test:** S

#### M7-06 · Langlauf-Autoplay (1,5 h) [CC]
- **Abh.:** M6-09
- **Schritte:** `AutoTest=70` mit `DebugTimeScale=20` für 60 min Echtzeit (= 20 h Spielzeit, Bot kauft/fusioniert/kämpft/rebirthet nach einfacher Strategie wie `economy_sim.py decide()`); Ausgabe alle 10 Spielstunden: Rebirths, Welle, Index, Save-Größe-Check; Vergleich mit GDD 5.9 (Rebirth 1 zwischen 1:15 h und 4:00 h; 10 h: Rebirth 4–10; keine ERROR-Zeile).
- **Abnahme:** keine ERROR, Save besteht Fits-Test, Werte im Korridor.
- **Test:** S

#### M7-07 · IIT-Debugtest (1 h) [Luis+CC]
- **Abh.:** M5-05
- **Schritte:** In UEFN-Session bzw. privater Version (IIT-Debug laut Epic-Doku): „Grant All Products“ → alle Effekte prüfen (CC-Checkliste 14 Zeilen), Rejoin → Besitz bleibt; „Force Remove Products“ → Effekte weg; ein echter Debug-Kauf-Dialog (ohne V-Bucks-Abzug) für Münz-Rausch, dann `ConsumeEntitlement` geprüft.
- **Abnahme:** 14/14 Effekte korrekt, keine Doppelvergabe.
- **Test:** S
- **API:** Debug-Befehle VERIFIED (Best Practices); `IITEnabled=false`, falls Luis nicht berechtigt (Shop „Bald verfügbar“).

#### M7-08 · RC-Kandidat bauen (1 h) [CC+Luis]
- **Abh.:** M7-01…M7-07
- **Schritte:** Release-Konfiguration (M8-06-Liste) außer `TESTREPORT` (bleibt für Test 2 aktiv); Tag `m7-rc1`; Luis lädt private Version hoch (**Mo 23.11.**) und gibt sie den Testern zum freien Spielen frei.
- **Abnahme (G7):** private Version startet; Selbsttest AT-Kurzlauf grün.

### M7 · Aufgaben für Luis
| Wann | Aufgabe | Dauer |
|---|---|---|
| Di 17.11. | Controller-Durchgang (M7-02) | 45 min |
| Mi 18.11. | Mobile/Touch-Durchgang (M7-03), notfalls mit Tester-Handy per Discord | 45 min |
| Do 19.11. | IIT-Debugtest (M7-07) | 45 min |
| Mitte Nov. | Chapter-8-/Winterfest-Daten prüfen (Launch-Plan 8.4) → `offene_fragen.md` Q-REL-2 | 15 min |
| **Mo 23.11.** | RC-Kandidat als private Version hochladen, Tester informieren | 30 min |

---

## M8 · Release Candidate, Test 2, Einreichung (Mo 23.11. – Do 03.12.2026, KW 48–49)

**Ziel:** Nachweis „kein Save-Verlust, kein Blocker, IIT sauber, Controller + Touch komplett“ (GDD 14.1 Test 2; Launch-Plan 4.2 Go/No-Go), dann Einreichung.
**Spielbarer Endzustand:** Release-Build, eingereicht am **Do 03.12.2026**.

#### M8-01 · Test-2-Vorbereitung (1 h) [CC]
- **Abh.:** M7-08
- **Dateien:** `_context/playtests.md` (Abschnitt „Test 2“)
- **Schritte:** Ablauf Sa 28.11.: Session 1 (11:00–12:30, jeder auf seiner Plattform: PC-Maus, Konsole/Controller, Handy/Touch), Session 2 (17:00–18:30, **Save-Prüfung**: jeder notiert vorher/nachher Münzen, Kerne, Anzahl Kreaturen, Index), Koop-Boss um 18:00 mit allen 4; Fragebogen; Test-Report-Screenshots.
- **Abnahme:** Protokoll vollständig.

#### M8-02 · Test 2 durchführen (Sa 28.11.) [Luis]
- **Abh.:** M8-01
- **Schritte:** Laut Protokoll; zusätzlich prüfen, ob die private Version eigene Saves hat (Luis vergleicht mit seinem Edit-Session-Stand; UNVERIFIED-Punkt 4.3).
- **Abnahme:** Daten in `playtests/test2/`.

#### M8-03 · Go/No-Go (1 h) [CC]
- **Abh.:** M8-02
- **Schritte:** Kriterien: kein Blocker, kein Save-Verlust, kein Absturz; erste Fusion bei allen < 5 min; Controller- und Touch-Durchlauf komplett; IIT-Flows (M7-07) ok. **Rot** → Fix zuerst; Einreichung darf bis **Mo 07.12.** rutschen (Launch-Plan 4.2), Publish-Fenster bis 15.12.
- **Abnahme:** Go/No-Go in `entscheidungen.md`.

#### M8-04 · Fix-Slots (2 × 2 h, Mo 30.11. – Di 01.12.) [CC]
- **Abh.:** M8-03
- **Schritte:** nur Blocker/Datenverlust/Verständnis; jeder Fix + AT-Kurzlauf.
- **Abnahme:** Fix-Liste leer oder bewusst verschoben (Eintrag „nach Launch“).

#### M8-05 · UEFN-Update-Rauchtest (1 h, bei Bedarf) [CC+Luis]
- **Abh.:** –
- **Schritte:** Falls eine neue UEFN-Version erscheint (Chapter 8: 28.11. oder 05.12., geleakt): Projekt öffnen, Verse bauen, AT-Kurzlauf, Memory Calculation; Abweichungen fixen; ggf. neuen Upload.
- **Abnahme:** Build grün in aktueller UEFN-Version.

#### M8-06 · Release-Konfiguration prüfen (1 h) [CC]
- **Abh.:** M8-04
- **Schritte (Checkliste, jede Zeile per MCP-Property-Lesen belegen):** `DebugMode=false`, `AutoTest=0`, `BotPlots=0`, `DebugTimeScale=1.0`, `DebugOffsetSec=0`, `TESTREPORT` deaktiviert, `IITEnabled` = Luis-Status, `EventSource` = EPOCH (oder Fallback laut P8), `HypeMode` laut Test 1, Island Settings D00 (Max Players 16 bzw. G0-Wert, Join in Progress an), keine Spike-/Showroom-Props, Log-Level nur WARN/ERROR; `budgets.md` final.
- **Abnahme:** Checkliste 100 %.

#### M8-07 · Store-Seite, Thumbnails, IARC, Einreichung (2 h) [Luis+CC]
- **Abh.:** M8-06
- **Schritte:** CC liefert Texte aus Launch-Plan §1 (Titel, Beschreibung ≤ 80 Zeichen/Zeile, 4 Tags, How to Play) als `docs/store_texte.md` und rendert finale Thumbnails A/B/C (`gen_thumbs.py` mit echten Asset-Posen, 1920×1080, ≤ 5 MB, **keine Pfeile**); Luis: Creator Portal ausfüllen (Launch-Plan 8.3), IARC nach Launch-Plan 8.2, A/B-Test vorbereiten, Release-Termin Do 10.12. 16:00 MEZ, **Einreichen Do 03.12.**
- **Abnahme:** Portal zeigt „In Review“.

#### M8-08 · Abschluss (0,5 h) [CC]
- **Schritte:** Backup, Tag `v1.0.0-submitted`, `status.md` → „Warten auf Review; Launch-Plan Phase H übernimmt“; `tools/eco_pull.py` für die tägliche KPI-Archivierung nach Launch bereitstellen (Launch-Plan 4.3 nennt `tools/kpi_pull.py` – als Alias anlegen).

### M8 · Aufgaben für Luis
| Wann | Aufgabe | Dauer |
|---|---|---|
| Fr 27.11. | Tester erinnern, Plattformen verteilen | 15 min |
| **Sa 28.11.** | **Test 2** (zwei Sessions + Koop-Boss) | 4 h |
| So 29.11. | Ergebnisse ins Repo | 20 min |
| Di 01.12. | OBS-Rohmaterial für Clips/Thumbnails aufnehmen (Launch-Plan 8.5, Rohmaterial-Liste) | 2 h |
| Mi 02.12. | Portal: Metadaten, Thumbnails, IARC, IIT-Angebote prüfen (Launch-Plan 8.2/8.3) | 1,5 h |
| **Do 03.12.** | **Einreichen** | 30 min |

---

## Anhang D · Device-Katalog (alle Nicht-Standard-Einstellungen)

Nicht belegte Einstellungsnamen sind mit „UV“ markiert = *UNVERIFIED – prüfe im Details-Panel (MCP C15 listet Properties); Fallback in Spalte „Fallback“*. Positionen lokal zum Plot (x Richtung Hub, cm) laut GDD 11.

| ID | Device (Verse-Klasse) | Anzahl | Ort | Nicht-Standard-Einstellungen | Tag | Fallback |
|---|---|---|---|---|---|---|
| D00 | Island Settings | 1 | – | Max Players **16** (bzw. G0-Wert); Teams: **1 Team, alle kooperativ** (UV „Team Count/Team Size“); Friendly Fire **aus** (UV); Join in Progress **Spawn/Erlaubt** (UV); Bauen **aus** (UV „Allow Building: None“); Umgebungsschaden **aus**; Fallschaden **aus** (UV); Spitzhacke **an** (Standard, für Hype-Takt); Respawn-Zeit 1 s (UV); Spielzeitlimit **keins**; Build-/Material-HUD **aus** (UV) | – | Luis-Klickliste; bei fehlender Option: Spieler-Schaden per Verse ignorieren (keine PvP-Reize im Spiel) |
| D01 | Player Spawn Pad (`player_spawner_device`) | 16 | (+1.500, 0) je Plot | Visible in Game **aus**; Team **beliebig** | `ftb_tag_spawn` | – |
| D02 | Button „Nest“ (`button_device`) | 16 | (+500, −1.300) | Interaction Text „Open egg“ (UV); Interact Time **0 s**; Visible During Game **aus** (UV; nur Interaktion, Optik = Nest-Mesh) | `ftb_tag_btn_nest` | sichtbar lassen, Nest-Mesh darüber |
| D03 | Button „Ei-Automat“ | 16 | (+1.100, −1.300) | wie D02, Text „Egg machine“ | `ftb_tag_btn_egg` | wie D02 |
| D04 | Button „Fusions-Maschine“ | 16 | (+700, +1.300) | wie D02, Text „Fuse“ | `ftb_tag_btn_fuse` | wie D02 |
| D05 | Button „Menü-Terminal“ | 16 | (+1.500, +500) | wie D02, Text „Menu“ | `ftb_tag_btn_menu` | wie D02 |
| D06 | Button „KAMPF!“ (Pilz) | 16 | (+200, +400) | wie D02, Text „FIGHT!“ | `ftb_tag_btn_fight` | wie D02 |
| D07 | Button „Herz geben“ | 16 | (+2.000, +600) | wie D02, Text „Give heart“ | `ftb_tag_btn_heart` | wie D02 |
| D08 | Button „Zur Boss-Arena“ | 16 | (+1.500, −500) | wie D02, Text „To the arena“; Verse teleportiert in die Hype-Zone | `ftb_tag_btn_arena` | – |
| D09a | Button „Code-Terminal“ | 1 | Hub (0, +3.200) | wie D02, Text „Codes“ | `ftb_tag_btn_codes` | – |
| D09b | Button „Glitzer-Laden“ (IIT-Kiosk) | 1 | Hub (0, −3.200) | wie D02, Text „Shop“ | `ftb_tag_btn_shop` | – |
| D09c | Button „Zurück zum Plot“ | 4 | Hub r = 3.500 bei 45°/135°/225°/315° | wie D02, Text „My plot“ | `ftb_tag_btn_home` | – |
| D09d | Button „Event-Kalender“ | 1 | Hub (−3.200, 0) | wie D02, Text „Events“ | `ftb_tag_btn_events` | – |
| D10 | Input Trigger „Hype“ (`input_trigger_device`) | 1 | Hub (unsichtbar) | Input **Fire/Primärfeuer** (UV Optionsname); Register Player Behavior **alle Spieler registrieren** (UV); Consume Input **aus** (UV; Spitzhacke soll schwingen); Show on HUD **aus** (UV) | `ftb_tag_input_hype` | P5-Fallbacks (SMASH-Knopf, Hype-Meter) |
| D11 | Input Trigger „Menü“ (optional) | 1 | Hub | Input: frei belegbare Aktion (UV); sonst weglassen | `ftb_tag_input_menu` | nur Welt-Terminals |
| D12 | Audio Player „Musik“ (`audio_player_device`) | 4 | Hub | Audio = Loop-Asset; Auto Play **aus**; Spatialization **aus** (UV); Hörbar für **registrierte Spieler** (UV); Looping **an** (Asset) | `ftb_tag_music_<zustand>` | globale Wiedergabe |
| D13 | Audio Player „Silbe“ | 30 | Hub | wie D12, ohne Looping, Volume 1,0 | `ftb_tag_syl` + Name `FTB_SYL_<Art>_<P/M/S>` | spatial am Plot abspielen |
| D14 | Audio Player „UI/Fanfare/Vox/Stinger“ | 8 + 7 + 8 + 8 = 31 | Hub | wie D13 | `ftb_tag_sfx` + Name | global/spatial |
| D15 | Analytics (`analytics_device`) | 16 | Hub | Event-Name je Device (Liste M3-08) (UV Feldname) | `ftb_tag_ana` + Name `FTB_ANA_<event>` | nur Test-Report + Log |
| D16 | Billboard (`billboard_device`) | 16 Plot-Schilder + 4 Rangliste + 1 Event-Tafel + (16 Maschinen-Schilder optional) | (+2.000, +600) / Hub | Text per Verse; Rahmen aus (UV); Textgröße groß (UV) | `ftb_tag_board_<typ>` | Toast statt Maschinen-Schild |
| D17 | Barrier (`barrier_device`) | ≤ 8 | Außenring r = 15.500 | Visible in Game **aus**; Zone Box maximal (UV Maximalmaß) | – | Galerie-Wände unsichtbar |
| D18 | Tageszeit/Day-Sequence-Device | 1 | Hub | feste Zeit ≈ 15:00, Sonne 50° (UV) | – | Standardlicht |
| D19 | Verse-Device `ftb_game_manager` | 1 | Hub (0, 0, −500) | `@editable`-Schalter (M0-10) | – | – |

**Summe:** 16 + 16×7 + 7 + 2 + 4 + 30 + 31 + 16 + 21 + 8 + 1 + 1 ≈ **249** (B8 ≤ 260). Sparmaßnahme bei Bedarf: D14-Vox (8) streichen, D11 streichen.

---

## Anhang A · Asset-Katalog

| ID | Name | Ordner (Content) | Format / Quelle | Budget |
|---|---|---|---|---|
| A01–A24 | `SM_FTB_<Art>_<Head/Body/Accessory>` für Waffelino, Frogurko, Idrantoro, Tagliatakel, Diskolama, Razzopingu, Wolkowal, Bzzkoffro (A01 = Waffelino_Head, A02 = Waffelino_Body, A03 = Waffelino_Accessory, … A24 = Bzzkoffro_Accessory) | `FTB/Meshes/Creatures/` | FBX ← `gen_species_parts.py` | B2 |
| A25–A30 | Paketeulo, Bassotto (je 3 Teile, optional) | wie oben | wie oben | B2, nur B1 < 50.000 |
| A31–A34 | `SM_FTB_Enemy_Staubfussel\|Kabelwurm\|Dosenpanzer\|Ploppblase` | `FTB/Meshes/Enemies/` | ← `gen_misc_meshes.py` | ≤ 2.000 |
| A35–A37 | `SM_FTB_Boss_Kabelsalat\|Mikrowellora\|StaubsaugerBaron` | `FTB/Meshes/Bosses/` | ← `gen_misc_meshes.py` | ≤ 25.000 |
| A38 | `SM_FTB_Egg` | `FTB/Meshes/Props/` | Skript | ≤ 600 |
| A39 | `SM_FTB_Capsule` | `FTB/Meshes/Props/` | Skript | ≤ 300 |
| A40–A48 | `SM_FTB_Pad`, `_Nest`, `_EggMachine`, `_FusionMachine`, `_TotemSegment`, `_Drop_Kern`, `_Core`, `_Portal`, `_Arrow3D` | `FTB/Meshes/Props/` | Skript | je ≤ 1.500 |
| A49 | `SM_FTB_Statue` | `FTB/Meshes/Props/` | Skript | ≤ 8.000 |
| A50 | `SM_FTB_<Art>_Merged` (8, nur Fallback F4) | `FTB/Meshes/Creatures/` | Skript | ≤ 4.800 |
| A51 | `BP_FTB_<Mesh>` (Creative-Prop-Blueprints, nur Variante A/C) | `FTB/Props/` | UEFN | – |
| A60 | `T_FTB_Palette` | `FTB/Textures/` | PNG 256×64 | – |
| A61 | `T_FTB_Noise` | `FTB/Textures/` | PNG 512² | – |
| A62–A65 | `T_FTB_Icon_<Art>_<Slot>` (24), `T_FTB_Icon_Coin\|Kern\|Token`, `T_FTB_Rar_0…6`, `T_FTB_Egg_1…8` | `FTB/Textures/UI/` | PNG 256² ← `gen_icons.py` | B6 |
| A66 | `T_FTB_UI_Panel9`, `T_FTB_UI_Ring` | `FTB/Textures/UI/` | PNG 128² ← Python (PIL-frei: stdlib `zlib`+PNG-Schreiber in `tools/gen_ui_tex.py`) | – |
| A70 | `M_FTB_Creature` + `M_FTB_Creature_Crystal` | `FTB/Materials/` | UEFN-Material | – |
| A71–A77 | `MI_FTB_Rarity_0` … `MI_FTB_Rarity_6` (Klassik, Neon, Gold, Kristall*, Königlich, Mythisch, Kosmisch; *Parent `M_FTB_Creature_Crystal`) | `FTB/Materials/` | MI | – |
| A78–A83 | `MI_FTB_Event_Gruender\|Frosti\|Funki\|Schleimi\|Kosmi\|Festi` | `FTB/Materials/` | MI | – |
| A84 | `MI_FTB_Sternen` | `FTB/Materials/` | MI | – |
| A85–A87 | `M_FTB_Enemy` + `MI_FTB_Enemy_Base` + `MI_FTB_Boss_<Variante>` (6); `M_FTB_Prop` + `MI_FTB_Prop`, `MI_FTB_Pad_<Farbe>` (7); `M_FTB_VFX_Add` | `FTB/Materials/` | – | – |
| V01–V22 | `NS_FTB_…` (22 Systeme, Liste 5.7) | `FTB/VFX/` | Niagara | B17 |
| A100–A129 | `A_FTB_Syl_<Art>_<P\|M\|S>` (30) | `FTB/Audio/Syllables/` | WAV ← `tts_syllables.py` | B18 |
| A130–A137 | `A_FTB_UI_Click\|Focus\|Open\|Close\|Buy\|Error\|CoinTick\|Kern` | `FTB/Audio/UI/` | WAV ← `gen_sfx.py` | – |
| A138–A144 | `A_FTB_Fan_R0…R6` | `FTB/Audio/Fanfare/` | WAV ← `gen_sfx.py` | – |
| A145–A152 | `A_FTB_Sting_W1…W8` | `FTB/Audio/Stinger/` | WAV ← `gen_sfx.py` | – |
| A153–A160 | `A_FTB_Vox_<Art>` (8) | `FTB/Audio/Vox/` | WAV ← Luis + ffmpeg | – |
| A161–A164 | Musik-Loops (UEFN-Bibliothek; eigene nur optional) | – / `FTB/Audio/Music/` | – | B18 |

(VFX tragen die IDs V01–V22; eindeutig ist immer der Asset-**Name**.)

---

## Anhang T · Autoplay-Szenarien und Log-Format

**Aufruf:** Game-Manager `@editable AutoTest = <Nr.>` setzen (per MCP C3; sonst Luis-Klick im Details-Panel), Session starten; Szenario läuft auf dem ersten Spieler-Plot. `AutoTest = 100` = alle Szenarien des aktuellen Meilensteins nacheinander.
**Log:** `[FTB][TEST][<ID>] PASS|FAIL <max. 80 Zeichen>` · Ende: `[FTB][TEST][DONE] pass=<n> fail=<n>`.
**Auswertung:** `python tools/log_check.py --test --since 30`.

| ID (AutoTest) | Szenario | Prüfungen (Auszug) |
|---|---|---|
| AT-M0-90…93 | Proben P1–P4 | Material/WPO/MoveTo+Scale/Hide – Aufruf erfolgreich (Sicht durch Luis) |
| AT-M0-94 (94) | Save Worst-Case | 56 Kreaturen, alle Index-Bits, FitsInPlayerMap, Rejoin-Vergleich |
| AT-M0-95 (95) | Zeit | Wert, Steigung 60 ± 2 s/min, Plausibilität gegen erwartetes Datum |
| AT-M1-1 (1) | Neuer Spieler 0–2 min | Plot, Starter-Ei ≤ 30 s, Kauf ≤ 45 s, Level-Up ≤ 120 s, Pad 3 |
| AT-M1-2 (2) | Golden Values | 30 Werte = Python ± 0,1 %; `FormatBig` 12/12 |
| AT-M1-3 (3) | Save-Rundreise | 40 Felder identisch nach Build/Apply |
| AT-M2-1 (11) | Fusionsregeln | 20 Regeln (siehe M2-01) |
| AT-M2-2 (12) | Fusionsfluss | Start → Dauer → Einsammeln → Pad → Index |
| AT-M2-3 (13) | Index | 30 Fusionen, Zähler, Bonus |
| AT-M2-S (20) | Showroom | 7 Seltenheiten nebeneinander im Hub (Sichtprüfung) |
| AT-M3-1 (21) | Wellen 1–12 | Sieg-Bedingung, Sichtbarkeit, Tank/Mini-Boss |
| AT-M3-2 (22) | Hype-Bewertung | Offsets −400…+400 ms → Stufe |
| AT-M3-3 (23) | Belohnungen | Welle/Boss = Golden Values |
| AT-M3-4 (24) | Solo-Boss | HP-Formel, Phasen, Belohnung, Flucht |
| AT-M3-5 (25) | Tutorial 0–15 min | Zeitmarken GDD 3 |
| AT-M5-1 (31) | Rebirth | 25 Prüfungen |
| AT-M5-2 (32) | Tage/Streak | Offset Tage 1–8, Schutz, Lücke |
| AT-M5-3 (33) | Codes | 16 Codes × Gültigkeit |
| AT-M5-4 (34) | Event-Wochen | 8 + 3 Rotationswochen |
| AT-M5-5a (35) | IIT-Effekte (Debug-Grant) | 14 Items |
| AT-M5-6 (36) | Rückkehr/Komfort | Bonus-Regel, Auto-Welle-Deckel |
| AT-M5-7 (37) | Save-Freeze | Worst-Case ×2 Fits, Migration M1-Save |
| AT-M6-1 (41) | Boss-Rotation/Varianten | Wochen-Offset |
| AT-M7-5 (55) | Zeit-Freischaltung | 12 Zeitpunkte |
| AT-M7-6 (70) | Langlauf | 20 h Spielzeit, Korridore, keine ERROR |
| (99) | Save zurücksetzen | nur Debug |

---

## Anhang W · Werkzeuge und Lizenzen (alle kostenlos)

| Werkzeug | Zweck | Lizenz | Installation |
|---|---|---|---|
| UEFN (≥ 42.00) + Unreal MCP | Editor, Automatisierung | Epic-EULA/UEFN-Bedingungen | Epic Games Launcher |
| Claude Code | Agent | Anthropic (Luis’ Claude Pro) | vorhanden |
| Git + Git LFS | Versionierung | GPL-2.0 / MIT | `winget install -e --id Git.Git` |
| GitHub CLI | Repo | MIT | `winget install -e --id GitHub.cli` |
| Python 3.12 | Tools, Generatoren, Sim | PSF | `winget install -e --id Python.Python.3.12` |
| Blender 4.2 LTS | 3D per Skript | GPL-3.0 (Ausgaben gehören Luis) | blender.org / winget |
| Kokoro-82M | TTS-Silben | Apache-2.0 (Voicepacks: Luis prüft) | `pip install "kokoro>=0.9.4" soundfile` |
| eSpeak NG | Phonemizer für Kokoro | GPL-3.0 (nur Werkzeug) | Installer GitHub-Releases |
| ffmpeg | Audio-Nachbearbeitung | LGPL/GPL (nur Werkzeug) | `winget install -e --id Gyan.FFmpeg` |
| jsfxr/sfxr, ChipTone | optionale SFX | MIT / frei nutzbar (LIKELY, Hinweis auf Seite prüfen) | Browser |
| LMMS | optionale Musik | GPL-2.0 (Ausgaben gehören Luis) | `winget install -e --id LMMS.LMMS` |
| freesound.org (nur CC0) | Samples | CC0 | Browser |
| OBS Studio | Aufnahmen | GPL-2.0 | `winget install -e --id OBSProject.OBSStudio` |
| GIMP / Krita (optional) | Thumbnail-Text | GPL-3.0 | winget |
| **Nicht verwenden** | Coqui XTTS-v2 (CPML, nicht kommerziell), Fab-/Kauf-Assets, fremde IP, KI-Musikdienste mit unklarer Lizenz | – | – |

---

## Anhang L · Aufgaben für Luis (Gesamtübersicht nach Datum)

| Datum | Aufgabe | Meilenstein |
|---|---|---|
| Do 01.10. | Installationen, UEFN-Projekt, MCP verbinden, Developer Program, Python-Beta-Antrag, Tester einladen, Paket nach `C:\FTB_paket\` | M0 |
| Fr 02.10. | Klicklisten (falls MCP-Lücken); fortnite.gg Titelcheck; R0-1/R0-2 falls nötig | M0 |
| Sa–So 03.–04.10. | Messläufe starten, Sichtproben P1–P6, P11 | M0 |
| Di 06.10. | G0 lesen (nur bei F6 entscheiden) | M0 |
| Do 08.–So 11.10. | Thumbnail-Klick-Test (≥ 20 Personen) | M1 |
| Di 13.10. | Selbsttest M1 | M1 |
| Mi 14.10. | Kokoro + eSpeak NG installieren, Lizenz prüfen | M2 |
| Do 15.10. | 8 Kreatur-Laute aufnehmen | M2 |
| Di 20.10. | Selbsttest M2 | M2 |
| Di 27.10. | Hype-Takt-Gefühlstest | M3 |
| Do 29.10. | Private Version hochladen, Tester freischalten, Selbsttest + 2P | M3 |
| **Sa 31.10.** | **Test 1** | M4 |
| Do 05.11. | IIT-Berechtigung prüfen, Regel-Zusammenfassung bestätigen | M5 |
| Di 10.11. | Selbsttest M5 (Save-Freeze) | M5 |
| Sa–So 14.–15.11. | Juice-Checkliste, Feature-Freeze bestätigen | M6 |
| Di–Do 17.–19.11. | Controller-, Touch-, IIT-Debugtest | M7 |
| Mitte Nov. | Chapter-8-/Winterfest-Daten prüfen | M7 |
| Mo 23.11. | RC-Kandidat als private Version | M7 |
| **Sa 28.11.** | **Test 2** | M8 |
| Di 01.12. | OBS-Rohmaterial | M8 |
| Mi 02.12. | Portal, Thumbnails, IARC | M8 |
| **Do 03.12.** | **Einreichen** | M8 |
| Do 10.12. 16:00 | Publish (Launch-Plan) | – |
