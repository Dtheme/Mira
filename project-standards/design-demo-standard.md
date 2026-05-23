# Design Demo Standard / 设计系统演示标准

## Purpose

Every Mira design style demo must expose the same minimum set of UI surfaces so humans and AI agents can compare styles without guessing what is missing.

This standard defines the runtime demo contract. A style's `Design.md` defines the design knowledge; the app demo translates that knowledge into concrete iOS / SwiftUI components.

## Required Inputs

Before implementing or updating a style demo, read:

1. `project-standards/README.md`
2. `project-standards/ios-swiftui-baseline.md`
3. `project-standards/vibe-coding.md`
4. `docs/design-system/mira-app-design-system.md`
5. The target style file at `docs/design-system/styles/<style-slug>/Design.md`

Do not implement a style-specific demo until its `Design.md` exists. Registered styles without a complete app module should remain visible on Home, but tapping them should show a lightweight unavailable notice instead of opening a placeholder detail page.

Runtime code for each style should be organized independently:

```text
Mira/Features/Styles/<StyleModuleName>/
```

The `Design.md` remains the documentation source of truth under:

```text
docs/design-system/styles/<style-slug>/Design.md
```

## Required Demo Slots

Each implementation-ready style demo must define these slots:

| Slot | Required Content | Notes |
| --- | --- | --- |
| Hero | first viewport, style identity, category, readiness status | Shows the style's strongest visual signal without turning into a landing page. |
| Style Card | homepage card with screenshot branch and no-screenshot branch | Must follow Mira's medium rounded-rectangle card rule. |
| Surface / Material | primary content surface, shell surface, transient surface | For Liquid Glass, shell may be glass while content stays readable. |
| Button | primary, secondary, selected, disabled, destructive | At least 44x44 pt touch target. |
| Search / Input | default, focused, filled, cleared, error | For Liquid Glass, search is a functional glass shell control; it must stay readable over the app background. |
| Filter / Tag | unselected, selected, disabled, overflow | Category and style metadata chips belong here. |
| Navigation / Segmented | back, tab or segment, active indicator | Must preserve native iOS navigation expectations; Liquid Glass demos should use true glass for segment selectors on supported systems and keep a readable fallback. |
| Sheet / Inspector | floating panel, close action, prompt helper | Chrome can be glass; body copy must not sit on low-contrast translucent material. |
| Empty / Loading / Error | recoverable empty, skeleton/loading, error action | No blank screenshots or dead states. |
| Selected / Disabled | explicit visual and semantic states | Do not rely on color alone. |
| Motion Sample | press feedback, transition, reduced-motion fallback | Avoid animating blur radius directly. |
| Accessibility Sample | VoiceOver label, Dynamic Type, contrast, touch target | Include readable fallback if style effects reduce contrast. |
| Token Swatches | color, type, spacing, radius, material, shadow | Token names should match or map to `Design.md`. |
| Prompt Guidance | AI prompt phrase, anti-patterns, acceptance checklist | Keep it implementation-oriented, not mood-only. |

## Spatial Component Contract

Mira's app shell uses Apple Liquid Glass and a spatial home constellation. Each style demo should therefore identify how it appears in these shared spatial contexts:

- **Home card preview**: screenshot background plus style name when assets exist; otherwise style name plus short introduction.
- **Detail hero**: style identity, localized name, category, `Design.md` path, screenshot status, readiness status.
- **Demo slot grid**: all required demo slots visible in a predictable order.
- **Token panel**: swatches and implementation roles.
- **Guidance sections**: Style Identity, Visual Tokens, Layout Rules, Component Guidance, Motion, Accessibility, Prompt Guidance, Anti-patterns, Acceptance Checklist.
- **Unavailable state**: registered but incomplete styles should not open a shared placeholder page in the app. The home card can show a transient AlertToast-style message until the style owns its own module page.
- **Liquid Glass shell**: shared search, navigation, filters, and floating commands may use Liquid Glass; repeated cards and dense content should use lighter readable surfaces.
- **Scrolling performance**: detail demos should keep live blur and `glassEffect` on real controls such as search, segments, buttons, fixed shell controls, and floating commands; repeated section bodies use static gradients, strokes, and sparse tint.

## Implementation Rules

- New Swift types and files must use the `Mi` prefix.
- Style runtime data starts in `MiStyleRepository`; do not introduce Core Data for style entries in this phase.
- The app should not parse Markdown at runtime in the first implementation phase.
- Do not duplicate long style knowledge in Cursor, Claude, or Codex rule adapters.
- Keep Apple Liquid Glass as the app shell unless a task explicitly asks to redesign the shell.
- Style-specific visuals should appear inside preview/demo content without overriding the global shell.
- Each implementation-ready style should own its SwiftUI screen code under `Mira/Features/Styles/<StyleModuleName>/`.
- Registered but unimplemented styles should show a lightweight AlertToast notice when tapped from Home.
- Do not use live blur or custom glass on every repeated home card; reserve custom glass for important controls and group adjacent effects with `GlassEffectContainer`.
- Do not put live Liquid Glass effects on every repeated detail section; search, segment, and button demos may use true Liquid Glass when they remain bounded interactive controls with a static fallback.

## Acceptance Checklist

- [ ] The target style has `docs/design-system/styles/<style-slug>/Design.md`.
- [ ] The style is registered in `MiStyleRepository`.
- [ ] The detail page can show all required demo slots.
- [ ] The homepage card handles screenshot and no-screenshot branches.
- [ ] Token swatches map to the style's documented tokens.
- [ ] Empty, loading, error, selected, disabled, and reduced-motion states are defined.
- [ ] VoiceOver can identify style name, category, screenshot status, and summary.
- [ ] The implementation follows iOS / SwiftUI baseline rules.
- [ ] All new Swift files and types use the `Mi` prefix.
