# Glassmorphism / 玻璃拟物化设计

## Style Identity

- **Status**: Registered draft. This file exists so AI tools can resolve the style path, but the style is not implementation-ready yet.
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

- Draft color direction: translucent white, cool cyan, blue-violet, soft black scrim.
- Draft material direction: frosted blur, semi-transparent fill, luminous border, soft shadow.
- Draft radius direction: large rounded rectangles and capsules.
- Draft shadow direction: soft depth shadow with subtle inner highlight.

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

## iOS / SwiftUI Notes

- Prefer SwiftUI materials, rounded rectangles, overlays, and shadows.
- Avoid custom blur stacks that become expensive in scrolling views.
- Use scrims when text is placed over gradients or screenshots.

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
