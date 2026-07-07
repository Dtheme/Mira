# Minimalism / 极简主义

## Style Identity

- **Status**: Implementation-ready. Runtime demo lives in `Mira/Features/Styles/Minimalism/`.
- **Definition**: Minimalism uses grid, typography, whitespace, hairline rules, and restrained color to make content priority obvious.
- **Core Feeling**: 克制、理性、清晰、可扫描。
- **iOS Interpretation**: Use it as a quiet SwiftUI style for information tools, settings, search, reference pages, and focused productivity screens. Do not confuse minimalism with empty generic UI.

## Best Use Cases

- Reference pages, settings, search, dashboards, component catalogs.
- Screens where content hierarchy matters more than visual spectacle.
- AI-generated UI that needs strong constraints against over-decoration.

## Avoid When

- The product needs strong brand expression or emotional art direction.
- Users need rich material cues, playful feedback, or heavy visual affordance.
- The layout has too little content; minimalism can become blank rather than clear.

## Visual Tokens

- `mi-min-paper`: warm white reading surface.
- `mi-min-ink`: primary text and rule color.
- `mi-min-hairline`: grid and quiet separator.
- `mi-min-accent`: sparse selection accent.
- Shape: nearly square corners or very small radius.
- Shadow: avoid decorative shadows; use line, fill, spacing, and hierarchy first.

## Layout Rules

- Build the page from a visible rhythm: column grid, baseline rhythm, section numbering, and stable spacing.
- Use whitespace as grouping, not as emptiness.
- Keep one primary action per region.
- Use short labels, predictable alignment, and clear reading order.

## Component Guidance

- Buttons: high-contrast filled primary, outlined secondary, opacity-based disabled state.
- Input: visible label, rule line, and high-contrast focus state.
- Tags / filters: rectangular chips with selected fill and unselected outline.
- Segmented control: crisp selected fill, no blur or decorative glow.
- Hero Preview: oversized typographic/grid tile + reactive metrics for grid, type, and density.
- Home Card: a single Swiss poster page. Flat paper, two structural hairlines only (a margin column at ~13% of width and a title baseline at 26% of height), a solid accent origin square at their intersection, a 9 pt tracked micro label, a one-line semibold title, and a giant ink issue numeral "01" at 50% of card height that bleeds past the bottom-right edge and is cropped by the card shape. Radius rule is outer 8 / inner 0: the shell keeps a fixed 8 pt continuous radius while every internal element stays square. One constant 1 pt ink border (opacity follows focus, fills to full on press) and a single ink-tinted shadow. Press sinks the label + title + numeral group by 1 px and scales the origin square to 1.35x while the grid lines and border never move; Reduce Motion makes the switch instant. Idle is fully static, and the only isDragging fallback is flattening the shadow (radius 10 -> 3), since the card uses no blur, material, or glow.

## iOS / SwiftUI Notes

- Runtime module path: `Mira/Features/Styles/Minimalism/`.
- Use system typography and readable Dynamic Type behavior.
- Prefer `VStack`, `LazyVGrid`, simple rectangles, thin strokes, and stable spacing.
- Do not use decorative blur, gradient-heavy backgrounds, or soft material as the main identity.

## Motion Rules

- Motion should be short and structural: selection fill, one-pixel press offset, opacity change.
- Avoid bouncy, liquid, or decorative animation.
- Reduced Motion can simply switch fill, rule, and opacity.

## Accessibility

- High contrast is expected, but still test disabled and hairline states.
- Use text and shape, not color alone.
- Dynamic Type should wrap labels and increase section height instead of truncating.
- Touch targets remain at least 44pt.

## Prompt Guidance

Ask AI for grid rhythm, type scale, hierarchy, spacing, component states, and explicit anti-decoration rules. Require it to explain what has been removed and why.

## Anti-patterns

- Calling a UI minimal because it has little content.
- Light gray text on white backgrounds.
- Removing labels, focus states, or recovery actions.
- Adding decorative shadows, glass, or gradients to make the style "less empty".

## Acceptance Checklist

- [ ] Grid, typography, whitespace, and hierarchy are visible.
- [ ] Buttons, inputs, chips, segments, states, tokens, and prompt rules are represented.
- [ ] The UI remains readable without decorative effects.
- [ ] Selected, disabled, error, loading, and empty states are explicit.
- [ ] Dynamic Type and VoiceOver reading order remain clear.
