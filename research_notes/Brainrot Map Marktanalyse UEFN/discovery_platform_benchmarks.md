# Fortnite Discovery, Platform Mix, Metadata/Thumbnail Practice & Genre Benchmarks (for a brainrot-style simulator launching ~Dec 2026)

Research date: 2026-09-29. Research method note (important for the report writer):
- **All direct page fetches failed** because the sandbox's egress proxy blocks fortnite.gg, api.fortnite.com (Ecosystem API), dev.epicgames.com, www.fortnite.com, vice.com, gamesbeat.com and fnanalytica.com (EGRESS_BLOCKED). **No Ecosystem API pulls were possible.**
- Every figure below therefore comes from **web-search result snippets** of the linked pages (search index date unknown, usually recent). They have not been checked against the full page. Labels:
  - MEASURED-SNIPPET = a measured stat shown on a tracker page (fortnite.gg), read from the search snippet only
  - CLAIMED = stated by a publisher, creator or blog
  - OFFICIAL = stated by Epic in its docs or news
  - ESTIMATED = my own inference
- Before any number goes into a KPI plan, recheck it on fortnite.gg or the Ecosystem API from a network that allows those hosts.

## 1. Platform mix and UI implications

### Takeaway
I found no reliable, current, official breakdown of Fortnite players by platform. The published figures are old or come from aggregators. Console is still described as the largest platform. Mobile has been back on iOS (US/EU) since 2025 and Creative runs on Switch 2. A brainrot simulator aimed at young players must therefore work well with a controller and with touch from day one.

### Cited Findings
- Aggregator claim: 78% of players "prefer" console, ~31% PC, ~23% mobile (multi-device, so it sums to more than 100%). Also PS4 46.8% of revenue, Xbox One 27.5%, Switch+Android+PC 18.7%. These are old, poorly sourced figures (the revenue split looks like 2018-era data). CLAIMED — [Techjury, Fortnite Usage Statistics 2025](https://techjury.net/industry-analysis/fortnite-usage-statistics/)
- Revenue split of about 60% console, 25% PC, 15% mobile, explicitly "pre-2021". Around 110M MAU in early 2026. CLAIMED — [Business of Apps, Fortnite statistics 2026](https://www.businessofapps.com/data/fortnite-statistics/) / [Tekrevol](https://www.tekrevol.com/blogs/fortnite-revenue-usage-statistics/)
- Through Feb 2026, Fortnite was played by 35% of US PlayStation players and 31% of US Xbox players. Average monthly PS engagement fell from 21 h to 16 h year over year, and Xbox from 19 h to 15 h. CLAIMED (appears to be Circana-type data, reported via aggregator) — [Business of Apps](https://www.businessofapps.com/data/fortnite-statistics/)
- Tim Sweeney's March 2026 memo tied layoffs of more than 1,000 staff to a Fortnite engagement downturn that began in 2025. CLAIMED/REPORTED — [GamesRadar](https://www.gamesradar.com/games/fortnite/epic-games-lays-off-over-1-000-people-ceo-tim-sweeney-says-im-sorry-were-here-again-and-blames-the-downturn-in-fortnite-engagement/)
- Fortnite returned to the iOS App Store in the US in May 2025 and was available again in the EU in 2025. On Android it is distributed via the Epic Games app and the Samsung Galaxy Store. REPORTED — [esports.net](https://www.esports.net/news/fortnite/fortnite-mobile-us-return/); [recharge.com](https://www.recharge.com/en/gb/fortnite/infos/fortnite-on-mobile); [Last Word on Gaming, 2025-05-26](https://lastwordongaming.com/2025/05/26/fortnite-returns-to-mobile/)
- Fortnite Creative is available on Nintendo Switch 2 (launched 2025-06-05/06). REPORTED — [Wikipedia: Fortnite Creative](https://en.wikipedia.org/wiki/Fortnite_Creative)
- The Sponsored Row appears on PlayStation, Xbox, PC, Android, iOS and iPadOS, and is **not shown to players under 18**. OFFICIAL — [Fortnite news: Sponsored Row campaign tools](https://www.fortnite.com/news/sponsored-row-campaign-tools-now-in-the-fortnite-creator-portal?lang=en-US)

### Inferences
- ESTIMATED: Console (PS + Xbox + Switch/Switch 2) is probably still the largest share of playtime. Mobile (iOS + Android) is probably a meaningful and growing minority among younger players. No reliable percentage exists, so the plan should use the Creator Portal's per-platform analytics after launch rather than assume one.
- UI requirements (ESTIMATED from the platform list):
  - All interactions must work with a controller: large buttons that can be reached by focus navigation, and no mouse-only UI.
  - Tap targets on phones must be at least about 1 cm, with nothing critical close to the screen edges. The HUD must stay readable at 720p on Switch.
  - Keep performance within the budget for Switch 1/2 and low-end Android: low prop and particle counts, and few Verse per-frame loops.
  - Avoid tiny text. Use icon-first prompts.
- Most of the young brainrot audience is under 18, so the Sponsored Row is useless for reaching them. Organic Discover and social video matter more.

### Gaps
- No official Epic breakdown of players or playtime by platform for 2025–2026, and none for UGC or brainrot maps specifically. The Creator Portal analytics may show a per-platform split for your own island, but I could not verify this.
- No data on the Switch 2 player share, or on mobile share after iOS returned.

## 2. Discovery in 2026 (algorithm, rows, tags, testing, search)

### Takeaway
Discover ranks islands on per-player engagement signals: CTR, average playtime, retention, quality play-through rate and bounce, each compared against genre history. A new island gets a **testing window of up to 2 weeks**. Creators can A/B test two thumbnails. Keyword stuffing, near-duplicate clones and unoriginal thumbnails are downranked. A paid Sponsored Row now exists, but under-18s cannot see it.

### Cited Findings
- New islands: "When you publish a new island, Discover tests your content for up to 2 weeks" to gather data before wider distribution. OFFICIAL (Epic docs via snippet) — [How Discover Works in Fortnite (dev.epicgames.com)](https://dev.epicgames.com/documentation/fortnite/how-discover-works-in-fortnite)
- Engagement signals include playtime, bounce rate and quality play-through rate (QPTR), weighed against the historical performance distribution of other islands. Average Playtime, retention and QPTR are evaluated per player, "so deep engagement can even outperform a large audience." OFFICIAL/snippet — [How Discover Works](https://dev.epicgames.com/documentation/fortnite/how-discover-works-in-fortnite); related: [Fortnite news: How Fortnite Discover works](https://www.fortnite.com/news/how-fortnite-discover-works)
- CTR is defined as clicks divided by impressions (e.g. 5 clicks on 100 impressions = 5%). Thumbnail A/B testing in the Creator Portal: two variants, split 50/50, running for at most 90 days, with the winner judged by CTR. OFFICIAL — [A/B Thumbnail Testing (Epic docs)](https://dev.epicgames.com/documentation/en-us/fortnite/ab-thumbnail-testing-in-fortnite-creative); [Fortnite news: A/B test thumbnails](https://www.fortnite.com/news/ab-test-thumbnails-to-optimize-player-engagement-in-your-fortnite-islands)
- The Creator Portal gives a personalized view of Discover performance (impressions, CTR per surface) and published project analytics. OFFICIAL — [Get a Personalized View of Your Island's Discover Performance](https://www.fortnite.com/news/get-a-personalized-view-of-your-fortnite-island-s-discover-performance?team=personal); [Project Analytics docs](https://dev.epicgames.com/documentation/fortnite/project-analytics-for-fortnite-games?lang=en-US); [Creator Portal updates June 2025](https://www.fortnite.com/news/creator-portal-updates-and-insights-for-fortnite-island-success---june-2025?lang=en-US)
- Anti-spam measures:
  - Islands that are highly similar to earlier-published games are downranked.
  - Thumbnails face stricter originality pre-checks.
  - Keyword stuffing and inaccurate titles lead to downranking.
  - An island can appear in only one genre row. Genre is separate from tags.

  OFFICIAL (snippet) — [Fortnite news: Big Changes for Discover](https://www.fortnite.com/news/big-changes-for-discover)
- Up to 4 tags per island, plus a title and up to 3 descriptions. Tags describe gameplay or theme. OFFICIAL — [Games and Game Tags in Fortnite Creative](https://dev.epicgames.com/documentation/en-us/fortnite-creative/games-and-game-tags-in-fortnite-creative); [Changing island description settings](https://www.fortnite.com/fortnite/en-US/creative/docs/changing-my-island-description-settings-in-fortnite-creative)
- A "Recently Released" Discover row exists for new islands. OFFICIAL — [Introducing the Recently Released Discover Row](https://fortnite.com/fortnite/en-US/news/introducing-the-recently-released-discover-row-in-fortnite)
- Sponsored Row:
  - Creators bid for placement through the Creator Portal. The row went live on Nov 21 (year per the article, most likely 2025).
  - From launch through the end of 2026, 100% of sponsorship revenue goes to the engagement payout pool. The long-term rate is 50%.
  - Under-18s do not see the row. All other rows are unchanged.

  OFFICIAL — [Sponsored Row tools](https://www.fortnite.com/news/sponsored-row-campaign-tools-now-in-the-fortnite-creator-portal?lang=en-US); [GameSpot](https://www.gamespot.com/articles/fortnite-creators-will-soon-be-able-to-sell-in-game-items-pay-for-visibility/1100-6534859/)
- At Unreal Fest 2026 (Chicago), Epic unveiled a new Discover system. It "boosts" some islands, using analytics to decide whether an island needs an extra push, and is modeled on streaming platforms like HBO Max. REPORTED (search summary; full article not fetched) — [GamesBeat](https://gamesbeat.com/why-fortnites-new-discover-system-is-taking-cues-from-streaming-platforms-like-hbo-max/)
- Players can search by island code, island name or creator. OFFICIAL — [Epic Help: How can I search for an island](https://www.epicgames.com/help/c-202300000001636/c-202300000001721/a202300000010419?lang=en-US)
- Creator-built islands captured 47% of all Fortnite player hours in May 2026, up from about 35% a year earlier. CLAIMED (secondary article citing Epic) — [Tech Insider](https://tech-insider.org/ca/fortnite-creator-economy-1-billion-2026/)

### Inferences
- ESTIMATED: The 2-week test window is where the launch is won or lost. Friends-and-family soft launches, CCU seeding by creators and social pushes should happen *inside* this window, not before publishing.
- ESTIMATED: The brainrot genre is saturated with near-clones (see §4). The "similar to earlier islands" downranking means a copy titled "Steal the Brainrot 2" will likely be penalized. It needs a distinct mechanic, name and thumbnail.
- ESTIMATED: The title should hold the 1–2 search keywords ("Brainrot" plus a verb like Steal/Grow/Escape/Tycoon). Search results for brainrot are dominated by exactly this pattern (see §3/§4). Tags should cover the Simulation/Tycoon genre plus a theme tag.

### Gaps
- No public keyword or search-volume data for Fortnite in-game search. I found no tool that exposes what players type. fortnite.gg ranks by players, not by search terms. The frequency of "brainrot/steal/tycoon" in island titles is only a proxy.
- The exact weights of CTR vs. playtime vs. retention are not published.
- I could not read the details of the Unreal Fest 2026 Discover system or any "Game Collections" feature, because the pages were blocked.

## 3. Thumbnails and titles

### Takeaway
Epic's rules require thumbnails and titles to be accurate. They ban mentioning or depicting V-Bucks, the Battle Pass or real money, and ban reward-bait terms such as "XP", "AFK" and "Coin farm". Successful brainrot titles follow a formula: **VERB + (THE) BRAINROT**, in capitals, sometimes with an emoji or a "+1" prefix. General high-CTR practice is one clear big subject, visible emotion, saturated colors and strong contrast. Epic offers native A/B testing to validate choices.

### Cited Findings
- Promotional assets (thumbnail, title, description) must accurately represent the island. You must not mention V-Bucks, the Battle Pass, real-world currency or rewards, and must not show V-Bucks or currency in thumbnails. The terms "AFK", "XP", "Coin farm" and "Coin slide" are banned in the name, description, thumbnail, loading screen and lobby background. Violations can lead to removal or hiding from Discover. OFFICIAL — [Fortnite Developer Rules](https://legal.epicgames.com/fortnite/developer-rules); [Thumbnail Image Policies](https://dev.epicgames.com/documentation/fortnite/thumbnail-image-policies?lang=en-US); [Island Creator Rules](https://www.fortnite.com/news/fortnite-creative-creator-content-rules-and-guidelines); [PCGamesN on the XP-misleading rule](https://www.pcgamesn.com/fortnite/island-changes); [Change log](https://legal.epicgames.com/fortnite/developer-rules-change-log)
- Epic's advice: the thumbnail is the first impression. Use high-quality, eye-catching images that accurately show the gameplay, and take high-quality screenshots of the island's best aspects. OFFICIAL — [Best Practices for Islands Featured in Discover](https://www.fortnite.com/news/best-practices-for-fortnite-islands-featured-in-discover?team=personal)
- Stricter originality pre-checks now apply to thumbnails. OFFICIAL — [Big Changes for Discover](https://www.fortnite.com/news/big-changes-for-discover)
- General Fortnite-thumbnail CTR advice: a clear subject, visible emotion (shock, hype, panic) and strong contrast (bright subject on a dark background), with about "three seconds to win attention." CLAIMED (design-tool blogs, aimed at YouTube thumbnails, not Discover) — [Simplified](https://simplified.com/blog/ai-design/fortnite-thumbnail-that-impossible-to-ignore); [1of10](https://1of10.com/blog/fortnite-thumbnail-maker-how-to-create-high-ctr-gaming-thumbnails-with-ai/)
- Title patterns seen among top brainrot islands on fortnite.gg (MEASURED-SNIPPET, titles as listed):
  - "STEAL THE BRAINROT" (ferins)
  - "GO UP FOR BRAINROTS" (ferins)
  - "Fight The Brainrot" (neverty7)
  - "GROW THE BRAINROT" (takuman_kamikz)
  - "STEAL BRAINROTS FROM BRAINROTS" (nitromaps)
  - "BE A BRAINROT" (nitromaps)
  - "BEAT THE BRAINROT" (post)
  - "+1 Escape a Brainrot" (stanni)
  - "OPEN SEA FOR BRAINROT - UNC"
  - "Brainrot Card Tycoon" (pwr)
  - "TUNG TUNG TYCOON"

  Sources: [fortnite.gg 3225-0366-8885](https://fortnite.gg/island/3225-0366-8885), [7875-7934-3852](https://fortnite.gg/island/7875-7934-3852), [6980-2761-9936](https://fortnite.gg/island/6980-2761-9936), [0017-2877-1308](https://fortnite.gg/island/0017-2877-1308), [3275-9318-3999](https://fortnite.gg/island/3275-9318-3999), [6931-5304-1207](https://fortnite.gg/island/6931-5304-1207), [1796-9956-7050](https://fortnite.gg/island/1796-9956-7050), [8344-0475-7589](https://fortnite.gg/island/8344-0475-7589), [8476-4256-2100](https://fortnite.gg/island/8476-4256-2100), [7672-1003-7237](https://fortnite.gg/island/7672-1003-7237), [5195-2546-6742](https://fortnite.gg/island/5195-2546-6742)
- Steal the Brainrot added randomized "Present Rot" paid bundles of up to 4,900 V-Bucks within 24 h of in-island transactions going live on Jan 9 (2026). This drew player backlash as "gambling". REPORTED — [Notebookcheck](https://www.notebookcheck.net/Fortnite-players-slam-Steal-the-Brainrot-microtransactions-as-gambling.1205005.0.html)

### Inferences
- ESTIMATED title recipe: a short action verb plus "BRAINROT(S)" plus a unique twist noun (e.g. "GROW THE BRAINROT", "+1 … Brainrot"), 2–5 words, in capitals. Avoid "XP/AFK/free/V-Bucks" and never promise rewards. Put the unique mechanic in the title or thumbnail so the island is not classed as a clone.
- ESTIMATED thumbnail recipe (visual analysis was **not** possible because images were blocked):
  - One or two large brainrot-style characters, which must be **original** designs because Italian-brainrot meme characters raise IP and originality risk.
  - The player character reacting with a big emotion.
  - Saturated background with a strong hue contrast, and at most 2–3 words of text.
  - Must be readable at mobile tile size.
  - Test 2 variants from day 1 with the native A/B tool.
- ESTIMATED: The loot-box backlash is a risk signal. Randomized paid items aimed at a young audience invite rule and reputation trouble, so use transparent item sales.

### Gaps
- I could not view the actual thumbnail images, so no verified visual-pattern analysis exists. Someone needs to screenshot the top 10 brainrot tiles on fortnite.gg manually.
- The exact thumbnail spec (resolution, aspect ratio, text limits) could not be read from Epic's policy page.

## 4. Genre benchmarks (simulator / tycoon / brainrot)

### Takeaway
Real Ecosystem API pulls were impossible because the host is blocked. From fortnite.gg snippets, the **Simulation & Tycoon genre median is about 12–13% D1 and 4–5% D7, and the 90th percentile is about 24–26% D1 and 13–19% D7**. Steal the Brainrot showed about 67 min average playtime (98th percentile in the genre) but only about 10% D1 and 3% D7. Brainrot peaks range from about 7k to 1M+ CCU.

### Cited Findings (all MEASURED-SNIPPET unless noted; snapshot date = search index, roughly Sep 2026)
- **Genre benchmark, Simulation & Tycoon** (fortnite.gg benchmark shown on island pages):
  - Median D1 12%, 90th-percentile D1 24%; median D7 4%, 90th-percentile D7 13% — [Star Wars Droid Tycoon 7865-8305-9184](https://fortnite.gg/island/7865-8305-9184)
  - A second page shows median D1 13%, P90 26%; median D7 5%, P90 19% (probably a different snapshot or date) — [MINING SIMULATOR 1477-2361-8593](https://fortnite.gg/island/1477-2361-8593)
- **STEAL THE BRAINROT (ferins, 3225-0366-8885):**
  - D1 9.87%, D7 3.28%
  - Average playtime 66.7 min (98th percentile in Simulation & Tycoon), average session 12.82 min
  - 12,379 players "now" at snippet time

  The snippet's "D1 71% / D7 54%" for a "top-performing version" is suspect and was probably misparsed. — [fortnite.gg](https://fortnite.gg/island/3225-0366-8885)
  - Peak CCU is reported inconsistently:
    - 400k, breaking Super Red vs Blue's 235k record (May 2025) — [GameSpot](https://www.gamespot.com/articles/a-brainrotted-roblox-clone-is-dominating-the-fortnite-charts/1100-6534047/), [Pocket Tactics](https://www.pockettactics.com/fortnite/steal-a-brainrot)
    - About 500k on Sep 13 and 542k on Sep 14 (2025) — [Dexerto](https://www.dexerto.com/gaming/steal-a-brainrot-smashes-records-with-nearly-24-million-players-across-roblox-and-fortnite-3250973/)
    - Over 1M, the first Creative map to do so — [PCGamesN](https://www.pcgamesn.com/fortnite/creative-steal-the-brainrot-roblox-clone-1-million-players)

    All REPORTED. These are different dates of a rising peak, not a conflict of fact.
- **Brainrot Card Tycoon (7672-1003-7237):** D1 48%, D7 39% (unusually high, probably a small cohort). All-time peak 11,597 on 2026-07-26 — [fortnite.gg](https://fortnite.gg/island/7672-1003-7237)
- **Pet Tycoon (9447-9726-2272, unc):** D1 20%, D7 2% — [fortnite.gg](https://fortnite.gg/island/9447-9726-2272)
- **Star Wars Droid Tycoon:** the snippet says 70% D1 and 65% D7. This is implausible and is probably a percentile rank or a misparse. Do NOT use it. — [fortnite.gg](https://fortnite.gg/island/7865-8305-9184)
- **Peak CCU (all-time) for other brainrot islands:**

  | Island | Code | Creator | All-time peak | Date |
  |---|---|---|---|---|
  | GO UP FOR BRAINROTS | 7875-7934-3852 | ferins | 362,337 | 2026-05-17 |
  | Fight The Brainrot | 6980-2761-9936 | — | 211,831 | 2026-08-29 |
  | GROW THE BRAINROT | 0017-2877-1308 | — | 53,218 | 2026-09-23 |
  | Brainrot Card Tycoon | — | — | 11,597 | 2026-07-26 |
  | STEAL BRAINROTS FROM BRAINROTS | 3275-9318-3999 | nitromaps | 10,087 | 2026-02-21 |
  | +1 Escape a Brainrot | 8344-0475-7589 | stanni | 9,042 | 2026-09-05 |
  | BEAT THE BRAINROT | 1796-9956-7050 | — | 7,325 | 2026-09-12 |

  Sources: [7875-7934-3852](https://fortnite.gg/island/7875-7934-3852); [6980-2761-9936](https://fortnite.gg/island/6980-2761-9936); [0017-2877-1308](https://fortnite.gg/island/0017-2877-1308); [7672-1003-7237](https://fortnite.gg/island/7672-1003-7237); [3275-9318-3999](https://fortnite.gg/island/3275-9318-3999); [8344-0475-7589](https://fortnite.gg/island/8344-0475-7589); [1796-9956-7050](https://fortnite.gg/island/1796-9956-7050)
- **Other tycoon/simulator islands to benchmark later** (pages found, metrics not extracted):
  - [Mining Simulator Tycoon 3697-4304-5603](https://fortnite.gg/island?code=3697-4304-5603)
  - [FAMOUS TYCOON 3 0722-1566-1361](https://fortnite.gg/island/0722-1566-1361)
  - [PET TYCOON 8396-9258-5687](https://fortnite.gg/island/8396-9258-5687)
  - [FORTNITE TYCOON 2 1314-1221-7678](https://fortnite.gg/island/1314-1221-7678)
  - [TUNG TUNG TYCOON 5195-2546-6742](https://fortnite.gg/island/5195-2546-6742)
  - [RESTAURANT SIMULATOR 2007-4387-0287](https://fortnite.gg/island/2007-4387-0287)
- **Economy context** (all CLAIMED):
  - Epic had paid creators more than $1B by 2026-06-17, and $722M by Sep 2025 — [Tech Insider](https://tech-insider.org/ca/fortnite-creator-economy-1-billion-2026/)
  - Creators get 100% of the V-Bucks value of in-island sales from Dec 2025 through end-2026, about 74% of retail — same source; see also [Naavik State of UGC 2026](https://naavik.co/deep-dives/the-state-of-ugc-games-2026/)

### Inferences
- ESTIMATED KPI targets for launch, relative to the genre benchmark snippets:

  | Metric | Pass / "median" | "Top-10%" target |
  |---|---|---|
  | D1 retention | at least 12–13% | 24%+ |
  | D7 retention | at least 4–5% | 13%+ |
  | Average playtime per player | at least 30 min (weakly sourced) | about 60 min (Steal the Brainrot level) |
  | CTR | unknown | unknown |

  No sourced CTR benchmark was found. Use the A/B tool to set your own baseline.
- ESTIMATED: Brainrot hits combine very high playtime with *low* D1/D7. They are fad-driven, which argues for a fast content-update cadence (new brainrots or rarities weekly) to fight churn.
- ESTIMATED: The CCU spread is extreme (7k to over 1M), and the originals by ferins dominate. A new entrant should plan for a "tail" outcome (5–50k peak) unless it has a distinct hook.

### Gaps
- The requirement of **8+ islands with verified D1, D7 and average playtime is only partly met**. Retention is available for 4 islands (Steal the Brainrot, Brainrot Card Tycoon, Pet Tycoon, plus one excluded as suspect) and average playtime for only 1. The API and fortnite.gg were blocked. A follow-up should pull `https://api.fortnite.com/ecosystem/v1/islands/<CODE>/metrics/day?from=<7 days back>` for the codes listed above from an allowed network.
- No sourced genre CTR, plays-per-day or bounce/QPTR benchmarks.

## 5. Marketing (short video, creator codes, launch tactics, Discord)

### Takeaway
Creator guides describe short video (TikTok/Shorts) as the main external discovery channel, supported by Discord cross-promotion and a Support-A-Creator code. The evidence is mostly how-to blogs, not measured case studies.

### Cited Findings
- Short, eye-catching clips of gameplay highlights, world records and funny moments work well with trending sounds and Fortnite hashtags. "A single viral TikTok [can] send tens of thousands of players to your map in 48 hours." CLAIMED — [Overwolf, Ultimate Guide to Promoting Your UEFN Map](https://blog.overwolf.com/the-ultimate-guide-to-promoting-your-fortnite-uefn-map-in-2024/); [Generalist Programmer, How to Become a Fortnite Map Creator 2026](https://generalistprogrammer.com/tutorials/how-to-become-fortnite-map-creator-complete-guide)
- Support-A-Creator (SAC) code eligibility needs 1,000+ followers on one social platform. The creator earns a share of the purchases made by players who use the code. CLAIMED — [Generalist Programmer, Monetization 2026](https://generalistprogrammer.com/tutorials/fortnite-creative-monetization-complete-revenue-guide)
- Join creator Discord servers, which have map-promo channels, and use map-to-map cross-promotion deals. CLAIMED — [Overwolf guide](https://blog.overwolf.com/the-ultimate-guide-to-promoting-your-fortnite-uefn-map-in-2024/)
- A developer's first-release write-up, useful for publishing steps. CLAIMED — [Chris McCole, Releasing our first UEFN game](https://www.chrismccole.com/blog/releasing-our-first-fortnite-uefn-game)
- TikTok has a topic hub for "how to promote Fortnite map". — [TikTok discover](https://www.tiktok.com/discover/how-to-promote-fortnite-map)

### Inferences
- ESTIMATED launch sequence:
  1. Publish.
  2. Seed CCU with friends and a Discord group in the first 48 h, inside the 2-week test window.
  3. Post daily 15–30 s vertical clips showing the "steal/rare pull" moment.
  4. Ship weekly content drops.
  5. Link a SAC code once 1k followers is reached.

### Gaps
- No measured case studies linking TikTok views to Fortnite plays.
- No data on the effectiveness of Discord or SAC codes.

## 6. Seasonal calendar Oct–Dec 2026 and launch window

### Takeaway
The calendar is: Fortnitemares Oct 1–31, Chapter 7 Season 4 ends around Oct 31/Nov 1, then a mini-season. Chapter 8 starts on **Nov 28 or Dec 5, 2026** (sources conflict). Winterfest starts around **Dec 17, 2026**. A launch in the week before Winterfest and the Christmas school holidays (roughly Dec 10–18) catches the holiday traffic peak. The alternative is to launch just after the Chapter 8 launch surge settles.

### Cited Findings
- Epic has confirmed Fortnitemares 2026 starts on Thursday Oct 1. The event is expected to run through Oct 31, with a mid-event update on Oct 15. CONFIRMED/REPORTED — [VICE: Fortnitemares 2026 date confirmed](https://www.vice.com/en/article/fortnitemares-2026-release-date-confirmed/); [Nintendo Life](https://www.nintendolife.com/guides/fortnite-fortnitemares-2026-release-date-time); [Insider Gaming](https://insider-gaming.com/fortnite-fortnitemares-2026-start-end-dates/)
- Chapter 7 Season 4 started on 2026-08-20. Its end date is given as Nov 1 ET by one source and Oct 31 by another. A mini-season is reported to start on Nov 1. REPORTED — [esportstales](https://www.esportstales.com/fortnite/chapter-season-end-date); [Fandom Ch7 S4](https://fortnite.fandom.com/wiki/Chapter_7:_Season_4)
- Chapter 8 (v44.00) launch dates:
  - Nov 28, 2026 per a leaked schedule — [VICE leaked schedule](https://www.vice.com/en/article/fortnite-update-schedule-2026-fortnitemares-chapter-8-dates/)
  - Dec 5, 2026 per another report — [esports.net](https://www.esports.net/wiki/guides/fortnite-chapter-8/)
  - [FRVR](https://frvr.com/blog/news/fortnite-chapter-8-release-date/) says Epic revealed the Chapter 8 date well in advance.

  CONFLICTING/LEAKED.
- Winterfest 2026 is reported to start on 2026-12-17 (LEAKED). Winterfest usually runs from December into January. — [VICE leaked schedule](https://www.vice.com/en/article/fortnite-update-schedule-2026-fortnitemares-chapter-8-dates/); [Fandom Winterfest](https://fortnite.fandom.com/wiki/Winterfest)

### Inferences
- ESTIMATED:
  - Avoid launching on the day of the Chapter 8 launch. BR attention peaks then, and Epic features its own content.
  - Target publishing about Dec 8–15, 2026. This lets the 2-week Discover test window overlap Winterfest (Dec 17 onward) and the Christmas school holidays (in DACH, UK and US, typically about Dec 19/23 to Jan 6).
  - Prepare a Winterfest/Christmas-themed thumbnail variant and content drop for Dec 17–24.
- ESTIMATED: A Halloween-themed soft beta in late October is possible but conflicts with a December release.

### Gaps
- Chapter 8 and Winterfest dates are leaks or reports, not official Epic announcements. Recheck in November.
- School-holiday dates are general knowledge and were not sourced. Verify per target country.
