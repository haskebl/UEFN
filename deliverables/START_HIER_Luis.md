# START HIER – Luis' Schritt-für-Schritt-Anleitung (Tag 1)

Ziel von Tag 1: Am Ende läuft der lokale Claude Code im UEFN-Projekt `FuseTheBrainrot`, ist mit UEFN verbunden und beginnt mit M0.
Du brauchst dafür ca. 3–4 Stunden. Alles danach sagt dir Claude Code (Klicklisten) bzw. `BAUPLAN_Claude_Code.md`, Anhang L.

Kennzeichnung: **[PS]** = in PowerShell eingeben · **[GB]** = in Git Bash eingeben · **[Klick]** = Maus.
„UNGEPRÜFT“ = konnte aus der Cloud nicht bestätigt werden; wenn es anders aussieht, frag Claude Code.

---

## Teil A – Werkzeuge installieren (ca. 60–90 min)

1. **PowerShell öffnen:** Windows-Taste → `PowerShell` tippen → *Windows PowerShell* öffnen (normal, nicht als Admin).
2. **[PS]** Nacheinander (jede Zeile einzeln, Enter, warten bis fertig; Rückfragen mit `Y` bestätigen):
   ```
   winget install -e --id Git.Git
   winget install -e --id Python.Python.3.12
   winget install -e --id Gyan.FFmpeg
   winget install -e --id GitHub.cli
   ```
3. **PowerShell schließen und neu öffnen** (damit die neuen Programme gefunden werden).
4. **[PS]** `git lfs install` → Erwartet: „Git LFS initialized.“
5. **Blender 4.2 LTS:** [Klick] Browser → `https://download.blender.org/release/Blender4.2/` → die Datei mit der höchsten Nummer, die auf `-windows-x64.msi` endet, herunterladen → doppelklicken → immer *Next* → Pfad **nicht ändern** (`C:\Program Files\Blender Foundation\Blender 4.2\`). Blender musst du nie öffnen.
6. **Claude Code prüfen:** **[PS]** `claude --version`.
   - Kommt eine Versionsnummer → fertig.
   - Kommt ein Fehler → installieren: **[PS]** `irm https://claude.ai/install.ps1 | iex`, PowerShell neu öffnen, `claude --version` erneut. (Installationsweg UNGEPRÜFT – falls es scheitert: docs.claude.com → „Claude Code“ → „Setup“.)
7. **GitHub anmelden:** **[PS]** `gh auth login` → Antworten: *GitHub.com* → *HTTPS* → *Yes* (Git-Zugang) → *Login with a web browser* → Code im Browser eingeben.
8. **Kontrolle in Git Bash:** [Klick] Startmenü → `Git Bash` öffnen. **[GB]** diese 5 Zeilen; jede muss eine Versionsnummer zeigen, keinen Fehler:
   ```
   git --version
   git lfs version
   python --version
   ffmpeg -version | head -1
   "/c/Program Files/Blender Foundation/Blender 4.2/blender.exe" --version | head -1
   ```
   Fehler bei `python`? → Windows-Einstellungen → *Apps* → *Erweiterte App-Einstellungen* → *App-Ausführungsaliase* → beide „python“-Einträge **aus**, Git Bash neu öffnen.

## Teil B – Das Recherche-Paket holen (5 min)

9. **[GB]**
   ```
   git clone -b claude/brainrot-map-uefn-plan-20eyj3 https://github.com/haskebl/uefn.git /c/FTB_paket
   ls /c/FTB_paket/deliverables
   ```
   Erwartet u. a.: `BAUPLAN_Claude_Code.md`, `CLAUDE.md`, `GDD_Fuse_and_Fight.md`, `_context`, `blender`, `data`, `verse_reference`.
   (Alternative ohne Befehl: GitHub → Repo `uefn` → Branch `claude/brainrot-map-uefn-plan-20eyj3` → *Code* → *Download ZIP* → so entpacken, dass es `C:\FTB_paket\deliverables\…` gibt.)

## Teil C – UEFN-Projekt anlegen (15 min)

10. [Klick] **Epic Games Launcher** → *Unreal Editor for Fortnite* → *Starten*. Falls ein Update angeboten wird: installieren.
11. [Klick] Im Projekt-Browser: *Help → About* (oder Startbildschirm) → **Versionsnummer notieren** (muss ≥ 42.00 sein, sonst gibt es kein Unreal MCP).
12. [Klick] *New Project* → Vorlage **Blank** (leere Insel) → Projektname exakt **`FuseTheBrainrot`** → *Create*.
13. Wenn das Projekt offen ist: **Projektordner finden.** Üblich (UNGEPRÜFT): `C:\Users\<dein Name>\Documents\Fortnite Projects\FuseTheBrainrot\`. **[GB]** zur Kontrolle:
    ```
    ls "$(cygpath -u "$USERPROFILE")/Documents/Fortnite Projects/"
    ```
    → `FuseTheBrainrot` muss erscheinen. Pfad notieren.
14. **Startdateien hineinkopieren [GB]** (Pfad aus 13 einsetzen, falls anders):
    ```
    P="$(cygpath -u "$USERPROFILE")/Documents/Fortnite Projects/FuseTheBrainrot"
    cp /c/FTB_paket/deliverables/CLAUDE.md "$P/"
    cp -r /c/FTB_paket/deliverables/_context "$P/"
    ls "$P"
    ```
    → `CLAUDE.md` und `_context` müssen in der Liste stehen. (Alles andere kopiert Claude Code in Aufgabe M0-02 selbst.)

## Teil D – Claude Code mit UEFN verbinden (20–40 min)

15. UEFN offen lassen (Projekt `FuseTheBrainrot` geladen).
16. **[GB]**
    ```
    cd "$(cygpath -u "$USERPROFILE")/Documents/Fortnite Projects/FuseTheBrainrot"
    claude
    ```
17. Im Claude-Code-Fenster eintippen (genau so):
    > Hilf mir Schritt für Schritt, das Unreal MCP von UEFN (v42+) laut offizieller Epic-Doku mit dir zu verbinden. Such die Doku mit WebSearch/WebFetch, sag mir jeden Klick einzeln. Danach zeig mit /mcp, dass die Werkzeuge da sind.
    - Folge seinen Klicks. (Die genauen Menüpfade in UEFN konnte ich aus der Cloud nicht prüfen – deshalb lässt du ihn die aktuelle Doku lesen.)
    - **Erfolgreich,** wenn Claude Code bei `/mcp` einen Unreal-/UEFN-Server mit Werkzeugen anzeigt.
    - **Klappt es nicht nach 40 min:** abbrechen. Der Plan hat einen Fallback (Claude Code arbeitet mit Dateien und gibt dir Klicklisten). Weiter mit Schritt 19.
18. Claude Code beenden: `/exit`.

## Teil E – Konten & Menschen (30 min, kann auch abends)

19. **Fortnite Developer Program** (nötig für V-Bucks-Verkäufe in der Map): Browser → `create.fortnite.com` → anmelden → Beitritt/Enrollment. Voraussetzungen laut Recherche: 18+, mind. 20 $ in Fortnite (oder qualifizierter Epic-Kauf) in den letzten 365 Tagen. Ergebnis merken (ja/nein/ausstehend) – Claude Code fragt danach.
20. **Zweites Epic-Konto** anlegen (kostenlos, andere E-Mail) – für 2-Spieler-Tests.
21. **Gamepad** an den PC anstecken und in Fortnite kurz prüfen.
22. **Handy/Tablet** (Android) mit Fortnite bereitlegen, falls vorhanden. Kein Gerät? Kein Problem – sag es Claude Code.
23. **Tester einladen** (genau 3 Personen; ideal: 1 mit Controller/Konsole, 1 mit Handy):
    - Test 1: **Sa 31.10.2026, 13:00–16:00**
    - Test 2: **Sa 28.11.2026, 11:00–19:00** – Ausweichtermin gleich mit ausmachen: **Fr 27.11. 17:00–21:00 oder So 29.11. 11:00–18:30** (gilt nur, wenn der 28.11. ausfällt).
24. Optional, 2 min: Im Epic-Forum den Zugang zur „Python Editor Scripting Beta“ für UEFN beantragen (nur Reserve, nicht darauf warten).

## Teil F – Bau starten

25. **[GB]**
    ```
    cd "$(cygpath -u "$USERPROFILE")/Documents/Fortnite Projects/FuseTheBrainrot"
    claude
    ```
26. Eintippen:
    > Lies CLAUDE.md und _context/status.md. Das Recherche-Paket liegt unter /c/FTB_paket (Bauplan: /c/FTB_paket/deliverables/BAUPLAN_Claude_Code.md). Meine Angaben: UEFN-Version <Nummer aus 11>, MCP verbunden: <ja/nein>, Developer Program: <ja/nein/ausstehend>, Android-Gerät: <ja/nein>, Tester eingeladen: <ja/nein>. Starte mit M0-02.
27. Ab jetzt: Claude Code arbeitet, du machst nur, was er dir als **Klickliste** gibt (Session starten, kurz hinschauen, etwas bestätigen).
    - Pro Tag ca. **2 Claude-Sessions**, je 1–2 Aufgaben. Nach jeder Session: `/exit`, neue Session mit
      > Lies CLAUDE.md und _context/status.md und mach mit der nächsten Aufgabe weiter.
    - Ist dein Claude-Kontingent leer: einfach warten. Er hat den Stand in `_context/status.md` gesichert und macht beim nächsten Start dort weiter.

---

## Deine Termine in M0 (danach: Anhang L im Bauplan)

| Wann | Was du tust | Dauer |
|---|---|---|
| Do 01.10. | Teile A–F dieser Anleitung | 3–4 h |
| Fr 02.10. | Klicklisten von Claude Code (nur falls MCP etwas nicht kann); 1 Verse-Datei anlegen, wenn er fragt | 0–2 h |
| Sa/So 03.–04.10. | Sessions starten, wenn er es sagt; kurz hinschauen (wippen Figuren? wechseln Farben?); 40× im Takt Feuer drücken | ca. 1,5 h |
| Mo 05.10. | ggf. *Launch Memory Calculation* klicken | 10 min |
| Di 06.10. | Ergebnis des Technik-Tests lesen; nur entscheiden, falls er eine Entscheidungsvorlage schreibt | 15 min |
| Do 08.–So 11.10. | Thumbnail-Umfrage: ~20 Leuten (Discord/Story) die Entwürfe zeigen, „welches würdest du anklicken?“ – **kein Playtest** | 30 min |

## Wenn etwas schiefgeht
- Befehl unbekannt → Programm neu installieren bzw. Git Bash/PowerShell neu öffnen.
- Irgendwas in UEFN sieht anders aus als beschrieben → Screenshot machen, Claude Code im Projektordner zeigen/beschreiben.
- Claude Code fragt etwas, das hier nicht steht → Antwort in `_context/offene_fragen.md` bzw. einfach im Chat geben.
