# =====================================================================
# REFERENZ — UNGEPRÜFT bis in UEFN kompiliert
# Datei: ftb_creature_pool.verse  (FUSE THE BRAINROT)
# Zweck: Darstellung der Kreaturen über einen vorplatzierten Prop-Pool:
#        je Pad 24 Teil-Props (8 Arten × Kopf/Körper/Accessoire), nur
#        ein-/ausblenden, positionieren, Seltenheits-Material setzen,
#        prozedurale Lunge-Animation (GDD §1 Punkt 5, §4.1, §11).
# Kein Rigging, keine Laufzeit-Entities. Idle-Bob läuft im Material (WPO).
# Offsets passen zu blender/gen_species_parts.py (SPECIES-Dict, Werte in cm).
# Konvention lokal: X = vorwärts (Blickrichtung), Y = rechts, Z = oben.
# Blender -> lokal: X_lokal = -Y_blender, Z_lokal = Z_blender (alle Montage-
# punkte liegen auf der Mittelachse, X_blender = 0). Achsen in UEFN prüfen!
# =====================================================================

using { /Fortnite.com/Devices }                   # creative_prop: VERIFIED
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath } # vector3, rotation, transform: VERIFIED (Modul)
using { /UnrealEngine.com/Temporary/Diagnostics }

PartsPerPad:int = 24          # 3 Slots × 8 Arten (Release 1)
MaxLungesPerPlot:int = 3      # GDD §2.4.3 Serverlast
# Einheitliche Anzeige-Skalierung (Blender-Kreatur 1,6–2,1 m -> GDD 1,8–2,4 m), Bauplan §5.2/M1-07.
# ALLE Skalen (Lunge/Landen) sind DisplayScale × Faktor, ALLE Montage-Offsets × DisplayScale,
# sonst schrumpft die Kreatur nach dem ersten Lunge auf 1,0 bzw. Kopf/Acc schweben.
# Fallback, falls MoveTo mit Skalierung scheitert (Probe P3): DisplayScale = 1.0 setzen.
DisplayScale:float = 1.15

# Montage-Typ des Accessoires: 0 Rücken, 1 Hals (Körper), 2 Kopf-oben, 3 Gesicht (Kopf)
AccMountType:[]int = array{0, 2, 1, 1, 3, 1, 0, 0, 0, 0}

# Körper: Kopf-Sockel, Rücken, Hals (lokal, cm). Index = Art-1.
BodyHeadSocket:[]vector3 = array{
    vector3{X := 0.0, Y := 0.0, Z := 80.0},  vector3{X := 0.0, Y := 0.0, Z := 90.0},
    vector3{X := 0.0, Y := 0.0, Z := 95.0},  vector3{X := 0.0, Y := 0.0, Z := 65.0},
    vector3{X := 0.0, Y := 0.0, Z := 100.0}, vector3{X := 0.0, Y := 0.0, Z := 95.0},
    vector3{X := 0.0, Y := 0.0, Z := 85.0},  vector3{X := 0.0, Y := 0.0, Z := 75.0}}
BodyBackMount:[]vector3 = array{
    vector3{X := -40.0, Y := 0.0, Z := 50.0}, vector3{X := -40.0, Y := 0.0, Z := 50.0},
    vector3{X := -38.0, Y := 0.0, Z := 55.0}, vector3{X := -45.0, Y := 0.0, Z := 40.0},
    vector3{X := -40.0, Y := 0.0, Z := 75.0}, vector3{X := -35.0, Y := 0.0, Z := 55.0},
    vector3{X := -45.0, Y := 0.0, Z := 60.0}, vector3{X := -23.0, Y := 0.0, Z := 50.0}}
BodyNeckMount:[]vector3 = array{
    vector3{X := 30.0, Y := 0.0, Z := 78.0}, vector3{X := 35.0, Y := 0.0, Z := 85.0},
    vector3{X := 34.0, Y := 0.0, Z := 90.0}, vector3{X := 30.0, Y := 0.0, Z := 62.0},
    vector3{X := 40.0, Y := 0.0, Z := 95.0}, vector3{X := 32.0, Y := 0.0, Z := 88.0},
    vector3{X := 40.0, Y := 0.0, Z := 80.0}, vector3{X := 23.0, Y := 0.0, Z := 72.0}}
# Kopf: oben, Gesicht (relativ zum Kopf-Pivot = Hals-Unterseite)
HeadTopMount:[]vector3 = array{
    vector3{X := 0.0, Y := 0.0, Z := 100.0}, vector3{X := 0.0, Y := 0.0, Z := 72.0},
    vector3{X := 0.0, Y := 0.0, Z := 82.0},  vector3{X := 0.0, Y := 0.0, Z := 100.0},
    vector3{X := 0.0, Y := 0.0, Z := 110.0}, vector3{X := 0.0, Y := 0.0, Z := 82.0},
    vector3{X := 0.0, Y := 0.0, Z := 78.0},  vector3{X := 0.0, Y := 0.0, Z := 95.0}}
HeadFaceMount:[]vector3 = array{
    vector3{X := 40.0, Y := 0.0, Z := 40.0}, vector3{X := 38.0, Y := 0.0, Z := 35.0},
    vector3{X := 40.0, Y := 0.0, Z := 40.0}, vector3{X := 40.0, Y := 0.0, Z := 40.0},
    vector3{X := 35.0, Y := 0.0, Z := 55.0}, vector3{X := 38.0, Y := 0.0, Z := 45.0},
    vector3{X := 45.0, Y := 0.0, Z := 35.0}, vector3{X := 38.0, Y := 0.0, Z := 40.0}}

AtV(A:[]vector3, I:int):vector3 = if (V := A[I]) then V else vector3{}

# Lokale Offsets der drei Teile für eine Kreatur (Körper-Pivot = Pad-Oberfläche)
part_layout := struct:
    Body:vector3 = vector3{}
    Head:vector3 = vector3{}
    Acc:vector3 = vector3{}

ComputeLayout(C:ftb_creature):part_layout =
    HeadPos := AtV(BodyHeadSocket, C.Body - 1)
    Mount := if (M := AccMountType[C.Acc - 1]) then M else 0
    AccPos := case(Mount):
        1 => AtV(BodyNeckMount, C.Body - 1)
        2 => HeadPos + AtV(HeadTopMount, C.Head - 1)
        3 => HeadPos + AtV(HeadFaceMount, C.Head - 1)
        _ => AtV(BodyBackMount, C.Body - 1)
    part_layout{Body := vector3{}, Head := HeadPos, Acc := AccPos}

# ---------------------------------------------------------------------
# Pool eines Plots. Props werden im Editor (per MCP/Python-Skript)
# platziert und in dieser Reihenfolge ins Array gezogen:
#   Index = Pad * 24 + Slot * 8 + (Art - 1),  Slot 0 Kopf, 1 Körper, 2 Acc.
# @editable-Array von creative_prop: VERIFIED-Muster.
# ---------------------------------------------------------------------
ftb_plot_pool := class<concrete>:
    @editable PartProps:[]creative_prop = array{}
    @editable PadMarkers:[]creative_prop = array{}   # unsichtbare Marker je Pad (Position + Blickrichtung)
    # Seltenheits-Materialien MI_FTB_Rarity_0..6. @editable für `material`: UNVERIFIED.
    # Fallback: Asset-Referenz aus der generierten Assets-Digest (z. B. FTB_Materials.MI_FTB_Rarity_Gold).
    @editable RarityMaterials:[]material = array{}

    var LungesRunning:int = 0

    GetPart(Pad:int, Slot:int, Species:int)<decides><transacts>:creative_prop =
        PartProps[Pad * PartsPerPad + Slot * 8 + (Species - 1)]

    # Alle 24 Teile eines Pads ausblenden. Hide(): LIKELY (Fallback TeleportTo unter die Map)
    ClearPad(Pad:int):void =
        for (I := 0..PartsPerPad - 1, Prop := PartProps[Pad * PartsPerPad + I]):
            Prop.Hide()

    PadTransform(Pad:int):transform =
        if (M := PadMarkers[Pad]) then M.GetTransform() else transform{}

    # Kreatur auf Pad zeigen: 3 Teile positionieren, Material setzen, einblenden.
    ShowCreature(Pad:int, C:ftb_creature):void =
        ClearPad(Pad)
        T := PadTransform(Pad)
        L := ComputeLayout(C)
        PlacePart(Pad, 0, C.Head, T, L.Head, C.Rarity)
        PlacePart(Pad, 1, C.Body, T, L.Body, C.Rarity)
        PlacePart(Pad, 2, C.Acc, T, L.Acc, C.Rarity)

    PlacePart(Pad:int, Slot:int, Species:int, PadT:transform, Local:vector3, Rarity:int):void =
        if (Prop := GetPart[Pad, Slot, Species]):
            # Lokal -> Welt: mit Pad-Rotation drehen. RotateVector: LIKELY
            World := PadT.Translation + PadT.Rotation.RotateVector(Local * DisplayScale)
            if (Prop.TeleportTo[World, PadT.Rotation]) {}   # TeleportTo[]: VERIFIED (failable)
            # TeleportTo setzt keine Skalierung: der Aufrufer startet danach LandSquash (endet auf DisplayScale).
            # SetMaterial zur Laufzeit: LIKELY (GDD §4.2). Fallback: Aura-VFX am Pad.
            if (Mat := RarityMaterials[Rarity]):
                Prop.SetMaterial(Mat)
            Prop.Show()

    # Prozedurale Lunge (GDD §11): 0,25 s hin, 0,25 s zurück, Squash 1,0 -> 1,15 -> 1,0.
    # MoveTo(transform, Zeit) mit Skalierung: LIKELY. Fallback: MoveTo(Position, Rotation, Zeit).
    Lunge(Pad:int, C:ftb_creature, Distance:float)<suspends>:void =
        if (LungesRunning >= MaxLungesPerPlot):
            return
        set LungesRunning += 1
        PadT := PadTransform(Pad)
        L := ComputeLayout(C)
        Fwd := PadT.Rotation.RotateVector(vector3{X := Distance, Y := 0.0, Z := 0.0})
        sync:
            LungePart(Pad, 0, C.Head, PadT, L.Head, Fwd)
            LungePart(Pad, 1, C.Body, PadT, L.Body, Fwd)
            LungePart(Pad, 2, C.Acc, PadT, L.Acc, Fwd)
        set LungesRunning -= 1

    LungePart(Pad:int, Slot:int, Species:int, PadT:transform, Local:vector3, Fwd:vector3)<suspends>:void =
        if (Prop := GetPart[Pad, Slot, Species]):
            Home := PadT.Translation + PadT.Rotation.RotateVector(Local * DisplayScale)
            D := DisplayScale
            Out := transform{Translation := Home + Fwd, Rotation := PadT.Rotation, Scale := vector3{X := D * 1.15, Y := D * 1.15, Z := D * 0.87}}
            Back := transform{Translation := Home, Rotation := PadT.Rotation, Scale := vector3{X := D, Y := D, Z := D}}
            Prop.MoveTo(Out, 0.25)
            Prop.MoveTo(Back, 0.25)

    # "Landen"-Squash beim Aufs-Pad-Setzen (GDD §13: 0,8 -> 1,1 -> 1,0, 350 ms)
    LandSquash(Pad:int, C:ftb_creature)<suspends>:void =
        PadT := PadTransform(Pad)
        L := ComputeLayout(C)
        for (Step -> Sz : array{0.8, 1.1, 1.0}):
            sync:
                SquashPart(Pad, 0, C.Head, PadT, L.Head, Sz)
                SquashPart(Pad, 1, C.Body, PadT, L.Body, Sz)
                SquashPart(Pad, 2, C.Acc, PadT, L.Acc, Sz)

    SquashPart(Pad:int, Slot:int, Species:int, PadT:transform, Local:vector3, Sz:float)<suspends>:void =
        if (Prop := GetPart[Pad, Slot, Species]):
            D := DisplayScale
            Home := PadT.Translation + PadT.Rotation.RotateVector(Local * (Sz * D))
            Prop.MoveTo(transform{Translation := Home, Rotation := PadT.Rotation,
                                  Scale := vector3{X := D * (2.0 - Sz), Y := D * (2.0 - Sz), Z := D * Sz}}, 0.11)
