# =====================================================================
# REFERENZ — UNGEPRÜFT bis in UEFN kompiliert
# Datei: ftb_types.verse  (FUSE THE BRAINROT)
# Zweck: Grundtypen, Seltenheiten, Arten-Tabellen, Kreatur-Struct und
#        alle Konstanten aus GDD §4.2, §4.4, §5.8 (1:1 übernommen).
# Quelle der Wahrheit: deliverables/GDD_Fuse_and_Fight.md
# Status-Legende in Kommentaren:
#   VERIFIED   = Sprach-/API-Feature laut offiziellem Epic-Auszug belegt
#   LIKELY     = starkes Vorwissen / Sekundärquelle
#   UNVERIFIED = unbelegt, in UEFN prüfen
# Hinweis: Alle .verse-Dateien dieses Ordners liegen im SELBEN Modul,
#          daher sind die Definitionen hier ohne eigenes `using` sichtbar.
# =====================================================================

using { /Verse.org/Simulation }                 # VERIFIED (Standard-Import)
using { /UnrealEngine.com/Temporary/Diagnostics } # VERIFIED (Print)

# ---------------------------------------------------------------------
# Seltenheit (GDD §4.2). Im Save und in Tabellen wird der Index 0..6
# benutzt; das enum dient der Lesbarkeit im Code.
# enum-Syntax: VERIFIED (Verse-Sprache)
# ---------------------------------------------------------------------
ftb_rarity := enum{Common, Uncommon, Rare, Epic, Legendary, Mythic, Secret}

RarityToInt(R:ftb_rarity)<transacts>:int =
    case(R):
        ftb_rarity.Common => 0
        ftb_rarity.Uncommon => 1
        ftb_rarity.Rare => 2
        ftb_rarity.Epic => 3
        ftb_rarity.Legendary => 4
        ftb_rarity.Mythic => 5
        ftb_rarity.Secret => 6

IntToRarity(I:int)<transacts>:ftb_rarity =
    case(I):
        1 => ftb_rarity.Uncommon
        2 => ftb_rarity.Rare
        3 => ftb_rarity.Epic
        4 => ftb_rarity.Legendary
        5 => ftb_rarity.Mythic
        6 => ftb_rarity.Secret
        _ => ftb_rarity.Common

RarityCount:int = 7
RarityMax:int = 6

# Anzeige-Daten je Seltenheit (Index = Seltenheit)
RarityNameDE:[]string = array{"Gewöhnlich", "Ungewöhnlich", "Selten", "Episch", "Legendär", "Mythisch", "Geheim"}
RarityNameEN:[]string = array{"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret"}
# Farbenblind-Regel: Seltenheit immer auch als Symbol (GDD §8). Im UI als Textur,
# hier nur als Fallback-Zeichen für Debug-Text.
RaritySymbol:[]string = array{"●", "◆", "▲", "★", "♛", "✦", "∞"}
RarityHex:[]string = array{"B8C2CC", "5BD45B", "3AA0FF", "B056FF", "FFB319", "FF3D6E", "00E5FF"}
# Reveal-Dauer in Sekunden (GDD §4.2)
RevealSeconds:[]float = array{0.4, 0.6, 0.9, 1.4, 2.2, 2.8, 4.0}
# Titel-Präfix ab Legendär (nur Anzeige, GDD §4.7 Punkt 4)
RarityTitlePrefix:[]string = array{"", "", "", "", "Gran ", "Mythico ", "Kosmico "}

# ---------------------------------------------------------------------
# Arten (GDD §4.4). IDs 1..8 = Release 1, 9..10 = Bonus-Arten (Event W3/W6,
# Kill-Schalter über das Speicherbudget). Array-Index = ID - 1.
# ---------------------------------------------------------------------
SpeciesWaffelino:int = 1
SpeciesFrogurko:int = 2
SpeciesIdrantoro:int = 3
SpeciesTagliatakel:int = 4
SpeciesDiskolama:int = 5
SpeciesRazzopingu:int = 6
SpeciesWolkowal:int = 7
SpeciesBzzkoffro:int = 8
SpeciesPaketeulo:int = 9
SpeciesBassotto:int = 10
SpeciesCountR1:int = 8
SpeciesCountAll:int = 10

SpeciesName:[]string = array{"Waffelino", "Frogurko", "Idrantoro", "Tagliatakel", "Diskolama",
                             "Razzopingu", "Wolkowal", "Bzzkoffro", "Paketeulo", "Bassotto"}
# Silben Präfix / Mitte / Suffix (identisch zu catalog_gen.py SPECIES[..][6])
SyllablePrefix:[]string = array{"Waf", "Fro", "Idra", "Tagli", "Dis", "Raz", "Wol", "Bzz", "Pake", "Bas"}
SyllableMid:[]string = array{"waffe", "gurk", "dranto", "glia", "disko", "razzo", "wolko", "koff", "paket", "basso"}
SyllableSuffix:[]string = array{"lino", "urko", "oro", "takel", "lama", "pingu", "wal", "offro", "eulo", "otto"}

# Faktoren Einkommen / ATK / HP / Tempo (GDD §4.4, letzte Spalte)
SpeciesIncomeFactor:[]float = array{1.2, 1.0, 0.85, 1.0, 0.9, 0.95, 1.05, 1.1, 1.05, 1.0}
SpeciesAtkFactor:[]float = array{0.9, 0.8, 0.7, 0.75, 0.6, 1.3, 1.0, 0.8, 0.9, 0.95}
SpeciesHpFactor:[]float = array{1.0, 1.1, 1.6, 1.0, 1.0, 0.8, 1.1, 1.0, 1.2, 1.0}
SpeciesSpeedFactor:[]float = array{1.0, 1.2, 0.8, 1.4, 1.0, 0.9, 0.7, 1.1, 0.9, 1.25}

# Teil-Slots
ftb_slot := enum{Head, Body, Accessory}

# ---------------------------------------------------------------------
# Kreatur (Laufzeit-Darstellung). Persistiert wird sie GEPACKT als int
# (siehe ftb_save.verse PackCreature/UnpackCreature), damit das Save-
# Schema nach dem Publish nie an einem Struct hängt.
# struct mit Defaults: VERIFIED (Verse-Sprache)
# ---------------------------------------------------------------------
ftb_creature := struct:
    Head:int = 1       # Art-ID des Kopfes (Skill)
    Body:int = 1       # Art-ID des Körpers (Profil, Animation)
    Acc:int = 1        # Art-ID des Accessoires (Trait)
    Rarity:int = 0     # 0..6
    Level:int = 1      # 1..150
    Gen:int = 0        # 0..10
    Form:int = 0       # 0 = Standard; 1 Gründer, 2 Frosti, 3 Paket, 4 Funki, 5 Schleimi, 6 Bass, 7 Kosmi, 8 Festi, 9 Sternen (IIT); 10..31 frei (Bauplan §4.2)
    Flags:int = 0      # Bit 0 = Neben-Trait aktiv, Bit 1 = Team fixiert, Bit 2 = Geheim-Rezept, Bit 3 = IIT-Kreatur
    SideAcc:int = 0    # Art-ID des Neben-Traits (50 % Stärke, ab Gen 5 / Spiegel-Fusion), 0 = keiner

IsPure(C:ftb_creature)<decides><transacts>:void =
    C.Head = C.Body
    C.Body = C.Acc

# ---------------------------------------------------------------------
# Wirtschafts-Parameter (GDD §5.8 "Endgültige Parametertabelle").
# Änderungen IMMER zuerst in economy_sim.py simulieren.
# ---------------------------------------------------------------------
IncomeBase:[]float = array{1.0, 4.0, 16.0, 70.0, 320.0, 1500.0, 7500.0}
PowerBase:[]float = array{10.0, 40.0, 160.0, 700.0, 3200.0, 15000.0, 75000.0}
LevelMult:float = 1.15
LevelCostFactor:float = 20.0
LevelCostGrowth:float = 1.21
LevelCapBase:int = 25
LevelCapPerRebirth:int = 5
LevelCapMax:int = 150
GenBonus:float = 0.08
GenCap:int = 10
BroodSlotsBase:int = 1
StallCapBase:int = 30
StallCapIIT:int = 50
PadsStart:int = 2
PadsMax:int = 6
PadCosts:[]float = array{150.0, 3000.0, 60000.0, 1200000.0}
TotemBase:float = 500.0
TotemGrowth:float = 1.55
TotemBonus:float = 0.1
FusionUnlockWave:int = 5
FusionCoinSeconds:float = 120.0
FusionKerne:[]int = array{3, 6, 12, 25, 50, 100, 100}
FusionTimeSeconds:[]float = array{20.0, 45.0, 90.0, 180.0, 360.0, 600.0, 600.0}
ResonanceChance:float = 0.2
ResonancePity:int = 5
SecretRecipeRebirth:int = 10
WaveBase:float = 22.0
WaveGrowth:float = 1.13
WavePoly:float = 15.0
WaveFightSeconds:float = 25.0
WaveFirstIncomeSeconds:float = 45.0
WaveFirstFlat:float = 20.0
WaveFlatGrowth:float = 1.12
WaveReplayIncomeSeconds:float = 15.0
WaveLostIncomeSeconds:float = 10.0
WaveFirstKerneBase:int = 2
WaveReplayKerne:int = 1
BossPeriodSeconds:float = 420.0
BossOffsetSeconds:float = 200.0
BossUnlockSeconds:float = 480.0
BossDurationSeconds:float = 75.0
BossIncomeSeconds:float = 90.0
BossKerneBase:int = 10
BossKerneMax:int = 30
ReleaseKerne:[]int = array{1, 1, 2, 3, 5, 8, 12}
RebirthBase:float = 300000000.0
RebirthGrowth:float = 4.25
RebirthWaveReq:int = 20
RebirthWaveStep:int = 10
RebirthMult:float = 1.45
RebirthKeepBase:int = 1
RebirthKeepMax:int = 6
IndexBonusPerEntry:float = 0.004
IndexBonusCap:float = 1.0
# IIT-Deckel (GDD §5.5 Punkt 8): Münz-Magnet +100 %, Münz-Rausch +50 %, gesamt max ×2,5
IITCoinMagnetBonus:float = 1.0
IITCoinRushBonus:float = 0.5
IITCoinMultCap:float = 2.5
# Dös-Regel (GDD §8): nach 300 s ohne Eingabe Einkommen ×0,25
IdleAfterSeconds:float = 300.0
IdleIncomeMult:float = 0.25

# Ei-Stufen (GDD §4.3): Preis, Brutzeit, ab Rebirth
EggPrice:[]float = array{20.0, 350.0, 7500.0, 400000.0, 3000000000.0, 5000000000000.0, 20000000000000000.0, 100000000000000000000000.0}
EggHatchSeconds:[]float = array{3.0, 5.0, 8.0, 12.0, 18.0, 25.0, 30.0, 30.0}
EggRebirthReq:[]int = array{0, 0, 0, 0, 2, 5, 9, 14}
EggPityCount:int = 50

# ---------------------------------------------------------------------
# Zeit-Job (Brutplatz oder Fusions-Slot). EndsAt in Simulationszeit
# (GetSimulationElapsedTime, VERIFIED). Payload: Ei-Stufe bzw. gepacktes Ergebnis.
# ---------------------------------------------------------------------
ftb_timer_job := struct:
    Payload:int = 0
    EndsAt:float = 0.0

# ---------------------------------------------------------------------
# Sitzungs-Zustand je Spieler (NICHT persistable, darf var-Felder haben).
# Das ist die Laufzeit-Wahrheit; ftb_save.verse spiegelt sie in die
# weak_map (BuildSave / ApplySave).
# ---------------------------------------------------------------------
ftb_player_state := class:
    Agent:player
    var PlotIndex:int = -1
    var Coins:float = 0.0
    var Kerne:int = 0
    var Tokens:[]int = array{0, 0, 0, 0, 0, 0, 0, 0}
    var Rebirths:int = 0
    var Totem:int = 0
    var Pads:int = 2
    var BestWave:int = 0
    var Creatures:[]ftb_creature = array{}
    var PadSlots:[]int = array{-1, -1, -1, -1, -1, -1}
    var Brood:[]ftb_timer_job = array{}
    var Fusing:[]ftb_timer_job = array{}
    var IndexBits:[]int = array{}
    var BaseIdx:[]int = array{}
    var EventIdx:[]int = array{}
    var SecretIdx:int = 0
    var EggPity:[]int = array{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
    var ResPity:int = 0
    var DailyDay:int = 0
    var Streak:int = 0
    var LastDay:int = -1
    var StreakShieldWeek:int = -1
    var SessionsOK:int = 0
    var CodesClaimed:int = 0
    var EventClaims:[]int = array{0, 0, 0, 0, 0, 0, 0, 0}
    var IITMirror:int = 0
    var IITPendingConsume:int = 0
    var CoinRushSeconds:float = 0.0
    var Settings:int = 0
    var Stats:[]int = array{0, 0, 0, 0, 0, 0, 0, 0}
    var LastSeenEpoch:float = 0.0
    var PlaySeconds:float = 0.0
    var LastSessionActiveSec:float = 0.0
    # --- nur Sitzung, wird nicht gespeichert ---
    var SessionActiveSec:float = 0.0
    var LastInputAt:float = 0.0
    var PendingPurchase:logic = false
    var HypeMult:float = 1.0
    var CheerKerneSession:int = 0
    var HeartsGivenSession:int = 0
    var AutoWavesLeft:int = 0
    var Dirty:logic = false
