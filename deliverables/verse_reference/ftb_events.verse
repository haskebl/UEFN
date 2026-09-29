# =====================================================================
# REFERENZ — UNGEPRÜFT bis in UEFN kompiliert
# Datei: ftb_events.verse  (FUSE THE BRAINROT)
# Zweck: Vorproduzierter 8-Wochen-Kalender (GDD §7.4), Wochen-Modifikatoren,
#        Codes mit Validierung (§7.2) und Tagesbelohnung mit Streak (§7.1).
#        Alle Vergaben laufen atomar (Markierung + Belohnung + Commit in
#        EINEM Fehlerkontext, siehe ftb_save.verse).
# =====================================================================

using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# --------------------------- Kalender ---------------------------------
event_week := struct:
    Week:int
    Theme:string
    TokenName:string
    FormPrefix:string
    Creatures:[]string          # Katalog-IDs E1-01 … (brainrot_catalog.csv)
    BossVariant:string
    WeekendMod:int              # siehe WeekendMod* unten

WeekendModNone:int = 0
WeekendModDoubleKerne:int = 1
WeekendModBoss5Min:int = 2
WeekendModBossEggs150:int = 3
WeekendModResonance30:int = 4
WeekendModAllPlopp:int = 5
WeekendModHypeWide30:int = 6
WeekendModSecretX2:int = 7
WeekendModAllHints:int = 8

EventCalendar:[]event_week = array{
    event_week{Week := 1, Theme := "Frisch geschlüpft", TokenName := "Gründer", FormPrefix := "Gründer",
        Creatures := array{"E1-01", "E1-02", "E1-03", "E1-04", "E1-05"}, BossVariant := "", WeekendMod := WeekendModDoubleKerne},
    event_week{Week := 2, Theme := "Winterfest I: Frostfusion", TokenName := "Frost", FormPrefix := "Frosti",
        Creatures := array{"E2-06", "E2-07", "E2-08", "E2-09", "E2-10"}, BossVariant := "Frost-König Kabelsalat", WeekendMod := WeekendModBoss5Min},
    event_week{Week := 3, Theme := "Winterfest II: Geschenke-Sturm", TokenName := "Paket", FormPrefix := "Paket",
        Creatures := array{"E3-11", "E3-12", "E3-13", "E3-14", "E3-15"}, BossVariant := "Geschenk-Mikrowellora", WeekendMod := WeekendModBossEggs150},
    event_week{Week := 4, Theme := "Funkenregen", TokenName := "Funken", FormPrefix := "Funki",
        Creatures := array{"E4-16", "E4-17", "E4-18", "E4-19", "E4-20"}, BossVariant := "Funken-Staubsauger-Baron", WeekendMod := WeekendModResonance30},
    event_week{Week := 5, Theme := "Schleim-Invasion", TokenName := "Schleim", FormPrefix := "Schleimi",
        Creatures := array{"E5-21", "E5-22", "E5-23", "E5-24", "E5-25"}, BossVariant := "Schleim-Mikrowellora", WeekendMod := WeekendModAllPlopp},
    event_week{Week := 6, Theme := "Disko-Fieber", TokenName := "Bass", FormPrefix := "Bass",
        Creatures := array{"E6-26", "E6-27", "E6-28", "E6-29", "E6-30"}, BossVariant := "König Kabelsalat Disco-Remix", WeekendMod := WeekendModHypeWide30},
    event_week{Week := 7, Theme := "Kosmos-Woche", TokenName := "Kosmos", FormPrefix := "Kosmi",
        Creatures := array{"E7-31", "E7-32", "E7-33", "E7-34", "E7-35"}, BossVariant := "Meteor-Staubsauger-Baron", WeekendMod := WeekendModSecretX2},
    event_week{Week := 8, Theme := "Fusions-Festival", TokenName := "Festival", FormPrefix := "Festi",
        Creatures := array{"E8-36", "E8-37", "E8-38", "E8-39", "E8-40"}, BossVariant := "Boss-Parade", WeekendMod := WeekendModAllHints}}

# Event-Ei-Quoten je Kreatur in Tabellenreihenfolge (W7/W8: 5. = Geheim-Form)
EventEggOdds:[]float = array{35.0, 30.0, 20.0, 12.0, 3.0}
EventEggOddsSecretWeeks:[]float = array{35.0, 30.0, 20.0, 14.5, 0.5}
EventEggPrice:int = 100
EventEggPity:int = 20        # garantiert Kreatur 4 spätestens beim 20. Event-Ei

# Wochenende nur mit Wanduhr erkennbar: 01.01.1970 war ein Donnerstag.
IsWeekend(T:ftb_time_source, S:ftb_player_state)<decides><transacts>:void =
    T.HasWallClock[]
    Wd := Mod[T.DayIndex(S) + 3, 7]    # 0 = Montag … 5 = Sa, 6 = So
    Wd >= 5

ActiveWeekendMod(T:ftb_time_source, S:ftb_player_state)<transacts>:int =
    W := T.EventWeek(S)
    if (IsWeekend[T, S], E := EventCalendar[W - 1]) then E.WeekendMod else WeekendModNone

ResonanceChanceNow(T:ftb_time_source, S:ftb_player_state)<transacts>:float =
    if (ActiveWeekendMod(T, S) = WeekendModResonance30) then 0.3 else ResonanceChance

BossPeriodNow(T:ftb_time_source, S:ftb_player_state)<transacts>:float =
    if (ActiveWeekendMod(T, S) = WeekendModBoss5Min) then 300.0 else BossPeriodSeconds

HypeWidenNow(T:ftb_time_source, S:ftb_player_state)<transacts>:float =
    if (ActiveWeekendMod(T, S) = WeekendModHypeWide30) then 0.3 else 0.0

SecretEggMultNow(T:ftb_time_source, S:ftb_player_state)<transacts>:float =
    if (ActiveWeekendMod(T, S) = WeekendModSecretX2) then 2.0 else 1.0

# --------------------------- Belohnungen ------------------------------
ftb_reward := struct:
    IncomeSeconds:float = 0.0
    Kerne:int = 0
    Eggs:int = 0               # Eier der höchsten freigeschalteten Stufe (Gratis-Zufall)
    Tokens:int = 0             # Tokens der aktuellen Woche
    CosmeticId:int = 0         # 0 = keine
    RecipeHint:int = 0         # 1/2 = voller Geheim-Rezept-Hinweis
    TitleId:int = 0

GrantReward(S:ftb_player_state, R:ftb_reward, Week:int)<transacts>:void =
    set S.Coins += IncomePerSecondBase(S) * R.IncomeSeconds
    set S.Kerne += R.Kerne
    if (R.Tokens > 0, Old := S.Tokens[Max(0, Week - 1)], set S.Tokens[Max(0, Week - 1)] = Old + R.Tokens) {}
    # Eier/Kosmetik/Titel: Warteschlange im game_manager (Brutplätze prüfen). Hier nur Stats.
    set S.Dirty = true

# --------------------------- Codes (§7.2) -----------------------------
ftb_code := struct:
    Code:string
    Week:int
    Permanent:logic = false
    Reward:ftb_reward

Codes:[]ftb_code = array{
    ftb_code{Code := "HALLOHASKE", Week := 1, Permanent := true, Reward := ftb_reward{IncomeSeconds := 600.0, Kerne := 25}},
    ftb_code{Code := "FUSEFUN", Week := 1, Reward := ftb_reward{Eggs := 2}},
    ftb_code{Code := "FROSTFUSION", Week := 2, Reward := ftb_reward{Tokens := 50}},
    ftb_code{Code := "SCHNEEBALL", Week := 2, Reward := ftb_reward{Kerne := 20, CosmeticId := 1}},
    ftb_code{Code := "PAKETPOST", Week := 3, Reward := ftb_reward{Tokens := 50}},
    ftb_code{Code := "GESCHENK24", Week := 3, Reward := ftb_reward{IncomeSeconds := 900.0}},
    ftb_code{Code := "FUNKEN2027", Week := 4, Reward := ftb_reward{Tokens := 50}},
    ftb_code{Code := "REZEPTEINS", Week := 4, Reward := ftb_reward{RecipeHint := 1}},
    ftb_code{Code := "GLIBBGLIBB", Week := 5, Reward := ftb_reward{Tokens := 50}},
    ftb_code{Code := "SCHLEIMBOSS", Week := 5, Reward := ftb_reward{Kerne := 30}},
    ftb_code{Code := "BASSDROP", Week := 6, Reward := ftb_reward{Tokens := 50}},
    ftb_code{Code := "DISKOLAMA", Week := 6, Reward := ftb_reward{TitleId := 1}},
    ftb_code{Code := "STERNSTAUB", Week := 7, Reward := ftb_reward{Tokens := 50}},
    ftb_code{Code := "KOSMOWAL", Week := 7, Reward := ftb_reward{Eggs := 2}},
    ftb_code{Code := "FESTIVAL", Week := 8, Reward := ftb_reward{Tokens := 50, IncomeSeconds := 1800.0}},
    ftb_code{Code := "REZEPTZWEI", Week := 8, Reward := ftb_reward{RecipeHint := 2}}}

CodeValidWeeks:int = 3   # 21 Tage ab Event-Woche

code_result := enum{Ok, Unknown, Expired, AlreadyClaimed, NotYet, SaveFailed}

# Eingabe kommt von der Bildschirm-Tastatur (A–Z, 0–9) -> schon Großbuchstaben.
FindCode(Input:string)<decides><transacts>:int =
    var Found:int = -1
    for (I -> C : Codes, C.Code = Input):
        set Found = I
    Found >= 0
    Found

TryRedeemCode(T:ftb_time_source, S:ftb_player_state, Input:string)<transacts>:code_result =
    var Idx:int = -1
    if (Found := FindCode[Input]):
        set Idx = Found
    if (Idx < 0):
        return code_result.Unknown
    C := if (Cd := Codes[Idx]) then Cd else ftb_code{Code := "", Week := 99, Reward := ftb_reward{}}
    if (HasBitInt[S.CodesClaimed, Idx]):
        return code_result.AlreadyClaimed
    Week := T.EventWeek(S)
    # Rückkehr-Wochen (>8) machen alte Codes nicht wieder gültig: Rohwoche zählt.
    if (not C.Permanent?):
        if (Week < C.Week):
            return code_result.NotYet
        if (Week - C.Week >= CodeValidWeeks):
            return code_result.Expired
    Now := T.SimNow()
    # ATOMAR: Bit + Belohnung + Commit; bei Fehler rollt alles zurück.
    if:
        set S.CodesClaimed = S.CodesClaimed + Pow2(Idx)
        GrantReward(S, C.Reward, Week)
        CommitSave[S.Agent, BuildSave(S, Now)]
    then:
        code_result.Ok
    else:
        code_result.SaveFailed

# --------------------------- Tagesbelohnung (§7.1) --------------------
DailyRewards:[]ftb_reward = array{
    ftb_reward{IncomeSeconds := 300.0, Kerne := 10},
    ftb_reward{Eggs := 1},
    ftb_reward{Kerne := 20},
    ftb_reward{IncomeSeconds := 900.0},
    ftb_reward{Eggs := 2},
    ftb_reward{Kerne := 30, Tokens := 50},
    ftb_reward{CosmeticId := 100, IncomeSeconds := 1800.0, Kerne := 50}}   # Glanz-Kiste
DailyStreakBonus:[]float = array{0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.5}

CanClaimDaily(T:ftb_time_source, S:ftb_player_state)<decides><transacts>:void =
    T.DayIndex(S) > S.LastDay

TryClaimDaily(T:ftb_time_source, S:ftb_player_state)<transacts>:logic =
    Today := T.DayIndex(S)
    if (not CanClaimDaily[T, S]):
        return false
    # Streak nur mit Wanduhr; 1× pro Woche springt der Streak-Schutz ein.
    WeekNo := if (Q := Quotient[Today, 7]) then Q else 0
    var NewStreak:int = S.Streak + 1
    var NewShield:int = S.StreakShieldWeek
    if (T.HasWallClock[], Today - S.LastDay > 1, S.LastDay >= 0):
        if (Today - S.LastDay = 2, S.StreakShieldWeek <> WeekNo):
            set NewShield = WeekNo        # Schutz verbraucht, Streak bleibt
        else:
            set NewStreak = 1
    if (not T.HasWallClock[]):
        set NewStreak = 0                 # "Treue-Kalender" ohne Streak
    Day := if (M := Mod[S.DailyDay, 7]) then M else 0
    Base := if (R := DailyRewards[Day]) then R else ftb_reward{}
    Bonus := 1.0 + (if (B := DailyStreakBonus[Min(6, Max(0, NewStreak - 1))]) then B else 0.0)
    Scaled := ftb_reward{IncomeSeconds := Base.IncomeSeconds * Bonus, Kerne := (if (K := Round[Base.Kerne * Bonus]) then K else Base.Kerne),
                         Eggs := Base.Eggs, Tokens := Base.Tokens, CosmeticId := Base.CosmeticId}
    if:
        set S.LastDay = Today
        set S.DailyDay = S.DailyDay + 1
        set S.Streak = NewStreak
        set S.StreakShieldWeek = NewShield
        GrantReward(S, Scaled, T.EventWeek(S))
        CommitSave[S.Agent, BuildSave(S, T.SimNow())]
    then:
        true
    else:
        false
