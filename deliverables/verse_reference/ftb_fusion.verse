# =====================================================================
# REFERENZ — UNGEPRÜFT bis in UEFN kompiliert
# Datei: ftb_fusion.verse  (FUSE THE BRAINROT)
# Zweck: Fusionsregeln (GDD §4.6), Geheim-Rezepte (§4.8), Trait-Vererbung,
#        deterministischer Namensgenerator (§4.7). Der Namens-Algorithmus
#        ist gegen alle 1.000 Zeilen von data/hybrid_names.csv geprüft
#        (Python-Spiegel dieses Codes: 0 Abweichungen).
# =====================================================================

using { /Verse.org/Simulation }
using { /Verse.org/Random }                       # GetRandomFloat: LIKELY-Signatur
using { /UnrealEngine.com/Temporary/Diagnostics }

# ------------------------- Namensgenerator ----------------------------
# Strings sind in Verse []char; Index S[I] ist failable, Slice[] failable,
# `+` verkettet: VERIFIED (Verse-Sprache). char-Literal 'a': VERIFIED.
IsVowel(C:char)<decides><computes>:void =
    (C = 'a' or C = 'e' or C = 'i' or C = 'o' or C = 'u' or
     C = 'A' or C = 'E' or C = 'I' or C = 'O' or C = 'U')

# Konsonant+Konsonant -> Bindevokal "a"; Vokal+Vokal -> 1. Vokal rechts streichen.
JoinSyllables(Left:string, Right:string)<transacts>:string =
    if (X := Left[Left.Length - 1], Y := Right[0]):
        if (not IsVowel[X], not IsVowel[Y]):
            Left + "a" + Right
        else if (IsVowel[X], IsVowel[Y], Rest := Right.Slice[1]):
            Left + Rest
        else:
            Left + Right
    else:
        Left + Right

# Dreifach-Buchstaben kappen ("zzz" -> "zz")
CapTriples(S:string)<transacts>:string =
    var Out:string = ""
    for (Ch : S):
        L := Out.Length
        Skip := if (L >= 2, P1 := Out[L - 1], P2 := Out[L - 2], P1 = Ch, P2 = Ch) then true else false
        if (not Skip?):
            set Out += array{Ch}
    Out

# Basis-Namen der reinen Formen (catalog_gen.py BASE_NAMES), Index [Art-1][Seltenheit 0..3 | 4 = Top-Form]
BaseNames:[][]string = array{
    array{"Waffelino", "Waffelinetto", "Waffeloro", "Kristawaffel", "Re Waffelissimo"},
    array{"Frogurko", "Frogurchetto", "Frogoldurko", "Kristagurko", "Gurkönig Frogurkone"},
    array{"Idrantoro", "Idrantorino", "Idrantoro Dorado", "Kristidranto", "Imperatoro Idrante"},
    array{"Tagliatakel", "Tagliatakelino", "Tagliatakel d'Oro", "Kristallotakel", "Mamma Tagliatella"},
    array{"Diskolama", "Diskolamina", "Goldiskolama", "Kristallama", "Diskolama Mythica"},
    array{"Razzopingu", "Razzopinguino", "Razzoro", "Kristazzo", "Razzopingu Supremo"},
    array{"Wolkowal", "Wolkowalino", "Wolkoro", "Kristallwal", "Kosmowal Infinito"},
    array{"Bzzkoffro", "Bzzkoffrino", "Bzzoro Kofferone", "Kristabzz", "Galaktikoffro"}}
# Seltenheit der Top-Form je Art (Leg. 1–4, Myth. 5–6, Geheim 7–8)
TopFormRarity:[]int = array{4, 4, 4, 4, 5, 5, 6, 6}

HybridName(H:int, B:int, A:int)<transacts>:string =
    if (H = B, B = A, N := SpeciesName[H - 1]):
        return N
    P := if (X := SyllablePrefix[H - 1]) then X else "?"
    M := if (X := SyllableMid[B - 1]) then X else "?"
    S := if (X := SyllableSuffix[A - 1]) then X else "?"
    CapTriples(JoinSyllables(JoinSyllables(P, M), S))

# ------------------------- Geheim-Rezepte (§4.8) ----------------------
secret_recipe := struct:
    Name:string
    Head:int
    Body:int
    Acc:int

SecretRecipes:[]secret_recipe = array{
    secret_recipe{Name := "Blitzodisko Supremo", Head := 7, Body := 5, Acc := 6},
    secret_recipe{Name := "Nudelnebel Infinito", Head := 4, Body := 7, Acc := 2},
    secret_recipe{Name := "Kofferkanone Magnifica", Head := 8, Body := 6, Acc := 3},
    secret_recipe{Name := "Sirupsturm Galattico", Head := 1, Body := 7, Acc := 5},
    secret_recipe{Name := "Hydrodisko Grandioso", Head := 3, Body := 5, Acc := 4},
    secret_recipe{Name := "Gurkenrakete Fantastica", Head := 2, Body := 6, Acc := 8},
    secret_recipe{Name := "Walwaffel Celestiale", Head := 7, Body := 1, Acc := 8},
    secret_recipe{Name := "Pinguinudel Assoluta", Head := 6, Body := 4, Acc := 7}}

FindSecretRecipe(H:int, B:int, A:int)<decides><transacts>:int =
    var Found:int = -1
    for (I -> R : SecretRecipes, R.Head = H, R.Body = B, R.Acc = A):
        set Found = I
    Found >= 0
    Found

# Anzeigename inkl. Titel-Präfix ab Legendär (§4.7 Punkt 4) und Sonderfällen.
DisplayName(C:ftb_creature)<transacts>:string =
    if (HasBitInt[C.Flags, 2], Idx := FindSecretRecipe[C.Head, C.Body, C.Acc], R := SecretRecipes[Idx]):
        return R.Name
    if (C.Head = C.Body, C.Body = C.Acc, Row := BaseNames[C.Head - 1]):
        if (C.Rarity <= 3, N := Row[C.Rarity]):
            return N
        if (Top := TopFormRarity[C.Head - 1], C.Rarity = Top, N := Row[4]):
            return N
    Prefix := if (P := RarityTitlePrefix[C.Rarity]) then P else ""
    Prefix + HybridName(C.Head, C.Body, C.Acc)

# Hybrid-Index-Bit (0..999), passt zu hybrid_names.csv-Reihenfolge
HybridIndexBit(C:ftb_creature)<transacts>:int = (C.Head - 1) * 100 + (C.Body - 1) * 10 + (C.Acc - 1)

# ------------------------- Fusion -------------------------------------
# Teilewahl: true = Teil von Elternteil A
fusion_choice := struct:
    HeadFromA:logic = true
    BodyFromA:logic = true
    AccFromA:logic = true

fusion_preview := struct:
    Result:ftb_creature = ftb_creature{}
    Name:string = ""
    ResonanceChance:float = 0.0    # 0 = keine Resonanz möglich
    ResonanceTarget:int = 0
    PityGuaranteed:logic = false
    IsSecret:logic = false
    IsNewInIndex:logic = false
    CoinCost:float = 0.0
    KerneCost:int = 0
    DurationSeconds:float = 0.0

# Auto-Vorschlag (§4.6): pro Slot das Teil mit dem höheren Wert fürs Ziel.
SuggestChoice(A:ftb_creature, B:ftb_creature, GoalIncome:logic)<transacts>:fusion_choice =
    HeadA := AtF(SpeciesAtkFactor, A.Head - 1)
    HeadB := AtF(SpeciesAtkFactor, B.Head - 1)
    BodyScore := (if (GoalIncome?) then SpeciesIncomeFactor else SpeciesHpFactor)
    BodyA := AtF(BodyScore, A.Body - 1) * (if (GoalIncome?) then 1.0 else AtF(SpeciesSpeedFactor, A.Body - 1))
    BodyB := AtF(BodyScore, B.Body - 1) * (if (GoalIncome?) then 1.0 else AtF(SpeciesSpeedFactor, B.Body - 1))
    # Accessoire: Einkommens-Traits (Waffelino, Bzzkoffro) bzw. Kampf-Traits bevorzugen
    AccIncome := array{1.0, 0.2, 0.2, 0.2, 0.4, 0.2, 0.2, 0.9, 0.5, 0.2}
    AccCombat := array{0.2, 0.7, 0.6, 0.8, 0.9, 1.0, 0.8, 0.3, 0.5, 0.8}
    AccTable := if (GoalIncome?) then AccIncome else AccCombat
    fusion_choice:
        HeadFromA := if (HeadA >= HeadB) then true else false
        BodyFromA := if (BodyA >= BodyB) then true else false
        AccFromA := if (AtF(AccTable, A.Acc - 1) >= AtF(AccTable, B.Acc - 1)) then true else false

# Vorschau berechnen (Pflicht VOR dem Bestätigen, §4.6). Kein Zufall hier.
BuildFusionPreview(S:ftb_player_state, A:ftb_creature, B:ftb_creature, Ch:fusion_choice, ResChance:float)<transacts>:fusion_preview =
    H := if (Ch.HeadFromA?) then A.Head else B.Head
    Bo := if (Ch.BodyFromA?) then A.Body else B.Body
    Ac := if (Ch.AccFromA?) then A.Acc else B.Acc
    OtherAcc := if (Ch.AccFromA?) then B.Acc else A.Acc
    NewGen := Min(GenCap, Max(A.Gen, B.Gen) + 1)
    Mirror := if (A.Head = B.Head, A.Body = B.Body, A.Acc = B.Acc) then true else false
    NewSide := if (NewGen >= 5 or Mirror?) then OtherAcc else 0
    HiR := Max(A.Rarity, B.Rarity)
    # Geheim: beide Mythisch + exaktes Rezept -> garantiert Geheim
    SecretHit := if (A.Rarity = 5, B.Rarity = 5, FindSecretRecipe[H, Bo, Ac]) then true else false
    # Resonanz: gleiche Seltenheit, Ergebnis max. Mythisch (§4.6)
    CanResonate := if (not SecretHit?, A.Rarity = B.Rarity, HiR < 5) then true else false
    NewFlags := (if (NewSide > 0) then 1 else 0) + (if (SecretHit?) then 4 else 0)
    Res := ftb_creature:
        Head := H
        Body := Bo
        Acc := Ac
        Rarity := if (SecretHit?) then 6 else HiR
        Level := Max(A.Level, B.Level)
        Gen := NewGen
        Flags := NewFlags
        SideAcc := NewSide
    NewIdx := if (HasBit[S.IndexBits, HybridIndexBit(Res)]) then false else true
    fusion_preview:
        Result := Res
        Name := DisplayName(Res)
        ResonanceChance := if (CanResonate?) then ResChance else 0.0
        ResonanceTarget := if (CanResonate?) then HiR + 1 else HiR
        PityGuaranteed := if (CanResonate?, S.ResPity + 1 >= ResonancePity) then true else false
        IsSecret := SecretHit
        IsNewInIndex := NewIdx
        CoinCost := FusionCoinCost(HiR, S.Rebirths)
        KerneCost := FusionKerneCost(HiR)
        DurationSeconds := AtF(FusionTimeSeconds, HiR)

# Endgültiges Ergebnis (Resonanz würfeln, Pity pflegen). Aufruf erst beim
# Einsammeln bzw. Start; Kosten bucht ftb_game_manager atomar.
ResolveFusion(S:ftb_player_state, P:fusion_preview)<transacts>:ftb_creature =
    if (P.ResonanceChance <= 0.0):
        return P.Result
    Hit := if (P.PityGuaranteed? or GetRandomFloat(0.0, 1.0) < P.ResonanceChance) then true else false
    if (Hit?):
        set S.ResPity = 0
        C := P.Result
        return ftb_creature{Head := C.Head, Body := C.Body, Acc := C.Acc, Rarity := P.ResonanceTarget,
                            Level := C.Level, Gen := C.Gen, Form := C.Form, Flags := C.Flags, SideAcc := C.SideAcc}
    set S.ResPity += 1
    P.Result

# Trait-Stärke einer Art für eine Kreatur: 1.0 Haupt-Accessoire, 0.5 Neben-Trait
TraitStrength(C:ftb_creature, Species:int)<transacts>:float =
    var T:float = 0.0
    if (C.Acc = Species):
        set T += 1.0
    if (HasBitInt[C.Flags, 0], C.SideAcc = Species):
        set T += 0.5
    T
