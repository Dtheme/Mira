# Refined Dark / 精致暗色

## Style Identity

- **Status**: Implementation-ready. Mira includes a homepage preview card and an independent detail page under `Mira/Features/Styles/RefinedDark/`.
- **Definition**: Refined Dark is a polished dark product-UI style (in the spirit of modern developer tools like Linear and Vercel): a deep near-black base, subtle multi-stop gradients, crisp hairline borders, restrained accent with tasteful glow, and precise small-to-medium typography.
- **Core Feeling**: 冷静、精密、高级、专业;暗色不沉闷,靠极细边框、微妙渐变和克制发光建立层级。
- **Visual Keywords**: deep dark base, hairline borders, subtle gradient sheen, restrained indigo accent, soft glow, crisp type, micro-interactions, product-grade polish.
- **iOS Interpretation**: Use SwiftUI dark surfaces, 1 pt hairline strokes, low-opacity gradients, a single accent with a faint glow shadow, and fast crisp micro-motion. Hierarchy comes from contrast and borders, not heavy shadows.

## Best Use Cases

- Suitable screens: dashboards, developer/product tools, settings, command surfaces, analytics, pro apps.
- Suitable product moods: precise, professional, premium, focused, modern.
- Suitable content types: status controls, lists, metrics, compact cards, command/search.
- Best audience fit: SaaS, dev tools, productivity, and pro/premium products.

## Avoid When

- Do not use for: playful consumer apps, warm/soft brands, or light-mode-first products.
- Risky contexts: low-contrast dark-on-dark text, decorative heavy glow everywhere.
- Accessibility concerns: insufficient text contrast on dark; glow-only state meaning.
- Product mismatch: childlike, editorial-warm, or high-saturation expressive brands.

## Visual Tokens

### Color Tokens

- Primitive:
  - `mi-rd-base`: `#0E0E11` deep near-black page base.
  - `mi-rd-surface`: `#161619` card surface.
  - `mi-rd-surface-raised`: `#1D1D22` raised/active surface.
  - `mi-rd-ink`: `#F4F4F7` near-white primary text.
  - `mi-rd-muted`: `#9A9AA6` secondary text.
  - `mi-rd-accent`: `#7C8CFF` refined indigo accent.
  - `mi-rd-accent-deep`: `#5664E0` accent gradient end.
  - `mi-rd-hairline`: white at ~8% for borders/dividers.
- Semantic:
  - `mi-rd-page`: base with a faint top sheen.
  - `mi-rd-card`: surface with a hairline border and a top highlight line.
  - `mi-rd-accent-glow`: soft accent glow for primary focus.
  - `mi-rd-positive` / `mi-rd-danger`: restrained green / red for status.

### Typography Tokens

- Display: medium-weight rounded/system title, not heavy black.
- Title: semibold compact section titles.
- Body: regular, slightly small, high legibility on dark.
- Label: small uppercase or mono labels for metrics and tags.

### Shape / Radius Tokens

- Surface: 14-20 pt continuous rounded rectangles.
- Button: 10-12 pt rounded rectangle or capsule.
- Card: consistent 16-18 pt radius.
- Control: pills and small rounded chips.

### Elevation / Material Tokens

- Surface depth: separation via hairline borders + a 1 pt top highlight line, not heavy shadows.
- Shadow: optional very soft accent glow under the primary action only.
- Blur / material: avoid heavy frosted blur; use flat dark fills with subtle gradients.
- Border: 1 pt low-opacity white hairline; the active element gets a slightly brighter border.

## Layout Rules

- Composition: calm dark canvas with crisp bordered cards and one accent focus per region.
- Grid: tidy column rhythm; compact but breathable spacing.
- Spacing: medium; let hairlines and contrast do the work.
- Density: medium-high is acceptable (product tools), but keep type legible.
- Hierarchy: contrast (ink vs muted), border brightness, and a single accent — not color noise.
- Safe area: respect safe areas; bottom controls feel integrated.

## Component Guidance

- Navigation: a slim dark top bar with a hairline bottom edge and a clear back control.
- Button: primary uses an accent gradient with a faint glow and crisp white text; secondary uses surface + hairline; ghost is transparent + hairline. Micro press (scale + brightness).
- Card: dark surface, hairline border, top highlight line, optional accent left-edge for active.
- Home Card: a Cmd-K command palette poster on the deepest `base` surface. Upper field carries a static dot grid fading toward one focused command bar (raised-surface gradient fill, accent hairline border, a static full-accent caret, muted placeholder, and a ⌘K keycap) floating at 40% height over an accent bloom and a light pool below; the footer is a hairline with a 12 pt accent tick above the title. The bar's accent glow is the card's only glow and drops to zero while the home canvas pans (`isDragging`), where the indigo-tinted outer shadow also tightens; press brightens the bar border and glow like focus landing in the input, with a fill/border-only fallback under reduced motion. Separation stays border-led, never heavy shadows.
- Sheet / Modal: raised dark surface with a hairline and a clear close.
- Form: dark inset field with a hairline that brightens to accent on focus.
- Tab / Segmented Control: a dark track with a raised, subtly glowing selected segment.
- Empty state: a quiet bordered placeholder plus one accent action.
- Paywall / subscription surface: accent-glow primary plan, crisp pricing in near-white.

## iOS / SwiftUI Notes

- SwiftUI primitives: `RoundedRectangle(style: .continuous)`, hairline `strokeBorder`, low-opacity `LinearGradient`, accent glow `shadow`, `Capsule`.
- Recommended modifiers: 1 pt hairline overlays, a top highlight gradient line, `scaleEffect` + `brightness` micro-press, fast `easeOut`/short spring.
- Native controls to preserve: navigation, sheets, Dynamic Type, VoiceOver, scroll behavior.
- Performance notes: flat fills + borders are cheap; reserve glow for the single primary action; do not animate blur.
- Dynamic Type notes: keep near-white body text; let cards grow; never clip metrics.

## Motion Rules

- Transition: fast and crisp (120-200 ms); subtle fades and small offsets.
- Press feedback: scale to ~0.98 with a small brightness/glow bump.
- Loading: a subtle skeleton shimmer on dark surfaces.
- Gesture response: smooth, low-travel; no bounce.
- Reduced motion fallback: swap fills/borders/opacity without movement or glow pulse.

## Accessibility

- Contrast: near-white `mi-rd-ink` on dark surfaces; muted text must still pass contrast.
- VoiceOver: label icon-only controls; describe selected/active state.
- Dynamic Type: text wraps; cards expand; no clipping.
- Touch target: at least 44x44 pt.
- Color-only meaning: status needs label/icon in addition to accent/positive/danger color.

## Prompt Guidance

### Use This Style When Prompt Says

- Trigger phrases: Refined Dark, 精致暗色, Linear-style, Vercel-style, dark product UI, pro dark mode, sleek dashboard.
- Related product scenarios: dev tools, dashboards, settings, command surfaces, pro apps.

### AI Output Should Include

- Visual direction: deep dark base, hairline borders, subtle gradients, one restrained accent with soft glow, crisp type.
- Token suggestions: base/surface/raised dark steps, near-white ink, muted text, indigo accent + deep, hairline.
- Component behavior: gradient primary with glow, hairline secondary/ghost, focus-brightening fields, glowing selected segment, per-cell states.
- SwiftUI notes: hairline strokes, low-opacity gradients, accent glow shadow, fast crisp micro-motion.
- Risks and acceptance checks: dark-on-dark contrast, glow overuse, glow-only state meaning.

## Anti-patterns

- Do not: drown the UI in glow; rely on glow alone for state; use muddy low-contrast dark-on-dark text.
- Avoid: heavy drop shadows, frosted-glass blur as the main material, many competing accents.
- Common shallow interpretation: "just make it dark" — Refined Dark needs hairline precision, subtle gradients, one disciplined accent, and crisp micro-motion.

## Acceptance Checklist

- [ ] The result reads as a precise, premium dark product UI without relying only on a label.
- [ ] Separation comes from hairline borders and contrast, not heavy shadows.
- [ ] A single restrained accent (with optional soft glow) marks the primary focus.
- [ ] The result remains usable on iPhone.
- [ ] Touch targets are at least 44x44 pt.
- [ ] Near-white text and muted text pass contrast on dark surfaces.
- [ ] Empty, loading, error, and selected states are defined and not color/glow-only.
- [ ] Motion is fast and crisp with a reduced-motion fallback.
- [ ] SwiftUI notes use native shapes, hairlines, gradients, and glow instead of heavy blur.
- [ ] Anti-patterns from this document are avoided.
