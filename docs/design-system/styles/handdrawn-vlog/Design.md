# Hand-drawn Vlog / Vlog 手绘风

## Style Identity

- **Status**: Style documented and implemented under `Mira/Features/Styles/HanddrawnVlog/` (home preview card + bespoke detail page: a diary/scrapbook feed with a tap-to-flip polaroid memory board).
- **Definition**: Hand-drawn Vlog is a Korean film-diary cute style. A warm cream "paper" page holds a hand-placed polaroid (a faded-film photo with a handwritten date), and hand-drawn doodles, washi tape, and restrained stickers decorate it like a `다꾸` / 手账 vlog spread.
- **Core Feeling**: 温柔、治愈、有手作温度的可爱;像韩系生活博主的胶片日记手账,而非高饱和糖果卡哇伊。
- **Visual Keywords**: cream paper, faded film tones, polaroid / instant photo, handwriting, washi tape, hand-drawn doodles (sun, stars, hearts, wavy lines), a little mascot, gentle tilt, warm grain.
- **iOS Interpretation**: Use warm cream SwiftUI surfaces, muted dusty accents, `.system(design: .rounded)` for friendly type, a handwriting font for short captions/dates, and `Path`/`Canvas`-drawn doodles for the hand-drawn signature. The charm comes from paper, film tone, framing, handwriting, and restraint, not from saturation or heavy effects.

## Best Use Cases

- Suitable screens: diary / journal feeds, lifestyle & travel logs, photo collections, memory/timeline, gentle onboarding, profile.
- Suitable product moods: cozy, warm, personal, playful-but-calm, lifestyle, K-culture.
- Suitable content types: photos, short handwritten captions, dates, moods, small notes, sticker reactions.
- Best audience fit: lifestyle, journaling, photo, K-pop / K-culture, Gen-Z and young-adult consumer apps.

## Avoid When

- Do not use for: dense data tools, dashboards, finance/enterprise, high-frequency utility flows.
- Risky contexts: tiny dense controls, heavy forms, long technical text, content with no imagery.
- Accessibility concerns: handwriting font legibility at small sizes; low-contrast dusty accents used as text; over-rotation hurting readability and tap targets.
- Product mismatch: serious B2B, brutalist, neon/tech, or anything that needs crisp neutrality.

## Visual Tokens

> Taste guardrail: this is a **faded-film** palette, not bright candy pastels. The warm cream/paper family is intrinsic to the Korean film-diary `감성` aesthetic (justified, not a default "warm-craft" reach), and it is paired with **muted dusty** accents, never brass/oxblood. Never use pure white or pure black.

### Color Tokens

- Primitive:
  - `mi-hv-cream`: `#F6EFE1` warm milky paper page.
  - `mi-hv-paper`: `#FBF6EC` brighter polaroid mat / card surface.
  - `mi-hv-ink`: `#4B4138` warm brown-black for text and hand-drawn line (never pure black).
  - `mi-hv-pencil`: `#9C8E7C` pencil-grey secondary text / handwriting.
  - `mi-hv-rose`: `#E0A79C` dried-rose, the single locked accent.
  - `mi-hv-butter`: `#EAD6A0` faded butter (washi tape, highlight).
  - `mi-hv-matcha`: `#A9B795` dusty sage-green (secondary doodle).
  - `mi-hv-sky`: `#A6BFC9` faded sky (film-photo placeholder).
  - `mi-hv-clay`: `#C7896B` terracotta (stamp / deeper accent).
  - `mi-hv-shadow`: `#D9C9AE` warm-tinted shadow.
- Semantic:
  - `mi-hv-page`: warm cream reading field.
  - `mi-hv-photo`: instant-photo image slot (real photo, or warm gradient placeholder).
  - `mi-hv-mat`: white polaroid border that carries the handwritten caption.
  - `mi-hv-accent`: dried rose used sparingly for the active state and one doodle.
  - `mi-hv-tape`: semi-transparent butter/rose washi tape.
- Component:
  - `mi-hv-doodle-ink`: hand-drawn line color (ink at 0.65 to 0.85 opacity).
  - `mi-hv-sticker`: rose / clay fill with a thin ink outline.

### Typography Tokens

- Display: friendly rounded headline (`design: .rounded`, semibold), warm and soft.
- Title: rounded medium section titles.
- Body: rounded/default regular at a comfortable size; never thin grey.
- Label: small rounded labels; a **handwriting** face (`mi-hv-hand`) is reserved for short captions, dates, and moods only. Until a custom handwriting font is bundled, fall back to rounded + `.italic()`.

### Shape / Radius Tokens

> Taste guardrail: one **documented** dual-radius rule. The card surface is soft and pillowy; the polaroid photo is near-square like a real instant print. This is the only allowed radius split, applied everywhere.

- Surface / Card: soft radius 20-24 pt (pillowy paper).
- Photo (polaroid): small radius 4-8 pt (near-square instant print).
- Button: pill / large rounded.
- Control / Input: medium rounded inset paper field (8-12 pt).
- Sticker: organic die-cut shapes (drawn paths), not rounded rectangles.

### Elevation / Material Tokens

- Surface depth: mostly flat cream; the polaroid and stickers lift slightly off the page.
- Shadow: soft, **warm-tinted** (`mi-hv-clay`/`mi-hv-shadow` at low opacity), low blur. Never grey or black.
- Blur / material: none required; this is a paper-led style. Reserve any material for transient overlays only.
- Border: thin warm hairline on the polaroid mat; hand-drawn (slightly irregular) lines for emphasis instead of geometric strokes.
- Grain: a subtle warm film grain is part of the look. Apply it on a single fixed, non-interactive overlay (not per scrolling cell) for performance; the home card uses a soft paper sheen instead of live grain.

## Layout Rules

- Composition: a vertical "diary feed" of polaroid cards; each = photo + handwritten date/mood + one doodle or tape accent. One hero polaroid per region.
- Grid: relaxed scrapbook rhythm; gentle tilt (±2-3°) on photos and stickers for a hand-placed feel, but content stays upright enough to read.
- Spacing: generous warm cream breathing room; whitespace is part of the calm.
- Density: low-to-medium. Restraint is the taste: max 1-2 decorations per card.
- Hierarchy: photo first, then handwriting, then doodle accent. Size and placement create hierarchy, not saturation.
- Safe area: respect safe areas; keep tap targets ≥ 44x44 pt even when an element is rotated.

## Component Guidance

- Navigation: a soft cream top bar with a rounded/handwritten-style title and a friendly back control; a tiny doodle can sit beside the title.
- Button: primary is a dried-rose pill with cream text; secondary is a paper outline pill; press = a soft squish (`scale ≈ 0.97`) and settle. SwiftUI: `Capsule` fill + `scaleEffect` on press, spring back.
- Card: a polaroid: photo on top, white mat, handwritten date/caption at the bottom, one tape or sticker accent, slight tilt that straightens on press. SwiftUI: `VStack` (photo + mat) on a `RoundedRectangle(mi-hv-paper)` with a warm shadow and `rotationEffect`.
- Home Card: one oversized hero polaroid (80% of card width, tilted -2.5°) taped to the cream page; the faded-film photo window holds a hand-drawn postcard scene (sun, sparkle, sea-horizon wave) and the style title is handwritten on the mat as the caption, ending in the single dried-rose heart. A pencil date note sits on the otherwise empty cream below. Decorations are exactly two (washi tape + heart); press flattens the print (straighten to 0°, 1 pt nudge, tighter clay shadow), with reduced motion keeping the static tilt and softening only the shadow. The paper sheen is a static soft-light gradient that, while the home canvas drags, falls back to a plain non-blended overlay alongside a lighter polaroid shadow.
- Sheet / Modal: a cream paper sheet with a rounded grabber; a small doodle header is allowed. SwiftUI: `.presentationDetents`, paper background, rounded top.
- Form: rounded inset paper field with a handwriting-style placeholder; focus shows a dried-rose underline/glow. SwiftUI: `RoundedRectangle` inset fill + a rose focus line; never placeholder-as-label.
- Tab / Segmented Control: cute rounded segments; the active item gets a sticker-like indicator (a small rose dot or underline), plus a label, never color alone.
- Empty state: a hand-drawn mascot plus a handwritten line (for example "아직 없어요 / nothing yet") and one friendly action.
- Paywall / subscription surface: framed like a "diary membership" with a warm cover, a clear plan list, and a rose pill primary; keep pricing high-contrast ink on cream.

## iOS / SwiftUI Notes

- SwiftUI primitives: `RoundedRectangle`, `Capsule`, `Path`/`Shape` and `Canvas` for doodles (sun, four-point stars, hearts, wavy underlines), `Text` with `.rounded`, `rotationEffect`, `LinearGradient` for the film-photo placeholder.
- Recommended modifiers: warm-tinted `.shadow`, `.rotationEffect` (with a press straighten), `.blendMode(.softLight)` for a paper sheen, `minimumScaleFactor` on tilted/handwritten text.
- Native controls to preserve: navigation, sheets, scroll behavior, Dynamic Type, VoiceOver.
- Performance notes: doodles are cheap `Path` strokes/fills; keep grain on one fixed overlay, not per cell; avoid live blur for repeated cards.
- Dynamic Type notes: rounded body and titles must scale and wrap; keep handwriting only for short non-critical captions so scaling never breaks meaning.
- Image strategy: prefer real photo / hand-drawn illustration assets in the photo and mascot slots. The procedural `Path`/`Canvas` doodles are the documented hand-drawn signature and a safe offline default; real assets (PNG/PDF/SVG) drop into the same slots later without changing layout.

## Motion Rules

- Transition: soft spring; page changes cross-fade with a small upward drift, like turning a diary page.
- Press feedback: the polaroid straightens toward 0° and nudges down 1 pt; buttons squish and settle; a sticker can give a tiny wobble.
- Loading: a friendly skeleton (paper blocks) or a small doodle, not a generic spinner.
- Gesture response: calm, low travel.
- Reduced motion fallback: no rotation, no wobble, no drift; keep photos straight and cross-fade only.

## Accessibility

- Contrast: warm ink (`mi-hv-ink`) on cream passes AA; keep dusty accents for decoration, never body text on cream.
- VoiceOver: read the photo caption, date, and mood; mark tape, stickers, and doodles as decorative (`.accessibilityHidden(true)`), or let the parent ignore children.
- Dynamic Type: rounded body and titles scale and wrap; handwriting stays short and non-critical.
- Touch target: at least 44x44 pt, preserved even under rotation.
- Color-only meaning: selected/active also use a label, underline, or sticker, not the rose alone.

## Prompt Guidance

### Use This Style When Prompt Says

- Trigger phrases: Korean cute, K-vlog, 韩系, 手绘, hand-drawn, doodle, polaroid, film diary, 手账, scrapbook, washi tape, journaling, cozy cute.
- Related product scenarios: diary/journal feeds, lifestyle & travel logs, photo collections, gentle onboarding.

### AI Output Should Include

- Visual direction: cream paper, faded film tones, a tilted polaroid hero, handwriting, washi tape, and a few restrained hand-drawn doodles.
- Token suggestions: warm cream/paper, warm ink, dried-rose accent, faded butter/matcha/sky, warm-tinted shadow.
- Component behavior: rose pill primary that squishes, polaroid cards that straighten on press, inset paper inputs with a rose focus line, friendly empty/loading states with a mascot.
- SwiftUI notes: `Path`/`Canvas` doodles, `.rounded` type plus handwriting captions, warm shadows, `rotationEffect` with a reduced-motion fallback.
- Risks and acceptance checks: keep it faded not candy, restrain decoration (max 1-2 per card), protect contrast and tap targets, keep handwriting short.

## Anti-patterns

- Do not: use bright saturated candy pastels, pure white or pure black, or more than two accents on a surface.
- Avoid: over-rotating elements so text is hard to read or tap; making the handwriting font the body text; piling on stickers; neon, glass, or heavy 3D effects.
- Common shallow interpretation: "rounded corners + pink" is not this style. Hand-drawn Vlog needs warm paper, faded film tone, polaroid framing, handwriting, hand-drawn line, and restraint.

## Acceptance Checklist

- [ ] The result reads as Korean film-diary cute via paper, faded film tones, polaroid framing, handwriting, and hand-drawn doodles, not just a label.
- [ ] The palette stays faded/dusty (no bright candy pastels), with no pure white or pure black, and at most two accents per surface.
- [ ] One documented radius rule is followed (soft card surfaces, near-square polaroid photos).
- [ ] Warm-tinted shadows only; no grey or black drop shadows.
- [ ] Decoration is restrained (max 1-2 stickers/tape/doodles per card).
- [ ] The result remains usable on iPhone; tap targets are at least 44x44 pt, even when rotated.
- [ ] Dynamic Type scales and wraps body and titles; handwriting is short and non-critical.
- [ ] Contrast is checked for all text-on-surface pairs; dusty accents are not used as body text.
- [ ] Empty, loading, error, and selected states are defined and not color-only.
- [ ] Motion is soft with a reduced-motion fallback (no rotation, wobble, or drift).
- [ ] Doodles use native `Path`/`Canvas`; real photo/illustration assets can replace placeholders without layout changes.
- [ ] Anti-patterns from this document are avoided.
