# Phase H: Launch, Wachstum, Live-Betrieb – „FUSE THE BRAINROT“ (Arbeitstitel)

**Creator:** Luis (Creator-Name „haske“) · **Stand:** 29.09.2026 · **Konzept:** „Fuse & Fight“ (Eier ausbrüten → eigene Brainrot-Kreaturen verdienen auf dem Plot → zwei Kreaturen zu einem modularen Hybriden mit Mash-up-Namen fusionieren → Hybride kämpfen solo gegen Wellen und im Koop gegen Server-Bosse)
**Ziel-Release:** Do 10.12.2026 (Fenster 8.–15.12.) · **Live-Ops:** 8 Wochen zeitgesteuert im Release-Build · **Tester:** 3 · **IIT:** deterministisch ab Tag 1

> **Quellenlage.** Grundlage sind `reports/Brainrot Map Marktanalyse UEFN.md` und die Notizen `discovery_platform_benchmarks.md`, `red_team_review.md` und `ip_rules_monetization.md`. Dazu kamen wenige Websuchen am 29.09.2026 (nur Snippets, Seiten nicht geöffnet). Labels: **OFFICIAL** (Epic-Doku oder Epic-News per Snippet), **CLAIMED** (Blog oder Presse), **ESTIMATED** (eigene Ableitung), **UNVERIFIED** (Wert nicht bestätigt, vor Nutzung im Creator Portal prüfen). **Keine Zahl in diesem Plan ist gemessen.** Der Titel ist ein Platzhalter. Das parallel entstehende GDD kann ihn noch ändern, alle Regeln hier gelten dann für den neuen Titel genauso.

---

## 0. Die fünf wichtigsten Punkte

1. **Über den Launch entscheidet das Discover-Testfenster** von bis zu 2 Wochen nach dem Publish (OFFICIAL, [How Discover Works](https://dev.epicgames.com/documentation/fortnite/how-discover-works-in-fortnite)). Bei einem Publish am 10.12. läuft es bis etwa 24.12. und überschneidet sich mit Winterfest (≈17.12., geleakt) und dem Ferienbeginn. Freunde, Discord und Clips gehören **in** dieses Fenster, nicht davor.
2. **Titel und Thumbnail müssen „Fusion“ zeigen, nicht „Ei“**, sonst wirkt die Insel wie „Grow The Brainrot 2“ und wird als ähnliche Insel abgewertet ([Big Changes for Discover](https://www.fortnite.com/news/big-changes-for-discover)). Das sprachfreie Motiv „Kreatur **+** Kreatur **=** Hybrid“ trägt den Hook. **Pfeile sind auf Thumbnails verboten** (OFFICIAL, [Thumbnail-Update](https://forums.unrealengine.com/t/discover-island-thumbnail-update/1199156)).
3. **Abbruchkriterien aus dem Red Team gelten:** D1 unter 8 % oder Ø-Spielzeit unter 20 min im Testfenster heißt: Titel und Thumbnail an **derselben** Insel umstellen und nur noch minimal pflegen. Ein Duplikat ist wegen Regel 1.9.1 verboten.
4. **Die Ecosystem API liefert nur 7 Tage rückwirkend.** Lokales Claude Code muss die Werte deshalb ab Tag 0 **täglich archivieren**, sonst sind sie weg (CLAIMED/OFFICIAL, [Fortnite Data API](https://www.fortnite.com/news/fortnite-data-api-unlocks-more-island-insights-for-creators)).
5. **Rund um Weihnachten gibt es keine Publishes.** Alles bis 6.1. kommt zeitgesteuert aus dem Build. Hotfix-Fenster sind nur Tag 1–7 (10.–17.12.). Die Review-Dauer über die Feiertage ist unbekannt (ESTIMATED; Verzögerungen belegt: [Sportskeeda](https://www.sportskeeda.com/fortnite/epic-games-speed-review-process-fortnite-creative-maps?ref=homepage)).

---

## 1. Titel, Beschreibung, Tags, Keywords

### 1.1 Feldgrenzen

| Feld | Grenze | Status |
|---|---|---|
| Titel | Genaue Zeichengrenze **UNVERIFIED**. Plan: **höchstens 24 Zeichen**, damit der Titel auf der Discover-Kachel und mobil nicht abgeschnitten wird (ESTIMATED) | Im Creator Portal am Zeichenzähler des Feldes prüfen |
| Beschreibung | Bis zu **3 Beschreibungszeilen** (OFFICIAL: „title and up to 3 descriptions“, [Island Description Settings](https://www.fortnite.com/fortnite/en-US/creative/docs/changing-my-island-description-settings-in-fortnite-creative)). **Je 80 Zeichen** gilt für die Island-Settings in Creative ([Fandom](https://fortnite.fandom.com/wiki/Creative_Island_Settings)) und ist fürs Creator Portal **UNVERIFIED** | Jede Zeile hier hat ≤ 80 Zeichen, damit sie auf jeden Fall passt |
| „How to Play“ | Eigenes Feld auf dem Game-Details-Screen (OFFICIAL, [Game Details Screen](https://dev.epicgames.com/documentation/fortnite/game-details-screen-in-fortnite?lang=en-US)); Länge **UNVERIFIED** | Kurz halten, 3–4 Stichpunkte |
| Tags | **Höchstens 4** (OFFICIAL, [Game Tags](https://dev.epicgames.com/documentation/en-us/fortnite-creative/games-and-game-tags-in-fortnite-creative)). Das Genre ist getrennt von den Tags, jede Insel steht in nur einer Genre-Zeile | Nur aus der Portal-Liste wählbar |
| Thumbnail | **Mindestens 1920×1080, 16:9, höchstens 5 MB** (OFFICIAL, [Thumbnail Image Policies](https://dev.epicgames.com/documentation/fortnite/thumbnail-image-policies?lang=en-US)). Das Thumbnail ist auch der Standard-Ladebildschirm ([FNCreate](https://x.com/FNCreate/status/1944789163640803745)) | — |

### 1.2 Titel

**Empfehlung: `FUSE THE BRAINROT`** (17 Zeichen, Großbuchstaben wie bei allen Top-Titeln).

| Kandidat | Pro | Contra | Urteil |
|---|---|---|---|
| **FUSE THE BRAINROT** | Folgt exakt der Formel „VERB + THE BRAINROT“ der Top-Maps (STEAL / GROW / BEAT / Fight THE BRAINROT); „Fuse“ ist aus der „Fuse Machine“ bekannt; kurz | Der Kampf-Teil steht nicht im Titel, ihn zeigen Thumbnail und Beschreibung | **Nr. 1** |
| FUSE & FIGHT BRAINROTS | Beide Verben | Zu nah an „Fight The Brainrot“ (211K Peak), Risiko Klon-Eindruck und Verwechslung; 22 Zeichen | Nur als Unterzeile im Thumbnail |
| FUSE THE BRAINROT 🧬 | Emoji hebt ab (vgl. „Steal An Egg 🥚“) | Emoji-Darstellung auf allen Plattformen **UNVERIFIED** | A/B-fähig nur über den Titel, nicht über das Thumbnail-Tool, daher später |
| BRAINROT FUSION LAB | eigenständig | Bricht mit der gelernten Verb-Formel; „Lab“ ist schwaches Suchwort | Rückfall, falls „FUSE THE BRAINROT“ schon vergeben ist |

**Pflicht vor dem Eintragen:** Auf fortnite.gg und in der Fortnite-Suche prüfen, ob es „FUSE THE BRAINROT“ schon gibt. Existiert ein gleichnamiger Titel, droht Verwechslung und die Abwertung ähnlicher Inseln. Dann „BRAINROT FUSION LAB“ nehmen oder den Titel aus dem GDD.

### 1.3 Beschreibung (≤ 80 Zeichen pro Zeile)

Primär auf **Englisch**, weil das Publikum global ist. Ob sich Metadaten im Portal lokalisieren lassen, ist **UNVERIFIED**. Wenn ja, die deutsche Fassung zusätzlich eintragen.

**EN (primär)**
1. `Hatch eggs, fuse two creatures into one brand-new hybrid and fill your Index!` (77)
2. `Your hybrids power up your plot, battle waves solo and team up vs. bosses.` (74)
3. `Up to 16 players. New creatures and events unlock week by week.` (63)

**DE (falls lokalisierbar)**
1. `Brüte Eier aus, fusioniere zwei Kreaturen zu einem neuen Hybriden!` (67)
2. `Deine Hybride stärken deinen Plot, kämpfen solo und im Team gegen Bosse.` (74)
3. `Bis zu 16 Spieler. Neue Kreaturen und Events jede Woche.` (56)

**How to Play (EN)**
- `Hatch an egg and place your creature on your plot.`
- `Pick two creatures and FUSE them – head, body and gear mix into a new hybrid.`
- `Send your hybrids into waves and join the server boss fight.`
- `Rebirth to go further and complete the Fusion Index.`

Zeile 3 ist nur korrekt, wenn die Max-Players-Einstellung wirklich 16 ist und die Wochen-Unlocks im Build liegen. Sonst die Zeile ändern, denn Metadaten müssen die Insel korrekt darstellen.

### 1.4 Tags (4)

Die exakten Tag-Namen sind **UNVERIFIED** und nur aus der Dropdown-Liste im Portal wählbar. Ziel-Belegung:

1. **Simulator** (Genre-Nachbar der Brainrot-Hits; Genre-Benchmark „Simulation & Tycoon“)
2. **Tycoon** (Plot-Einkommen; so werden Steal the Brainrot und Droid Tycoon gelistet)
3. **PvE** oder **Co-op**: das Wort nehmen, das die Liste anbietet (Wellen und Server-Boss, Abgrenzung zu reinen Aufzucht-Maps)
4. **Collectathon** oder **Casual** (Index sammeln)

Nicht verwenden: Tags oder Titelwörter wie „Brainrot Tung“, „Tralalero“ oder andere geschützte Namen, „AFK“, „XP“, „Idle“ (weckt AFK-Assoziationen, ESTIMATED) und „Free“.

### 1.5 Keyword-Recherche: Was Spieler eintippen

In der Fortnite-Suche kann man nach Inselcode, Inselname und Creator suchen (OFFICIAL, [Epic Help](https://www.epicgames.com/help/c-202300000001636/c-202300000001721/a202300000010419?lang=en-US)). **Öffentliche Suchvolumen-Daten für die Fortnite-Suche gibt es nicht** (Gap aus den Discovery-Notizen). Die Evidenz ist deshalb indirekt:

| Keyword | Evidenz | Einsatz |
|---|---|---|
| **brainrot** | Steckt in 11 von 11 Top-Brainrot-Titeln (STEAL/GROW/BEAT/Fight THE BRAINROT, GO UP FOR BRAINROTS usw., fortnite.gg-Snippets); laut Red Team das einzige belegte Such- und Klickwort der Kategorie auf Fortnite | Im Titel, Pflicht |
| **fuse / fusion** | Spieler kennen „Fuse Machine“ aus Steal a Brainrot (Roblox, „Santa's Fuse update“, „Divine Fuse Machine“), Plants vs Brainrots (Fuse-Rezepte), BE A BRAINROT („Fuse Factory“) und Kick a Lucky Rot ([Sportskeeda](https://www.sportskeeda.com/roblox-news/steal-brainrot-santa-s-fuse-update-patch-notes), [GameRant](https://gamerant.com/roblox-plants-vs-brainrots-all-fuse-recipes-how-use-fuse-machine-guide/), [Fandom](https://stealabrainrot.fandom.com/wiki/Fuse_Machine)) | Titel-Verb. Das Wort ist gelernt, es muss nicht erklärt werden |
| **merge** | MERGE THE BRAINROT und mehrere Merge-Klone auf Fortnite | Nur in der Beschreibung, falls die Portal-Suche Beschreibungen indiziert (**UNVERIFIED**). Nicht in den Titel, sonst entsteht Klon-Nähe |
| **fight / boss** | Fight The Brainrot 211K Peak (29.08.2026) | Beschreibung (Zeile 2) und Thumbnail B, nicht im Titel |
| **„<Mapname> codes“** | Zu jeder großen Brainrot-Map gibt es Code-Artikel: thespike.gg, Beebom, Destructoid, GameRant, nerdschalk ([Beispiel](https://beebom.com/fortnite-fight-the-brainrot-codes/)) | Ein Google- und YouTube-Suchmuster, kein Fortnite-Suchmuster. Wöchentliche Codes machen die Map für solche Artikel „schreibbar“, das ist Gratis-SEO. **Das Wort „codes“ nicht in die Metadaten**, weil es wie ein Belohnungsversprechen wirken kann (ESTIMATED) |
| **haske** | Creator-Suche | Profil vor dem Launch ausfüllen, damit die Suche nach „haske“ die Insel findet |

**Validierung (Luis, 15 min, im November):** In der Fortnite-Suche „fuse“, „fusion“, „merge brainrot“ und „brainrot“ eintippen und die Autovervollständigung sowie die ersten 10 Treffer als Screenshot sichern. Zusätzlich Google Trends für „fuse brainrot“, „brainrot fortnite“ und „brainrot codes“ ansehen.

### 1.6 Regelprüfung der Metadaten

| Regel | Prüfung | Status |
|---|---|---|
| Keine Begriffe „AFK“, „XP“, „Coin farm“, „Coin slide“ in Name, Beschreibung, Thumbnail, Ladebildschirm und Lobby-Hintergrund ([Developer Rules](https://legal.epicgames.com/fortnite/developer-rules)) | Nicht enthalten. Bewusst auch kein „idle“ | ✅ |
| Keine Erwähnung von V-Bucks, Battle Pass, Echtgeld oder Belohnungen; keine Währungsbilder ([Thumbnail Policies](https://dev.epicgames.com/documentation/fortnite/thumbnail-image-policies?lang=en-US)) | Nicht enthalten. Kein „free“, kein „rewards“, kein „codes“. Im Thumbnail keine Münzen, Geldscheine oder $-Zeichen, auch keine Ingame-Währung (sicherer, weil „Reference to Currency“ verboten ist) | ✅ |
| Keine Pfeile, keine Plattform-Buttons, keine Waffen in Quadraten, kein Preisschild-Look ([Thumbnail-Update](https://forums.unrealengine.com/t/discover-island-thumbnail-update/1199156)) | „+“ und „=“ statt Pfeil. Keine Controller-Tasten | ✅ |
| Nicht irreführend: Metadaten müssen die Insel korrekt darstellen | „16 players“ und „weekly unlocks“ nur, wenn sie im Build stimmen. Das Winter-Thumbnail nur, solange das Winter-Event live ist | ⚠️ Beim Publish prüfen |
| Keine fremde IP | Keine Namen aus der Sperrliste (Tung, Sahur, Tralalero, Tralala, Cappuccina, Bombardiro, Crocodilo, Patapim, Lirilì, Bananini), keine bekannten Figurenlooks | ✅ |
| Nicht auf unter 13-Jährige ausrichten | Kein „for kids“, keine Kinder-Ansprache | ✅ |
| Regel 1.9.1: keine Duplikate | Nur eine Insel. Ein Rebranding findet an derselben Insel statt | ✅ |

---

## 2. Thumbnail-Konzept

### 2.1 Was erfolgreiche Brainrot-Thumbnails tun (und was davon belegt ist)

**Ehrliche Einschränkung:** Die Thumbnail-Bilder selbst konnte niemand ansehen, alle Bild-Hosts waren gesperrt. Die folgende Analyse leitet sich aus Titeln, Map-Beschreibungen und allgemeinen CTR-Leitfäden ab. **Luis muss R0-1 aus dem Bericht nachholen:** die Top-10-Brainrot-Kacheln auf fortnite.gg als Screenshot sichern und prüfen, ob das Muster unten stimmt. Das dauert 10 Minuten.

| Muster | Beleg | Übernahme für FUSE |
|---|---|---|
| 1–2 große Figuren füllen 40–60 % des Bildes | CTR-Leitfäden für Fortnite ([1of10](https://1of10.com/blog/fortnite-thumbnail-maker-how-to-create-high-ctr-gaming-thumbnails-with-ai/)); ESTIMATED für Brainrot | Hybrid als Hauptmotiv, groß |
| Sichtbare Emotion (Schock, Hype, Panik) | [Simplified](https://simplified.com/blog/ai-design/fortnite-thumbnail-that-impossible-to-ignore), [1of10](https://1of10.com/blog/fortnite-thumbnail-maker-how-to-create-high-ctr-gaming-thumbnails-with-ai/) (CLAIMED) | Jede Kreatur bekommt eine „Schock/Jubel“-Gesichtstextur nur für Thumbnails und Clips |
| Fortnites Grundpalette Blau/Violett plus warme Motivfarben (Orange, Gelb, Rot) | [1of10](https://1of10.com/blog/fortnite-thumbnail-maker-how-to-create-high-ctr-gaming-thumbnails-with-ai/) (CLAIMED) | Violetter Grund, gelber Fusionsblitz |
| Energie-Ring oder Explosion hinter dem Motiv, Text im oberen Drittel | [1of10](https://1of10.com/blog/fortnite-thumbnail-maker-how-to-create-high-ctr-gaming-thumbnails-with-ai/) (CLAIMED) | Fusionsblitz = Energie-Ring |
| Höchstens 2–3 Wörter Text | Discovery-Notizen §3 (ESTIMATED) | Höchstens 1–2 Wörter oder nur Symbole |
| Brainrot-Hits zeigen *bekannte* Figuren | Red Team, Punkt 2 | **Nicht erlaubt.** Der Ersatz für den Bekanntheitshebel ist das *Rätsel*: „A + B = ?“ reizt zum Klicken, weil man den Hybriden sehen will |
| Originalität wird vorab geprüft | [Big Changes for Discover](https://www.fortnite.com/news/big-changes-for-discover) (OFFICIAL) | Nur eigene Ingame-Screenshots, keine Stock-Grafik, keine Fremd-Thumbnails nachbauen |

### 2.2 Epic-Regeln fürs Thumbnail (Kurzfassung)

- Das Motiv muss echtes Gameplay oder echte Inhalte der Insel zeigen. Die Kreaturen müssen genau so im Spiel vorkommen.
- **Verboten:** V-Bucks, Battle Pass, Echtgeld, Währungssymbole, „XP/AFK“-Text, **Pfeile**, Plattform-Buttons, Waffen in Quadraten, Sale- oder Preisschild-Optik, fremde IP.
- Format mindestens 1920×1080 (16:9), höchstens 5 MB, PNG oder JPG (Dateityp **UNVERIFIED**, JPG mit Qualität 90 ist in der Regel sicher).
- Keine Fortnite-Outfits aus dem Item-Shop zeigen, sondern nur eigene Kreaturen (ESTIMATED, zur Sicherheit wegen Epic-IP).

### 2.3 Drei Varianten

Gemeinsame Palette (Markenfarben):

| Rolle | Hex |
|---|---|
| Hintergrund dunkel | `#1A0B3D` |
| Hintergrund hell (Radial-Mitte) | `#5B1FA8` |
| Fusionsblitz Kern | `#FFFFFF` |
| Fusionsblitz Rand | `#FFD21F` |
| Kreatur A (Spezies-Grundfarbe) | `#7CFF4F` (Limette) |
| Kreatur B | `#FF3FA4` (Pink) |
| Hybrid-Randlicht | `#22E4FF` (Cyan) |
| Text Füllung | `#FFE600` |
| Text Kontur (10–14 px) | `#0B0B14` |

**Variante A – „Das Fusions-Rätsel“ (Hauptvariante, zeigt den USP)**
- **Komposition:** Drei-Teiler auf horizontaler Linie im mittleren Bilddrittel. Links Kreatur A (etwa 25 % der Bildbreite), rechts Kreatur B (etwa 25 %), beide leicht zur Mitte gedreht. In der Mitte, **vorgezogen und ~45 % der Bildhöhe groß**, der Hybrid aus Kopf A, Körper B und Accessoire A, im Moment des Auftauchens aus dem Fusionsblitz. Zwischen A und Hybrid ein dickes „**+**“, zwischen Hybrid und B nichts, stattdessen „A + B =“ als Leiste darüber (siehe Text). Kamera leicht von unten (Heldenperspektive).
- **Figuren:** zwei eigene Basisarten mit klar unterscheidbarer Silhouette, zum Beispiel ein Frucht-Tier und ein Gegenstand-Tier. Der Hybrid muss beide Silhouetten sofort erkennbar kombinieren.
- **Farben:** Grund Radialverlauf `#5B1FA8` → `#1A0B3D`; Fusionsblitz `#FFFFFF`/`#FFD21F`; A `#7CFF4F`, B `#FF3FA4`, Hybrid-Rim `#22E4FF`.
- **Text:** oben mittig „**1 + 1 = ?!**“ in `#FFE600` mit `#0B0B14`-Kontur. Das sind keine Wörter und damit sprachneutral. Alternative für den Test: „**FUSE!**“.
- **Emotion:** A und B schauen erschrocken zum Hybriden, der Hybrid jubelt oder brüllt mit offenem Mund. Die Botschaft: „Was ist *das* denn?“
- **Lesbarkeit klein:** Bei 320×180 müssen drei Silhouetten und der Blitz erkennbar sein. Bei 160×90 muss mindestens „heller Blitz mit Figur in der Mitte“ bleiben. Der Hintergrund bleibt ohne Details, keine Plot-Deko.

**Variante B – „Hybrid gegen Boss“ (zeigt das zweite Verb, Kampf)**
- **Komposition:** Diagonale von links unten nach rechts oben. Rechts oben ein riesiger Server-Boss, angeschnitten, nur Kopf und Schultern, etwa 55 % der Bildfläche. Links unten der Hybrid, klein, aber mit starkem Randlicht, in Angriffspose, ~30 % Höhe. Zwischen beiden ein Treffer-VFX-Blitz. Oben rechts ein Stück der Boss-HP-Leiste als Spiel-UI-Element (erlaubt, weil echtes Gameplay; **keine** Zahlen, die wie Währung aussehen).
- **Farben:** Grund `#0A1633` (Nachtblau). Boss warm `#FF4A1C` und `#B3122E`, Hybrid kalt `#22E4FF` mit weißem Rim `#FFFFFF`. Treffer-Blitz `#FFD21F`. Das ist ein Komplementärkontrast warm gegen kalt.
- **Text:** „**TEAM UP!**“ oder gar kein Text (A/B-fähig). Falls Text: links oben, `#FFFFFF` mit `#0B0B14`-Kontur.
- **Emotion:** Boss wütend, Hybrid entschlossen. Die Botschaft: David gegen Goliath.
- **Lesbarkeit klein:** Der Boss funktioniert allein als Farbfläche mit Augen. Der Hybrid braucht die Cyan-Kontur, sonst geht er bei 160×90 verloren. Deshalb eine Konturlinie von 8 px in Krita.
- **Risiko:** ähnelt eher „Fight The Brainrot“. Das A/B-Ergebnis zeigt, ob das hilft (bekanntes Genre) oder schadet (Klon-Eindruck).

**Variante C – „Winter-Fusion“ (saisonal, nur 17.12.–6.1., während das Frost-Ei live ist)**
- **Komposition:** wie der Gewinner aus A/B, damit der Test nur die Saison misst. Bei A: Kreatur A trägt eine Winter-Accessoire-Variante (Mütze, Schal, **eigenes** Design), Kreatur B ist die Winter-Event-Art, der Hybrid hat Frost-Partikel. Unten Schnee-Kante, oben leichter Schneefall. Der Schnee darf den Hybriden nicht verdecken.
- **Farben:** Grund `#0E3A6B` → `#051A33`; Eis `#BFF3FF`; Schnee `#FFFFFF`; Akzente Rot `#E8283C` und Gold `#FFC83D`; Fusionsblitz bleibt `#FFD21F`, damit die Wiedererkennung bleibt.
- **Text:** wie beim Gewinner. Kein „Christmas“, kein „Event Rewards“.
- **Emotion:** wie der Gewinner, dazu Winter-Freude.
- **Regel:** **Am 6.1. wieder entfernen.** Ein Winter-Thumbnail ohne Winter-Inhalt ist irreführend.

### 2.4 A/B-Plan mit dem Creator-Portal-Thumbnail-Test

Das Tool testet 2 Varianten im 50/50-Split, höchstens 90 Tage lang. Der Gewinner wird nach CTR bestimmt (OFFICIAL, [A/B Thumbnail Testing](https://dev.epicgames.com/documentation/en-us/fortnite/ab-thumbnail-testing-in-fortnite-creative)).

| Runde | Zeitraum | Varianten | Entscheidungsregel | Danach |
|---|---|---|---|---|
| 1 | Do 10.12. – Mi 16.12. | **A vs. B** | Nach mindestens 5 Tagen und mindestens 10.000 Impressions je Variante (ESTIMATED, der Portal-Signifikanzhinweis hat Vorrang, falls es einen gibt): Die Variante mit > 10 % relativ höherer CTR gewinnt. Bei weniger Abstand gilt A als Gewinner, weil sie den USP zeigt | Gewinner = G1 |
| 2 | Do 17.12. – Di 5.1. | **G1 vs. C (Winter-G1)** | wie oben | Ab 6.1. muss C in jedem Fall raus |
| 3 | Mi 6.1. – Mi 27.1. | **G1 vs. D** (neuer Herausforderer: der seltenste Index-Hybrid, oder A mit Text „FUSE!“ statt „1+1=?!“) | wie oben | Gewinner = G2 |
| 4 | ab Do 28.1. | **G2 vs. E** (Motiv zum Inhalt der Woche 8 oder zum Folge-Update) | wie oben | — |

**Regeln für den Test:**
- Pro Runde nur **eine** Variable ändern (Motiv, Text oder Farbe). Sonst ist unklar, was gewirkt hat.
- CTR immer **pro Oberfläche** vergleichen, soweit das Portal sie trennt (OFFICIAL: Impressions und CTR pro Surface, [Discover Performance](https://www.fortnite.com/news/get-a-personalized-view-of-your-fortnite-island-s-discover-performance?team=personal)).
- Ergebnisse protokolliert lokales Claude Code in `deliverables/thumbnail_ab_log.md` (Datum, Varianten, Impressions, CTR, Entscheidung).
- Ob ein Thumbnail-Wechsel eine neue Review auslöst, ist **UNVERIFIED**. Deshalb C schon **vor** dem 17.12. hochladen und in Runde 2 einplanen, nicht erst am 17.12.

### 2.5 Erstellungs-Workflow mit freien Tools

Keine KI-Bildgeneratoren für Figuren. Ist eine KI-Hilfe für Hintergründe gewünscht, dürfen Prompts **nie** Namen oder Beschreibungen geschützter Figuren (Sperrliste) oder anderer Marken enthalten. Empfohlen wird aber, ganz ohne KI zu arbeiten, denn die eigenen Screenshots sind am originellsten und bestehen die Originalitätsprüfung.

1. **Foto-Studio in UEFN (einmalig, 1–2 h):** Einen Bereich außerhalb der Spielfläche anlegen, nicht sichtbar und nicht erreichbar, oder ein eigenes Sublevel, falls es beim Publish nicht mitgeladen wird (**UNVERIFIED**, im Zweifel den Bereich vor dem Publish löschen oder ausblenden). Darin:
   - eine Ebene mit einem **Unlit-Material in Reingrün `#00FF00`** als Hintergrund (Chroma-Key)
   - Beleuchtung: Key-Light warm (`#FFE2B0`) von vorn oben links, Rim-Light `#22E4FF` von hinten rechts, Fill schwach
   - eine Post-Process-Volume mit leichter Sättigung (+10 %) und ohne Bloom (Bloom verschmiert den Key)
   - CineCamera oder Editor-Kamera, Brennweite 50–85 mm (weniger Verzerrung)
2. **Posen:** Die Kreatur-Prefabs in die Thumbnail-Pose bringen. Dafür Animation am passenden Frame anhalten, Sequencer nutzen oder eine eigene „Pose“-Animation aus Blender. Die Thumbnail-Gesichtstextur (Schock/Jubel) einsetzen.
3. **Aufnahme:** Im Viewport „High Resolution Screenshot“ mit Faktor 2 (Ergebnis 3840×2160) und, falls angeboten, Maske oder Alpha. Die Funktion ist in UEFN **LIKELY** vorhanden. Rückfall: Vollbild-Viewport in 4K mit Windows-Snipping oder OBS-Screenshot. Jede Figur einzeln aufnehmen und dazu einen Fusionsblitz-VFX-Frame vor Schwarz.
4. **Freistellen in Krita (oder GIMP):** Farbauswahl auf `#00FF00` mit Toleranz 15–25 %, invertieren, Maske 1 px verkleinern und 1 px weichzeichnen, grüne Säume entsättigen („Color to Alpha“ in GIMP oder Farb-Einstellung im Maskenrand).
5. **Komponieren in Krita:** Leinwand 1920×1080 bei 300 dpi (egal) in RGB 8 bit. Ebenen von unten nach oben:
   1. Radialverlauf
   2. Lichtstrahlen (Verlauf mit Überblendmodus „Addition“, 20 % Deckkraft)
   3. VFX-Blitz im Modus „Screen“
   4. Figuren
   5. weiße oder cyanfarbene Außenkontur 8–12 px (Ebenenstil „Kontur“)
   6. Schlagschatten weich, 25 %
   7. Text
6. **Schrift:** freie OFL-Schriften von Google Fonts, zum Beispiel **Luckiest Guy**, **Lilita One** oder **Bangers**. Die OFL erlaubt kommerzielle Nutzung; die Lizenzdatei trotzdem in `/assets/fonts/LICENSES` ablegen. Text in `#FFE600` mit 12 px Kontur `#0B0B14` und leichter Schräge (−4°).
7. **Sichere Zonen:** Kein wichtiges Element in den unteren 20 % (dort überlagert Discover den Titel) und nicht in die Ecken (Badges wie „New“ oder Spielerzahl). Welche Overlays an welcher Stelle liegen, ist **UNVERIFIED**. Einmal im Spiel prüfen, wie eine fremde Kachel aussieht.
8. **Kleinheitstest:** In Krita das Bild auf **320×180 und 160×90** verkleinern und neben 6 Screenshots echter Discover-Kacheln legen. Fragen: Erkennt man nach 1 s drei Figuren und ein „+“? Ist es das hellste und bunteste Bild der Reihe? Zusätzlich in Graustufen prüfen: Die Figuren müssen sich vom Grund abheben.
9. **Export:** 1920×1080 JPG mit Qualität 90 (Ziel unter 1,5 MB, erlaubt sind 5 MB). Dateiname `thumb_A_v01.jpg`. Die `.kra`-Quelldatei versionieren.
10. **Alternative für die Figuren:** Luis' Blender-Pipeline. Die Teile per Skript zum Hybriden zusammensetzen und in Eevee vor Grün oder transparent rendern (Film → Transparent). Die Render müssen aber **optisch dem Ingame-Look entsprechen** (Genauigkeitsregel). Deshalb Ingame-Screenshots bevorzugen.

---

## 3. Fünf TikTok/Shorts-Clips ohne Worte

Allgemein:
- 9:16 in 1080×1920, 30 oder 60 fps.
- Keine Stimme, keine erklärenden Texte. Erlaubt sind UI im Spiel, der Name eines Hybriden (den zeigt das Spiel) und am Ende eine Karte mit dem **Inselcode** für 1,5 s.
- Nur eigener Ton aus dem Spiel. Trend-Sounds der Plattform sind bei geschäftlicher Nutzung lizenzrechtlich heikel (ESTIMATED), und virale Brainrot-Audios haben dieselben IP-Risiken wie die Figuren.
- Nicht „an Kinder“ richten, keine Giveaways gegen Follows.
- Aufnahme: siehe Luis-Aufgaben, OBS. Schnitt: DaVinci Resolve (kostenlos) oder CapCut.
- Jeder Clip bekommt ein Loop-Ende: Der letzte Frame passt zum ersten.

| # | Titel (intern) | Länge | Hook in der 1. Sekunde | Shot-Liste |
|---|---|---|---|---|
| 1 | **„1 + 1 = ???“** | 8–10 s | Frame 0: zwei Kreaturen fliegen von links und rechts aufeinander zu, **Aufprall bei 0,6 s** mit weißem Blitz und Bass-Hit | 0,0–0,6 s Anflug (Nahaufnahme, Zeitlupe 50 %) · 0,6–1,2 s Blitz, Screen-Shake · 1,2–4 s Hybrid dreht sich langsam, Namens-Einblendung aus dem Spiel (Silben-Mix) plus TTS-Silbenruf · 4–7 s Hybrid macht seine Idle-Animation, schneller Zoom auf das Gesicht · 7–9 s Schnitt zurück auf zwei *neue* Kreaturen im Anflug (Loop, Neugier auf die nächste Fusion) · Endkarte mit Code |
| 2 | **„Fusion-Roulette“ (5 schnelle Fusionen)** | 12–15 s | Frame 0: schon mitten in Fusion 1, Blitz bei 0,3 s. Kein Vorlauf | 5 Fusionen à 2,5 s im Schnitt auf den Beat. Jede Fusion: 0,5 s Eltern, 0,5 s Blitz, 1,5 s Ergebnis mit Name. Steigerung von Common bis zur seltensten Fusion mit eigener Fanfare. Letzte Fusion länger (3 s) und mit Slow-Mo · Endkarte |
| 3 | **„Winzling gegen Boss“** | 15–20 s | Frame 0: Boss-Fuß stampft auf den Boden direkt vor der Kamera (Low Angle), Staub. Bei 0,8 s schwenkt die Kamera auf den *kleinen* Hybriden | 0–1 s Stampfen · 1–3 s Größenvergleich (Kamera fährt vom Hybriden am Boss hoch) · 3–12 s Kampf: Treffer-VFX, Schadenszahlen, Boss-HP-Leiste sinkt, zwei Beinahe-K.o.-Momente · 12–15 s Boss fällt, Hybrid posiert · 15–17 s Index-Eintrag „neu“ · Endkarte |
| 4 | **„Plot: Minute 1 vs. Stunde 1“** | 10–12 s | Frame 0: 0,4 s **fertiger, voller, leuchtender Plot** (das „Nachher“), dann harter Schnitt auf den leeren Plot | 0–0,4 s Nachher-Flash · 0,4–1,5 s leerer Plot, ein Ei · 1,5–9 s Zeitraffer über gleichen Kamerawinkel (Fixed-Point-Camera-Device oder Stativ-Kamera), Kreaturen erscheinen, Fusionen blitzen, Plot füllt sich · 9–11 s Endzustand mit langsamer Kamerafahrt · Endkarte. **Keine Geldzähler in Großaufnahme**, der Fokus liegt auf den Kreaturen |
| 5 | **„16 gegen 1: Server-Boss“** | 15–20 s | Frame 0: Boss-Brüllen mit Kamerawackeln, Boss-Namensbanner aus dem Spiel. Bei 0,5 s sieht man, dass viele Hybride aus allen Richtungen anstürmen | 0–1 s Brüllen · 1–5 s Luftaufnahme: viele Plots, Hybride strömen zur Mitte (dafür eine Aufnahme mit allen 4 Personen: Luis und 3 Tester, dazu im Soft Launch eine Aufnahme mit Bots oder Doppel-Clients, **nur echte Spielszenen**) · 5–14 s Massenkampf, Treffer-Feuerwerk · 14–17 s Boss explodiert in Konfetti-VFX · Endkarte |

**Post-Rhythmus:** Ab Tag 0 ein Clip pro Tag über 14 Tage. Das sind die 5 Grund-Clips plus je 1–2 Varianten (andere Kreaturen oder Musikschnitt). Posting-Zeit etwa **16–18 Uhr MEZ** (Europa nach der Schule, US-Mittag; ESTIMATED). Hashtags: `#fortnite #fortnitecreative #uefn #brainrot #fortnitemap`. Keine geschützten Figurennamen als Hashtag.

---

## 4. Launch-Plan

### 4.1 Zeitachse bis zum Public Release

| Datum | Meilenstein | Wer |
|---|---|---|
| bis So 15.11. | **Feature-Freeze** (Red Team). Danach nur Bugfixes, Balance und Winter-Inhalte | Luis + Claude Code |
| Mo 16.11. – So 22.11. | Blindtest mit den 3 Testern (Gate aus dem Bericht): Zeit bis zur ersten Fusion unter 3–5 min, ≥ 70 % Zweit-Fusion freiwillig, Median-Session über 20 min | Luis |
| Mo 23.11. | **Soft Launch Start:** privater Code mit ≤ 3 Freunden (siehe 4.2). Das Portal bietet dafür private Versionen oder Playtest-Gruppen an; Name und Obergrenze der Funktion sind **UNVERIFIED** | Luis |
| 28.11. oder 5.12. | **Chapter-8-Start (geleakt).** Neue UEFN-Version kann Neu-Validierung und einen neuen Upload erzwingen (ESTIMATED). Einen Tag nach dem Update: Projekt in der neuen UEFN-Version öffnen, Verse-Build prüfen und einen Smoke-Test spielen | Luis + Claude Code |
| Mo 30.11. – Mi 2.12. | Fixes aus dem Soft Launch; Metadaten, Thumbnails A/B/C, IARC und IIT-Angebote im Portal fertig | Luis + Claude Code |
| **Do 3.12.** | **Zur Review einreichen** (spätester Termin laut Bericht: 5.12.) | Luis |
| 4.–9.12. | Review. Bei Ablehnung: Grund beheben und am selben Tag neu einreichen | Luis |
| **Do 10.12., ca. 16:00 MEZ** | **Public Release.** Ob sich die Freigabe nach der Genehmigung manuell zurückhalten lässt, ist **UNVERIFIED**. Falls nicht: nicht früher als 7.12. einreichen, damit der Release nicht auf Chapter-8-Tage fällt. Spätester sinnvoller Release: 15.12. Kommt die Genehmigung später, trotzdem sofort veröffentlichen, denn die Ferien laufen bis ≈6.1. | Luis |

### 4.2 Soft Launch (23.11.–2.12.): messen → fixen

**Ziel:** Blocker vor dem Discover-Test finden. Drei Personen liefern **keine Statistik**, nur Bugs und grobe Signale (Red Team).

**Aufbau:**
- Private Version mit denselben Einstellungen wie das spätere Public-Build: 16 Max Players, IIT aktiv. IIT-Test mit „Grant All Products“ und „Force Remove Products“.
- **Analytics-Device-Events schon hier aktiv** (bis zu 50 pro Insel, Daten täglich im Portal-Dashboard, OFFICIAL/CLAIMED: [Analytics Device](https://www.fortnite.com/news/get-play-stats-with-the-analytics-device-for-fortnite-creative-and-uefn)). Pflicht-Events:
  1. `egg_first_hatch`
  2. `fuse_1`
  3. `fuse_2`
  4. `fuse_5`
  5. `wave_first_start`
  6. `wave_first_clear`
  7. `boss_join`
  8. `boss_kill`
  9. `rebirth_1`
  10. `index_10`
  11. `offer_dialog_open`
  12. `code_redeem`
  13. `session_min_10`
  14. `session_min_30`

  Ob die Events auch in privaten Versionen gezählt werden, ist **UNVERIFIED**. Deshalb zusätzlich Stoppuhr und Beobachtung.
- Jeder der 3 Freunde spielt auf einer **anderen Plattform**, idealerweise Konsole mit Controller, Handy mit Touch und Switch bzw. Low-End. Luis spielt auf dem PC.

**Messplan:**

| Tag | Was | Messung |
|---|---|---|
| Mo 23.11. | Erste Session, **ohne Erklärung**, Luis schaut per Discord-Stream zu | Stoppuhr: Laden → erstes Ei → erste Fusion → erste Welle → Boss. Wo stockt jemand? Wo wird gefragt? |
| Di 24.11. | **Kommt jemand von selbst zurück?** (D1-Proxy, nicht erinnern) | Ja/nein pro Person; ist der Spielstand intakt (Persistenz)? Wurde Offline-Einkommen korrekt gutgeschrieben (falls vorhanden)? |
| Mi 25.11. | Koop-Session mit allen 4 um 18 Uhr | Boss-Balance zu viert. Server-Performance (Timing Insights, Lags?) |
| Do 26.11. | Zeit-Unlock-Test: Systemdatum bzw. Test-Offset auf Winterfest, Woche 3 und Woche 8 stellen (Debug-Schalter nur in der privaten Version) | Schaltet jeder Event-Block zur richtigen Zeit frei und wieder ab? Werden Codes nur im gültigen Zeitraum angenommen? |
| Fr 27.11. | Kurzumfrage (Discord-Formular, 5 Fragen): Was war das Coolste? Was nervt? Welchen Hybriden hast du gezeigt? Würdest du morgen spielen? Hast du einen Kauf erwogen, und warum (nicht)? | Stichworte ins Bug- und Feedback-Board |
| Sa/So 28.–29.11. | Freies Spielen am Wochenende; Luis nimmt Rohmaterial für die Clips 1–5 auf | Session-Länge laut Analytics bzw. Selbstauskunft |
| Mo 30.11. – Mi 2.12. | Fixen, Einreichen vorbereiten | — |

**Go/No-Go für die Einreichung am 3.12.:**
- kein Blocker, kein Spielstand-Verlust, kein Absturz
- erste Fusion bei allen unter 5 min
- mindestens 2 von 3 Freunden sind am Tag 2 von selbst zurückgekommen
- der Controller- und Touch-Durchlauf ist komplett ohne Maus möglich

Ist ein Punkt rot, zuerst diesen Punkt beheben. Die Einreichung darf sich dafür bis 7.12. verschieben.

### 4.3 Die ersten 14 Tage, Tag für Tag

Legende: **CP** = Creator Portal (Analytics, Discover Performance, A/B), **API** = Ecosystem API (Tages-Pull durch Claude Code), **AD** = Analytics-Device-Events im CP. **CC** = lokales Claude Code. Die Portal-Daten kommen zeitversetzt, laut Analytics-Device-Doku täglich (CLAIMED). Frische Werte deshalb erst am Folgetag bewerten.

**Tägliche Routine von CC (≈10 min Kontingent):** Der Script `tools/kpi_pull.py` wird im Repo angelegt, die genauen Metrik-Pfade sind aus der [API-Doku](https://dev.epicgames.com/documentation/en-us/fortnite/using-fortnite-data-api-in-fortnite) zu prüfen.

```bash
# Muster aus dem Bericht; Intervall day/hour; 7 Tage Rückblick -> TÄGLICH archivieren
CODE=XXXX-XXXX-XXXX
FROM=$(date -u -d '7 days ago' +%Y-%m-%dT00:00:00Z)
curl -s "https://api.fortnite.com/ecosystem/v1/islands/$CODE/metrics/day?from=$FROM" \
  > "data/api/$(date +%F)_day.json"
curl -s "https://api.fortnite.com/ecosystem/v1/islands/$CODE/metrics/hour?from=$FROM" \
  > "data/api/$(date +%F)_hour.json"
```

Laut Doku liefert die API: Peak-CCU, Unique Players, Plays, Minutes Played, Minutes per Player, Favorites, Recommends, Retention D1 und D7 (CLAIMED/OFFICIAL, [Data API](https://www.fortnite.com/news/fortnite-data-api-unlocks-more-island-insights-for-creators)). **Die CTR liefert die API nicht**, die gibt es nur im CP. Luis trägt die CP-Werte (Impressions, CTR je Variante, Click→Play, IIT-Umsatz, AD-Funnel) täglich in `data/cp_daily.csv` ein, eine Zeile pro Tag und ≈3 min Aufwand. Daraus erstellt CC `reports/daily/YYYY-MM-DD.md` mit Ampel gegen die KPI-Tabelle aus Abschnitt 6.

| Tag | Datum | Build-Kalender (automatisch) | Luis | Claude Code (lokal) | Messen |
|---|---|---|---|---|---|
| **0** | Do 10.12. | Launch-Woche: Starter-Code `FUSE1` aktiv, „Fusion der Woche“ #1 | 16:00 Release freischalten, A/B-Test Runde 1 (A vs. B) **im Moment des Release** starten. Island-Code auf Discord, TikTok und YouTube posten, Clip 1 posten. 18–20 Uhr mit den 3 Freunden auf öffentlichem Server spielen (Seed-CCU, Stimmung). Bug-Channel beobachten | `kpi_pull.py` einrichten und erster Pull (Stundenwerte). Bug-Meldungen aus Discord in `bugs.md` sortieren (Blocker, Major, Minor) | API stündlich: CCU. CP: erste Impressions (vermutlich verzögert) |
| **1** | Fr 11.12. | Erstes Wochenend-Event „Doppel-Brut-Wochenende“ (kostenlos, für alle, keine Käufe) | Clip 2 posten. Bugs reproduzieren. **Entscheidung Hotfix 1** (nur Blocker und Major) | Hotfix-Patches in Verse vorbereiten und gegen den Digest bauen; Changelog-Text für Discord | CP: Impressions, CTR A/B, Plays. AD: Funnel `egg_first_hatch` → `fuse_1` → `fuse_2` (Drop-off?) |
| **2** | Sa 12.12. | Wochenend-Event | **Hotfix 1 einreichen**, falls nötig (Review-Dauer unbekannt). Clip 3. 30 min öffentlich mitspielen und beobachten | Tagesbericht: erster D1-Wert der Kohorte vom Tag 0 | **D1 (Kohorte Tag 0)**, Ø-Minuten pro Spieler, CTR je Variante |
| **3** | So 13.12. | Wochenend-Event, Ende 23:59 UTC | Clip 4. Discord: erste „Zeig deinen Hybriden“-Galerie | Balancing-Analyse aus AD: Wo brechen Spieler ab (Welle X, Boss)? Vorschlag für Werte-Anpassung (nur Daten-Tabelle) | D1 Tag 1, Peak-CCU Wochenende, Click→Play |
| **4** | Mo 14.12. | Normalbetrieb | **Zwischenbilanz Tag 4:** KPI-Ampel. Bei Rot → Maßnahmen aus Abschnitt 6. Clip 5 | KPI-Ampel-Bericht, Abweichungen erklären (Plattform-Split aus CP falls vorhanden) | Alle KPIs, 4-Tage-Trend |
| **5** | Di 15.12. | Normalbetrieb | A/B Runde 1 auswerten (Regel 2.4), sonst weiterlaufen lassen bis Mi. Clip-Variante 1b | Thumbnail-Log aktualisieren; ggf. Hotfix 2 vorbereiten (Balancing aus Tag 3) | CTR A vs. B, Impressions je Variante |
| **6** | Mi 16.12. | Letzter Tag Woche 1 | **Hotfix 2 einreichen** (letzte Chance vor Winterfest und Feiertagen). A/B Runde 1 beenden → G1. **Variante C** vorbereiten bzw. hochladen | Hotfix-2-Build prüfen: Zeit-Unlocks für Woche 2–8 ein letztes Mal im Test-Offset | D7 ist noch nicht verfügbar. D1-Trend über die Kohorten Tag 0–4 |
| **7** | Do 17.12. | **Winterfest-Block:** Frost-Ei, Winter-Accessoires, Winter-Boss-Skin, Code `FROST26` | A/B Runde 2 starten (G1 vs. C). Discord-Ankündigung, Clip „Frost-Fusion“ (Variante von Clip 1 mit Winter-Kreatur) | Kontrolle nach dem Unlock (00:00 UTC): Ist das Event wirklich live? Code-Test mit Luis' Account | **D7 (Kohorte Tag 0)** ab Tag 7/8. CCU-Sprung durch Winterfest? |
| **8** | Fr 18.12. | Winter-Wochenend-Event (kostenlos) | Clip 2b (Winter-Roulette). Discord-Event „Boss-Abend“ Fr 19 Uhr MEZ: alle auf einen Server (Party-Joins) | Tagesbericht mit D7 | D7, Ø-Spielzeit, Favoriten und Recommends |
| **9** | Sa 19.12. | Winter-Wochenende, **Ferienbeginn in vielen Ländern (ESTIMATED)** | Mitspielen zur Stoßzeit, Clip 3b. Moderation im Discord | Beobachtung CCU stündlich (Stoßzeiten nach Region für den Posting-Plan) | Peak-CCU, Stunden-Kurve |
| **10** | So 20.12. | Winter-Wochenende | Ruhetag (nur Discord-Blick 2× täglich) | Wochenbericht Woche 1+ (Tag 0–10): KPI gegen Schwellen, Empfehlung | Alle KPIs |
| **11** | Mo 21.12. | Normalbetrieb Winter | Entscheidung auf Basis des Wochenberichts (Abschnitt 6). Bei Bedarf Titel-Wechsel an **derselben** Insel vorbereiten (nur Metadaten) | Metadaten-Varianten vorbereiten, falls CTR rot | CTR gegen Retention: Welches Problem dominiert? |
| **12** | Di 22.12. | Normalbetrieb Winter | Clip „Best of Community-Hybride“ (nur mit Erlaubnis der Spieler, Namen im Spiel ausblenden) | Code-Liste Woche 3 im Discord-Entwurf vorbereiten | Discover-Test läuft aus (≈Tag 14) |
| **13** | Mi 23.12. | Letzter Tag vor dem Weihnachtsblock | **Bilanz des Discover-Testfensters:** weiter wie geplant, nachsteuern oder Abbruch-Modus (Abschnitt 6). Ab jetzt keine Publishes bis ≈5.1. | Abschlussbericht Tag 0–13 inkl. Kohorten-Tabelle, A/B-Log, Top-5-Bugs, Empfehlung für das Januar-Update | Alle KPIs, Retentionskurve Kohorten |

---

## 5. Update-Plan: die ersten 8 Updates auf dem zeitgesteuerten Kalender

**Grundsatz:** Die 8 „Updates“ sind **Content-Freischaltungen aus dem Release-Build**, jeweils donnerstags 00:00 UTC (≈ 01:00 MEZ). Echte Publishes gibt es nur für Hotfixes, Balance und als Rückfall, falls die Zeit-API fehlt. Jede Woche folgt demselben Muster: neuer Inhalt am Donnerstag, kostenloses Wochenend-Event Fr–So, 2 Codes (Do und Sa).

**Technische Voraussetzung (Gate aus dem Bericht):** eine verlässliche serverseitige Wanduhr-Zeit in Verse, **UNVERIFIED**. Luis bzw. CC prüft das in Woche 1 der Entwicklung im Digest.
- **Fall A (Zeit-API vorhanden):** Alle Codes und Unlocks liegen als Datentabelle `live_calendar.verse` im Build, mit Start und Ende in UTC. Es sind keine Publishes nötig.
- **Fall B (keine Zeit-API):** Jeder Wochen-Block braucht einen kleinen Publish, der ein Flag umschaltet, also **8 Publishes**. Die Publishes über die Feiertage (Woche 2–4) müssen dann **schon vor dem 17.12.** eingereicht sein. Das ist realistisch nicht sicher planbar (ESTIMATED). In Fall B deshalb den Winter-Block schon im Launch-Build **von Tag 0 an** aktiv lassen und im Januar per Publish umschalten.

| Update | Zeitraum | Inhalt (vorproduziert) | Codes (vorab gebacken, Beispiele) | Thumbnail/Metadaten | Publish nötig? |
|---|---|---|---|---|---|
| **U1 Launch** | Do 10.12. – Mi 16.12. | 8 Grundarten; Fusion der Woche #1 (Bonus-Index-Eintrag); Wochenend-Event „Doppel-Brut“ | `FUSE1` (Launch), `HYBRID` (Sa 12.12.) | A/B Runde 1 | **Ja, bis zu 2 Hotfixes** (12.12. und 16.12.) |
| **U2 Winterfest** | Do 17.12. – Mi 23.12. | Frost-Ei (neue Event-Art, 3 Teile = Kopf, Körper, Accessoire), Winter-Accessoires für alle Arten, Winter-Skin des Server-Bosses, Schnee-Deko auf den Plots | `FROST26`, `SNOWFUSE` | A/B Runde 2 (G1 vs. C) | Nein |
| **U3 Weihnachten** | Do 24.12. – Mi 30.12. | „Geschenk-Wellen“ (Wellenmodus mit Geschenk-Gegnern, kostenlose Belohnungen **nur durchs Spielen**), Login-Geschenk am 24.–26.12. | `GIFTROT`, `CANDY` | wie U2 | Nein |
| **U4 Silvester** | Do 31.12. – Mi 6.1. | „Feuerwerks-Boss“ (Boss-Variante mit Feuerwerk-VFX), Countdown-Event am 31.12. um 23:00 UTC (1 h, Boss mit doppelten Leben für alle Server) | `NEWYEAR27`, `BOOM` | C bis Di 5.1., dann raus | Nein. Plan: Mi 6.1. Winter-Assets per Zeit-Flag aus |
| **U5 Januar-Ei** | Do 7.1. – Mi 13.1. | Neue Art „Januar-Ei“ (3 Teile) als erste dauerhafte Erweiterung des Index; Winter-Ei nicht mehr erhältlich (bereits geschlüpfte Kreaturen bleiben!) | `JANEGG`, `FUSE2027` | A/B Runde 3 (G1 vs. D) | **Optional:** 1 Balance-Publish nach der Feiertagsauswertung (einreichen Mo 4.1.) |
| **U6 Boss-Rush** | Do 14.1. – Mi 20.1. | Boss-Rush-Modus: 3 Bosse hintereinander, Server-Bestenliste pro Session; neuer Titel-Rahmen (Kosmetik) fürs Plot-Schild | `RUSH`, `BIGBOSS` | Runde 3 läuft | Nein |
| **U7 Index-Jagd** | Do 21.1. – Mi 27.1. | „Geheime Fusionen“: 10 versteckte Kombinationen mit Hinweisen (eine pro Tag bis Wochenende, Hinweistext im Spiel), Index-Rahmen für 25/50/75 % | `SECRET1`, `HINTS` | Runde 3 → G2 | Nein |
| **U8 Finale** | Do 28.1. – Mi 3.2. | Rebirth-Stufe erweitert, „Hall of Fusions“ (Lobby-Statue mit dem Server-Top-Hybriden), Abschluss-Event-Wochenende | `FINALE`, `THANKS` | Runde 4 (G2 vs. E) | **Ja, das Folge-Update** (siehe unten) |

**Joker-Codes:** 4 zusätzliche Codes sind ab Tag 0 gültig, werden aber geheim gehalten (zum Beispiel `JOKER-A`–`D`, echte Codes sechsstellig und nicht erratbar). Luis gibt sie bei Meilensteinen im Discord und auf TikTok frei, etwa bei 1.000 Favoriten, 100 Discord-Mitgliedern oder zu Weihnachten. So entstehen „Live“-Momente ohne Publish. **Code-Belohnungen:** nur Spielinhalte (Eier, Kosmetik, Brut-Beschleuniger). Nie etwas, das es auch gegen V-Bucks gibt, damit keine Verwechslung mit IIT entsteht (ESTIMATED).

**Kleine Publishes, die trotzdem nötig sind:**

| Anlass | Wann | Umfang |
|---|---|---|
| Hotfix 1 | Sa 12.12. einreichen | nur Blocker und Major |
| Hotfix 2 / Balance | Mi 16.12. einreichen | Balancing aus dem Launch-Funnel. **Letzter Publish vor den Feiertagen** |
| Balance Januar (optional) | Mo 4.1. einreichen | Werte-Tabellen, keine Schema-Änderung |
| **Folge-Update (U9)** | Einreichen **Mo 25.1.**, Live bis ≈ Do 4.2. | Das Ende des vorproduzierten Kalenders ist ein Klippen-Risiko (Bericht, Phase C). Inhalt: 1 neue Art, 8 neue Wochen-Kalender (Kalender-Daten reichen, falls Fall A). **Vor dem 1.2.**, weil der IIT-Anteil danach auf 50 % sinkt, damit IIT-Neuheiten noch vom vollen Satz profitieren |
| Codes, falls **nicht** vorgebacken | wöchentlich Mo einreichen | Nur dann nötig. Dringend vermeiden: Vorbacken ist Pflicht-Design |

**Schema-Regel für alle Publishes:** Die Persistenz-Felder niemals entfernen oder umbenennen, nur mit Defaults ergänzen (Bericht E1).

---

## 6. KPIs und Abbruchschwellen

Benchmarks: Genre Simulation & Tycoon mit **Median D1 12–13 %, D7 4–5 %** und **P90 D1 24–26 %, D7 13–19 %**; Steal the Brainrot **D1 9,87 %, D7 3,28 %, 66,7 min** (fortnite.gg-Snippets); Fight The Brainrot 85 min, Grow The Brainrot 158 min Ø-Spielzeit. Für die CTR gibt es **keinen belegten Benchmark**. Die Werte unten sind ESTIMATED und werden nach Runde 1 des A/B-Tests an der eigenen Basis kalibriert.

**Messzeitraum:** Discover-Testfenster Tag 0–14; bewertet werden jeweils die Werte der Vortage (Kohorten).

| KPI | Quelle | Ziel | Stretch (Top 10 %) | Warnung | Abbruch/Umbau |
|---|---|---|---|---|---|
| **CTR** (Impressions → Klick) | CP | ≥ 5 % (ESTIMATED) | ≥ 8 % | < 3,5 % über 3 Tage | < 2 % nach beiden A/B-Runden |
| **Click → Play** (Plays ÷ Klicks) | CP | ≥ 60 % (ESTIMATED) | ≥ 75 % | < 45 % | < 30 % |
| **Ø-Spielzeit pro Spieler** (Minutes per Player) | API + CP | ≥ 45 min | ≥ 66,7 min (Steal-Niveau) | < 30 min | **< 20 min** (Red-Team-Kill) |
| **D1** | API + CP | ≥ 13 % (über dem Genre-Median) | ≥ 24 % | < 12 % (unter Median) | **< 8 %** (Red-Team-Kill) |
| **D7** | API + CP | ≥ 5 % | ≥ 13 % | < 4 % | < 2,5 % |
| **Peak-CCU** (Tag 0–14) | API | ≥ 500 bis Tag 14 (ESTIMATED; die realistische Spannweite für Neueinsteiger ist 5–50K Peak nur mit klarem Hook) | ≥ 5.000 (Schwelle „stark“ der Lückenanalyse) | < 100 an Tag 7 | < 50 an Tag 14 bei gleichzeitig roten Retention-Werten |
| Funnel `fuse_1` (AD) | CP | ≥ 80 % der Spieler | ≥ 90 % | < 65 % | — |
| Funnel `fuse_2` ÷ `fuse_1` (AD) | CP | ≥ 70 % (Red-Team-Ziel) | ≥ 85 % | < 55 % | — |
| IIT-Konversion (Käufer ÷ Unique Players) | CP | ≥ 1 % (ESTIMATED) | ≥ 3 % | < 0,3 % | — (kein Abbruchgrund, aber Signal) |

**Diagnose- und Maßnahmen-Matrix:**

| Verfehlter KPI | Wahrscheinliche Ursache | Konkrete Maßnahme | Wer / bis wann |
|---|---|---|---|
| **CTR** Warnung | Thumbnail unklar klein, Titel generisch, Motiv verwechselbar | (1) A/B-Runde vorziehen: Gewinner gegen eine Variante mit **größerem Hybriden und weniger Elementen** (nur 1 Figur und Blitz). (2) Kleinheitstest wiederholen. (3) Titel-Alternative vorbereiten (nur Metadaten, gleiche Insel) | Luis Krita 2 h; CC: Variantenliste. Innerhalb von 48 h |
| **CTR** Abbruch | Branding erreicht niemanden | Titel und Thumbnail auf die zweite Stufe umbauen: „BRAINROT FUSION LAB“ oder eine Richtung aus dem GDD. Ein Wechsel zu „Creature-Fusion“ ohne „Brainrot“ nur, wenn die Brainrot-Maps insgesamt eingebrochen sind (Bericht A3) | Luis. Vor Tag 14 |
| **Click → Play** Warnung | Ladezeit, Matchmaking, Einstieg verwirrt oder Thumbnail verspricht etwas anderes (Bounce) | (1) Prüfen, ob Thumbnail B (Boss) Erwartungen weckt, die der Einstieg nicht erfüllt. Dann A bevorzugen. (2) Die ersten 30 s: Ei sofort in der Hand, kein Menü vorab. (3) Speicher und Ladezeit prüfen (Launch Memory Calculation) | CC: Einstiegs-Patch vorbereiten. Hotfix-Fenster nutzen |
| **Ø-Spielzeit** Warnung | Zu wenig Ziele nach der ersten Fusion, Welle 1 zu schwer oder zu leicht | (1) AD-Funnel: Wo endet die Session? (2) Balancing-Tabelle anpassen: Brutzeiten in Minute 5–20 verkürzen, erste Welle leichter, Boss früher sichtbar. (3) Mit „Fusion der Woche“ ein klares nächstes Ziel im HUD zeigen | CC Balancing, Luis Test. Hotfix 2 (16.12.) |
| **Ø-Spielzeit** Abbruch (< 20 min) | Kern trägt nicht | **Abbruch-Modus:** keine neuen Inhalte mehr bauen. Metadaten-Umbau (siehe CTR-Abbruch) und nur noch minimal pflegen. Zeit in Fish- oder Fight-Hybrid-Rückfallkonzept als **neues** eigenständiges Spiel stecken (kein Duplikat) | Luis entscheidet Tag 13 |
| **D1** Warnung | Kein Grund zur Rückkehr | (1) Brutzeit-Hook: Ein Ei, das „morgen“ schlüpft, wird am Sessionende sichtbar angeboten (Voraussetzung Zeit-API). (2) Joker-Code am Folgetag im Discord. (3) Sessionende zeigt das nächste Index-Ziel | CC: Patch für Hotfix 2 bzw. Januar |
| **D1** Abbruch (< 8 %) | wie oben, strukturell | Abbruch-Modus wie oben | Luis Tag 13 |
| **D7** Warnung | Content-Wand nach 3–5 Tagen, Grind zu steil | Rebirth-Kosten −20 %, Index-Zwischenbelohnungen bei 10/25/50 %; U5-Inhalt (Januar-Ei) ist ohnehin fest eingeplant, eventuell per Balance-Publish am 4.1. früher freischalten | CC Balancing-Tabelle |
| **D7** Abbruch | Genre-untypisch schlecht | Keine neuen Inhalte über U8 hinaus. U9 fällt aus, der Kalender läuft aus | Luis |
| **Peak-CCU** Warnung bei guter Retention | Reichweiten-Problem, keine Qualitätsfrage | (1) CTR-Maßnahmen. (2) Clip-Frequenz auf 2 pro Tag erhöhen, die 2 besten Clips (Aufrufe pro Stunde) variieren. (3) Cross-Promo (Abschnitt 7). (4) Sponsored Row **nicht** nutzen: Unter 18-Jährige sehen sie nicht, und die Zielgruppe ist überwiegend jung | Luis |
| **Peak-CCU** Warnung bei schlechter Retention | Qualität | Zuerst Retention reparieren, keine Reichweite einkaufen | — |
| **fuse_2 ÷ fuse_1** Warnung | Fusion fühlt sich nicht lohnend an | Reveal verlängern (Fanfare, Name-Ruf), Hybrid sichtbar stärker in Welle 1, „Neuer Index-Eintrag!“-Feedback | CC UMG-Animation, Hotfix |
| **IIT-Konversion** Warnung | Angebot nicht sichtbar oder nicht attraktiv | Angebote an natürlichen Punkten zeigen (Plot voll → Brutplatz). **Kein Druck, keine Countdown-Angebote** (Verbot von Kaufdruck auf Minderjährige). Preise nicht senken, bevor die Retention stimmt | Luis |

**Entscheidungstermine:** Tag 4 (14.12., Zwischenbilanz), Tag 10/11 (20.–21.12., Wochenbericht), **Tag 13 (23.12., Testfenster-Bilanz: weiter, nachsteuern oder Abbruch-Modus)**, 6.1. (Feiertagsbilanz), 25.1. (U9 ja oder nein).

---

## 7. Social und Community

### 7.1 Discord-Setup (vor dem 23.11. fertig)

- **Server-Name:** „FUSE THE BRAINROT | haske“. Server-Icon ist der Hybrid aus Thumbnail A.
- **Kanäle:**
  - `#regeln`: Regelwerk, Discords Mindestalter 13 nennen, kein Handel mit Accounts, keine V-Bucks-Giveaways
  - `#ankündigungen`: nur Luis
  - `#codes`: nur Luis, die zwei Wochen-Codes plus Joker
  - `#patchnotes`
  - `#bug-melden`: Forum-Kanal mit Vorlage (Plattform, was passiert, erwartet, Screenshot oder Clip, Uhrzeit UTC)
  - `#feedback-ideen` (Forum)
  - `#zeig-deinen-hybriden`: Bilder, Slowmode 60 s
  - `#boss-teams`: Mitspieler suchen
  - `#clips`
  - `#allgemein`
- **Rollen:** `Tester` (die 3 Freunde), `Spieler` (per Onboarding), optional selbst wählbar `Boss-Abend-Ping`.
- **Moderation (Luis ist allein):**
  - Discord-AutoMod mit Keyword-Filter: Beleidigungen, Links, „free vbucks“, Scam-Muster
  - Verifizierungsstufe „Mittel“
  - Direktnachrichten von Servermitgliedern standardmäßig aus (Serverinstellung)
  - Keine Altersabfrage, keine persönlichen Daten sammeln
- **Rhythmus:**
  - Do 01:00 MEZ (Unlock): automatisch geplante Ankündigung mit Discords Nachrichtenplanung oder Bot, sonst Luis am Morgen
  - Sa: zweiter Code
  - Fr 19 Uhr: „Boss-Abend“ als Discord-Event
- **Einladungslink** in TikTok- und YouTube-Bio und auf dem Creator-Profil, falls dort verlinkbar (**UNVERIFIED**). **Nicht in der Insel**, weil externe Links bzw. Handlungsaufforderungen in der Insel **UNVERIFIED** sind. Nur den Creator-Namen zeigen.

### 7.2 Creator-Code (Support-A-Creator)

- **Voraussetzungen (CLAIMED, [gemlist.io](https://www.gemlist.io/blog/fortnite-creator-code-requirements), [Generalist Programmer](https://generalistprogrammer.com/tutorials/fortnite-creative-monetization-complete-revenue-guide); offiziell: [SAC-Programm](https://www.fortnite.com/fortnite/en-US/creative/docs/joining-the-support-a-creator-program), [SAC Terms](https://legal.epicgames.com/fortnite/eula/sac)):**
  - etwa **1.000 Follower auf *einer* Plattform** (YouTube, TikTok, Twitch, X …), echte Follower
  - 18+, Epic-Konto in gutem Stand mit 2FA
  - Auszahlungs- und Steuerdaten
  - manuelle Prüfung, 3–7 Werktage
- **Heißt für Luis:** „haske“ ist zum Launch wahrscheinlich **noch kein** SAC-Code, sondern nur der Creator-Name. Den SAC-Antrag stellen, sobald TikTok oder YouTube 1.000 Follower hat. Das ist realistisch erst im Testfenster oder danach.
- **Regeln:** Keine Ingame-Belohnung für die Nutzung des Codes und kein „Use code haske“ im Thumbnail oder Titel. SAC-Missbrauch und Clickbait sind verboten ([Developer Rules](https://legal.epicgames.com/fortnite/developer-rules)). Den Code erlaubt nur in Social-Bios und am Ende von Videos erwähnen: „Creator Code: haske“ als Text. Kein Druck, keine Ansprache von Kindern.

### 7.3 Cross-Promo

- **Mit kleinen Creators ähnlicher Größe**, nicht mit direkten Konkurrenten: zum Beispiel Tycoon-, Parkour- oder Party-Maps mit 100–2.000 CCU. Tausch: gegenseitiger Discord-Post und je ein Clip-Duett oder Stitch auf TikTok.
- **Creator-Discords** mit Promo-Kanälen (CLAIMED, [Overwolf-Guide](https://blog.overwolf.com/the-ultimate-guide-to-promoting-your-fortnite-uefn-map-in-2024/)). Vor jedem Post die Server-Regeln lesen.
- **Ingame-Portal:** Ein Link bzw. Matchmaking-Portal in der Lobby zu einer Partner-Insel ist technisch möglich. Die Regelkonformität für Cross-Promo-Portale ist **UNVERIFIED** (Developer Rules lesen). Nur einsetzen, wenn das zweifelsfrei erlaubt ist, und frühestens mit U5 (Balance-Publish).
- **Reddit:** r/FortniteCreative, nur nach den Self-Promo-Regeln des Subs. Ein Post zum Launch mit Clip 1 und ein „Dev-Log“-Post zum Winter-Update.
- **Content-Creator (YouTube, Code-Artikel):** Presse-Kit (1 Seite: Code, 3 Screenshots, Clip-Link, aktuelle Codes) an Seiten schicken, die „Fortnite <Map> codes“-Artikel schreiben: thespike.gg, Beebom, Destructoid, GameRant. Timing: Tag 3 und Tag 8.
- **Nicht tun:** Sponsored Row im Testfenster (U18 sieht sie nicht), Follow-for-Code-Aktionen, bezahlte Bots oder Fake-Spieler (Kontorisiko), Duplikat-Inseln (1.9.1).

---

## 8. Luis-Aufgaben (Checkliste)

### 8.1 Konto, Programm, Monetarisierung (bis 31.10.)
- [ ] Epic-Konto: **2FA** an; Creator-Profil „haske“ mit Bild, Kurzbio und Social-Links ausfüllen.
- [ ] **Fortnite Developer Program** beitreten ([Enroll](https://create.fortnite.com/enroll)): 18+, dazu ein qualifizierender Epic-Payments-Kauf **oder** mindestens 20 $ Ausgaben in Fortnite in den letzten 365 Tagen (OFFICIAL/snippet). Steuer- und Auszahlungsdaten hinterlegen.
- [ ] **IIT-Berechtigung** im Portal prüfen (Owner 18+ und im Developer Program). IIT-Regeltext 4.4.x und die [Monetization Guidelines](https://dev.epicgames.com/documentation/fortnite/guidelines-for-in-island-monetization-in-fortnite) vollständig lesen.
- [ ] Angebote anlegen, nur deterministisch:
  - permanenter Einkommens-Multiplikator (Gameplay-Vorteil → **offenlegen nach 4.4.12**, `ConsequentialToGameplay` = true)
  - zusätzlicher Brutplatz (ebenso)
  - Plot-Theme (kosmetisch)
  - eine *bestimmte* benannte Kreatur (ebenso Vorteil, wenn sie stärker ist)
- [ ] **Nicht verkaufen:** Eier, Zufallsinhalte, Ingame-Währung (sie kauft Eier, das wäre indirekter Zufall; Einstufung **UNVERIFIED**, deshalb meiden), Glücks-Boosts, Wochenend-Event-Zugänge, Outfits, Emotes. Keine zeitlich begrenzten Kaufangebote.
- [ ] Preise unter der zulässigen Obergrenze (Angebote über 5.000 V-Bucks sind laut Bericht unzulässig).
- [ ] Im Private Playtest „Grant All Products“ und „Force Remove Products“ testen; prüfen, dass Käufe nach einem Rejoin da sind (`GetPurchasedEntitlements`-Abgleich).

### 8.2 IARC-Fragebogen (beim Einreichen, 3.12.)

Wahrheitsgemäß antworten. Der Fragebogen muss alle Inhalte abdecken, inklusive Musik mit Text (OFFICIAL, [IARC FAQ](https://dev.epicgames.com/documentation/fortnite/iarc-overview-and-faqs-in-fortnite-creative?lang=en-US)). Die genauen Fragen können abweichen. Empfohlene Antworten für den geplanten Inhalt:

| Bereich | Antwort | Begründung |
|---|---|---|
| Gewalt | **Ja: Fantasy- bzw. Cartoon-Gewalt**, nicht realistisch, kein Blut, keine Menschen als Opfer | Hybride kämpfen gegen Wellen und Bosse, Treffer-VFX, Kreaturen „fallen um“ oder verpuffen |
| Blut/Gore | Nein | — |
| Angst/Horror | Nein bzw. höchstens „mild“, falls der Boss erschreckend inszeniert wird | Ehrlich nach dem finalen Boss-Design entscheiden |
| Sprache/Schimpfwörter | Nein | **Namensgenerator vorher gegen eine Schimpfwort- und Sperrliste in allen großen Sprachen laufen lassen** (Silben-Mix kann versehentlich Wörter bilden) |
| Crude Humor | Ja, mild, falls Kreaturen albern oder „furzig“ sind; sonst nein | Brainrot-Stil |
| Sexuelle Inhalte, Nacktheit | Nein | — |
| Drogen, Alkohol, Tabak | Nein | Kreaturen-Designs ohne Zigarette, Flasche o. Ä. (Kaffee ist okay) |
| Glücksspiel (simuliert oder echt) | **Nein** zu Casino- bzw. echtem Glücksspiel. Eier mit zufälligem Inhalt gibt es **nur gegen verdiente Ingame-Währung, nie gegen Geld** | Falls der Fragebogen „Zufallsbelohnungen“ getrennt abfragt: wahrheitsgemäß angeben, dass es kostenlose Zufallsbelohnungen gibt, aber keine bezahlten |
| **Digital Purchases / In-Game-Käufe** | **Ja** (Pflicht bei IIT, OFFICIAL, [IIT Overview](https://dev.epicgames.com/documentation/fortnite/in-island-transactions-overview-in-fortnite?lang=en-US)). **Ohne** „random items“ | Nur deterministische Angebote |
| Nutzerinteraktion / Chat | So angeben, wie Fortnite es für Inseln vorgibt. Eigene Textfelder gibt es nicht | Keine eigenen Chat- oder Freitextfunktionen bauen |
| Standortdaten, persönliche Daten | Nein | — |
| Musik mit Text | Nein, falls nur instrumentale Musik und TTS-Silbenrufe (ohne Liedtext) verwendet werden, sonst Ja | TTS-Rufe sind Kreaturnamen, kein Liedtext. Im Zweifel ehrlich „Ja“ |

### 8.3 Creator Portal: manuelle Klicks
- [ ] Projekt verknüpfen, **Island-Einstellungen:** Max Players 16, Join in Progress an, Matchmaking-Einstellungen passend zu 16 Plots.
- [ ] **Metadaten** eintragen: Titel, 3 Beschreibungszeilen, How to Play, **4 Tags**, Zeichenlimits am Zähler prüfen. Deutsche Lokalisierung, falls möglich.
- [ ] **Thumbnail A** als Hauptbild hochladen, **B** für den Test, **C** vorab (Winter).
- [ ] **A/B-Test** Runde 1 vorbereiten, Start zum Release.
- [ ] **Private Version bzw. Playtest-Gruppe** anlegen, die 3 Freunde hinzufügen (23.11.).
- [ ] **IARC** ausfüllen (siehe 8.2).
- [ ] **IIT-Angebote** prüfen, Offenlegungstexte bei Gameplay-Vorteil.
- [ ] Zur **Review einreichen** am Do 3.12. Release-Termin 10.12., 16:00 MEZ, ggf. manuell freigeben.
- [ ] **Analytics-Dashboard** einrichten (AD-Events aus 4.2) und die Discover-Performance-Ansicht als Lesezeichen speichern.
- [ ] Während des Tests täglich 3 min: CP-Werte in `data/cp_daily.csv` eintragen.

### 8.4 Regeln und Recht (einmalig, November)
- [ ] Developer Rules 1.x, 3.x, 4.4.x plus Change Log nach 29.04.2026 und die [Thumbnail Image Policies](https://dev.epicgames.com/documentation/fortnite/thumbnail-image-policies?lang=en-US) **vollständig** lesen. Dabei prüfen: Cross-Promo-Portale, Hinweise auf Discord in der Insel, Code-Keypads.
- [ ] Namensgenerator-Ausgabe gegen die Sperrliste prüfen; Stichprobe in USPTO und EUIPO.
- [ ] Prüfen, ob der Titel „FUSE THE BRAINROT“ auf fortnite.gg schon existiert.
- [ ] Chapter-8- und Winterfest-Daten bestätigen (Mitte November).
- [ ] Schriftlizenzen (OFL) und TTS-Lizenz ablegen.

### 8.5 Aufnahme mit OBS (für Clips und Thumbnails)
- [ ] OBS Studio (kostenlos). Einstellungen: **Canvas 2560×1440 oder 1920×1080 bei 60 fps**; Encoder NVENC (NVIDIA) oder x264. Rate Control **CQP 18** bzw. CRF 18. Format **MKV** (übersteht Abstürze), danach „Remux“ zu MP4.
- [ ] Quelle „Spielaufnahme“ auf Fortnite bzw. die UEFN-Session. Ton: Spielton auf Spur 1, **Mikrofon aus** (Clips ohne Worte).
- [ ] **Hochkant:** Lieber im Querformat aufnehmen und in DaVinci Resolve oder CapCut auf 9:16 zuschneiden; Motiv beim Aufnehmen mittig halten. Alternative: zweite OBS-Szene mit vertikaler Leinwand 1080×1920 (Plugin „Aitum Vertical“, kostenlos; **UNVERIFIED**, ob es mit der aktuellen OBS-Version läuft).
- [ ] HUD für saubere Shots ausblenden bzw. reduzieren (Fortnite-HUD-Einstellungen). Für Kamerafahrten in UEFN eine Aufnahme-Kamera (Fixed-Point-Camera-Device oder Sequencer) im **privaten** Build.
- [ ] Rohmaterial-Liste: 20× Fusion (verschiedene Arten, inklusive der seltensten), 5× Boss-Kill, 3× Zeitraffer-Plot (60 min, gleicher Winkel), 2× Server-Boss mit 4 Spielern, Winter-Varianten nach dem Test-Offset.
- [ ] Dateinamen: `clip_<nr>_<motiv>_<datum>.mkv`.

### 8.6 Social-Konten (bis 22.11.)
- [ ] TikTok- und YouTube-Konto „haske“ (Luis ist 18+), Bio mit Island-Code-Platzhalter und Discord-Link.
- [ ] 3 Teaser-Clips vor dem Launch (Kreaturen-Reveal ohne Code, „coming 10.12.“ als Datum im Bild), um bis zum Launch erste Follower zu haben.
- [ ] SAC-Antrag, sobald eine Plattform 1.000 Follower hat.
- [ ] Discord-Server nach 7.1 aufsetzen, die 3 Tester als `Tester`.

---

## 9. Offene Punkte und Validierung (Zusammenfassung)

| Punkt | Status | Wer prüft wann |
|---|---|---|
| Zeichenlimits für Titel, Beschreibung und How to Play | UNVERIFIED | Luis im Portal, November |
| Tag-Namen in der Portal-Liste | UNVERIFIED | Luis, November |
| Private Version bzw. Playtest-Gruppe (Name, Limit, Analytics) | UNVERIFIED | Luis, vor 23.11. |
| Release nach Genehmigung manuell zurückhalten | UNVERIFIED | Luis beim Einreichen |
| Löst ein Thumbnail-Wechsel eine Review aus? | UNVERIFIED | Luis (Portal-Hinweis) |
| Verse-Wanduhr-Zeit für Unlocks und Codes | UNVERIFIED (kritisch) | CC im Digest, Entwicklungswoche 1 |
| Review-Dauer über die Feiertage | UNVERIFIED | Einplanung: keine Publishes 18.12.–4.1. |
| CTR- und Click→Play-Benchmarks | kein Beleg, ESTIMATED | nach A/B-Runde 1 kalibrieren |
| Top-10-Brainrot-Thumbnails visuell | nicht gesehen | Luis Screenshot (R0-1) |
| Regeln zu Cross-Promo-Portalen, Discord-Hinweisen und Code-Keypads | UNVERIFIED | Luis liest die Rules im November |

---

### Quellen der Websuchen vom 29.09.2026 (zusätzlich zu den Notizen)
- [Thumbnail Image Policies (Epic)](https://dev.epicgames.com/documentation/fortnite/thumbnail-image-policies?lang=en-US): 1920×1080, 16:9, ≤ 5 MB
- [Game Details Screen (Epic)](https://dev.epicgames.com/documentation/fortnite/game-details-screen-in-fortnite?lang=en-US): Titel, Beschreibung, Tags, How to Play
- [Discover: Island Thumbnail Update (UE-Forum)](https://forums.unrealengine.com/t/discover-island-thumbnail-update/1199156): keine Pfeile, Plattform-Buttons, Waffen in Quadraten, Währungsbezüge, Preisschild-Namen
- [FNCreate auf X](https://x.com/FNCreate/status/1944789163640803745): Thumbnail als Standard-Ladebildschirm
- [Fandom: Creative Island Settings](https://fortnite.fandom.com/wiki/Creative_Island_Settings): 80 Zeichen Beschreibung
- [1of10](https://1of10.com/blog/fortnite-thumbnail-maker-how-to-create-high-ctr-gaming-thumbnails-with-ai/): Motiv 40–60 %, Blau/Violett plus warme Töne, Text oben
- [Fortnite Data API](https://www.fortnite.com/news/fortnite-data-api-unlocks-more-island-insights-for-creators), [API-Doku](https://dev.epicgames.com/documentation/en-us/fortnite/using-fortnite-data-api-in-fortnite): Metriken, 7 Tage Rückblick
- [Analytics Device (Fortnite News)](https://www.fortnite.com/news/get-play-stats-with-the-analytics-device-for-fortnite-creative-and-uefn): 50 pro Insel, tägliches Dashboard
- [gemlist.io SAC-Anforderungen](https://www.gemlist.io/blog/fortnite-creator-code-requirements), [SAC-Programm (Epic)](https://www.fortnite.com/fortnite/en-US/creative/docs/joining-the-support-a-creator-program), [SAC Terms](https://legal.epicgames.com/fortnite/eula/sac)
- [Steal a Brainrot Fuse Machine (Fandom)](https://stealabrainrot.fandom.com/wiki/Fuse_Machine), [Beebom Fight The Brainrot Codes](https://beebom.com/fortnite-fight-the-brainrot-codes/)
