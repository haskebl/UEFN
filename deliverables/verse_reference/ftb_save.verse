# =====================================================================
# REFERENZ — UNGEPRÜFT bis in UEFN kompiliert
# Datei: ftb_save.verse  (FUSE THE BRAINROT)
# Zweck: Persistenz. EINE persistable Root-Klasse in EINER weak_map
#        (Projekt-Limit: max. 2 player-weak_maps, VERIFIED [Feas §1]).
#        Die zweite weak_map bleibt als Reserve für eine spätere Migration frei.
# Regeln (VERIFIED [Feas §1]):
#   - Nach dem ersten Publish NUR Felder MIT Default ergänzen,
#     nie umbenennen, nie entfernen, nie Typ ändern.
#   - `Version`-Feld für Migrationen.
#   - Größe je Spieler begrenzt (≈128 KB, LIKELY) -> FitsInPlayerMap prüfen.
# Forum-Hinweis (LIKELY): Defaults NICHT aus Modul-Konstanten setzen
# (Linker-Fehler gemeldet) -> hier nur Literale als Defaults.
# =====================================================================

using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

CurrentSaveVersion:int = 1

# ---------------------------------------------------------------------
# Größenbudget (Schätzung, Serialisierungs-Overhead UNVERIFIED):
#   Skalare: ~24 int/float à 8 B                         ≈   192 B
#   Creatures: max. 56 gepackte int (50 Stall + 6 Pads)   ≈   448 B
#   PadSlots 6, Brood 2×2, Fusing 2×2 int                 ≈   112 B
#   IndexBits 32 Worte (1.000 Hybrid-Bits à 32 Bit/Wort)  ≈   256 B
#   BaseIdx 3, EventIdx 2, EggPity 10, Tokens 8, Stats 8,
#   EventClaims 8                                         ≈   312 B
#   Summe Rohdaten                                        ≈ 1,3 KB
#   Mit angenommenem 3×-Overhead (Feldnamen/Array-Header) ≈ 4 KB
#   => < 4 % von 128 KB. FitsInPlayerMap nur beim Commit, nicht pro Tick
#      (Forum: FitsInPlayerMap ist langsam, LIKELY).
# ---------------------------------------------------------------------

# <persistable> + <final> Klasse: VERIFIED (Using Persistable Data).
# Persistable-Klassen dürfen KEINE var-Felder haben -> Updates bauen eine neue Instanz.
ftb_save_root := class<final><persistable>:
    Version:int = 1
    Coins:float = 0.0
    Kerne:int = 0
    Tokens:[]int = array{}          # 8 Event-Wochen, Index = Woche-1
    Rebirths:int = 0
    Totem:int = 0
    Pads:int = 2
    BestWave:int = 0
    Creatures:[]int = array{}       # gepackt (PackCreature)
    PadSlots:[]int = array{}        # Index in Creatures oder -1
    Brood:[]int = array{}           # Paare (EiStufe, RestSekunden)
    Fusing:[]int = array{}          # Paare (gepacktes Ergebnis, RestSekunden)
    IndexBits:[]int = array{}       # Hybrid-Index, Bit = (K-1)*100+(B-1)*10+(A-1)
    BaseIdx:[]int = array{}         # 40 Basis-Einträge
    EventIdx:[]int = array{}        # 40 Event-Einträge
    SecretIdx:int = 0               # 8 Geheim-Rezepte
    EggPity:[]int = array{}         # 10 Zähler (8 Eier + Event-Ei + Reserve)
    ResPity:int = 0
    DailyDay:int = 0                # 0..6 in der 7-Tage-Schleife
    Streak:int = 0
    LastDay:int = -1                # UTC-Tag (Epoch/86400) oder Sitzungszähler im Fallback
    StreakShieldWeek:int = -1
    SessionsOK:int = 0              # Sitzungen mit >= 15 aktiven Minuten (Fallback-Kalender)
    CodesClaimed:int = 0            # Bitfeld, 16 Codes
    EventClaims:[]int = array{}     # je Woche Bitfeld (Aufgabe, Token-Umtausch, Kosmetik)
    IITMirror:int = 0               # Bitfeld der dauerhaften Angebote (Spiegel, nicht Wahrheit)
    IITPendingConsume:int = 0       # 1 = ConsumeEntitlement ausstehend (Idempotenz)
    CoinRushSeconds:float = 0.0     # Rest aktiver Sekunden Münz-Rausch
    Settings:int = 0                # Bitfeld Optionen
    Stats:[]int = array{}           # 0 Fusionen, 1 Bosse, 2 Spielminuten, 3 Wellen, 4 Hatches
    LastSeenEpoch:float = 0.0       # 0 = unbekannt (Zeit-API fehlt)
    PlaySeconds:float = 0.0
    LastSessionActiveSec:float = 0.0

# Modul-weite weak_map: VERIFIED-Muster `var X : weak_map(player, t) = map{}`
var FtbSaves:weak_map(player, ftb_save_root) = map{}

# ---------------------------------------------------------------------
# Bit-Hilfen. Verse hat (Stand Wissen) KEINE bitweisen Operatoren
# (UNVERIFIED) -> reine Arithmetik mit 32 Bit je Wort.
# Quotient[] / Mod[] sind failable: VERIFIED (Verse-Sprache).
# ---------------------------------------------------------------------
BitsPerWord:int = 32

Pow2(N:int)<transacts>:int =
    var R:int = 1
    for (I := 1..N):
        set R *= 2
    R

HasBit(Words:[]int, Bit:int)<decides><transacts>:void =
    W := Words[Quotient[Bit, BitsPerWord]]
    Mod[Quotient[W, Pow2(Mod[Bit, BitsPerWord])], 2] = 1

HasBitInt(Word:int, Bit:int)<decides><transacts>:void =
    Mod[Quotient[Word, Pow2(Bit)], 2] = 1

WithBit(Words:[]int, Bit:int)<transacts>:[]int =
    if (HasBit[Words, Bit]):
        return Words
    WordIdx := if (Q := Quotient[Bit, BitsPerWord]) then Q else 0
    BitIdx := if (M := Mod[Bit, BitsPerWord]) then M else 0
    var Out:[]int = Words
    # Array bei Bedarf verlängern (alte Saves sind kürzer)
    loop:
        if (Out.Length > WordIdx):
            break
        set Out += array{0}
    if (Old := Out[WordIdx], set Out[WordIdx] = Old + Pow2(BitIdx)) {}
    Out

CountBits(Words:[]int)<transacts>:int =
    var N:int = 0
    for (W : Words, B := 0..BitsPerWord - 1, HasBitInt[W, B]):
        set N += 1
    N

# ---------------------------------------------------------------------
# Kreatur packen: gemischte Basis (kein Bitshift nötig).
# Head 16 · Body 16 · Acc 16 · Rarity 8 · Level 256 · Gen 16 · Form 32 · Flags 16 · SideAcc 16
# Erweiterung NUR als neue oberste Stelle anhängen -> alte Werte bleiben gültig (SideAcc = 0).
# Maximalwert ≈ 2^40 < 2^63: passt in Verse-int (64 Bit, LIKELY).
# ---------------------------------------------------------------------
PackCreature(C:ftb_creature)<transacts>:int =
    C.Head + 16 * (C.Body + 16 * (C.Acc + 16 * (C.Rarity + 8 * (C.Level + 256 * (C.Gen + 16 * (C.Form + 32 * (C.Flags + 16 * C.SideAcc)))))))

UnpackCreature(P:int)<transacts>:ftb_creature =
    if:
        H := Mod[P, 16]
        R1 := Quotient[P, 16]
        B := Mod[R1, 16]
        R2 := Quotient[R1, 16]
        A := Mod[R2, 16]
        R3 := Quotient[R2, 16]
        Ra := Mod[R3, 8]
        R4 := Quotient[R3, 8]
        L := Mod[R4, 256]
        R5 := Quotient[R4, 256]
        G := Mod[R5, 16]
        R6 := Quotient[R5, 16]
        F := Mod[R6, 32]
        R7 := Quotient[R6, 32]
        Fl := Mod[R7, 16]
        Sa := Quotient[R7, 16]
    then:
        ftb_creature{Head := H, Body := B, Acc := A, Rarity := Ra, Level := L, Gen := G, Form := F, Flags := Fl, SideAcc := Sa}
    else:
        ftb_creature{}   # defekter Wert -> Gewöhnlicher Waffelino statt Absturz

# ---------------------------------------------------------------------
# Migration: alte Versionen auf den aktuellen Stand heben.
# Neue Felder bekommen ihren Default automatisch (VERIFIED), hier nur
# inhaltliche Korrekturen. Muster "Kopierkonstruktor" (LIKELY, aus Epic-
# Tutorial "Persistent Player Statistics").
# ---------------------------------------------------------------------
MakeSaveFrom<constructor>(Old:ftb_save_root)<transacts> := ftb_save_root:
    Version := Old.Version
    Coins := Old.Coins
    Kerne := Old.Kerne
    Tokens := Old.Tokens
    Rebirths := Old.Rebirths
    Totem := Old.Totem
    Pads := Old.Pads
    BestWave := Old.BestWave
    Creatures := Old.Creatures
    PadSlots := Old.PadSlots
    Brood := Old.Brood
    Fusing := Old.Fusing
    IndexBits := Old.IndexBits
    BaseIdx := Old.BaseIdx
    EventIdx := Old.EventIdx
    SecretIdx := Old.SecretIdx
    EggPity := Old.EggPity
    ResPity := Old.ResPity
    DailyDay := Old.DailyDay
    Streak := Old.Streak
    LastDay := Old.LastDay
    StreakShieldWeek := Old.StreakShieldWeek
    SessionsOK := Old.SessionsOK
    CodesClaimed := Old.CodesClaimed
    EventClaims := Old.EventClaims
    IITMirror := Old.IITMirror
    IITPendingConsume := Old.IITPendingConsume
    CoinRushSeconds := Old.CoinRushSeconds
    Settings := Old.Settings
    Stats := Old.Stats
    LastSeenEpoch := Old.LastSeenEpoch
    PlaySeconds := Old.PlaySeconds
    LastSessionActiveSec := Old.LastSessionActiveSec

MigrateSave(S:ftb_save_root)<transacts>:ftb_save_root =
    var Cur:ftb_save_root = S
    # Beispiel für künftige Schritte:
    # if (Cur.Version < 2):
    #     set Cur = ftb_save_root{MakeSaveFrom<constructor>(Cur), Version := 2, NeuesFeld := ...}
    if (Cur.Version < 1):
        set Cur = ftb_save_root:
            MakeSaveFrom<constructor>(Cur)
            Version := 1
    Cur

# ---------------------------------------------------------------------
# Laden / Commit.
# Dupe-sicheres, atomares Muster:
#   Jede Vergabe (Code, Tagesbelohnung, IIT) läuft als
#     if (Markierung setzen <transacts>, Belohnung buchen <transacts>, CommitSave[...]) {}
#   Schlägt irgendein Teil fehl (z. B. FitsInPlayerMap), rollt Verse ALLE
#   `set` im Fehlerkontext zurück (Speculative Execution: VERIFIED Sprach-
#   feature). Belohnung und "schon eingelöst"-Bit landen also nur gemeinsam.
# ---------------------------------------------------------------------
LoadSave(P:player)<transacts>:ftb_save_root =
    if (S := FtbSaves[P]) then MigrateSave(S) else ftb_save_root{}

# FitsInPlayerMap: Name VERIFIED [Feas §1], Signatur (<decides>) UNVERIFIED.
CommitSave(P:player, New:ftb_save_root)<decides><transacts>:void =
    FitsInPlayerMap[New]
    set FtbSaves[P] = New

# ---------------------------------------------------------------------
# Zustand <-> Save. Zeit-Jobs werden als Restsekunden gespeichert, weil
# Simulationszeit zwischen Sitzungen nicht weiterläuft.
# ---------------------------------------------------------------------
JobsToInts(Jobs:[]ftb_timer_job, Now:float)<transacts>:[]int =
    var Out:[]int = array{}
    for (J : Jobs):
        Rest := if (R := Ceil[Max(0.0, J.EndsAt - Now)]) then R else 0
        set Out += array{J.Payload, Rest}
    Out

IntsToJobs(Ints:[]int, Now:float)<transacts>:[]ftb_timer_job =
    var Out:[]ftb_timer_job = array{}
    # Achtung: int / int ergibt in Verse `rational` -> Quotient[] benutzen (VERIFIED Sprache)
    Half := if (Q := Quotient[Ints.Length, 2]) then Q else 0
    for (I := 0..Half - 1, P := Ints[2 * I], R := Ints[2 * I + 1]):
        set Out += array{ftb_timer_job{Payload := P, EndsAt := Now + 1.0 * R}}
    Out

BuildSave(S:ftb_player_state, Now:float)<transacts>:ftb_save_root =
    ftb_save_root:
        Version := CurrentSaveVersion
        Coins := S.Coins
        Kerne := S.Kerne
        Tokens := S.Tokens
        Rebirths := S.Rebirths
        Totem := S.Totem
        Pads := S.Pads
        BestWave := S.BestWave
        Creatures := for (C : S.Creatures) { PackCreature(C) }
        PadSlots := S.PadSlots
        Brood := JobsToInts(S.Brood, Now)
        Fusing := JobsToInts(S.Fusing, Now)
        IndexBits := S.IndexBits
        BaseIdx := S.BaseIdx
        EventIdx := S.EventIdx
        SecretIdx := S.SecretIdx
        EggPity := S.EggPity
        ResPity := S.ResPity
        DailyDay := S.DailyDay
        Streak := S.Streak
        LastDay := S.LastDay
        StreakShieldWeek := S.StreakShieldWeek
        SessionsOK := S.SessionsOK
        CodesClaimed := S.CodesClaimed
        EventClaims := S.EventClaims
        IITMirror := S.IITMirror
        IITPendingConsume := S.IITPendingConsume
        CoinRushSeconds := S.CoinRushSeconds
        Settings := S.Settings
        Stats := S.Stats
        LastSeenEpoch := S.LastSeenEpoch
        PlaySeconds := S.PlaySeconds
        LastSessionActiveSec := S.SessionActiveSec

# Arrays aus alten Saves können kürzer sein -> auf Mindestlänge auffüllen.
PadTo(A:[]int, Len:int, Fill:int)<transacts>:[]int =
    var Out:[]int = A
    loop:
        if (Out.Length >= Len):
            break
        set Out += array{Fill}
    Out

ApplySave(S:ftb_player_state, Sv:ftb_save_root, Now:float)<transacts>:void =
    set S.Coins = Sv.Coins
    set S.Kerne = Sv.Kerne
    set S.Tokens = PadTo(Sv.Tokens, 8, 0)
    set S.Rebirths = Sv.Rebirths
    set S.Totem = Sv.Totem
    set S.Pads = Max(PadsStart, Sv.Pads)
    set S.BestWave = Sv.BestWave
    set S.Creatures = for (P : Sv.Creatures) { UnpackCreature(P) }
    set S.PadSlots = PadTo(Sv.PadSlots, PadsMax, -1)
    set S.Brood = IntsToJobs(Sv.Brood, Now)
    set S.Fusing = IntsToJobs(Sv.Fusing, Now)
    set S.IndexBits = Sv.IndexBits
    set S.BaseIdx = Sv.BaseIdx
    set S.EventIdx = Sv.EventIdx
    set S.SecretIdx = Sv.SecretIdx
    set S.EggPity = PadTo(Sv.EggPity, 10, 0)
    set S.ResPity = Sv.ResPity
    set S.DailyDay = Sv.DailyDay
    set S.Streak = Sv.Streak
    set S.LastDay = Sv.LastDay
    set S.StreakShieldWeek = Sv.StreakShieldWeek
    set S.SessionsOK = Sv.SessionsOK
    set S.CodesClaimed = Sv.CodesClaimed
    set S.EventClaims = PadTo(Sv.EventClaims, 8, 0)
    set S.IITMirror = Sv.IITMirror
    set S.IITPendingConsume = Sv.IITPendingConsume
    set S.CoinRushSeconds = Sv.CoinRushSeconds
    set S.Settings = Sv.Settings
    set S.Stats = PadTo(Sv.Stats, 8, 0)
    set S.LastSeenEpoch = Sv.LastSeenEpoch
    set S.PlaySeconds = Sv.PlaySeconds
    set S.LastSessionActiveSec = Sv.LastSessionActiveSec

# Bequemer Commit aus dem Sitzungszustand (periodisch alle 30 s + nach
# jedem wichtigen Ereignis). Rückgabe false = zu groß oder Spieler weg.
TryCommitState(S:ftb_player_state, Now:float)<transacts>:logic =
    if (CommitSave[S.Agent, BuildSave(S, Now)]):
        set S.Dirty = false
        true
    else:
        Print("FTB SAVE: Commit fehlgeschlagen (FitsInPlayerMap oder Spieler nicht mehr da)")
        false

# Nur Lese-Hilfe für Debug-Ausgaben
DebugSaveSummary(S:ftb_save_root)<transacts>:string =
    "v{S.Version} coins={S.Coins} kerne={S.Kerne} creatures={S.Creatures.Length} rebirths={S.Rebirths} wave={S.BestWave}"
