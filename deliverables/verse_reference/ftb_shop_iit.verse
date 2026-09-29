# =====================================================================
# REFERENZ — UNGEPRÜFT bis in UEFN kompiliert
# Datei: ftb_shop_iit.verse  (FUSE THE BRAINROT)
# Zweck: In-Island-Transactions (GDD §9). Nur deterministische Angebote,
#        kein Zufall gegen V-Bucks, keine Timer, keine Pop-ups.
# WICHTIG: Die Klassen-/Funktionssignaturen hier sind UNVERIFIED.
#   Vor dem Kompilieren die offizielle "In-Island Transactions Device
#   Template" (dev.epicgames.com) WÖRTLICH importieren und nur die
#   Inhalte (Namen, Preise, Grant-Logik) hierher übertragen [Feas §8].
# Belegt (Suchauszüge, VERIFIED/LIKELY):
#   - BuyOffer, OnPurchasesChanged, ShowOffersDialog, GetPurchasedEntitlements,
#     ConsumeEntitlement, GetMinPurchaseAge existieren (VERIFIED Namen).
#   - GetEntitlementsChangedEvent(Player, Ent).Subscribe(OnPurchasesChanged)
#     im Template (LIKELY, Suchauszug).
#   - GetPurchasedEntitlements(Player, entitlement)<transacts><suspends>…
#     liefert Paare (Entitlement, Anzahl) (LIKELY, Suchauszug; Rückgabetyp unklar).
#   - Consumable=false => MaxCount=1 (VERIFIED).
# Grant-Grundsatz: dauerhafte Angebote sind ZUSTÄNDE (Bit im Spiegel),
#   keine Einmal-Gutschriften -> doppelte Auswertung ist harmlos (idempotent).
# =====================================================================

using { /Fortnite.com/Marketplace }               # Modulpfad LIKELY
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Spiegel-Bits in S.IITMirror (NIE umnummerieren, Save-Schema!)
IITBitGoldenNest:int = 0        # 300 VB  2. Brutplatz              (Vorteil)
IITBitTurboHatch:int = 1        # 250 VB  Brutzeit −50 %            (Vorteil)
IITBitDoubleFusion:int = 2      # 400 VB  2. Fusions-Slot           (Vorteil)
IITBitCoinMagnet:int = 3        # 800 VB  +100 % Pad-Münzen          (Vorteil)
IITBitAutoWave:int = 4          # 300 VB  bis 10 Auto-Wellen        (Komfort)
IITBitStallPlus:int = 5         # 150 VB  Stall 30 -> 50            (Komfort)
IITBitThemeNeon:int = 6         # 400 VB  Plot-Thema Neon-Nacht     (kosmetisch)
IITBitThemeCandy:int = 7        # 400 VB  Plot-Thema Zuckerwatte    (kosmetisch)
IITBitThemeLava:int = 8         # 400 VB  Plot-Thema Vulkan-Grill   (kosmetisch)
IITBitRainbowTag:int = 9        # 200 VB  Namensschild + Titel      (kosmetisch)
IITBitConfetti:int = 10         # 250 VB  Konfetti-Angriffe         (kosmetisch)
IITBitStarWaffle:int = 11       # 500 VB  Kreatur Sternenwaffel     (Vorteil, deterministisch)
IITBitStarWaffleGranted:int = 12 # interner Merker: Kreatur schon ins Inventar gelegt
# Bundle Themen-Sammlung (900 VB) setzt Bits 6, 7, 8.
# Münz-Rausch (100 VB, Consumable, MaxCount 10) hat kein Bit, sondern
# CoinRushSeconds + IITPendingConsume (Idempotenz-Ledger).
CoinRushSecondsPerItem:float = 3600.0

# ---------------------------------------------------------------------
# Entitlements (UNVERIFIED: Basisklasse `entitlement`, Feldnamen).
# ---------------------------------------------------------------------
TxtGameplayAdvantage<localizes>:message = "Gibt einen Gameplay-Vorteil."
TxtCosmetic<localizes>:message = "Rein kosmetisch."
NameGoldenNest<localizes>:message = "Goldenes Nest"
DescGoldenNest<localizes>:message = "Zweiter Brutplatz. Gibt einen Gameplay-Vorteil: doppelt so viele Eier gleichzeitig."
NameCoinRush<localizes>:message = "Münz-Rausch (60 Spielminuten)"
DescCoinRush<localizes>:message = "+50 % Pad-Münzen für 60 aktive Minuten. Stapelt nicht mit sich selbst. Gibt einen Gameplay-Vorteil."

ftb_ent_golden_nest<public> := class<concrete>(entitlement):
    Name<override>:message = NameGoldenNest
    Description<override>:message = DescGoldenNest
    ShortDescription<override>:message = TxtGameplayAdvantage
    ConsequentialToGameplay<override>:logic = true
    Consumable<override>:logic = false
    MaxCount<override>:int = 1
    # Icon<override>:texture = FTB_Icons.T_IIT_GoldenNest   # Asset-Pfad UNVERIFIED

ftb_ent_coin_rush<public> := class<concrete>(entitlement):
    Name<override>:message = NameCoinRush
    Description<override>:message = DescCoinRush
    ShortDescription<override>:message = TxtGameplayAdvantage
    ConsequentialToGameplay<override>:logic = true
    Consumable<override>:logic = true
    MaxCount<override>:int = 10

# Die übrigen 11 Entitlements identisch nach obigem Muster anlegen:
#   ftb_ent_turbo_hatch, ftb_ent_double_fusion, ftb_ent_coin_magnet, ftb_ent_auto_wave,
#   ftb_ent_stall_plus, ftb_ent_theme_neon, ftb_ent_theme_candy, ftb_ent_theme_lava,
#   ftb_ent_rainbow_tag, ftb_ent_confetti, ftb_ent_star_waffle
# Offers (entitlement_offer / bundle_offer, UNVERIFIED) mit Preisen laut GDD §9:
#   300/250/400/800/300/150/400/400/400/900(Bundle)/200/250/500/100.
# Keine Streichpreise, keine Zeitlimits.

# ---------------------------------------------------------------------
# Laufzeit-Dienst
# ---------------------------------------------------------------------
ftb_iit_service := class:
    var AgeChecked:[player]logic = map{}
    var AgeOk:[player]logic = map{}

    # GetMinPurchaseAge: Absturzbericht (LIKELY) -> 1× pro Sitzung, im Fehlerkontext.
    CheckAgeOnce(P:player)<suspends>:logic =
        if (Done := AgeChecked[P], Done?):
            return if (Ok := AgeOk[P], Ok?) then true else false
        if (set AgeChecked[P] = true) {}
        # UNVERIFIED Signatur; Template-Version übernehmen.
        # Ok := if (GetMinPurchaseAge[P]) then true else false
        Ok := true
        if (set AgeOk[P] = Ok) {}
        Ok

    # Anzahl gekaufter Einheiten eines Entitlements (UNVERIFIED Rückgabeform).
    OwnedCount(P:player, EntType:castable_subtype(entitlement))<suspends>:int =
        var N:int = 0
        for (Pair : GetPurchasedEntitlements(P, EntType)):
            set N += Pair(1)
        N

    # Einmal beim Join + in OnPurchasesChanged. Idempotent.
    SyncEntitlements(S:ftb_player_state, Now:float)<suspends>:void =
        P := S.Agent
        var Mirror:int = S.IITMirror
        if (OwnedCount(P, ftb_ent_golden_nest) > 0):
            set Mirror = SetBitInt(Mirror, IITBitGoldenNest)
        # … analog für alle dauerhaften Entitlements (Bundle -> Bits 6, 7, 8)
        # Sternenwaffel: Kreatur genau EINMAL ins Inventar (Bit 12 = schon vergeben)
        StarOwned := if (HasBitInt[Mirror, IITBitStarWaffle]) then true else false
        if:
            set S.IITMirror = Mirror
            StarOwned?
            not HasBitInt[S.IITMirror, IITBitStarWaffleGranted]
            set S.IITMirror = SetBitInt(S.IITMirror, IITBitStarWaffleGranted)
            # Sternenwaffel: Waffelino, Episch, Form 31 = Sternen-Form, Flag-Bit 3 = IIT
            set S.Creatures += array{ftb_creature{Head := 1, Body := 1, Acc := 1, Rarity := 3, Form := 31, Flags := 8}}
            CommitSave[P, BuildSave(S, Now)]
        # Mirror auch ohne Sternenwaffel sichern
        if (set S.IITMirror = Mirror, CommitSave[P, BuildSave(S, Now)]) {}
        HandleCoinRush(S, Now)

    # Münz-Rausch: 2-Phasen-Ledger gegen Doppelvergabe.
    #  Phase 1 (atomar): Sekunden gutschreiben + Pending=1 + Commit
    #  Phase 2: ConsumeEntitlement; danach Pending=0 + Commit.
    #  Absturz zwischen 1 und 2 -> beim nächsten Join: Pending=1 und Count>0
    #  => nur konsumieren, NICHT erneut gutschreiben.
    HandleCoinRush(S:ftb_player_state, Now:float)<suspends>:void =
        P := S.Agent
        Count := OwnedCount(P, ftb_ent_coin_rush)
        if (S.IITPendingConsume = 1):
            if (Count > 0):
                ConsumeOne(P)
            if (set S.IITPendingConsume = 0, CommitSave[P, BuildSave(S, Now)]) {}
            return
        # Stapelt nicht mit sich selbst: erst aktivieren, wenn der alte abgelaufen ist.
        if (Count > 0, S.CoinRushSeconds <= 0.0):
            if (set S.CoinRushSeconds = CoinRushSecondsPerItem, set S.IITPendingConsume = 1,
                CommitSave[P, BuildSave(S, Now)]):
                ConsumeOne(P)
                if (set S.IITPendingConsume = 0, CommitSave[P, BuildSave(S, Now)]) {}

    ConsumeOne(P:player)<suspends>:void =
        # UNVERIFIED: ConsumeEntitlement(Player, Entitlement-Typ, Anzahl)
        ConsumeEntitlement(P, ftb_ent_coin_rush, 1)

    # Kauf-Knopf im Shop-Tab (S13). Gewährt NICHTS selbst: Vergabe nur in
    # OnPurchasesChanged -> SyncEntitlements (Epic-Best-Practice, LIKELY).
    TryBuy(S:ftb_player_state, Offer:entitlement_offer)<suspends>:void =
        if (S.PendingPurchase?):
            return
        if (not CheckAgeOnce(S.Agent)?):
            Print("FTB IIT: Shop nicht verfügbar (Altersprüfung)")
            return
        set S.PendingPurchase = true
        BuyOffer(S.Agent, Offer)        # UNVERIFIED Signatur/Rückgabe
        set S.PendingPurchase = false

SetBitInt(Word:int, Bit:int)<transacts>:int =
    if (HasBitInt[Word, Bit]) then Word else Word + Pow2(Bit)
