# =====================================================================
# REFERENZ — UNGEPRÜFT bis in UEFN kompiliert
# Datei: ftb_economy.verse  (FUSE THE BRAINROT)
# Zweck: Einkommens-Tick, Kostenkurven, Ei-Quoten mit Pity, Rebirth-Formeln
#        und Zahlenformat FormatBig (1:1-Port von fmt() in economy_sim.py).
# Formeln: GDD §5.3, §5.6, §5.7, §4.3. Werte kommen aus ftb_types.verse.
# =====================================================================

using { /Verse.org/Simulation }
using { /Verse.org/Random }                       # GetRandomFloat: VERIFIED (Modul), Signatur LIKELY
using { /UnrealEngine.com/Temporary/Diagnostics }

# Pow(float, float):float, Floor[]/Round[]/Ceil[] (failable -> int),
# Min/Max: VERIFIED (Verse-Standardbibliothek).

AtF(A:[]float, I:int)<transacts>:float = if (V := A[I]) then V else 0.0
AtI(A:[]int, I:int)<transacts>:int = if (V := A[I]) then V else 0

RebirthMultFor(Rebirths:int)<transacts>:float = Pow(RebirthMult, 1.0 * Rebirths)

LevelCap(Rebirths:int)<transacts>:int = Min(LevelCapMax, LevelCapBase + LevelCapPerRebirth * Rebirths)

# Einkommen einer Kreatur ohne globale Multiplikatoren (GDD §4.6 "Werte des Ergebnisses")
CreatureIncome(C:ftb_creature)<transacts>:float =
    Base := AtF(IncomeBase, C.Rarity) * AtF(SpeciesIncomeFactor, C.Body - 1)
    Lvl := Pow(LevelMult, 1.0 * (C.Level - 1))
    GenF := 1.0 + GenBonus * C.Gen
    # Geheim-Rezept: ×1,25 (GDD §4.8), Flag-Bit 2
    Secret := if (HasBitInt[C.Flags, 2]) then 1.25 else 1.0
    Base * Lvl * GenF * Secret

IndexEntries(S:ftb_player_state)<transacts>:int =
    CountBits(S.IndexBits) + CountBits(S.BaseIdx) + CountBits(S.EventIdx) + CountBits(array{S.SecretIdx})

IndexMult(S:ftb_player_state)<transacts>:float =
    1.0 + Min(IndexBonusCap, IndexBonusPerEntry * IndexEntries(S))

# IIT-Münz-Multiplikator: additiv, gedeckelt ×2,5 (GDD §5.5 Punkt 8).
# Offer-Bits siehe ftb_shop_iit.verse (Bit 3 = Münz-Magnet).
IITCoinMult(S:ftb_player_state)<transacts>:float =
    var M:float = 1.0
    if (HasBitInt[S.IITMirror, 3]):
        set M += IITCoinMagnetBonus
    if (S.CoinRushSeconds > 0.0):
        set M += IITCoinRushBonus
    Min(IITCoinMultCap, M)

# Grund-Einkommen/s aller Pad-Kreaturen inkl. Totem, Rebirth, Index (GDD §5.3).
# Ohne IIT-Boost und ohne Dös-Faktor: Das ist die Basis für "N s Einkommen"-Belohnungen.
IncomePerSecondBase(S:ftb_player_state)<transacts>:float =
    var Sum:float = 0.0
    for (Slot : S.PadSlots, Slot >= 0, C := S.Creatures[Slot]):
        set Sum += CreatureIncome(C)
    Sum * (1.0 + TotemBonus * S.Totem) * RebirthMultFor(S.Rebirths) * IndexMult(S)

# Pad-Einkommen pro Tick mit IIT-Boost und Dös-Regel (GDD §8).
IncomePerSecondLive(S:ftb_player_state, Now:float)<transacts>:float =
    Idle := if (Now - S.LastInputAt > IdleAfterSeconds) then IdleIncomeMult else 1.0
    IncomePerSecondBase(S) * IITCoinMult(S) * Idle

# Einkommens-Tick: vom Game-Manager 1× pro Sekunde je Spieler aufgerufen.
# Server schickt 1 Hz, UI interpoliert (GDD §5.4).
IncomeTick(S:ftb_player_state, Now:float, Dt:float)<transacts>:float =
    Gain := IncomePerSecondLive(S, Now) * Dt
    set S.Coins += Gain
    if (Now - S.LastInputAt <= IdleAfterSeconds):
        set S.SessionActiveSec += Dt
        set S.PlaySeconds += Dt
        # Münz-Rausch läuft nur in AKTIVEN Minuten ab (GDD §9 Angebot 14)
        if (S.CoinRushSeconds > 0.0):
            set S.CoinRushSeconds = Max(0.0, S.CoinRushSeconds - Dt)
    Gain

# --------------------------- Kosten ----------------------------------
LevelUpCost(C:ftb_creature)<transacts>:float =
    AtF(IncomeBase, C.Rarity) * LevelCostFactor * Pow(LevelCostGrowth, 1.0 * (C.Level - 1))

TotemCost(Totem:int)<transacts>:float = TotemBase * Pow(TotemGrowth, 1.0 * Totem)

# Pad N (0-basiert) freischalten; Pads 0..1 sind gratis.
PadCost(PadIndex:int)<transacts>:float = AtF(PadCosts, PadIndex - PadsStart)

FusionCoinCost(ParentRarity:int, Rebirths:int)<transacts>:float =
    FusionCoinSeconds * AtF(IncomeBase, ParentRarity) * RebirthMultFor(Rebirths)

FusionKerneCost(ParentRarity:int)<transacts>:int = AtI(FusionKerne, ParentRarity)

RebirthCost(Rebirths:int)<transacts>:float = RebirthBase * Pow(RebirthGrowth, 1.0 * Rebirths)
RebirthWaveNeeded(Rebirths:int)<transacts>:int = RebirthWaveReq + RebirthWaveStep * Rebirths

CanRebirth(S:ftb_player_state)<decides><transacts>:void =
    S.Coins >= RebirthCost(S.Rebirths)
    S.BestWave >= RebirthWaveNeeded(S.Rebirths)

RebirthProgress(S:ftb_player_state)<transacts>:float =
    Min(1.0, S.Coins / RebirthCost(S.Rebirths))

# --------------------------- Eier (GDD §4.3) --------------------------
# Quoten in Prozent, 8 Eier × 7 Seltenheiten, Zeile = Ei-Stufe.
EggOdds:[][]float = array{
    array{80.0, 18.0, 2.0, 0.0, 0.0, 0.0, 0.0},
    array{40.0, 42.0, 15.0, 3.0, 0.0, 0.0, 0.0},
    array{0.0, 45.0, 40.0, 13.0, 2.0, 0.0, 0.0},
    array{0.0, 0.0, 50.0, 38.0, 11.0, 1.0, 0.0},
    array{0.0, 0.0, 0.0, 60.0, 36.0, 3.99, 0.01},
    array{0.0, 0.0, 0.0, 0.0, 70.0, 29.95, 0.05},
    array{0.0, 0.0, 0.0, 0.0, 55.0, 44.8, 0.2},
    array{0.0, 0.0, 0.0, 0.0, 30.0, 69.5, 0.5}}

HighestUnlockedEgg(Rebirths:int)<transacts>:int =
    var Best:int = 0
    for (I -> Req : EggRebirthReq, Req <= Rebirths):
        set Best = I
    Best

# "Zweithöchste Stufe dieses Eis" = Pity-Ziel (GDD §4.3 Glücks-Zähler).
PityTargetRarity(Tier:int)<transacts>:int =
    var Top:int = 0
    var Second:int = 0
    if (Row := EggOdds[Tier]):
        for (R -> P : Row, P > 0.0):
            set Second = Top
            set Top = R
    Second

# Würfelt eine Seltenheit; aktualisiert den Pity-Zähler im Zustand.
# SecretMult: ×2 in Event-Woche 7 (GDD §7.4), sonst 1.0.
RollEggRarity(S:ftb_player_state, Tier:int, SecretMult:float)<transacts>:int =
    Target := PityTargetRarity(Tier)
    Pity := AtI(S.EggPity, Tier)
    var Result:int = 0
    if (Pity + 1 >= EggPityCount):
        set Result = Target
    else if (Row := EggOdds[Tier]):
        var Total:float = 0.0
        for (R -> P : Row):
            set Total += if (R = RarityMax) then P * SecretMult else P
        Roll := GetRandomFloat(0.0, Total)
        var Acc:float = 0.0
        var Done:logic = false
        for (R -> P : Row, not Done?):
            set Acc += if (R = RarityMax) then P * SecretMult else P
            if (Roll <= Acc and P > 0.0):
                set Result = R
                set Done = true
    NewPity := if (Result >= Target) then 0 else Pity + 1
    if (set S.EggPity[Tier] = NewPity) {}
    Result

# --------------------------- Belohnungen (GDD §5.7) -------------------
WaveRewardCoins(S:ftb_player_state, Wave:int, First:logic, Won:logic)<transacts>:float =
    Inc := IncomePerSecondBase(S)
    if (not Won?) then Inc * WaveLostIncomeSeconds
    else if (First?) then Inc * WaveFirstIncomeSeconds + WaveFirstFlat * Pow(WaveFlatGrowth, 1.0 * Wave)
    else Inc * WaveReplayIncomeSeconds

WaveRewardKerne(Wave:int, First:logic, Won:logic)<transacts>:int =
    if (not Won?) then 0
    else if (First?, Q := Quotient[Wave, 10]) then WaveFirstKerneBase + Q
    else WaveReplayKerne

# ---------------------- Zahlenformat (GDD §5.4) -----------------------
# 3 signifikante Stellen + Suffix: 999 · 1.00K · 7.50K · 17.0K · 100K · 1.00M …
BigSuffix:[]string = array{"", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc",
                           "Ud", "Dd", "Td", "Qad", "Qid", "Sxd", "Spd", "Ocd", "Nod", "Vg"}

DecimalsFor(V:float)<transacts>:int = if (V < 10.0) then 2 else if (V < 100.0) then 1 else 0

FormatBig(X:float)<transacts>:string =
    if (X < 1000.0):
        return if (N := Floor[Max(0.0, X)]) then ToString(N) else "0"
    MaxE := BigSuffix.Length - 1
    var E:int = 0
    var V:float = X
    loop:
        if (V < 1000.0 or E >= MaxE):
            break
        set V = V / 1000.0
        set E += 1
    # Erst auf 3 signifikante Stellen runden (wie Python "{:.3g}") ...
    var Dec:int = DecimalsFor(V)
    var Scale:int = if (Dec = 2) then 100 else if (Dec = 1) then 10 else 1
    var Scaled:int = if (R := Round[V * Scale]) then R else 0
    set V = (1.0 * Scaled) / (1.0 * Scale)
    # ... Überlauf 999.5 -> 1000 in den nächsten Suffix schieben
    if (V >= 1000.0 and E < MaxE):
        set V = V / 1000.0
        set E += 1
    # ... dann Nachkommastellen neu aus dem gerundeten Wert bestimmen
    set Dec = DecimalsFor(V)
    set Scale = if (Dec = 2) then 100 else if (Dec = 1) then 10 else 1
    set Scaled = if (R := Round[V * Scale]) then R else 0
    Whole := if (Q := Quotient[Scaled, Scale]) then Q else 0
    Frac := if (M := Mod[Scaled, Scale]) then M else 0
    FracStr := if (Dec = 2 and Frac < 10) then "0{Frac}" else "{Frac}"
    Suffix := if (Sfx := BigSuffix[E]) then Sfx else "?"
    if (Dec = 0) then "{Whole}{Suffix}" else "{Whole}.{FracStr}{Suffix}"

# ---------------------- Rebirth (GDD §5.6) ----------------------------
# Behält: Index, Pads, Kerne, BestWave, IIT, die min(1+n, 6) stärksten
# Brainrots (Level 1, Gen bleibt). Rest -> Kerne (Freilassen-Wert).
# Zurück: Münzen, Level, Totem. Aufruf nur im atomaren if mit CommitSave.
ApplyRebirth(S:ftb_player_state)<transacts>:void =
    Keep := Min(RebirthKeepMax, RebirthKeepBase + S.Rebirths)
    var Rest:[]ftb_creature = S.Creatures
    var Kept:[]ftb_creature = array{}
    for (K := 1..Keep):
        var BestI:int = -1
        var BestV:float = -1.0
        for (I -> C : Rest, V := CreatureIncome(C), V > BestV):
            set BestV = V
            set BestI = I
        if (C := Rest[BestI], Before := Rest.Slice[0, BestI], After := Rest.Slice[BestI + 1]):
            set Kept += array{ftb_creature{Head := C.Head, Body := C.Body, Acc := C.Acc, Rarity := C.Rarity,
                                           Level := 1, Gen := C.Gen, Form := C.Form, Flags := C.Flags, SideAcc := C.SideAcc}}
            set Rest = Before + After
    for (C : Rest):
        set S.Kerne += AtI(ReleaseKerne, C.Rarity)
    set S.Creatures = Kept
    set S.PadSlots = for (I := 0..PadsMax - 1) { if (I < Kept.Length) then I else -1 }
    set S.Coins = 0.0
    set S.Totem = 0
    set S.Rebirths += 1
