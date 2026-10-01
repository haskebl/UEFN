
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Playspaces }
using { /Fortnite.com/Teams }
using { /Verse.org/Simulation }


# Props-Teleport (EINZIGE Fassung - ersetzt beide alten teleportONTimer-Dateien)
#  - Wenn Team2TeleportTimer ablaeuft, wird JEDER lebende Prop (Team 2) auf einen EIGENEN Teleporter (1-12) gesetzt.
#  - Das passiert genau EINMAL pro Runde. Danach ist der Teleport gesperrt bis zur naechsten Runde:
#    Eliminierungen, erneute Timer-Signale, Respawns usw. teleportieren NIEMANDEN mehr.
#  - Hunter werden hier nie teleportiert.
teleportONTimer := class(creative_device):

    @editable
    Team2TeleportTimer:timer_device = timer_device{}

    # Gibt die Sperre zu jedem Rundenstart wieder frei (PFLICHT bei mehreren Runden)
    @editable
    RoundSettings:round_settings_device = round_settings_device{}

    @editable
    HUDController:hud_controller = hud_controller{}

    @editable
    Teleporter1:teleporter_device = teleporter_device{}

    @editable
    Teleporter2:teleporter_device = teleporter_device{}

    @editable
    Teleporter3:teleporter_device = teleporter_device{}

    @editable
    Teleporter4:teleporter_device = teleporter_device{}

    @editable
    Teleporter5:teleporter_device = teleporter_device{}

    @editable
    Teleporter6:teleporter_device = teleporter_device{}

    @editable
    Teleporter7:teleporter_device = teleporter_device{}

    @editable
    Teleporter8:teleporter_device = teleporter_device{}

    @editable
    Teleporter9:teleporter_device = teleporter_device{}

    @editable
    Teleporter10:teleporter_device = teleporter_device{}

    @editable
    Teleporter11:teleporter_device = teleporter_device{}

    @editable
    Teleporter12:teleporter_device = teleporter_device{}

    # Alte Felder der zweiten Fassung - nur damit Verknuepfungen im Geraet erhalten bleiben, werden nicht benutzt
    @editable
    Spawner1:player_spawner_device = player_spawner_device{}

    @editable
    Spawner2:player_spawner_device = player_spawner_device{}

    @editable
    Spawner3:player_spawner_device = player_spawner_device{}

    @editable
    Spawner4:player_spawner_device = player_spawner_device{}

    @editable
    Spawner5:player_spawner_device = player_spawner_device{}

    @editable
    Spawner6:player_spawner_device = player_spawner_device{}

    @editable
    Spawner7:player_spawner_device = player_spawner_device{}

    @editable
    Spawner8:player_spawner_device = player_spawner_device{}

    @editable
    Spawner9:player_spawner_device = player_spawner_device{}

    @editable
    Spawner10:player_spawner_device = player_spawner_device{}

    @editable
    Spawner11:player_spawner_device = player_spawner_device{}

    @editable
    Spawner12:player_spawner_device = player_spawner_device{}

    @editable
    Spawner13:player_spawner_device = player_spawner_device{}

    @editable
    Spawner14:player_spawner_device = player_spawner_device{}

    @editable
    Spawner15:player_spawner_device = player_spawner_device{}

    @editable
    Spawner16:player_spawner_device = player_spawner_device{}


    var TeleportDoneThisRound:logic = false
    var TeleportPassInProgress:logic = false
    var TeleportedThisRound:[player]logic = map{}
    var NextTeleporter:int = 0


    OnBegin<override>()<suspends>:void =
        Team2TeleportTimer.SuccessEvent.Subscribe(OnTeam2TeleportTimerFinished)
        RoundSettings.RoundBeginEvent.Subscribe(OnRoundBegin)


    OnRoundBegin():void =
        set TeleportDoneThisRound = false
        set TeleportPassInProgress = false
        set TeleportedThisRound = map{}
        set NextTeleporter = 0


    OnTeam2TeleportTimerFinished(Instigator:?agent):void =
        if (TeleportDoneThisRound = true):
            Print("teleportONTimer: Timer erneut ausgeloest - IGNORIERT (Props wurden diese Runde schon teleportiert)")
            return

        if (TeleportPassInProgress = true):
            return

        set TeleportPassInProgress = true
        spawn { RunTeleportPasses() }


    # Ein Hauptdurchgang + kurze Nachkontrollen (fuer Props, deren Rolle gerade erst gesetzt wurde)
    RunTeleportPasses()<suspends>:void =
        set TeleportedThisRound = map{}
        set NextTeleporter = 0

        TeleportPropsPass()
        Sleep(0.15)
        TeleportPropsPass()
        Sleep(0.35)
        TeleportPropsPass()
        Sleep(0.75)
        TeleportPropsPass()

        set TeleportDoneThisRound = true
        set TeleportPassInProgress = false
        Print("teleportONTimer: Props-Teleport fuer diese Runde abgeschlossen und gesperrt")


    TeleportPropsPass():void =
        HUDController.RefreshDisplayedRoleStateForTeleport()

        for (Player : GetPlayspace().GetPlayers()):
            AlreadyDone := if (Done := TeleportedThisRound[Player]) then Done else false

            if (AlreadyDone = false):
                IsProp := IsOnTeam2(Player)
                ShownAsProp := HUDController.IsPlayerDisplayedAsPropForTeleport(Player)

                if (IsProp = true or ShownAsProp = true):
                    if (Character := Player.GetFortCharacter[], Character.IsActive[]):
                        TeleportToNextFree(Player)


    TeleportToNextFree(Player:player):void =
        List := GetTeleporters()

        if (Target := List[NextTeleporter]):
            set NextTeleporter += 1
            if (set TeleportedThisRound[Player] = true) {}
            Target.Teleport(Player)
            Print("teleportONTimer: Prop auf Teleporter {NextTeleporter} gesetzt")
        else:
            Print("teleportONTimer: WARNUNG - mehr Props als Teleporter")


    GetTeleporters():[]teleporter_device =
        array{Teleporter1, Teleporter2, Teleporter3, Teleporter4, Teleporter5, Teleporter6, Teleporter7, Teleporter8, Teleporter9, Teleporter10, Teleporter11, Teleporter12}


    IsOnTeam2(Player:player):logic =
        TeamCollection := GetPlayspace().GetTeamCollection()
        Teams := TeamCollection.GetTeams()

        if (Team2 := Teams[1], TeamCollection.IsOnTeam[Player, Team2]):
            return true

        false
