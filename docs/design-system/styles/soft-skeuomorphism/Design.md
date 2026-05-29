# Soft Skeuomorphism / 柔和有机拟物

## Style Identity

- **Status**: Implementation-ready. Mira includes a homepage preview card and an independent detail page under `Mira/Features/Styles/SoftSkeuomorphism/`.
- **Definition**: Soft Skeuomorphism is a calm material style that centers a friendly physical object, such as a lamp or wellness device, inside warm cream surfaces, organic silhouettes, soft shadows, and tactile controls.
- **Core Feeling**: 温暖、安静、疗愈、像真实物件一样可触摸；界面不是纯装饰，而像一个柔和灯光设备的控制面板。
- **Visual Keywords**: warm cream, mushroom lamp, ambient glow, moss green, peach light, organic object, wellness cards, soft gauges, gentle tactile panels.
- **iOS Interpretation**: Use SwiftUI shapes, layered gradients, radial highlights, soft shadows, and accessible text hierarchy to suggest a physical product. Do not copy photorealism or web CSS; keep the experience iPhone-native and readable.

## Best Use Cases

- Suitable screens: wellness onboarding, meditation/breathing tools, smart-home controls, sleep dashboards, habit reminders, product companion apps.
- Suitable product moods: restful, safe, gentle, sensory, friendly, warm.
- Suitable content types: hero objects, control panels, ring metrics, guided actions, calm media/gallery cards.
- Best audience fit: consumer wellness, family smart devices, gentle productivity, ambient lifestyle products.

## Avoid When

- Do not use for dense admin tools, trading dashboards, legal workflows, or high-urgency safety screens.
- Risky contexts: tiny controls, large data tables, strong brand color systems, or dark-mode-first products.
- Accessibility concerns: low contrast cream-on-cream surfaces, shadow-only state, small caption labels, color-only wellness scores.
- Product mismatch: aggressive gaming, enterprise operations, cyberpunk, brutalist, or purely Apple-native utility screens.

## Visual Tokens

### Color Tokens

- Primitive:
  - `mi-softsk-cream`: `#F8EAD8`
  - `mi-softsk-surface`: `#FFF7EA`
  - `mi-softsk-card`: `#FFF1DF`
  - `mi-softsk-moss`: `#88A58E`
  - `mi-softsk-teal`: `#6EAFA7`
  - `mi-softsk-peach`: `#F6B08A`
  - `mi-softsk-coral`: `#EF998C`
  - `mi-softsk-butter`: `#F5D38B`
  - `mi-softsk-ink`: `#18202A`
  - `mi-softsk-muted`: `#70675C`
- Semantic:
  - `mi-softsk-page-field`: warm cream background with peach and moss ambient depth.
  - `mi-softsk-object-glow`: radial peach/butter light emitted by the signature object.
  - `mi-softsk-calm-surface`: readable cream panel with low-opacity moss/peach edge.
  - `mi-softsk-wellness-accent`: moss/teal used for calm, balanced, and selected states.
- Component:
  - `mi-softsk-lamp-cap`: peach-to-butter organic cap gradient.
  - `mi-softsk-lamp-stem`: ivory-to-peach soft body gradient.
  - `mi-softsk-ring-score`: segmented moss, teal, butter, and peach rings.
  - `mi-softsk-bloom-button`: cream pill with soft lower shadow and warm inner glow.

### Typography Tokens

- Display: rounded system large title, medium or semibold weight, never harsh black.
- Title: clean SF-style title with enough size and line height for calm reading.
- Body: readable system body in dark ink; avoid pale gray body text.
- Label: small labels can be used for metrics, but must stay dark enough over cream cards.

### Shape / Radius Tokens

- Surface: 28-38 pt continuous rounded rectangles.
- Button: capsule or 22-30 pt rounded rectangle.
- Card: 30-36 pt continuous rounded rectangle, soft but not inflated like Claymorphism.
- Control: circular rings, organic blobs, and pill controls with at least 44 pt touch targets.

### Elevation / Material Tokens

- Surface depth: broad low-opacity warm shadows plus a small top-left highlight.
- Shadow: warm brown/peach shadow at low opacity; avoid hard offsets and heavy black shadows.
- Blur / material: no live glass blur for ordinary panels. Use gradients, radial highlights, and static overlays.
- Border: nearly invisible cream/moss strokes; use edges to separate panels, not to draw attention.

## Layout Rules

- Composition: lead with one strong physical object or object-inspired control, then support it with calm panels.
- Grid: asymmetric two-panel arrangements are allowed, but iPhone should stack sections vertically.
- Spacing: generous but not empty; panels should feel like separate soft objects on a warm field.
- Density: medium-low. Prefer 1-2 controls per panel, not dense chip clouds.
- Hierarchy: object or signature control first, live readout second, guidance text third.
- Safe area: top navigation can float in the style's warm pill form, but must remain accessible and readable.

## Component Guidance

- Navigation: floating cream pill with moss/peach accent and a clear back action.
- Button: cream or peach pill, soft lower shadow, subtle press compression, clear label.
- Card: warm cream panel, low-contrast depth, rounded corners, and small ambient object illustration.
- Sheet / Modal: nested cream panel with readable copy and one clear close or confirm action.
- Form: inset cream troughs; focused state gets moss stroke and dark label, not only glow.
- Tab / Segmented Control: pill segments with selected fill, moss text, and shape difference.
- Empty state: small object glow plus recovery action.
- Paywall / subscription surface: use warm object stage, clear pricing, and avoid hiding commitment copy behind pastel decoration.

## iOS / SwiftUI Notes

- SwiftUI primitives: `RoundedRectangle(style: .continuous)`, `Capsule`, `Circle`, `LinearGradient`, `RadialGradient`, soft `shadow`, `overlay`, and simple `ButtonStyle`.
- Recommended modifiers: shadow changes and `scaleEffect` for press; opacity and fill changes for reduced motion.
- Native controls to preserve: safe-area navigation, button semantics, VoiceOver labels, Dynamic Type text wrapping, and iOS sheet behavior.
- Performance notes: keep glow and object lighting static or state-driven. Do not animate large blur radii during scroll.
- Dynamic Type notes: let panels grow vertically; never clip breathing guidance, metric labels, or call-to-action text.

## Motion Rules

- Transition: slow-calm spring or ease-out for state changes; avoid bouncy toy motion.
- Press feedback: button compresses 2-4%, shadow shortens, and warm glow increases.
- Loading: use calm staged bars or ring progress, not aggressive shimmer.
- Gesture response: tap-to-bloom is the primary interaction; drag or hold can be future enhancement.
- Reduced motion fallback: change fill, ring value, and glow opacity without moving the object.

## Accessibility

- Contrast: dark ink text on cream surfaces; muted text must remain readable.
- VoiceOver: describe the control state, such as "Bloom mode on, brightness warm".
- Dynamic Type: titles and body text wrap; cards do not depend on fixed-height captions.
- Touch target: every actionable pill, ring, or object control is at least 44x44 pt.
- Color-only meaning: wellness states need labels, icons, or ring position in addition to color.

## Prompt Guidance

### Use This Style When Prompt Says

- Soft Skeuomorphism
- 柔和拟物
- organic soft UI
- mushroom lamp UI
- warm wellness interface
- ambient smart-home control
- calm breathing or sleep app

### AI Output Should Include

- Visual direction: warm cream surfaces, organic product object, moss/peach accents, soft tactile depth.
- Token suggestions: primitive colors, semantic object glow, panel depth, ring metric colors, shape scale.
- Component behavior: tap-to-bloom control, ring metrics, cream panels, inset troughs, selected and disabled states.
- SwiftUI notes: native shapes, gradients, radial highlights, static shadows, accessibility labels.
- Risks and acceptance checks: low contrast, over-decoration, photorealistic clutter, and performance limits.

## Anti-patterns

- Do not turn it into Claymorphism by making every object puffy, toy-like, and saturated.
- Do not turn it into Neumorphism by relying on monochrome shadow-only state.
- Do not use glass blur as the main material.
- Do not place pale text on cream panels.
- Do not use photorealistic product art that fights UI readability.
- Do not make the page a generic wellness dashboard without the signature object/control.

## Acceptance Checklist

- [ ] The result is recognizable as warm, object-led Soft Skeuomorphism without relying only on a label.
- [ ] A signature object or object-inspired control appears in the opening experience.
- [ ] Tap-to-bloom or equivalent tactile interaction visibly updates a reactive readout.
- [ ] Warm cream, moss, teal, peach, and butter tokens are used semantically.
- [ ] Cards and controls use soft depth without hard shadows, glass blur, or color-only state.
- [ ] The result remains usable on iPhone.
- [ ] Touch targets are at least 44x44 pt.
- [ ] Body text supports Dynamic Type and remains readable.
- [ ] Contrast is checked for all text-on-surface pairs.
- [ ] Motion has a reduced-motion fallback.
- [ ] SwiftUI notes use native iOS concepts where possible.
- [ ] Anti-patterns from this document are avoided.
