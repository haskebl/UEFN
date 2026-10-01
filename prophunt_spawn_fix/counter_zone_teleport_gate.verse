using { /Fortnite.com/Devices }
using { /Fortnite.com/Playspaces }
using { /Verse.org/Simulation }


# Zonen-Tor: Wenn SourceCounter erfolgreich ist, werden die Spieler in TargetVolume durch TargetTeleporter geschickt.
# Absicherung: Sobald LockTimer ablaeuft (= Props-Freigabe / Rundenstart), ist das Tor fuer den Rest der Runde
# GESPERRT. Ein Zaehler-Signal waehrend der Runde (z. B. durch eine Eliminierung) teleportiert dann niemanden.
counter_zone_teleport_gate := class(creative_device):

    @editable
    SourceCounter : player_counter_device = player_counter_device{}

    @editable
    TargetVolume : volume_device = volume_device{}

    @editable
    TargetTeleporter : teleporter_device = teleporter_device{}

    # Ab Ablauf dieses Timers ist das Tor gesperrt (empfohlen: derselbe Timer wie Team2TeleportTimer)
    @editable
    LockTimer : timer_device = timer_device{}

    # Hebt die Sperre zu jedem Rundenstart wieder auf
    @editable
    RoundSettings : round_settings_device = round_settings_device{}


    var CanTriggerTeleport : logic = true
    var LockedThisRound : logic = false


    OnBegin<override>()<suspends>:void =
        TargetTeleporter.Disable()

        SourceCounter.CountSucceedsEvent.Subscribe(
            OnCounterSucceeded
        )

        LockTimer.SuccessEvent.Subscribe(
            OnLockTimerFinished
        )

        RoundSettings.RoundBeginEvent.Subscribe(
            OnRoundBegin
        )

        GetPlayspace().PlayerAddedEvent().Subscribe(
            OnPlayerCountChanged
        )

        GetPlayspace().PlayerRemovedEvent().Subscribe(
            OnPlayerCountChanged
        )


    OnCounterSucceeded():void =
        if (LockedThisRound = true):
            Print("Zonen-Tor: Zaehler ausgeloest, aber Runde laeuft - KEIN Teleport")
            return

        if (CanTriggerTeleport = false):
            return

        AgentsInVolume :=
            TargetVolume.GetAgentsInVolume()

        var TeleportedAny : logic = false

        for (ZoneAgent : AgentsInVolume):
            if (player[ZoneAgent]):
                if (TeleportedAny = false):
                    TargetTeleporter.Enable()

                TargetTeleporter.Teleport(ZoneAgent)
                set TeleportedAny = true

        if (TeleportedAny = true):
            Print("Zonen-Tor: Spieler aus der Zone teleportiert")
            TargetTeleporter.Disable()
            set CanTriggerTeleport = false


    OnLockTimerFinished(Instigator:?agent):void =
        set LockedThisRound = true
        TargetTeleporter.Disable()


    OnRoundBegin():void =
        set LockedThisRound = false


    OnPlayerCountChanged(ChangedPlayer:player):void =
        CurrentPlayers := GetPlayspace().GetPlayers().Length

        if (CurrentPlayers <= 1):
            set CanTriggerTeleport = true
