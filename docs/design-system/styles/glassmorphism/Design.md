# Glassmorphism / 玻璃拟物化设计

## Style Identity

- **Status**: Implementation-ready. Runtime demo lives in `Mira/Features/Styles/Glassmorphism/`.
- **Definition**: Glassmorphism uses frosted translucent panels, blur, light borders, depth layering, and colorful background separation to simulate glass-like interface surfaces.
- **iOS Interpretation**: Treat this as a broader glass aesthetic distinct from Mira's Apple Liquid Glass shell. Use it for style-specific demos and comparison content, not as a replacement for the global shell unless explicitly requested.

## Best Use Cases

- Floating cards over colorful but controlled backgrounds.
- Dashboards with a small number of summary panels.
- Preview surfaces that demonstrate depth, blur, and material separation.
- Decorative style samples where hierarchy is simple.

## Avoid When

- Dense text, long lists, tables, or forms dominate the screen.
- Background imagery is too busy for readable translucent panels.
- Too many nested glass cards would weaken hierarchy.
- The style is confused with Apple Liquid Glass without explaining the difference.

## Visual Tokens

- `mi-glass-cyan`: luminous edge and active glass tint.
- `mi-glass-blue`: primary depth and action tint.
- `mi-glass-violet`: creative overlay tint.
- `mi-glass-surface`: translucent white readable panel surface.
- Material: SwiftUI material or static frost gradients for bounded controls; avoid heavy live blur on repeated scrolling content.
- Shape: large rounded rectangles for panels, capsules for actions and filter chips.
- Shadow: soft blue depth shadow paired with a thin white/cyan border highlight.

## Layout Rules

- Use clear foreground, midground, and background layers.
- Put important text on the most opaque glass surface.
- Avoid glass-on-glass nesting unless there is a functional hierarchy.
- Backgrounds should provide color depth without interfering with content.

## Component Guidance

- Cards: frosted panels with border highlight and readable padding.
- Buttons: glass capsules with selected tint and shadow.
- Inputs: higher opacity than decorative cards, clear focus ring.
- Sheets: glass chrome is acceptable; body content may need stronger opacity.
- Hero Preview: oversized frosted orb + reactive metric panel for layer count, blur strength, and focus state.
- Home Card: translucent preview card with luminous edge, short description, and no dense text.
- States: empty/loading/error/selected/disabled must use icon or text support in addition to tint.

## iOS / SwiftUI Notes

- Prefer SwiftUI materials, rounded rectangles, overlays, and shadows.
- Avoid custom blur stacks that become expensive in scrolling views.
- Use scrims when text is placed over gradients or screenshots.
- Runtime module path: `Mira/Features/Styles/Glassmorphism/`.
- Keep Mira's Apple Liquid Glass app shell separate from the style demo; this style is broader frosted glass, not the system shell.
- Use static frost surfaces for repeated content sections and reserve material effects for hero, controls, search, and inspector-like surfaces.

## Motion Rules

- Use gentle depth transitions, opacity changes, and small scale feedback.
- Avoid animating blur radius directly.
- Reduced Motion should preserve layer order through opacity and border state.

## Accessibility

- Increase opacity behind text when contrast drops.
- Provide labels for icon-only glass buttons.
- Selected states need shape, icon, or label support in addition to tint.
- Dynamic Type should expand panel height rather than clipping text.

## Prompt Guidance

Use this style when the prompt asks for frosted glass panels, translucent cards, soft depth, glass UI, or glassmorphism. Output should distinguish it from Apple Liquid Glass and include contrast, blur, depth, and nesting limits.

## Anti-patterns

- Placing paragraph text directly over low-opacity blur.
- Stacking many glass panels with no hierarchy.
- Using glass as decoration without a functional layer.
- Ignoring background complexity.

## Acceptance Checklist

- [ ] Foreground glass surfaces are readable.
- [ ] Background color depth supports the glass effect.
- [ ] Nested glass is limited and purposeful.
- [ ] Inputs and buttons have clear focus, selected, disabled, and error states.
- [ ] Reduced Motion avoids blur-heavy transitions.
