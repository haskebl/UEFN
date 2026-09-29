# Red-Team-Review: „Fuse/Breed the Brainrot“

Unabhängige Prüfung des Berichts `reports/Brainrot Map Marktanalyse UEFN.md` (Stand 29.09.2026). Zusätzlich zu den Notizen habe ich vier Websuchen gemacht. Alle neuen Belege stammen aus Such-Snippets.

## 0. Wichtigster neuer Befund: Fusion ist keine Lücke, sondern Standard-Nebenmechanik

Der Bericht behauptet, Fusion gebe es auf Fortnite „nirgends in Produktionsqualität“. Die Suche zeigt etwas anderes. Die **Fuse Machine** ist inzwischen Standard in den großen Brainrot-Spielen:
- **Roblox:** Steal a Brainrot („Santa's Fuse update“, „Divine Fuse Machine“, [Sportskeeda](https://www.sportskeeda.com/roblox-news/steal-brainrot-santa-s-fuse-update-patch-notes)), Plants vs Brainrots mit Fuse-Rezepten ([GameRant](https://gamerant.com/roblox-plants-vs-brainrots-all-fuse-recipes-how-use-fuse-machine-guide/)), Be a Brainrot ([Sportskeeda](https://www.sportskeeda.com/roblox-news/be-a-brainrot-fuse-machine-guide)).
- **Fortnite:** BE A BRAINROT mit „Fuse Factory“ (6931-5304-1207, Peak 14.568 am 02.04.2026, [fortnite.gg](https://fortnite.gg/island/6931-5304-1207)) und Kick a Lucky Rot mit „Fuse Machine“-Codes ([GameRant](https://gamerant.com/fortnite-kick-a-lucky-rot-all-codes/)). Dazu kommen laut Bericht die Craft-Maschine in Steal the Brainrot, Fusions-Crafting in Droid Tycoon und Duplikat-Merge in Fight.
- **Fusion als Hauptverb** gibt es auf Roblox ebenfalls: „Brainrot Fusion“ und „Fuse Anything into Brainrot“ ([Roblox](https://www.roblox.com/games/73463473679870/Fuse-Anything-into-Brainrot)). Für keins der beiden sind Hit-Zahlen belegt.

**Deutung:** Der Markt hat Fusion getestet. Als *Sink mit Timer* hat sie sich durchgesetzt, als *Hauptverb* nicht. Die „Lücke“ ist damit eher ein Nachfragesignal gegen das Konzept. Die Spieler kennen Fusion bereits, der Neuheitswert ist gering.

## 1. Die fünf stärksten Scheiter-Gründe

1. **Fusion trägt nicht als Hauptverb.** Wahrscheinlichkeit: **hoch.** Fusion kommt nur als Nebenmechanik in Hits vor (Abschnitt 0). Die reinen Fusion- und Merge-Titel sind klein: MERGE THE BRAINROT erreichte maximal 4.144 (Bericht B1), für Roblox-Fusion-Titel gibt es keine Zahlen (census Z. 94, 171). Die Kernschleife aller 8-Mio.-plus-Hits ist „rausgehen, holen, zur Base bringen“ plus ein aktives Verb (Bericht A2, deepdive Z. 63). Fuse hat **kein aktives Verb**. Es ist Menü-Gameplay auf dem eigenen Plot.
2. **Eigene Figuren verlieren den Klickhebel, der Brainrot-Maps trägt.** Wahrscheinlichkeit: **mittel-hoch.** Gute Klickraten bekommen Brainrot-Thumbnails durch *bekannte* Figuren wie Tung Tung oder Tralalero. Die sind wegen IP-Risiko und Epics Lizenz-Skins gesperrt (Bericht E4). Ein Thumbnail mit „A + B = C“ aus unbekannten Kreaturen ist erklärungsbedürftig und konkurriert mit lizenzierten und etablierten Maps. Im Discover-Test über bis zu 2 Wochen ([How Discover Works](https://dev.epicgames.com/documentation/fortnite/how-discover-works-in-fortnite)) entscheidet aber die erste Klickrate. Ein Solo-Creator hat außerdem keine Community für den Kaltstart (Bericht D4-9).
3. **Der Kern ist technisch unbewiesen, der Plan zu knapp.** Wahrscheinlichkeit: **mittel.** Laufzeit-Skelettanimation auf per Verse erzeugten Entities spielt laut Forumsbericht nicht ab (Bericht E2). Plan C (vorplatzierte Pool-Slots, Teile nur ein- und ausblenden) multipliziert Actors mit 16 Plots mal Slots mal Teilen. Das trifft das Speicherbudget von 100.000 Einheiten, das nur zur Editierzeit messbar ist. Vom 29.09. bis zur Einreichung am 05.12. bleiben **rund 9,5 Wochen**. Davon gehen Woche 1 (Spike) und Woche 6–7 (Test) ab. Die Offline-Brutzeiten hängen an einer nicht belegten Zeit-API (feasibility, Bericht E-Tabelle).
4. **Umfang gegen das Claude-Pro-Kontingent.** Wahrscheinlichkeit: **mittel-hoch.** Geplant sind 36 animierte Teile, ein Namensgenerator, TTS-Silben, Index-UI, Reveal, IIT, Persistenz-Schema, vorab eingebaute Live-Ops-Rotationen und Koop-Egg-Raids. Das ist der aufwendigste Kandidat (Aufwand-Score 4). In der Matrix zählt der Aufwand aber nur **5 %**. Verse-Iterationen gegen Digest-Fehler sind kontingent-intensiv. Das realistische Ergebnis ist ein halbfertiges Produkt beim Launch.
5. **Das Trend-Timing ist verpasst, und die Retention ist geliehen.** Wahrscheinlichkeit: **mittel.** Die Obergrenze neuer Roblox-Brainrot-Titel liegt unter 100.000 (Bericht A3). Auf Fortnite sind nur noch Fight (Peak 29.08.) und Grow (23.09.) frisch. Beide sind Nicht-Fusion-Loops mit aktivem Verb oder Aufzucht. Der Retention-Wert von 8 für Fuse stützt sich auf die 158 Minuten von Grow The Brainrot. Genau diese Map besetzt laut Bericht aber die Ei-Hälfte (B2). Die Evidenz wird damit **doppelt verwertet**. Zum Launch kommen die Weihnachts-Events der Platzhirsche hinzu (Christmas-Variante von Steal the Brainrot, Bericht C).

Weitere, schwächere Punkte:
- Die IIT-Quote halbiert sich ab 01.02.2027.
- Drei Tester sind statistisch wertlos.
- Epics Review läuft über die Feiertage.

## 2. Prüfung der Matrix

**Strukturfehler:**
- Es gibt kein Kriterium „auf Fortnite bewiesene Nachfrage“. Das einzige Fortnite-native Signal von 2026 ist Fight mit 211K im August 2026. Die Matrix wertet es als *Minus*, weil sie nur „Lücke“ misst.
- Der Aufwand zählt 5 %, obwohl Zeit und Kontingent die härteste Grenze sind.

**Zu optimistische Scores für Fuse:**

| Kriterium | Bericht | Fair | Begründung |
|---|---|---|---|
| Roblox-Nachfrage | 7 | **5** | Die Nachbarn Steal An Egg und Merge sind Steal- oder Hatch-Loops. Fusion ist dort nur Sink (Abschnitt 0). |
| Fortnite-Lücke | 8 | **5** | Fusion ist Nebenmechanik in mindestens 5 Fortnite-Maps; das Ei besetzt Grow mit 53K. |
| Retention | 8 | **6** | Die geliehenen 158 Minuten (Punkt 5) fallen weg. |
| Machbarkeit | 6 | **5** | Der Kern ist UNVERIFIED, dazu kommt der Laufzeit-Bug. |
| Aufwand | 4 | **3** | — |
| Thumbnail | 8 | **7** | Unbekannte eigene Figuren (Punkt 2). |

Ergebnis für Fuse: **5,65** statt 7,25.

**Zu pessimistische Scores:**
- **Fight/Boss:** Roblox-Nachfrage 6 bleibt. Die Lücke steigt von 2 auf 3, weil es nur einen großen Titel gibt und der Rest bei 7–9K liegt. Thumbnail 7. Ergebnis **≈ 6,15**.
- **Fish:** Die Lücke sinkt von 7 auf 6, denn zwei zerfallene Maps deuten auf wenig Nachfrage. Ergebnis **≈ 6,15**.
- **Steal-Hybrid:** bleibt bei 6,15.

**Neue Rangfolge:** Fish, Fight und Steal-Hybrid liegen bei je ≈ 6,15, Fuse bei 5,65, Tower Defense bei 5,55. **Die Rangfolge kippt.** Wichtiger noch: Die Matrix trennt die Kandidaten nicht, alle liegen innerhalb von ±0,4 Punkten, und das ist Schätzrauschen. Fuses Vorsprung ist ein Artefakt aus zwei Dingen: dem Lücken-Kriterium und der geliehenen Retention. Die Sensitivitätsanalyse im Bericht (D2) hat nur zwei Scores gesenkt und Retention und Thumbnail nicht angefasst.

## 3. Übersehene bessere Richtung: „Fuse & Fight“, also Fusion als Bauweg für einen Koop-Kampf

Das Muster der Gewinner von 2026 lautet: Sammel- und Einkommens-Kern plus **ein aktives zweites Verb** (deepdive Z. 63, Bericht A2). Fight The Brainrot beweist mit Merge und Koop-Bossen **auf Fortnite** 211K, 85 min Spielzeit und einen späten Peak nach einem Update. Mein Vorschlag:
- Spieler brüten Kreaturen aus und fusionieren sie. **Die Hybride kämpfen** (Autobattler-artig oder als Begleiter) in Koop-Wellen und gegen Server-Bosse.
- Fusion wird damit vom Sammelselbstzweck zum **Build-Crafting mit spürbarer Konsequenz**: Welcher Kopf, welcher Körper, welches Accessoire ergibt welchen Angriff. Das erzeugt Clip-Momente („mein Hybrid solo gegen den Boss“) und skaliert auf 16 Spieler.
- **Abgrenzung zu Fight:** Dort kämpft der Spieler, hier kämpfen die gebauten Kreaturen. Das ist klar genug gegen Regel 1.9.1 und die Klon-Abwertung.
- **Technisch** kann der Kampf abstrakt bleiben: Schaden als Zahl, Boss als ein NPC, Treffer als VFX. Laufende Kreatur-KI braucht es nicht.

**Ein Kreaturen-Thema ohne Brainrot** empfehle ich *nicht*. Auf Fortnite hat der reine Pet-Sim maximal 1.835 Spieler erreicht (B1). Brainrot ist dort das einzige bewiesene Such- und Klick-Keyword. Die Austausch-Option für später bleibt richtig.

## 4. Bedingungen für eine robuste Empfehlung

- **Umfang kürzen:** 8 Arten × 3 Slots = 512 Kombinationen, also 24 Teile statt 36. Plan C (Pool-Slots, Teile nur ein- und ausblenden) wird Standard, nicht Rückfall. Kopf und Accessoire bekommen nur Bob-Animation. Offline-Einkommen wird gestrichen, falls die Zeit-API in Woche 1 nicht bestätigt ist.
- **Zweites Verb von Anfang an:** mindestens ein Koop-Boss oder Wellen-Modus, in dem die Hybrid-Werte zählen. Das Egg-Raid aus dem Bericht wird damit zum Kern, nicht zur Nebensache.
- **Früher und breiter testen:** Spielbarer Kern bis **Woche 4**, 8–10 Tester statt 3. Ziele: erste Fusion unter 3 Minuten, mindestens 70 % fusionieren freiwillig ein zweites Mal, Median-Session über 20 Minuten.
- **Thumbnail-Test vor dem Bau:** In Woche 2 drei Mock-Thumbnails mit eigenen Figuren gegen Top-Brainrot-Thumbnails zeigen (Umfrage oder Kurzvideo-Klickrate). Verlieren alle deutlich, wird das Branding überarbeitet.
- **Feature-Freeze am 15.11.** Danach nur noch Bugfixes, Balance und Winter-Skin.

**Kill-Kriterien:**
- **Woche 1:** Der Spike mit 2×2×2 Teilen scheitert, oder das Speicherbudget für 16 Plots liegt hochgerechnet über 70 %. Dann Wechsel auf Fish oder Fight-Hybrid.
- **Woche 2:** Die Ecosystem API zeigt eine Fusion-first-Map mit mehr als 5K Peak in 30 Tagen, **oder** BE A BRAINROT bzw. Kick a Lucky Rot erreichen mit Fuse-Feature mehr als 10K. Dann ist Fusion als Differenzierung verbraucht, und die Matrix wird neu gerechnet.
- **Woche 4:** Das Testziel von mindestens 70 % Zweit-Fusion wird verfehlt.
- **Nach dem Launch im Discover-Test:** D1 unter 8 % oder Ø-Spielzeit unter 20 Minuten. Dann Titel und Thumbnail an der bestehenden Insel umstellen und nur noch minimal pflegen.

## 5. Urteil: **anpassen**

Verwerfen wäre zu hart. Kreatur plus Ei plus Index plus Rebirth ist eine bewährte Schleife, das IP- und Regelkonzept ist sauber, und die Pipeline passt zu Luis' Blender-Workflow. In der jetzigen Form ist das Konzept aber ein **Sink ohne Kern-Verb**, begründet mit einer Lücke, die es nicht gibt, und einer Retention, die von einer anderen Map geliehen ist. Anpassen heißt deshalb:
1. Fusion wird der Build-Weg zu einem aktiven Koop-Kampf-Verb („Fuse & Fight“).
2. Der Umfang sinkt auf 24 Teile.
3. Die Tests kommen früher.
4. Die Kill-Kriterien oben gelten.

Fish/Catch ist als Rückfall schwächer, als der Bericht nahelegt, denn die Fortnite-Fishing-Maps sind zerfallen. Den gleichen Rang verdient der Fight-nahe Hybrid.
