# Bild-Prompts – Stil-Referenz „FUSE THE BRAINROT“

Zweck: grobe Stil-Referenz (nicht verbindlich). Quelle: GDD §4.4 (Arten), §4.2 (Seltenheiten), §11 (Art Direction).
Regeln: keine bekannten Brainrot-Figuren, kein „Fortnite“-Logo/-Skin, keine Marken im Prompt. Bilder sind nur interne Referenz, nicht fürs Thumbnail.
Ablage der fertigen Bilder im Projekt: `docs/style/` (Claude Code liest sie als Stil-Referenz).

---

## Prompt 1 – Gesamtansicht der Insel (Hauptbild)

```
Bird's-eye 3/4 aerial view of a round toy-like game island, stylized 3D video game screenshot look, bright and cheerful. In the center a circular pastel theme-park plaza (lavender-white stone #E8E2F7 paving, string lights) with a giant 18-meter "fusion machine" landmark statue: two big candy-colored funnels feeding into one capsule with a cartoon lightning bolt on top. Around the plaza a sandy ring road (#F2D8A7). On the outer ring, 16 identical square garden plots arranged evenly in a circle, each like a birthday-party toy diorama: green lawn (#7BD957), candy-stripe fences, six cookie-shaped round pedestals with colorful chunky cartoon creatures standing on them, a small egg vending machine, a nest with glowing eggs, a chunky fusion machine, a tall income totem and a glowing crystal core at the back. Beyond the plots: cotton-candy hills and fluffy cloud cliffs, turquoise water (#4FC3F7). Afternoon sun at 50 degrees, warm sunlight (#FFE6B0), soft blue sky (#5EC8FF to #CFF3FF), light lavender haze, mild bloom, saturated colors, soft purple-tinted shadows (#3B2A6B). Glossy toy-plastic and clay materials, rounded beveled edges, chunky readable shapes, clean low-to-mid poly stylized game art, no text, no UI.
```
Format: 16:9.

## Prompt 2 – Ein Plot aus Spielerperspektive

```
Third-person video game view standing at the gate of one square garden plot on a toy-like island, stylized 3D game art. The plot looks like a kids' birthday toy diorama: bright green lawn (#7BD957), candy-cane fences, a wooden sign at the gate. On the left a nest with three speckled glowing eggs and a chunky candy-colored egg vending machine with a big coin slot. On the right a big chunky "fusion machine" with two funnels and a capsule, sparks and lightning. In the middle a tall golden income totem with coins popping out. At the back six round cookie-shaped pedestals, each with a player-sized chunky cartoon creature (big glossy eyes, chibi proportions, head about 45% of body height): a waffle-iron mouse with syrup-bottle backpack, a pickle-jar frog, a red fire-hydrant bull, a noodle octopus on a pasta plate, a disco-ball llama, a rocket penguin in a tuxedo. Behind them a glowing crystal core and a purple portal from which small broken-toy enemies with grey-violet bodies (#6D6A86) and toxic-green glitch pixels (#9CFF3A) are walking in. Warm afternoon light, saturated, soft bloom, glossy plastic and clay materials, rounded edges, no text, no UI, no logos.
```
Format: 16:9.

## Prompt 3 – Figuren-Lineup (Model Sheet)

```
Character lineup sheet of 8 original cartoon creatures for a cheerful 3D game, standing side by side on a light lavender background (#E8E2F7), front 3/4 view, same height (player size), chunky glossy toy-plastic and clay look, rounded beveled edges, oversized shiny eyes in one consistent eye style, chibi proportions. 1) "Waffelino": mouse head with waffle-shaped ears, body is an open waffle iron on four stubby legs, syrup bottle backpack, colors #E8A94B and #7A4A1E. 2) "Frogurko": frog head shaped like a pickle with bulging eyes, body is a glass pickle jar with frog legs, dill crown, #6BBF3A and #D9F2B4. 3) "Idrantoro": bull head with valve-shaped horns, red fire-hydrant torso with short hooves, fire-hose scarf, #E53935 and #FFD54F. 4) "Tagliatakel": octopus head with a noodle-nest hairdo, pasta-plate cape with eight noodle arms, meatball necklace, #FFE08A and #E4572E. 5) "Diskolama": llama head with disco-ball fluff, mirrored wool body, platform sunglasses, #C9D6E3 and #FF4FD8. 6) "Razzopingu": penguin head with pilot goggles, rocket-shaped body in a tuxedo, jet-nozzle bow tie, #22263A and #FF7A1A. 7) "Wolkowal": whale head made of a storm cloud, cloud body with rain veil, rainbow umbrella, #7E8BA8 and #FFF36B. 8) "Bzzkoffro": bumblebee head with travel hat, striped hard-shell suitcase body, customs-sticker wings, #FFC107 and #3E2723. Each silhouette clearly distinct and readable from far away. Soft studio lighting, no text labels, no logos.
```
Format: 16:9 oder 21:9.

## Prompt 4 – Fusion + Seltenheiten (Reveal-Moment)

```
Stylized 3D game moment: a chunky candy-colored fusion machine glowing and shooting sparks, in front of it a newly fused hybrid cartoon creature revealed on a cookie pedestal: the head of a disco-ball llama on the body of a red fire-hydrant bull, wearing a noodle-octopus meatball necklace, all parts clearly from different creatures, glossy toy-plastic look, big shiny eyes. The hybrid is rendered in a "legendary" style: shiny gold material and a floating golden crown, golden light beam from above, confetti and sparkle particles, slight slow-motion feel. Background: toy-diorama garden plot, warm afternoon light, saturated colors, bloom. No text, no UI, no logos.
```
Format: 16:9.
Seltenheits-Looks (zum Austauschen im Prompt): gewöhnlich = matte grey-blue plastic (#B8C2CC) · ungewöhnlich = neon green glowing edges (#5BD45B) · selten = shiny blue-tinted gold metallic (#3AA0FF Akzent) · episch = semi-transparent purple crystal (#B056FF) · legendär = gold + floating crown (#FFB319) · mythisch = pink aura with particle trail (#FF3D6E) · geheim = cosmic starfield material with cyan-to-magenta halo (#00E5FF → #FF3DF2) on near-black.

## Prompt 5 – Server-Boss im Hub (optional)

```
Stylized 3D game scene: a giant 30-meter boss made of broken toys and glitch pixels (grey-violet #6D6A86 with toxic-green glitch edges #9CFF3A) landing in the center of a round pastel theme-park plaza next to a huge fusion-machine statue. Around it dozens of small colorful chunky cartoon creatures (waffle-iron mice, pickle-jar frogs, hydrant bulls, rocket penguins) attacking together with lightning, noodles and sparkles; a glowing ring zone on the ground. Bright afternoon light, epic but cheerful, saturated, bloom, glossy toy materials. No text, no UI, no logos.
```

---

## Negativ-Prompt (wenn der Generator ein Feld dafür hat)

```
realistic, photorealistic, gritty, dark, horror, blood, weapons, guns, text, letters, watermark, logo, UI, HUD, Fortnite characters, existing brand characters, anime, sketch, low contrast, muddy colors, cluttered
```

## Tipps
- Generator ohne Hex-Codes-Verständnis: Hex weglassen, Farbwörter reichen.
- Pro Prompt 4 Varianten erzeugen, das beste 1 Bild behalten.
- Bilder sind **Stil-Ziel**, keine Bauvorlage: Maße und Layout gelten aus GDD §11. Die echten Figuren entstehen per Blender-Skript und werden einfacher aussehen (Low-Poly, Bevel).
- Für Claude Code: Bilder nach `docs/style/01_insel.png`, `02_plot.png`, `03_lineup.png`, `04_fusion.png`, `05_boss.png` legen und in `_context/entscheidungen.md` eintragen: „Stil-Referenz: docs/style/ (nicht verbindlich, GDD §11 hat Vorrang)“.
