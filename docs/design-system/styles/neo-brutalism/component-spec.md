# Neo-Brutalism Component Spec / 新粗野主义组件规范

## Purpose

This spec turns the Neo-Brutalism visual reference into iOS-first SwiftUI component rules. It supports `docs/design-system/styles/neo-brutalism/Design.md` and the runtime module at `Mira/Features/Styles/NeoBrutalism/`.

## Source Translation

The reference `MASTER.html` uses a strong three-zone composition with heavy framed surfaces:

- left index / control list
- center component stage
- right prompt rules / feedback panel

For iOS, this becomes a responsive stack:

- top controls for tokens, components, states, and mode
- central stage card for the active component or preview
- lower feedback cards for rules, states, and prompt guidance

Do not port CSS directly. Recreate the language with native SwiftUI shapes, overlays, and hard shadows.

## Shared Component Contract

- Border: `3pt` black for primary surfaces, `2pt` black for small internal details.
- Shadow: hard offset only, `radius: 0`, black ink color.
- Fill: flat color only; no glass, no blur, no translucent material.
- Radius: `8pt`, `12pt`, `18pt`, or `24pt`; avoid fully soft Apple-style cards.
- Typography: system rounded, bold to black weights.
- Hit target: every clickable component must be at least `44pt` high.
- Pressed state: offset down-right and collapse shadow.
- Reduced Motion: keep fill/border/shadow state; avoid translation.

## Component Matrix

| Component | Fill | Border | Shadow | Required States | Notes |
| --- | --- | --- | --- | --- | --- |
| Hero panel | `mi-nb-paper` | 3pt ink | 10pt x 10pt | default | Contains style title and miniature stage. |
| Style card | `mi-nb-paper` | 3pt ink | 5-10pt hard | focused, dimmed | Homepage preview uses `NB` tag plus saturated blocks. |
| Section panel | white or paper | 3pt ink | 4-6pt hard | default | Use for grouped demos, not every paragraph. |
| Primary button | blue | 3pt ink | 4pt x 4pt | default, pressed, disabled | White label on blue. |
| Secondary button | yellow | 3pt ink | 4pt x 4pt | default, pressed | Ink label on yellow. |
| Destructive button | red | 3pt ink | 4pt x 4pt | default, pressed | Add icon or label context. |
| Toggle | blue / grey | 2-3pt ink | 4pt x 4pt | on, off | Must include visible `on/off` text. |
| Segment | white shell, blue selected | 3pt shell, 2pt item | 4pt x 4pt | selected, unselected, pressed | Selected item appears physically pressed. |
| Input | white, blue focused, red error | 2-3pt ink | 4-6pt hard | empty, focused, filled, error | Helper/error text sits directly below. |
| Pill/tag | saturated fill | 2pt ink | 3pt x 3pt | default, selected, disabled | Short labels only. |
| Sheet/inspector | paper | 3pt ink | 10pt x 10pt | open, close | Body is solid and readable. |
| State card | semantic fill | 3pt ink | 4pt x 4pt | empty, loading, selected, error, disabled | Include icon and explicit text. |

## Layout Samples

### Design-System Layout

- Controller panel:
  - token/component/state selector
  - spec card list
  - inspector mode toggle
- Stage panel:
  - active component title
  - surface and material sample
  - primary, secondary, selected, and disabled controls
- Feedback panel:
  - prompt rules
  - anti-pattern tags
  - acceptance checklist

### Prompt Helper Layout

- Prompt category segment.
- Rules grid with anti-pattern warnings.
- Acceptance checklist on paper surface.
- Inspector sheet for reusable prompt rules.

## Interaction Rules

- Button press:
  - default shadow: `4pt x 4pt`
  - pressed offset: `4pt x 4pt`
  - pressed shadow: `0pt`
- Card selection:
  - use blue, yellow, or green fill plus selected label
  - do not depend on color alone
- Error:
  - red-tinted fill
  - warning icon
  - nearby error text
- Disabled:
  - grey fill
  - reduced opacity
  - still readable

## SwiftUI Implementation Notes

- Prefer reusable components:
  - `MiNeoBrutalismCard`
  - `MiNeoBrutalismButton`
  - `MiNeoBrutalismToggle`
  - `MiNeoBrutalismSegmentedControl`
  - `MiNeoBrutalismInput`
  - `MiNeoBrutalismSpecCard`
  - `MiNeoBrutalismStateCard`
  - `MiNeoBrutalismInspectorSheet`
- Use `ViewThatFits` for horizontal-to-vertical layout adaptation.
- Use `LazyVGrid` for token, state, and rule demos.
- Use solid backgrounds behind text. Hard shadows should not clip against scroll containers.
- Keep animations on press/selection only; avoid continuous animated backgrounds.

## Acceptance Checklist

- [ ] Component keeps the shared border, shadow, fill, and typography contract.
- [ ] Component has default and at least one meaningful state.
- [ ] Interactive components are at least 44pt high.
- [ ] State is not color-only.
- [ ] Large text wraps without clipping.
- [ ] Reduced Motion keeps the state visible without travel.
- [ ] The component does not use Liquid Glass, material blur, soft shadow, or glossy gradients.
