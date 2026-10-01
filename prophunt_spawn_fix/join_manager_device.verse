using { /Fortnite.com/Devices }
using { /Fortnite.com/Teams }
using { /Verse.org/Simulation }


# Stillgelegt (Kompatibilitaet, wie timerManagement):
# Dieses Geraet hat Teams per class_and_team_selector geaendert und damit gegen den hud_controller gearbeitet
# (3. Spieler wurde beim Startup-Timer nach Team 1 geschoben -> 2 Hunter / 1 Prop, der HUD-Controller hat
# zurueckgetauscht -> Spieler wechselten mehrfach Team und Spawn-Ort). Die Teamzuteilung macht jetzt
# ausschliesslich der hud_controller, die Plattformen garantiert fla_spawn_guard_device.
# Die @editable-Felder bleiben, damit die Verknuepfungen im UEFN-Geraet nicht verloren gehen.
join_manager_device := class(creative_device):

    @editable
    Team1Selector : class_and_team_selector_device =
        class_and_team_selector_device{}

    @editable
    Team2Selector : class_and_team_selector_device =
        class_and_team_selector_device{}

    @editable
    StartupTimerDevice : timer_device =
        timer_device{}


    var StartupTimerFinished : logic = false


    OnBegin<override>()<suspends>:void =

        StartupTimerDevice.SuccessEvent.Subscribe(
            OnStartupTimerSuccess
        )


    OnStartupTimerSuccess(
        Instigator : ?agent
    ):void =

        set StartupTimerFinished = true


    IsStartupTimerFinished<public>():logic =

        StartupTimerFinished
