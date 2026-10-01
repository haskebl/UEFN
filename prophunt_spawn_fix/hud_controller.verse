
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Playspaces }
using { /Fortnite.com/Teams }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { /Verse.org/Verse }
using { /haske@fortnite.com/SpritePropHuntEigen/HUDbuttons }


ToMessage<localizes>(Value:string):message = "{Value}"


player_session_state := class:
    var PlayedRounds:int = 0
    var Wins:int = 0
    var HideMinutes:int = 0
    var HideAwarded:logic = false
    var RoundsAwarded:logic = false
    var WinsAwarded:logic = false


player_widget_state := class:
    Root:canvas
    TimerText:text_block
    StartupText:text_block
    PropsText:text_block
    WinsText:text_block
    RoundsText:text_block
    HideTimeText:text_block
    RoundsDoneXText:text_block
    HideTimeDoneXText:text_block
    TeamRoleHunterImage:texture_block
    TeamRolePropImage:texture_block
    CoinText:text_block
    CoinTextOutline:text_block

    var LastDisplayedGold:int = -1
    var LastDisplayedProps:int = -1
    var LastDisplayedTimer:string = ""
    var LastDisplayedWins:int = -1
    var LastDisplayedRounds:int = -1
    var LastDisplayedHideMinutes:int = -1
    var LastDisplayedWaiting:logic = false
    var LastDisplayedStartup:logic = false
    var LastDisplayedHideCompleted:logic = false
    var RoleHUDInitialized:logic = false


hud_controller := class(creative_device):

    @editable
    RoundTimerDevice:timer_device = timer_device{}

    @editable
    StartupTimerDevice:timer_device = timer_device{}

    @editable
    RoundSettings:round_settings_device = round_settings_device{}

    @editable
    PropsCounter:player_counter_device = player_counter_device{}

    @editable
    Team1Settings:team_settings_and_inventory_device =
        team_settings_and_inventory_device{}

    @editable
    Team2Class2Settings:team_settings_and_inventory_device =
        team_settings_and_inventory_device{}

    @editable
    Team2Class3Settings:team_settings_and_inventory_device =
        team_settings_and_inventory_device{}

    @editable
    Team2Class4Settings:team_settings_and_inventory_device =
        team_settings_and_inventory_device{}

    @editable
    Team2Class5Settings:team_settings_and_inventory_device =
        team_settings_and_inventory_device{}

    @editable
    Team2Class6Settings:team_settings_and_inventory_device =
        team_settings_and_inventory_device{}

    @editable
    Team2Class7Settings:team_settings_and_inventory_device =
        team_settings_and_inventory_device{}

    @editable
    Team2Class8Settings:team_settings_and_inventory_device =
        team_settings_and_inventory_device{}

    @editable
    Team2Class9Settings:team_settings_and_inventory_device =
        team_settings_and_inventory_device{}

    @editable
    Team2Class10Settings:team_settings_and_inventory_device =
        team_settings_and_inventory_device{}

    @editable
    Team2Class11Settings:team_settings_and_inventory_device =
        team_settings_and_inventory_device{}

    @editable
    Team2Class12Settings:team_settings_and_inventory_device =
        team_settings_and_inventory_device{}

    @editable
    Team2Class13Settings:team_settings_and_inventory_device =
        team_settings_and_inventory_device{}

    @editable
    GoldInventoryReader:conditional_button_device =
        conditional_button_device{}

    @editable
    GoldRestoreGranter:item_granter_device =
        item_granter_device{}

    @editable
    GoldPersistTracker:tracker_device =
        tracker_device{}

    @editable
    CoinIconImage:texture =
        HUDbuttons.TEAMHUNTERSPropHunt

    @editable
    HideForTenMinutesAccolade:accolades_device =
        accolades_device{}

    @editable
    PlayFiveRoundsAccolade:accolades_device =
        accolades_device{}

    @editable
    SimulatePlayerButton:button_device =
        button_device{}

    @editable
    WinsTaskTarget:int = 3

    @editable
    WinsPersistTracker:tracker_device =
        tracker_device{}

    @editable
    RoundsPersistTracker:tracker_device =
        tracker_device{}

    @editable
    HidePersistTracker:tracker_device =
        tracker_device{}

    @editable
    HUNTERSwinCounter:player_counter_device =
        player_counter_device{}

    @editable
    PROPSwinTimer:timer_device =
        timer_device{}

    @editable
    TeamRoleHUDMessage:hud_message_device =
        hud_message_device{}

    # Timer, der die Props in die Map teleportiert (= Team2TeleportTimer im teleportONTimer).
    # Ab dessen Ablauf sind die Teams fuer die Runde fest: keine Neuverteilung mehr, Nachzuegler -> Hunter.
    @editable
    TeamLockTimer:timer_device =
        timer_device{}


    var PlayerStates:[player]player_session_state = map{}
    var PlayerWidgets:[player]player_widget_state = map{}
    var PendingGoldRestore:[player]logic = map{}

    var CurrentHideSeconds:[player]int = map{}

    var IsStartupPhaseActive:logic = true
    var IsWaitingForPlayers:logic = true
    var SimulatedExtraPlayers:int = 0
    var WinRecordedThisRound:logic = false
    var RoundTimerStartedThisRound:logic = false
    var TeamsLockedThisRound:logic = false
    var RoundLoopToken:int = 0

    var RoundTeam1Snapshot:[player]logic = map{}
    var RoundTeam2Snapshot:[player]logic = map{}
    var WasPropThisRound:[player]logic = map{}
    var EligibleHuntersForTeam1Win:[player]logic = map{}
    var RoundWinEvaluationToken:int = 0
    var RoundStartHunters:[player]logic = map{}
    var RoundStartProps:[player]logic = map{}
    var EliminatedAsPropThisRound:[player]logic = map{}

    var PendingLastRoundWinnerTeam:int = 0
    var PendingLastRoundHunters:[player]logic = map{}
    var PendingLastRoundProps:[player]logic = map{}

    var RoundTeamAssignment:[player]int = map{}
    var RoundAssignmentPlayerCount:int = -1

    var CurrentTeam1Snapshot:[player]logic = map{}
    var CurrentTeam2Snapshot:[player]logic = map{}
    var CurrentAliveTeam2Snapshot:[player]logic = map{}

    var CurrentDisplayedPropHUD:[player]logic = map{}
    var CurrentDisplayedHunterHUD:[player]logic = map{}
    var CurrentDisplayedPropHUDCount:int = 0
    var LastAnnouncedTeamRole:[player]int = map{}
    var CurrentGlobalPropsRemaining:int = 0

    var CurrentTeam1Count:int = 0
    var CurrentTeam2Count:int = 0

    var TaskTrackersInitialized:[player]logic = map{}
    var TaskProgressLoaded:[player]logic = map{}
    var GoldTrackerInitialized:[player]logic = map{}
    var GoldRestoreInProgress:[player]logic = map{}
    var TaskCompletionPreview:[player]logic = map{}
    var GoldRestoreGranterBusy:logic = false


    OnBegin<override>()<suspends>:void =
        Playspace := GetPlayspace()

        HideConflictingHUD(Playspace)
        ShowStandardResourceHUD(Playspace)

        Playspace.PlayerAddedEvent().Subscribe(OnPlayerAdded)
        Playspace.PlayerRemovedEvent().Subscribe(OnPlayerRemoved)

        RoundSettings.RoundBeginEvent.Subscribe(OnRoundBegin)

        TeamLockTimer.SuccessEvent.Subscribe(
            OnTeamLockTimerSuccess
        )

        HUNTERSwinCounter.CountSucceedsEvent.Subscribe(
            OnPropsCounterSuccess
        )

        PROPSwinTimer.SuccessEvent.Subscribe(
            OnMainRoundTimerSuccess
        )

        StartupTimerDevice.SuccessEvent.Subscribe(
            OnStartupTimerSuccess
        )

        Team1Settings.TeamMemberSpawnedEvent.Subscribe(
            OnAgentSpawned
        )

        Team2Class2Settings.TeamMemberSpawnedEvent.Subscribe(
            OnAgentSpawned
        )

        Team2Class3Settings.TeamMemberSpawnedEvent.Subscribe(
            OnAgentSpawned
        )

        Team2Class4Settings.TeamMemberSpawnedEvent.Subscribe(
            OnAgentSpawned
        )

        Team2Class5Settings.TeamMemberSpawnedEvent.Subscribe(
            OnAgentSpawned
        )

        Team2Class6Settings.TeamMemberSpawnedEvent.Subscribe(
            OnAgentSpawned
        )

        Team2Class7Settings.TeamMemberSpawnedEvent.Subscribe(
            OnAgentSpawned
        )

        Team2Class8Settings.TeamMemberSpawnedEvent.Subscribe(
            OnAgentSpawned
        )

        Team2Class9Settings.TeamMemberSpawnedEvent.Subscribe(
            OnAgentSpawned
        )

        Team2Class10Settings.TeamMemberSpawnedEvent.Subscribe(
            OnAgentSpawned
        )

        Team2Class11Settings.TeamMemberSpawnedEvent.Subscribe(
            OnAgentSpawned
        )

        Team2Class12Settings.TeamMemberSpawnedEvent.Subscribe(
            OnAgentSpawned
        )

        Team2Class13Settings.TeamMemberSpawnedEvent.Subscribe(
            OnAgentSpawned
        )

        Team2Class2Settings.TeamMemberEliminatedEvent.Subscribe(
            OnTeam2MemberEliminated
        )

        Team2Class3Settings.TeamMemberEliminatedEvent.Subscribe(
            OnTeam2MemberEliminated
        )

        Team2Class4Settings.TeamMemberEliminatedEvent.Subscribe(
            OnTeam2MemberEliminated
        )

        Team2Class5Settings.TeamMemberEliminatedEvent.Subscribe(
            OnTeam2MemberEliminated
        )

        Team2Class6Settings.TeamMemberEliminatedEvent.Subscribe(
            OnTeam2MemberEliminated
        )

        Team2Class7Settings.TeamMemberEliminatedEvent.Subscribe(
            OnTeam2MemberEliminated
        )

        Team2Class8Settings.TeamMemberEliminatedEvent.Subscribe(
            OnTeam2MemberEliminated
        )

        Team2Class9Settings.TeamMemberEliminatedEvent.Subscribe(
            OnTeam2MemberEliminated
        )

        Team2Class10Settings.TeamMemberEliminatedEvent.Subscribe(
            OnTeam2MemberEliminated
        )

        Team2Class11Settings.TeamMemberEliminatedEvent.Subscribe(
            OnTeam2MemberEliminated
        )

        Team2Class12Settings.TeamMemberEliminatedEvent.Subscribe(
            OnTeam2MemberEliminated
        )

        Team2Class13Settings.TeamMemberEliminatedEvent.Subscribe(
            OnTeam2MemberEliminated
        )

        SimulatePlayerButton.InteractedWithEvent.Subscribe(
            OnSimulatePlayerButtonPressed
        )

        for (Player : Playspace.GetPlayers()):
            InitializePlayer(Player)

        UpdateWaitingState()
        UpdateRoundTimerHUDState()
        EnsurePreRoundTeamAssignment()
        RebuildCurrentTeamState()
        RefreshCurrentDisplayedRoleState()
        RebuildRoundTeamSnapshot()
        UpdateAllPropsHUDOnly()

        StartRoundLoops()

        spawn {
            MainGameplayTickLoop()
        }

        spawn {
            GoldTrackingLoop()
        }


    # Rundenschleifen (Rundentimer-Erkennung + Teamkontrolle vor Rundenstart) fuer JEDE Runde neu starten.
    # Der Token beendet die Schleifen der vorherigen Runde, damit nie zwei gleichzeitig laufen.
    StartRoundLoops():void =
        set RoundLoopToken += 1

        LoopToken :=
            RoundLoopToken

        spawn {
            RoundTimerStartMonitorLoop(LoopToken)
        }

        spawn {
            PreRoundTeamCheckLoop(LoopToken)
        }


    OnTeamLockTimerSuccess(
        Instigator:?agent
    ):void =
        set TeamsLockedThisRound = true


    # Teams sind fest, sobald die Props freigegeben wurden oder der Rundentimer laeuft
    AreTeamsLocked():logic =
        if (RoundTimerStartedThisRound = true):
            return true

        if (TeamsLockedThisRound = true):
            return true

        false


    OnPlayerAdded(
        NewPlayer:player
    ):void =
        HideConflictingHUDForPlayer(NewPlayer)
        ShowStandardResourceHUDForPlayer(NewPlayer)

        InitializeTaskPersistTrackers(NewPlayer)
        InitializeSessionTaskValues(NewPlayer)

        if (ExistingState := PlayerStates[NewPlayer]):
            Print("HUD: vorhandenen Player-State behalten")
        else:
            if (
                set PlayerStates[NewPlayer] =
                    player_session_state{}
            ) {}

        LoadPersistentTaskProgress(NewPlayer)
        SyncPlayerTaskStateStrict(NewPlayer)

        InitializeGoldPersistTracker(NewPlayer)
        MarkGoldRestorePending(NewPlayer)

        CreateOrReplacePlayerWidget(NewPlayer)

        if (AreTeamsLocked() = true):
            AssignLateJoiningPlayerToHunter(NewPlayer)
        else:
            set RoundAssignmentPlayerCount = -1
            EnsurePreRoundTeamAssignment()

        RebuildCurrentTeamState()
        RefreshCurrentDisplayedRoleState()
        RebuildRoundTeamSnapshot()
        UpdateAllPropsHUDOnly()
        UpdateWaitingState()

        UpdatePlayerHUD(NewPlayer)
        UpdatePlayerHideTimeHUD(NewPlayer)


    OnPlayerRemoved(
        RemovedPlayer:player
    ):void =
        SavePlayerGoldSnapshot(RemovedPlayer)
        SavePlayerTaskSnapshot(RemovedPlayer)

        if:
            PlayerUI := GetPlayerUI[RemovedPlayer]
            WidgetState := PlayerWidgets[RemovedPlayer]
        then:
            PlayerUI.RemoveWidget(WidgetState.Root)

        if (
            set PendingGoldRestore[RemovedPlayer] = false
        ) {}

        if (
            set GoldRestoreInProgress[RemovedPlayer] = false
        ) {}

        if (
            set CurrentTeam1Snapshot[RemovedPlayer] = false
        ) {}

        if (
            set CurrentTeam2Snapshot[RemovedPlayer] = false
        ) {}

        if (
            set CurrentAliveTeam2Snapshot[RemovedPlayer] = false
        ) {}

        if (
            set CurrentDisplayedPropHUD[RemovedPlayer] = false
        ) {}

        if (
            set CurrentDisplayedHunterHUD[RemovedPlayer] = false
        ) {}

        if (
            set RoundTeam1Snapshot[RemovedPlayer] = false
        ) {}

        if (
            set RoundTeam2Snapshot[RemovedPlayer] = false
        ) {}

        if (
            set TaskTrackersInitialized[RemovedPlayer] = false
        ) {}

        if (
            set TaskProgressLoaded[RemovedPlayer] = false
        ) {}

        if (
            set GoldTrackerInitialized[RemovedPlayer] = false
        ) {}

        if (
            set TaskCompletionPreview[RemovedPlayer] = false
        ) {}

        if (
            set LastAnnouncedTeamRole[RemovedPlayer] = 0
        ) {}

        if (AreTeamsLocked() = false):
            set RoundAssignmentPlayerCount = -1

        RebuildCurrentTeamState()
        RefreshCurrentDisplayedRoleState()
        RebuildRoundTeamSnapshot()
        UpdateWaitingState()
        UpdateAllHUD()


    InitializeSessionTaskValues(
        Player:player
    ):void =
        if:
            ExistingSeconds :=
                CurrentHideSeconds[Player]
        then:
        else:
            if (
                set CurrentHideSeconds[Player] = 0
            ) {}

        if:
            ExistingState :=
                PlayerStates[Player]
        then:
            return
        else:
            if (
                set PlayerStates[Player] =
                    player_session_state{}
            ) {}


    GetHideTimeMinutes(
        Player:player
    ):int =
        if:
            State :=
                PlayerStates[Player]
        then:
            return State.HideMinutes

        0


    GetCurrentHideSeconds(
        Player:player
    ):int =
        if:
            Seconds :=
                CurrentHideSeconds[Player]
        then:
            return Seconds

        0


    CalculateHideTotalSeconds(
        Player:player
    ):int =
        HideMinutes :=
            GetHideTimeMinutes(Player)

        RemainingSeconds :=
            GetCurrentHideSeconds(Player)

        (HideMinutes * 60) + RemainingSeconds


    AddHideTimeSecond(
        Player:player
    ):void =
        InitializeSessionTaskValues(Player)

        CurrentTotalSeconds :=
            CalculateHideTotalSeconds(Player)

        NewTotalSeconds :=
            CurrentTotalSeconds + 1

        var NewMinutes:int = 0
        var RemainingSeconds:int =
            NewTotalSeconds

        loop:
            if (RemainingSeconds < 60):
                break

            set NewMinutes += 1
            set RemainingSeconds -= 60

        if (State := PlayerStates[Player]):
            if (NewMinutes > State.HideMinutes):
                set State.HideMinutes = NewMinutes

        if (
            set CurrentHideSeconds[Player] =
                RemainingSeconds
        ) {}

        if (State := PlayerStates[Player]):
            CheckAwards(
                Player,
                State
            )

        SetSavedHideTotalSeconds(
            Player,
            NewTotalSeconds
        )


    IsHideTaskCompleted(
        Player:player
    ):logic =
        HideMinutes :=
            GetHideTimeMinutes(Player)

        if (HideMinutes >= 10):
            return true

        false


    UpdateWaitingState():void =
        PlayerCount :=
            GetPlayspace().GetPlayers().Length

        if (PlayerCount <= 1):
            set IsWaitingForPlayers = true
            return

        if (RoundTimerStartedThisRound = true):
            set IsWaitingForPlayers = false
            return

        set IsWaitingForPlayers = false


    OnAgentSpawned(
        SpawnedAgent:agent
    ):void =
        if (SpawnedPlayer := player[SpawnedAgent]):
            InitializeTaskPersistTrackers(SpawnedPlayer)
            InitializeSessionTaskValues(SpawnedPlayer)

            RebuildCurrentTeamState()
            RefreshCurrentDisplayedRoleState()
            RebuildRoundTeamSnapshot()

            UpdatePlayerHideTimeHUD(SpawnedPlayer)
            UpdatePlayerHUD(SpawnedPlayer)

            spawn {
                RestorePlayerGoldAfterSpawn(SpawnedPlayer)
            }


    OnTeam2MemberEliminated(
        EliminatedAgent:agent
    ):void =
        if (EliminatedPlayer := player[EliminatedAgent]):
            if (RoundTimerStartedThisRound = true):
                if (
                    set EliminatedAsPropThisRound[EliminatedPlayer] =
                        true
                ) {}

                if (
                    set WasPropThisRound[EliminatedPlayer] =
                        true
                ) {}

                spawn {
                    HandlePropElimination(EliminatedPlayer)
                }


    HandlePropElimination(
        EliminatedPlayer:player
    )<suspends>:void =
        if (WinRecordedThisRound = true):
            return

        RebuildCurrentTeamState()
        RefreshCurrentDisplayedRoleState()

        RemainingProps :=
            CountDisplayedPropHUD()

        if (RemainingProps <= 0):
            return

        TeamCollection :=
            GetPlayspace().GetTeamCollection()

        Teams :=
            TeamCollection.GetTeams()

        if (Team1 := Teams[0]):
            if (
                TeamCollection.AddToTeam[
                    EliminatedPlayer,
                    Team1
                ]
            ):
                Print(
                    "Eliminierter Prop -> Team 1 / Hunter"
                )

        Team1Settings.RespawnAtPlayerSpawner(
            EliminatedPlayer
        )

        RebuildCurrentTeamState()
        RefreshCurrentDisplayedRoleState()
        RebuildRoundTeamSnapshot()

        UpdatePlayerHideTimeHUD(
            EliminatedPlayer
        )

        UpdatePlayerHUD(
            EliminatedPlayer
        )

        UpdateAllHUD()


    AssignLateJoiningPlayerToHunter(
        Player:player
    ):void =
        if (
            set RoundStartHunters[Player] =
                true
        ) {}

        if (
            set RoundStartProps[Player] =
                false
        ) {}

        if (
            set WasPropThisRound[Player] =
                false
        ) {}

        if (
            set EliminatedAsPropThisRound[Player] =
                false
        ) {}

        TeamCollection :=
            GetPlayspace().GetTeamCollection()

        Teams :=
            TeamCollection.GetTeams()

        if (Team1 := Teams[0]):
            if (
                TeamCollection.AddToTeam[
                    Player,
                    Team1
                ]
            ):
                Print(
                    "Late Joiner -> Team 1 / Hunter"
                )

        RebuildCurrentTeamState()
        RefreshCurrentDisplayedRoleState()
        RebuildRoundTeamSnapshot()

        UpdatePlayerHUD(Player)
        UpdatePlayerHideTimeHUD(Player)


    OnPropsCounterSuccess():void =
        CapturePendingLastRoundOutcome(1)


    OnMainRoundTimerSuccess(
        InstigatingAgent:?agent
    ):void =
        CapturePendingLastRoundOutcome(2)


    CapturePendingLastRoundOutcome(
        WinnerTeam:int
    ):void =
        if (RoundTimerStartedThisRound = false):
            return

        if (WinRecordedThisRound = true):
            return

        if (WinnerTeam <> 1):
            if (WinnerTeam <> 2):
                return

        set WinRecordedThisRound = true
        set PendingLastRoundWinnerTeam =
            WinnerTeam
        set PendingLastRoundHunters =
            map{}
        set PendingLastRoundProps =
            map{}

        for (Player : GetPlayspace().GetPlayers()):

            if (WinnerTeam = 1):

                if:
                    WasRoundHunter :=
                        RoundStartHunters[Player]
                then:

                    if (WasRoundHunter = true):

                        if (
                            set PendingLastRoundHunters[Player] =
                                true
                        ) {}

            else:

                if:
                    WasRoundProp :=
                        RoundStartProps[Player]
                then:

                    if (WasRoundProp = true):

                        var WasEliminatedAsProp:logic = false

                        if:
                            EliminatedAsProp :=
                                EliminatedAsPropThisRound[Player]
                        then:

                            set WasEliminatedAsProp =
                                EliminatedAsProp

                        if (WasEliminatedAsProp = false):

                            if (
                                set PendingLastRoundProps[Player] =
                                    true
                            ) {}

        if (WinnerTeam = 1):

            var HunterWinnersCount:int = 0

            for (Player : GetPlayspace().GetPlayers()):

                if:
                    IsWinner :=
                        PendingLastRoundHunters[Player]
                then:

                    if (IsWinner = true):
                        set HunterWinnersCount += 1

            if (HunterWinnersCount <= 0):

                RebuildCurrentTeamState()

                for (Player : GetPlayspace().GetPlayers()):

                    if:
                        IsCurrentHunter :=
                            CurrentTeam1Snapshot[Player]
                    then:

                        if (IsCurrentHunter = true):

                            var WasProp:logic = false

                            if:
                                PropHistory :=
                                    WasPropThisRound[Player]
                            then:

                                set WasProp =
                                    PropHistory

                            if (WasProp = false):

                                if (
                                    set PendingLastRoundHunters[Player] =
                                        true
                                ) {}

        else:

            var PropWinnersCount:int = 0

            for (Player : GetPlayspace().GetPlayers()):

                if:
                    IsWinner :=
                        PendingLastRoundProps[Player]
                then:

                    if (IsWinner = true):
                        set PropWinnersCount += 1

            if (PropWinnersCount <= 0):

                RebuildCurrentTeamState()

                for (Player : GetPlayspace().GetPlayers()):

                    if:
                        IsCurrentProp :=
                            CurrentTeam2Snapshot[Player]
                    then:

                        if (IsCurrentProp = true):

                            var WasEliminatedAsProp:logic = false

                            if:
                                EliminatedAsProp :=
                                    EliminatedAsPropThisRound[Player]
                            then:

                                set WasEliminatedAsProp =
                                    EliminatedAsProp

                            if (WasEliminatedAsProp = false):

                                if (
                                    set PendingLastRoundProps[Player] =
                                        true
                                ) {}


    EvaluateTeam1WinAfterDelay()<suspends>:void =
        RoundToken :=
            RoundWinEvaluationToken

        TryAwardTeam1WinWithRetries(RoundToken)


    CaptureEligibleHuntersForTeam1Win():void =
        set EligibleHuntersForTeam1Win =
            map{}

        RebuildCurrentTeamState()

        for (Player : GetPlayspace().GetPlayers()):

            if:
                IsHunter :=
                    CurrentTeam1Snapshot[Player]
            then:

                if (IsHunter = true):

                    var WasProp:logic = false

                    if:
                        WasPropHistory :=
                            WasPropThisRound[Player]
                    then:

                        set WasProp =
                            WasPropHistory

                    if (WasProp = false):

                        if (
                            Character :=
                                Player.GetFortCharacter[]
                        ):

                            if:
                                IsActive :=
                                    Character.IsActive[]
                            then:

                                if (IsActive = true):

                                    if (
                                        set EligibleHuntersForTeam1Win[Player] =
                                            true
                                    ) {}


    CaptureEligibleHuntersForTeam1WinIgnoringActive():void =
        set EligibleHuntersForTeam1Win =
            map{}

        RebuildCurrentTeamState()

        for (Player : GetPlayspace().GetPlayers()):

            if:
                IsHunter :=
                    CurrentTeam1Snapshot[Player]
            then:

                if (IsHunter = true):

                    var WasProp:logic = false

                    if:
                        WasPropHistory :=
                            WasPropThisRound[Player]
                    then:

                        set WasProp =
                            WasPropHistory

                    if (WasProp = false):

                        if (
                            set EligibleHuntersForTeam1Win[Player] =
                                true
                        ) {}


    CountEligibleHuntersForTeam1Win():int =

        var Count:int = 0

        for (Player : GetPlayspace().GetPlayers()):

            if:
                IsEligible :=
                    EligibleHuntersForTeam1Win[Player]
            then:

                if (IsEligible = true):
                    set Count += 1

        Count


    TryAwardTeam1WinImmediate(
        RoundToken:int
    ):void =

        if (WinRecordedThisRound = true):
            return

        if (RoundToken <> RoundWinEvaluationToken):
            return

        RebuildCurrentTeamState()
        RefreshCurrentDisplayedRoleState()

        AliveProps :=
            CountAliveTeam2Players()

        if (AliveProps > 0):
            return

        EligibleCount :=
            CountEligibleHuntersForTeam1Win()

        if (EligibleCount <= 0):

            CaptureEligibleHuntersForTeam1WinIgnoringActive()

            FallbackEligibleCount :=
                CountEligibleHuntersForTeam1Win()

            if (FallbackEligibleCount <= 0):
                return

        AwardTeam1RoundWin()


    TryAwardTeam1WinWithRetries(
        RoundToken:int
    )<suspends>:void =

        var Attempt:int = 0

        loop:

            if (WinRecordedThisRound = true):
                return

            if (RoundToken <> RoundWinEvaluationToken):
                return

            RebuildCurrentTeamState()
            RefreshCurrentDisplayedRoleState()

            AliveProps :=
                CountAliveTeam2Players()

            if (AliveProps <= 0):

                TryAwardTeam1WinImmediate(RoundToken)

                return

            if (Attempt >= 5):
                return

            set Attempt += 1

            Sleep(0.2)


    TryAwardTeam2WinWithRetries(
        RoundToken:int
    )<suspends>:void =

        var Attempt:int = 0

        loop:

            if (WinRecordedThisRound = true):
                return

            if (RoundToken <> RoundWinEvaluationToken):
                return

            RebuildCurrentTeamState()
            RefreshCurrentDisplayedRoleState()

            AliveProps :=
                CountAliveTeam2Players()

            if (AliveProps > 0):
                AwardTeam2RoundWin()

                return

            if (Attempt >= 5):
                return

            set Attempt += 1

            Sleep(0.2)


    EvaluateTeam2WinAfterDelay()<suspends>:void =
        RoundToken :=
            RoundWinEvaluationToken

        TryAwardTeam2WinWithRetries(RoundToken)


    OnStartupTimerSuccess(
        Instigator:?agent
    ):void =
        UpdateWaitingState()
        RebuildCurrentTeamState()
        RefreshCurrentDisplayedRoleState()
        RebuildRoundTeamSnapshot()
        UpdateAllHUD()


    OnSimulatePlayerButtonPressed(
        Agent:agent
    ):void =
        if (InteractingPlayer := player[Agent]):

            var IsPreviewEnabled:logic = false

            if:
                ExistingPreview :=
                    TaskCompletionPreview[InteractingPlayer]
            then:

                set IsPreviewEnabled = ExistingPreview

            if (IsPreviewEnabled = true):

                if (
                    set TaskCompletionPreview[InteractingPlayer] =
                        false
                ) {}

                Print("Task-X Preview: OFF")

            else:

                if (
                    set TaskCompletionPreview[InteractingPlayer] =
                        true
                ) {}

                Print("Task-X Preview: ON")

            if:
                WidgetState :=
                    PlayerWidgets[InteractingPlayer]
            then:

                set WidgetState.LastDisplayedRounds = -1
                set WidgetState.LastDisplayedHideMinutes = -1
                set WidgetState.LastDisplayedHideCompleted = false

            UpdatePlayerHUD(InteractingPlayer)
            UpdatePlayerHideTimeHUD(InteractingPlayer)


    InitializePlayer(
        Player:player
    ):void =
        InitializeTaskPersistTrackers(Player)
        InitializeSessionTaskValues(Player)
        InitializeGoldPersistTracker(Player)
        MarkGoldRestorePending(Player)

        if (ExistingState := PlayerStates[Player]):
            Print(
                "HUD: vorhandenen Player-State behalten"
            )
        else:
            if (
                set PlayerStates[Player] =
                    player_session_state{}
            ) {}

        LoadPersistentTaskProgress(Player)
        SyncPlayerTaskStateStrict(Player)

        CreateOrReplacePlayerWidget(Player)

        if (
            set CurrentTeam1Snapshot[Player] = false
        ) {}

        if (
            set CurrentTeam2Snapshot[Player] = false
        ) {}

        if (
            set CurrentAliveTeam2Snapshot[Player] = false
        ) {}

        if (
            set CurrentDisplayedPropHUD[Player] = false
        ) {}

        if (
            set CurrentDisplayedHunterHUD[Player] = false
        ) {}

        UpdatePlayerHUD(Player)
        UpdatePlayerHideTimeHUD(Player)


    IsTaskCompletionPreviewEnabled(
        Player:player
    ):logic =
        if:
            PreviewEnabled :=
                TaskCompletionPreview[Player]
        then:
            return PreviewEnabled

        false


    GetGoldInventoryCount(
        Player:player
    ):int =
        GoldInventoryReader.GetItemCount(
            Player,
            0
        )


    InitializeGoldPersistTracker(
        Player:player
    ):void =
        if:
            IsInitialized :=
                GoldTrackerInitialized[Player]
        then:
            if (IsInitialized = true):
                return

        GoldPersistTracker.Assign(Player)
        GoldPersistTracker.Load(Player)

        if (
            set GoldTrackerInitialized[Player] = true
        ) {}


    MarkGoldRestorePending(
        Player:player
    ):void =
        if (
            set PendingGoldRestore[Player] = true
        ) {}


    ClearGoldRestorePending(
        Player:player
    ):void =
        if (
            set PendingGoldRestore[Player] = false
        ) {}


    IsGoldRestorePending(
        Player:player
    ):logic =
        if (
            Pending :=
                PendingGoldRestore[Player]
        ):
            return Pending

        false


    ShouldRunPendingGoldRestore(
        Player:player
    ):logic =
        PendingRestore :=
            IsGoldRestorePending(Player)

        if (PendingRestore = false):
            return false

        CurrentGold :=
            GetGoldInventoryCount(Player)

        SavedGold :=
            GetSavedGold(Player)

        if (CurrentGold < SavedGold):
            return true

        if (RoundTimerStartedThisRound = true):
            return true

        false


    TryQueuePendingGoldRestore(
        Player:player
    ):void =
        ShouldRestore :=
            ShouldRunPendingGoldRestore(Player)

        if (ShouldRestore = false):
            return

        if:
            RestoreRunning :=
                GoldRestoreInProgress[Player]
        then:
            if (RestoreRunning = true):
                return

        spawn {
            RestorePlayerGoldAfterSpawn(Player)
        }


    AcquireGoldRestoreGranterLock()<suspends>:void =
        loop:
            if (GoldRestoreGranterBusy = false):
                set GoldRestoreGranterBusy = true
                return

            Sleep(0.0)


    ReleaseGoldRestoreGranterLock():void =
        if (GoldRestoreGranterBusy = true):
            set GoldRestoreGranterBusy = false


    GetSavedGold(
        Player:player
    ):int =
        GoldPersistTracker.GetValue(Player)


    SetSavedGold(
        Player:player,
        GoldAmount:int
    ):void =
        GoldPersistTracker.SetValue(
            Player,
            GoldAmount
        )

        GoldPersistTracker.Save(Player)


    SavePlayerGoldSnapshot(
        Player:player
    ):void =
        PendingRestore :=
            IsGoldRestorePending(Player)

        if (PendingRestore = true):
            return

        CurrentGold :=
            GetGoldInventoryCount(Player)

        SavedGold :=
            GetSavedGold(Player)

        if (CurrentGold <> SavedGold):
            SetSavedGold(
                Player,
                CurrentGold
            )


    UpdatePlayerGoldHUD(
        Player:player
    ):void =
        if:
            WidgetState :=
                PlayerWidgets[Player]
        then:

            CurrentGold :=
                GetGoldInventoryCount(Player)

            var DisplayedGold:int =
                CurrentGold

            PendingRestore :=
                IsGoldRestorePending(Player)

            if (PendingRestore = true):
                SavedGold :=
                    GetSavedGold(Player)

                if (SavedGold > DisplayedGold):
                    set DisplayedGold = SavedGold

            if (
                DisplayedGold <>
                WidgetState.LastDisplayedGold
            ):

                CoinCountText :=
                    ToString(DisplayedGold)

                WidgetState.CoinText.SetText(
                    ToMessage(CoinCountText)
                )

                WidgetState.CoinTextOutline.SetText(
                    ToMessage(CoinCountText)
                )

                set WidgetState.LastDisplayedGold =
                    DisplayedGold


    GoldTrackingLoop()<suspends>:void =
        loop:

            Sleep(0.5)

            for (Player : GetPlayspace().GetPlayers()):

                TryQueuePendingGoldRestore(Player)
                SavePlayerGoldSnapshot(Player)
                UpdatePlayerGoldHUD(Player)


    RestorePlayerGoldAfterSpawn(
        Player:player
    )<suspends>:void =
        if:
            RestoreRunning :=
                GoldRestoreInProgress[Player]
        then:
            if (RestoreRunning = true):
                return

        if (
            set GoldRestoreInProgress[Player] = true
        ) {}

        InitializeGoldPersistTracker(Player)
        MarkGoldRestorePending(Player)

        Sleep(0.0)

        SavedGold :=
            GetSavedGold(Player)

        CurrentGold :=
            GetGoldInventoryCount(Player)

        MissingGold :=
            SavedGold - CurrentGold

        if (MissingGold > 0):
            AcquireGoldRestoreGranterLock()

            GoldRestoreGranter.SetItemGrantCountAtIndex(
                0,
                MissingGold
            )

            GoldRestoreGranter.GrantItemIndex(
                Player,
                0
            )

            ReleaseGoldRestoreGranterLock()

            Sleep(0.0)

        SavePlayerGoldSnapshotAfterRestore(Player)

        UpdatePlayerHUD(Player)

        if (
            set GoldRestoreInProgress[Player] = false
        ) {}


    SavePlayerGoldSnapshotAfterRestore(
        Player:player
    ):void =
        CurrentGold :=
            GetGoldInventoryCount(Player)

        SetSavedGold(
            Player,
            CurrentGold
        )

        ClearGoldRestorePending(Player)


    InitializeTaskPersistTrackers(
        Player:player
    ):void =
        if:
            IsInitialized :=
                TaskTrackersInitialized[Player]
        then:
            if (IsInitialized = true):
                return

        WinsPersistTracker.Assign(Player)
        RoundsPersistTracker.Assign(Player)
        HidePersistTracker.Assign(Player)

        if (
            set TaskTrackersInitialized[Player] = true
        ) {}


    LoadPersistentTaskProgress(
        Player:player
    ):void =
        InitializeTaskPersistTrackers(Player)

        if:
            IsLoaded :=
                TaskProgressLoaded[Player]
        then:
            if (IsLoaded = true):
                return

        WinsPersistTracker.Load(Player)
        RoundsPersistTracker.Load(Player)
        HidePersistTracker.Load(Player)

        if (
            set TaskProgressLoaded[Player] = true
        ) {}

        InitializeSessionTaskValues(Player)

        WinsValue :=
            WinsPersistTracker.GetValue(Player)

        RoundsValue :=
            RoundsPersistTracker.GetValue(Player)

        HideTotalSeconds :=
            HidePersistTracker.GetValue(Player)

        if (State := PlayerStates[Player]):

            if (WinsValue > State.Wins):
                set State.Wins = WinsValue

            if (RoundsValue > State.PlayedRounds):
                set State.PlayedRounds = RoundsValue

            var LoadedHideMinutes:int = 0
            var LoadedHideSeconds:int =
                HideTotalSeconds

            loop:
                if (LoadedHideSeconds < 60):
                    break

                set LoadedHideMinutes += 1
                set LoadedHideSeconds -= 60

            if (LoadedHideMinutes > State.HideMinutes):
                set State.HideMinutes =
                    LoadedHideMinutes

            if (
                set CurrentHideSeconds[Player] =
                    LoadedHideSeconds
            ) {}


    GetSavedWins(
        Player:player
    ):int =
        InitializeTaskPersistTrackers(Player)

        WinsPersistTracker.GetValue(Player)


    GetSavedRounds(
        Player:player
    ):int =
        InitializeTaskPersistTrackers(Player)

        RoundsPersistTracker.GetValue(Player)


    GetSavedHideTotalSeconds(
        Player:player
    ):int =
        InitializeTaskPersistTrackers(Player)

        HidePersistTracker.GetValue(Player)


    GetSavedHideMinutes(
        Player:player
    ):int =
        HideTotalSeconds :=
            GetSavedHideTotalSeconds(Player)

        var Minutes:int = 0
        var RemainingSeconds:int =
            HideTotalSeconds

        loop:
            if (RemainingSeconds < 60):
                break

            set Minutes += 1
            set RemainingSeconds -= 60

        Minutes


    SetSavedWins(
        Player:player,
        Wins:int
    ):void =
        InitializeTaskPersistTrackers(Player)

        SavedWins :=
            WinsPersistTracker.GetValue(Player)

        if (Wins > SavedWins):

            WinsPersistTracker.SetValue(
                Player,
                Wins
            )

            WinsPersistTracker.Save(Player)


    SetSavedRounds(
        Player:player,
        PlayedRounds:int
    ):void =
        InitializeTaskPersistTrackers(Player)

        SavedRounds :=
            RoundsPersistTracker.GetValue(Player)

        if (PlayedRounds > SavedRounds):

            RoundsPersistTracker.SetValue(
                Player,
                PlayedRounds
            )

            RoundsPersistTracker.Save(Player)


    SetSavedHideTotalSeconds(
        Player:player,
        TotalSeconds:int
    ):void =
        InitializeTaskPersistTrackers(Player)

        SavedSeconds :=
            HidePersistTracker.GetValue(Player)

        if (TotalSeconds > SavedSeconds):

            HidePersistTracker.SetValue(
                Player,
                TotalSeconds
            )

            HidePersistTracker.Save(Player)


    SyncPlayerTaskStateStrict(
        Player:player
    ):void =
        InitializeTaskPersistTrackers(Player)
        InitializeSessionTaskValues(Player)

        if (State := PlayerStates[Player]):

            SavedWins :=
                GetSavedWins(Player)

            if (SavedWins > State.Wins):
                set State.Wins =
                    SavedWins

            SavedRounds :=
                GetSavedRounds(Player)

            if (SavedRounds > State.PlayedRounds):
                set State.PlayedRounds =
                    SavedRounds

            SavedHideTotalSeconds :=
                GetSavedHideTotalSeconds(Player)

            CurrentHideTotalSeconds :=
                CalculateHideTotalSeconds(Player)

            if (SavedHideTotalSeconds > CurrentHideTotalSeconds):

                var SyncHideMinutes:int = 0
                var SyncRemainingSeconds:int =
                    SavedHideTotalSeconds

                loop:
                    if (SyncRemainingSeconds < 60):
                        break

                    set SyncHideMinutes += 1
                    set SyncRemainingSeconds -= 60

                if (SyncHideMinutes > State.HideMinutes):
                    set State.HideMinutes =
                        SyncHideMinutes

                if (
                    set CurrentHideSeconds[Player] =
                        SyncRemainingSeconds
                ) {}

            CheckAwards(
                Player,
                State
            )


    SaveAllPersistentTaskProgress(
        Player:player
    ):void =
        InitializeTaskPersistTrackers(Player)
        InitializeSessionTaskValues(Player)

        if (State := PlayerStates[Player]):

            SavedWins :=
                WinsPersistTracker.GetValue(Player)

            if (State.Wins > SavedWins):

                WinsPersistTracker.SetValue(
                    Player,
                    State.Wins
                )

                WinsPersistTracker.Save(Player)

            SavedRounds :=
                RoundsPersistTracker.GetValue(Player)

            if (State.PlayedRounds > SavedRounds):

                RoundsPersistTracker.SetValue(
                    Player,
                    State.PlayedRounds
                )

                RoundsPersistTracker.Save(Player)

            CurrentHideTotalSeconds :=
                CalculateHideTotalSeconds(Player)

            SavedHideTotalSeconds :=
                HidePersistTracker.GetValue(Player)

            if (CurrentHideTotalSeconds > SavedHideTotalSeconds):

                HidePersistTracker.SetValue(
                    Player,
                    CurrentHideTotalSeconds
                )

                HidePersistTracker.Save(Player)


    SavePlayerTaskSnapshot(
        Player:player
    ):void =
        SyncPlayerTaskStateStrict(Player)
        SaveAllPersistentTaskProgress(Player)


    RunSpawnTaskIntegrityPass(
        Player:player
    )<suspends>:void =

        InitializeSessionTaskValues(Player)
        SyncPlayerTaskStateStrict(Player)

        UpdatePlayerHUD(Player)
        UpdatePlayerHideTimeHUD(Player)

        Sleep(0.25)

        InitializeSessionTaskValues(Player)
        SyncPlayerTaskStateStrict(Player)

        UpdatePlayerHUD(Player)
        UpdatePlayerHideTimeHUD(Player)


    RunRoundStartTaskIntegrityPass()<suspends>:void =

        for (Player : GetPlayspace().GetPlayers()):

            InitializeSessionTaskValues(Player)
            SyncPlayerTaskStateStrict(Player)

        UpdateAllHUD()

        Sleep(0.25)

        for (Player : GetPlayspace().GetPlayers()):

            InitializeSessionTaskValues(Player)
            SyncPlayerTaskStateStrict(Player)

        UpdateAllHUD()


    # Aufteilungs-Schema: 1 Spieler = Warten, 2-5 = 1 Hunter, 6-8 = 2, 9-12 = 3, ab 13 = 4. Rest = Props.
    GetDesiredHunterCount(
        PlayerCount:int
    ):int =

        if (PlayerCount <= 1):
            return 0

        if (PlayerCount <= 5):
            return 1

        if (PlayerCount <= 8):
            return 2

        if (PlayerCount <= 12):
            return 3

        return 4


    GetDesiredPropCount(
        PlayerCount:int
    ):int =

        HunterCount :=
            GetDesiredHunterCount(PlayerCount)

        PlayerCount - HunterCount


    # Zuteilung vor Rundenstart. Bestehende Zuteilung bleibt erhalten (keine unnoetigen Teamwechsel
    # bei jedem Join), es wird nur die Differenz zum Schema zufaellig ausgeglichen.
    # Nach RoundBegin ist RoundTeamAssignment leer -> jede Runde wird komplett neu gelost.
    BuildRandomRoundTeamAssignment():void =

        Players :=
            GetPlayspace().GetPlayers()

        PlayerCount :=
            Players.Length

        if (PlayerCount < 2):

            set RoundAssignmentPlayerCount =
                PlayerCount

            return

        HunterCount :=
            GetDesiredHunterCount(PlayerCount)

        var KeptHunters:[]player = array{}
        var OtherPlayers:[]player = array{}

        for (Player : Shuffle(Players)):

            if (AssignedTeam := RoundTeamAssignment[Player], AssignedTeam = 1):

                set KeptHunters += array{Player}

            else:

                set OtherPlayers += array{Player}

        var NewAssignment:[player]int = map{}

        var Index:int = 0

        # Bisherige Hunter bleiben Hunter (ueberzaehlige werden Props)
        for (Player : KeptHunters):

            if (Index < HunterCount):

                if (
                    set NewAssignment[Player] = 1
                ) {}

            else:

                if (
                    set NewAssignment[Player] = 2
                ) {}

            set Index += 1

        # Fehlende Hunter zufaellig aus Props + neuen Spielern, alle anderen Props
        for (Player : OtherPlayers):

            if (Index < HunterCount):

                if (
                    set NewAssignment[Player] = 1
                ) {}

            else:

                if (
                    set NewAssignment[Player] = 2
                ) {}

            set Index += 1

        set RoundTeamAssignment =
            NewAssignment

        set RoundAssignmentPlayerCount =
            PlayerCount


    EnsurePreRoundTeamAssignment():void =

        if (AreTeamsLocked() = true):
            return

        Players :=
            GetPlayspace().GetPlayers()

        PlayerCount :=
            Players.Length

        if (PlayerCount < 2):

            set IsWaitingForPlayers = true

            return

        if (
            RoundAssignmentPlayerCount <>
            PlayerCount
        ):

            BuildRandomRoundTeamAssignment()
            ApplyRoundTeamAssignment()

            return

        var NeedsNewAssignment:logic = false

        for (Player : Players):

            if (
                AssignedTeam :=
                    RoundTeamAssignment[Player]
            ):
            else:
                set NeedsNewAssignment = true

        if (NeedsNewAssignment = true):

            BuildRandomRoundTeamAssignment()
            ApplyRoundTeamAssignment()


    ApplyRoundTeamAssignment():void =

        if (AreTeamsLocked() = true):
            return

        TeamCollection :=
            GetPlayspace().GetTeamCollection()

        Teams :=
            TeamCollection.GetTeams()

        if:
            Team1 := Teams[0]
            Team2 := Teams[1]
        then:

            for (Player : GetPlayspace().GetPlayers()):

                if (
                    AssignedTeam :=
                        RoundTeamAssignment[Player]
                ):

                    if (AssignedTeam = 1):

                        if (
                            TeamCollection.IsOnTeam[
                                Player,
                                Team1
                            ]
                        ):
                        else:

                            if (
                                TeamCollection.AddToTeam[
                                    Player,
                                    Team1
                                ]
                            ):

                                Print(
                                    "PreRound: Hunter"
                                )

                    else:

                        if (
                            TeamCollection.IsOnTeam[
                                Player,
                                Team2
                            ]
                        ):
                        else:

                            if (
                                TeamCollection.AddToTeam[
                                    Player,
                                    Team2
                                ]
                            ):

                                Print(
                                    "PreRound: Prop"
                                )

        RebuildCurrentTeamState()
        RefreshCurrentDisplayedRoleState()
        RebuildRoundTeamSnapshot()
        UpdateAllPropsHUDOnly()


    ValidateRoundTeamAssignment():void =

        if (AreTeamsLocked() = true):
            return

        Players :=
            GetPlayspace().GetPlayers()

        PlayerCount :=
            Players.Length

        if (PlayerCount < 2):
            return

        DesiredHunters :=
            GetDesiredHunterCount(PlayerCount)

        DesiredProps :=
            GetDesiredPropCount(PlayerCount)

        if (CurrentTeam1Count <> DesiredHunters):

            ApplyRoundTeamAssignment()

            return

        if (CurrentTeam2Count <> DesiredProps):

            ApplyRoundTeamAssignment()

            return


    PreRoundTeamCheckLoop(
        LoopToken:int
    )<suspends>:void =

        loop:

            if (LoopToken <> RoundLoopToken):
                return

            if (AreTeamsLocked() = true):
                return

            EnsurePreRoundTeamAssignment()
            ValidateRoundTeamAssignment()
            UpdateAllPropsHUDOnly()

            Sleep(1.0)


    IsPlayerInTeam1Settings(
        Player:player
    ):logic =

        TeamMembers :=
            Team1Settings.GetTeamMembers()

        for (Member : TeamMembers):

            if (MemberPlayer := player[Member]):

                if (MemberPlayer = Player):
                    return true

        false


    IsPlayerInTeam2Settings(
        Player:player
    ):logic =

        TeamMembers2 :=
            Team2Class2Settings.GetTeamMembers()

        for (Member : TeamMembers2):

            if (MemberPlayer := player[Member]):

                if (MemberPlayer = Player):
                    return true


        TeamMembers3 :=
            Team2Class3Settings.GetTeamMembers()

        for (Member : TeamMembers3):

            if (MemberPlayer := player[Member]):

                if (MemberPlayer = Player):
                    return true


        TeamMembers4 :=
            Team2Class4Settings.GetTeamMembers()

        for (Member : TeamMembers4):

            if (MemberPlayer := player[Member]):

                if (MemberPlayer = Player):
                    return true


        TeamMembers5 :=
            Team2Class5Settings.GetTeamMembers()

        for (Member : TeamMembers5):

            if (MemberPlayer := player[Member]):

                if (MemberPlayer = Player):
                    return true


        TeamMembers6 :=
            Team2Class6Settings.GetTeamMembers()

        for (Member : TeamMembers6):

            if (MemberPlayer := player[Member]):

                if (MemberPlayer = Player):
                    return true


        TeamMembers7 :=
            Team2Class7Settings.GetTeamMembers()

        for (Member : TeamMembers7):

            if (MemberPlayer := player[Member]):

                if (MemberPlayer = Player):
                    return true


        TeamMembers8 :=
            Team2Class8Settings.GetTeamMembers()

        for (Member : TeamMembers8):

            if (MemberPlayer := player[Member]):

                if (MemberPlayer = Player):
                    return true


        TeamMembers9 :=
            Team2Class9Settings.GetTeamMembers()

        for (Member : TeamMembers9):

            if (MemberPlayer := player[Member]):

                if (MemberPlayer = Player):
                    return true


        TeamMembers10 :=
            Team2Class10Settings.GetTeamMembers()

        for (Member : TeamMembers10):

            if (MemberPlayer := player[Member]):

                if (MemberPlayer = Player):
                    return true


        TeamMembers11 :=
            Team2Class11Settings.GetTeamMembers()

        for (Member : TeamMembers11):

            if (MemberPlayer := player[Member]):

                if (MemberPlayer = Player):
                    return true


        TeamMembers12 :=
            Team2Class12Settings.GetTeamMembers()

        for (Member : TeamMembers12):

            if (MemberPlayer := player[Member]):

                if (MemberPlayer = Player):
                    return true


        TeamMembers13 :=
            Team2Class13Settings.GetTeamMembers()

        for (Member : TeamMembers13):

            if (MemberPlayer := player[Member]):

                if (MemberPlayer = Player):
                    return true

        false


    IsPlayerInIslandTeam1(
        Player:player
    ):logic =

        TeamCollection :=
            GetPlayspace().GetTeamCollection()

        Teams :=
            TeamCollection.GetTeams()

        if (Team1 := Teams[0]):

            if (
                TeamCollection.IsOnTeam[
                    Player,
                    Team1
                ]
            ):
                return true

        false


    IsPlayerInIslandTeam2(
        Player:player
    ):logic =

        TeamCollection :=
            GetPlayspace().GetTeamCollection()

        Teams :=
            TeamCollection.GetTeams()

        if (Team2 := Teams[1]):

            if (
                TeamCollection.IsOnTeam[
                    Player,
                    Team2
                ]
            ):
                return true

        false


    IsPlayerActuallyOnTeam1(
        Player:player
    ):logic =

        SettingsResult :=
            IsPlayerInTeam1Settings(Player)

        if (SettingsResult = true):
            return true

        IslandResult :=
            IsPlayerInIslandTeam1(Player)

        if (IslandResult = true):
            return true

        false


    IsPlayerActuallyOnTeam2(
        Player:player
    ):logic =

        SettingsResult :=
            IsPlayerInTeam2Settings(Player)

        if (SettingsResult = true):
            return true

        IslandResult :=
            IsPlayerInIslandTeam2(Player)

        if (IslandResult = true):
            return true

        false


    RebuildCurrentTeamState():void =

        Playspace :=
            GetPlayspace()

        TeamCollection :=
            Playspace.GetTeamCollection()

        Teams :=
            TeamCollection.GetTeams()

        var Team1SettingsSnapshot:[player]logic = map{}
        var Team2SettingsSnapshot:[player]logic = map{}

        Team1Members :=
            Team1Settings.GetTeamMembers()

        for (Member : Team1Members):

            if (MemberPlayer := player[Member]):

                if (
                    set Team1SettingsSnapshot[MemberPlayer] =
                        true
                ) {}


        Team2Members2 :=
            Team2Class2Settings.GetTeamMembers()

        for (Member : Team2Members2):

            if (MemberPlayer := player[Member]):

                if (
                    set Team2SettingsSnapshot[MemberPlayer] =
                        true
                ) {}


        Team2Members3 :=
            Team2Class3Settings.GetTeamMembers()

        for (Member : Team2Members3):

            if (MemberPlayer := player[Member]):

                if (
                    set Team2SettingsSnapshot[MemberPlayer] =
                        true
                ) {}


        Team2Members4 :=
            Team2Class4Settings.GetTeamMembers()

        for (Member : Team2Members4):

            if (MemberPlayer := player[Member]):

                if (
                    set Team2SettingsSnapshot[MemberPlayer] =
                        true
                ) {}


        Team2Members5 :=
            Team2Class5Settings.GetTeamMembers()

        for (Member : Team2Members5):

            if (MemberPlayer := player[Member]):

                if (
                    set Team2SettingsSnapshot[MemberPlayer] =
                        true
                ) {}


        Team2Members6 :=
            Team2Class6Settings.GetTeamMembers()

        for (Member : Team2Members6):

            if (MemberPlayer := player[Member]):

                if (
                    set Team2SettingsSnapshot[MemberPlayer] =
                        true
                ) {}


        Team2Members7 :=
            Team2Class7Settings.GetTeamMembers()

        for (Member : Team2Members7):

            if (MemberPlayer := player[Member]):

                if (
                    set Team2SettingsSnapshot[MemberPlayer] =
                        true
                ) {}


        Team2Members8 :=
            Team2Class8Settings.GetTeamMembers()

        for (Member : Team2Members8):

            if (MemberPlayer := player[Member]):

                if (
                    set Team2SettingsSnapshot[MemberPlayer] =
                        true
                ) {}


        Team2Members9 :=
            Team2Class9Settings.GetTeamMembers()

        for (Member : Team2Members9):

            if (MemberPlayer := player[Member]):

                if (
                    set Team2SettingsSnapshot[MemberPlayer] =
                        true
                ) {}


        Team2Members10 :=
            Team2Class10Settings.GetTeamMembers()

        for (Member : Team2Members10):

            if (MemberPlayer := player[Member]):

                if (
                    set Team2SettingsSnapshot[MemberPlayer] =
                        true
                ) {}


        Team2Members11 :=
            Team2Class11Settings.GetTeamMembers()

        for (Member : Team2Members11):

            if (MemberPlayer := player[Member]):

                if (
                    set Team2SettingsSnapshot[MemberPlayer] =
                        true
                ) {}


        Team2Members12 :=
            Team2Class12Settings.GetTeamMembers()

        for (Member : Team2Members12):

            if (MemberPlayer := player[Member]):

                if (
                    set Team2SettingsSnapshot[MemberPlayer] =
                        true
                ) {}


        Team2Members13 :=
            Team2Class13Settings.GetTeamMembers()

        for (Member : Team2Members13):

            if (MemberPlayer := player[Member]):

                if (
                    set Team2SettingsSnapshot[MemberPlayer] =
                        true
                ) {}


        var NewTeam1Count:int = 0
        var NewTeam2Count:int = 0

        for (Player : Playspace.GetPlayers()):

            var IsTeam1:logic = false
            var IsTeam2:logic = false

            if:
                SettingsTeam2 :=
                    Team2SettingsSnapshot[Player]
            then:

                if (SettingsTeam2 = true):
                    set IsTeam2 = true


            if (IsTeam2 = false):

                if:
                    SettingsTeam1 :=
                        Team1SettingsSnapshot[Player]
                then:

                    if (SettingsTeam1 = true):
                        set IsTeam1 = true


            if (IsTeam2 = false):

                if (IsTeam1 = false):

                    if:
                        Team2 :=
                            Teams[1]
                    then:

                        if (
                            TeamCollection.IsOnTeam[
                                Player,
                                Team2
                            ]
                        ):

                            set IsTeam2 = true


                    if (IsTeam2 = false):

                        if:
                            Team1 :=
                                Teams[0]
                        then:

                            if (
                                TeamCollection.IsOnTeam[
                                    Player,
                                    Team1
                                ]
                            ):

                                set IsTeam1 = true


            if (IsTeam2 = true):

                if (
                    set CurrentTeam2Snapshot[Player] =
                        true
                ) {}

                if (
                    set CurrentTeam1Snapshot[Player] =
                        false
                ) {}

                set NewTeam2Count += 1

                if (
                    Character :=
                        Player.GetFortCharacter[]
                ):

                    if:
                        IsActive :=
                            Character.IsActive[]
                    then:

                        if (IsActive = true):

                            if (
                                set CurrentAliveTeam2Snapshot[Player] =
                                    true
                            ) {}

                        else:

                            if (
                                set CurrentAliveTeam2Snapshot[Player] =
                                    false
                            ) {}

                    else:

                        if (
                            set CurrentAliveTeam2Snapshot[Player] =
                                false
                        ) {}

                else:

                    if (
                        set CurrentAliveTeam2Snapshot[Player] =
                            false
                    ) {}


            else if (IsTeam1 = true):

                if (
                    set CurrentTeam1Snapshot[Player] =
                        true
                ) {}

                if (
                    set CurrentTeam2Snapshot[Player] =
                        false
                ) {}

                if (
                    set CurrentAliveTeam2Snapshot[Player] =
                        false
                ) {}

                set NewTeam1Count += 1


            else:

                if (
                    set CurrentTeam1Snapshot[Player] =
                        false
                ) {}

                if (
                    set CurrentTeam2Snapshot[Player] =
                        false
                ) {}

                if (
                    set CurrentAliveTeam2Snapshot[Player] =
                        false
                ) {}

            TrackAndAnnounceAssignedTeamRole(
                Player,
                IsTeam1,
                IsTeam2
            )

        set CurrentTeam1Count =
            NewTeam1Count

        set CurrentTeam2Count =
            NewTeam2Count


    CountTeam1Players():int =
        CurrentTeam1Count


    CountTeam2Players():int =
        CurrentTeam2Count


    TrackAndAnnounceAssignedTeamRole(
        Player:player,
        IsTeam1:logic,
        IsTeam2:logic
    ):void =

        var NewRole:int = 0

        if (IsTeam2 = true):
            set NewRole = 2
        else if (IsTeam1 = true):
            set NewRole = 1

        if (NewRole = 0):
            return

        var PreviousRole:int = 0

        if:
            StoredRole :=
                LastAnnouncedTeamRole[Player]
        then:

            set PreviousRole =
                StoredRole

        if (PreviousRole = NewRole):
            return

        if (
            set LastAnnouncedTeamRole[Player] =
                NewRole
        ) {}

        if (NewRole = 1):

            TeamRoleHUDMessage.Show(
                Player,
                ToMessage("You are: HUNTER")
            )

            return


        if (NewRole = 2):

            TeamRoleHUDMessage.Show(
                Player,
                ToMessage("You are: PROP")
            )


    CountAliveTeam2Players():int =

        var Count:int = 0

        for (Player : GetPlayspace().GetPlayers()):

            if:
                IsTeam2 :=
                    CurrentTeam2Snapshot[Player]
            then:

                if (IsTeam2 = true):

                    if (
                        Character :=
                            Player.GetFortCharacter[]
                    ):

                        if:
                            IsActive :=
                                Character.IsActive[]
                        then:

                            if (IsActive = true):
                                set Count += 1

        set Count += SimulatedExtraPlayers

        if (Count < 0):
            return 0

        Count


    RebuildRoundTeamSnapshot():void =

        for (Player : GetPlayspace().GetPlayers()):

            if:
                IsTeam1 :=
                    CurrentTeam1Snapshot[Player]
            then:

                if (
                    set RoundTeam1Snapshot[Player] =
                        IsTeam1
                ) {}


            if:
                IsTeam2 :=
                    CurrentTeam2Snapshot[Player]
            then:

                if (
                    set RoundTeam2Snapshot[Player] =
                        IsTeam2
                ) {}


    IsRoundTeam1Member(
        Player:player
    ):logic =

        if:
            IsMember :=
                RoundTeam1Snapshot[Player]
        then:
            return IsMember

        false


    IsRoundTeam2Member(
        Player:player
    ):logic =

        if:
            IsMember :=
                RoundTeam2Snapshot[Player]
        then:
            return IsMember

        false


    RefreshCurrentDisplayedRoleState():void =

        var PropCount:int = 0

        for (Player : GetPlayspace().GetPlayers()):

            if:
                WidgetState :=
                    PlayerWidgets[Player]
            then:

                if:
                    IsTeam2 :=
                        CurrentTeam2Snapshot[Player]
                then:

                    if (IsTeam2 = true):

                        set PropCount += 1

                        if:
                            PreviousProp :=
                                CurrentDisplayedPropHUD[Player]
                        then:

                            if (PreviousProp = false):

                                ShowPropRoleImage(
                                    WidgetState
                                )

                                if (
                                    set CurrentDisplayedPropHUD[Player] =
                                        true
                                ) {}

                                if (
                                    set CurrentDisplayedHunterHUD[Player] =
                                        false
                                ) {}

                        else:

                            ShowPropRoleImage(
                                WidgetState
                            )

                            if (
                                set CurrentDisplayedPropHUD[Player] =
                                    true
                            ) {}

                            if (
                                set CurrentDisplayedHunterHUD[Player] =
                                    false
                            ) {}


                    else:

                        if:
                            IsTeam1 :=
                                CurrentTeam1Snapshot[Player]
                        then:

                            if (IsTeam1 = true):

                                if:
                                    PreviousProp :=
                                        CurrentDisplayedPropHUD[Player]
                                then:

                                    if (PreviousProp = true):

                                        ShowHunterRoleImage(
                                            WidgetState
                                        )

                                        if (
                                            set CurrentDisplayedPropHUD[Player] =
                                                false
                                        ) {}

                                        if (
                                            set CurrentDisplayedHunterHUD[Player] =
                                                true
                                        ) {}

                                else:

                                    if (
                                        WidgetState.RoleHUDInitialized = false
                                    ):

                                        ShowHunterRoleImage(
                                            WidgetState
                                        )

                                        if (
                                            set CurrentDisplayedPropHUD[Player] =
                                                false
                                        ) {}

                                        if (
                                            set CurrentDisplayedHunterHUD[Player] =
                                                true
                                        ) {}


                            else:

                                if:
                                    PreviousProp :=
                                        CurrentDisplayedPropHUD[Player]
                                then:

                                    if (PreviousProp = true):
                                        set PropCount += 1

                                if (
                                    WidgetState.RoleHUDInitialized = false
                                ):

                                    ShowHunterRoleImage(
                                        WidgetState
                                    )

                                    if (
                                        set CurrentDisplayedPropHUD[Player] =
                                            false
                                    ) {}

                                    if (
                                        set CurrentDisplayedHunterHUD[Player] =
                                            true
                                    ) {}

                        else:

                            if:
                                PreviousProp :=
                                    CurrentDisplayedPropHUD[Player]
                            then:

                                if (PreviousProp = true):
                                    set PropCount += 1

                            if (
                                WidgetState.RoleHUDInitialized = false
                            ):

                                ShowHunterRoleImage(
                                    WidgetState
                                )

                                if (
                                    set CurrentDisplayedPropHUD[Player] =
                                        false
                                ) {}

                                if (
                                    set CurrentDisplayedHunterHUD[Player] =
                                        true
                                ) {}

                set WidgetState.RoleHUDInitialized =
                    true

        set CurrentDisplayedPropHUDCount =
            PropCount


    RefreshDisplayedRoleStateForTeleport():void =
        RebuildCurrentTeamState()
        RefreshCurrentDisplayedRoleState()


    IsPlayerDisplayedAsPropForTeleport(
        Player:player
    ):logic =

        if:
            IsDisplayedProp :=
                CurrentDisplayedPropHUD[Player]
        then:
            return IsDisplayedProp

        false


    CountDisplayedPropHUD():int =

        var PropsCount:int =
            CurrentTeam2Count

        set PropsCount +=
            SimulatedExtraPlayers

        if (PropsCount < 0):
            set PropsCount = 0

        set CurrentDisplayedPropHUDCount =
            PropsCount

        set CurrentGlobalPropsRemaining =
            PropsCount

        PropsCount


    MainGameplayTickLoop()<suspends>:void =

        loop:

            Sleep(1.0)

            if (RoundTimerStartedThisRound = true):

                RebuildCurrentTeamState()
                RefreshCurrentDisplayedRoleState()

                PropsCount :=
                    CountDisplayedPropHUD()

                UpdateAllPropsHUDOnlyWithCount(
                    PropsCount
                )

                for (Player : GetPlayspace().GetPlayers()):

                    if:
                        IsDisplayedProp :=
                            CurrentDisplayedPropHUD[Player]
                    then:

                        if (IsDisplayedProp = true):

                            AddHideTimeSecond(Player)
                            UpdatePlayerHideTimeHUD(Player)

                    UpdatePlayerRunningHUD(
                        Player,
                        PropsCount
                    )

            else:

                UpdateWaitingState()


    UpdatePlayerRunningHUD(
        Player:player,
        PropsCount:int
    ):void =

        if:
            WidgetState :=
                PlayerWidgets[Player]
        then:

            if (PropsCount <> WidgetState.LastDisplayedProps):

                WidgetState.PropsText.SetText(
                    ToMessage(
                        ToString(PropsCount)
                    )
                )

                ApplyTextGlow(
                    WidgetState.PropsText,
                    NamedColors.LemonChiffon,
                    NamedColors.Gold,
                    48.0
                )

                set WidgetState.LastDisplayedProps =
                    PropsCount


            if (RoundTimerStartedThisRound = true):

                TimerText :=
                    FormatRoundTimerText(Player)

                if (TimerText <> WidgetState.LastDisplayedTimer):

                    WidgetState.TimerText.SetText(
                        ToMessage(TimerText)
                    )

                    set WidgetState.LastDisplayedTimer =
                        TimerText

            UpdatePlayerTaskHUD(Player)


    UpdatePlayerTaskHUD(
        Player:player
    ):void =

        if:
            WidgetState :=
                PlayerWidgets[Player]

            State :=
                PlayerStates[Player]
        then:

            TaskPreviewEnabled :=
                IsTaskCompletionPreviewEnabled(Player)

            if (State.Wins <> WidgetState.LastDisplayedWins):

                UpdateTaskProgressText(
                    WidgetState.WinsText,
                    State.WinsAwarded,
                    ToString(State.Wins),
                    NamedColors.LightSkyBlue,
                    NamedColors.DeepSkyBlue
                )

                set WidgetState.LastDisplayedWins =
                    State.Wins


            var ShowRoundsCompleted:logic =
                State.RoundsAwarded

            if (TaskPreviewEnabled = true):
                set ShowRoundsCompleted = true


            if (State.PlayedRounds <> WidgetState.LastDisplayedRounds):

                UpdateTaskProgressTextWithRaisedX(
                    WidgetState.RoundsText,
                    WidgetState.RoundsDoneXText,
                    ShowRoundsCompleted,
                    ToString(State.PlayedRounds),
                    NamedColors.Bisque,
                    NamedColors.Orange
                )

                set WidgetState.LastDisplayedRounds =
                    State.PlayedRounds


            HideMinutes :=
                State.HideMinutes

            HideCompleted :=
                IsHideTaskCompleted(Player)

            if (HideCompleted = true):
                set State.HideAwarded = true
            else:
                set State.HideAwarded = false


            var ShowHideCompleted:logic =
                HideCompleted

            if (TaskPreviewEnabled = true):
                set ShowHideCompleted = true


            if (HideMinutes <> WidgetState.LastDisplayedHideMinutes):

                UpdateTaskProgressTextWithRaisedX(
                    WidgetState.HideTimeText,
                    WidgetState.HideTimeDoneXText,
                    ShowHideCompleted,
                    ToString(HideMinutes),
                    NamedColors.Honeydew,
                    NamedColors.LimeGreen
                )

                set WidgetState.LastDisplayedHideMinutes =
                    HideMinutes

                set WidgetState.LastDisplayedHideCompleted =
                    ShowHideCompleted

            else:

                if (ShowHideCompleted <> WidgetState.LastDisplayedHideCompleted):

                    UpdateTaskProgressTextWithRaisedX(
                        WidgetState.HideTimeText,
                        WidgetState.HideTimeDoneXText,
                        ShowHideCompleted,
                        ToString(HideMinutes),
                        NamedColors.Honeydew,
                        NamedColors.LimeGreen
                    )

                    set WidgetState.LastDisplayedHideCompleted =
                        ShowHideCompleted


    UpdateAllHideTimeHUD():void =

        for (Player : GetPlayspace().GetPlayers()):

            UpdatePlayerHideTimeHUD(Player)


    UpdatePlayerHideTimeHUD(
        Player:player
    ):void =

        if:
            WidgetState :=
                PlayerWidgets[Player]

            State :=
                PlayerStates[Player]
        then:

            TaskPreviewEnabled :=
                IsTaskCompletionPreviewEnabled(Player)

            HideMinutes :=
                State.HideMinutes

            HideCompleted :=
                IsHideTaskCompleted(Player)

            if (HideCompleted = true):
                set State.HideAwarded = true
            else:
                set State.HideAwarded = false

            var ShowHideCompleted:logic =
                HideCompleted

            if (TaskPreviewEnabled = true):
                set ShowHideCompleted = true

            if (HideMinutes <> WidgetState.LastDisplayedHideMinutes):

                UpdateTaskProgressTextWithRaisedX(
                    WidgetState.HideTimeText,
                    WidgetState.HideTimeDoneXText,
                    ShowHideCompleted,
                    ToString(HideMinutes),
                    NamedColors.Honeydew,
                    NamedColors.LimeGreen
                )

                set WidgetState.LastDisplayedHideMinutes =
                    HideMinutes

                set WidgetState.LastDisplayedHideCompleted =
                    ShowHideCompleted

            else:

                if (ShowHideCompleted <> WidgetState.LastDisplayedHideCompleted):

                    UpdateTaskProgressTextWithRaisedX(
                        WidgetState.HideTimeText,
                        WidgetState.HideTimeDoneXText,
                        ShowHideCompleted,
                        ToString(HideMinutes),
                        NamedColors.Honeydew,
                        NamedColors.LimeGreen
                    )

                    set WidgetState.LastDisplayedHideCompleted =
                        ShowHideCompleted


    RoundTimerStartMonitorLoop(
        LoopToken:int
    )<suspends>:void =

        loop:

            if (LoopToken <> RoundLoopToken):
                return

            if (RoundTimerStartedThisRound = true):
                return

            UpdateRoundTimerHUDState()

            if (RoundTimerStartedThisRound = true):

                UpdateWaitingState()
                RebuildCurrentTeamState()
                RefreshCurrentDisplayedRoleState()
                CaptureRoundPropHistory()
                RebuildRoundTeamSnapshot()
                UpdateAllHUD()

                return

            Sleep(0.25)


    UpdateRoundTimerHUDState():void =

        if (RoundTimerStartedThisRound = true):
            return

        TimerStarted :=
            CheckRoundTimerStartedNow()

        if (TimerStarted = true):

            set RoundTimerStartedThisRound = true
            set IsStartupPhaseActive = false
            set IsWaitingForPlayers = false


    CheckRoundTimerStartedNow():logic =

        MaxDurationFloat :=
            RoundTimerDevice.GetMaxDuration()

        if:
            MaxDuration :=
                Floor[MaxDurationFloat]
        then:

            if (MaxDuration <= 0):
                return false

            if (
                RoundTimerDevice.IsStatePerAgent[]
            ):

                for (Player : GetPlayspace().GetPlayers()):

                    RemainingFloatPerAgent :=
                        RoundTimerDevice.GetActiveDuration(Player)

                    if:
                        RemainingPerAgent :=
                            Floor[RemainingFloatPerAgent]
                    then:

                        if (RemainingPerAgent < MaxDuration):
                            return true

                return false


            RemainingFloatGlobal :=
                RoundTimerDevice.GetActiveDuration()

            if:
                RemainingGlobal :=
                    Floor[RemainingFloatGlobal]
            then:

                if (RemainingGlobal < MaxDuration):
                    return true

            false

        else:

            false


    CaptureRoundPropHistory():void =

        set WasPropThisRound =
            map{}
        set RoundStartHunters =
            map{}
        set RoundStartProps =
            map{}
        set EliminatedAsPropThisRound =
            map{}

        for (Player : GetPlayspace().GetPlayers()):

            var IsRoundHunter:logic = false
            var IsRoundProp:logic = false

            if:
                IsTeam1 :=
                    CurrentTeam1Snapshot[Player]
            then:

                set IsRoundHunter =
                    IsTeam1


            if:
                IsTeam2 :=
                    CurrentTeam2Snapshot[Player]
            then:

                set IsRoundProp =
                    IsTeam2

            if (
                set RoundStartHunters[Player] =
                    IsRoundHunter
            ) {}

            if (
                set RoundStartProps[Player] =
                    IsRoundProp
            ) {}

            if (
                set EliminatedAsPropThisRound[Player] =
                    false
            ) {}

            if:
                IsTeam2 :=
                    CurrentTeam2Snapshot[Player]
            then:

                if (
                    set WasPropThisRound[Player] =
                        IsTeam2
                ) {}

            else:

                if (
                    set WasPropThisRound[Player] =
                        false
                ) {}


    AwardTeam1RoundWin():void =

        if (WinRecordedThisRound = true):
            return

        set WinRecordedThisRound = true

        RebuildCurrentTeamState()
        RefreshCurrentDisplayedRoleState()
        RebuildRoundTeamSnapshot()

        EligibleCountBeforeAward :=
            CountEligibleHuntersForTeam1Win()

        if (EligibleCountBeforeAward <= 0):
            CaptureEligibleHuntersForTeam1WinIgnoringActive()

        for (Player : GetPlayspace().GetPlayers()):

            if:
                IsEligibleHunter :=
                    EligibleHuntersForTeam1Win[Player]
            then:

                if (IsEligibleHunter = true):

                    if (State := PlayerStates[Player]):

                        set State.Wins += 1

                        SetSavedWins(
                            Player,
                            State.Wins
                        )

                        CheckAwards(
                            Player,
                            State
                        )

        UpdateAllHUD()


    AwardTeam2RoundWin():void =

        if (WinRecordedThisRound = true):
            return

        set WinRecordedThisRound = true

        RebuildCurrentTeamState()
        RefreshCurrentDisplayedRoleState()
        RebuildRoundTeamSnapshot()

        for (Player : GetPlayspace().GetPlayers()):

            if:
                IsProp :=
                    CurrentTeam2Snapshot[Player]
            then:

                if (IsProp = true):

                    if (State := PlayerStates[Player]):

                        set State.Wins += 1

                        SetSavedWins(
                            Player,
                            State.Wins
                        )

                        CheckAwards(
                            Player,
                            State
                        )

        UpdateAllHUD()


    AwardPendingLastRoundWinToPlayer(
        Player:player,
        State:player_session_state
    ):void =

        if (PendingLastRoundWinnerTeam = 1):

            if:
                IsRoundWinner :=
                    PendingLastRoundHunters[Player]
            then:

                if (IsRoundWinner = true):

                    set State.Wins += 1

                    SetSavedWins(
                        Player,
                        State.Wins
                    )

                    CheckAwards(
                        Player,
                        State
                    )

            return


        if (PendingLastRoundWinnerTeam = 2):

            if:
                IsRoundWinner :=
                    PendingLastRoundProps[Player]
            then:

                if (IsRoundWinner = true):

                    set State.Wins += 1

                    SetSavedWins(
                        Player,
                        State.Wins
                    )

                    CheckAwards(
                        Player,
                        State
                    )


    ClearPendingLastRoundOutcome():void =
        set PendingLastRoundWinnerTeam = 0
        set PendingLastRoundHunters =
            map{}
        set PendingLastRoundProps =
            map{}


    CheckAwards(
        Player:player,
        State:player_session_state
    ):void =

        HideCompleted :=
            IsHideTaskCompleted(Player)

        if (HideCompleted = true):

            if (State.HideAwarded = false):

                HideForTenMinutesAccolade.Award(
                    Player
                )

            set State.HideAwarded = true

        else:

            set State.HideAwarded = false


        if (State.PlayedRounds >= 5):

            if (State.RoundsAwarded = false):

                PlayFiveRoundsAccolade.Award(
                    Player
                )

                set State.RoundsAwarded = true


        if (State.Wins >= WinsTaskTarget):

            if (State.WinsAwarded = false):

                set State.WinsAwarded = true


    UpdateAllHUD():void =

        RebuildCurrentTeamState()
        RefreshCurrentDisplayedRoleState()

        PropsCount :=
            CountDisplayedPropHUD()

        UpdateAllPropsHUDOnlyWithCount(
            PropsCount
        )

        for (Player : GetPlayspace().GetPlayers()):

            SavePlayerGoldSnapshot(Player)
            UpdatePlayerHUDWithPropsCount(
                Player,
                PropsCount
            )


    UpdateAllPropsHUDOnly():void =

        PropsCount :=
            CountDisplayedPropHUD()

        UpdateAllPropsHUDOnlyWithCount(
            PropsCount
        )


    UpdateAllPropsHUDOnlyWithCount(
        PropsCount:int
    ):void =

        var StablePropsCount:int =
            PropsCount

        if (StablePropsCount < 0):
            set StablePropsCount = 0

        set CurrentGlobalPropsRemaining =
            StablePropsCount

        for (Player : GetPlayspace().GetPlayers()):

            if:
                WidgetState :=
                    PlayerWidgets[Player]
            then:

                if (StablePropsCount <> WidgetState.LastDisplayedProps):

                    WidgetState.PropsText.SetText(
                        ToMessage(
                            ToString(StablePropsCount)
                        )
                    )

                    ApplyTextGlow(
                        WidgetState.PropsText,
                        NamedColors.LemonChiffon,
                        NamedColors.Gold,
                        48.0
                    )

                    set WidgetState.LastDisplayedProps =
                        StablePropsCount


    UpdatePlayerHUD(
        Player:player
    ):void =

        PropsCount :=
            CountDisplayedPropHUD()

        UpdatePlayerHUDWithPropsCount(
            Player,
            PropsCount
        )


    UpdatePlayerHUDWithPropsCount(
        Player:player,
        PropsCount:int
    ):void =

        if:
            WidgetState :=
                PlayerWidgets[Player]

            State :=
                PlayerStates[Player]
        then:

            UpdatePlayerGoldHUD(Player)


            if (IsWaitingForPlayers = true):

                if (WidgetState.LastDisplayedWaiting = false):

                    WidgetState.StartupText.SetVisibility(
                        widget_visibility.Visible
                    )

                    WidgetState.TimerText.SetVisibility(
                        widget_visibility.Collapsed
                    )

                    WidgetState.StartupText.SetText(
                        ToMessage("WAITING")
                    )

                    ApplyTextGlow(
                        WidgetState.StartupText,
                        NamedColors.White,
                        NamedColors.LightSkyBlue,
                        53.0
                    )

                    WidgetState.StartupText.SetShadowOpacity(
                        0.45
                    )

                    set WidgetState.LastDisplayedWaiting =
                        true

                    set WidgetState.LastDisplayedStartup =
                        false

                else:

                    if (WidgetState.LastDisplayedStartup = true):

                        WidgetState.StartupText.SetVisibility(
                            widget_visibility.Visible
                        )

                        WidgetState.TimerText.SetVisibility(
                            widget_visibility.Collapsed
                        )

                        WidgetState.StartupText.SetText(
                            ToMessage("WAITING")
                        )

                        ApplyTextGlow(
                            WidgetState.StartupText,
                            NamedColors.White,
                            NamedColors.LightSkyBlue,
                            53.0
                        )

                        WidgetState.StartupText.SetShadowOpacity(
                            0.45
                        )

                        set WidgetState.LastDisplayedStartup =
                            false


            else if (RoundTimerStartedThisRound = false):

                if (WidgetState.LastDisplayedStartup = false):

                    WidgetState.StartupText.SetVisibility(
                        widget_visibility.Visible
                    )

                    WidgetState.TimerText.SetVisibility(
                        widget_visibility.Collapsed
                    )

                    WidgetState.StartupText.SetText(
                        ToMessage("STARTING")
                    )

                    ApplyTextGlow(
                        WidgetState.StartupText,
                        NamedColors.White,
                        NamedColors.LightSkyBlue,
                        53.0
                    )

                    WidgetState.StartupText.SetShadowOpacity(
                        0.45
                    )

                    set WidgetState.LastDisplayedWaiting =
                        false

                    set WidgetState.LastDisplayedStartup =
                        true

                else:

                    if (WidgetState.LastDisplayedWaiting = true):

                        WidgetState.StartupText.SetVisibility(
                            widget_visibility.Visible
                        )

                        WidgetState.TimerText.SetVisibility(
                            widget_visibility.Collapsed
                        )

                        WidgetState.StartupText.SetText(
                            ToMessage("STARTING")
                        )

                        ApplyTextGlow(
                            WidgetState.StartupText,
                            NamedColors.White,
                            NamedColors.LightSkyBlue,
                            53.0
                        )

                        WidgetState.StartupText.SetShadowOpacity(
                            0.45
                        )

                        set WidgetState.LastDisplayedWaiting =
                            false


            else:

                WidgetState.StartupText.SetVisibility(
                    widget_visibility.Collapsed
                )

                WidgetState.TimerText.SetVisibility(
                    widget_visibility.Visible
                )

                TimerText :=
                    FormatRoundTimerText(Player)

                if (TimerText <> WidgetState.LastDisplayedTimer):

                    WidgetState.TimerText.SetText(
                        ToMessage(TimerText)
                    )

                    set WidgetState.LastDisplayedTimer =
                        TimerText

                ApplyTextGlow(
                    WidgetState.TimerText,
                    NamedColors.White,
                    NamedColors.LightSkyBlue,
                    69.0
                )

                WidgetState.TimerText.SetShadowOpacity(
                    0.45
                )

                set WidgetState.LastDisplayedWaiting =
                    false

                set WidgetState.LastDisplayedStartup =
                    false


            if (PropsCount <> WidgetState.LastDisplayedProps):

                WidgetState.PropsText.SetText(
                    ToMessage(
                        ToString(PropsCount)
                    )
                )

                set WidgetState.LastDisplayedProps =
                    PropsCount

                ApplyTextGlow(
                    WidgetState.PropsText,
                    NamedColors.LemonChiffon,
                    NamedColors.Gold,
                    48.0
                )


            TaskPreviewEnabled :=
                IsTaskCompletionPreviewEnabled(Player)


            if (State.Wins <> WidgetState.LastDisplayedWins):

                UpdateTaskProgressText(
                    WidgetState.WinsText,
                    State.WinsAwarded,
                    ToString(State.Wins),
                    NamedColors.LightSkyBlue,
                    NamedColors.DeepSkyBlue
                )

                set WidgetState.LastDisplayedWins =
                    State.Wins


            var ShowRoundsCompleted:logic =
                State.RoundsAwarded

            if (TaskPreviewEnabled = true):
                set ShowRoundsCompleted = true


            if (State.PlayedRounds <> WidgetState.LastDisplayedRounds):

                UpdateTaskProgressTextWithRaisedX(
                    WidgetState.RoundsText,
                    WidgetState.RoundsDoneXText,
                    ShowRoundsCompleted,
                    ToString(State.PlayedRounds),
                    NamedColors.Bisque,
                    NamedColors.Orange
                )

                set WidgetState.LastDisplayedRounds =
                    State.PlayedRounds


            HideMinutes :=
                State.HideMinutes

            HideCompleted :=
                IsHideTaskCompleted(Player)

            if (HideCompleted = true):
                set State.HideAwarded = true
            else:
                set State.HideAwarded = false


            var ShowHideCompleted:logic =
                HideCompleted

            if (TaskPreviewEnabled = true):
                set ShowHideCompleted = true


            if (HideMinutes <> WidgetState.LastDisplayedHideMinutes):

                UpdateTaskProgressTextWithRaisedX(
                    WidgetState.HideTimeText,
                    WidgetState.HideTimeDoneXText,
                    ShowHideCompleted,
                    ToString(HideMinutes),
                    NamedColors.Honeydew,
                    NamedColors.LimeGreen
                )

                set WidgetState.LastDisplayedHideMinutes =
                    HideMinutes

                set WidgetState.LastDisplayedHideCompleted =
                    ShowHideCompleted

            else:

                if (ShowHideCompleted <> WidgetState.LastDisplayedHideCompleted):

                    UpdateTaskProgressTextWithRaisedX(
                        WidgetState.HideTimeText,
                        WidgetState.HideTimeDoneXText,
                        ShowHideCompleted,
                        ToString(HideMinutes),
                        NamedColors.Honeydew,
                        NamedColors.LimeGreen
                    )

                    set WidgetState.LastDisplayedHideCompleted =
                        ShowHideCompleted


            UpdateTeamRoleBanner(
                Player,
                WidgetState
            )


    UpdateTaskProgressTextWithRaisedX(
        ValueWidget:text_block,
        RaisedXWidget:text_block,
        IsComplete:logic,
        CurrentValue:string,
        FillColor:color,
        GlowColor:color
    ):void =

        if (IsComplete = true):

            ValueWidget.SetVisibility(
                widget_visibility.Collapsed
            )

            RaisedXWidget.SetVisibility(
                widget_visibility.Visible
            )

            RaisedXWidget.SetText(
                ToMessage("X")
            )

            ApplyTextGlow(
                RaisedXWidget,
                NamedColors.LimeGreen,
                NamedColors.Lime,
                90.0
            )

            return


        RaisedXWidget.SetVisibility(
            widget_visibility.Collapsed
        )

        ValueWidget.SetVisibility(
            widget_visibility.Visible
        )

        ValueWidget.SetText(
            ToMessage(CurrentValue)
        )

        ApplyTextGlow(
            ValueWidget,
            FillColor,
            GlowColor,
            59.0
        )


    UpdateTaskProgressText(
        TextWidget:text_block,
        IsComplete:logic,
        CurrentValue:string,
        FillColor:color,
        GlowColor:color
    ):void =

        if (IsComplete = true):

            TextWidget.SetText(
                ToMessage("X")
            )

            ApplyTextGlow(
                TextWidget,
                NamedColors.LimeGreen,
                NamedColors.Lime,
                80.0
            )

            return


        TextWidget.SetText(
            ToMessage(CurrentValue)
        )

        ApplyTextGlow(
            TextWidget,
            FillColor,
            GlowColor,
            59.0
        )


    ShowPropRoleImage(
        WidgetState:player_widget_state
    ):void =

        WidgetState.TeamRoleHunterImage.SetVisibility(
            widget_visibility.Collapsed
        )

        WidgetState.TeamRolePropImage.SetVisibility(
            widget_visibility.Visible
        )


    ShowHunterRoleImage(
        WidgetState:player_widget_state
    ):void =

        WidgetState.TeamRolePropImage.SetVisibility(
            widget_visibility.Collapsed
        )

        WidgetState.TeamRoleHunterImage.SetVisibility(
            widget_visibility.Visible
        )


    UpdateTeamRoleBanner(
        Player:player,
        WidgetState:player_widget_state
    ):void =

        if:
            IsProp :=
                CurrentDisplayedPropHUD[Player]
        then:

            if (IsProp = true):

                if (
                    WidgetState.RoleHUDInitialized = false
                ):

                    ShowPropRoleImage(
                        WidgetState
                    )

                return


        if (
            WidgetState.RoleHUDInitialized = false
        ):

            ShowHunterRoleImage(
                WidgetState
            )


    OnRoundBegin(
        RoundData:tuple()
    ):void =

        set RoundWinEvaluationToken += 1
        set IsStartupPhaseActive = true
        set IsWaitingForPlayers = true
        set WinRecordedThisRound = false
        set RoundTimerStartedThisRound = false
        set TeamsLockedThisRound = false
        set RoundAssignmentPlayerCount = -1
        set WasPropThisRound =
            map{}
        set RoundStartHunters =
            map{}
        set RoundStartProps =
            map{}
        set EliminatedAsPropThisRound =
            map{}
        set EligibleHuntersForTeam1Win =
            map{}
        set RoundTeamAssignment =
            map{}

        for (Player : GetPlayspace().GetPlayers()):

            InitializeSessionTaskValues(Player)
            InitializeTaskPersistTrackers(Player)

            LoadPersistentTaskProgress(Player)
            SyncPlayerTaskStateStrict(Player)

            if (State := PlayerStates[Player]):

                AwardPendingLastRoundWinToPlayer(
                    Player,
                    State
                )

                set State.PlayedRounds += 1

                SetSavedRounds(
                    Player,
                    State.PlayedRounds
                )

                CheckAwards(
                    Player,
                    State
                )

                MarkGoldRestorePending(Player)

        ClearPendingLastRoundOutcome()


        RebuildCurrentTeamState()
        UpdateWaitingState()

        PlayerCount :=
            GetPlayspace().GetPlayers().Length

        if (PlayerCount >= 2):
            EnsurePreRoundTeamAssignment()

        RebuildCurrentTeamState()
        RefreshCurrentDisplayedRoleState()
        RebuildRoundTeamSnapshot()

        # Rundentimer-Erkennung und Teamkontrolle auch in Runde 2, 3, ... wieder starten
        StartRoundLoops()

        spawn {
            RunRoundStartTaskIntegrityPass()
        }

        UpdateAllHUD()


    FormatRoundTimerText(
        Player:player
    ):string =

        MaxDurationFloat :=
            RoundTimerDevice.GetMaxDuration()

        if:
            MaxDuration :=
                Floor[MaxDurationFloat]
        then:

            if (MaxDuration <= 0):
                return "0"

            if (
                RoundTimerDevice.IsStatePerAgent[]
            ):

                RemainingFloatPerAgent :=
                    RoundTimerDevice.GetActiveDuration(Player)

                if:
                    RemainingPerAgent :=
                        Floor[RemainingFloatPerAgent]
                then:

                    return FormatVisibleTimerText(
                        RemainingPerAgent,
                        MaxDuration
                    )

                return "0"


            RemainingFloatGlobal :=
                RoundTimerDevice.GetActiveDuration()

            if:
                RemainingGlobal :=
                    Floor[RemainingFloatGlobal]
            then:

                return FormatVisibleTimerText(
                    RemainingGlobal,
                    MaxDuration
                )

            return "0"

        "0"


    FormatVisibleTimerText(
        RemainingSeconds:int,
        MaxDuration:int
    ):string =

        if (RemainingSeconds <= 0):
            return "0"

        if (MaxDuration <= 0):
            return "0"

        FormatDurationMMSS(
            RemainingSeconds
        )


    FormatDurationMMSS(
        TotalSeconds:int
    ):string =

        var Minutes:int = 0
        var Seconds:int =
            TotalSeconds

        loop:

            if (Seconds < 60):
                break

            set Minutes += 1
            set Seconds -= 60

        "{ToString(Minutes)}:{TwoDigits(Seconds)}"


    FormatDurationMinutesOnly(
        TotalSeconds:int
    ):string =

        var Minutes:int = 0
        var RemainingSeconds:int =
            TotalSeconds

        loop:

            if (RemainingSeconds < 60):
                break

            set Minutes += 1
            set RemainingSeconds -= 60

        ToString(Minutes)


    TwoDigits(
        Value:int
    ):string =

        if (Value < 10):
            return "0{ToString(Value)}"

        ToString(Value)


    HideConflictingHUD(
        Playspace:fort_playspace
    ):void =

        HUDController :=
            Playspace.GetHUDController()

        HUDController.HideElements(
            GetConflictingHUDElements()
        )


    HideConflictingHUDForPlayer(
        Player:player
    ):void =

        GetPlayspace().GetHUDController().HideElementsForPlayer(
            Player,
            GetConflictingHUDElements()
        )


    ShowStandardResourceHUD(
        Playspace:fort_playspace
    ):void =

        Playspace.GetHUDController().ShowElements(
            GetStandardResourceHUDElements()
        )


    ShowStandardResourceHUDForPlayer(
        Player:player
    ):void =

        GetPlayspace().GetHUDController().ShowElementsForPlayer(
            Player,
            GetStandardResourceHUDElements()
        )


    GetConflictingHUDElements():[]hud_element_identifier =

        array:
            creative_hud_identifier_round_timer{}
            creative_hud_identifier_round_info{}
            creative_hud_identifier_hud_info{}


    GetStandardResourceHUDElements():[]hud_element_identifier =

        array:
            creative_hud_identifier_crafting_resources{}


    CreateOrReplacePlayerWidget(
        Player:player
    ):void =

        if (PlayerUI := GetPlayerUI[Player]):

            if (
                ExistingWidgetState :=
                    PlayerWidgets[Player]
            ):

                PlayerUI.RemoveWidget(
                    ExistingWidgetState.Root
                )


            WidgetState :=
                CreatePlayerWidget()


            PlayerUI.AddWidget(
                WidgetState.Root,
                player_ui_slot{
                    InputMode := ui_input_mode.None
                    ZOrder := 2147483647
                }
            )


            if (
                set PlayerWidgets[Player] =
                    WidgetState
            ) {}


    HUDScale():float = 0.92


    ScaleHUD(Value:float):float =
        Value * HUDScale()


    CreatePlayerWidget():player_widget_state =

        TimerBackground :=
            texture_block{
                DefaultImage :=
                    ROUNDTIME

                DefaultDesiredSize :=
                    vector2{
                        X := ScaleHUD(392.0)
                        Y := ScaleHUD(196.0)
                    }
            }


        StartupTextBlock :=
            text_block{
                DefaultText :=
                    ToMessage("WAITING")

                DefaultTextColor :=
                    NamedColors.White

                DefaultTextSize :=
                    ScaleHUD(53.0)

                DefaultJustification :=
                    text_justification.Center

                DefaultShadowOffset :=
                    option{
                        vector2{
                            X := 1.0
                            Y := 1.0
                        }
                    }

                DefaultShadowColor :=
                    NamedColors.DodgerBlue

                DefaultShadowOpacity :=
                    0.35
            }


        TimerTextBlock :=
            text_block{
                DefaultText :=
                    ToMessage("0")

                DefaultTextColor :=
                    NamedColors.White

                DefaultTextSize :=
                    ScaleHUD(69.0)

                DefaultJustification :=
                    text_justification.Center

                DefaultShadowOffset :=
                    option{
                        vector2{
                            X := 1.0
                            Y := 1.0
                        }
                    }

                DefaultShadowColor :=
                    NamedColors.DodgerBlue

                DefaultShadowOpacity :=
                    0.35
            }


        PropsBackground :=
            texture_block{
                DefaultImage :=
                    PROPSREMAINING

                DefaultDesiredSize :=
                    vector2{
                        X := ScaleHUD(400.0)
                        Y := ScaleHUD(250.0)
                    }
            }


        PropsTextBlock :=
            text_block{
                DefaultText :=
                    ToMessage("0")

                DefaultTextColor :=
                    NamedColors.White

                DefaultTextSize :=
                    ScaleHUD(47.0)

                DefaultJustification :=
                    text_justification.Center

                DefaultShadowOffset :=
                    option{
                        vector2{
                            X := 1.0
                            Y := 1.0
                        }
                    }

                DefaultShadowColor :=
                    NamedColors.DodgerBlue

                DefaultShadowOpacity :=
                    0.35
            }


        WinsTextBlock :=
            CreateStatTextBlock()


        RoundsTextBlock :=
            CreateStatTextBlock()


        HideTimeTextBlock :=
            CreateStatTextBlock()


        RoundsDoneXTextBlock :=
            CreateTaskDoneXTextBlock()


        HideTimeDoneXTextBlock :=
            CreateTaskDoneXTextBlock()


        RoundsDoneXTextBlock.SetVisibility(
            widget_visibility.Collapsed
        )


        HideTimeDoneXTextBlock.SetVisibility(
            widget_visibility.Collapsed
        )


        TeamRoleHunterTexture :=
            texture_block{
                DefaultImage :=
                    HUDbuttons.TEAMHUNTERSPropHunt

                DefaultDesiredSize :=
                    vector2{
                        X := ScaleHUD(645.0)
                        Y := ScaleHUD(155.0)
                    }
            }


        TeamRolePropTexture :=
            texture_block{
                DefaultImage :=
                    HUDbuttons.TEAMPROPSPropHunt

                DefaultDesiredSize :=
                    vector2{
                        X := ScaleHUD(475.0)
                        Y := ScaleHUD(142.0)
                    }
            }


        TeamRolePropTexture.SetVisibility(
            widget_visibility.Collapsed
        )


        CoinIcon :=
            texture_block{
                DefaultImage :=
                    CoinIconImage

                DefaultDesiredSize :=
                    vector2{
                        X := ScaleHUD(50.0)
                        Y := ScaleHUD(50.0)
                    }
            }


        CoinTextOutlineBlock :=
            CreateCoinTextBlock(
                NamedColors.Black,
                NamedColors.Black,
                vector2{
                    X := 0.0
                    Y := 0.0
                }
            )


        CoinTextBlock :=
            CreateCoinTextBlock(
                NamedColors.White,
                NamedColors.Black,
                vector2{
                    X := 1.0
                    Y := 1.0
                }
            )


        TasksOverlay :=
            CreateCombinedTasksOverlay(
                WinsTextBlock,
                RoundsTextBlock,
                HideTimeTextBlock,
                RoundsDoneXTextBlock,
                HideTimeDoneXTextBlock
            )


        TimerOverlay :=
            overlay{}


        TimerOverlay.AddWidget(
            overlay_slot{
                Widget :=
                    TimerBackground

                HorizontalAlignment :=
                    horizontal_alignment.Center

                VerticalAlignment :=
                    vertical_alignment.Top
            }
        )


        TimerOverlay.AddWidget(
            overlay_slot{
                Widget :=
                    StartupTextBlock

                HorizontalAlignment :=
                    horizontal_alignment.Center

                VerticalAlignment :=
                    vertical_alignment.Top

                Padding :=
                    margin{
                        Left := ScaleHUD(10.0)
                        Top := ScaleHUD(102.0)
                        Right := 0.0
                        Bottom := 0.0
                    }
            }
        )


        TimerOverlay.AddWidget(
            overlay_slot{
                Widget :=
                    TimerTextBlock

                HorizontalAlignment :=
                    horizontal_alignment.Center

                VerticalAlignment :=
                    vertical_alignment.Top

                Padding :=
                    margin{
                        Left := ScaleHUD(10.0)
                        Top := ScaleHUD(94.0)
                        Right := 0.0
                        Bottom := 0.0
                    }
            }
        )


        PropsOverlay :=
            overlay{}


        PropsOverlay.AddWidget(
            overlay_slot{
                Widget :=
                    PropsBackground

                HorizontalAlignment :=
                    horizontal_alignment.Center

                VerticalAlignment :=
                    vertical_alignment.Top
            }
        )


        PropsOverlay.AddWidget(
            overlay_slot{
                Widget :=
                    PropsTextBlock

                HorizontalAlignment :=
                    horizontal_alignment.Center

                VerticalAlignment :=
                    vertical_alignment.Top

                Padding :=
                    margin{
                        Left := ScaleHUD(68.0)
                        Top := ScaleHUD(156.0)
                        Right := 0.0
                        Bottom := 0.0
                    }
            }
        )


        CoinTextOverlay :=
            overlay{}


        CoinTextOverlay.AddWidget(
            overlay_slot{
                Widget :=
                    CoinTextOutlineBlock

                HorizontalAlignment :=
                    horizontal_alignment.Left

                VerticalAlignment :=
                    vertical_alignment.Center
            }
        )


        CoinTextOverlay.AddWidget(
            overlay_slot{
                Widget :=
                    CoinTextBlock

                HorizontalAlignment :=
                    horizontal_alignment.Left

                VerticalAlignment :=
                    vertical_alignment.Center

                Padding :=
                    margin{
                        Left := ScaleHUD(1.0)
                        Top := ScaleHUD(1.0)
                        Right := 0.0
                        Bottom := 0.0
                    }
            }
        )


        CoinOverlay :=
            overlay{}


        CoinOverlay.AddWidget(
            overlay_slot{
                Widget :=
                    CoinIcon

                HorizontalAlignment :=
                    horizontal_alignment.Left

                VerticalAlignment :=
                    vertical_alignment.Center
            }
        )


        CoinOverlay.AddWidget(
            overlay_slot{
                Widget :=
                    CoinTextOverlay

                HorizontalAlignment :=
                    horizontal_alignment.Left

                VerticalAlignment :=
                    vertical_alignment.Center

                Padding :=
                    margin{
                        Left := ScaleHUD(62.0)
                        Top := 0.0
                        Right := 0.0
                        Bottom := 0.0
                    }
            }
        )


        RootWidget :=
            canvas{}


        RootWidget.AddWidget(
            canvas_slot{
                Widget :=
                    TimerOverlay

                Anchors :=
                    anchors{
                        Minimum :=
                            vector2{
                                X := 0.5
                                Y := 0.0
                            }

                        Maximum :=
                            vector2{
                                X := 0.5
                                Y := 0.0
                            }
                    }

                Offsets :=
                    margin{
                        Left := 0.0
                        Top := 10.0
                        Right := 0.0
                        Bottom := 0.0
                    }

                SizeToContent :=
                    true

                Alignment :=
                    vector2{
                        X := 0.5
                        Y := 0.0
                    }

                ZOrder :=
                    2147483647
            }
        )


        RootWidget.AddWidget(
            canvas_slot{
                Widget :=
                    PropsOverlay

                Anchors :=
                    anchors{
                        Minimum :=
                            vector2{
                                X := 1.0
                                Y := 0.0
                            }

                        Maximum :=
                            vector2{
                                X := 1.0
                                Y := 0.0
                            }
                    }

                Offsets :=
                    margin{
                        Left := -60.0
                        Top := -1.0
                        Right := 0.0
                        Bottom := 0.0
                    }

                SizeToContent :=
                    true

                Alignment :=
                    vector2{
                        X := 1.0
                        Y := 0.0
                    }

                ZOrder :=
                    2147483647
            }
        )


        RootWidget.AddWidget(
            canvas_slot{
                Widget :=
                    TasksOverlay

                Anchors :=
                    anchors{
                        Minimum :=
                            vector2{
                                X := 0.0
                                Y := 0.0
                            }

                        Maximum :=
                            vector2{
                                X := 0.0
                                Y := 0.0
                            }
                    }

                Offsets :=
                    margin{
                        Left := -33.4
                        Top := 20.0
                        Right := 0.0
                        Bottom := 0.0
                    }

                SizeToContent :=
                    true

                Alignment :=
                    vector2{
                        X := 0.0
                        Y := 0.0
                    }

                ZOrder :=
                    2147483647
            }
        )


        RootWidget.AddWidget(
            canvas_slot{
                Widget :=
                    TeamRoleHunterTexture

                Anchors :=
                    anchors{
                        Minimum :=
                            vector2{
                                X := 1.0
                                Y := 0.5
                            }

                        Maximum :=
                            vector2{
                                X := 1.0
                                Y := 0.5
                            }
                    }

                Offsets :=
                    margin{
                        Left := 80.0
                        Top := 134.0
                        Right := 0.0
                        Bottom := 0.0
                    }

                SizeToContent :=
                    true

                Alignment :=
                    vector2{
                        X := 1.0
                        Y := 0.5
                    }

                ZOrder :=
                    2147483647
            }
        )


        RootWidget.AddWidget(
            canvas_slot{
                Widget :=
                    TeamRolePropTexture

                Anchors :=
                    anchors{
                        Minimum :=
                            vector2{
                                X := 1.0
                                Y := 0.5
                            }

                        Maximum :=
                            vector2{
                                X := 1.0
                                Y := 0.5
                            }
                    }

                Offsets :=
                    margin{
                        Left := -30.0
                        Top := 134.0
                        Right := 0.0
                        Bottom := 0.0
                    }

                SizeToContent :=
                    true

                Alignment :=
                    vector2{
                        X := 1.0
                        Y := 0.5
                    }

                ZOrder :=
                    2147483647
            }
        )


        RootWidget.AddWidget(
            canvas_slot{
                Widget :=
                    CoinOverlay

                Anchors :=
                    anchors{
                        Minimum :=
                            vector2{
                                X := 0.0
                                Y := 0.0
                            }

                        Maximum :=
                            vector2{
                                X := 0.0
                                Y := 0.0
                            }
                    }

                Offsets :=
                    margin{
                        Left := 42.0
                        Top := 850.0
                        Right := 0.0
                        Bottom := 0.0
                    }

                SizeToContent :=
                    true

                Alignment :=
                    vector2{
                        X := 0.0
                        Y := 0.0
                    }

                ZOrder :=
                    2147483647
            }
        )


        player_widget_state{
            Root :=
                RootWidget

            TimerText :=
                TimerTextBlock

            StartupText :=
                StartupTextBlock

            PropsText :=
                PropsTextBlock

            WinsText :=
                WinsTextBlock

            RoundsText :=
                RoundsTextBlock

            HideTimeText :=
                HideTimeTextBlock

            RoundsDoneXText :=
                RoundsDoneXTextBlock

            HideTimeDoneXText :=
                HideTimeDoneXTextBlock

            TeamRoleHunterImage :=
                TeamRoleHunterTexture

            TeamRolePropImage :=
                TeamRolePropTexture

            CoinText :=
                CoinTextBlock

            CoinTextOutline :=
                CoinTextOutlineBlock
        }


    CreateStatTextBlock():text_block =

        text_block{
            DefaultText :=
                ToMessage("0")

            DefaultTextColor :=
                NamedColors.White

            DefaultTextSize :=
                ScaleHUD(42.0)

            DefaultJustification :=
                text_justification.Center

            DefaultShadowOffset :=
                option{
                    vector2{
                        X := 1.0
                        Y := 1.0
                    }
                }

            DefaultShadowColor :=
                NamedColors.DodgerBlue

            DefaultShadowOpacity :=
                0.35
        }


    CreateTaskDoneXTextBlock():text_block =

        text_block{
            DefaultText :=
                ToMessage("X")

            DefaultTextColor :=
                NamedColors.LimeGreen

            DefaultTextSize :=
                ScaleHUD(90.0)

            DefaultJustification :=
                text_justification.Center

            DefaultShadowOffset :=
                option{
                    vector2{
                        X := 1.0
                        Y := 1.0
                    }
                }

            DefaultShadowColor :=
                NamedColors.Lime

            DefaultShadowOpacity :=
                0.35
        }


    CreateCoinTextBlock(
        TextColor:color,
        ShadowColor:color,
        ShadowOffset:vector2
    ):text_block =

        text_block{
            DefaultText :=
                ToMessage("0")

            DefaultTextColor :=
                TextColor

            DefaultTextSize :=
                ScaleHUD(49.0)

            DefaultJustification :=
                text_justification.Left

            DefaultShadowOffset :=
                option{
                    ShadowOffset
                }

            DefaultShadowColor :=
                ShadowColor

            DefaultShadowOpacity :=
                1.0
        }


    ApplyTextGlow(
        TextWidget:text_block,
        TextColor:color,
        GlowColor:color,
        TextSize:float
    ):void =

        TextWidget.SetTextColor(TextColor)
        TextWidget.SetTextSize(TextSize)
        TextWidget.SetShadowColor(GlowColor)

        TextWidget.SetShadowOffset(
            option{
                vector2{
                    X := 1.0
                    Y := 1.0
                }
            }
        )

        TextWidget.SetShadowOpacity(0.35)


    CreateCombinedTasksOverlay(
        WinsText:text_block,
        RoundsText:text_block,
        HideTimeText:text_block,
        RoundsDoneXText:text_block,
        HideTimeDoneXText:text_block
    ):overlay =

        TasksBackground :=
            texture_block{
                DefaultImage :=
                    HUDbuttons.AllThreeTasks

                DefaultDesiredSize :=
                    vector2{
                        X := ScaleHUD(550.0)
                        Y := ScaleHUD(250.0)
                    }
            }


        TasksOverlay :=
            overlay{}


        TasksOverlay.AddWidget(
            overlay_slot{
                Widget :=
                    TasksBackground

                HorizontalAlignment :=
                    horizontal_alignment.Left

                VerticalAlignment :=
                    vertical_alignment.Top
            }
        )


        TasksOverlay.AddWidget(
            overlay_slot{
                Widget :=
                    RoundsText

                HorizontalAlignment :=
                    horizontal_alignment.Center

                VerticalAlignment :=
                    vertical_alignment.Top

                Padding :=
                    margin{
                        Left := ScaleHUD(165.0)
                        Top := ScaleHUD(29.5)
                        Right := 00.0
                        Bottom := 0.0
                    }
            }
        )


        TasksOverlay.AddWidget(
            overlay_slot{
                Widget :=
                    RoundsDoneXText

                HorizontalAlignment :=
                    horizontal_alignment.Center

                VerticalAlignment :=
                    vertical_alignment.Top

                Padding :=
                    margin{
                        Left := ScaleHUD(165.0)
                        Top := ScaleHUD(11.0)
                        Right := 00.0
                        Bottom := 0.0
                    }
            }
        )


        TasksOverlay.AddWidget(
            overlay_slot{
                Widget :=
                    HideTimeText

                HorizontalAlignment :=
                    horizontal_alignment.Center

                VerticalAlignment :=
                    vertical_alignment.Top

                Padding :=
                    margin{
                        Left := ScaleHUD(165.0)
                        Top := ScaleHUD(154.7)
                        Right := 00.0
                        Bottom := 0.0
                    }
            }
        )


        TasksOverlay.AddWidget(
            overlay_slot{
                Widget :=
                    HideTimeDoneXText

                HorizontalAlignment :=
                    horizontal_alignment.Center

                VerticalAlignment :=
                    vertical_alignment.Top

                Padding :=
                    margin{
                        Left := ScaleHUD(165.0)
                        Top := ScaleHUD(136.0)
                        Right := 00.0
                        Bottom := 0.0
                    }
            }
        )


        TasksOverlay
