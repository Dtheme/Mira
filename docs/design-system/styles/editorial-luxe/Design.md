# Editorial Luxe / 轻奢编辑

## Style Identity

- **Status**: Implementation-ready. Mira includes a homepage preview card and an independent detail page under `Mira/Features/Styles/EditorialLuxe/`.
- **Definition**: Editorial Luxe is an elegant, magazine-inspired luxury style built from refined serif display typography, clean sans body text, generous whitespace, thin gold/ink hairline rules, and large imagery — restrained, premium, and beautiful.
- **Core Feeling**: 优雅、高级、克制、有编辑品味;像一本精致杂志或精品品牌册子。
- **Visual Keywords**: serif display, ivory paper, generous whitespace, hairline rules, gold accent, large imagery, byline, drop cap, refined restraint.
- **iOS Interpretation**: Use SwiftUI serif fonts (`.system(design: .serif)`) for headlines, a clean sans for body/labels, warm ivory surfaces, thin rules, and a single restrained gold accent. Elegance comes from type, space, and rhythm — not effects.

## Best Use Cases

- Suitable screens: feature/article pages, premium brand & product stories, lookbooks, profiles, onboarding with narrative.
- Suitable product moods: elegant, premium, calm, editorial, fashion/lifestyle.
- Suitable content types: large headlines, pull quotes, imagery, bylines, short body, refined metadata.
- Best audience fit: fashion, lifestyle, culture, luxury, publishing, and premium brand experiences.

## Avoid When

- Do not use for: dense data tools, dashboards, high-frequency utility flows.
- Risky contexts: tiny dense controls, heavy forms, content that is not narrative.
- Accessibility concerns: thin serif at small sizes; low-contrast gold-on-ivory text.
- Product mismatch: playful, brutalist, neon, or dense enterprise apps.

## Visual Tokens

### Color Tokens

- Primitive:
  - `mi-ed-paper`: `#F6F1E9` warm ivory page.
  - `mi-ed-surface`: `#FFFFFF` clean card surface.
  - `mi-ed-ink`: `#211C16` warm near-black text and rules.
  - `mi-ed-muted`: `#756B5E` secondary text and bylines.
  - `mi-ed-gold`: `#AD8A52` restrained luxury accent.
  - `mi-ed-hairline`: `#E5DDCF` thin rule and divider.
- Semantic:
  - `mi-ed-page`: warm ivory reading field.
  - `mi-ed-cover`: imagery/cover block (ink gradient placeholder).
  - `mi-ed-rule`: thin gold/ink hairline for editorial structure.
  - `mi-ed-accent`: gold used sparingly for emphasis and active state.

### Typography Tokens

- Display: large serif headline (`design: .serif`), regular/semibold weight; the signature elegance.
- Title: medium serif or refined sans section titles.
- Body: clean sans (`design: .default`) at comfortable size and line height; never thin gray.
- Label: small uppercase sans labels with moderate tracking for kickers and metadata.

### Shape / Radius Tokens

- Surface: small radius (8-14 pt) or near-square for an editorial, print feel.
- Button: pill or small rounded rectangle; underlined text links allowed.
- Card: clean rectangle with a thin rule, low radius.
- Control: minimal; rely on rules and type, not heavy chrome.

### Elevation / Material Tokens

- Surface depth: mostly flat; very soft shadow only on the cover/feature card.
- Shadow: subtle warm shadow; avoid heavy elevation.
- Blur / material: none; this is a print-led style.
- Border: thin ink/gold hairline rules; use rules to separate, not boxes everywhere.

## Layout Rules

- Composition: lead with a large serif headline and generous whitespace; support with a kicker, byline, and one image/cover.
- Grid: editorial column rhythm; align to a baseline; let whitespace group content.
- Spacing: generous; whitespace is part of the luxury.
- Density: low-to-medium; one strong feature per region.
- Hierarchy: serif size + weight + a gold rule/kicker, not color noise.
- Safe area: respect safe areas; top navigation stays minimal and refined.

## Component Guidance

- Navigation: a slim refined top bar with a hairline rule and a clear back control; kicker-style title.
- Button: primary is an ink-filled pill with ivory text; secondary is a thin ink/gold outline; tertiary is an underlined gold text link.
- Card: clean surface with a thin rule, a kicker label, a serif title, and a short body.
- Home Card: an engraved monogram bookplate on pure flat paper, zero shadows. A sharp-cornered ink plate frame (0.75 pt, inset 9 pt) sits inside the hairline-bordered card; inside it, centered: a gold tracked kicker, one giant italic serif monogram (`home_ed_monogram`, ~0.415 x card height) standing over a 0.75 pt gold engraved rule that runs behind the glyph and shows through its counters, the serif title (17 pt), and a tick-flanked gold monospaced Roman folio (`home_ed_folio`, `Vol. II`). On press the plate inks in: the rule rises from 0.65 to full gold opacity and widens 10 pt while the framed content scales to 0.985; reduced motion keeps only the rule opacity crossfade. Idle is fully static, and every layer is a flat fill, hairline stroke, or text, so no isDragging fallback is needed — the card is equally cheap while panning.
- Sheet / Modal: a clean paper sheet with a hairline and a refined close.
- Form: minimal field with a bottom rule that turns gold on focus, and a clear label.
- Tab / Segmented Control: understated text segments with a gold underline indicator for the selected item.
- Empty state: a quiet serif message plus one refined action.
- Paywall / subscription surface: a serif headline, a clean plan list, and an ink-filled primary; keep pricing high contrast.

## iOS / SwiftUI Notes

- SwiftUI primitives: `Text` with `.font(.system(size:weight:design: .serif))`, thin `Divider`/`Rectangle` rules, `RoundedRectangle`, `Capsule`, gold underline overlays.
- Recommended modifiers: serif headlines, baseline-aware spacing, hairline rules, gentle fades; underline indicators for selection.
- Native controls to preserve: navigation, sheets, Dynamic Type, VoiceOver, scroll behavior.
- Performance notes: flat surfaces and rules are cheap; reserve a soft shadow for the cover only.
- Dynamic Type notes: serif headlines and sans body must scale and wrap; never clip a headline — allow it to grow and re-flow.

## Motion Rules

- Transition: slow, refined fades and gentle offsets; nothing flashy.
- Press feedback: subtle opacity/scale; a gold underline can slide for selection.
- Loading: elegant skeleton rules/lines, not spinners.
- Gesture response: calm, low-travel.
- Reduced motion fallback: cross-fade or swap state without movement.

## Accessibility

- Contrast: warm near-black ink on ivory; keep gold for accents, not body text.
- VoiceOver: label the feature control and its state; read headline then byline.
- Dynamic Type: headlines and body scale and wrap; do not depend on fixed-height text.
- Touch target: at least 44x44 pt.
- Color-only meaning: selected/active also use an underline or label, not gold alone.

## Prompt Guidance

### Use This Style When Prompt Says

- Trigger phrases: Editorial, Luxury, 轻奢, magazine, serif, fashion, premium brand, lookbook, editorial layout.
- Related product scenarios: feature/article pages, brand stories, lookbooks, premium onboarding.

### AI Output Should Include

- Visual direction: serif headlines, ivory paper, generous whitespace, thin gold/ink rules, large imagery, one restrained accent.
- Token suggestions: ivory paper, warm ink, gold accent, hairline rule, clean sans body.
- Component behavior: ink-filled primary, outline secondary, underlined text link, gold underline selection, refined states.
- SwiftUI notes: serif `Text`, hairline rules, gentle fades, baseline rhythm.
- Risks and acceptance checks: thin serif legibility, gold-on-ivory contrast, keeping it elegant not busy.

## Anti-patterns

- Do not: fill the page with boxes and heavy shadows; use gold for body text; crowd the layout.
- Avoid: neon, blur/glass, playful shapes, or dense controls that break the editorial calm.
- Common shallow interpretation: "add a serif font" — Editorial Luxe needs whitespace, rhythm, hairline rules, restrained gold, and real hierarchy.

## Acceptance Checklist

- [ ] The result reads as elegant editorial/luxury via serif headlines, whitespace, and hairline rules — not just a label.
- [ ] Serif headlines pair with a clean readable sans body.
- [ ] Gold is a restrained accent; body text stays high-contrast ink on ivory.
- [ ] The result remains usable on iPhone.
- [ ] Touch targets are at least 44x44 pt.
- [ ] Dynamic Type scales and wraps headlines and body without clipping.
- [ ] Empty, loading, error, and selected states are defined and not color-only.
- [ ] Motion is slow and refined with a reduced-motion fallback.
- [ ] SwiftUI notes use native serif `Text`, rules, and gentle fades.
- [ ] Anti-patterns from this document are avoided.
