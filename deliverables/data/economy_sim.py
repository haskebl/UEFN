#!/usr/bin/env python3
"""
FUSE THE BRAINROT - Economy-Simulation (nur Python-Standardbibliothek)
=====================================================================
Simuliert einen aktiven Spieler (F2P, keine IIT-Boosts, kein Offline-Einkommen)
ueber 50 Spielstunden und schreibt Checkpoints nach economy_sim_output.csv.

Aufruf (Git Bash / Linux / macOS; unter Windows `python` statt `python3`):
  python3 economy_sim.py                      Referenzlauf Seed 7 -> schreibt data/economy_sim_output.csv
  python3 economy_sim.py --runs 20            Median/Streuung ueber 20 Seeds (7..26)
  python3 economy_sim.py --show-params        Parametertabelle als Markdown (nichts wird simuliert)
  python3 economy_sim.py --set pads_max=5     Parameter ueberschreiben (mehrfach erlaubt)
  python3 economy_sim.py --set 'pad_costs=[150,3000,60000]' --set rebirth_growth=4.0
  python3 economy_sim.py --params aenderung.json   Overrides aus JSON-Datei {"key": wert, ...}
  python3 economy_sim.py --dump-json econ_params.json   effektive Parameter als JSON schreiben
  python3 economy_sim.py --out pfad.csv       CSV-Ziel explizit setzen

Regeln:
- Werte von --set werden per json.loads gelesen (Zahlen, Listen, true/false);
  unbekannte Schluessel oder falscher Typ -> Abbruch mit Fehlermeldung.
- Reihenfolge: erst --params-Datei, dann --set (spaeteres --set gewinnt).
- Sobald Overrides aktiv sind, wird die Referenzdatei data/economy_sim_output.csv
  NIE ueberschrieben; Standardziel ist dann research/sim/sim_<JJJJMMTT_hhmmss>.csv
  (relativ zum aktuellen Arbeitsverzeichnis). Ohne Overrides bleibt das alte Verhalten.
- `--params` ohne JSON-Datei wirkt wie --show-params (Rueckwaertskompatibilitaet).

Alle Balancing-Werte stehen im Dict P. Dieselben Werte gehoeren 1:1 in
Verse (Generator-Marker `econ`, Quelle data/econ_params.json = --dump-json).
Aenderungen immer hier zuerst simulieren.
"""
import csv
import datetime
import json
import math
import os
import random
import statistics
import sys

RARITIES = ["Gewoehnlich", "Ungewoehnlich", "Selten", "Episch", "Legendaer", "Mythisch", "Geheim"]
R_SHORT = ["C", "U", "R", "E", "L", "M", "S"]

P = {
    # --- Kreaturen -------------------------------------------------------
    "income_base": [1, 4, 16, 70, 320, 1500, 7500],          # Muenzen/s auf Level 1, Gen 0
    "power_base": [10, 40, 160, 700, 3200, 15000, 75000],    # Kampfkraft auf Level 1, Gen 0
    "level_mult": 1.15,               # Einkommen & Kraft x1.15 pro Level
    "level_cost_factor": 20,          # Levelkosten = income_base[r] * 20 * growth^(L-1)
    "level_cost_growth": 1.21,
    "level_cap_base": 25,             # Max-Level = 25 + 5 * Rebirths (Deckel 150)
    "level_cap_per_rebirth": 5,
    "level_cap_max": 150,
    "gen_bonus": 0.08,                # +8 % Einkommen & Kraft pro Fusions-Generation
    "gen_cap": 10,
    # --- Eier: Name, Preis, Brutzeit s, Quoten C..S in %, Rebirth-Voraussetzung
    "eggs": [
        ("Wiesen-Ei", 20, 3, [80, 18, 2, 0, 0, 0, 0], 0),
        ("Sumpf-Ei", 350, 5, [40, 42, 15, 3, 0, 0, 0], 0),
        ("Wuesten-Ei", 7_500, 8, [0, 45, 40, 13, 2, 0, 0], 0),
        ("Disko-Ei", 400_000, 12, [0, 0, 50, 38, 11, 1, 0], 0),
        ("Gewitter-Ei", 3_000_000_000, 18, [0, 0, 0, 60, 36, 3.99, 0.01], 2),
        ("Kosmos-Ei", 5_000_000_000_000, 25, [0, 0, 0, 0, 70, 29.95, 0.05], 5),
        ("Urknall-Ei", 20_000_000_000_000_000, 30, [0, 0, 0, 0, 55, 44.8, 0.2], 9),
        ("Galaxie-Ei", 1e23, 30, [0, 0, 0, 0, 30, 69.5, 0.5], 14),
    ],
    "brood_slots": 1,                 # F2P; IIT "Goldenes Nest" = 2
    "stall_cap": 30,                  # Lager (nicht verdienend)
    # --- Plot ------------------------------------------------------------
    "pads_start": 2,
    "pads_max": 6,                    # Obergrenze Pads (Fallback F2: 5); braucht pads_max-pads_start Pad-Kosten
    "pad_costs": [150, 3_000, 60_000, 1_200_000],   # Pad 3..6 (bleiben bei Rebirth)
    "totem_base": 500,                # Einkommens-Totem Stufe n kostet 500*1.55^n
    "totem_growth": 1.55,
    "totem_bonus": 0.10,              # +10 % Einkommen pro Stufe (additiv)
    # --- Fusion ----------------------------------------------------------
    "fusion_unlock_wave": 5,
    "fusion_coin_s": 120,             # Muenzkosten = income_base[r] * 120 * Rebirth-Mult
    "fusion_kerne": [3, 6, 12, 25, 50, 100, 100],
    "fusion_time_s": [20, 45, 90, 180, 360, 600, 600],   # Fusionsdauer nach Eltern-Seltenheit
    "fusion_slots": 1,
    "resonance_chance": 0.20,         # gleiche Seltenheit -> +1 Stufe (Quote sichtbar), max. Mythisch
    "resonance_pity": 5,              # 5. Versuch in Folge garantiert
    "secret_recipe_rebirth": 10,      # Geheim-Rezepte (Hinweise) ab Rebirth 10
    "secret_recipe_chance": 0.08,     # Anteil M+M-Fusionen, die ein Rezept treffen
    # --- Wellen ----------------------------------------------------------
    "wave_base": 22,                  # W(w) = 22 * 1.13^(w-1) * (1 + (w-1)/15)
    "wave_growth": 1.13,
    "wave_poly": 15,
    "hype_dist": [(1.0, 0.20), (1.25, 0.50), (1.5, 0.30)],   # Verfehlt/Gut/Perfekt
    "wave_cycle_s": 40,               # 25 s Kampf + 15 s Verwaltung
    "wave_first_income_s": 45,        # Erstabschluss: 45 s Einkommen
    "wave_first_flat": 20, "wave_flat_growth": 1.12,
    "wave_replay_income_s": 15,       # Wiederholung: 15 s Einkommen
    "wave_first_kerne_base": 2,       # 2 + floor(w/10)
    "wave_replay_kerne": 1,
    # --- Server-Boss -----------------------------------------------------
    "boss_period_s": 420, "boss_offset_s": 200, "boss_unlock_s": 480,
    "boss_duration_s": 75,
    "boss_income_s": 90,              # 90 s Einkommen fuer jeden Teilnehmer
    "boss_kerne": 10,
    "boss_free_egg": True,            # 1 Gratis-Ei der hoechsten freigeschalteten Stufe
    # --- Freilassen ------------------------------------------------------
    "release_kerne": [1, 1, 2, 3, 5, 8, 12],
    # --- Rebirth ---------------------------------------------------------
    "rebirth_base": 300_000_000,      # Kosten n-ter Rebirth = base * growth^n
    "rebirth_growth": 4.25,
    "rebirth_wave_req": 20,           # + Welle >= 20 + 10n
    "rebirth_wave_step": 10,
    "rebirth_mult": 1.45,              # x1.45 Einkommen & Kraft pro Rebirth (multiplikativ)
    "rebirth_keep_base": 1,           # behaelt min(1+n, 6) beste Brainrots
    # --- Index -----------------------------------------------------------
    "index_bonus_per_entry": 0.004,   # +0,4 % Einkommen pro Index-Eintrag
    "index_bonus_cap": 1.0,           # max +100 %
    "hybrid_combos": 504,             # 512 Kombis - 8 reine Arten
    # --- Tutorial-Skript -------------------------------------------------
    "tut_free_egg_at": 5,             # Gratis-Starter-Ei (Brutzeit 5 s)
    "tut_wave1_at": 40,               # Tutorial-Welle 1: +50 Muenzen, +3 Kerne, Gratis-Wiesen-Ei
    "tut_wave1_coins": 50, "tut_wave1_kerne": 3,
}

def pads_max():
    """Effektive Pad-Obergrenze: pads_max, begrenzt durch die Anzahl definierter Pad-Kosten."""
    return min(P["pads_max"], P["pads_start"] + len(P["pad_costs"]))


HORIZONS_H = [0.25, 0.5, 1, 2, 3, 5, 10, 20, 30, 50]


def fmt(n):
    """Zahlenformat wie im HUD: 3 signifikante Stellen + Suffix."""
    sfx = ["", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc",
           "Ud", "Dd", "Td", "Qad", "Qid", "Sxd", "Spd", "Ocd", "Nod", "Vg"]
    if n < 1000:
        return str(int(n))
    e = min(int(math.log10(n) // 3), len(sfx) - 1)
    v = float(f"{n / 10 ** (3 * e):.3g}")
    if v >= 1000 and e < len(sfx) - 1:
        e, v = e + 1, v / 1000
    s = f"{v:.2f}" if v < 10 else (f"{v:.1f}" if v < 100 else f"{v:.0f}")
    return s + sfx[e]


class Creature:
    __slots__ = ("r", "lvl", "gen", "combo")

    def __init__(self, r, combo, lvl=1, gen=0):
        self.r, self.lvl, self.gen, self.combo = r, lvl, gen, combo

    def income(self):
        return P["income_base"][self.r] * P["level_mult"] ** (self.lvl - 1) * (1 + P["gen_bonus"] * self.gen)

    def power(self):
        return P["power_base"][self.r] * P["level_mult"] ** (self.lvl - 1) * (1 + P["gen_bonus"] * self.gen)

    def lvl_cost(self):
        return P["income_base"][self.r] * P["level_cost_factor"] * P["level_cost_growth"] ** (self.lvl - 1)


class Sim:
    def __init__(self, seed):
        self.rng = random.Random(seed)
        self.t = 0
        self.coins = 0.0
        self.kerne = 0
        self.rebirths = 0
        self.creatures = []
        self.pads = P["pads_start"]
        self.totem = 0
        self.best_wave = 0
        self.index = set()          # entdeckte Kombinationen (int)
        self.base_index = set()     # (Art, Seltenheit) rein
        self.best_r = -1
        self.fusions = 0
        self.bosses = 0
        self.eggs_hatched = 0
        self.brood = []             # Liste von Fertig-Zeitpunkten + Ei-Index
        self.pity = 0
        self.fusing = []            # (fertig_t, Creature)
        self.ms = {}                # Meilensteine
        self.total_earned = 0.0
        self.last_wave_t = 0

    # --- Hilfen ----------------------------------------------------------
    def mark(self, key):
        if key not in self.ms:
            self.ms[key] = self.t

    def rb_mult(self):
        return P["rebirth_mult"] ** self.rebirths

    def idx_mult(self):
        n = len(self.index) + len(self.base_index)
        return 1 + min(P["index_bonus_cap"], n * P["index_bonus_per_entry"])

    def lvl_cap(self):
        return min(P["level_cap_max"], P["level_cap_base"] + P["level_cap_per_rebirth"] * self.rebirths)

    def pad_creatures(self):
        return sorted(self.creatures, key=lambda c: c.income(), reverse=True)[: self.pads]

    def income_ps(self):
        base = sum(c.income() for c in self.pad_creatures())
        return base * (1 + P["totem_bonus"] * self.totem) * self.rb_mult() * self.idx_mult()

    def team_power(self):
        top = sorted((c.power() for c in self.creatures), reverse=True)[:3]
        return sum(top) * self.rb_mult()

    def wave_req(self, w):
        return P["wave_base"] * P["wave_growth"] ** (w - 1) * (1 + (w - 1) / P["wave_poly"])

    def unlocked_eggs(self):
        return [i for i, e in enumerate(P["eggs"]) if e[4] <= self.rebirths]

    def add_creature(self, r, combo, pure_species=None):
        c = Creature(r, combo)
        self.creatures.append(c)
        if pure_species is not None:
            self.base_index.add((pure_species, r))
        else:
            self.index.add(combo)
        if r > self.best_r:
            self.best_r = r
            self.mark("first_" + R_SHORT[r])
        self.enforce_stall()
        return c

    def enforce_stall(self):
        cap = self.pads + P["stall_cap"]
        while len(self.creatures) > cap:
            worst = min(self.creatures, key=lambda c: c.income())
            self.creatures.remove(worst)
            self.kerne += P["release_kerne"][worst.r]

    def roll_egg(self, ei):
        odds = P["eggs"][ei][3]
        x = self.rng.random() * 100
        acc = 0
        for r, o in enumerate(odds):
            acc += o
            if x < acc:
                return r
        return max(i for i, o in enumerate(odds) if o > 0)

    def hatch(self, ei):
        r = self.roll_egg(ei)
        species = self.rng.randrange(8)
        self.eggs_hatched += 1
        self.add_creature(r, species * 73, pure_species=species)
        self.mark("first_hatch")

    def earn(self, amount):
        self.coins += amount
        self.total_earned += amount

    # --- Entscheidungen --------------------------------------------------
    def decide(self):
        inc = self.income_ps()
        opts = []  # (roi, cost, action)
        pads = self.pad_creatures()
        cap = self.lvl_cap()
        rbm = (1 + P["totem_bonus"] * self.totem) * self.rb_mult() * self.idx_mult()
        for c in pads:
            if c.lvl < cap:
                cost = c.lvl_cost()
                gain = c.income() * (P["level_mult"] - 1) * rbm
                opts.append((gain / cost, cost, ("lvl", c)))
        # Totem
        tcost = P["totem_base"] * P["totem_growth"] ** self.totem
        base = sum(c.income() for c in pads) * self.rb_mult() * self.idx_mult()
        opts.append((base * P["totem_bonus"] / tcost, tcost, ("totem", None)))
        # Pads
        if self.pads < pads_max():
            pcost = P["pad_costs"][self.pads - 2]
            spare = sorted(self.creatures, key=lambda c: c.income(), reverse=True)[self.pads:self.pads + 1]
            g = spare[0].income() * rbm if spare else 0
            if not spare:
                g = inc / max(1, len(pads)) * 0.5
            opts.append((g / pcost * 1.5, pcost, ("pad", None)))
        # Eier
        if len(self.brood) < P["brood_slots"]:
            worst_pad = min((c.income() for c in pads), default=0) if len(pads) >= self.pads else 0
            for ei in self.unlocked_eggs():
                price = P["eggs"][ei][1]
                odds = P["eggs"][ei][3]
                exp_inc = sum(o / 100 * P["income_base"][r] for r, o in enumerate(odds)) * rbm
                gain = max(0.0, exp_inc - worst_pad * rbm) + exp_inc * 0.25
                opts.append((gain / price, price, ("egg", ei)))
        opts.sort(key=lambda o: o[0], reverse=True)
        for roi, cost, act in opts[:3]:
            if cost <= self.coins:
                self.do(act, cost)
                return True
            # Sparen, wenn das beste Ziel in < 90 s erreichbar ist
            if inc > 0 and (cost - self.coins) / inc < 90:
                return False
        return False

    def do(self, act, cost):
        kind, arg = act
        self.coins -= cost
        if kind == "lvl":
            arg.lvl += 1
            self.mark("first_upgrade")
        elif kind == "totem":
            self.totem += 1
            self.mark("first_upgrade")
        elif kind == "pad":
            self.pads += 1
        elif kind == "egg":
            self.brood.append((self.t + P["eggs"][arg][2], arg))
            self.mark("first_egg_bought")

    def try_fusion(self):
        # fertige Fusionen einsammeln
        for f in [f for f in self.fusing if f[0] <= self.t]:
            self.fusing.remove(f)
            c = f[1]
            self.creatures.append(c)
            self.index.add(c.combo)
            if c.r > self.best_r:
                self.best_r = c.r
                self.mark("first_" + R_SHORT[c.r])
            self.mark("first_fusion")
        if self.best_wave < P["fusion_unlock_wave"] or len(self.fusing) >= P["fusion_slots"]:
            return
        by_r = {}
        for c in self.creatures:
            by_r.setdefault(c.r, []).append(c)
        floor_r = max(0, self.best_r - 3)
        for r in sorted(by_r):
            group = sorted(by_r[r], key=lambda c: c.power())
            if r < floor_r or len(group) < 2 or r >= 6:
                continue
            ccost = P["income_base"][r] * P["fusion_coin_s"] * self.rb_mult()
            kcost = P["fusion_kerne"][r]
            if self.coins < ccost or self.kerne < kcost:
                continue
            a, b = group[0], group[1]
            self.coins -= ccost
            self.kerne -= kcost
            self.creatures.remove(a)
            self.creatures.remove(b)
            if r == 5:
                up = self.rebirths >= P["secret_recipe_rebirth"] and self.rng.random() < P["secret_recipe_chance"]
            else:
                self.pity += 1
                up = self.rng.random() < P["resonance_chance"] or self.pity >= P["resonance_pity"]
                if up:
                    self.pity = 0
            nr = r + 1 if up else r
            gen = min(P["gen_cap"], max(a.gen, b.gen) + 1)
            c = Creature(nr, self.rng.randrange(P["hybrid_combos"]), max(a.lvl, b.lvl), gen)
            self.fusing.append((self.t + P["fusion_time_s"][r], c))
            self.fusions += 1
            self.mark("first_fusion_started")
            return

    def wave(self):
        tp = self.team_power()
        nxt = self.best_wave + 1
        hype = self.rng.choices([h for h, _ in P["hype_dist"]], [p for _, p in P["hype_dist"]])[0]
        inc = self.income_ps()
        if tp * 1.5 >= self.wave_req(nxt):
            if tp * hype >= self.wave_req(nxt):
                self.best_wave = nxt
                self.earn(inc * P["wave_first_income_s"] + P["wave_first_flat"] * P["wave_flat_growth"] ** nxt)
                self.kerne += P["wave_first_kerne_base"] + nxt // 10
                self.mark("first_wave")
                if nxt % 10 == 0 and self.unlocked_eggs():
                    self.hatch(self.unlocked_eggs()[-1])      # Meilenstein-Ei alle 10 Wellen
                return
        # farmen (Welle, die sicher gewonnen wird) oder Trostpreis
        self.earn(inc * P["wave_replay_income_s"])
        self.kerne += P["wave_replay_kerne"]

    def boss(self):
        inc = self.income_ps()
        self.earn(inc * P["boss_income_s"])
        self.kerne += P["boss_kerne"] + self.bosses // 5
        if P["boss_free_egg"]:
            self.hatch(self.unlocked_eggs()[-1])
        self.bosses += 1
        self.mark("first_boss")

    def try_rebirth(self):
        n = self.rebirths
        cost = P["rebirth_base"] * P["rebirth_growth"] ** n
        if self.coins >= cost and self.best_wave >= P["rebirth_wave_req"] + P["rebirth_wave_step"] * n:
            self.rebirths += 1
            keep = min(P["rebirth_keep_base"] + self.rebirths, pads_max())
            ranked = sorted(self.creatures, key=lambda c: c.power(), reverse=True)
            for c in ranked[keep:]:
                self.kerne += P["release_kerne"][c.r]
            self.creatures = ranked[:keep]
            for c in self.creatures:
                c.lvl = 1
            self.coins = 0.0
            self.totem = 0
            for f in self.fusing:
                self.creatures.append(f[1])
            self.fusing = []
            self.mark("first_rebirth" if n == 0 else f"rebirth_{n + 1}")

    # --- Hauptschleife ---------------------------------------------------
    def run(self, until_s, checkpoints):
        out = []
        cps = sorted(checkpoints)
        ci = 0
        while self.t <= until_s:
            # Tutorial
            if self.t == P["tut_free_egg_at"]:
                self.brood.append((self.t + 5, 0))
            if self.t == P["tut_wave1_at"]:
                self.best_wave = max(self.best_wave, 1)
                self.earn(P["tut_wave1_coins"])
                self.kerne += P["tut_wave1_kerne"]
                self.brood.append((self.t + 3, 0))
                self.mark("first_wave")
            # Brut
            done = [b for b in self.brood if b[0] <= self.t]
            for b in done:
                self.brood.remove(b)
                self.hatch(b[1])
                if "first_reward" not in self.ms:
                    self.mark("first_reward")
            # Einkommen
            self.earn(self.income_ps())
            # Entscheidungen alle 5 s
            if self.t % 5 == 0:
                for _ in range(4):
                    if not self.decide():
                        break
                self.try_fusion()
                self.try_rebirth()
            # Wellen
            if self.t > 60 and self.t - self.last_wave_t >= P["wave_cycle_s"]:
                self.last_wave_t = self.t
                self.wave()
            # Boss
            if self.t >= P["boss_unlock_s"] and (self.t - P["boss_offset_s"]) % P["boss_period_s"] == 0:
                self.boss()
            if ci < len(cps) and self.t >= cps[ci]:
                out.append(self.snapshot(cps[ci]))
                ci += 1
            self.t += 1
        return out

    def snapshot(self, t):
        return {
            "horizon_h": round(t / 3600, 2),
            "coins": self.coins,
            "coins_fmt": fmt(self.coins),
            "income_per_s": fmt(self.income_ps()),
            "total_earned": fmt(self.total_earned),
            "creatures_owned": len(self.creatures),
            "best_rarity": RARITIES[self.best_r] if self.best_r >= 0 else "-",
            "rebirths": self.rebirths,
            "wave_reached": self.best_wave,
            "team_power": fmt(self.team_power()),
            "index_entries": len(self.index) + len(self.base_index),
            "fusions_total": self.fusions,
            "bosses_joined": self.bosses,
            "eggs_hatched": self.eggs_hatched,
        }


def mmss(s):
    if s is None:
        return "-"
    h, rem = divmod(int(s), 3600)
    m, sec = divmod(rem, 60)
    return f"{h}:{m:02d}:{sec:02d}" if h else f"{m}:{sec:02d}"


def params_markdown():
    rows = ["| Parameter | Wert |", "|---|---|"]
    for k, v in P.items():
        if k == "eggs":
            continue
        rows.append(f"| `{k}` | {v} |")
    rows.append("")
    rows.append("| Ei | Preis | Brutzeit | Quoten C/U/R/E/L/M/S (%) | ab Rebirth |")
    rows.append("|---|---|---|---|---|")
    for name, price, hs, odds, rb in P["eggs"]:
        rows.append(f"| {name} | {fmt(price)} | {hs} s | {' / '.join(str(o) for o in odds)} | {rb} |")
    return "\n".join(rows)


def _type_ok(old, new):
    num = (int, float)
    if isinstance(old, bool) or isinstance(new, bool):
        return isinstance(old, bool) and isinstance(new, bool)
    if isinstance(old, num):
        return isinstance(new, num)
    if isinstance(old, (list, tuple)):
        return isinstance(new, (list, tuple))
    return isinstance(new, type(old))


def apply_overrides(overrides):
    """Setzt Overrides in P; prueft Schluessel, Typ und Pad-Konsistenz. Gibt Liste 'key=alt->neu' zurueck."""
    log = []
    for key, val in overrides:
        if key not in P:
            sys.exit(f"FEHLER: unbekannter Parameter '{key}'. Gueltig: {', '.join(P)}")
        if not _type_ok(P[key], val):
            sys.exit(f"FEHLER: '{key}' erwartet {type(P[key]).__name__}, bekam {type(val).__name__} ({val!r})")
        if key == "eggs":
            val = [tuple(e) for e in val]
        log.append(f"{key}={P[key]!r}->{val!r}")
        P[key] = val
    if P["pads_max"] < P["pads_start"]:
        sys.exit("FEHLER: pads_max < pads_start")
    if P["pads_start"] + len(P["pad_costs"]) < P["pads_max"]:
        sys.exit(f"FEHLER: pads_max={P['pads_max']} braucht {P['pads_max'] - P['pads_start']} Werte in pad_costs, "
                 f"vorhanden {len(P['pad_costs'])}")
    return log


def parse_args(argv):
    a = {"runs": 1, "out": None, "dump": None, "show": False, "overrides": []}
    json_files, sets = [], []
    i = 0
    while i < len(argv):
        arg = argv[i]
        nxt = argv[i + 1] if i + 1 < len(argv) else None
        if arg == "--runs" and nxt:
            a["runs"] = int(nxt); i += 2
        elif arg == "--out" and nxt:
            a["out"] = nxt; i += 2
        elif arg == "--dump-json" and nxt:
            a["dump"] = nxt; i += 2
        elif arg == "--show-params":
            a["show"] = True; i += 1
        elif arg == "--params":
            if nxt and not nxt.startswith("--") and nxt.lower().endswith(".json"):
                json_files.append(nxt); i += 2
            else:
                a["show"] = True; i += 1
        elif arg == "--set" and nxt:
            if "=" not in nxt:
                sys.exit(f"FEHLER: --set erwartet key=wert, bekam '{nxt}'")
            k, v = nxt.split("=", 1)
            try:
                val = json.loads(v)
            except ValueError:
                val = v   # reiner Text
            sets.append((k.strip(), val)); i += 2
        elif arg in ("-h", "--help"):
            print(__doc__); sys.exit(0)
        else:
            sys.exit(f"FEHLER: unbekanntes Argument '{arg}' (Hilfe: --help)")
    for jf in json_files:
        with open(jf, encoding="utf-8") as f:
            data = json.load(f)
        if not isinstance(data, dict):
            sys.exit(f"FEHLER: {jf} muss ein JSON-Objekt sein")
        a["overrides"].extend(data.items())
    a["overrides"].extend(sets)
    return a


def main():
    here = os.path.dirname(os.path.abspath(__file__))
    args = parse_args(sys.argv[1:])
    changes = apply_overrides(args["overrides"])
    if args["dump"]:
        with open(args["dump"], "w", encoding="utf-8") as f:
            json.dump(P, f, indent=1, ensure_ascii=False)
        print(f"Parameter-JSON geschrieben: {args['dump']}")
    if args["show"]:
        print(params_markdown())
        return
    if args["dump"] and not changes and args["out"] is None and args["runs"] == 1 and "--runs" not in sys.argv:
        return   # reiner Export
    runs = args["runs"]
    cps = [int(h * 3600) for h in HORIZONS_H]
    all_rows, all_ms = [], []
    for seed in range(7, 7 + runs):
        s = Sim(seed)
        rows = s.run(max(cps), cps)
        all_rows.append(rows)
        all_ms.append(s.ms)
    rows = all_rows[0]
    if args["out"]:
        path = args["out"]
    elif changes:
        stamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        path = os.path.join("research", "sim", f"sim_{stamp}.csv")
    else:
        path = os.path.join(here, "economy_sim_output.csv")
    ref = os.path.abspath(os.path.join(here, "economy_sim_output.csv"))
    if changes and os.path.abspath(path) == ref:
        sys.exit("FEHLER: Mit Overrides darf die Referenzdatei data/economy_sim_output.csv nicht ueberschrieben werden.")
    os.makedirs(os.path.dirname(os.path.abspath(path)), exist_ok=True)
    with open(path, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w.writeheader()
        for r in rows:
            r = dict(r)
            r["coins"] = f"{r['coins']:.0f}"
            w.writerow(r)
    if changes:
        print("Overrides aktiv:")
        for c in changes:
            print(f"  {c}")
        print()
    print("Checkpoints (Seed 7):")
    hdr = ["h", "Muenzen", "Eink./s", "Brainrots", "Beste", "Rebirths", "Welle", "Index", "Fusionen", "Bosse"]
    print(" | ".join(hdr))
    for r in rows:
        print(" | ".join(str(x) for x in [r["horizon_h"], r["coins_fmt"], r["income_per_s"], r["creatures_owned"],
                                           r["best_rarity"], r["rebirths"], r["wave_reached"], r["index_entries"],
                                           r["fusions_total"], r["bosses_joined"]]))
    print("\nMeilensteine (Seed 7):")
    keys = ["first_reward", "first_upgrade", "first_egg_bought", "first_fusion", "first_boss", "first_U", "first_R",
            "first_E", "first_L", "first_M", "first_S", "first_rebirth", "rebirth_2", "rebirth_5", "rebirth_10",
            "rebirth_15", "rebirth_20"]
    for k in keys:
        print(f"  {k:18s} {mmss(all_ms[0].get(k))}")
    if runs > 1:
        print(f"\nStreuung ueber {runs} Seeds (Median / Min / Max):")
        for k in keys:
            vals = [m[k] for m in all_ms if k in m]
            if vals:
                print(f"  {k:18s} {mmss(statistics.median(vals))} / {mmss(min(vals))} / {mmss(max(vals))}"
                      f"  (erreicht in {len(vals)}/{runs})")
        for i, h in enumerate(HORIZONS_H):
            if h in (1, 10, 50):
                rb = [rr[i]["rebirths"] for rr in all_rows]
                wv = [rr[i]["wave_reached"] for rr in all_rows]
                print(f"  {h:>4} h: Rebirths {statistics.median(rb)} ({min(rb)}-{max(rb)}), "
                      f"Welle {statistics.median(wv)} ({min(wv)}-{max(wv)})")
    print(f"\nCSV geschrieben: {path}")


if __name__ == "__main__":
    main()
