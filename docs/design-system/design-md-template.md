# Design.md Template / 风格设计文档模板

Use this template for every style-specific `Design.md`. Keep English section names stable for AI retrieval. Use Chinese explanation for design intent, tradeoffs, and product guidance.

```markdown
# Style Name / 中文名

## Style Identity

- **Definition**:
- **Core Feeling**:
- **Visual Keywords**:
- **iOS Interpretation**:

## Best Use Cases

- Suitable screens:
- Suitable product moods:
- Suitable content types:
- Best audience fit:

## Avoid When

- Do not use for:
- Risky contexts:
- Accessibility concerns:
- Product mismatch:

## Visual Tokens

### Color Tokens

- Primitive:
- Semantic:
- Component:

### Typography Tokens

- Display:
- Title:
- Body:
- Label:

### Shape / Radius Tokens

- Surface:
- Button:
- Card:
- Control:

### Elevation / Material Tokens

- Surface depth:
- Shadow:
- Blur / material:
- Border:

## Layout Rules

- Composition:
- Grid:
- Spacing:
- Density:
- Hierarchy:
- Safe area:

## Component Guidance

- Navigation:
- Button:
- Card:
- Sheet / Modal:
- Form:
- Tab / Segmented Control:
- Empty state:
- Paywall / subscription surface:

## iOS / SwiftUI Notes

- SwiftUI primitives:
- Recommended modifiers:
- Native controls to preserve:
- Performance notes:
- Dynamic Type notes:

## Motion Rules

- Transition:
- Press feedback:
- Loading:
- Gesture response:
- Reduced motion fallback:

## Accessibility

- Contrast:
- VoiceOver:
- Dynamic Type:
- Touch target:
- Color-only meaning:

## Prompt Guidance

### Use This Style When Prompt Says

- Trigger phrases:
- Related product scenarios:

### AI Output Should Include

- Visual direction:
- Token suggestions:
- Component behavior:
- SwiftUI notes:
- Risks and acceptance checks:

## Anti-patterns

- Do not:
- Avoid:
- Common shallow interpretation:

## Acceptance Checklist

- [ ] The result is recognizable as this style without relying only on a label.
- [ ] The result remains usable on iPhone.
- [ ] Touch targets are at least 44x44 pt.
- [ ] Body text supports Dynamic Type and remains readable.
- [ ] Contrast is checked for all text-on-surface pairs.
- [ ] Motion has a reduced-motion fallback.
- [ ] SwiftUI notes use native iOS concepts where possible.
- [ ] Anti-patterns from this document are avoided.
```

## Authoring Rules

- Keep `Design.md` factual and operational; avoid generic moodboard language without UI consequences.
- Prefer three-layer token language: primitive -> semantic -> component.
- Include at least one SwiftUI-specific note in every component section.
- Include anti-patterns for shallow AI outputs, such as "add blur everywhere" for Glassmorphism.
- Do not copy web CSS effects directly when iOS has a native material, animation, or control pattern.

## Dry-run Coverage

The template must support these first three styles:

- **Acid Graphic**: high-expression color, distorted typography, experimental hierarchy, high accessibility risk.
- **Glassmorphism**: material translucency, depth, blur, foreground/background separation, contrast risk.
- **Neo-Brutalism**: bold borders, raw layout, high-contrast surfaces, simple implementation but strong hierarchy risk.

