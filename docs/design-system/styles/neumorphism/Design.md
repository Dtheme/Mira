# Neumorphism / 新拟态

## Style Identity

- **Status**: Implementation-ready. Mira includes a homepage preview card and an independent Neumorphism detail page under `Mira/Features/Styles/Neumorphism/`.
- **Runtime Demo Coverage**: The detail page should cover hero, style card, raised/inset/pressed surfaces, buttons, toggle, segmented control, input, sheet/inspector, empty/loading/error/selected/disabled states, token swatches, motion/accessibility notes, prompt guidance, and acceptance checks.
- **Definition**: Neumorphism, also called Soft UI, creates tactile raised and inset surfaces from a near-monochrome base color, paired light/dark shadows, large radius, and calm low-contrast controls.
- **Reference Mapping**: The provided CSS input style maps to two iOS surface states: a raised resting control and an inset focused control. Do not copy CSS values directly; translate them into SwiftUI shadows, overlays, focus state, and accessible contrast.
- **iOS Interpretation**: Use the style for quiet control surfaces, setting panels, onboarding selectors, and simple input flows where tactile depth is more important than dense data display.

## Best Use Cases

- Search fields, text inputs, steppers, toggles, and segmented controls with clear focus states.
- Calm productivity tools, settings pages, small configuration panels, and onboarding preference screens.
- Component demos that compare raised, pressed, selected, focused, and inset surfaces.
- Light-mode interfaces where the background and component base can share one soft material color.

## Avoid When

- The screen is text-heavy, data-dense, or requires strong scanning contrast.
- The user must distinguish many states quickly.
- Dark mode needs equal quality but the style has not defined dark shadows and highlights.
- Brand colors or screenshots are the primary content; low-contrast depth can make them feel washed out.

## Visual Tokens

- **Base Surface**: `#E8E8E8`; use for background and primary soft controls.
- **Highlight Shadow**: `#FFFFFF`; cast toward top-left to suggest raised surfaces.
- **Ambient Shadow**: `#C5C5C5`; cast toward bottom-right for depth.
- **Ink**: `#343A40`; text must be darker than the base surface, not light gray.
- **Muted Text**: `#6F747A`; use only for secondary copy and never for small critical labels.
- **Accent**: `#8FA6C8`; use sparingly for active markers, focus dots, and selected feedback.
- **Radius**: 16-28 pt for controls and cards; keep a continuous rounded rectangle feel.
- **Depth**: Resting surfaces use outer paired shadows; focused fields use inset paired shadows.
- **Pressed Rim**: A pure white highlight may appear on the outer border only during press/focus feedback to simulate a lit edge. It should not be a permanent decorative line.

## Layout Rules

- Keep the canvas light, calm, and uncluttered so shadows have room to breathe.
- Use fewer, larger components rather than many tiny raised chips.
- Preserve clear grouping with spacing, labels, and text hierarchy; do not rely on shadow alone.
- Keep important actions visually distinct with accent, label weight, or shape change.
- Avoid deeply nested raised panels, because each layer reduces contrast and clarity.

## Component Guidance

- **Cards**: Raised rounded rectangles with paired shadows and a subtle white edge highlight.
- **Home Card**: one raised soft-UI board carrying a single sculptural object — a large raised dial (0.58 × card width) seated in an inset circular groove centered at 0.40 × card height, so raised and inset read in one glance. The dial carries the card's only accent: a small `focusAccent` indicator dot at the 10 o'clock position. Bottom-left text block: a tracked "SOFT UI" kicker over the style title. Press sinks the dial (shadows collapse to 0.3x, fill darkens toward `basePressed`, content nudges 1.5 pt, dial an extra 1 pt) and lights the outer white rim; reduce-motion drops the offsets and keeps only the shadow/fill state change. The blur+mask groove carving renders only at rest; while the home canvas pans (isDragging) it falls back to a flat inset stroke and scaled-down shadows.
- **Inputs**: Resting fields can be raised or flat; focused fields should become inset with a visible focus accent.
- **Buttons**: Raised by default, pressed state collapses shadow and slightly darkens the fill.
- **Pressed Highlight**: Use the white rim as an interaction result on the outer border; do not draw a constant inner white line.
- **Toggles / Segments**: Selected state needs both inset depth and text/icon emphasis.
- **Tags**: Use low depth and concise labels; avoid chip clouds.
- **Sheets**: Prefer stable light panels. Avoid making the entire sheet deeply embossed.

## iOS / SwiftUI Notes

- Build with `RoundedRectangle(style: .continuous)`, paired `.shadow`, subtle `overlay` strokes, and focus-state-specific inner-shadow approximations.
- Runtime code belongs in `Mira/Features/Styles/Neumorphism/`; keep components independent from Apple Liquid Glass and Neo-Brutalism modules.
- Do not animate large blur, material, or shadow stacks during scroll.
- Use native focus, keyboard, safe-area, VoiceOver, and Dynamic Type behavior.
- Treat the CSS `box-shadow` recipe as a token reference, not as a web effect to paste into SwiftUI.
- Keep all new Swift files and types prefixed with `Mi`.

## Motion Rules

- Keep motion short and soft: 120-220 ms for focus, press, and selection.
- Pressed state may reduce shadow radius and shift content 1-2 pt.
- Focus state can transition from raised to inset, but avoid exaggerated sinking effects.
- Reduced Motion should swap shadow and border states without positional movement.

## Accessibility

- Low contrast is the main risk; text must pass contrast against the base surface.
- Do not use shadow alone to communicate selected, focused, disabled, or error states.
- Maintain at least 44x44 pt touch targets.
- Dynamic Type should expand controls vertically instead of clipping.
- VoiceOver labels must describe the control state, not the visual depth.

## Prompt Guidance

Use this style when the prompt mentions Neumorphism, Soft UI, raised soft surfaces, inset inputs, tactile gray controls, or CSS like paired light/dark `box-shadow`. The output should include base surface tokens, raised/inset state rules, contrast safeguards, SwiftUI shadow notes, and an explicit warning against low-contrast unreadable controls.

## Anti-patterns

- Making every object the same light gray with no hierarchy.
- Using pale gray text that disappears into the surface.
- Depending on shadow-only state changes.
- Applying large expensive shadow stacks to long scrolling lists.
- Mixing Neumorphism with Liquid Glass blur unless the prompt explicitly asks for a hybrid and defines hierarchy.

## Acceptance Checklist

- [ ] The base surface, highlight shadow, and ambient shadow are defined as tokens.
- [ ] Raised and inset states are both represented.
- [ ] Text remains readable on the soft surface.
- [ ] Focused, selected, disabled, error, and pressed states are not shadow-only.
- [ ] Touch targets are at least 44 pt.
- [ ] Reduced Motion has a non-positional fallback.
- [ ] SwiftUI implementation uses native shapes and shadows instead of copied CSS.
