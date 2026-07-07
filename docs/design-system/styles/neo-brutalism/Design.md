# Neo-Brutalism / 新粗野主义

## Style Identity

- **Status**: Implementation-ready for Mira.
- **Definition / 定义**: Neo-Brutalism exposes the interface structure through thick black borders, hard offset shadows, saturated flat colors, direct typography, and intentionally tactile controls.
- **Core Feeling / 核心感受**: 直接、粗粝、清晰、有重量、可按压。它不是“凌乱”，而是把层级、边界和交互反馈做得非常显眼。
- **Mira Interpretation / Mira 解释**: Use Neo-Brutalism as a style-specific demo module. It can fully override the Apple Liquid Glass shell inside its detail page, but it must keep native iOS safe areas, back behavior, 44pt touch targets, Dynamic Type, VoiceOver labels, and reduced-motion fallbacks.
- **Reference Source / 参考来源**: `MASTER.html` is treated as a visual reference for hard-edged panels, bold hierarchy, thick outlines, and three-zone composition, not as code or domain content to port directly into SwiftUI.

## Best Use Cases

- Design-system encyclopedia pages that need a strongly recognizable style identity.
- Design-system reference pages, component catalogs, challenge flows, or game-like task screens.
- Component demonstrations where state clarity matters: selected, pressed, disabled, error, success.
- Creative tools, prompt helpers, style cards, onboarding explainers, and editorial showcases.
- AI reference pages where tokens and layout rules must be easy to inspect.

## Avoid When

- The product needs a quiet, premium, finance, healthcare, or conservative system tone.
- The screen contains very dense long-form reading or large tables.
- Hard borders and heavy shadows would reduce content scanning speed.
- The implementation already uses glass, blur, gradient glow, or soft material as its primary language.
- A small iPhone screen cannot provide enough spacing for borders, shadows, and readable copy.

## Visual Tokens

### Color Tokens

- `mi-nb-ink`: `#323232`  
  Text, borders, icon strokes, and hard shadow color.
- `mi-nb-paper`: `#FFFDF7`  
  Main content surface and hero stage.
- `mi-nb-paper-blue`: `#DFF2FF`  
  Page background, grid field, and secondary surface.
- `mi-nb-surface`: `#FFFFFF`  
  Cards, inputs, and stable reading panels.
- `mi-nb-blue`: `#2D8CF0`  
  Primary action, selected tab, and active component.
- `mi-nb-green`: `#4ECB71`  
  Ready, success, completion, positive status.
- `mi-nb-orange`: `#FF9F3F`  
  Progress, warning, and warm accent block.
- `mi-nb-yellow`: `#FFE66D`  
  Highlight, secondary action, and attention block.
- `mi-nb-red`: `#FF6B6B`  
  Error, destructive action, and anti-pattern warning.
- `mi-nb-purple`: `#9F7AEA`  
  AI prompt helper or creative accent. Use sparingly.

### Stroke / Radius / Shadow Tokens

- `mi-nb-border-heavy`: `3pt` black border for cards, primary buttons, panels, and page chrome.
- `mi-nb-border-light`: `2pt` black border for small pills, icons, and inner tiles.
- `mi-nb-radius-xs`: `8pt`
- `mi-nb-radius-sm`: `12pt`
- `mi-nb-radius-md`: `18pt`
- `mi-nb-shadow-small`: `4pt x 4pt`, no blur.
- `mi-nb-shadow-medium`: `6pt x 6pt`, no blur.
- `mi-nb-shadow-large`: `10pt x 10pt`, no blur.
- `mi-nb-pressed-offset`: `4pt x 4pt`; pressed state moves into the shadow and collapses it.

### Typography Tokens

- Use SF system fonts with bold to black weights.
- Hero/title: `.system(size: 32-42, weight: .black, design: .rounded)`
- Section title: `.system(size: 24, weight: .black, design: .rounded)`
- Body: `.system(size: 15, weight: .bold, design: .rounded)`
- Label: `.system(size: 12, weight: .black, design: .rounded)`
- Copy should be short. The style gets weaker when large paragraphs fill every panel.

## Layout Rules

- Use clear modular blocks: controller, main stage, feedback/inspector.
- On iPhone, stack the three-column reference layout vertically: controls first, stage second, feedback third.
- The main task or preview stage should be the largest and most visually weighted object.
- Leave enough space around every component for hard shadows to remain visible.
- Use simple grid backgrounds sparingly. Grid lines should support structure, not become noise.
- Keep page sections readable with solid paper or white surfaces; do not layer multiple patterns behind body copy.
- Intentional imbalance is allowed only when primary action and reading order remain obvious.

## Component Guidance

- **Hero**: paper card, 3pt border, large hard shadow, short title, and a compact visual preview.
- **Style Card**: `NB` tag, style name, short summary, saturated blocks, 3pt border, hard shadow.
- **Home Card**: a full-bleed yellow slab with a 3pt ink border over a solid offset ink shadow; the only object is one white arrow block (rotated -4 degrees, `7pt x 7pt` solid shadow), plus a printed ink `NB` stamp (flat, no shadow) and a bottom-left title with the shadow-spec caption `7x7 · NO BLUR`, which states the block's actual resting shadow. Press drops the card onto its outer shadow while the block translates `7pt x 7pt` onto its own shadow, which collapses to zero. While the home canvas drags (isDragging fallback) the outer shadow offset shrinks to 0.55x at 0.32 opacity and the block shadow degrades to `4pt x 4pt`; nothing ever blurs. Reduced Motion removes all translation and changes shadow states only.
- **Button**: at least 44pt high, filled rectangle, 3pt border, hard shadow, bold label.
- **Pressed Button**: translate `4pt x 4pt`, collapse shadow to zero. Reduced Motion only changes shadow/border.
- **Toggle**: visible on/off text, thick track border, knob border, color plus text state.
- **Segment / Tabs**: selected item uses blue fill and pressed-like position. Unselected item stays white with border.
- **Input / Search**: visible label, white or light-blue fill, thick focus border, explicit helper/error text.
- **Tag / Pill**: saturated fill, border, short label, no color-only meaning.
- **Sheet / Inspector**: solid paper panel, thick border, large shadow, direct close action.
- **State Cards**: empty, loading, error, selected, disabled, and complete states must include icon or text support.

See `docs/design-system/styles/neo-brutalism/component-spec.md` for component-level implementation details.

## iOS / SwiftUI Notes

- Runtime module path: `Mira/Features/Styles/NeoBrutalism/`.
- Entry point: `MiNeoBrutalismModule`.
- Detail page: `MiNeoBrutalismDetailView`.
- Tokens: `MiNeoBrutalismTokens`.
- Use SwiftUI `RoundedRectangle`, `Capsule`, `overlay`, `strokeBorder`, `shadow(radius: 0, x:y:)`, and `offset` for the style.
- Do not use `glassEffect`, `GlassEffectContainer`, live blur, system material, translucent chrome, or soft glow inside this style page.
- Preserve iOS basics: `NavigationStack` routing, safe-area spacing, sheet dismissal, minimum touch targets, VoiceOver, Dynamic Type, and Reduced Motion.
- Keep rendering simple. Prefer flat fills, borders, and static shadows over expensive live materials or continuous animations.

## Motion Rules

- Primary motion pattern: press offset plus shadow collapse.
- Selection motion: short snap or spring with low travel.
- Page motion: normal iOS navigation transition is enough; do not add decorative full-page animations.
- Loading motion: use chunky blocks or simple progress state, not soft shimmer.
- Reduced Motion:
  - remove translation where possible
  - keep shadow, border, fill, and label state changes
  - avoid repeated bouncing or elastic effects

## Accessibility

- All controls must have at least 44pt hit height.
- Selected, disabled, error, and success states must use text or icons, not color alone.
- Text should wrap inside bordered panels at large Dynamic Type sizes.
- Avoid high-saturation red/blue or green/yellow text-on-fill combinations when contrast drops.
- VoiceOver labels should state component purpose and state: for example, "Tokens selected", "Inspector mode on", "Error example, missing token".
- If a hard shadow visually competes with content, reduce shadow size before reducing text contrast.

## Prompt Guidance

When asking AI to design with this style, include:

```text
Use Neo-Brutalism for an iOS SwiftUI screen.
Use #323232 ink borders, 3pt strokes, 4/6/10pt hard offset shadows with no blur.
Use #FFFDF7 paper, white cards, #FFE66D yellow, #2D8CF0 blue, #4ECB71 green, #FF9F3F orange, and #FF6B6B red.
Buttons must be at least 44pt high and press by moving down-right while collapsing their shadow.
Do not use Liquid Glass, blur, translucent material, soft glow, or decorative gradients.
Include selected, disabled, error, loading, and empty states.
```

Good output should include:

- token recommendations
- layout structure
- component rules
- state rules
- SwiftUI implementation notes
- accessibility checks
- anti-pattern checks

## Anti-patterns

- Treating Neo-Brutalism as "just add thick borders".
- Using blur, glass, translucent material, or soft glow in the Neo-Brutalist page.
- Making the layout chaotic without a clear task hierarchy.
- Using long explanatory paragraphs inside every card.
- Shrinking controls below native iOS touch targets.
- Relying on color alone for selected, disabled, success, or error states.
- Letting hard shadows clip against parent containers.
- Copying web CSS one-to-one instead of adapting to SwiftUI and iPhone constraints.

## Acceptance Checklist

- [ ] The style has an independent runtime module under `Mira/Features/Styles/NeoBrutalism/`.
- [ ] The detail page does not reuse the Apple Liquid Glass template.
- [ ] Hero, style card, tokens, shadows, buttons, toggle, segmented control, inputs, sheet, states, prompt guidance, and checklist are represented.
- [ ] Core surfaces use thick black borders and hard offset shadows.
- [ ] No Liquid Glass, blur, frosted material, soft glow, or glass gradients appear inside the style page.
- [ ] Buttons and interactive controls are at least 44pt high.
- [ ] Pressed state uses offset plus shadow collapse; Reduced Motion has a non-moving fallback.
- [ ] Dynamic Type can wrap labels and descriptions inside bordered panels.
- [ ] VoiceOver can identify the main controls and state examples.
- [ ] Homepage card communicates Neo-Brutalism visually before opening the detail page.
