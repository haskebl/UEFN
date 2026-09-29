# Fortnite Creative/UEFN Brainrot and Simulator Map Inventory, plus Loop Gap Analysis vs. Roblox (as of 2026-09-29)

> **Read this first: method limits and data labels**
> - **fortnite.gg, api.fortnite.com (Ecosystem API) and fortnite.com were BLOCKED** by this environment's egress proxy (403 on CONNECT, verified 2026-09-29 with WebFetch and curl). WebFetch was also blocked for every news site I tried (videogamer, hotspawn, igamingtoday).
> - **Every number below comes from web-search result snippets of fortnite.gg pages and news articles** (search index, retrieved 2026-09-29). The snippet date is usually unknown, so a "players right now" value is an **undated snapshot**, not a live 2026-09-29 reading. All-time peaks carry the date that fortnite.gg shows.
> - The search summariser sometimes labelled fortnite.gg's "all-time peak <N> <date>" as a "24-hour peak". Where a number came with a date, I treat it as the **all-time peak on that date** and flag it.
> - **No D1/D7 retention, no avg playtime per player, and no 30-day peak could be measured.** These come only from the Ecosystem API and fortnite.gg charts, and both were blocked. They are Gaps. As a proxy I give "minutes played" (lifetime total) where the snippet had it.
> - Labels: **CLAIMED** = a number shown on a third-party page (fortnite.gg uses Epic's official API data, but I could not verify it myself). **ESTIMATED** = my inference. Nothing here is **MEASURED** by me.
> - **Quality score (1–10) is ESTIMATED from the description and scale only. I did not play any of these maps.**
> - "UEFN vs Creative 1.0" is inferred: persistent saves, offline earnings, rebirth, custom brainrot models and in-island V-Bucks shops require UEFN/Verse, so any map listing those is marked "UEFN (inferred)".

## What are the top brainrot maps and their numbers? (Inventory)

### Takeaway
The category is led by a handful of UEFN "collect → earn → upgrade → rebirth" tycoon-simulators. STEAL THE BRAINROT (ferins, officially licensed, 1,087,974 all-time peak on 2026-01-11) is first, followed by GO UP FOR BRAINROTS (362,337 all-time peak, 2026-05-17) and Fight The Brainrot (211,831 all-time peak, 2026-08-29). Beyond these there is a long tail of 60+ clones with a 1k–50k all-time peak. In recent snapshots, only about 5–7 brainrot or brainrot-adjacent maps sit above 5k CCU.

### Inventory table
Columns: Code | Title | Creator | Core loop | Current players (undated snapshot) | All-time peak (date) | Minutes played / favorites | Build | Custom models | Quality (ESTIMATED) | Source. Where a column has no data it says "n/a (blocked)". For every map, release date, 30-day peak, avg playtime and D1/D7 were unavailable, so those columns are left out.

| # | Code | Title | Creator | Core loop | Now (snapshot, CLAIMED) | All-time peak (CLAIMED) | Minutes / favs (CLAIMED) | Build | Custom models | Q | Source |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 3225-0366-8885 | STEAL THE BRAINROT | ferins | Steal/tycoon: buy brainrots → passive cash → defend base, steal from others; codes, events, V-Bucks shop | 8,850 / 12,075 / 12,379 (three different snapshots; one is dated 2026-09-28 with 658.3K unique players that day) | **1,087,974 (2026-01-11)** | n/a | UEFN (inferred; licensed assets, in-island purchases) | Yes (licensed Roblox brainrot art) | 8: record holder, licensed, live-ops codes; controversial monetization | [fortnite.gg](https://fortnite.gg/island/3225-0366-8885) |
| 2 | 7875-7934-3852 | GO UP FOR BRAINROTS | ferins | Vertical jump/obby-tycoon: upgrade jump → climb → collect rarer brainrots; rebirth; events (Radioactive) | 14,509 / 19,532 | **362,337 (2026-05-17)** | 6.7B min / 1.2M favs | UEFN (inferred) | Yes (inferred) | 8: second-biggest brainrot map by lifetime minutes | [fortnite.gg](https://fortnite.gg/island/7875-7934-3852) |
| 3 | 6980-2761-9936 | Fight The Brainrot | neverty7 | Fighting-simulator: earn cash → buy brainrots → merge duplicates → co-op bosses → rebirth | 16,304 / 4,407 | **211,831 (2026-08-29)** | 2.8B min / 565.6K favs | UEFN (inferred) | Yes (inferred) | 8: peak fell inside the last 30 days, so it is the freshest breakout | [fortnite.gg](https://fortnite.gg/island/6980-2761-9936) |
| 4 | 7865-8305-9184 | Star Wars Droid Tycoon (brainrot-adjacent benchmark) | foad | Tycoon: buy droid blueprints → build droids → income → fusion crafting → super rebirth; no stealing, no V-Bucks | "15k–35k typical" per games.gg | **124,592 (2026-05-09)** | n/a | UEFN (licensed IP) | Yes | 9: Epic/Lucasfilm IP, cited as a Top-10 staple | [fortnite.gg](https://fortnite.gg/island/7865-8305-9184); [games.gg](https://games.gg/news/fortnite-creative-tycoon-genre-rising/) |
| 5 | 0017-2877-1308 | GROW THE BRAINROT | takuman_kamikz | Grow/raise: break eggs → get brainrots → raise them bigger → show off | 45,845 / 6,206 (snapshots) | **53,218** (date not in snippet) | n/a | UEFN (credits "verse by kamikz", VFX material by AXINITE) | Yes (custom VFX material credited) | 7 | [fortnite.gg](https://fortnite.gg/island/0017-2877-1308) |
| 6 | 7113-0641-3989 | ESCAPE TSUNAMI FOR THE BRAINROTS | gako | Escape/tycoon: dodge waves → grab rarer brainrots further out → level up → income | n/a | **44,575 (2026-01-31)** | 540.7M min / 487.5K favs | UEFN (inferred) | Yes (inferred) | 7 | [fortnite.gg](https://fortnite.gg/island/7113-0641-3989) |
| 7 | 6311-7280-6172 | Become A Lucky Rot [BRAINROT] | smuti | Steal + lucky-block RNG: become a lucky block, steal brainrots, offline cash | n/a | **43,911 (2026-04-18)** | 244.3M min | UEFN (inferred) | Yes (inferred) | 6 | [fortnite.gg](https://fortnite.gg/island/6311-7280-6172) |
| 8 | 0497-4522-9912 | GARDEN VS BRAINROTS | rvb | Plants-vs-Brainrots: buy seeds → plant → plants fight brainrot waves; mutations; offline income | 532 | **36,451 (2025-11-23)** | 581.4M min | UEFN (inferred) | Yes (inferred) | 6: faded ~10 months after peak | [fortnite.gg](https://fortnite.gg/island/0497-4522-9912) |
| 9 | 9840-0433-5082 | 🌻 PLANTS VS BRAINROTS [NEW] | rvb | Plants-vs-Brainrots (same as #8), trading, rebirth, live events | n/a | **27,613 (2025-10-05)** | n/a | UEFN (inferred) | Yes (inferred) | 6 | [fortnite.gg](https://fortnite.gg/island?code=9840-0433-5082) |
| 10 | 5184-8602-9262 | KICK THE LUCKY BLOCK [BRAINROT] | smuti | Lucky-block RNG: kick blocks for random brainrots | n/a | **17,834 (2026-05-02)** (flagged as "24h peak" by summariser) | n/a | UEFN (inferred) | Yes (inferred) | 6 | [fortnite.gg](https://fortnite.gg/island/5184-8602-9262) |
| 11 | 6931-5304-1207 | BE A BRAINROT | nitromaps | Stealth-steal + evolve: become a brainrot, sneak past guards, steal, transform into stronger forms | 7,878 | **14,568** (date n/a) | n/a | UEFN (inferred) | Yes (inferred) | 6 | [fortnite.gg](https://fortnite.gg/island/6931-5304-1207) |
| 12 | 5488-9032-1549 | BRAINROT TOWER DEFENSE | njay | Tower defense: place brainrot towers → waves → cash → summon rare brainrots (gacha); trait rerolls | 369 | **14,427 (2026-02-15)** (flagged "24h peak") | 383.5M min / 187.4K favs | UEFN (inferred; item shop with "Trait Reroll Skip") | Yes (inferred) | 7 | [fortnite.gg](https://fortnite.gg/island/5488-9032-1549) |
| 13 | 2931-5177-5650 | DIG FOR BRAINROTS | luckymaps | Dig/mine: dig deeper → rarer brainrots → upgrade → rebirth → new zones | 220 | **12,188 (2026-05-03)** (flagged "24h peak") | 80.7M min / 88K favs | UEFN (inferred) | Yes (inferred) | 5 | [fortnite.gg](https://fortnite.gg/island/2931-5177-5650) |
| 14 | 7672-1003-7237 | Brainrot Card Tycoon | pwr | Pack-opening/card tycoon: mine → open packs → level brainrots; offline earnings | 349 | **11,597 (2026-07-26)** | n/a | UEFN (inferred) | Yes (inferred) | 5 | [fortnite.gg](https://fortnite.gg/island/7672-1003-7237) |
| 15 | 2557-3355-0240 | BERRY GARDEN TYCOON (non-brainrot garden) | wanderer | Garden tycoon: harvest berries → juice → upgrade juicer → rebirth; dino boss, minigames, secret codes | 9,852 | **9,930 (2026-09-26)** | n/a | UEFN (inferred; autosave) | Likely | 7: rising right now, peak 3 days ago | [fortnite.gg](https://fortnite.gg/island/2557-3355-0240) |
| 16 | 8344-0475-7589 | +1 Escape a Brainrot | stanni | +1-stat escape + fight brainrots → earn lucky blocks | n/a | **9,042 (2026-09-05)** | n/a | UEFN (inferred) | Yes (inferred) | 5 | [fortnite.gg](https://fortnite.gg/island/8344-0475-7589) |
| 17 | 1796-9956-7050 | BEAT THE BRAINROT | post | Fight/collect | n/a | **7,325 (2026-09-12)** | n/a | UEFN (inferred) | n/a | 5 | [fortnite.gg](https://fortnite.gg/island/1796-9956-7050) |
| 18 | 4619-2685-4993 | FISH HEROES | njay | Fishing: catch → sail to new islands → place fish in base for income | 2,066 | **5,627 (2026-05-24)** | 16.5M min | UEFN (inferred) | Yes (inferred) | 6 | [fortnite.gg](https://fortnite.gg/island/4619-2685-4993) |
| 19 | 0333-6852-5537 | MERGE THE BRAINROT | ocwg | Merge: combine brainrots → higher tiers; tickets for random brainrots; boss every 10 min | n/a | **4,144 (2026-02-20)** | 14.3M min | UEFN (inferred) | Yes (inferred) | 5 | [fortnite.gg](https://fortnite.gg/island/0333-6852-5537) |
| 20 | 4471-5708-8314 | Pet Simulator | ripstu | Egg-hatch + steal: steal eggs, hatch, pets earn money, treadmill speed | 442 (2026-08-28) | **1,835** | n/a | UEFN (inferred) | n/a | 4 | [fortnite.gg](https://fortnite.gg/island/4471-5708-8314) |
| 21 | 9391-9758-5459 | BIKE OBBY FOR THE BRAINROTS (EVENT) | gako | Obby-collect | 358 | 1,197 | n/a | UEFN (inferred) | n/a | 4 | [fortnite.gg](https://fortnite.gg/island/9391-9758-5459) |
| 22 | 2029-5468-2362 | OBBY FOR BRAINROTS [TYCOON] | kiwilover | Obby-tycoon | 608 | n/a | 2.4M min | UEFN (inferred) | n/a | 4 | [fortnite.gg](https://fortnite.gg/island?code=2029-5468-2362) |
| 23 | 1127-2368-2059 | OBBY FOR BRAINROTS | laxhub | Obby-collect | 6 (24h peak 361) | date 2026-03-14 (value n/a) | n/a | UEFN (inferred) | n/a | 3 | [fortnite.gg](https://fortnite.gg/island?code=1127-2368-2059) |
| 24 | 7279-5118-9032 | ROLL A BRAINROT [RNG] | luckymaps | Pure RNG roll for rare brainrots | n/a | **755 (2026-06-12)** | n/a | UEFN (inferred) | n/a | 3: pure RNG underperformed | [fortnite.gg](https://fortnite.gg/island/7279-5118-9032) |
| 25 | 6611-8927-4506 | PLANTS VS BRAINROTS [SIMULATOR] | peakgames | PvB clone | n/a | **179 (2025-11-09)** | n/a | UEFN (inferred) | n/a | 2: failed clone | [fortnite.gg](https://fortnite.gg/island?code=6611-8927-4506) |
| 26 | 8157-6026-2408 | BRAINROT TYCOON | viper9 | Tycoon: be a brainrot, cars, infinite tower | 8 | n/a | n/a | n/a | n/a | 2 | [fortnite.gg](https://fortnite.gg/island/8157-6026-2408) |
| 27 | 6872-6995-0659 | GO FISHING! | sypherpk | Fishing sim: rods/lures/boats, Legendary/Mythic/Secret catches | 3 | n/a | 38.2M min | UEFN (inferred) | n/a | 3: once sizable, now dead | [fortnite.gg](https://fortnite.gg/island/6872-6995-0659) |
| 28 | 5424-8482-6958 | ESCAPE 99 NIGHTS IN THE FOREST [HORROR] | sorus | 99-Nights survival clone | n/a | **2,653 (2025-06-26)** | n/a | n/a | n/a | 3 | [fortnite.gg](https://fortnite.gg/island/5424-8482-6958) |
| 29 | 4580-8774-4615 | 99 NIGHTS IN A FOREST | ccstudios | Survival clone | n/a | **2,054 (2025-08-09)** | n/a | n/a | n/a | 3 | [fortnite.gg](https://fortnite.gg/island?code=4580-8774-4615) |
| 30 | 3168-8927-7042 | GARDEN HORIZONS | marvyn | Grow-a-Garden clone | n/a | **999 (2025-06-20)** | n/a | n/a | n/a | 2 | [fortnite.gg](https://fortnite.gg/island?code=3168-8927-7042) |
| 31 | 8655-8604-8707 | GROW A GARDEN TYCOON | cheerzcreators | Garden tycoon | n/a | **634** ("12 days ago", about mid-Sep 2026) | n/a | n/a | n/a | 2 | [fortnite.gg](https://fortnite.gg/island?code=8655-8604-8707) |
| 32 | 0170-4107-9064 | Grow a Garden🌙[STEAL FRUITS] | fn-maps | Garden + steal | n/a | **628 (2025-06-28)** | n/a | n/a | n/a | 2 | [fortnite.gg](https://fortnite.gg/island?code=0170-4107-9064) |

**Additional maps confirmed to exist (code, creator and loop from fortnite.gg titles/descriptions), with no player numbers retrievable (Now/Peak = n/a (blocked), Q not scored):**

| # | Code | Title | Creator | Core loop | Source |
|---|---|---|---|---|---|
| 33 | 4124-4721-7108 | 🍬 Steal a Brainrot | napperfn | Steal | [fortnite.gg](https://fortnite.gg/island?code=4124-4721-7108) |
| 34 | 6794-9792-5260 | GO STEAL A BRAINROT | shufflegamer | Steal | [fortnite.gg](https://fortnite.gg/island/6794-9792-5260) |
| 35 | 2245-9923-5638 | STEAL THE BRAINROT WINTER | zombix | Steal | [fortnite.gg](https://fortnite.gg/island/2245-9923-5638) |
| 36 | 3275-9318-3999 | STEAL BRAINROTS FROM BRAINROTS | nitromaps | Steal (**disabled 2026-06-04**) | [fortnite.gg](https://fortnite.gg/island/3275-9318-3999) |
| 37 | 2228-0420-7962 | Merge The Brainrot & Steal | gwst | Merge + steal | [fortnite.gg](https://fortnite.gg/island?code=2228-0420-7962) |
| 38 | 1157-0809-6700 | Merge The Brainrot - خرابيط العرب | seedoh | Merge ("1000+ combinations"), Arabic-market | [fortnite.gg](https://fortnite.gg/island/1157-0809-6700) |
| 39 | 4838-2014-5851 | CRAFT A BRAINROT | pandvil | Craft/merge | [fortnite.gg](https://fortnite.gg/island/4838-2014-5851) |
| 40 | 9335-3650-5967 | Grow a Garden To Steal a Brainrot | frizzyfish | Grow + steal hybrid, offline growth | [fortnite.gg](https://fortnite.gg/island?code=9335-3650-5967) |
| 41 | 5792-3315-4832 | GROW A BRAINROT | manteigastudio | Grow (no size cap), minigames, rebirth, 1–8p | [fortnite.gg](https://fortnite.gg/island/5792-3315-4832) |
| 42 | 4554-4413-1515 | FRUITS VS BRAINROTS | pandvil | PvB variant | [fortnite.gg](https://fortnite.gg/island/4554-4413-1515) |
| 43 | 6781-3462-8778 | PLANTS AGAINST BRAINROTS | lootlover | PvB clone | [fortnite.gg](https://fortnite.gg/island?code=6781-3462-8778) |
| 44 | 5153-7312-9072 | PLANTS VS THE BRAINROTS | volatery | PvB clone | [fortnite.gg](https://fortnite.gg/island?code=5153-7312-9072) |
| 45 | 2921-5361-5833 | 🌈ADMIN PANEL Plants Vs Brainrots MODDED | frizzyfish (also listed as curiouscraze) | PvB + "admin abuse" | [fortnite.gg](https://fortnite.gg/island?code=2921-5361-5833) |
| 46 | 9452-2972-2586 | JUNGLE VS BRAINROTS [NEW] BOSS BATTLE | quickmaps | PvB + boss | [fortnite.gg](https://fortnite.gg/island?code=9452-2972-2586) |
| 47 | 2877-4372-2337 | Build Pillars for Brainrots [TYCOON] | ripsti | Build/climb tycoon | [fortnite.gg](https://fortnite.gg/island?code=2877-4372-2337) |
| 48 | 0557-0991-6312 | GROW BEANSTALK FOR BRAINROTS [BETA] | bkss | Grow/climb | [fortnite.gg](https://fortnite.gg/island?code=0557-0991-6312) |
| 49 | 1404-8116-3135 | BE A BRAINROT [TYCOON] | rvb | Tycoon | [fortnite.gg](https://fortnite.gg/island/1404-8116-3135) |
| 50 | 9342-7257-9767 | SURVIVE LAVA FOR BRAINROTS [TYCOON] | rvb | Escape-hazard tycoon | [fortnite.gg](https://fortnite.gg/island/9342-7257-9767) |
| 51 | 1840-9148-5961 | Brainrots vs Balloons Tower Defense | rvb | TD | [fortnite.gg](https://fortnite.gg/island/1840-9148-5961) |
| 52 | 9517-4620-3044 | Brainrot Tower Defense [Pandvil] | pandvil | TD | [fortnite.gg](https://fortnite.gg/island/9517-4620-3044) |
| 53 | 2888-0772-6567 | Brainrot Tower Wars [Tower Defense] | thepapasmurf91 | 3v3 tower wars | [fortnite.gg](https://fortnite.gg/island?code=2888-0772-6567) |
| 54 | 2766-0575-2301 | BRAINROT BASE DEFENSE | morzu | Base defense (**disabled 2026-07-31**) | [fortnite.gg](https://fortnite.gg/island/2766-0575-2301) |
| 55 | 5409-6471-1162 | EVOLVE A BRAINROT ⭐🎄 | metaggames | Evolve: eat → level → transform | [fortnite.gg](https://fortnite.gg/island?code=5409-6471-1162) |
| 56 | 8699-5246-6810 | BRAINROT EVOLUTION ⭐ | njay (with xFrozen Studios) | Evolve (eat → level → evolution) | [fortnite.gg](https://fortnite.gg/island/8699-5246-6810) |
| 57 | 4122-6885-3510 | 🧠 BRAINROT EVOLUTION Tycoon 🦈 | clickgames | Evolve + hatch pets | [fortnite.gg](https://fortnite.gg/island?code=4122-6885-3510) |
| 58 | 6105-2051-1405 | Spin For Brainrot 🎲 | trentesc | RNG lucky blocks + steal + rebirth | [fortnite.gg](https://fortnite.gg/island?code=6105-2051-1405) |
| 59 | 6463-5208-5848 | BRAINROT BLOCK SPIN RP | praccy | RP + case unboxing | [fortnite.gg](https://fortnite.gg/island?code=6463-5208-5848) |
| 60 | 8487-6027-7031 | Race Your Lucky Block | freezy | Racing + RNG | [fortnite.gg](https://fortnite.gg/island/8487-6027-7031) |
| 61 | 1799-0772-8349 | BRAIN ROT RACE | quickplay | Racing | [fortnite.gg](https://fortnite.gg/island/1799-0772-8349) |
| 62 | 0311-6653-8306 | FLY/ROCKET UP FOR BRAINROTS | nitromaps / nitrobackup | Go-Up clone | [fortnite.gg](https://fortnite.gg/island/0311-6653-8306) |
| 63 | 6284-8267-1225 | JUMP FOR BRAINROTS (GO UP TYCOON) | dwed | Go-Up clone | [fortnite.gg](https://fortnite.gg/island/6284-8267-1225) |
| 64 | 1760-1583-8879 | Fishing For Brainrot🎣 | anthrot | Fishing + brainrot | [fortnite.gg](https://fortnite.gg/island/1760-1583-8879) |
| 65 | 9005-9435-2814 | Brainrot Catch & Sell | mststudios | Catch/sell | [fortnite.gg](https://fortnite.gg/island/9005-9435-2814) |
| 66 | 2998-6709-7605 | CATCH ALL BRAINROTS | stanni | Catching | [fortnite.gg](https://fortnite.gg/island?code=2998-6709-7605) |
| 67 | 0621-6220-1078 | GUESS THE BRAINROT QUIZ 🔊 | tony4k | Quiz | [fortnite.gg](https://fortnite.gg/island?code=0621-6220-1078) |
| 68 | 7302-5205-4646 | 🧠 BRAINROT QUIZ 🧠🤪 | auronic | Quiz | [fortnite.gg](https://fortnite.gg/island?code=7302-5205-4646) |
| 69 | 0031-8858-9271 | ITALIAN BRAINROT QUIZ ❓ | neewayk | Quiz | [fortnite.gg](https://fortnite.gg/island?code=0031-8858-9271) |
| 70 | 4991-7203-8899 | TUNG TUNG TUNG SAHUR BOSS FIGHT | banisher | Boss fight (1–16p) | [fortnite.gg](https://fortnite.gg/island/4991-7203-8899) |
| 71 | 4792-9920-5448 | TUNG TUNG SAHUR 1v1 | epicwander | 1v1 build fights | [fortnite.gg](https://fortnite.gg/island/4792-9920-5448) |
| 72 | 6069-4019-8271 | TUNG TUNG SAHUR - FREE FOR ALL | koloss | FFA | [fortnite.gg](https://fortnite.gg/island/6069-4019-8271) |
| 73 | 5199-0297-8054 | ESCAPE TUNG SAHUR [HORROR] | fnhorror | Horror escape | [fortnite.gg](https://fortnite.gg/island?code=5199-0297-8054) |
| 74 | 5619-1474-5004 / 4274-1432-8830 | Brainrot FFA / Brainrot Box Fights | brainrots | PvP reskins | [fortnite.gg](https://fortnite.gg/creator/brainrots) |
| 75 | 9530-3973-5646 / 9700-5146-7838 | Steal An Lucky Egg / Steal An Egg 🥚 | centralgames / swany-creative | Egg steal + hatch + mutations | [fortnite.gg](https://fortnite.gg/island/9530-3973-5646/history) |
| 76 | 8090-8825-9706 | Hatch a Pet [TYCOON] | kiwilover | Egg-hatch tycoon | [fortnite.gg](https://fortnite.gg/island/8090-8825-9706) |
| 77 | 2334-3897-4888 / 9810-2147-6885 | Brainrot Roguelike / Memes Vs Brainrots | ferins | Portfolio spin-offs by the market leader | [fortnite.gg](https://fortnite.gg/creator/ferins) |

### Cited Findings
- STEAL THE BRAINROT reached an all-time peak of 1,087,974 CCU on 2026-01-11 (CLAIMED, fortnite.gg). It was the first Creative map to pass 1M CCU — [fortnite.gg](https://fortnite.gg/island/3225-0366-8885); [PCGamesN](https://www.pcgamesn.com/fortnite/creative-steal-the-brainrot-roblox-clone-1-million-players)
- Epic officially licensed Roblox's Steal a Brainrot. The Fortnite version launched July 2025, broke the Creative CCU record at ~400k (previous record: 235k, Super Red vs Blue, May 2025) and hit 500k on 2025-09-13 — [Wikipedia](https://en.wikipedia.org/wiki/Steal_a_Brainrot); X post by [RBXevents](https://x.com/RBXevents_/status/1961945776919130426) (post ID decodes to 2025-08-31) claims it is "officially licenced".
- On 2025-09-14 the Fortnite edition had 542,000 concurrent users. Roblox plus Fortnite together reached ~24M players in a single day — [Dexerto](https://www.dexerto.com/gaming/steal-a-brainrot-smashes-records-with-nearly-24-million-players-across-roblox-and-fortnite-3250973/); [Tribune](https://tribune.com.pk/story/2567134/steal-a-brainrot-reaches-24-million-players-across-roblox-and-fortnite-in-single-day)
- The Fortnite version had 658.3K unique players on 2026-09-28 and ~12,379 current players (CLAIMED, search-summary of fortnite.gg page) — [fortnite.gg](https://fortnite.gg/island/3225-0366-8885)
- GO UP FOR BRAINROTS: 6.7B minutes played, 1.2M favorites, all-time peak 362,337 (2026-05-17) — [fortnite.gg](https://fortnite.gg/island/7875-7934-3852)
- Fight The Brainrot: 2.8B minutes, 565.6K favorites, all-time peak 211,831 (2026-08-29), 16,304 players in one snapshot — [fortnite.gg](https://fortnite.gg/island/6980-2761-9936)
- Star Wars Droid Tycoon (launched May 1, 2026) sits in the Top 10 with Steal the Brainrot and Go Up for Brainrots, "typically 15,000–35,000 players at any given time". That is more than the official Epic modes LEGO Fortnite Odyssey and Blitz Royale. It has no stealing and no V-Bucks monetization — [games.gg](https://games.gg/news/fortnite-creative-tycoon-genre-rising/). Its all-time peak was 124,592 (2026-05-09) — [fortnite.gg](https://fortnite.gg/island/7865-8305-9184)
- All other per-map numbers are in the table above, each with its fortnite.gg source link.

### Inferences
- **Three tiers (ESTIMATED):** (a) mega-hits with a 200k–1.1M all-time peak: Steal, Go Up, Fight. All three are UEFN, all three have heavy live-ops, and two of the three belong to one creator (ferins). (b) Mid-tier hits with a 10k–55k peak: Grow the Brainrot, Escape Tsunami, Lucky Rot, Garden/Plants vs Brainrots, Kick Lucky Block, Be a Brainrot, TD, Dig, Card Tycoon. (c) A long tail under 5k, mostly dead.
- **Most mid-tier maps peaked and decayed within ~1–3 months.** Garden vs Brainrots went from a 36k peak (Nov 2025) to 532 now. TD went from 14k (Feb 2026) to 369. Dig went from 12k (May 2026) to 220. A trend-chasing clone gets a short window.
- **Only three maps have an all-time peak dated within the last 30 days (≥ 2026-08-30):** Fight The Brainrot (211k, 08-29, borderline), +1 Escape a Brainrot (9k, 09-05), BEAT THE BRAINROT (7.3k, 09-12) and BERRY GARDEN TYCOON (9.9k, 09-26). The current momentum is in **fight-simulators and garden tycoons**.

### Gaps
- Release dates, 30-day peaks, average playtime per player and D1/D7 retention could not be retrieved for any map (fortnite.gg and the Ecosystem API were both blocked). **Rerun the Ecosystem API metrics calls from an unrestricted machine** for the top 15 codes above.
- "Current players" values are undated search-index snapshots. Several conflict (Grow the Brainrot: 45,845 vs 6,206; Steal: 8,850 / 12,075 / 12,379).
- Custom-model and UEFN flags are inferred, not verified on the fortnite.gg "UEFN" badge.
- The ~40 table rows with n/a numbers need a manual fortnite.gg pass.

## Which Roblox loops are missing or weak in Fortnite? (Loop coverage)

### Takeaway
Measured against your threshold (a map with a >1k / >5k peak in the last 30 days), the saturated loops are **steal-tycoon, generic tycoon/"go up" climbing, and fighting-simulator**. **Grow/garden** is strong but thin (2 maps). **Merge, evolve, breed, pure RNG/spin, pet-sim/egg-hatch, quiz and racing are weak or absent**, and so is 99-Nights-style survival. Tower defense and fishing had a real audience but currently look weak.

### Loop coverage matrix (ESTIMATED classification; the 30-day peak is inferred from the all-time-peak date plus current snapshots)

| Loop | Fortnite maps (CCU evidence) | Classification | Evidence |
|---|---|---|---|
| **Steal** | STEAL THE BRAINROT (≈8.8–12.4k now), BE A BRAINROT (7.9k now), Become A Lucky Rot (43.9k ATP Apr-26), plus many clones | **Saturated / dominated by a licensed incumbent** | Two maps above 5k in recent snapshots, plus a licensed 1M-CCU incumbent |
| **Tycoon (generic / "go up" / escape-hazard)** | GO UP FOR BRAINROTS (14.5–19.5k), Droid Tycoon (15–35k), Berry Garden Tycoon (9.9k, 2026-09-26), Escape Tsunami (44.6k ATP Jan) | **Saturated** | Three or more maps above 5k |
| **Fighting-simulator** | Fight The Brainrot (16.3k now; 211.8k ATP 08-29), +1 Escape a Brainrot (9.0k 09-05), BEAT THE BRAINROT (7.3k 09-12), plus native Fortnite PvP | **Saturated** | Three maps above 5k with peaks within about the last 30 days |
| **Grow / garden** | GROW THE BRAINROT (6.2k–45.8k snapshots), Berry Garden Tycoon (9.9k), Garden vs Brainrots (532 now) | **Strong (not saturated)** | Two maps above 5k. Pure Grow-a-Garden clones never exceeded ~1k (999 / 634 / 628) |
| **Plants-vs-Brainrots (grow + TD hybrid)** | Garden vs Brainrots (36.5k ATP Nov-25, 532 now), PvB [NEW] (27.6k ATP Oct-25) | **Present but weak now** (was strong in Q4 2025) | Current CCU is under 1k for the leader |
| **Tower defense** | BRAINROT TOWER DEFENSE (14.4k ATP Feb-26, 369 now), plus 4 others with no data | **Weak / likely not present in 30 days** | Leader far below 1k now |
| **Fishing / catching** | FISH HEROES (2,066 snapshot; 5.6k ATP May-26), GO FISHING! (3 now; 38.2M min lifetime), Fishing for Brainrot (n/a) | **Present but weak** | Only one map shows over 1k, and it is below 5k |
| **Dig / mine** | DIG FOR BRAINROTS (12.2k ATP May-26, 220 now) | **Weak now** | — |
| **RNG / spin / lucky block** | Lucky-block hybrids strong earlier (Lucky Rot 43.9k, Kick 17.8k), pure RNG weak (ROLL A BRAINROT 755 ATP); Spin For Brainrot n/a | **Pure RNG: not present. Lucky-block hybrids: present but decayed** | Epic's 2026-01-20 ban on paid prize-wheel spins limits monetising this loop |
| **Merge** | MERGE THE BRAINROT (4.1k ATP Feb-26), seedoh/gwst variants n/a; merge only as a sub-mechanic in Fight The Brainrot and Droid Tycoon fusion | **Weak** | No merge-first map above 5k ever |
| **Evolve** | BRAINROT EVOLUTION (njay), EVOLVE A BRAINROT, Evolution Tycoon: no numbers found; evolve-as-transform exists in BE A BRAINROT | **Weak / unknown** | No numbers surfaced |
| **Breed** | None found in searches | **Not present (no evidence)** | — |
| **Pet-sim / egg-hatch** | Pet Simulator ripstu (1,835 ATP; 442 on 2026-08-28), Hatch a Pet, Steal an Egg: n/a | **Weak** | Leader under 2k all-time |
| **Obby** | Pure brainrot obbies ≤1.2k ATP; the "Go Up" jump-obby-tycoon hybrid is huge | **Pure obby weak. Obby-tycoon hybrid saturated** | — |
| **Racing** | BRAIN ROT RACE, Race Your Lucky Block: no numbers | **Not present / unknown** (Epic's own Rocket Racing occupies the genre) | — |
| **Quiz** | 3+ brainrot quiz maps, no numbers | **Weak / unknown** | — |
| **Idle** | Offline earnings are a feature of nearly every tycoon. No standalone idle map found | **Present only as a feature** | — |
| **Survival (99 Nights, Roblox mega-hit)** | Clones peaked at 2,653 / 2,054 in mid-2025 | **Not present (failed)** | — |

### Cited Findings
- Roblox's 2025 mega-hits Grow a Garden, Steal a Brainrot and 99 Nights in the Forest *each* had more monthly engagement than Fortnite Battle Royale. Creator-made content is about 40% of Fortnite platform share. Fortnite's active creator count fell slightly since 2024 while published maps more than doubled — [Naavik, State of UGC Games 2026](https://naavik.co/deep-dives/the-state-of-ugc-games-2026/)
- Grow-a-Garden clones on Fortnite peaked at 628 (2025-06-28), 999 (2025-06-20) and 634 (mid-Sep 2026). Garden vs Brainrots peaked at 36,451 (2025-11-23). Berry Garden Tycoon peaked at 9,930 (2026-09-26) — [fortnite.gg search results](https://fortnite.gg/island?code=0497-4522-9912), [Berry Garden](https://fortnite.gg/island/2557-3355-0240)
- 99 Nights clones peaked at 2,054 and 2,653 in summer 2025 — [fortnite.gg](https://fortnite.gg/island?code=4580-8774-4615), [fortnite.gg](https://fortnite.gg/island/5424-8482-6958)
- Epic says in its documentation that islands highly similar to an existing experience are shown less often in Discover. The Developer Rules forbid copying other islands' titles, thumbnails and descriptions — [Epic: How Discover Works](https://dev.epicgames.com/documentation/fortnite/how-discover-works-in-fortnite); [Fortnite Developer Rules](https://legal.epicgames.com/fortnite/developer-rules)
- The remaining loop-level numbers are in the matrix above, each linked to fortnite.gg in the inventory table.

### Inferences
- **The best gap candidates (ESTIMATED): merge-first, breed, evolve, pet-sim/egg-hatch and pure RNG.** Each is proven on Roblox, and each has at best a weak Fortnite leader (under 5k all-time, or no data). Pure RNG is weaker as a business because paid spins are banned (see below). It still works as a free progression loop.
- Epic's clone-demotion rule in Discover and the Spyder lawsuit both mean a **mechanically distinct hybrid** (e.g., merge + garden, breed + steal) is safer than a 1:1 clone of a Roblox title.
- The 30-day classifications are **ESTIMATED**. Rerun the API metrics to confirm them.

### Gaps
- True 30-day peaks per map were not measurable. Evolve, breed, quiz, racing and Spin For Brainrot have no CCU numbers at all.
- The fortnite.gg tag pages (e.g., "simulator", "tycoon") could not be opened, so I could not count maps per tag.

## How big is the brainrot/simulator category in Fortnite, and what failed?

### Takeaway
Brainrot tycoon-simulators are the largest creator-made genre in Fortnite in 2025–26. They briefly beat Battle Royale's CCU, and in a games.gg snapshot 2–3 of the Top-10 creator maps were brainrot or tycoon titles. The genre is also where Epic's rule changes landed: it produced the platform's first loot-box and prize-wheel backlash (leading to the 2026-01-20 ban on paid prize wheels), a copyright lawsuit that took down one clone, and a steady stream of disabled maps.

### Cited Findings: category size
- Steal the Brainrot's CCU wave peaks at times topped Battle Royale. Example: 183k on a Sunday while BR had 300k+ in total, so the effect "operates in waves" — [Hotspawn](https://www.hotspawn.com/fortnite/news/brainrot-fortnite-maps-popular); [GameSpot](https://www.gamespot.com/articles/a-brainrotted-roblox-clone-is-dominating-the-fortnite-charts/1100-6534047/); [Sportskeeda](https://www.sportskeeda.com/fortnite/fortnite-battle-royale-losing-ground-viral-creative-map)
- In December 2025 Steal the Brainrot was the first creator island to pass Epic's BR on key weekends (>1M CCU) — search summary citing [fortnite.gg](https://fortnite.gg/island/3225-0366-8885) and [PCGamesN](https://www.pcgamesn.com/fortnite/creative-steal-the-brainrot-roblox-clone-1-million-players)
- Three tycoon maps (Droid Tycoon, Steal the Brainrot, Go Up for Brainrots) "sitting in Fortnite's Top 10 for weeks" — [games.gg](https://games.gg/news/fortnite-creative-tycoon-genre-rising/); [GameSpot: "Fortnite Creative Finally Has A Genre People Want To Play"](https://www.gamespot.com/articles/fortnite-creative-finally-has-a-genre-people-want-to-play/)
- fortnite.gg platform snapshot (undated): 5,031 maps being played at that moment, 545,352 maps in total — [fortnite.gg player-count](https://fortnite.gg/player-count?pa=)
- Epic sold its own Italian-brainrot skins from April 1 (Tung Tung Tung Sahur, Ballerina Cappuccina; 1,500 V-Bucks each, bundle 2,400). Mementum Labs claims ownership of Tung Tung Tung Sahur, licensed from its creator Noxa. The launch caused backlash over AI-generated IP — [GamesBeat](https://gamesbeat.com/who-owns-brainrot-fortnite-skin-launch-renews-creator-community-debate-over-ai-generated-ip/); [PCGamesN](https://www.pcgamesn.com/fortnite/brainrot-bundle)

### Cited Findings: failures, takedowns, rule changes
- **Stealing Brainrots (VastHorizon / Thomas Van Der Voort):** an unlicensed clone sued in October 2025 by Spyder Games (DoBig Studios) in California district court. The suit alleges a "wholesale copy" of art, gameplay and some visual assets. The map was taken down. The licensed "Steal the Brainrot" was *not* the target; a typo in the filing was later corrected — [TheGamer](https://www.thegamer.com/roblox-steal-a-brainrot-fortnite-stealing-brainrots-lawsuit/); [Pocket Tactics](https://www.pockettactics.com/fortnite/steal-the-brainrot-lawsuit); [Aftermath correction](https://aftermath.site/brainrot-roblox-court/); [GameRant](https://gamerant.com/roblox-steal-a-brainrot-dev-sues-fortnite-copycat/). HYPEX X post (ID decodes to 2025-10-24) — [X](https://x.com/HYPEX/status/1981755342850580916)
- **A separate Dexerto report says Fortnite map creators were sued for allegedly using bots to make real money.** I could not open the article to check which map or creators — [Dexerto](https://www.dexerto.com/fortnite/fortnite-map-creators-sued-after-allegedly-using-bots-to-make-real-money-3263453/)
- **Steal the Brainrot temporary takedown:** FNBRintel reported that Epic had taken it down (X post ID decodes to 2025-11-02). Epic's policy is that misleading maps are removed and V-Bucks refunded, and Steal the Brainrot purchases were refunded. A creator said a buggy build had removed new brainrots and the map was down while that was fixed. It came back with its microtransactions intact — [FNBRintel on X](https://x.com/FNBRintel/status/1985023924342554786); [VideoGamer](https://www.videogamer.com/news/fortnite-creative-steal-the-brainrot-removed/); [Techwiser](https://techwiser.com/did-fortnite-remove-steal-the-brainrot-what-happened-to-v-bucks/). **Conflict:** VideoGamer calls the takedown unexplained, while Techwiser relays the creator's bug explanation. The VideoGamer timing ("two months after July release") also sits oddly with the Jan 2026 monetisation story. Treat the exact date as uncertain.
- **Monetisation backlash, then rule change:** Epic enabled in-island V-Bucks purchases on 2026-01-09. Within 24 hours Steal the Brainrot sold a 4,900 V-Bucks (~$37) "Present Rot" bundle, loot boxes and a prize wheel priced at 100 V-Bucks per spin (200 for three; one free spin per 4 hours played). Epic then banned the sale of prize-wheel spins, and of anything that "directly or indirectly influence[s] prize wheels", effective 2026-01-20 — [PC Gamer](https://www.pcgamer.com/games/battle-royale/fortnite-bans-paid-prize-wheels-in-third-party-games-just-days-after-steal-the-brainrot-started-selling-them/); [GamesRadar](https://www.gamesradar.com/games/fortnite/fortnite-now-allows-in-game-purchases-in-user-generated-creative-maps-including-for-randomized-items-with-steal-the-brainrot-charging-at-least-usd37-for-a-loot-box-bundle/); [Forbes, 2026-01-13](https://www.forbes.com/sites/paultassi/2026/01/13/fortnite-players-angry-at-steal-the-brainrots-20-loot-boxes-gambling-wheel/); [Kotaku](https://kotaku.com/fortnite-steal-the-brainrot-gambling-vbucks-2000658885)
- **Maps fortnite.gg lists as "disabled"** (reason not shown): STEAL BRAINROTS FROM BRAINROTS (nitromaps, 2026-06-04), STEAL THE BRAINROT CHAOS (cracj19, 2026-03-13), Throw Brainrot 1V1 (kamitomo, 2026-07-04), BRAINROT 1V1 250+ SONGS (popcornstudio, 2025-12-01), FLAMETHROWER FOR BRAINROT (manzo, 2026-08-30), BRAINROT RED VS BLUE (1v1-v1, 2026-03-12), BRAINROT BASE DEFENSE (morzu, 2026-07-31) — [fortnite.gg](https://fortnite.gg/island/3275-9318-3999), [fortnite.gg](https://fortnite.gg/island/0962-7539-2061), [fortnite.gg](https://fortnite.gg/island/2766-0575-2301)
- **Launched and died:** PLANTS VS BRAINROTS [SIMULATOR] (peakgames) peaked at 179 (2025-11-09). ROLL A BRAINROT peaked at 755. Grow-a-Garden clones peaked at 600–1,000 in June 2025. 99 Nights clones peaked at 2–2.7k. GO FISHING! has 38.2M lifetime minutes but only 3 players now — see the table for sources.

### Inferences
- **Why maps die (ESTIMATED from patterns, not creator statements):**
  1. They arrive late to a trend already owned by an incumbent. The June 2025 Grow-a-Garden clones launched while the Roblox original peaked and never passed 1k.
  2. They are 1:1 clones that Discover demotes.
  3. They lack the licensed or recognisable brainrot IP that the leaders have.
  4. Live-ops stop. Every leader runs weekly events or codes, and every decayed map shows cliff-like drops.
  5. They get disabled for policy or IP reasons.
- The large number of short-lived "disabled" brainrot maps suggests high churn and moderation activity. **No reasons were discoverable.** fortnite.gg does not say whether a creator unpublished a map or Epic removed it.

### Gaps
- No public Epic statement listing brainrot-specific delistings was found, and the reasons for the "disabled" statuses are unknown.
- I could not read the Dexerto "bots / real money" lawsuit, the VideoGamer takedown article or the Hotspawn article in full (WebFetch blocked). Their details come from search snippets only.
- There is no category-share figure (e.g., "% of top-100 CCU that is brainrot/simulator"). This needs a manual fortnite.gg /creative or /player-count pass.
