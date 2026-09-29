# =====================================================================
# REFERENZ — UNGEPRÜFT bis in UEFN kompiliert
# Datei: ftb_game_manager.verse  (FUSE THE BRAINROT)
# Zweck: Haupt-creative_device. Verdrahtet alle Module: Join/Leave,
#        Plot-Zuweisung (16 Plots), Einkommens-Loop (1 Hz), Save-Loop (30 s),
#        Brut/Fusion-Timer, Wellen, Server-Boss, Codes, Tagesbelohnung, IIT.
# Devices im Level (je Plot): 3 button_device (KAMPF!, Ei-Automat,
#   Fusions-Maschine), 1 teleporter_device (Plot-Tor), Prop-Pool (ftb_plot_pool).
# Global: 1 input_trigger_device (Hype-Takt, "Fire" LIKELY), Code-Terminal.
# =====================================================================

using { /Fortnite.com/Devices }                   # creative_device, button_device, teleporter_device: VERIFIED
using { /Fortnite.com/Characters }
using { /Fortnite.com/Marketplace }               # LIKELY
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/Diagnostics }

ftb_plot := class<concrete>:
    @editable Pool:ftb_plot_pool = ftb_plot_pool{}
    @editable GateTeleporter:teleporter_device = teleporter_device{}
    @editable FightButton:button_device = button_device{}
    @editable EggButton:button_device = button_device{}
    @editable FusionButton:button_device = button_device{}
    var Owner:?player = false

# Verse hat keine Closures -> kleine Bindungs-Klasse trägt den Plot-Index.
ftb_plot_binding := class:
    Manager:ftb_game_manager
    PlotIndex:int
    OnFight(A:agent):void = Manager.HandleFight(A, PlotIndex)
    OnEgg(A:agent):void = Manager.HandleEgg(A, PlotIndex)
    OnFusion(A:agent):void = Manager.HandleFusionMachine(A, PlotIndex)

# Generisches Entfernen eines Map-Schlüssels (parametrische Funktion: LIKELY-Syntax)
WithoutKey(M:[k]v, Key:k where k:subtype(comparable), v:type):[k]v =
    var Out:[k]v = map{}
    for (K -> V : M, K <> Key):
        set Out = ConcatenateMaps(Out, map{K => V})
    Out

ftb_game_manager := class(creative_device, ftb_ui_events):
    @editable Plots:[]ftb_plot = array{}
    @editable HypeInput:input_trigger_device = input_trigger_device{}   # PressedEvent: LIKELY
    Time:ftb_time_source = ftb_time_source{}
    Hype:ftb_hype_tracker = ftb_hype_tracker{}
    Boss:ftb_boss_director = ftb_boss_director{}
    IIT:ftb_iit_service = ftb_iit_service{}
    var States:[player]ftb_player_state = map{}
    var Huds:[player]ftb_hud = map{}
    var FusionUIs:[player]ftb_fusion_screen = map{}
    var BeatStart:[player]float = map{}

    OnBegin<override>()<suspends>:void =
        Time.Detect()
        for (I -> Plot : Plots):
            B := ftb_plot_binding{Manager := Self, PlotIndex := I}
            Plot.FightButton.InteractedWithEvent.Subscribe(B.OnFight)
            Plot.EggButton.InteractedWithEvent.Subscribe(B.OnEgg)
            Plot.FusionButton.InteractedWithEvent.Subscribe(B.OnFusion)
            for (Pad := 0..PadsMax - 1):
                Plot.Pool.ClearPad(Pad)
        HypeInput.PressedEvent.Subscribe(OnHypePressed)
        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerAdded)       # VERIFIED
        GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerRemoved)   # VERIFIED
        for (P : GetPlayspace().GetPlayers()):
            OnPlayerAdded(P)
        sync:
            EconomyLoop()
            SaveLoop()
            BossLoop()

    # ------------------------------ Join / Leave ----------------------
    OnPlayerAdded(P:player):void =
        Now := GetSimulationElapsedTime()
        S := ftb_player_state{Agent := P}
        ApplySave(S, LoadSave(P), Now)
        set S.LastInputAt = Now
        # Plot zuweisen: erster freier
        for (I -> Plot : Plots, not Plot.Owner?, S.PlotIndex < 0):
            set Plot.Owner = option{P}
            set S.PlotIndex = I
        if (set States[P] = S) {}
        Hud := ftb_hud{Agent := P}
        Hud.Build()
        if (set Huds[P] = Hud) {}
        if (set FusionUIs[P] = ftb_fusion_screen{Agent := P, Events := Self}) {}
        spawn{ Hud.RunTicker() }
        spawn{ Hud.RunToastQueue() }
        if (Plot := Plots[S.PlotIndex]):
            Plot.GateTeleporter.Teleport(P)                   # LIKELY Signatur
            RefreshPlot(S)
            Hud.PushToast("Willkommen! Dein Plot.")
        else:
            Hud.PushToast("Server voll: Zuschauer-Modus")      # mehr Spieler als Plots
        # Neuer Spieler: skriptiertes Starter-Ei -> Waffelino (GDD §3.1)
        if (S.Creatures.Length = 0, AtI(S.Stats, 4) = 0):
            set S.Brood = array{ftb_timer_job{Payload := -1, EndsAt := Now + 5.0}}
        else:
            Bonus := ReturnBonusCoins(Time, S)
            if (Bonus > 0.0):
                set S.Coins += Bonus
                Hud.PushToast("Deine Brainrots haben {FormatBig(Bonus)} verdient!")
        # IIT: Abgleich beim Join + Abo auf Änderungen (Template-Muster, LIKELY)
        GetEntitlementsChangedEvent(P, ftb_ent_golden_nest).Subscribe(OnEntitlementsChanged)
        spawn{ IIT.SyncEntitlements(S, Now) }

    OnEntitlementsChanged(P:player):void =   # Handler-Parametertyp UNVERIFIED
        if (S := States[P]):
            spawn{ IIT.SyncEntitlements(S, GetSimulationElapsedTime()) }

    OnPlayerRemoved(P:player):void =
        if (S := States[P]):
            # Commit kann nach dem Verlassen scheitern -> deshalb periodisch speichern.
            Time.StampLastSeen(S)
            TryCommitState(S, GetSimulationElapsedTime())
            if (Plot := Plots[S.PlotIndex]):
                for (Pad := 0..PadsMax - 1):
                    Plot.Pool.ClearPad(Pad)
                set Plot.Owner = false
        set States = WithoutKey(States, P)
        set Huds = WithoutKey(Huds, P)
        set FusionUIs = WithoutKey(FusionUIs, P)

    RefreshPlot(S:ftb_player_state):void =
        if (Plot := Plots[S.PlotIndex]):
            for (Pad -> Slot : S.PadSlots):
                if (Slot >= 0, C := S.Creatures[Slot]):
                    Plot.Pool.ShowCreature(Pad, C)
                else:
                    Plot.Pool.ClearPad(Pad)

    # ------------------------------ Loops -----------------------------
    EconomyLoop()<suspends>:void =
        loop:
            Sleep(1.0)
            Now := GetSimulationElapsedTime()
            for (P -> S : States):
                IncomeTick(S, Now, 1.0)
                TickTimers(S, Now)
                if (S.SessionActiveSec >= SessionQualifySeconds, S.SessionActiveSec < SessionQualifySeconds + 1.0):
                    set S.SessionsOK += 1               # Fallback-Kalender: 1 "Tag" je Sitzung
                if (Hud := Huds[P]):
                    W := Time.EventWeek(S)
                    Tok := if (W > 0, T := S.Tokens[W - 1]) then T else 0
                    Hud.SetCurrencies(S.Coins, IncomePerSecondLive(S, Now), S.Kerne, Tok, (if (W > 0) then true else false))
                    Hud.SetGoal(GoalText(S))
                set S.Dirty = true

    SaveLoop()<suspends>:void =
        loop:
            Sleep(30.0)
            Now := GetSimulationElapsedTime()
            for (S : States, S.Dirty?):
                Time.StampLastSeen(S)
                TryCommitState(S, Now)

    BossLoop()<suspends>:void =
        loop:
            Now := GetSimulationElapsedTime()
            Next := Boss.NextBossTime(Now)
            Sleep(Max(0.0, Next - 60.0 - Now))
            for (T := 0..59):
                for (H : Huds):
                    H.SetBossPill("BOSS IN 0:{59 - T}")
                Sleep(1.0)
            BossStartAt := GetSimulationElapsedTime()
            for (P -> S : States):
                if (set BeatStart[P] = BossStartAt) {}
            Players := for (P -> S : States) { S }
            # Spieler < 8 min Spielzeit: nur Zuschauer-Kiste (30 s Einkommen), GDD §2.4.4
            for (S : Players, S.PlaySeconds < BossUnlockSeconds):
                set S.Coins += IncomePerSecondBase(S) * 30.0
            O := Boss.Run(Hype, Players)
            for (Pt : Boss.Participants, Boss.Qualifies[Pt]):
                St := Pt.State
                set St.Coins += Boss.RewardCoins(Pt, O, false)
                set St.Kerne += Boss.RewardKerne(AtI(St.Stats, 1))
                if (Old := St.Stats[1], set St.Stats[1] = Old + 1) {}
                QueueFreeEgg(St)
                if (H := Huds[St.Agent]):
                    H.PushToast(if (O.Defeated?) then "BOSS BESIEGT!" else "Boss geflohen – Trostpreis")
            for (H : Huds):
                H.SetBossPill("")

    # ------------------------------ Timer (Brut + Fusion) --------------
    TickTimers(S:ftb_player_state, Now:float):void =
        var KeepBrood:[]ftb_timer_job = array{}
        for (J : S.Brood):
            if (J.EndsAt <= Now):
                HatchEgg(S, J.Payload)
            else:
                set KeepBrood += array{J}
        set S.Brood = KeepBrood
        var KeepFuse:[]ftb_timer_job = array{}
        for (J : S.Fusing):
            if (J.EndsAt <= Now):
                AddCreature(S, UnpackCreature(J.Payload), true)
            else:
                set KeepFuse += array{J}
        set S.Fusing = KeepFuse

    # Payload -1 = skriptiertes Starter-Ei (Waffelino, Gewöhnlich)
    HatchEgg(S:ftb_player_state, Tier:int):void =
        C := if (Tier < 0) then ftb_creature{} else RollEggCreature(S, Tier)
        if (Old := S.Stats[4], set S.Stats[4] = Old + 1) {}
        AddCreature(S, C, false)

    RollEggCreature(S:ftb_player_state, Tier:int):ftb_creature =
        R := RollEggRarity(S, Tier, SecretEggMultNow(Time, S))
        # Arten mit reiner Form dieser Seltenheit (GDD §4.3)
        Lo := if (R = 4) then 1 else if (R = 5) then 5 else if (R = 6) then 7 else 1
        Hi := if (R = 4) then 4 else if (R = 5) then 6 else if (R = 6) then 8 else 8
        Sp := GetRandomInt(Lo, Hi)
        ftb_creature{Head := Sp, Body := Sp, Acc := Sp, Rarity := R}

    AddCreature(S:ftb_player_state, C:ftb_creature, IsFusion:logic):void =
        StallCap := if (HasBitInt[S.IITMirror, IITBitStallPlus]) then StallCapIIT else StallCapBase
        if (S.Creatures.Length >= StallCap + PadsMax):
            set S.Kerne += AtI(ReleaseKerne, C.Rarity)      # Stall voll -> automatisch Kerne
            return
        set S.Creatures += array{C}
        NewIdx := S.Creatures.Length - 1
        # Index-Eintrag
        if (C.Head = C.Body, C.Body = C.Acc):
            set S.BaseIdx = WithBit(S.BaseIdx, (C.Head - 1) * 5 + Min(C.Rarity, 4))
        else:
            set S.IndexBits = WithBit(S.IndexBits, HybridIndexBit(C))
        # Auf freies Pad setzen
        var Placed:logic = false
        for (Pad -> Slot : S.PadSlots, Pad < S.Pads, Slot < 0, not Placed?):
            if (set S.PadSlots[Pad] = NewIdx) {}
            set Placed = true
        RefreshPlot(S)
        spawn{ PlayReveal(S.Agent, C, IsFusion) }
        TryCommitState(S, GetSimulationElapsedTime())

    QueueFreeEgg(S:ftb_player_state):void =
        Tier := HighestUnlockedEgg(S.Rebirths)
        set S.Brood += array{ftb_timer_job{Payload := Tier, EndsAt := GetSimulationElapsedTime() + AtF(EggHatchSeconds, Tier)}}

    # ------------------------------ Welt-Knöpfe ------------------------
    StateFor(A:agent, PlotIndex:int)<decides><transacts>:ftb_player_state =
        P := player[A]
        S := States[P]
        S.PlotIndex = PlotIndex       # nur der Besitzer bedient seinen Plot
        S

    HandleEgg(A:agent, PlotIndex:int):void =
        if (S := StateFor[A, PlotIndex]):
            set S.LastInputAt = GetSimulationElapsedTime()
            Slots := BroodSlotsBase + (if (HasBitInt[S.IITMirror, IITBitGoldenNest]) then 1 else 0)
            if (S.Brood.Length >= Slots):
                return
            # Platzhalter für Ei-Automat S1: teuerstes leistbares, freigeschaltetes Ei
            var Tier:int = -1
            for (I -> Price : EggPrice, AtI(EggRebirthReq, I) <= S.Rebirths, Price <= S.Coins):
                set Tier = I
            if (Tier >= 0):
                set S.Coins -= AtF(EggPrice, Tier)
                Turbo := if (HasBitInt[S.IITMirror, IITBitTurboHatch]) then 0.5 else 1.0
                set S.Brood += array{ftb_timer_job{Payload := Tier, EndsAt := GetSimulationElapsedTime() + AtF(EggHatchSeconds, Tier) * Turbo}}

    HandleFight(A:agent, PlotIndex:int):void =
        if (S := StateFor[A, PlotIndex], Plot := Plots[PlotIndex]):
            set S.LastInputAt = GetSimulationElapsedTime()
            spawn{ FightWave(S, Plot) }

    FightWave(S:ftb_player_state, Plot:ftb_plot)<suspends>:void =
        W := S.BestWave + 1
        if (set BeatStart[S.Agent] = GetSimulationElapsedTime()) {}
        R := RunWave(S, Plot.Pool, Hype, W, HypeWidenNow(Time, S))
        First := if (R.Won?, W > S.BestWave) then true else false
        set S.Coins += WaveRewardCoins(S, W, First, R.Won)
        set S.Kerne += WaveRewardKerne(W, First, R.Won)
        if (First?):
            set S.BestWave = W
            if (IsMiniBossWave[W]):
                QueueFreeEgg(S)   # Meilenstein-Ei
        if (H := Huds[S.Agent]):
            H.PushToast(if (R.Won?) then "WELLE {W} GESCHAFFT!" else "Welle verloren – Tipp: Mehrfachtreffer!")

    # Rebirth-Terminal (S10, 2 s Halten im UI) ruft das auf.
    HandleRebirth(A:agent, PlotIndex:int):void =
        if (S := StateFor[A, PlotIndex]):
            if (CanRebirth[S], ApplyRebirth(S), CommitSave[S.Agent, BuildSave(S, GetSimulationElapsedTime())]):
                RefreshPlot(S)
                if (H := Huds[S.Agent]):
                    H.PushToast("REBIRTH! ×{RebirthMultFor(S.Rebirths)}")

    HandleFusionMachine(A:agent, PlotIndex:int):void =
        if (S := StateFor[A, PlotIndex], S.BestWave >= FusionUnlockWave, UI := FusionUIs[S.Agent]):
            # Platzhalter-Auswahl: zwei stärkste Stall-Kreaturen (Picker folgt in UMG)
            if (S.Creatures.Length >= 2):
                UI.Show(S, S.Creatures.Length - 2, S.Creatures.Length - 1, ResonanceChanceNow(Time, S))

    OnHypePressed(A:agent):void =
        if (P := player[A], S := States[P], Start := BeatStart[P]):
            Now := GetSimulationElapsedTime()
            set S.LastInputAt = Now
            Hype.RegisterPress(P, Start, Now)

    # ------------------------------ ftb_ui_events ----------------------
    OnFuseRequested<override>(P:player, SlotA:int, SlotB:int, Ch:fusion_choice):void =
        if (S := States[P], CA := S.Creatures[SlotA], CB := S.Creatures[SlotB], SlotA <> SlotB):
            MaxJobs := 1 + (if (HasBitInt[S.IITMirror, IITBitDoubleFusion]) then 1 else 0)
            Pv := BuildFusionPreview(S, CA, CB, Ch, ResonanceChanceNow(Time, S))
            Now := GetSimulationElapsedTime()
            # ATOMAR: Kosten, Eltern entfernen, Job anlegen, Commit
            if:
                S.Fusing.Length < MaxJobs
                S.Coins >= Pv.CoinCost
                S.Kerne >= Pv.KerneCost
                set S.Coins = S.Coins - Pv.CoinCost
                set S.Kerne = S.Kerne - Pv.KerneCost
                RemoveTwo(S, SlotA, SlotB)
                Final := ResolveFusion(S, Pv)
                set S.Fusing += array{ftb_timer_job{Payload := PackCreature(Final), EndsAt := Now + Pv.DurationSeconds}}
                CommitSave[P, BuildSave(S, Now)]
            then:
                RefreshPlot(S)
            else:
                if (H := Huds[P]):
                    H.PushToast("Fusion nicht möglich (Kosten/Slot)")

    OnPanelClosed<override>(P:player):void =
        Print("FTB UI: Panel geschlossen")

    # Entfernt zwei Kreaturen und korrigiert Pad-Verweise (Indizes verschieben sich).
    RemoveTwo(S:ftb_player_state, A:int, B:int)<transacts>:void =
        var NewList:[]ftb_creature = array{}
        var Remap:[]int = array{}
        for (I -> C : S.Creatures):
            if (I = A or I = B):
                set Remap += array{-1}
            else:
                set Remap += array{NewList.Length}
                set NewList += array{C}
        set S.Creatures = NewList
        set S.PadSlots = for (Slot : S.PadSlots) { if (Slot >= 0, N := Remap[Slot]) then N else -1 }

    GoalText(S:ftb_player_state):string =
        if (S.BestWave < FusionUnlockWave) then "Nächstes Ziel: Welle {FusionUnlockWave}"
        else "Rebirth: {FormatBig(S.Coins)} / {FormatBig(RebirthCost(S.Rebirths))} · Welle {S.BestWave}/{RebirthWaveNeeded(S.Rebirths)}"
