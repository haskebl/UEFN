# =====================================================================
# REFERENZ — UNGEPRÜFT bis in UEFN kompiliert
# Datei: ftb_combat.verse  (FUSE THE BRAINROT)
# Zweck: Wellen (Solo am Plot, GDD §2.4.3), Auto-Battle als abstrakte
#        Simulation (0,25-s-Tick), Hype-Takt-Timing (§2.4.2) und
#        Koop-Server-Boss mit Teilnahme-Belohnung (§2.4.4, §5.7).
# Keine Schadenszahlen in der Welt (UNVERIFIED) -> nur HUD-Werte.
# =====================================================================

using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }                # GetFortCharacter[]: VERIFIED
using { /Verse.org/Simulation }                   # GetSimulationElapsedTime, Sleep: VERIFIED
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/Diagnostics }

CombatTick:float = 0.25
BeatPeriod:float = 3.0          # alle 3,0 s ein Takt-Ring
BeatShrink:float = 1.2          # Ring schrumpft in 1,2 s auf Zielkreis
LatencyComp:float = 0.1         # +100 ms auf den Zielzeitpunkt (serverseitig)
PerfectWindow:float = 0.15      # ±150 ms (Messung W4: ggf. 0,25)
GoodWindow:float = 0.35         # ±350 ms (Messung W4: ggf. 0,50)
HubCenter:vector3 = vector3{X := 0.0, Y := 0.0, Z := 0.0}
HypeZoneRadius:float = 3000.0   # Außenradius Hype-Zone-Ring (GDD §2.4.4/§11)
HypeZoneInner:float = 2000.0    # Innenradius: Ring r = 2.000–3.000 (Bauplan M3-05), NICHT die Scheibe

# --------------------------- Formeln ---------------------------------
WaveStrength(W:int)<transacts>:float =
    WaveBase * Pow(WaveGrowth, 1.0 * (W - 1)) * (1.0 + (1.0 * (W - 1)) / WavePoly)

WaveTotalHP(W:int)<transacts>:float = WaveFightSeconds * WaveStrength(W)

WaveEnemyCount(W:int)<transacts>:int = Min(8, 3 + (if (Q := Quotient[W, 10]) then Q else 0))
IsTankWave(W:int)<decides><computes>:void = Mod[W, 5] = 0
IsMiniBossWave(W:int)<decides><computes>:void = Mod[W, 10] = 0

# Kampfkraft KK (GDD §2.4.3): Power_base · 1,15^(L−1) · (1+0,08·Gen) · Rebirth · Rollenfaktor
CreaturePower(C:ftb_creature, Rebirths:int)<transacts>:float =
    Base := AtF(PowerBase, C.Rarity) * Pow(LevelMult, 1.0 * (C.Level - 1)) * (1.0 + GenBonus * C.Gen)
    Role := AtF(SpeciesAtkFactor, C.Head - 1) * AtF(SpeciesSpeedFactor, C.Body - 1)
    Purity := if (C.Head = C.Body, C.Body = C.Acc) then 1.1 else 1.0   # Reinheits-Bonus §4.8
    Secret := if (HasBitInt[C.Flags, 2]) then 1.25 else 1.0
    Base * Role * Purity * Secret * RebirthMultFor(Rebirths)

CreatureHP(C:ftb_creature)<transacts>:float =
    AtF(PowerBase, C.Rarity) * 5.0 * AtF(SpeciesHpFactor, C.Body - 1) * Pow(LevelMult, 1.0 * (C.Level - 1))

# Team = 3 stärkste Pad-Kreaturen; fixierte (Flag-Bit 1) haben Vorrang.
SelectTeam(S:ftb_player_state)<transacts>:[]int =
    var Team:[]int = array{}
    for (Slot : S.PadSlots, Slot >= 0, C := S.Creatures[Slot], HasBitInt[C.Flags, 1], Team.Length < 3):
        set Team += array{Slot}
    loop:
        if (Team.Length >= 3):
            break
        var BestSlot:int = -1
        var BestKK:float = -1.0
        for (Slot : S.PadSlots, Slot >= 0, not Contains[Team, Slot], C := S.Creatures[Slot]):
            KK := CreaturePower(C, S.Rebirths)
            if (KK > BestKK):
                set BestKK = KK
                set BestSlot = Slot
        if (BestSlot < 0):
            break
        set Team += array{BestSlot}
    Team

Contains(A:[]int, X:int)<decides><transacts>:void =
    var Hit:logic = false
    for (V : A, V = X):
        set Hit = true
    Hit?

TeamPower(S:ftb_player_state)<transacts>:float =
    var Sum:float = 0.0
    for (Slot : SelectTeam(S), C := S.Creatures[Slot]):
        set Sum += CreaturePower(C, S.Rebirths)
    Sum

# Hype-Fenster-Breite: Diskolama-Accessoire im Team +20 %, Event W6 +30 %.
HypeWidenFactor(S:ftb_player_state, EventWiden:float)<transacts>:float =
    var F:float = 1.0 + EventWiden
    for (Slot : SelectTeam(S), C := S.Creatures[Slot], TraitStrength(C, SpeciesDiskolama) > 0.0):
        set F = 1.0 + EventWiden + 0.2
    F

# --------------------------- Hype-Takt --------------------------------
# Press kommt über input_trigger_device (LIKELY: "Fire" wählbar) oder
# Fallback-UI-Button (VERIFIED). Nur der ERSTE Druck je Takt zählt.
hype_press := struct:
    Beat:int = -1
    Time:float = 0.0

ftb_hype_tracker := class:
    var Presses:[player]hype_press = map{}

    BeatIndex(Start:float, Now:float)<transacts>:int =
        if (B := Floor[(Now - Start) / BeatPeriod]) then B else -1

    RegisterPress(P:player, Start:float, Now:float)<transacts>:void =
        B := BeatIndex(Start, Now)
        if (Old := Presses[P], Old.Beat = B):
            return   # Spam-Schutz
        if (set Presses[P] = hype_press{Beat := B, Time := Now}) {}

    # Nach Ablauf des Fensters aufrufen. Rückgabe ×1,0 / ×1,25 / ×1,5 und Ergebnis-Code.
    Evaluate(P:player, Start:float, Beat:int, Widen:float)<transacts>:tuple(float, int) =
        Target := Start + BeatPeriod * Beat + BeatShrink + LatencyComp
        if (Pr := Presses[P], Pr.Beat = Beat):
            D := Abs(Pr.Time - Target)
            if (D <= PerfectWindow * Widen):
                return (1.5, 2)
            if (D <= GoodWindow * Widen):
                return (1.25, 1)
        (1.0, 0)

# --------------------------- Welle (Solo) -----------------------------
wave_result := struct:
    Won:logic = false
    Wave:int = 1
    Perfects:int = 0
    DamageDone:float = 0.0

# Abstrakte Simulation: HP = 25·W(w), Schaden/Tick = ΣKK · Hype · Tick.
# Callback-Punkte (UI/Lunges) steuert ftb_game_manager über Rückgabewerte.
RunWave(S:ftb_player_state, Pool:ftb_plot_pool, Tracker:ftb_hype_tracker, Wave:int, EventWiden:float)<suspends>:wave_result =
    HP := WaveTotalHP(Wave)
    var Left:float = HP
    var Perfects:int = 0
    Start := GetSimulationElapsedTime()
    Widen := HypeWidenFactor(S, EventWiden)
    KK := TeamPower(S)
    var LastBeat:int = -1
    var Elapsed:float = 0.0
    loop:
        if (Left <= 0.0 or Elapsed >= WaveFightSeconds):
            break
        Sleep(CombatTick)
        set Elapsed += CombatTick
        Now := GetSimulationElapsedTime()
        # Takt auswerten, sobald das "Gut"-Fenster des Takts vorbei ist
        B := Tracker.BeatIndex(Start, Now - BeatShrink - LatencyComp - GoodWindow * Widen)
        if (B > LastBeat, B >= 0):
            set LastBeat = B
            Res := Tracker.Evaluate(S.Agent, Start, B, Widen)
            set S.HypeMult = Res(0)
            if (Res(1) = 2):
                set Perfects += 1
                # Smash-Lunge der Team-Kreaturen (max. 3 gleichzeitig pro Plot)
                Team := SelectTeam(S)
                for (Pad -> Slot : S.PadSlots, Slot >= 0, Contains[Team, Slot], C := S.Creatures[Slot]):
                    spawn{ Pool.Lunge(Pad, C, 120.0) }
        set Left -= KK * S.HypeMult * CombatTick
    set S.HypeMult = 1.0
    wave_result{Won := (if (Left <= 0.0) then true else false), Wave := Wave, Perfects := Perfects, DamageDone := HP - Max(0.0, Left)}

# --------------------------- Server-Boss ------------------------------
boss_participant := class:
    State:ftb_player_state
    var Damage:float = 0.0
    var Presses:int = 0
    var PresentSec:float = 0.0
    var JoinedAt:float = 0.0

boss_outcome := struct:
    Defeated:logic = false
    HpFraction:float = 0.0       # abgezogener HP-Anteil 0..1

ftb_boss_director := class:
    var Participants:[]boss_participant = array{}
    var MaxHP:float = 1.0
    var HP:float = 1.0
    var SyncUntil:float = 0.0
    var BossesDone:int = 0

    NextBossTime(Now:float)<transacts>:float =
        K := if (N := Floor[(Now - BossOffsetSeconds) / BossPeriodSeconds]) then N + 1 else 1
        BossOffsetSeconds + BossPeriodSeconds * K

    # HP = 60 s · Σ (KK_Team · 1,25); in den ersten 20 s bei Beitritt neu rechnen.
    RecalcHP()<transacts>:void =
        var Sum:float = 0.0
        for (Pt : Participants):
            set Sum += TeamPower(Pt.State) * 1.25
        Ratio := if (MaxHP > 0.0) then HP / MaxHP else 1.0
        set MaxHP = Max(1.0, 60.0 * Sum)
        set HP = MaxHP * Ratio

    # Ring in der xy-Ebene: 2.000 ≤ Abstand ≤ 3.000 (Höhe egal, Boss-Landekreis r = 1.500 zählt nicht).
    InHypeZone(P:player)<transacts>:logic =
        if (Ch := P.GetFortCharacter[]):
            D := Ch.GetTransform().Translation - HubCenter
            Dxy := Sqrt(D.X * D.X + D.Y * D.Y)
            if (Dxy >= HypeZoneInner and Dxy <= HypeZoneRadius) then true else false
        else false

    Run(Tracker:ftb_hype_tracker, Players:[]ftb_player_state)<suspends>:boss_outcome =
        Start := GetSimulationElapsedTime()
        set Participants = for (S : Players, S.PlaySeconds >= BossUnlockSeconds) { boss_participant{State := S, JoinedAt := Start} }
        set MaxHP = 1.0
        set HP = 1.0
        RecalcHP()
        var Elapsed:float = 0.0
        var LastBeat:int = -1
        # Phasen bei 66 % / 33 % HP: je 8 s Sync-Smash-Phase
        var NextPhase:int = 0
        var SyncPhaseUntil:float = 0.0
        # TODO(GDD §2.4.4): Stampf-Angriff alle 10 s -> schwächste Kreatur je Team
        #   5 s KO, wenn HP < 0,3 × Ø-Team-HP (CreatureHP). Braucht KO-Liste im Zustand.
        loop:
            if (HP <= 0.0 or Elapsed >= BossDurationSeconds):
                break
            Sleep(CombatTick)
            set Elapsed += CombatTick
            Now := GetSimulationElapsedTime()
            if (Elapsed <= 20.0):
                RecalcHP()
            B := Tracker.BeatIndex(Start, Now - BeatShrink - LatencyComp - GoodWindow)
            var PerfectCount:int = 0
            NewBeat := if (B > LastBeat, B >= 0) then true else false
            if (NewBeat?):
                set LastBeat = B
            for (Pt : Participants):
                set Pt.PresentSec += CombatTick
                if (NewBeat?):
                    Res := Tracker.Evaluate(Pt.State.Agent, Start, B, 1.0)
                    set Pt.State.HypeMult = Res(0)
                    if (Res(1) > 0):
                        set Pt.Presses += 1
                    if (Res(1) = 2):
                        set PerfectCount += 1
                Zone := if (InHypeZone(Pt.State.Agent)?) then 1.25 else 1.0
                Sync := if (Now < SyncUntil) then 2.0 else 1.0
                Dmg := TeamPower(Pt.State) * Pt.State.HypeMult * Zone * Sync * CombatTick
                set Pt.Damage += Dmg
                set HP -= Dmg
            Ratio := HP / MaxHP
            if (Threshold := array{0.66, 0.33}[NextPhase], Ratio <= Threshold):
                set NextPhase += 1
                set SyncPhaseUntil = Now + 8.0
            # Sync-Smash: ≥ 50 % Perfekt im selben Takt -> ×2 für 5 s (solo: eigenes Perfekt)
            if (Now < SyncPhaseUntil, NewBeat?, PerfectCount > 0, 2 * PerfectCount >= Participants.Length):
                set SyncUntil = Now + 5.0
        set BossesDone += 1
        boss_outcome{Defeated := (if (HP <= 0.0) then true else false), HpFraction := Min(1.0, Max(0.0, 1.0 - HP / MaxHP))}

    # Belohnung (GDD §2.4.4 / §5.7): Teilnahme = ≥1 Takt-Druck oder ≥20 s anwesend.
    Qualifies(Pt:boss_participant)<decides><transacts>:void =
        (Pt.Presses >= 1 or Pt.PresentSec >= 20.0)

    RewardCoins(Pt:boss_participant, O:boss_outcome, CatchUp:logic)<transacts>:float =
        Frac := if (O.Defeated?) then 1.0 else Max(0.6, O.HpFraction)
        Bonus := if (CatchUp?) then 1.5 else 1.0     # Aufhol-Hilfe §8 (nur Münzen)
        IncomePerSecondBase(Pt.State) * BossIncomeSeconds * Frac * Bonus

    RewardKerne(PlayerBosses:int)<transacts>:int =
        Min(BossKerneMax, BossKerneBase + (if (Q := Quotient[PlayerBosses, 5]) then Q else 0))
