#!/usr/bin/env python3
"""
FUSE THE BRAINROT - Katalog-Generator (nur Standardbibliothek)
Erzeugt:
  brainrot_catalog.csv   40 Basis- + 40 Event- + 8 Geheim-Kreaturen
  hybrid_names.csv       alle 512 (bzw. 1000 mit Bonus-Arten) Hybrid-Namen, gegen Sperrliste geprueft
  catalog_tables.md      Markdown-Tabellen fuer das GDD
Stats kommen aus denselben Basiswerten wie economy_sim.py (income_base / power_base).
"""
import csv
import os

HERE = os.path.dirname(os.path.abspath(__file__))

RAR = ["Gewöhnlich", "Ungewöhnlich", "Selten", "Episch", "Legendär", "Mythisch", "Geheim"]
RAR_HEX = ["#B8C2CC", "#5BD45B", "#3AA0FF", "#B056FF", "#FFB319", "#FF3D6E", "#00E5FF>#FF3DF2"]
INCOME_BASE = [1, 4, 16, 70, 320, 1500, 7500]
POWER_BASE = [10, 40, 160, 700, 3200, 15000, 75000]

# Sperrliste: Teilstrings geschuetzter/bekannter Brainrot-Figuren (klein, ohne Akzente).
BLOCK = ["tung", "sahur", "tralal", "cappucc", "ballerin", "bombard", "crocod", "patapim", "brr", "lirili",
         "larila", "bananin", "chimpanz", "trippi", "troppi", "boneca", "ambalab", "udin", "glorbo", "frigo",
         "camelo", "saturn", "assassin", "bobrit", "bandit", "trulimer", "trulicin", "burbalon", "lulilol",
         "garama", "orangut", "ananasin", "cocofant", "elefant", "girafa", "celestr", "espresson", "svinin",
         "bombombin", "gusini", "toasterin", "tualett", "cacto", "hipopot", "frulli", "frulla", "spionir",
         "golubir", "crabracad", "blueberrin", "octopussin", "tatata", "pipi", "potato", "salamin", "matteo",
         "graipuss", "medussi", "tob tob", "nuclear", "dinossaur", "zibra", "zubra", "zibrin", "ta ta",
         "tim chees", "strawberr", "elephant", "sigma", "skibidi", "rizz", "gyatt", "ohio", "fanum",
         "kaka", "pups", "arsch", "nazi", "sex", "tits", "fick", "shit", "fuck", "piss", "kack"]

# 8 Basis-Arten + 2 Event-Bonus-Arten (nur wenn Speicherbudget < 50 % in Woche 1)
# id, Name, Konzept, Kopf, Koerper, Accessoire, Silben (prefix, mid, suffix),
# Rolle, Skill (Kopf), Koerperprofil, Trait (Accessoire), Faktoren inc/atk/hp/spd, Animation, Sound
SPECIES = [
    (1, "Waffelino", "Waffeleisen-Maus", "Mauskopf mit Waffel-Ohren", "aufklappbares Waffeleisen auf 4 Stummelbeinen",
     "Sirupflaschen-Rucksack", ("Waf", "waffe", "lino"), "Verdiener",
     "Waffel-Wurf: Einzelziel, 1,2x ATK", "Waffel-Leib: Einkommen +20 %", "Sirup-Zins: +10 % Münzen aus Wellen",
     (1.20, 0.9, 1.0, 1.0), "Klapp-Hüpfer: Körper-Squash 0,85/1,15 Y alle 0,6 s, Ohren wippen", "Knusper-Klick + hohes Fiepen"),
    (2, "Frogurko", "Gurkenglas-Frosch", "Frosch-Gurkenkopf mit Glubschaugen", "Einmachglas mit Froschbeinen",
     "Dill-Krone", ("Fro", "gurk", "urko"), "Gift",
     "Essig-Spritzer: Gift 3 s (40 % ATK/s)", "Glas-Leib: Angriffstempo +20 %", "Dill-Duft: Gift hält +2 s",
     (1.0, 0.8, 1.1, 1.2), "Frosch-Sprung: Hop 40 cm alle 1,4 s, Glas wackelt (Roll ±6°)", "Quaken + Glas-Plopp"),
    (3, "Idrantoro", "Hydranten-Stier", "Stierkopf mit Ventil-Hörnern", "roter Hydranten-Rumpf, kurze Hufe",
     "Feuerwehrschlauch-Schal", ("Idra", "dranto", "oro"), "Tank",
     "Wasser-Ansturm: Stoß + 0,5 s Betäubung", "Hydranten-Leib: HP +60 %", "Druckventil: 15 % Schaden zurück",
     (0.85, 0.7, 1.6, 0.8), "Stampf-Idle: 2 Stampfer + Dampfwolke alle 3 s", "Tiefes Muhen + Zisch-Ventil"),
    (4, "Tagliatakel", "Nudel-Oktopus", "Oktopuskopf mit Nudelnest-Frisur", "Pastateller-Mantel mit 8 Nudelarmen",
     "Fleischbällchen-Kette", ("Tagli", "glia", "takel"), "Mehrfachtreffer",
     "Nudel-Wirbel: 3 Ziele, je 0,5x ATK", "Teller-Leib: Angriffstempo +40 %", "Bällchen-Kette: +1 Ziel",
     (1.0, 0.75, 1.0, 1.4), "Wabbel-Idle: Körper-Scale-Puls 1,0/1,08, Kette rotiert 30°/s", "Schlürfen + Blubb"),
    (5, "Diskolama", "Discokugel-Lama", "Lamakopf mit Discokugel-Wuschel", "verspiegelter Wollkörper",
     "Plateau-Sonnenbrille", ("Dis", "disko", "lama"), "Support",
     "Glitzer-Spucke: Team-ATK +15 % für 5 s", "Spiegel-Leib: ausgewogen", "Plateau-Groove: Hype-Fenster +20 % breiter",
     (0.9, 0.6, 1.0, 1.0), "Kopfnicken im 120-BPM-Takt, Kugel dreht 45°/s", "Lama-Summen + Disco-Pling"),
    (6, "Razzopingu", "Raketen-Pinguin", "Pinguinkopf mit Pilotenbrille", "Raketenrumpf im Frack",
     "Düsen-Fliege", ("Raz", "razzo", "pingu"), "Burst",
     "Raketen-Rutscher: 25 % Krit-Chance", "Raketen-Leib: ATK +30 %", "Nachbrenner: Krit-Schaden +50 %",
     (0.95, 1.3, 0.8, 0.9), "Watschel-Idle (Roll ±8°) + Mini-Raketenhüpfer alle 4 s", "Tröt + Zünd-Fauchen"),
    (7, "Wolkowal", "Gewitterwolken-Wal", "Walkopf aus Sturmwolke", "Wolkenleib mit Regen-Schleier",
     "Regenbogen-Schirm", ("Wol", "wolko", "wal"), "Flächenschaden",
     "Donner-Blas: Kettenblitz auf 4 Ziele", "Nebel-Leib: 10 % Ausweichen", "Farbschild: Boss-Schaden +20 %",
     (1.05, 1.0, 1.1, 0.7), "Schwebe-Bob: Sinus 25 cm / 2,4 s, langsames Rollen", "Walgesang + fernes Donnergrollen"),
    (8, "Bzzkoffro", "Koffer-Hummel", "Hummelkopf mit Reisehut", "Hartschalenkoffer mit Streifen",
     "Zoll-Sticker-Flügel", ("Bzz", "koff", "offro"), "Beute",
     "Souvenir-Stich: +25 % Drop-Chance beim Treffer", "Koffer-Leib: Einkommen +10 %", "Zoll-Sticker: +1 Kern pro Welle (15 %)",
     (1.10, 0.8, 1.0, 1.1), "Summ-Zittern 12 Hz ±1 cm + Flug-Bob 15 cm", "Brummen + Reißverschluss-Zipp"),
    (9, "Paketeulo", "Geschenkpaket-Eule", "Eulenkopf mit Schleife", "Geschenkkarton mit Flügeln",
     "Geschenkband-Schwanz", ("Pake", "paket", "eulo"), "Geschenk, Event-Bonus W3",
     "Paket-Bombe: Flächenschaden 2 Ziele", "Karton-Leib: HP +20 %", "Überraschung: 10 % Chance auf Gratis-Kern",
     (1.05, 0.9, 1.2, 0.9), "Kopf-Drehung 180° alle 5 s, Schleife flattert", "Huhu + Papier-Rascheln"),
    (10, "Bassotto", "Lautsprecher-Dackel", "Dackelkopf mit Kopfhörern", "langer Lautsprecher-Körper",
     "Subwoofer-Schwanz", ("Bas", "basso", "otto"), "Rhythmus, Event-Bonus W6",
     "Bass-Drop: alle 3. Angriffe 2x Schaden", "Boxen-Leib: Tempo +25 %", "Beat-Sync: Perfekt-Hype +10 % Schaden",
     (1.0, 0.95, 1.0, 1.25), "Pump-Idle: Körper-Scale-Puls im Takt 120 BPM", "Wuff + Bass-Wumms"),
]

FORM = ["Klassik", "Neon", "Gold", "Kristall", "Königlich", "Mythisch", "Kosmisch"]
BASE_NAMES = {
    1: ["Waffelino", "Waffelinetto", "Waffeloro", "Kristawaffel", "Re Waffelissimo"],
    2: ["Frogurko", "Frogurchetto", "Frogoldurko", "Kristagurko", "Gurkönig Frogurkone"],
    3: ["Idrantoro", "Idrantorino", "Idrantoro Dorado", "Kristidranto", "Imperatoro Idrante"],
    4: ["Tagliatakel", "Tagliatakelino", "Tagliatakel d'Oro", "Kristallotakel", "Mamma Tagliatella"],
    5: ["Diskolama", "Diskolamina", "Goldiskolama", "Kristallama", "Diskolama Mythica"],
    6: ["Razzopingu", "Razzopinguino", "Razzoro", "Kristazzo", "Razzopingu Supremo"],
    7: ["Wolkowal", "Wolkowalino", "Wolkoro", "Kristallwal", "Kosmowal Infinito"],
    8: ["Bzzkoffro", "Bzzkoffrino", "Bzzoro Kofferone", "Kristabzz", "Galaktikoffro"],
}
# 5. Form je Art: Seltenheit (Leg. fuer 1-4, Myth. fuer 5-6, Geheim fuer 7-8)
TOP_RARITY = {1: 4, 2: 4, 3: 4, 4: 4, 5: 5, 6: 5, 7: 6, 8: 6}

REVEAL = [
    "Staubwölkchen weiß, 1 Pling (400 ms)",
    "Grüner Konfetti-Puff + Doppel-Pling (600 ms)",
    "Blauer Ring-Burst + Glocken-Arpeggio, leichter Kamera-Push (900 ms)",
    "Lila Wirbel, Ei bekommt Risse in 3 Stufen, Trommelwirbel (1.400 ms)",
    "Goldener Lichtstrahl, 0,5 s Zeitlupe, Fanfare, Server-Toast (2.200 ms)",
    "Pinke Schockwelle über den Plot, Chor-Akkord, Server-Toast + Name per TTS (2.800 ms)",
    "Blackout 300 ms, kosmischer Wirbel, Bass-Drop, globales Banner für alle 16 Spieler (4.000 ms)",
]
EGG_SRC = {0: "Wiesen-/Sumpf-Ei", 1: "Wiesen-/Sumpf-/Wüsten-Ei", 2: "Sumpf-/Wüsten-/Disko-Ei",
           3: "Wüsten-/Disko-/Gewitter-Ei", 4: "Disko-/Gewitter-/Kosmos-Ei (+Fusion)",
           5: "Disko-(1 %)/Gewitter-/Kosmos-Ei (+Fusion)", 6: "Gewitter-/Kosmos-/Urknall-Ei (0,01–0,5 %) oder Geheim-Rezept"}
RARITY_LOOK = ["mattes Plastik", "Neon-Emissive-Kanten", "Gold-Metallic", "Kristall-Fresnel, halbtransparent",
               "Gold + schwebende Krone (VFX)", "Pink-Aura + Partikelschweif", "Kosmos-Shader (Sternenfeld-Panning), Halo"]


def stats(sp, r):
    inc_f, atk_f, hp_f, spd_f = sp[11]
    inc = round(INCOME_BASE[r] * inc_f, 2)
    atk = round(POWER_BASE[r] * atk_f)
    hp = round(POWER_BASE[r] * 5 * hp_f)
    spd = round(1.0 * spd_f, 2)
    return inc, atk, hp, spd


VOW = set("aeiouäöü")


def join(a, b):
    """Silben-Verbindung: Konsonant+Konsonant -> Bindevokal 'a'; Vokal+Vokal -> 2. Vokal fallen lassen."""
    if not a:
        return b
    x, y = a[-1].lower(), b[0].lower()
    if x not in VOW and y not in VOW:
        return a + "a" + b
    if x in VOW and y in VOW:
        return a + b[1:]
    return a + b


def hybrid_name(h, b, a):
    if h == b == a:
        return SPECIES[h - 1][1]
    p, m, s = SPECIES[h - 1][6][0], SPECIES[b - 1][6][1], SPECIES[a - 1][6][2]
    n = join(join(p, m), s)
    # Dreifach-Buchstaben kappen
    out = ""
    for ch in n:
        if len(out) >= 2 and out[-1].lower() == out[-2].lower() == ch.lower():
            continue
        out += ch
    return out[0].upper() + out[1:].lower()


def blocked(name):
    n = name.lower().replace("ì", "i").replace("à", "a")
    return [w for w in BLOCK if w in n]


SECRETS = [  # Name, Kopf, Koerper, Accessoire, Spezialeffekt
    ("Blitzodisko Supremo", 7, 5, 6, "Donner-Disco: Kettenblitz trifft im Takt, jeder 4. Blitz 3x"),
    ("Nudelnebel Infinito", 4, 7, 2, "Nebel-Nudeln: alle Gegner vergiftet + 10 % langsamer"),
    ("Kofferkanone Magnifica", 8, 6, 3, "Koffer-Rakete: Boss-Treffer werfen 2 Extra-Kerne aus"),
    ("Sirupsturm Galattico", 1, 7, 5, "Sirup-Regen: Team-Einkommen +25 % während Wellen"),
    ("Hydrodisko Grandioso", 3, 5, 4, "Schaum-Party: Team-HP +30 %, Dornen 25 %"),
    ("Gurkenrakete Fantastica", 2, 6, 8, "Essig-Jet: Krit-Treffer vergiften (100 % ATK/s)"),
    ("Walwaffel Celestiale", 7, 1, 8, "Himmelswaffel: +1 Pad-Einkommenseffekt auf alle Nachbarn (+10 %)"),
    ("Pinguinudel Assoluta", 6, 4, 7, "Raketen-Wirbel: Mehrfachtreffer auf 5 Ziele mit Krit"),
]

EVENT_WEEKS = [  # Woche, Datum, Form-Praefix, Arten (Rarity), Beschreibung
    (1, "10.–16.12.2026", "Gründer", [(1, 2), (2, 2), (5, 3), (6, 3), (8, 4)], "Launch: goldene Schlüpf-Banderole"),
    (2, "17.–23.12.2026", "Frosti", [(3, 2), (4, 2), (7, 3), (1, 3), (5, 4)], "Winterfest I: Eis-Kristall-Shader, Schneeflocken-VFX"),
    (3, "24.–30.12.2026", "Paket", [(9, 1), (9, 2), (9, 3), (9, 4), (9, 5)], "Winterfest II: neue Art Paketeulo (Bonus-Art)"),
    (4, "31.12.–06.01.2027", "Funki", [(6, 2), (8, 2), (2, 3), (3, 4), (5, 5)], "Jahreswechsel: Funkenregen-Shader (keine Böller-Geräusche)"),
    (5, "07.–13.01.2027", "Schleimi", [(2, 2), (4, 3), (1, 3), (7, 4), (3, 5)], "Schleim-Invasion: glibbriges Grün, Wellen-Modifikator"),
    (6, "14.–20.01.2027", "Bass", [(10, 1), (10, 2), (10, 3), (10, 4), (10, 5)], "Disko-Fieber: neue Art Bassotto (Bonus-Art)"),
    (7, "21.–27.01.2027", "Kosmi", [(5, 3), (8, 3), (3, 4), (1, 5), (6, 6)], "Kosmos-Woche: Sternenfeld-Shader, Meteor-Boss"),
    (8, "28.01.–03.02.2027", "Festi", [(4, 3), (7, 3), (2, 4), (5, 5), (8, 6)], "Fusions-Festival: Regenbogen-Shader, Rezept-Hinweise"),
]


def main():
    rows = []
    # Basis-Kreaturen
    cid = 0
    for sp in SPECIES[:8]:
        sid = sp[0]
        rars = [0, 1, 2, 3, TOP_RARITY[sid]]
        for k, r in enumerate(rars):
            cid += 1
            name = BASE_NAMES[sid][k]
            inc, atk, hp, spd = stats(sp, r)
            form = FORM[k] if k < 4 else FORM[r]
            rows.append({
                "id": f"B{cid:02d}", "name": name, "quelle": "Basis (Ei)", "event_woche": "",
                "art_id": sid, "art": sp[1], "seltenheit": RAR[r], "rarity_hex": RAR_HEX[r], "form": form,
                "konzept": f"{sp[2]} ({sp[7]}); Form {form}: {RARITY_LOOK[r]}",
                "silhouette": f"Kopf: {sp[3]} / Körper: {sp[4]} / Accessoire: {sp[5]}",
                "kopf": f"H{sid}", "koerper": f"K{sid}", "accessoire": f"A{sid}",
                "einkommen_pro_s_L1": inc, "atk": atk, "hp": hp, "angriffe_pro_s": spd,
                "skill_kopf": sp[8], "profil_koerper": sp[9], "trait_accessoire": sp[10],
                "animation": sp[12], "sound": sp[13] + "; Name per Kokoro-TTS gesungen",
                "reveal": REVEAL[r], "herkunft": EGG_SRC[r],
            })
    # Event-Kreaturen
    eid = 0
    for wk, date, pref, lst, desc in EVENT_WEEKS:
        for sid, r in lst:
            eid += 1
            sp = SPECIES[sid - 1]
            inc, atk, hp, spd = stats(sp, r)
            name = f"{pref}-{sp[1]}" if sid <= 8 else [sp[1], sp[1] + "tto" if not sp[1].endswith("o") else sp[1][:-1] + "etto",
                                                        sp[1][:-1] + "oro", "Krista" + sp[1].lower(), "Re " + sp[1] + "issimo"][r - 1]
            if sid > 8 and r == 5:
                name = f"{sp[1]} Mythico"
            rows.append({
                "id": f"E{wk}-{eid:02d}", "name": name, "quelle": "Event (Event-Ei, gratis)", "event_woche": f"W{wk} {date}",
                "art_id": sid, "art": sp[1], "seltenheit": RAR[r], "rarity_hex": RAR_HEX[r], "form": pref,
                "konzept": f"{sp[2]}; {desc}",
                "silhouette": f"wie {sp[1]}" + (f" – Kopf: {sp[3]} / Körper: {sp[4]} / Acc.: {sp[5]}" if sid > 8 else " + Event-Material-Instanz"),
                "kopf": f"H{sid}", "koerper": f"K{sid}", "accessoire": f"A{sid}",
                "einkommen_pro_s_L1": inc, "atk": atk, "hp": hp, "angriffe_pro_s": spd,
                "skill_kopf": sp[8], "profil_koerper": sp[9], "trait_accessoire": sp[10],
                "animation": sp[12], "sound": sp[13] + " + Event-Glöckchen-Layer",
                "reveal": REVEAL[r] + " + Event-Farbton", "herkunft": f"Event-Ei W{wk} (Event-Tokens), bleibt danach im Index sichtbar",
            })
    # Geheim-Rezepte
    for i, (name, h, b, a, fx) in enumerate(SECRETS, 1):
        inc, atk, hp, spd = INCOME_BASE[6] * 1.25, round(POWER_BASE[6] * 1.25), round(POWER_BASE[6] * 5 * 1.2), 1.1
        rows.append({
            "id": f"G{i:02d}", "name": name, "quelle": "Geheim-Fusion", "event_woche": "",
            "art_id": f"{h}/{b}/{a}", "art": "Hybrid", "seltenheit": RAR[6], "rarity_hex": RAR_HEX[6], "form": "Kosmisch+Rezept",
            "konzept": f"Rezept: Kopf {SPECIES[h-1][1]} + Körper {SPECIES[b-1][1]} + Acc. {SPECIES[a-1][1]}, beide Eltern mind. Mythisch",
            "silhouette": f"Kopf: {SPECIES[h-1][3]} / Körper: {SPECIES[b-1][4]} / Acc.: {SPECIES[a-1][5]} + Spezial-Halo",
            "kopf": f"H{h}", "koerper": f"K{b}", "accessoire": f"A{a}",
            "einkommen_pro_s_L1": inc, "atk": atk, "hp": hp, "angriffe_pro_s": spd,
            "skill_kopf": SPECIES[h-1][8], "profil_koerper": SPECIES[b-1][9], "trait_accessoire": fx,
            "animation": "Hybrid-Animation (Körper-Art) + Halo-Rotation 60°/s", "sound": "Eigener 4-Takt-Jingle + TTS-Name mit Hall",
            "reveal": REVEAL[6] + " + Rezept-Stempel im Index", "herkunft": "Fusion 2x Mythisch mit exakt diesen Teilen (Hinweise ab Rebirth 10 / Event W8)",
        })
    fields = list(rows[0].keys())
    with open(os.path.join(HERE, "brainrot_catalog.csv"), "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader()
        w.writerows(rows)

    # Hybrid-Namen
    bad, names, longest = [], [], ""
    for h in range(1, 11):
        for b in range(1, 11):
            for a in range(1, 11):
                n = hybrid_name(h, b, a)
                bl = blocked(n)
                base8 = h <= 8 and b <= 8 and a <= 8
                names.append((h, b, a, n, "R1" if base8 else "Bonus", ";".join(bl)))
                if bl:
                    bad.append((n, bl))
                if base8 and len(n) > len(longest):
                    longest = n
    with open(os.path.join(HERE, "hybrid_names.csv"), "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["kopf_art", "koerper_art", "acc_art", "name", "paket", "sperrlisten_treffer"])
        w.writerows(names)
    for r in rows:
        if blocked(r["name"]):
            bad.append((r["name"], blocked(r["name"])))
    lens = sorted(len(n[3]) for n in names if n[4] == "R1")

    # Markdown fuer GDD
    md = []
    md.append("| ID | Name | Konzept / Form | Silhouette (Kopf / Körper / Accessoire) | Seltenheit | Münzen/s (L1) | ATK / HP / Angr./s | Animation (prozedural) | Sound | Reveal |")
    md.append("|---|---|---|---|---|---|---|---|---|---|")
    for r in rows:
        if r["quelle"].startswith("Basis"):
            md.append(f"| {r['id']} | **{r['name']}** | {r['konzept']} | {r['silhouette'].replace('Kopf: ','').replace(' / Körper: ',' / ').replace(' / Accessoire: ',' / ')} | {r['seltenheit']} | {r['einkommen_pro_s_L1']} | {r['atk']} / {r['hp']} / {r['angriffe_pro_s']} | {r['animation']} | {r['sound'].split(';')[0]} | {r['reveal']} |")
    md.append("\n<!--EVENT-->\n")
    md.append("| ID | Name | Woche | Art | Seltenheit | Münzen/s (L1) | ATK / HP |")
    md.append("|---|---|---|---|---|---|---|")
    for r in rows:
        if r["quelle"].startswith("Event"):
            md.append(f"| {r['id']} | {r['name']} | {r['event_woche']} | {r['art']} | {r['seltenheit']} | {r['einkommen_pro_s_L1']} | {r['atk']} / {r['hp']} |")
    md.append("\n<!--SECRET-->\n")
    md.append("| ID | Name | Kopf + Körper + Accessoire | Spezialeffekt |")
    md.append("|---|---|---|---|")
    for r in rows:
        if r["quelle"] == "Geheim-Fusion":
            md.append(f"| {r['id']} | **{r['name']}** | {r['konzept'].split(', beide')[0].replace('Rezept: ','')} | {r['trait_accessoire']} |")
    md.append("\n<!--SPECIES-->\n")
    md.append("| # | Art | Konzept | Kopf → Skill | Körper → Profil | Accessoire → Trait | Silben P/M/S | Faktoren Eink./ATK/HP/Tempo |")
    md.append("|---|---|---|---|---|---|---|---|")
    for sp in SPECIES:
        md.append(f"| {sp[0]} | **{sp[1]}** | {sp[2]} ({sp[7]}) | {sp[3]} → {sp[8]} | {sp[4]} → {sp[9]} | {sp[5]} → {sp[10]} | {'/'.join(sp[6])} | {'/'.join(str(x) for x in sp[11])} |")
    with open(os.path.join(HERE, "catalog_tables.md"), "w", encoding="utf-8") as f:
        f.write("\n".join(md))

    print(f"Katalog: {len(rows)} Einträge ({sum(r['quelle'].startswith('Basis') for r in rows)} Basis)")
    print(f"Hybrid-Namen: {len(names)} (R1: {sum(1 for n in names if n[4]=='R1')}), Längen R1 min/median/max = {lens[0]}/{lens[len(lens)//2]}/{lens[-1]} ('{longest}')")
    print(f"Sperrlisten-Treffer: {len(bad)}")
    for b in bad[:30]:
        print("  ", b)
    ex = [(6, 2, 5), (7, 3, 1), (1, 8, 4), (5, 6, 7), (2, 4, 8), (3, 1, 6), (8, 7, 2), (4, 5, 3)]
    for h, b, a in ex:
        print(f"  Beispiel H{h}+K{b}+A{a}: {hybrid_name(h, b, a)}")


if __name__ == "__main__":
    main()
