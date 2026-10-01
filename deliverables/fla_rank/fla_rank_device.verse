# FLA Rank-System (Flickerlight Academy)
# Eigenstaendiges Geraet: liest nur Ereignisse bestehender Geraete, aendert keine bestehenden Systeme.
#  - Dauerhafte Rank-Punkte (RP) pro Spieler (persistent, ueber Sessions)
#  - Live-Rangliste der aktuellen Lobby (Session-Punkte) rechts im HUD
#  - Punkte: Ueberleben als Prop, Eliminierungen als Hunter, Rundensiege, Teilnahme
#  - Session-Streak: je laenger man bleibt, desto mehr RP (bis +50 %)

using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Game }
using { /Fortnite.com/Playspaces }
using { /Fortnite.com/Teams }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }

FLARankText<localizes>(Value:string):message = "{Value}"
FLARankName<localizes>(Agent:agent):message = "{Agent}"

# ---------- Persistenz ----------
fla_rank_profile := class<final><persistable>:
    Points:int = 0
    Eliminations:int = 0
    Wins:int = 0
    SurvivalSeconds:int = 0
    Rounds:int = 0
    # Verbleibende Runden mit 2X-RP-Boost (aus dem Shop)
    BoostRounds:int = 0
    # Shop-Rundenvorteile (Speed Boost / Shockwave), verbleibende Runden
    SpeedRounds:int = 0
    ShockRounds:int = 0

var FLARankProfiles:weak_map(player, fla_rank_profile) = map{}

# ---------- Rangstufen ----------
fla_rank_tier := struct:
    TierName:string
    MinPoints:int
    TierColor:color

FLABuildRankTiers():[]fla_rank_tier = array:
    fla_rank_tier{TierName := "ROOKIE", MinPoints := 0, TierColor := MakeColorFromSRGB(0.72, 0.76, 0.86)}
    fla_rank_tier{TierName := "BRONZE", MinPoints := 150, TierColor := MakeColorFromSRGB(0.85, 0.52, 0.28)}
    fla_rank_tier{TierName := "SILVER", MinPoints := 500, TierColor := MakeColorFromSRGB(0.80, 0.86, 0.95)}
    fla_rank_tier{TierName := "GOLD", MinPoints := 1200, TierColor := MakeColorFromSRGB(1.00, 0.80, 0.20)}
    fla_rank_tier{TierName := "PLATINUM", MinPoints := 2500, TierColor := MakeColorFromSRGB(0.35, 0.95, 0.90)}
    fla_rank_tier{TierName := "DIAMOND", MinPoints := 4500, TierColor := MakeColorFromSRGB(0.35, 0.65, 1.00)}
    fla_rank_tier{TierName := "ELITE", MinPoints := 7500, TierColor := MakeColorFromSRGB(0.75, 0.40, 1.00)}
    fla_rank_tier{TierName := "CHAMPION", MinPoints := 12000, TierColor := MakeColorFromSRGB(1.00, 0.30, 0.75)}
    fla_rank_tier{TierName := "LEGEND", MinPoints := 20000, TierColor := MakeColorFromSRGB(1.00, 0.35, 0.25)}

# ---------- UI-Zustand ----------
fla_rank_row := class:
    Background:color_block
    PosText:text_block
    NameText:text_block
    PointsText:text_block

fla_rank_ui := class:
    Root:canvas
    TierText:text_block
    PointsText:text_block
    NextText:text_block
    ProgressFill:color_block
    StreakText:text_block
    Rows:[]fla_rank_row
    ToastTier:text_block
    ToastBack:texture_block
    var ToastToken:int = 0
    var LastTierIndex:int = -1

fla_rank_elim_handler := class:
    Owner:fla_rank_device
    OnEliminated(Result:elimination_result):void =
        Owner.HandleElimination(Result)

fla_rank_spawn_handler := class:
    Owner:fla_rank_device
    OnSpawned(Agent:agent):void =
        Owner.HandleSpawn(Agent)

# ---------- Geraet ----------
fla_rank_device := class(creative_device):

    # Rundenstart (Hunter werden freigelassen) = GateTimer aus simple_prophunt
    @editable RoundStartTimer:timer_device = timer_device{}
    # Hunter gewinnen (alle Props eliminiert) = HUNTERSwinCounter aus hud_controller
    @editable HuntersWinCounter:player_counter_device = player_counter_device{}
    # Props gewinnen (Zeit abgelaufen) = PROPSwinTimer aus hud_controller
    @editable PropsWinTimer:timer_device = timer_device{}
    @editable RoundSettings:round_settings_device = round_settings_device{}
    # Team-Geraete fuer Spawn-Erkennung (Hunter / Props)
    @editable HunterTeamSettings:team_settings_and_inventory_device = team_settings_and_inventory_device{}
    @editable PropTeamSettings:team_settings_and_inventory_device = team_settings_and_inventory_device{}

    @editable SurvivalSecondsPerPoint:int = 10
    @editable PropWinPoints:int = 40
    @editable HunterWinPoints:int = 25
    @editable EliminationPoints:int = 20
    @editable ParticipationPoints:int = 5
    @editable StreakStepPercent:int = 10
    @editable StreakMaxSteps:int = 5
    @editable VisibleRows:int = 6
    # Shop: VIP-Bonus in Prozent, Faktor des RP-Boosts
    @editable VipBonusPercent:int = 25
    @editable BoostMultiplier:int = 2

    var Tiers:[]fla_rank_tier = array{}
    var VipPlayers:[player]logic = map{}
    var UIs:[player]fla_rank_ui = map{}
    var SessionPoints:[player]int = map{}
    var SessionRounds:[player]int = map{}
    var SurvivalCounter:[player]int = map{}
    var ElimSubscriptions:[player]cancelable = map{}
    var RoundActive:logic = false
    var RoundHunters:[player]logic = map{}
    var RoundProps:[player]logic = map{}

    OnBegin<override>()<suspends>:void =
        set Tiers = FLABuildRankTiers()
        Playspace := GetPlayspace()
        Playspace.PlayerAddedEvent().Subscribe(OnPlayerAdded)
        Playspace.PlayerRemovedEvent().Subscribe(OnPlayerRemoved)
        RoundStartTimer.SuccessEvent.Subscribe(OnRoundStart)
        HuntersWinCounter.CountSucceedsEvent.Subscribe(OnHuntersWin)
        PropsWinTimer.SuccessEvent.Subscribe(OnPropsWin)
        RoundSettings.RoundBeginEvent.Subscribe(OnRoundBegin)
        SpawnHandler := fla_rank_spawn_handler{Owner := Self}
        HunterTeamSettings.TeamMemberSpawnedEvent.Subscribe(SpawnHandler.OnSpawned)
        PropTeamSettings.TeamMemberSpawnedEvent.Subscribe(SpawnHandler.OnSpawned)
        for (P : Playspace.GetPlayers()):
            spawn { InitPlayer(P) }
        spawn { SurvivalLoop() }

    # ----- Spieler -----
    OnPlayerAdded(P:player):void =
        spawn { InitPlayer(P) }

    OnPlayerRemoved(P:player):void =
        if (UI := UIs[P], PlayerUI := GetPlayerUI[P]):
            PlayerUI.RemoveWidget(UI.Root)
        if (Sub := ElimSubscriptions[P]):
            Sub.Cancel()
        var NewUIs:[player]fla_rank_ui = map{}
        for (K -> V : UIs, K <> P):
            if (set NewUIs[K] = V) {}
        set UIs = NewUIs
        UpdateAllBoards()

    InitPlayer(P:player)<suspends>:void =
        EnsureProfile(P)
        if (not SessionPoints[P]):
            if (set SessionPoints[P] = 0) {}
        if (not SessionRounds[P]):
            if (set SessionRounds[P] = 0) {}
        var Attempts:int = 0
        loop:
            if (PlayerUI := GetPlayerUI[P]):
                if (Old := UIs[P]):
                    PlayerUI.RemoveWidget(Old.Root)
                UI := CreateUI()
                PlayerUI.AddWidget(UI.Root, player_ui_slot{InputMode := ui_input_mode.None, ZOrder := 50})
                if (set UIs[P] = UI) {}
                break
            set Attempts += 1
            if (Attempts > 40):
                break
            Sleep(0.25)
        SubscribeElimination(P)
        UpdateAllBoards()

    EnsureProfile(P:player):void =
        if (not FLARankProfiles[P]):
            if (set FLARankProfiles[P] = fla_rank_profile{}) {}

    HandleSpawn(Agent:agent):void =
        if (P := player[Agent]):
            SubscribeElimination(P)

    SubscribeElimination(P:player):void =
        if (Char := P.GetFortCharacter[]):
            if (Old := ElimSubscriptions[P]):
                Old.Cancel()
            Handler := fla_rank_elim_handler{Owner := Self}
            Sub := Char.EliminatedEvent().Subscribe(Handler.OnEliminated)
            if (set ElimSubscriptions[P] = Sub) {}

    # ----- Rundenlogik -----
    OnRoundBegin():void =
        set RoundActive = false
        set RoundHunters = map{}
        set RoundProps = map{}

    OnRoundStart(Instigator:?agent):void =
        set RoundActive = true
        set RoundHunters = map{}
        set RoundProps = map{}
        for (P : GetPlayspace().GetPlayers()):
            TeamIndex := GetTeamIndex(P)
            if (TeamIndex = 0):
                if (set RoundHunters[P] = true) {}
            else if (TeamIndex = 1):
                if (set RoundProps[P] = true) {}
            if (set SurvivalCounter[P] = 0) {}

    OnHuntersWin():void =
        if (RoundActive = false):
            return
        set RoundActive = false
        for (P : GetPlayspace().GetPlayers()):
            if (RoundHunters[P]):
                AddPoints(P, HunterWinPoints, true, false, 0)
            FinishRoundFor(P)
        UpdateAllBoards()

    OnPropsWin(Instigator:?agent):void =
        if (RoundActive = false):
            return
        set RoundActive = false
        for (P : GetPlayspace().GetPlayers()):
            TeamIndex := GetTeamIndex(P)
            if (RoundProps[P], TeamIndex = 1, IsAlive[P]):
                AddPoints(P, PropWinPoints, true, false, 0)
            FinishRoundFor(P)
        UpdateAllBoards()

    FinishRoundFor(P:player):void =
        if (RoundHunters[P] or RoundProps[P]):
            AddPoints(P, ParticipationPoints, false, false, 0)
            Rounds := GetSessionRounds(P) + 1
            if (set SessionRounds[P] = Rounds) {}
            if (Profile := FLARankProfiles[P]):
                # Eine Boost-Runde verbrauchen (erst nach der Teilnahmewertung)
                Boost := if (Profile.BoostRounds > 0) then Profile.BoostRounds - 1 else 0
                NewProfile := fla_rank_profile{Points := Profile.Points, Eliminations := Profile.Eliminations, Wins := Profile.Wins, SurvivalSeconds := Profile.SurvivalSeconds, Rounds := Profile.Rounds + 1, BoostRounds := Boost, SpeedRounds := Profile.SpeedRounds, ShockRounds := Profile.ShockRounds}
                if (set FLARankProfiles[P] = NewProfile) {}

    # ----- Shop-Schnittstelle -----
    IsRoundActive<public>()<transacts><decides>:void =
        RoundActive?

    SetVip<public>(P:player):void =
        if (set VipPlayers[P] = true) {}
        UpdateAllBoards()

    AddBoostRounds<public>(P:player, Count:int):void =
        EnsureProfile(P)
        if (Count > 0, Profile := FLARankProfiles[P]):
            NewProfile := fla_rank_profile{Points := Profile.Points, Eliminations := Profile.Eliminations, Wins := Profile.Wins, SurvivalSeconds := Profile.SurvivalSeconds, Rounds := Profile.Rounds, BoostRounds := Profile.BoostRounds + Count, SpeedRounds := Profile.SpeedRounds, ShockRounds := Profile.ShockRounds}
            if (set FLARankProfiles[P] = NewProfile) {}
        UpdateAllBoards()

    AddPerks<public>(P:player, Speed:int, Shock:int):void =
        EnsureProfile(P)
        if (Profile := FLARankProfiles[P]):
            NewProfile := fla_rank_profile{Points := Profile.Points, Eliminations := Profile.Eliminations, Wins := Profile.Wins, SurvivalSeconds := Profile.SurvivalSeconds, Rounds := Profile.Rounds, BoostRounds := Profile.BoostRounds, SpeedRounds := Profile.SpeedRounds + Speed, ShockRounds := Profile.ShockRounds + Shock}
            if (set FLARankProfiles[P] = NewProfile) {}

    GetPerks<public>(P:player):tuple(int, int) =
        if (Profile := FLARankProfiles[P]) then (Profile.SpeedRounds, Profile.ShockRounds) else (0, 0)

    IsVip(P:player):logic =
        if (VipPlayers[P]) then true else false

    GetBoostRounds(P:player):int =
        if (Profile := FLARankProfiles[P]) then Profile.BoostRounds else 0

    HandleElimination(Result:elimination_result):void =
        if (RoundActive = false):
            return
        if:
            Victim := player[Result.EliminatedCharacter.GetAgent[]]
            KillerChar := Result.EliminatingCharacter?
            Killer := player[KillerChar.GetAgent[]]
            Killer <> Victim
            RoundProps[Victim]
        then:
            KillerTeam := GetTeamIndex(Killer)
            if (KillerTeam = 0):
                AddPoints(Killer, EliminationPoints, false, true, 0)
                UpdateAllBoards()

    SurvivalLoop()<suspends>:void =
        loop:
            Sleep(1.0)
            if (RoundActive = true):
                var Changed:logic = false
                for (P : GetPlayspace().GetPlayers()):
                    TeamIndex := GetTeamIndex(P)
                    if (TeamIndex = 1, IsAlive[P]):
                        Count := GetSurvivalCounter(P) + 1
                        if (Count >= SurvivalSecondsPerPoint):
                            if (set SurvivalCounter[P] = 0) {}
                            AddPoints(P, 1, false, false, SurvivalSecondsPerPoint)
                            set Changed = true
                        else:
                            if (set SurvivalCounter[P] = Count) {}
                if (Changed = true):
                    UpdateAllBoards()

    # ----- Punkte -----
    AddPoints(P:player, Base:int, IsWin:logic, IsElim:logic, Seconds:int):void =
        EnsureProfile(P)
        Earned := ApplyStreak(P, Base)
        NewSession := GetSessionPoints(P) + Earned
        if (set SessionPoints[P] = NewSession) {}
        if (Profile := FLARankProfiles[P]):
            var W:int = Profile.Wins
            var E:int = Profile.Eliminations
            if (IsWin = true):
                set W += 1
            if (IsElim = true):
                set E += 1
            NewProfile := fla_rank_profile{Points := Profile.Points + Earned, Eliminations := E, Wins := W, SurvivalSeconds := Profile.SurvivalSeconds + Seconds, Rounds := Profile.Rounds, BoostRounds := Profile.BoostRounds, SpeedRounds := Profile.SpeedRounds, ShockRounds := Profile.ShockRounds}
            if (set FLARankProfiles[P] = NewProfile) {}

    # Basis x (100 % + Streak + VIP) x Boost
    ApplyStreak(P:player, Base:int):int =
        Steps := Min(GetSessionRounds(P), StreakMaxSteps)
        VipPct := if (VipPlayers[P]) then VipBonusPercent else 0
        Percent := 100 + Steps * StreakStepPercent + VipPct
        var Result:int = Base
        if (Scaled := Floor[(Base * Percent * 1.0) / 100.0]):
            set Result = Scaled
        Boost := GetBoostRounds(P)
        if (Boost > 0):
            set Result = Result * BoostMultiplier
        Result

    GetStreakPercent(P:player):int =
        Min(GetSessionRounds(P), StreakMaxSteps) * StreakStepPercent

    GetSessionPoints(P:player):int =
        if (V := SessionPoints[P]) then V else 0

    GetSessionRounds(P:player):int =
        if (V := SessionRounds[P]) then V else 0

    GetSurvivalCounter(P:player):int =
        if (V := SurvivalCounter[P]) then V else 0

    GetTotalPoints(P:player):int =
        if (Profile := FLARankProfiles[P]) then Profile.Points else 0

    GetTeamIndex(P:player):int =
        TeamCollection := GetPlayspace().GetTeamCollection()
        Teams := TeamCollection.GetTeams()
        if (T0 := Teams[0], TeamCollection.IsOnTeam[P, T0]):
            return 0
        if (T1 := Teams[1], TeamCollection.IsOnTeam[P, T1]):
            return 1
        -1

    IsAlive(P:player)<transacts><decides>:void =
        Char := P.GetFortCharacter[]
        Char.IsActive[]

    GetTierIndex(Points:int):int =
        var Index:int = 0
        var I:int = 0
        for (Tier : Tiers):
            if (Points >= Tier.MinPoints):
                set Index = I
            set I += 1
        Index

    # ----- Anzeige -----
    UpdateAllBoards():void =
        Sorted := SortedPlayers()
        for (P -> UI : UIs):
            UpdateBoard(P, UI, Sorted)

    SortedPlayers():[]player =
        var Result:[]player = array{}
        for (P : GetPlayspace().GetPlayers()):
            PPoints := GetSessionPoints(P)
            var Inserted:[]player = array{}
            var Placed:logic = false
            for (Q : Result):
                QPoints := GetSessionPoints(Q)
                if (Placed = false, PPoints > QPoints):
                    set Inserted += array{P}
                    set Placed = true
                set Inserted += array{Q}
            if (Placed = false):
                set Inserted += array{P}
            set Result = Inserted
        Result

    UpdateBoard(Me:player, UI:fla_rank_ui, Sorted:[]player):void =
        Total := GetTotalPoints(Me)
        TierIndex := GetTierIndex(Total)
        if (Tier := Tiers[TierIndex]):
            UI.TierText.SetText(FLARankText(Tier.TierName))
            UI.TierText.SetTextColor(Tier.TierColor)
            UI.ProgressFill.SetColor(Tier.TierColor)
            UI.PointsText.SetText(FLARankText("{Total} RP"))
            if (Next := Tiers[TierIndex + 1]):
                Span := Next.MinPoints - Tier.MinPoints
                Done := Total - Tier.MinPoints
                Missing := Next.MinPoints - Total
                var Ratio:float = (Done * 1.0) / (Max(Span, 1) * 1.0)
                if (Ratio > 1.0):
                    set Ratio = 1.0
                if (Ratio < 0.0):
                    set Ratio = 0.0
                UI.ProgressFill.SetDesiredSize(vector2{X := Art(BarWidth()) * Ratio + 0.01, Y := Art(BarHeight())})
                UI.NextText.SetText(FLARankText("NEXT: {Next.TierName}  -  {Missing} RP TO GO"))
            else:
                UI.ProgressFill.SetDesiredSize(vector2{X := Art(BarWidth()), Y := Art(BarHeight())})
                UI.NextText.SetText(FLARankText("MAX RANK REACHED"))
            if (UI.LastTierIndex >= 0, TierIndex > UI.LastTierIndex):
                spawn { ShowRankUp(UI, Tier) }
            set UI.LastTierIndex = TierIndex
        UI.StreakText.SetText(FLARankText(StatusLine(Me)))
        # Zeilen: Top-Plaetze, eigener Platz immer sichtbar
        var MyPos:int = 0
        var Idx:int = 0
        for (P : Sorted):
            if (P = Me):
                set MyPos = Idx
            set Idx += 1
        RowCount := UI.Rows.Length
        var Shown:[]int = array{}
        var I:int = 0
        loop:
            if (I >= Sorted.Length or I >= RowCount):
                break
            set Shown += array{I}
            set I += 1
        if (MyPos >= RowCount, RowCount > 0):
            if (set Shown[RowCount - 1] = MyPos) {}
        var R:int = 0
        for (Row : UI.Rows):
            if (SortIndex := Shown[R], P := Sorted[SortIndex]):
                PIsVip := IsVip(P)
                Pos := SortIndex + 1
                Row.PosText.SetText(FLARankText("{Pos}"))
                Row.NameText.SetText(FLARankName(P))
                SPoints := GetSessionPoints(P)
                Row.PointsText.SetText(FLARankText("{SPoints}"))
                Row.PosText.SetVisibility(widget_visibility.Visible)
                Row.NameText.SetVisibility(widget_visibility.Visible)
                Row.PointsText.SetVisibility(widget_visibility.Visible)
                if (P = Me):
                    Row.Background.SetOpacity(0.24)
                    Row.NameText.SetTextColor(MakeColorFromSRGB(0.55, 0.95, 1.0))
                else if (PIsVip?):
                    Row.Background.SetOpacity(0.0)
                    Row.NameText.SetTextColor(MakeColorFromSRGB(1.0, 0.80, 0.20))
                else:
                    Row.Background.SetOpacity(0.0)
                    Row.NameText.SetTextColor(NamedColors.White)
            else:
                Row.PosText.SetVisibility(widget_visibility.Collapsed)
                Row.NameText.SetVisibility(widget_visibility.Collapsed)
                Row.PointsText.SetVisibility(widget_visibility.Collapsed)
                Row.Background.SetOpacity(0.0)
            set R += 1

    # Statuszeile rechts unter dem Balken, z. B. "VIP  2X 7  +20%"
    StatusLine(P:player):string =
        var Parts:string = ""
        Vip := IsVip(P)
        if (Vip?):
            set Parts = "VIP"
        Boost := GetBoostRounds(P)
        if (Boost > 0):
            Sep := if (Parts = "") then "" else "  "
            set Parts = Parts + Sep + "2X {Boost}"
        Streak := GetStreakPercent(P)
        if (Streak > 0):
            Sep := if (Parts = "") then "" else "  "
            set Parts = Parts + Sep + "+{Streak}%"
        if (Parts = "") then "SESSION" else Parts

    ShowRankUp(UI:fla_rank_ui, Tier:fla_rank_tier)<suspends>:void =
        set UI.ToastToken += 1
        Token := UI.ToastToken
        UI.ToastTier.SetText(FLARankText(Tier.TierName))
        UI.ToastTier.SetTextColor(Tier.TierColor)
        UI.ToastTier.SetVisibility(widget_visibility.Visible)
        UI.ToastBack.SetVisibility(widget_visibility.Visible)
        Sleep(4.0)
        if (Token = UI.ToastToken):
            UI.ToastTier.SetVisibility(widget_visibility.Collapsed)
            UI.ToastBack.SetVisibility(widget_visibility.Collapsed)

    # ----- Widget-Aufbau -----
    # Hintergrund-Grafik: Content/FLARankUI/T_Rank_Panel (Generator: _context/transfer/original/rank2/gen_rank_ui.py)
    #
    # Alle Positionen unten sind GRAFIK-KOORDINATEN (Generator-Raster 480 x 292) und wurden am
    # Ingame-Screenshot nachgemessen (Rang-Chip, Fortschrittsschiene, Zeile "NEXT", 2 x 8 Zeilen).
    # Art() rechnet Grafik-Koordinaten in UI-Einheiten um (0.92 x 0.92 = bisherige, bewaehrte Panelgroesse).
    # Panel-Grafik, Texte, Balken und Schriftgroessen laufen ALLE ueber denselben Faktor Art(),
    # deshalb skaliert alles gemeinsam mit jeder HUD-Groesse und nichts verrutscht gegeneinander.
    #
    # Texte sitzen in festen Zellen (overlay) und werden darin VERTIKAL ZENTRIERT -> Schrifthoehe
    # oder Font-Metrik koennen die Zeilen nicht mehr nach unten/oben verschieben; zu lange Namen
    # werden mit "..." gekuerzt statt aus der Zeile zu laufen.
    RankUIScale():float = 0.92
    RankArtContentScale():float = 0.92
    ArtScale():float = RankUIScale() * RankArtContentScale()
    Art(Value:float):float = Value * ArtScale()
    ScaleRank(Value:float):float = Value * RankUIScale()

    # Groesse der Panel-Grafik in Grafik-Koordinaten (wird komplett mit Art() skaliert)
    ArtWidth():float = 480.0
    ArtHeight():float = 292.0

    # Horizontal: rechte Panelkante bei 96.2 % der Bildschirmbreite -> immer ca. 2 cm Abstand zum
    # rechten Rand (3.8 % der Breite, auf 24"-27"-Monitoren ~2-2.3 cm), unabhaengig von der HUD-Groesse.
    PanelAnchorX():float = 0.962
    PanelLeftFromRight():float = 0.0 - Art(ArtWidth())

    # Vertikal: Panel-Mitte exakt mittig zwischen PROPS REMAINING und TEAM HUNTERS / TEAM PROPS.
    #  - PROPS REMAINING (hud_controller): oben angeheftet, sichtbare Unterkante ~207 Einheiten unter dem Rand
    #  - TEAM-Banner (hud_controller): an der Bildschirmmitte angeheftet, sichtbare Oberkante ~ 0.5 x Hoehe + 66
    #  Mitte = (207 + 0.5 x Hoehe + 66) / 2 = 0.25 x Hoehe + 136.5
    #  -> Anker bei 25 % der Bildschirmhoehe + fester Versatz: stimmt fuer jede HUD-Groesse und Aufloesung.
    PanelAnchorY():float = 0.25
    PanelCenterOffset():float = 136.5
    PanelTop():float = PanelCenterOffset() - Art(ArtHeight() * 0.5)

    PanelAnchors():anchors =
        anchors{Minimum := vector2{X := PanelAnchorX(), Y := PanelAnchorY()}, Maximum := vector2{X := PanelAnchorX(), Y := PanelAnchorY()}}

    # Grafik-Masse (gemessen)
    BarX():float = 16.0
    BarY():float = 71.75
    BarWidth():float = 448.0
    BarHeight():float = 6.5
    RowTop():float = 104.0
    RowPitch():float = 22.5
    RowHeight():float = 20.5
    ColumnX():float = 14.0
    ColumnPitch():float = 229.0
    # Optischer Ausgleich: Schrift-Zeilenbox hat unten Platz fuer Unterlaengen -> Text minimal tiefer setzen
    TextOpticalNudge():float = 1.0

    # Element an Grafik-Koordinate X/Y mit Groesse SizeX/SizeY (alles in Grafik-Koordinaten)
    ArtSlot(W:widget, X:float, Y:float, SizeX:float, SizeY:float, Z:type{_X:int where 0 <= _X, _X <= 2147483647}):canvas_slot =
        canvas_slot{Widget := W, Anchors := PanelAnchors(), Offsets := margin{Left := PanelLeftFromRight() + Art(X), Top := PanelTop() + Art(Y), Right := Art(SizeX), Bottom := Art(SizeY)}, Alignment := vector2{X := 0.0, Y := 0.0}, SizeToContent := false, ZOrder := Z}

    # Textzelle: feste Box, Text fuellt die Breite (Ausrichtung ueber Justification) und ist vertikal zentriert
    TextCell(Label:text_block, X:float, Y:float, SizeX:float, SizeY:float, Z:type{_X:int where 0 <= _X, _X <= 2147483647}):canvas_slot =
        Cell := overlay{}
        Cell.AddWidget(overlay_slot{Widget := Label, HorizontalAlignment := horizontal_alignment.Fill, VerticalAlignment := vertical_alignment.Center})
        ArtSlot(Cell, X, Y + TextOpticalNudge(), SizeX, SizeY, Z)

    # Textstil wie im HUD: weiss mit Schatten (Kopfwerte mit blauem Schimmer wie Rundentimer)
    MakeText(Size:float, TextColor:color, Just:text_justification, ShadowColor:color, ShadowOpacity:type{_X:float where 0.0 <= _X, _X <= 1.0}):text_block =
        text_block{DefaultText := FLARankText(""), DefaultTextColor := TextColor, DefaultTextSize := Size, DefaultJustification := Just, DefaultOverflowPolicy := text_overflow_policy.Ellipsis, DefaultShadowOffset := option{vector2{X := 1.0, Y := 1.0}}, DefaultShadowColor := ShadowColor, DefaultShadowOpacity := ShadowOpacity}

    CreateUI():fla_rank_ui =
        Cyan := MakeColorFromSRGB(0.25, 0.90, 1.0)
        Gold := MakeColorFromSRGB(1.0, 0.82, 0.25)
        Root := canvas{}
        # Hintergrund: gezeichnetes Panel im HUD-Stil (Titel-Badge, Rahmen, Rang-Chip, Balkenschiene, Zeilen)
        Panel := texture_block{DefaultImage := FLARankUI.T_Rank_Panel, DefaultDesiredSize := vector2{X := Art(ArtWidth()), Y := Art(ArtHeight())}}
        Root.AddWidget(ArtSlot(Panel, 0.0, 0.0, ArtWidth(), ArtHeight(), 0))
        # Rang-Chip oben rechts (Grafik: X 222-466, Y 29-62): Rangname links, RP rechts, beide mittig in der Hoehe
        Tier := MakeText(Art(15.0), NamedColors.White, text_justification.Left, NamedColors.DodgerBlue, 0.45)
        Root.AddWidget(TextCell(Tier, 238.0, 30.0, 118.0, 31.0, 2))
        Pts := MakeText(Art(13.0), NamedColors.White, text_justification.Right, NamedColors.DodgerBlue, 0.45)
        Root.AddWidget(TextCell(Pts, 356.0, 30.0, 96.0, 31.0, 2))
        # Fortschritt zum naechsten Rang (Fuellung exakt in der gezeichneten Schiene, X 14-466, Y 71-79)
        Fill := color_block{DefaultColor := Cyan, DefaultOpacity := 1.0, DefaultDesiredSize := vector2{X := 0.01, Y := Art(BarHeight())}}
        Root.AddWidget(canvas_slot{Widget := Fill, Anchors := PanelAnchors(), Offsets := margin{Left := PanelLeftFromRight() + Art(BarX()), Top := PanelTop() + Art(BarY()), Right := 0.0, Bottom := 0.0}, Alignment := vector2{X := 0.0, Y := 0.0}, SizeToContent := true, ZOrder := 3})
        # Zeile darunter (Grafik: Y 84-102): naechster Rang links, Status (VIP / 2X / Streak) rechts buendig mit der Schiene
        Next := MakeText(Art(10.5), MakeColorFromSRGB(0.74, 0.82, 1.0), text_justification.Left, NamedColors.Black, 0.8)
        Root.AddWidget(TextCell(Next, 18.0, 84.0, 282.0, 18.0, 2))
        Streak := MakeText(Art(10.5), Gold, text_justification.Right, NamedColors.Black, 0.8)
        Root.AddWidget(TextCell(Streak, 304.0, 84.0, 160.0, 18.0, 2))
        # 16 Zeilen in 2 Spalten (Platz-Badges sind im Panel gezeichnet: Gold / Silber / Bronze / Blau)
        # Spalte links X 14-238, rechts X 243-467; Zeile n: Y = 104 + 22.5 x n, Hoehe 20.5
        var Rows:[]fla_rank_row = array{}
        var I:int = 0
        loop:
            if (I >= 16):
                break
            Col := if (I >= 8) then 1.0 else 0.0
            RowIdx := if (I >= 8) then I - 8 else I
            X := ColumnX() + Col * ColumnPitch()
            Y := RowTop() + RowPitch() * (RowIdx * 1.0)
            # Markierung der eigenen Zeile: rechts neben dem Badge bis zum Spaltenende
            Back := color_block{DefaultColor := Cyan, DefaultOpacity := 0.0}
            Root.AddWidget(ArtSlot(Back, X + 31.0, Y, 192.0, RowHeight(), 2))
            # Top 3 etwas groesser
            NameSize := if (I < 3) then 12.5 else 12.0
            # Platz-Nummer mittig im gezeichneten Badge
            PosT := MakeText(Art(11.0), NamedColors.White, text_justification.Center, NamedColors.Black, 0.9)
            Root.AddWidget(TextCell(PosT, X + 2.0, Y, 28.0, RowHeight(), 3))
            # Name links, Punkte rechts; beide vertikal mittig in der Zeile
            NameT := MakeText(Art(NameSize), NamedColors.White, text_justification.Left, NamedColors.Black, 0.8)
            Root.AddWidget(TextCell(NameT, X + 36.0, Y, 136.0, RowHeight(), 3))
            PtsT := MakeText(Art(11.5), Gold, text_justification.Right, NamedColors.Black, 0.8)
            Root.AddWidget(TextCell(PtsT, X + 174.0, Y, 44.0, RowHeight(), 3))
            set Rows += array{fla_rank_row{Background := Back, PosText := PosT, NameText := NameT, PointsText := PtsT}}
            set I += 1
        # Rank-Up-Einblendung (oben mittig, unter dem Rundentimer); "RANK UP!" ist im Banner gezeichnet
        ToastBack := texture_block{DefaultImage := FLARankUI.T_Rank_Toast, DefaultDesiredSize := vector2{X := ScaleRank(460.0), Y := ScaleRank(120.0)}}
        ToastTier := MakeText(44.0, NamedColors.White, text_justification.Center, NamedColors.DodgerBlue, 0.45)
        Root.AddWidget(canvas_slot{Widget := ToastBack, Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.0}, Maximum := vector2{X := 0.5, Y := 0.0}}, Offsets := margin{Left := 0.0, Top := ScaleRank(236.0), Right := ScaleRank(460.0), Bottom := ScaleRank(120.0)}, Alignment := vector2{X := 0.5, Y := 0.0}, SizeToContent := false, ZOrder := 10})
        Root.AddWidget(canvas_slot{Widget := ToastTier, Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.0}, Maximum := vector2{X := 0.5, Y := 0.0}}, Offsets := margin{Left := 0.0, Top := ScaleRank(288.0), Right := ScaleRank(420.0), Bottom := ScaleRank(58.0)}, Alignment := vector2{X := 0.5, Y := 0.0}, SizeToContent := false, ZOrder := 11})
        ToastBack.SetVisibility(widget_visibility.Collapsed)
        ToastTier.SetVisibility(widget_visibility.Collapsed)
        fla_rank_ui{Root := Root, TierText := Tier, PointsText := Pts, NextText := Next, ProgressFill := Fill, StreakText := Streak, Rows := Rows, ToastTier := ToastTier, ToastBack := ToastBack}
