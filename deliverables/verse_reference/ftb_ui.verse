# =====================================================================
# REFERENZ — UNGEPRÜFT bis in UEFN kompiliert
# Datei: ftb_ui.verse  (FUSE THE BRAINROT)
# Zweck: Verse-UI (ohne UMG) für HUD S0, Toast-Queue S0/S16, Fusions-
#        Screen S5 und Reveal S2/S6 über Widget-Updates (GDD §10).
#        Für gestylte/animierte Endfassung: UMG + Verse Fields (VERIFIED
#        seit v38.00) – diese Datei ist der robuste Minimal-Pfad.
# API-Status:
#   canvas, canvas_slot, stack_box, overlay, texture_block (Temporary/UI),
#   text_block, button_loud/button_quiet (Fortnite.com/UI): VERIFIED (API-Seiten)
#   GetPlayerUI[], AddWidget(W, player_ui_slot{InputMode := ui_input_mode.All}): VERIFIED
#   RemoveWidget, SetText, SetVisibility, OnClick(): LIKELY
#   MakeColorFromHex (/Verse.org/Colors), text_block.SetTextColor: UNVERIFIED
# Controller/Touch (GDD §10.1):
#   - HUD bleibt NICHT interaktiv (InputMode None) -> Bewegung nie blockiert.
#   - Panels mit InputMode All; Fokus-Navigation per Steuerkreuz ist
#     UNVERIFIED für Verse-UI -> große Buttons (≥ 12 % H), wenig Buttons je Screen,
#     B/○ schließt nur, wenn die Engine das an Verse-UI weiterreicht (testen W8).
#   - Untere Ecken (30 % B × 35 % H) frei lassen: Joystick/Feuer/Sprung auf Touch.
#   - Safe Zone: Anker in 0..1 relativ, keine festen Pixel am Rand.
# =====================================================================

using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }  # vector2
using { /Fortnite.com/UI }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }

ToMsg<localizes>(S:string):message = "{S}"

HexColor(Hex:string):color = MakeColorFromHex(Hex)   # UNVERIFIED -> Fallback NamedColors.White

# Anker-Hilfe: x/y/B/H in Safe-Zone-Prozent (GDD-Wireframes) -> canvas_slot
PctSlot(W:widget, X:float, Y:float, Wd:float, Ht:float):canvas_slot =
    canvas_slot:
        Anchors := anchors{Minimum := vector2{X := X / 100.0, Y := Y / 100.0},
                           Maximum := vector2{X := (X + Wd) / 100.0, Y := (Y + Ht) / 100.0}}
        Offsets := margin{Left := 0.0, Top := 0.0, Right := 0.0, Bottom := 0.0}
        Alignment := vector2{X := 0.0, Y := 0.0}
        SizeToContent := false
        Widget := W

# Callback-Schnittstelle, implementiert vom ftb_game_manager.
ftb_ui_events := interface:
    OnFuseRequested(P:player, SlotA:int, SlotB:int, Ch:fusion_choice):void
    OnPanelClosed(P:player):void

# ------------------------------- HUD ----------------------------------
ftb_hud := class:
    Agent:player
    CoinsText:text_block = text_block{DefaultText := ToMsg("0")}
    IncomeText:text_block = text_block{DefaultText := ToMsg("+0/s")}
    KerneText:text_block = text_block{DefaultText := ToMsg("◆ 0")}
    TokenText:text_block = text_block{DefaultText := ToMsg("")}
    BossPill:text_block = text_block{DefaultText := ToMsg("")}
    GoalText:text_block = text_block{DefaultText := ToMsg("")}
    ToastLines:[]text_block = array{text_block{}, text_block{}, text_block{}}
    var Toasts:[]string = array{}
    var Built:logic = false
    var ShownCoins:float = 0.0
    var TargetCoins:float = 0.0
    var IncomePerSec:float = 0.0

    Build():void =
        if (Built?):
            return
        if (UI := GetPlayerUI[Agent]):
            Root := canvas:
                Slots := array{
                    PctSlot(CoinsText, 2.0, 2.0, 24.0, 5.0),
                    PctSlot(IncomeText, 2.0, 7.0, 24.0, 3.0),
                    PctSlot(KerneText, 2.0, 10.0, 16.0, 5.0),
                    PctSlot(TokenText, 2.0, 16.0, 16.0, 5.0),
                    PctSlot(BossPill, 38.0, 2.0, 24.0, 6.0),
                    PctSlot(GoalText, 74.0, 2.0, 24.0, 12.0)}
            ToastBox := stack_box:
                Orientation := orientation.Vertical
                Slots := for (T : ToastLines) { stack_box_slot{Widget := T, HorizontalAlignment := horizontal_alignment.Center} }
            UI.AddWidget(Root, player_ui_slot{InputMode := ui_input_mode.None})
            UI.AddWidget(canvas{Slots := array{PctSlot(ToastBox, 30.0, 10.0, 40.0, 18.0)}}, player_ui_slot{InputMode := ui_input_mode.None})
            CoinsText.SetTextColor(HexColor("FFC93C"))
            KerneText.SetTextColor(HexColor("3EF2D6"))
            TokenText.SetTextColor(HexColor("FF7AE0"))
            set Built = true

    # Server schickt 1 Hz; RunTicker interpoliert mit 10 Hz (GDD §5.4).
    SetCurrencies(Coins:float, IncPS:float, Kerne:int, Tokens:int, EventActive:logic):void =
        set TargetCoins = Coins
        set IncomePerSec = IncPS
        IncomeText.SetText(ToMsg("+{FormatBig(IncPS)}/s"))
        KerneText.SetText(ToMsg("◆ {Kerne}"))
        TokenText.SetText(ToMsg(if (EventActive?) then "✿ {Tokens}" else ""))

    RunTicker()<suspends>:void =
        loop:
            Sleep(0.1)
            # weich hinlaufen; bei großem Sprung (≥ 10 %) direkt setzen (Pop, GDD §13)
            if (TargetCoins > ShownCoins * 1.1 or TargetCoins < ShownCoins):
                set ShownCoins = TargetCoins
            else:
                set ShownCoins = Min(TargetCoins, ShownCoins + IncomePerSec * 0.1)
            CoinsText.SetText(ToMsg(FormatBig(ShownCoins)))

    SetBossPill(Text:string):void = BossPill.SetText(ToMsg(Text))
    SetGoal(Text:string):void = GoalText.SetText(ToMsg(Text))

    # Toast-Queue: max. 3 sichtbar, je 2,5 s (GDD §10.3 S0)
    PushToast(Text:string):void =
        set Toasts += array{Text}
        RefreshToasts()

    RefreshToasts():void =
        for (I -> Line : ToastLines):
            Line.SetText(ToMsg(if (T := Toasts[I]) then T else ""))

    RunToastQueue()<suspends>:void =
        loop:
            Sleep(2.5)
            if (Toasts.Length > 0, Rest := Toasts.Slice[1]):
                set Toasts = Rest
                RefreshToasts()

# --------------------------- Fusions-Screen (S5) ----------------------
ftb_fusion_screen := class:
    Agent:player
    Events:ftb_ui_events
    var Open:?canvas = false
    var SlotA:int = -1
    var SlotB:int = -1
    var Choice:fusion_choice = fusion_choice{}
    PreviewText:text_block = text_block{}
    BtnHead:button_loud = button_loud{DefaultText := ToMsg("Kopf: A")}
    BtnBody:button_loud = button_loud{DefaultText := ToMsg("Körper: A")}
    BtnAcc:button_loud = button_loud{DefaultText := ToMsg("Accessoire: A")}
    BtnFuse:button_loud = button_loud{DefaultText := ToMsg("FUSIONIEREN")}
    BtnClose:button_quiet = button_quiet{DefaultText := ToMsg("X")}
    var Subscribed:logic = false
    var CurState:?ftb_player_state = false
    var CurResChance:float = 0.2

    Show(S:ftb_player_state, A:int, B:int, ResChance:float):void =
        set SlotA = A
        set SlotB = B
        set CurState = option{S}
        set CurResChance = ResChance
        if (not Subscribed?):
            BtnHead.OnClick().Subscribe(OnHead)
            BtnBody.OnClick().Subscribe(OnBody)
            BtnAcc.OnClick().Subscribe(OnAcc)
            BtnFuse.OnClick().Subscribe(OnFuse)
            BtnClose.OnClick().Subscribe(OnClose)
            set Subscribed = true
        if (CA := S.Creatures[A], CB := S.Creatures[B]):
            set Choice = SuggestChoice(CA, CB, true)
        Refresh(S, ResChance)
        if (UI := GetPlayerUI[Agent], not Open?):
            Parts := stack_box:
                Orientation := orientation.Vertical
                Slots := array{stack_box_slot{Widget := BtnHead}, stack_box_slot{Widget := BtnBody},
                               stack_box_slot{Widget := BtnAcc}, stack_box_slot{Widget := PreviewText},
                               stack_box_slot{Widget := BtnFuse}}
            Root := canvas{Slots := array{PctSlot(Parts, 35.0, 12.0, 30.0, 70.0), PctSlot(BtnClose, 88.0, 8.0, 6.0, 10.0)}}
            UI.AddWidget(Root, player_ui_slot{InputMode := ui_input_mode.All})
            set Open = option{Root}

    Refresh(S:ftb_player_state, ResChance:float):void =
        BtnHead.SetText(ToMsg(if (Choice.HeadFromA?) then "Kopf: A" else "Kopf: B"))
        BtnBody.SetText(ToMsg(if (Choice.BodyFromA?) then "Körper: A" else "Körper: B"))
        BtnAcc.SetText(ToMsg(if (Choice.AccFromA?) then "Accessoire: A" else "Accessoire: B"))
        if (CA := S.Creatures[SlotA], CB := S.Creatures[SlotB]):
            P := BuildFusionPreview(S, CA, CB, Choice, ResChance)
            Pct := if (R := Round[P.ResonanceChance * 100.0]) then R else 0
            Res := if (P.ResonanceChance > 0.0) then "{Pct} % Resonanz -> Stufe {P.ResonanceTarget} ({S.ResPity}/{ResonancePity})" else ""
            Neu := if (P.IsNewInIndex?) then "  INDEX: NEU!" else ""
            PreviewText.SetText(ToMsg("{P.Name}{Neu}\n{Res}\n{FormatBig(P.CoinCost)} Münzen + {P.KerneCost} Kerne · {P.DurationSeconds} s"))

    # Button-Handler: widget_message trägt den Spieler (LIKELY Feldname .Player)
    OnHead(M:widget_message):void =
        set Choice = fusion_choice{HeadFromA := Flip(Choice.HeadFromA), BodyFromA := Choice.BodyFromA, AccFromA := Choice.AccFromA}
        RefreshCurrent()
    OnBody(M:widget_message):void =
        set Choice = fusion_choice{HeadFromA := Choice.HeadFromA, BodyFromA := Flip(Choice.BodyFromA), AccFromA := Choice.AccFromA}
        RefreshCurrent()
    OnAcc(M:widget_message):void =
        set Choice = fusion_choice{HeadFromA := Choice.HeadFromA, BodyFromA := Choice.BodyFromA, AccFromA := Flip(Choice.AccFromA)}
        RefreshCurrent()
    RefreshCurrent():void =
        if (S := CurState?):
            Refresh(S, CurResChance)
    OnFuse(M:widget_message):void =
        Events.OnFuseRequested(Agent, SlotA, SlotB, Choice)
        Close()
    OnClose(M:widget_message):void = Close()

    Close():void =
        if (UI := GetPlayerUI[Agent], Root := Open?):
            UI.RemoveWidget(Root)
        set Open = false
        Events.OnPanelClosed(Agent)

# --------------------------- Reveal (S2 / S6) -------------------------
# Keine Widget-Animationen in Verse-UI -> Animation über zeitgesteuerte
# Text-/Farbwechsel. Silben erscheinen einzeln (je 180 ms, GDD §4.7/§13).
PlayReveal(Agent:player, C:ftb_creature, IsFusion:logic)<suspends>:void =
    if (UI := GetPlayerUI[Agent]):
        Title := text_block{DefaultText := ToMsg("")}
        Sub := text_block{DefaultText := ToMsg("")}
        Box := stack_box{Orientation := orientation.Vertical,
                         Slots := array{stack_box_slot{Widget := Title}, stack_box_slot{Widget := Sub}}}
        Root := canvas{Slots := array{PctSlot(Box, 20.0, 55.0, 60.0, 20.0)}}
        UI.AddWidget(Root, player_ui_slot{InputMode := ui_input_mode.None})
        Hex := if (H := RarityHex[C.Rarity]) then H else "FFFFFF"
        # 1) "Risse": Punkte zählen hoch, Farbe blinkt Weiß/Seltenheit
        Steps := 3 + C.Rarity
        for (I := 1..Steps):
            Title.SetTextColor(HexColor(if (Mod[I, 2] = 0) then Hex else "FFFFFF"))
            Title.SetText(ToMsg(if (IsFusion?) then "FUSION" else "EI"))
            Sleep(AtF(RevealSeconds, C.Rarity) / (1.0 * Steps))
        # 2) Name silbenweise zusammensetzen
        Syl := array{AtS(SyllablePrefix, C.Head - 1), AtS(SyllableMid, C.Body - 1), AtS(SyllableSuffix, C.Acc - 1)}
        var Shown:string = ""
        for (S : Syl):
            set Shown = if (Shown.Length = 0) then S else JoinSyllables(Shown, S)
            Title.SetText(ToMsg("{Shown}…"))
            Sleep(0.18)
        Title.SetTextColor(HexColor(Hex))
        Title.SetText(ToMsg(DisplayName(C)))
        RName := if (N := RarityNameDE[C.Rarity]) then N else ""
        Sym := if (Y := RaritySymbol[C.Rarity]) then Y else ""
        Sub.SetText(ToMsg("{Sym} {RName} · +{FormatBig(CreatureIncome(C))}/s"))
        Sleep(if (C.Rarity <= 1) then 1.5 else 3.0)
        UI.RemoveWidget(Root)

AtS(A:[]string, I:int):string = if (V := A[I]) then V else ""
Flip(L:logic):logic = if (L?) then false else true
