# =====================================================================
# REFERENZ — UNGEPRÜFT bis in UEFN kompiliert
# Datei: ftb_time.verse  (FUSE THE BRAINROT)
# Zweck: Zeitquelle abstrahieren (GDD §7.1, §7.4, §7.5, §16.2 Modul 12).
#   Modus WallClock:   GetSecondsSinceEpoch() (UTC).
#       Existenz LIKELY: API-Referenzseite "versedotorg/verse/getsecondssinceepoch"
#       taucht in Suchergebnissen auf; Rückgabetyp/Effekte UNVERIFIED.
#   Modus Session:     Fallback "Session-Kalender": 1 Tag = 1 Sitzung mit
#                      ≥ 15 aktiven Minuten; Streak entfällt ("Treue-Kalender").
#   Event-Woche:       WallClock ab Launch-Datum, sonst Fallback A (Konstante
#                      per Mikro-Update) oder Fallback B (5 h Spielzeit je Woche).
# Alle anderen Module fragen NUR diese Klasse nach Zeit.
# =====================================================================

using { /Verse.org/Simulation }                   # GetSimulationElapsedTime: VERIFIED
using { /UnrealEngine.com/Temporary/Diagnostics }

ftb_time_mode := enum{WallClock, SessionCalendar}
ftb_week_mode := enum{WallClock, ManualConstant, PlaytimeSolo}

# Launch Do. 10.12.2026 00:00 UTC (GDD §7.4 W1)
LaunchEpochSeconds:float = 1796860800.0
SecondsPerDay:float = 86400.0
SecondsPerWeek:float = 604800.0
# Plausibilitätsgrenze: alles vor 01.01.2026 gilt als "keine echte Uhr"
MinPlausibleEpoch:float = 1767225600.0
# Fallback A: bei jedem wöchentlichen Mikro-Update hochzählen (0 = aus)
CurrentEventWeekOverride:int = 0
# Fallback B: nach je 5 h Spielzeit schaltet die nächste Woche frei
PlaytimePerEventWeek:float = 18000.0
EventWeeksTotal:int = 8
SessionQualifySeconds:float = 900.0     # 15 aktive Minuten
OfflineCapSeconds:float = 28800.0       # 8 h (GDD §7.5)
OfflineIncomeShare:float = 0.1          # 10 %

ftb_time_source := class:
    var Mode:ftb_time_mode = ftb_time_mode.SessionCalendar
    var WeekMode:ftb_week_mode = ftb_week_mode.PlaytimeSolo

    # Beim Start des Spiels einmal aufrufen.
    Detect()<transacts>:void =
        E := ReadEpoch()
        if (E >= MinPlausibleEpoch):
            set Mode = ftb_time_mode.WallClock
            set WeekMode = ftb_week_mode.WallClock
        else if (CurrentEventWeekOverride > 0):
            set WeekMode = ftb_week_mode.ManualConstant
        ModeName := if (Mode = ftb_time_mode.WallClock) then "WallClock" else "Session"
        Print("FTB TIME: Epoch={E} Modus={ModeName}")

    # Einzige Stelle, an der die Wanduhr gelesen wird. Kompiliert das nicht,
    # hier `0.0` zurückgeben -> alles läuft im Fallback.
    ReadEpoch()<transacts>:float =
        GetSecondsSinceEpoch()        # UNVERIFIED Signatur (float? int? <reads>?)

    HasWallClock()<decides><transacts>:void = Mode = ftb_time_mode.WallClock

    SimNow()<transacts>:float = GetSimulationElapsedTime()

    # Kalendertag (UTC) bzw. Sitzungszähler im Fallback
    DayIndex(S:ftb_player_state)<transacts>:int =
        if (HasWallClock[], D := Floor[ReadEpoch() / SecondsPerDay]) then D else S.SessionsOK

    # Event-Woche 1..8 (0 = vor Launch). Nach W8: Rotation W2..W8 als "Rückkehr-Woche".
    EventWeek(S:ftb_player_state)<transacts>:int =
        WallWeek := if (W := Floor[(ReadEpoch() - LaunchEpochSeconds) / SecondsPerWeek]) then W + 1 else 0
        PlayWeek := if (W := Floor[S.PlaySeconds / PlaytimePerEventWeek]) then W + 1 else 1
        Raw := case(WeekMode):
            ftb_week_mode.WallClock => WallWeek
            ftb_week_mode.ManualConstant => CurrentEventWeekOverride
            ftb_week_mode.PlaytimeSolo => PlayWeek
        RotateWeek(Raw)

    # Offline-Sekunden seit letztem Speichern (nur mit Wanduhr, sonst 0)
    OfflineSeconds(S:ftb_player_state)<transacts>:float =
        if (HasWallClock[], S.LastSeenEpoch > 0.0):
            Min(OfflineCapSeconds, Max(0.0, ReadEpoch() - S.LastSeenEpoch))
        else:
            0.0

    StampLastSeen(S:ftb_player_state)<transacts>:void =
        if (HasWallClock[]):
            set S.LastSeenEpoch = ReadEpoch()

# W1..W8 direkt; danach Rotation W2..W8 (7er-Zyklus), GDD §7.4 "Nach W8".
RotateWeek(Raw:int)<transacts>:int =
    if (Raw <= 0) then 0
    else if (Raw <= EventWeeksTotal) then Raw
    else if (M := Mod[Raw - EventWeeksTotal - 1, 7]) then 2 + M
    else 2

IsReturnWeek(Raw:int)<decides><computes>:void = Raw > EventWeeksTotal

# Rückkehr-Einkommen beim Join (GDD §7.5).
# Mit Uhr: 10 % × Einkommen/s × min(Offline, 8 h).
# Ohne Uhr: 5 min Einkommen (+1 Ei, vergibt game_manager), nur wenn die
#           vorige Sitzung ≥ 10 aktive Minuten hatte.
ReturnBonusCoins(T:ftb_time_source, S:ftb_player_state)<transacts>:float =
    Inc := IncomePerSecondBase(S)
    if (T.HasWallClock[]):
        OfflineIncomeShare * Inc * T.OfflineSeconds(S)
    else if (S.LastSessionActiveSec >= 600.0):
        Inc * 300.0
    else:
        0.0
