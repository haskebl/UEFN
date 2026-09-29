# UEFN Feasibility Reference: Brainrot Collection/Tycoon/Simulator Island (as of 2026-09-29)

> **Method note (read first):** Direct page fetches of dev.epicgames.com, thecreativeblok.com and verseisland.com were **blocked by the network egress proxy** in this research session. Claims below come from search-engine extracts of official Epic pages (dev.epicgames.com, fortnite.com, forums.unrealengine.com, legal.epicgames.com) plus a few secondary sources. Status legend:
> - **VERIFIED** = stated in an official Epic page/announcement extract (URL given).
> - **LIKELY** = stated by a secondary source, a forum thread, or an official extract that was ambiguous; or strong prior knowledge consistent with official page titles.
> - **UNVERIFIED** = could not be confirmed; do not build on it without checking in-editor or on the linked page.
> Before any build decision, open the linked official page yourself: exact numbers (for example the 128 KB and the two weak_map limit) can change between UEFN releases.

## Master feasibility table

| Mechanic | Device / API | Doc link | Status | Notes / limits | Workaround |
|---|---|---|---|---|---|
| Per-player save | `var X : weak_map(player, t) = map{}` at module scope, `t` = `<persistable>` class/struct | [Using Persistable Data](https://dev.epicgames.com/documentation/en-us/fortnite/using-persistable-data-in-verse) | VERIFIED | Saved per player and per island. Cannot be iterated. | — |
| Max number of player weak_maps | — | [Using Persistable Data](https://dev.epicgames.com/documentation/en-us/fortnite/using-persistable-data-in-verse) | VERIFIED (snippet: "up to two player weak map variables") | Only 2 per project | Put everything in one root `player_save` class that holds sub-structs |
| Size per player | `FitsInPlayerMap` | [Persistence Best Practices](https://dev.epicgames.com/documentation/fortnite/verse-persistence-best-practices) | LIKELY: 128 KB per weak_map per player | Forum report: `FitsInPlayerMap` is slow and can bottleneck the server ([forum](https://forums.unrealengine.com/t/fitsinplayermap-is-extermly-slow-and-a-potential-server-bottleneck/2625137)) | Store compact IDs (int) rather than strings. Call `FitsInPlayerMap` only on the growing collection path, not every tick |
| Schema migration | Add fields to a `<persistable>` **class** with defaults; `Version : int = 0` field | [Persistence Best Practices](https://dev.epicgames.com/documentation/fortnite/verse-persistence-best-practices) | VERIFIED | Only the class type may change after publish, and only by adding fields that have defaults. Epic recommends a version field. | Design the save schema before the first publish. Never remove or rename fields. |
| Leaderboards | Stat Creator device ("Use Persistence"), Verse leaderboard | [Stat Creator](https://dev.epicgames.com/documentation/fortnite/using-stat-creator-devices-in-fortnite-creative), [Verse leaderboard](https://dev.epicgames.com/documentation/fortnite/make-your-own-ingame-leaderboard-in-verse), [Persistent Player Statistics](https://dev.epicgames.com/documentation/en-us/fortnite/persistent-player-statistics-in-unreal-editor-for-fortnite) | VERIFIED (per-player persistence). No global cross-server leaderboard confirmed | The Verse leaderboard only ranks players in the current session | Show "server top" plus "your personal best" |
| Custom UI (UMG) | UMG User Widget + View Bindings + **Verse fields** (v38.00) | [UMG Widgets](https://dev.epicgames.com/documentation/en-us/fortnite/umg-widgets-in-unreal-editor-for-fortnite), [Verse fields in UMG tutorial](https://dev.epicgames.com/community/learning/tutorials/07ay/fortnite-using-verse-fields-in-a-umg-user-widget), [Verse Fields Examples](https://dev.epicgames.com/documentation/fortnite/verse-fields-examples-in-fortnite) | VERIFIED | v38.00 "adds Verse Fields in UMG" ([38.00 notes](https://dev.epicgames.com/documentation/fortnite/38-00-fortnite-ecosystem-updates-and-release-notes)); Custom Buttons in UMG with animations | — |
| Custom UI (Verse-only) | `/UnrealEngine.com/Temporary/UI`: `canvas`, `overlay`, `stack_box`, `texture_block`; `/Fortnite.com/UI`: `text_block`, `button_loud`/`button_quiet`/`button_regular`; `GetPlayerUI[Player].AddWidget(W, player_ui_slot{InputMode := ui_input_mode.All})` | [UI module](https://dev.epicgames.com/documentation/en-us/fortnite/verse-api/unrealenginedotcom/temporary/ui), [Creating UI with Verse](https://dev.epicgames.com/documentation/en-us/fortnite/creating-ui-with-verse-in-unreal-editor-for-fortnite), [Making Widgets Interactable](https://dev.epicgames.com/documentation/en-us/fortnite/making-widgets-interactable-in-unreal-editor-for-fortnite) | VERIFIED | Verse-only UI has no designer and no widget animations | Use UMG for styled or animated screens and Verse fields for data |
| Touch / mobile pointer | Virtual Pointer; de-projection APIs (left Experimental) | [42.00 notes](https://dev.epicgames.com/documentation/fortnite/42-00-fortnite-ecosystem-updates-and-release-notes) | VERIFIED | v42.00: Virtual Pointer usable in live games (tap and drag) | — |
| Controller focus, safe zones, DPI | — | — | UNVERIFIED | No official extract found | Test on console and mobile preview |
| Custom character as NPC | NPC Character Definition (type **Custom**) + NPC Spawner + `npc_behavior`; BP actor with Skeletal Mesh component + Animation Presets | [NPC Spawner with Animations](https://dev.epicgames.com/documentation/en-us/fortnite/using-the-npc-spawner-with-animations-in-unreal-editor-for-fortnite), [Animation Presets](https://dev.epicgames.com/documentation/en-us/uefn/animation-presets-in-unreal-editor-for-fortnite), [Community tutorial](https://forums.unrealengine.com/t/community-tutorial-uefn-tutorial-npc-with-custom-character-mesh/2316733) | VERIFIED (custom type exists); LIKELY biped/retarget focus | Known bug: IK-retargeted NPC blueprint instance spawns at 0,0,0 after Push Changes ([forum](https://forums.unrealengine.com/t/when-using-an-npc-spawner-with-a-ik-retargeted-skeletal-mesh-an-instance-of-the-blueprint-is-spawned-into-the-world/2081594)) | Non-humanoid brainrot creatures: use animated props / Scene Graph skeletal meshes instead of NPC AI |
| NPC control via Scene Graph | `npc_actions_component`, `guard_actions_component`, `npc_awareness_component`, `guard_awareness_component` (v39.00) | [thecreativeblok v39 summary](https://thecreativeblok.com/uefn-v39-00-update-in-island-transactions-publishing-date-mobile-preview-physics-tools/) | LIKELY (secondary source) | — | — |
| Animated custom meshes (non-NPC) | `mesh_component` referencing a skeletal mesh + `PlaySkeletalAnimation` (Scene Graph Animation flag); props: `play_animation_controller` (`GetPlayAnimationController()`, `Play()`, `PlayAndAwait()`) | [Skeletal Animation in Scene Graph](https://dev.epicgames.com/documentation/fortnite/skeletal-animation-in-scene-graph-in-fortnite), [play_animation_controller](https://dev.epicgames.com/documentation/en-us/fortnite/verse-api/fortnitedotcom/animation/playanimation/play_animation_controller), [Import and Play Mesh Animations](https://dev.epicgames.com/documentation/en-us/fortnite/import-and-play-mesh-animations-in-unreal-editor-for-fortnite) | VERIFIED | Forum bug: skeletal animations on entities or components added at runtime through Verse do not play ([forum](https://forums.unrealengine.com/t/playing-skeletal-animations-for-entities-components-added-through-verse-doesnt-work/2729153)) | Place prefabs in the level or spawn prefab assets; do not construct components at runtime |
| Character animations in Verse | "Play Character Animations in Verse" (2026 announcement) | [Forum announcement](https://forums.unrealengine.com/t/play-character-animations-in-verse/2731739) | LIKELY (details not read) | — | — |
| Animation Blueprints / anim graphs | — | — | UNVERIFIED (not found in extracts) | Assume no custom AnimBP logic | Use Animation Presets, Sequencer, or Verse-triggered anim sequences |
| Scene Graph | entities, components, prefabs; `mesh_component` | [Publish with Scene Graph (Beta)](https://www.fortnite.com/news/publish-fortnite-islands-created-with-scene-graph-now-in-beta) | VERIFIED: Beta and publishable since v36.00 | v38.00: entities are presented to all players by default; includes a Tycoon feature example using Scene Graph ([38.00](https://dev.epicgames.com/documentation/fortnite/38-00-fortnite-ecosystem-updates-and-release-notes)) | Start from the Scene Graph Tycoon example |
| Cinematics | Cinematic Sequence device (Visibility: Everyone / Instigator Only / Instigator's Team) | [Cinematic Sequence device](https://dev.epicgames.com/documentation/en-us/fortnite/using-cinematic-sequence-device-in-unreal-editor-for-fortnite) | VERIFIED (settings); issues LIKELY | Forums: "Instigator Only" plays for one instigator at a time and cannot run concurrently for different players ([1](https://forums.unrealengine.com/t/major-sequences-not-playing-at-the-same-time-for-different-instigators/1146439), [2](https://forums.unrealengine.com/t/cinematic-sequence-device-plays-only-for-one-player/2652437), [3](https://forums.unrealengine.com/t/cinematic-sequence-the-instigator-only-function-is-not-working/2743061)) | Build rarity reveals as UMG widget animations (per player) plus a per-plot reveal prop. Keep cinematics short, or use one device copy per plot |
| VFX | Niagara (custom systems in UEFN); `SpawnParticleSystem()`; Scene Graph particle system component | [Effects and Particle Systems](https://dev.epicgames.com/documentation/en-us/fortnite/effects-and-particle-systems-in-unreal-editor-for-fortnite), [Particle System Component](https://dev.epicgames.com/documentation/en-us/fortnite/particle-system-component-in-unreal-editor-for-fortnite) | VERIFIED | — | — |
| Audio import | WAV import; Audio Player device (`audio_player_device`, `Register`/`Unregister` agent targets) | [Import Custom Audio](https://dev.epicgames.com/documentation/en-us/fortnite/import-custom-audio-in-unreal-editor-for-fortnite), [audio_player_device](https://dev.epicgames.com/documentation/en-us/fortnite/verse-api/fortnitedotcom/devices/audio_player_device) | VERIFIED (WAV; Register/Unregister) | Convert to .WAV. OGG import not confirmed. | Per-player sound: `Register(Agent)` then `Play` on a device set to play for registered agents (LIKELY) |
| MetaSounds | MetaSound Presets only | [MetaSounds in UEFN](https://dev.epicgames.com/documentation/en-us/fortnite/metasounds-in-uefn) | VERIFIED | Cannot add own nodes or edit the exposed graph; 2 exposed MetaSound sources for presets | — |
| Patchwork | Patchwork devices | [Patchwork Speaker](https://dev.epicgames.com/documentation/fortnite/using-patchwork-speaker-devices-in-fortnite-creative) | VERIFIED (exists) | — | — |
| Memory budget | Memory Calculation (Project > Launch Memory Calculation); Window > Message Log > Memory Test Results (top 100 assets) | [Memory Management](https://dev.epicgames.com/documentation/en-us/fortnite/memory-management-in-unreal-editor-for-fortnite), [Project Size Tool](https://dev.epicgames.com/documentation/en-us/fortnite/project-size-tool-in-unreal-editor-for-fortnite) | VERIFIED: 100,000 memory units max | Edit-time only; not runtime. Devices, custom landscapes and custom assets stay resident regardless of player position. Nanite "Keep Triangle Percent" reduces the footprint | Reuse one skeleton and texture atlases across creatures |
| Runtime profiling | Timing Insights (v42.00) | [42.00 notes](https://dev.epicgames.com/documentation/fortnite/42-00-fortnite-ecosystem-updates-and-release-notes) | VERIFIED | — | — |
| Max players | Island Settings > Max Players | [Island Settings](https://dev.epicgames.com/documentation/en-us/fortnite/island-settings-in-unreal-editor-for-fortnite) | VERIFIED: 1–100 | Tycoons usually run 8–16 for plot count and server load (design choice, not a limit) | — |
| In-island purchases | `/Fortnite.com/Marketplace` (module name LIKELY); `entitlement` (fields incl. `Consumable`, `MaxCount`), entitlement offer, bundle offer; `BuyOffer`, `OnPurchasesChanged`, `GetPurchasedEntitlements`, `ConsumeEntitlement`, `ShowOffersDialog`, `GetMinPurchaseAge` | [IIT Overview](https://dev.epicgames.com/documentation/fortnite/in-island-transactions-overview-in-fortnite), [Creating Items and Offers](https://dev.epicgames.com/documentation/fortnite/creating-items-and-offers-in-fortnite), [Device Template](https://dev.epicgames.com/documentation/fortnite/inisland-transactions-device-template-in-fortnite), [Best Practices and Debugging](https://dev.epicgames.com/documentation/en-us/fortnite/in-island-transactions-best-practices-and-debugging-in-fortnite), [Restrictions](https://dev.epicgames.com/documentation/fortnite/in-island-transactions-restrictions-in-fortnite), [Monetization Guidelines](https://dev.epicgames.com/documentation/fortnite/guidelines-for-in-island-monetization-in-fortnite) | VERIFIED (function names from extracts); exact signatures UNVERIFIED | `MaxCount` must be 1 when `Consumable=false`; `MaxCount` ≤ 10,000,000 | Copy the official device template verbatim |
| AI / editor automation | Unreal MCP in UEFN (v42.00, Windows); Python Editor Scripting (beta, access by request) | [42.00 notes](https://dev.epicgames.com/documentation/fortnite/42-00-fortnite-ecosystem-updates-and-release-notes), [Python Tools in UEFN](https://dev.epicgames.com/documentation/fortnite/python-tools-in-uefn) | VERIFIED (MCP); LIKELY (Python beta gating, from forum access requests) | — | Community MCP servers exist (for example [CharonCodenix/uefn-mcp](https://github.com/CharonCodenix/uefn-mcp)) but are unofficial |

---

## 1. Persistence

### Takeaway
Verse persistence (`weak_map(player, t)` with `<persistable>` types) is production-ready and suits a collection or tycoon save. Each project gets only **two** player weak_maps, with about **128 KB per player each** (LIKELY). The schema can only grow by adding defaulted fields to a persistable class, so the save design must be frozen before the first publish.

### Cited Findings
- Persistable data must be stored in a `weak_map`, which cannot be iterated. It is saved per player and per island and stays the same between sessions. VERIFIED — [Using Persistable Data in Verse](https://dev.epicgames.com/documentation/en-us/fortnite/using-persistable-data-in-verse)
- "Currently, a project can only have up to two player weak map variables." VERIFIED — [Using Persistable Data in Verse](https://dev.epicgames.com/documentation/en-us/fortnite/using-persistable-data-in-verse)
- There is a size limit per player and per island. Epic recommends checking the size of updates with `FitsInPlayerMap`. VERIFIED — [Using Persistable Data in Verse](https://dev.epicgames.com/documentation/en-us/fortnite/using-persistable-data-in-verse)
- The limit is reported as 128 KB for each of the two weak_maps. LIKELY: the search-engine extract attributed this to the Best Practices page, but I could not read the page directly — [Verse Persistence Best Practices](https://dev.epicgames.com/documentation/fortnite/verse-persistence-best-practices)
- The only persistable type you can change after publishing is a **class**, and only by adding new fields that have default values. Old saves then load with the defaults. VERIFIED — [Verse Persistence Best Practices](https://dev.epicgames.com/documentation/fortnite/verse-persistence-best-practices)
- Epic recommends a `Version : int = 0` field, or option-typed references to current and past data versions, so migrations can be detected. VERIFIED — [Verse Persistence Best Practices](https://dev.epicgames.com/documentation/fortnite/verse-persistence-best-practices); [Persistent Player Statistics](https://dev.epicgames.com/documentation/en-us/fortnite/persistent-player-statistics-in-unreal-editor-for-fortnite)
- Community report: `FitsInPlayerMap` is extremely slow and can become a server bottleneck. LIKELY — [forum](https://forums.unrealengine.com/t/fitsinplayermap-is-extermly-slow-and-a-potential-server-bottleneck/2625137)
- Community report: initializing a persistable class field with a constant can cause a linker error. LIKELY — [forum](https://forums.unrealengine.com/t/initializing-a-persistable-class-field-with-a-constant-leads-to-linker-error/2648608)
- Persistable type rules are documented in the Verse language book. — [Book of Verse: Persistable](https://verselang.github.io/book/17_persistable/)
- The Stat Creator device has a "Use Persistence" option. VERIFIED — [Stat Creator](https://dev.epicgames.com/documentation/fortnite/using-stat-creator-devices-in-fortnite-creative)

### Inferences
- Use one root class, for example `brainrot_save<persistable>` containing `Version`, `Cash : int`, `Rebirths : int`, `OwnedUnits : []unit_rec` (a struct of int IDs, level and count) and `LastSeen : float`. Keep the second weak_map free for a future migration or a split.
- 128 KB fits several thousand small int-based records. Avoid strings and nested arrays of classes.
- Anti-dupe: the server is authoritative and Verse runs on the server, so write-through on each state change is enough. Never grant twice on the same event: use a per-player "pending purchase" flag and reconcile against `GetPurchasedEntitlements` on join.
- Private and playtest sessions likely have save data separate from the live version. UNVERIFIED — test before relying on it.

### Gaps
- The exact 128 KB figure and whether it is per map or combined could not be read on the official page.
- Behaviour of saves across private and public versions, and any Scene Graph-specific persistence changes, were not found.
- Whether the two-map limit was raised in v40–v42 is unknown.

## 2. Custom UI

### Takeaway
Both paths work. UMG widgets with View Bindings and **Verse fields** (added in v38.00) are now the preferred route for styled or animated UI, while Verse-only widgets (`canvas`, `stack_box`, `overlay`, `text_block`, `texture_block`, `button_*`) suit simple dynamic HUDs. v42.00 improved mobile touch with the Virtual Pointer.

### Cited Findings
- v38.00 "adds Verse Fields in UMG". VERIFIED — [38.00 Release Notes](https://dev.epicgames.com/documentation/fortnite/38-00-fortnite-ecosystem-updates-and-release-notes)
- The Epic tutorial drives UMG User Widgets using View Bindings, Verse and Verse fields; a second tutorial covers Verse field **events**. VERIFIED — [Verse fields in UMG](https://dev.epicgames.com/community/learning/tutorials/07ay/fortnite-using-verse-fields-in-a-umg-user-widget); [Verse fields events](https://dev.epicgames.com/community/learning/tutorials/woOK/fortnite-using-verse-fields-events-in-a-umg-user-widget)
- Custom Button widgets in UMG can build a dynamic menu with animations, opened and closed through Verse fields. VERIFIED — [Custom Buttons](https://dev.epicgames.com/documentation/fortnite/custom-buttons-in-fortnite)
- Interactive widgets are added with `AddWidget()` and `player_ui_slot{InputMode := ui_input_mode.All}`. VERIFIED — [Making Widgets Interactable](https://dev.epicgames.com/documentation/en-us/fortnite/making-widgets-interactable-in-unreal-editor-for-fortnite); [AddWidget API](https://dev.epicgames.com/documentation/en-us/uefn/verse-api/unrealenginedotcom/temporary/ui/player_ui/addwidget-1)
- The Verse UI classes `canvas`, `texture_block`, `text_block` and `button_loud` have API pages. VERIFIED — [canvas](https://dev.epicgames.com/documentation/en-us/fortnite/verse-api/unrealenginedotcom/temporary/ui/canvas), [texture_block](https://dev.epicgames.com/documentation/en-us/fortnite/verse-api/unrealenginedotcom/temporary/ui/texture_block), [text_block](https://dev.epicgames.com/documentation/en-us/fortnite/verse-api/fortnitedotcom/ui/text_block), [button_loud](https://dev.epicgames.com/documentation/fortnite/verse-api/fortnitedotcom/ui/button_loud); [Widget Types](https://dev.epicgames.com/documentation/en-us/fortnite/widget-types-in-unreal-editor-for-fortnite)
- v42.00: the Virtual Pointer can be integrated into live games, enabling tap and drag on mobile, and the de-projection APIs exited Experimental. VERIFIED — [42.00 Release Notes](https://dev.epicgames.com/documentation/fortnite/42-00-fortnite-ecosystem-updates-and-release-notes)

### Inferences
- Rarity reveal, shop and index screens: build them in UMG with widget animations and bind data through Verse fields.
- Use Verse-only UI for quick text (for example a cash counter) if UMG binding proves heavy.
- The HUD Message and Popup Dialog devices remain fallbacks (LIKELY; not re-verified this session).

### Gaps
- Controller focus navigation, safe-zone handling and DPI scaling rules were not found in official extracts.
- The exact Verse-field type support list in UMG (for example arrays and textures) is unknown.

## 3. Custom characters and animation

### Takeaway
Custom skeletal meshes are supported. They can be NPCs through NPC Character Definition (type **Custom**) with a Blueprint that holds a Skeletal Mesh component plus Animation Presets, mainly for bipeds retargeted from the Fortnite or Manny skeleton. Non-humanoid "brainrot" creatures are safest as Scene Graph skeletal `mesh_component`s or props driven by `PlaySkeletalAnimation` or `play_animation_controller`.

### Cited Findings
- To make a custom NPC: in the Content Browser choose Artificial Intelligence > NPC Character Definition and set the character type to **Custom**. Add a Skeletal Mesh component to an Actor Blueprint, which the Animation Preset requires. VERIFIED / LIKELY — [NPC Spawner with Animations](https://dev.epicgames.com/documentation/en-us/fortnite/using-the-npc-spawner-with-animations-in-unreal-editor-for-fortnite); [Community tutorial](https://forums.unrealengine.com/t/community-tutorial-uefn-tutorial-npc-with-custom-character-mesh/2316733)
- To animate Fortnite characters with Animation Presets, use the FN_Mannequin mesh from the Animation 101 template and retarget. VERIFIED — [Animation Presets](https://dev.epicgames.com/documentation/en-us/uefn/animation-presets-in-unreal-editor-for-fortnite); [Animation 101 Template](https://dev.epicgames.com/documentation/fortnite/animation-101-template-in-unreal-editor-for-fortnite)
- `PlaySkeletalAnimation` requires an entity whose `mesh_component` references a **skeletal** mesh. With the Scene Graph Animation flag on, every animation asset is exposed to Verse as a subclass of `skeletal_animation`. VERIFIED — [Skeletal Animation in Scene Graph](https://dev.epicgames.com/documentation/fortnite/skeletal-animation-in-scene-graph-in-fortnite)
- Every Creative prop has a `play_animation_controller` (`GetPlayAnimationController()`, `Play()`, `PlayAndAwait()`). Animations move more smoothly than per-tick `MoveTo` or `TeleportTo`. VERIFIED — [play_animation_controller](https://dev.epicgames.com/documentation/en-us/fortnite/verse-api/fortnitedotcom/animation/playanimation/play_animation_controller); [Animating Prop Movement 2](https://dev.epicgames.com/documentation/en-us/fortnite/animating-prop-movement-2-moving-props-with-animations-in-verse)
- The 2026 announcement "Play Character Animations in Verse" exists. LIKELY — [forum](https://forums.unrealengine.com/t/play-character-animations-in-verse/2731739); [FNCreate on X](https://x.com/FNCreate/article/2070613870914474016)
- Scene Graph has been Beta and publishable since v36.00. VERIFIED — [fortnite.com news](https://www.fortnite.com/news/publish-fortnite-islands-created-with-scene-graph-now-in-beta). v38.00 adds a Tycoon feature example that uses Scene Graph, and entities are now presented to all players by default. VERIFIED — [38.00](https://dev.epicgames.com/documentation/fortnite/38-00-fortnite-ecosystem-updates-and-release-notes)
- v39.00 moves NPC control into Scene Graph components (`npc_actions_component`, `guard_actions_component`, `npc_awareness_component`, `guard_awareness_component`). LIKELY — [thecreativeblok](https://thecreativeblok.com/uefn-v39-00-update-in-island-transactions-publishing-date-mobile-preview-physics-tools/)
- Bugs: an IK-retargeted NPC spawns a stray blueprint at 0,0,0 after Push Changes ([forum](https://forums.unrealengine.com/t/when-using-an-npc-spawner-with-a-ik-retargeted-skeletal-mesh-an-instance-of-the-blueprint-is-spawned-into-the-world/2081594)); skeletal animations on runtime-added entities do not play ([forum](https://forums.unrealengine.com/t/playing-skeletal-animations-for-entities-components-added-through-verse-doesnt-work/2729153)). LIKELY

### Inferences
- Pipeline: Blender → FBX (one shared simple creature skeleton, or several) → UEFN Skeletal Mesh plus AnimSequences (idle, bounce, reveal) → prefab with a skeletal `mesh_component` → Verse `PlaySkeletalAnimation`.
- Use NPC Spawner only for walking "pets" or followers.

### Gaps
- Whether Animation Blueprints or anim graphs can be authored in UEFN is not confirmed; assume no.
- No official figure for the maximum number of simultaneous animated skeletal meshes. Use Timing Insights (v42) to measure.

## 4. Cinematics

### Takeaway
The Cinematic Sequence device supports Everyone, Instigator Only and Instigator's Team visibility. Community reports say "Instigator Only" cannot run concurrently for several players, so frequent per-player reveals should be done in UI.

### Cited Findings
- Visibility options are Everyone, Instigator Only and Instigator's Team. VERIFIED — [Cinematic Sequence device](https://dev.epicgames.com/documentation/en-us/fortnite/using-cinematic-sequence-device-in-unreal-editor-for-fortnite)
- Sequences are networked, and the same "Instigator Only" sequence cannot play for different instigators at once. Recent 2026 threads report that Instigator Only is not working. LIKELY — [forum 1](https://forums.unrealengine.com/t/major-sequences-not-playing-at-the-same-time-for-different-instigators/1146439), [forum 2](https://forums.unrealengine.com/t/cinematic-sequence-device-plays-only-for-one-player/2652437), [forum 3](https://forums.unrealengine.com/t/cinematic-sequence-the-instigator-only-function-is-not-working/2743061), [forum 4](https://forums.unrealengine.com/t/cinematic-sequence-device-doesnt-play-for-team-when-set-to-instigators-team/2656955)

### Inferences
- Do rarity reveals as UMG animation overlays (per player). Reserve Sequencer for rare, global events such as a rebirth or server-wide "secret spawn" moment.

### Gaps
- Camera device details (Fixed Point, Orbit, gameplay cameras) and per-player camera APIs were not re-verified this session.

## 5. VFX and audio

### Takeaway
Custom Niagara systems are fully authorable in UEFN and can be spawned from Verse. Audio must be imported as WAV. MetaSounds are limited to presets of two exposed sources. The Audio Player device supports per-agent targeting through `Register` and `Unregister`.

### Cited Findings
- UEFN includes Niagara for custom VFX, and effects are spawned from Verse with `SpawnParticleSystem()`. VERIFIED — [Effects and Particle Systems](https://dev.epicgames.com/documentation/en-us/fortnite/effects-and-particle-systems-in-unreal-editor-for-fortnite); [Niagara in UEFN course](https://dev.epicgames.com/community/learning/courses/7DG/fortnite-niagara-in-uefn)
- Audio files must be converted to .WAV. VERIFIED — [Import Custom Audio](https://dev.epicgames.com/documentation/en-us/fortnite/import-custom-audio-in-unreal-editor-for-fortnite)
- Custom MetaSound nodes and editing the exposed graph are not possible; there are two exposed sources for presets. VERIFIED — [MetaSounds in UEFN](https://dev.epicgames.com/documentation/en-us/fortnite/metasounds-in-uefn)
- `audio_player_device` has `Unregister` ("removes an Agent as a target to play audio from when activated"). VERIFIED — [audio_player_device](https://dev.epicgames.com/documentation/en-us/fortnite/verse-api/fortnitedotcom/devices/audio_player_device)
- A forum thread reports broken spatial audio on the Scene Graph `sound_component`. LIKELY — [forum](https://forums.unrealengine.com/t/is-scene-graph-sound-component-spatial-audio-broken-in-uefn/2714884)

### Gaps
- Audio size and length limits were not found.

## 6. Memory budget

### Takeaway
The island limit is **100,000 memory units**, measured at edit time with Launch Memory Calculation. Custom assets and devices stay resident, so a large roster of unique creatures is the main risk.

### Cited Findings
- The memory bar shows a maximum of 100,000 units. Run it from Project > Launch Memory Calculation (edit time only). The top-100 asset breakdown is under Window > Message Log > Memory Test Results. VERIFIED — [Memory Management](https://dev.epicgames.com/documentation/en-us/fortnite/memory-management-in-unreal-editor-for-fortnite)
- Devices, custom landscapes and custom assets stay in memory wherever the player is. Nanite "Keep Triangle Percent" reduces the footprint. VERIFIED — [Memory Management](https://dev.epicgames.com/documentation/en-us/fortnite/memory-management-in-unreal-editor-for-fortnite)
- A Project Size tool also exists. VERIFIED — [Project Size Tool](https://dev.epicgames.com/documentation/en-us/fortnite/project-size-tool-in-unreal-editor-for-fortnite)

### Inferences
- Use shared skeletons, 512–1024 px textures and atlas or palette materials. Measure early by importing 10 creatures and extrapolating.

### Gaps
- No official conversion from memory units to MB or to "N characters at X triangles".

## 7. Performance and players

### Cited Findings
- Max Players can be set to 1–100. VERIFIED — [Island Settings](https://dev.epicgames.com/documentation/en-us/fortnite/island-settings-in-unreal-editor-for-fortnite)
- Timing Insights profiling arrived in UEFN v42.00. VERIFIED — [42.00](https://dev.epicgames.com/documentation/fortnite/42-00-fortnite-ecosystem-updates-and-release-notes)
- v39.00 focused on mobile-first performance, including Mobile Preview. LIKELY — [thecreativeblok](https://thecreativeblok.com/uefn-v39-00-update-in-island-transactions-publishing-date-mobile-preview-physics-tools/)
- General mobile guidance from a non-Epic source: 5–15k triangles for hero characters and 100–500 for props, with LODs. LIKELY — [low-poly.com](https://low-poly.com/blog/polygon-budgets-by-platform-2026); [uefncentral](https://uefncentral.com/blog/uefn-map-performance-optimization)

### Gaps
- No official device-count limit, per-tick Verse cost, or `Sleep(0.0)` guidance was found this session. Standard practice is event-driven `Await` and `Sleep(0.1–1.0)` loops rather than per-frame loops (inference).

## 8. In-Island Transactions

### Takeaway
IIT is live: publishing opened on 9 January 2026. Creators earn 100% of the V-Bucks value until 31 January 2027 and 50% from 1 February 2027. Paid random items are allowed with odds disclosure and regional bans; gambling-like mechanics such as prize wheels are prohibited.

### Cited Findings
- The IIT device template implements the Marketplace module: items, offers, bundle offers and the default storefront UI. VERIFIED — [IIT Overview](https://dev.epicgames.com/documentation/fortnite/in-island-transactions-overview-in-fortnite); [Device Template](https://dev.epicgames.com/documentation/fortnite/inisland-transactions-device-template-in-fortnite)
- Purchases are handled by two main functions: `BuyOffer` (presents the offer and validates the purchase) and `OnPurchasesChanged` (handles success or refund). `ShowOffersDialog` shows the built-in storefront; `GetPurchasedEntitlements` queries ownership; `ConsumeEntitlement` consumes consumables. VERIFIED — [Creating Items and Offers](https://dev.epicgames.com/documentation/fortnite/creating-items-and-offers-in-fortnite); [Best Practices and Debugging](https://dev.epicgames.com/documentation/en-us/fortnite/in-island-transactions-best-practices-and-debugging-in-fortnite)
- `MaxCount` must be 1 when `Consumable=false`, with a maximum of 10,000,000. VERIFIED — [Best Practices and Debugging](https://dev.epicgames.com/documentation/en-us/fortnite/in-island-transactions-best-practices-and-debugging-in-fortnite)
- Live Edit and Private Playtest are debug sessions: no V-Bucks are deducted and entitlements are removed at the end. Debug commands are Grant All Products, Grant One of All Products, Force Remove Products and Open Storefront. Offers must be on a private or playtest version. VERIFIED — same page
- `GetMinPurchaseAge` can crash Verse when a player fails the age check. LIKELY — [forum](https://forums.unrealengine.com/t/transactions-when-player-doesnt-pass-getminpurchaseage-verse-can-crash/2678046). A non-consumable (MaxCount=1) was lost after purchase and re-prompted. LIKELY — [forum](https://forums.unrealengine.com/t/non-consumable-entitlement-maxcount-1-lost-after-purchase-offer-re-prompts-re-purchase-silently-fails-with-no-v-bucks-charge/2740454)
- Publishing opened on 9 January 2026. Creators earn 100% until 31 January 2027 and 50% from 1 February 2027. More than 3,000 islands earn more from IIT than from the engagement pool (June 2026). LIKELY (press) — [pocketgamer](https://www.pocketgamer.biz/epic-games-pushes-in-island-transaction-publishing-for-fortnite-creators-to-january-2026/); [gamespot](https://www.gamespot.com/articles/fortnite-now-lets-creators-publish-islands-with-in-game-transactions/1100-6537294/); [tubefilter](https://www.tubefilter.com/2026/06/17/epic-games-unreal-editor-for-fortnite-creator-payouts/)
- Paid random items are allowed with odds disclosure. They are banned in some regions (BE, NL, AU, SG, QA for all ages; UK and BR for under-18s). Prize wheels are affected, and gambling or casino content is prohibited. LIKELY — [tubefilter](https://www.tubefilter.com/2026/01/09/fortnites-new-developer-made-item-sales-loot-boxes-yes-outfits-and-emotes-no/); [IIT Restrictions](https://dev.epicgames.com/documentation/fortnite/in-island-transactions-restrictions-in-fortnite); [Developer Rules](https://legal.epicgames.com/fortnite/developer-rules). Sources conflict: techloy reports a ban on prize-wheel and loot-box sales ([techloy](https://www.techloy.com/epic-games-bans-prize-wheel-and-loot-box-sales-in-fortnite-creator-islands/)); check the [Rules Change Log](https://legal.epicgames.com/fortnite/developer-rules-change-log).
- A community visual tool (unofficial) generates IIT Verse code. — [ADEPT UEFN-Transaction-Manager](https://github.com/ADEPT-Interactive/UEFN-Transaction-Manager)

### Gaps
- Exact class names (`entitlement`, `entitlement_offer`, `bundle_offer`), module path and price bounds could not be read from the page directly.

## 9. Multiplayer

### Cited Findings
- Max Players is 1–100 (Island Settings). VERIFIED — [Island Settings](https://dev.epicgames.com/documentation/en-us/fortnite/island-settings-in-unreal-editor-for-fortnite)
- `player_reference_device` (`GetAgent`) and `player_spawner_device` have Verse APIs. VERIFIED — [player_reference_device](https://dev.epicgames.com/documentation/en-us/fortnite/verse-api/fortnitedotcom/devices/player_reference_device); [player_spawner_device](https://dev.epicgames.com/documentation/en-us/fortnite/verse-api/fortnitedotcom/devices/player_spawner_device)
- Forum report: a published island's Max Players reverted to 16. LIKELY — [forum](https://forums.unrealengine.com/t/how-can-i-set-my-island-to-2-maximum-players-uefn-in-island-settings-i-put-maximum-2-players-but-after-publishing-it-goes-for-16-players/1239744)

### Inferences
- Plot assignment: an array of N plot managers. On `PlayerAddedEvent`, claim a free plot; on `PlayerRemovedEvent`, save the player's data and reset the plot. Rebuild the plot from the save on join (join-in-progress).

### Gaps
- Join-in-progress settings and matchmaking options were not verified. No official global persistent leaderboard was found.

## 10. Tooling

### Cited Findings
- UEFN v42.00 brings Unreal MCP (shipped with UE 5.8) to UEFN, so Claude Code, Codex or Cursor can connect directly. VERIFIED — [42.00](https://dev.epicgames.com/documentation/fortnite/42-00-fortnite-ecosystem-updates-and-release-notes)
- Python in UEFN supports automation, including "MCP integration with an Agentic AI". Access is via a beta, judging by forum access requests. VERIFIED / LIKELY — [Python Tools in UEFN](https://dev.epicgames.com/documentation/fortnite/python-tools-in-uefn); [forum](https://forums.unrealengine.com/t/python-editor-scripting-beta-access-request-uefn/2741814)
- Community tooling: UEFN-TOOLBELT (287+ Python tools; unofficial). — [forum](https://forums.unrealengine.com/t/open-source-project-uefn-toolbelt-287-python-tools-for-world-building-verse-automation/2709005)
- Mixamo is royalty-free for commercial games; raw files may not be redistributed. VERIFIED — [Adobe Mixamo FAQ](https://helpx.adobe.com/creative-cloud/faq/mixamo-faq.html)
- TTS licences: Kokoro is Apache-2.0 (commercial OK). Piper's engine is MIT, or GPL-3.0 for the maintained fork; **each voice model has its own dataset licence, so check it**. Coqui XTTS-v2 is CPML, non-commercial, with no path to a commercial licence since Coqui shut down. LIKELY (secondary) — [promptquorum](https://www.promptquorum.com/power-local-llm/local-tts-voice-cloning-piper-coqui-xtts); [bentoml](https://www.bentoml.com/blog/exploring-the-world-of-open-source-text-to-speech-models)

### Gaps
- Blender add-on specifics (Send to Unreal, Game Rig Tools), sfxr/Bfxr/ChipTone licences and Krita/GIMP were not researched this session. They are well-known free tools; confirm their licences separately.
