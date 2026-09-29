# Verse-Referenzcode: FUSE THE BRAINROT

> **REFERENZ — UNGEPRÜFT bis in UEFN kompiliert.** Dieser Code lief durch keinen Verse-Compiler, weil hier kein UEFN verfügbar war. Er ist die Vorlage, die der lokale Claude-Code-Agent in UEFN kompiliert und anpasst. Quelle der Wahrheit für Zahlen und Regeln ist `../GDD_Fuse_and_Fight.md`. Die API-Belege stammen aus `research_notes/…/uefn_feasibility.md` [Feas] und aus Such-Snippets vom 29.09.2026.

Kommentare sind auf Deutsch, Bezeichner auf Englisch. Jede API-Stelle trägt **VERIFIED / LIKELY / UNVERIFIED**.

## Dateien

| Datei | Zeilen | Inhalt |
|---|---|---|
| `ftb_types.verse` | ~240 | `ftb_rarity`-enum, Art-IDs und Silben, Artfaktoren, `ftb_creature`-Struct, `ftb_timer_job`, `ftb_player_state` (Sitzungszustand), alle Konstanten aus GDD §5.8 und die Ei-Tabelle |
| `ftb_save.verse` | ~325 | `ftb_save_root<persistable>` mit `Version` und **einer** `weak_map`; Bit-Helfer ohne Bitoperatoren; `PackCreature`/`UnpackCreature` (Mischbasis, erweiterbar); Migration mit Kopierkonstruktor; `CommitSave` mit `FitsInPlayerMap`; atomares Vergabe-Muster; Größenbudget (≈ 1,3 KB roh) |
| `ftb_economy.verse` | ~225 | Einkommen (Pad, Totem, Rebirth, Index, IIT-Deckel ×2,5, Dös-Regel), Kostenkurven, Ei-Quoten mit Pity, Wellen-Belohnungen, `FormatBig` (K … Vg), `ApplyRebirth` |
| `ftb_fusion.verse` | ~195 | Namensgenerator (Silben, Bindevokal, Vokal-Streichung, Dreifach-Kappung), Basisnamen, 8 Geheim-Rezepte, Vorschau, Resonanz mit Pity, Neben-Trait ab Gen 5 / Spiegel-Fusion, Auto-Vorschlag |
| `ftb_creature_pool.verse` | ~155 | Prop-Pool 6 Pads × 24 Teile je Plot, Montage-Offsets (identisch zu `blender/gen_species_parts.py`), Show/Hide/TeleportTo, `SetMaterial`, Lunge und Landen-Squash per `MoveTo` |
| `ftb_combat.verse` | ~250 | Wellenformel, KK, Teamwahl, Hype-Takt-Tracker (Fenster ±150/±350 ms, +100 ms Latenz, Spam-Schutz), Wellen-Simulation mit 0,25-s-Tick, Server-Boss (HP-Skalierung, Phasen 66/33 %, Sync-Smash, Hype-Zone, Teilnahme-Belohnung) |
| `ftb_time.verse` | ~105 | Zeitquelle: `GetSecondsSinceEpoch` mit Plausibilitätsprüfung, sonst Session-Kalender; Event-Woche per Wanduhr / Konstante (Fallback A) / Spielzeit (Fallback B); Rotation nach W8; Offline- bzw. Rückkehr-Bonus |
| `ftb_events.verse` | ~205 | 8-Wochen-Kalender als Daten, Wochenend-Modifikatoren, 16 Codes mit Gültigkeit (21 Tage, `HALLOHASKE` dauerhaft) und atomarer Einlösung, 7-Tage-Belohnung mit Streak und Streak-Schutz |
| `ftb_shop_iit.verse` | ~165 | Spiegel-Bits der 14 Angebote, Entitlement-Muster, idempotenter Abgleich (Zustände statt Gutschriften), 2-Phasen-Ledger für den Verbrauchsartikel Münz-Rausch, Altersprüfung einmal pro Sitzung, `BuyOffer` gewährt nie selbst |
| `ftb_ui.verse` | ~235 | Verse-UI-HUD (Münzen mit 10-Hz-Ticker, Kerne, Tokens, Boss-Pille, Ziel), Toast-Queue (3 × 2,5 s), Fusions-Screen (Teile-Umschalter, Live-Vorschau), Reveal über zeitgesteuerte Text- und Farbwechsel mit silbenweisem Namen; Hinweise zu Controller und Touch |
| `ftb_game_manager.verse` | ~345 | `creative_device`: Join/Leave, Plot-Zuweisung, Bindungsklasse für Welt-Knöpfe (keine Closures), Loops für Einkommen (1 Hz), Save (30 s) und Boss (Countdown), Brut- und Fusions-Timer, atomarer Fusionsstart, Rebirth, Hype-Input |

Alle Dateien liegen im **selben Verse-Modul** (gleicher Ordner im UEFN-Projekt `Content/`). Deshalb brauchen sie untereinander kein `using`.

## Kompilier-Reihenfolge (zum schrittweisen Aktivieren)

Verse kompiliert ein Modul als Ganzes, daher gibt es keine echte Reihenfolge. Zum **inkrementellen Einschalten** (Dateien vorübergehend nach `_off/` verschieben) empfiehlt sich:

1. `ftb_types` + `ftb_save` → Save-Schema früh fixieren (Schema-Freeze W6, R8).
2. `ftb_economy` + `ftb_fusion` (reine Logik, keine Devices).
3. `ftb_time` + `ftb_events`.
4. `ftb_creature_pool` + `ftb_combat` (Props, `MoveTo`).
5. `ftb_ui`.
6. `ftb_shop_iit`, erst **nach** dem Import der offiziellen IIT-Device-Vorlage.
7. `ftb_game_manager` (hängt von allem ab). Das Device ins Level ziehen und Plots, Pools und Buttons zuweisen.

## Was UNVERIFIED oder LIKELY ist (in UEFN zuerst prüfen)

| Stelle | Datei | Status | Fallback / Hinweis |
|---|---|---|---|
| `FitsInPlayerMap[...]` als `<decides>` | save | Name VERIFIED, Signatur UNVERIFIED | Ohne Prüfung committen; die Save-Größe liegt bei < 4 KB |
| Kopierkonstruktor `MakeSaveFrom<constructor>` | save | LIKELY (Epic-Tutorial-Muster) | Neues Objekt Feld für Feld bauen (`BuildSave`) |
| Persistable-Defaults nur als Literale | save | LIKELY (Forum: Linker-Fehler bei Konstanten) | – |
| Keine bitweisen Operatoren in Verse | save | UNVERIFIED | Arithmetik mit 32 Bit je Wort ist ohnehin korrekt |
| `GetSecondsSinceEpoch()` Rückgabetyp und Effekte | time | Existenz LIKELY (API-Seite im Suchindex) | `ReadEpoch()` gibt `0.0` zurück, dann greifen automatisch Session-Kalender und Fallback A/B |
| `creative_prop.Hide()/Show()` | pool | LIKELY | `TeleportTo` unter die Map |
| `creative_prop.SetMaterial(material)` und `@editable []material` | pool | LIKELY / UNVERIFIED | Asset-Digest-Pfad statt `@editable`; sonst Aura-VFX |
| `MoveTo(transform, Zeit)` mit Skalierung | pool | LIKELY | `MoveTo(Position, Rotation, Zeit)` ohne Squash |
| `rotation.RotateVector`, `vector3 * float`, `Distance` | pool, combat | LIKELY | Yaw-Rotation manuell mit `Sin`/`Cos` |
| `input_trigger_device.PressedEvent` auf „Fire“ | manager | LIKELY | UMG-/Verse-Button „SMASH“ ruft `Hype.RegisterPress` |
| `teleporter_device.Teleport(agent)` | manager | LIKELY | Player-Spawner je Plot |
| Parametrische Funktion `WithoutKey(... where k:subtype(comparable), v:type)` | manager | LIKELY-Syntax | Pro Map einen eigenen Helfer schreiben |
| IIT: Modul `/Fortnite.com/Marketplace`, Basisklasse `entitlement`, Felder `Consumable/MaxCount/ConsequentialToGameplay`, `entitlement_offer`, `BuyOffer`, `ConsumeEntitlement`, `GetPurchasedEntitlements` (Rückgabe Paare), `GetEntitlementsChangedEvent`, `GetMinPurchaseAge` | shop_iit, manager | Namen VERIFIED/LIKELY, **Signaturen UNVERIFIED** | Die Epic-IIT-Device-Vorlage wörtlich übernehmen und nur die Logik hierher portieren |
| `MakeColorFromHex`, `text_block.SetTextColor` | ui | UNVERIFIED | `NamedColors`, oder Farben nur in UMG |
| `RemoveWidget`, `widget_message`, `OnClick()` | ui | LIKELY | – |
| Controller-Fokus, Safe Zones in Verse-UI | ui | UNVERIFIED [Feas §2] | Große Buttons, Welt-Terminals als Primärzugang, UMG für die Endfassung |
| Effekt-Spezifizierer (`<transacts>` an Helfern) | alle | Sprachregel VERIFIED, Einzelfälle ungeprüft | Meldet der Compiler „cannot call … in failure context“, `<transacts>` ergänzen; bei `<computes>`-Konflikten auf `<transacts>` ausweichen |
| `Round[]`-Rundung bei x.5 | economy | UNVERIFIED | `FormatBig` wurde gegen Python `fmt()` getestet (0 Abweichungen bei 20.012 Werten, Python-Rundung). An x.5-Grenzen kann Verse um 1 in der letzten Stelle abweichen, das ist nur optisch |

**Bewusst geprüft (in Python gespiegelt):** Der Namensgenerator stimmt für alle **1.000** Zeilen von `data/hybrid_names.csv`, `FormatBig` stimmt mit `economy_sim.py fmt()` überein, und die Pool-Offsets stimmen mit `blender/gen_species_parts.py --dry-run` überein.

## Offene Punkte / TODO für den lokalen Agenten

- **Boss-Stampf-Angriff** (KO 5 s) ist nur als TODO in `ftb_combat.verse` angelegt; dafür wird eine KO-Liste im Zustand gebraucht.
- **Ei-Automat S1, Stall-Picker, Index S9, Rebirth S10, Code-Tastatur S12, Shop S13** sind nur als Logik vorhanden (`TryRedeemCode`, `ApplyRebirth` …). Die Screens am besten in **UMG + Verse Fields** bauen (VERIFIED seit v38.00).
- **Katalog-Tabellen** (88 Kreaturen, Event-Formen) per Python aus `brainrot_catalog.csv` generieren (GDD §16.4), nicht per Hand.
- **Gegner-Props** (Staubfussel & Co.) und Drops: Pool analog zu `ftb_plot_pool`, Laufweg per `MoveTo` über 25 s bzw. 18 s.
- **Audio** (`audio_player_device.Register(Agent)` + `Play`, LIKELY) und **VFX** (`SpawnParticleSystem`, VERIFIED-Name) an den Reveal-, Lunge- und Boss-Stellen einhängen.
- `ftb_game_manager.verse` ist mit ≈ 345 Zeilen am größten. Beim Ausbau Boss-Loop und Timer in eigene Dateien auslagern.

## Tipps

- **Save-Schema zuerst einfrieren.** Nach dem ersten Publish dürfen nur noch Felder **mit Default** ergänzt werden, nie umbenennen oder löschen (VERIFIED). Das Kreatur-Packformat wird nur um eine neue **oberste** Stelle erweitert.
- **Kein Stringspeicher im Save.** Namen werden immer aus IDs berechnet (`DisplayName`).
- **Atomar vergeben:** Markierung, Belohnung und `CommitSave` stehen in **einem** `if`. Scheitert irgendwas, rollt Verse alles zurück, deshalb gibt es keine Doppelvergabe.
- **IIT:** Gewährt wird **nur** über `OnPurchasesChanged`/`SyncEntitlements`, nie über den Rückgabewert von `BuyOffer`. Beim Join immer `GetPurchasedEntitlements` abgleichen, das fängt den bekannten „MaxCount=1 verloren“-Bug ab.
- **Performance:** keine Per-Frame-Loops. Einkommen läuft mit 1 Hz, der Kampf mit 4 Hz, UI-Interpolation clientseitig. `FitsInPlayerMap` nur beim Commit aufrufen (Forum: langsam).
- **Debug:** `DebugSaveSummary` per `Print` ausgeben. Im Private Playtest mit „Grant All Products“ und „Force Remove Products“ testen.
