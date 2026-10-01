# FLA Spawn-Guard: garantiert, dass JEDER Spieler auf einer Spawn-Plattform SEINES Teams landet - nie in der Luft.
# Regeln (aus hud_controller / teleportONTimer):
#  - Team 1 (Teams[0]) = Hunter, Team 2 (Teams[1]) = Props
#  - Aufteilung nach Spielerzahl: 1 -> Warten, 2-5 -> 1 Hunter, 6-8 -> 2, 9-12 -> 3, ab 13 -> 4, Rest = Props
#    (16 Spieler = 4 Hunter + 12 Props = 4 Hunter-Plattformen + 12 Prop-Plattformen / 12 Prop-Teleporter)
#  - Jeder Spieler bekommt eine EIGENE Plattform seines Teams (keine Doppelbelegung, solange genug Plattformen da sind)
#  - Jeder Spawn (Join, Respawn, Rundenstart, auch Spawn in der Luft) -> Spieler wird sofort auf seine Plattform gesetzt
#  - Teamwechsel vor der Prop-Freigabe (Neuverteilung bei Join/Leave) -> Spieler wechselt auf eine Plattform des neuen Teams
#  - Nach der Prop-Freigabe (Props werden in die Map teleportiert) wird ein Prop NIE zurueckgeholt;
#    wer danach Hunter wird oder neu spawnt, kommt auf eine Hunter-Plattform
#  - Vor der Prop-Freigabe: wer hoch ueber den Plattformen schwebt (Luft-Spawn / Skydive) wird zurueckgesetzt
# Aendert keine Teams - die Teamzuteilung bleibt allein beim hud_controller.

using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Playspaces }
using { /Fortnite.com/Teams }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }

fla_spawn_guard_state := class:
    var WasActive:logic = false
    var LastTeam:int = -2
    var SlotTeam:int = -1
    var SlotIndex:int = -1
    var Busy:logic = false
    var Again:logic = false

fla_spawn_guard_device := class(creative_device):

    # Spawn-Plattformen der Hunter (Team 1), mindestens 4
    @editable HunterSpawners:[]player_spawner_device = array{}
    # Spawn-Plattformen der Props (Team 2), mindestens 12
    @editable PropSpawners:[]player_spawner_device = array{}
    # PFLICHT: derselbe Timer wie Team2TeleportTimer im teleportONTimer (Props werden in die Map teleportiert)
    @editable PropsReleaseTimer:timer_device = timer_device{}
    @editable RoundSettings:round_settings_device = round_settings_device{}

    # Hoehe ueber dem Plattform-Mittelpunkt, auf die der Spieler gesetzt wird
    @editable SpawnHeightOffset:float = 100.0
    # Versatz, falls die eigene Plattform gerade blockiert ist
    @editable OverflowOffset:float = 80.0
    # Luft-Rettung vor der Prop-Freigabe: wer hoeher als (hoechste Plattform + SkyRescueHeight) ist, wird zurueckgesetzt
    @editable SkyRescueEnabled:logic = true
    @editable SkyRescueHeight:float = 3000.0
    @editable PollSeconds:float = 0.2
    @editable SettleSeconds:float = 0.15

    var States:[player]fla_spawn_guard_state = map{}
    var PropsReleased:logic = false
    var ReleaseCounter:int = 0
    var HighestPadZ:float = 0.0
    var HasPads:logic = false

    OnBegin<override>()<suspends>:void =
        for (Pad : HunterSpawners + PropSpawners):
            Z := Pad.GetTransform().Translation.Z
            if (HasPads = false or Z > HighestPadZ):
                set HighestPadZ = Z
            set HasPads = true
        if (HunterSpawners.Length = 0 or PropSpawners.Length = 0):
            Print("SpawnGuard: FEHLER - HunterSpawners und PropSpawners muessen im Geraet gesetzt sein!")
        PropsReleaseTimer.SuccessEvent.Subscribe(OnPropsReleased)
        RoundSettings.RoundBeginEvent.Subscribe(OnRoundBegin)
        GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerRemoved)
        GuardLoop()

    # ----- Phasen -----
    OnPropsReleased(Instigator:?agent):void =
        set PropsReleased = true
        set ReleaseCounter += 1

    OnRoundBegin():void =
        set PropsReleased = false
        # Neue Runde: jeden Spieler beim naechsten Check wie frisch gespawnt behandeln
        for (P -> State : States):
            set State.WasActive = false

    OnPlayerRemoved(P:player):void =
        var NewStates:[player]fla_spawn_guard_state = map{}
        for (K -> V : States, K <> P):
            if (set NewStates[K] = V) {}
        set States = NewStates

    GetState(P:player):fla_spawn_guard_state =
        if (Existing := States[P]):
            return Existing
        NewState := fla_spawn_guard_state{}
        if (set States[P] = NewState) {}
        NewState

    # ----- Ueberwachung -----
    GuardLoop()<suspends>:void =
        Interval := if (PollSeconds > 0.05) then PollSeconds else 0.05
        loop:
            for (P : GetPlayspace().GetPlayers()):
                CheckPlayer(P)
            Sleep(Interval)

    CheckPlayer(P:player):void =
        State := GetState(P)
        Team := GetTeamIndex(P)
        if (Char := P.GetFortCharacter[], Char.IsActive[]):
            if (State.WasActive = false):
                # Spawn erkannt (Join, Respawn, Rundenstart, Luft-Spawn)
                set State.WasActive = true
                set State.LastTeam = Team
                RequestPlacement(P, State, "Spawn")
            else if (Team <> State.LastTeam):
                # Teamwechsel: vor der Freigabe immer, danach nur wenn der Spieler Hunter geworden ist
                set State.LastTeam = Team
                if (PropsReleased = false or Team = 0):
                    RequestPlacement(P, State, "Teamwechsel")
            else if (PropsReleased = false, SkyRescueEnabled?, HasPads?):
                if (Char.GetTransform().Translation.Z > HighestPadZ + SkyRescueHeight):
                    RequestPlacement(P, State, "Luft-Rettung")
        else:
            set State.WasActive = false

    RequestPlacement(P:player, State:fla_spawn_guard_state, Reason:string):void =
        Print("SpawnGuard: Spieler wird auf Plattform gesetzt - Grund: {Reason}")
        if (State.Busy?):
            set State.Again = true
            return
        set State.Busy = true
        set State.Again = false
        spawn { PlacementRoutine(P, State) }

    # Setzt den Spieler auf seine Plattform und prueft danach, ob er wirklich dort steht (sonst erneut)
    PlacementRoutine(P:player, State:fla_spawn_guard_state)<suspends>:void =
        Release := ReleaseCounter
        Sleep(SettleSeconds)
        var Attempts:int = 0
        loop:
            set State.Again = false
            if (not CanPlaceNow[P]):
                break
            Team := PlacementTeam(GetTeamIndex(P))
            # Wurden die Props waehrenddessen freigegeben, Props nicht mehr zurueckholen
            if (Release <> ReleaseCounter and Team = 1):
                break
            var Done:logic = false
            PlaceResult := PlaceNow(P, State, Team)
            if (TargetPos := PlaceResult?):
                Sleep(0.25)
                if (State.Again = false, IsNear[P, TargetPos]):
                    set Done = true
            if (Done?):
                break
            set Attempts += 1
            if (Attempts >= 6):
                break
            Sleep(0.2)
        set State.LastTeam = GetTeamIndex(P)
        set State.Busy = false

    CanPlaceNow(P:player)<transacts><decides>:void =
        P.IsActive[]
        Char := P.GetFortCharacter[]
        Char.IsActive[]

    IsNear(P:player, Pos:vector3)<transacts><decides>:void =
        Char := P.GetFortCharacter[]
        Distance(Char.GetTransform().Translation, Pos) < 400.0

    # ----- Plattformen -----
    # Spieler ohne Team: vor der Freigabe Prop-Bereich (Wartebereich), danach Hunter-Bereich
    PlacementTeam(Team:int):int =
        if (Team = 0 or Team = 1):
            return Team
        if (PropsReleased?) then 0 else 1

    PadsFor(Team:int):[]player_spawner_device =
        Primary := if (Team = 0) then HunterSpawners else PropSpawners
        if (Primary.Length > 0) then Primary else HunterSpawners + PropSpawners

    # Eigene Plattform des Spielers: behalten, sonst freie mit kleinster Nummer, sonst die am wenigsten belegte
    AcquireSlot(P:player, State:fla_spawn_guard_state, Team:int, PadCount:int):int =
        if (State.SlotTeam = Team, State.SlotIndex >= 0, State.SlotIndex < PadCount):
            return State.SlotIndex
        var Used:[int]int = map{}
        for (Other -> OtherState : States, Other <> P, OtherState.SlotTeam = Team, OtherState.SlotIndex >= 0):
            Current := if (C := Used[OtherState.SlotIndex]) then C else 0
            if (set Used[OtherState.SlotIndex] = Current + 1) {}
        var Chosen:int = 0
        var Best:int = -1
        var Index:int = 0
        loop:
            if (Index >= PadCount):
                break
            Count := if (C := Used[Index]) then C else 0
            if (Best < 0 or Count < Best):
                set Best = Count
                set Chosen = Index
            set Index += 1
        set State.SlotTeam = Team
        set State.SlotIndex = Chosen
        Chosen

    # 1) eigene Plattform  2) eigene Plattform leicht versetzt  3) jede andere Plattform des Teams
    PlaceNow(P:player, State:fla_spawn_guard_state, Team:int):?vector3 =
        Pads := PadsFor(Team)
        if (Pads.Length = 0):
            return false
        if (Char := P.GetFortCharacter[], Char.IsActive[]):
            Slot := AcquireSlot(P, State, Team, Pads.Length)
            if (OwnPad := Pads[Slot]):
                for (Ring := 0..4):
                    RingResult := TryTeleport(Char, OwnPad, Ring)
                    if (Pos := RingResult?):
                        return option{Pos}
            for (Pad : Pads):
                PadResult := TryTeleport(Char, Pad, 0)
                if (Pos := PadResult?):
                    return option{Pos}
        false

    TryTeleport(Char:fort_character, Pad:player_spawner_device, Ring:int):?vector3 =
        T := Pad.GetTransform()
        Pos := T.Translation + RingOffset(Ring) + vector3{X := 0.0, Y := 0.0, Z := SpawnHeightOffset}
        if (Char.TeleportTo[Pos, T.Rotation]):
            return option{Pos}
        false

    RingOffset(Ring:int):vector3 =
        D := OverflowOffset
        if (Ring = 1) then vector3{X := D, Y := 0.0, Z := 0.0}
        else if (Ring = 2) then vector3{X := -D, Y := 0.0, Z := 0.0}
        else if (Ring = 3) then vector3{X := 0.0, Y := D, Z := 0.0}
        else if (Ring = 4) then vector3{X := 0.0, Y := -D, Z := 0.0}
        else vector3{X := 0.0, Y := 0.0, Z := 0.0}

    GetTeamIndex(P:player):int =
        TeamCollection := GetPlayspace().GetTeamCollection()
        Teams := TeamCollection.GetTeams()
        if (T0 := Teams[0], TeamCollection.IsOnTeam[P, T0]):
            return 0
        if (T1 := Teams[1], TeamCollection.IsOnTeam[P, T1]):
            return 1
        -1
