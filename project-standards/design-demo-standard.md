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
| Opening Experience | first meaningful viewport, style identity, category, readiness status | The opening layout belongs to the selected style. It may be a hero, editorial spread, product surface, split inspector, stage, poster, grid, or another style-specific composition. |
| Signature Interaction | interactive atomic showcase in the opening experience or early detail flow | Required for every implementation-ready style. Must reveal the style's tactile philosophy in one glance and respond to at least one tap-to-toggle interaction. See "Signature Interaction Contract" below. |
| Style Card | homepage card with screenshot branch and no-screenshot branch | Must follow Mira's medium rounded-rectangle card rule. |
| Surface / Material | primary content surface, shell surface, transient surface | For Liquid Glass, shell may be glass while content stays readable. |
| Button | primary, secondary, selected, disabled, destructive | At least 44x44 pt touch target. |
| Search / Input | default, focused, filled, cleared, error | For Liquid Glass, search is a functional glass shell control; it must stay readable over the app background. |
| Filter / Tag | unselected, selected, disabled, overflow | Category and style metadata chips belong here. |
| Navigation / Segmented | back path, tab or segment, active indicator | Must preserve native iOS navigation expectations. The control location, shape, density, and chrome belong to the selected style. |
| Sheet / Inspector | floating panel, close action, prompt helper | Chrome can be glass; body copy must not sit on low-contrast translucent material. |
| Empty / Loading / Error | recoverable empty, skeleton/loading, error action | No blank screenshots or dead states. |
| Selected / Disabled | explicit visual and semantic states | Do not rely on color alone. |
| Motion Sample | press feedback, transition, reduced-motion fallback | Avoid animating blur radius directly. |
| Accessibility Sample | VoiceOver label, Dynamic Type, contrast, touch target | Include readable fallback if style effects reduce contrast. |
| Token Swatches | color, type, spacing, radius, material, shadow | Token names should match or map to `Design.md`. |
| Prompt Guidance | AI prompt phrase, anti-patterns, acceptance checklist | Keep it implementation-oriented, not mood-only. |

## Detail Page Composition Contract

The detail page's information architecture is part of the selected design style. Do not force every style into the Apple Liquid Glass detail layout, a shared top bar, a fixed hero card, or one universal scroll structure.

Each implementation-ready style should define its own detail page composition through its `Design.md` and runtime module:

- Overall page metaphor: canvas, document, control panel, object stage, editorial poster, dashboard, toy surface, gallery, or another style-appropriate structure.
- Opening experience: the first meaningful viewport that communicates identity, category, readiness, and the strongest visual signal.
- Navigation and escape path: native back button, custom top control, bottom command, side rail, embedded close action, or another accessible style-specific solution.
- Content progression: the order and grouping of demo slots should follow the style's logic, not a shared checklist order.
- Scroll and transition behavior: pinned chrome, paged sections, full-screen panels, long-form scroll, card stack, or inspector layout are all allowed when justified by the style.
- Responsive behavior: safe areas, compact width, Dynamic Type growth, VoiceOver order, and reduced-motion fallbacks must remain explicit.

### Required Behavior

- The user must always have an accessible way to leave the detail page.
- Current implementation-ready detail pages must keep a style-native top navigation control floating above the scroll content. The visual treatment can differ by style, but the control remains pinned in the root layer, not embedded in the scroll stack.
- The page must remain readable, touchable, and performant on iPhone-first layouts.
- Required demo slots must be discoverable, but they do not need to appear in the same order or container pattern across styles.
- Shared app shell elements can stay Apple Liquid Glass, but style detail pages may deliberately take over their own background, layout rhythm, navigation chrome, and section structure.
- A future style may propose a non-top escape path only when its `Design.md` explicitly justifies the page metaphor and preserves an equally clear, accessible back or close path.

### Anti-patterns

- Copying the Apple Liquid Glass detail page template into every style.
- Requiring a shared `MiDetailTopBar`, universal hero card, or fixed `ZStack` / `ScrollView` skeleton for all styles.
- Embedding the top navigation inside the scrolling content on implementation-ready detail pages.
- Treating the demo slot checklist as the page's visible information architecture.
- Hiding style identity inside isolated components while the page layout stays generic.
- Breaking iOS fundamentals such as safe areas, back behavior, touch target size, Dynamic Type, VoiceOver, or reduced motion in the name of style expression.

## Signature Interaction Contract

Every implementation-ready style must include a **Signature Interaction** in the opening experience or early detail flow. It is the most important interactive artifact of the style: a viewer should understand the style's tactile or structural philosophy within a glance.

### Required Elements

A Signature Interaction can be horizontal, vertical, overlaid, full-bleed, inspector-like, card-based, or embedded in another style-specific composition. It must include:

| Element | Required Content | Notes |
| --- | --- | --- |
| Signature control | a single, oversized, interactive atomic element built in the style's native language, such as a knob, switch, button, control surface, grid tile, source-color chip, or poster block | It should be the style's strongest visual idiom rendered at meaningful scale. |
| Reactive readout | 2-4 state details that reflect the control's state in real time | The readout may be metric rows, chips, captions, inspector fields, annotations, or another style-appropriate format. Values must visibly change when the control toggles. |

### Required Interaction

- The signature control **must respond to at least one tap-to-toggle state change** (e.g. ON/OFF, Active/Idle, mode cycle).
- The reactive readout **must visibly update** in response to the control's state.
- A press-down feedback (depth change, offset shift, scale, or shadow loss) is expected on platforms where it suits the style language.
- Continuous decorative animation (pulse, breathing glow, water ripple, etc.) is allowed only when intrinsic to the style's identity; it must not interfere with the discrete tap interaction.

### Style-Specific Examples

- **Apple Liquid Glass**: a large glass orb with accent inner glow and reflective highlight on the left; mode selector pills (Shell / Focus / Quiet) plus Tint / Radius metrics on the right. Tapping the orb cycles modes; the accent color, tint percentage, and corner radius all update.
- **Glassmorphism**: a frosted orb with translucent edge highlight on the left; layer, blur, and focus metrics on the right. Tapping toggles the glass focus state.
- **Neumorphism / Soft UI**: a raised circular power button with an inset dot constellation surrounding it; Status / Glow / Tap metrics on the right. Tapping toggles the power state; the button transitions raised↔pressed, dots illuminate in focusAccent with a breathing pulse.
- **Claymorphism**: an oversized puffy clay button with matte pastel fill and inner bevel shadows on the left; State / Depth / Shadow / Motion metrics on the right. Tapping compresses the object with a springy jelly press and updates the metrics.
- **Neo-Brutalism**: a square brutalist button with thick black border and large offset shadow (icon + uppercase label); Status / Hits / Mode metrics with hard-edged value chips on the right. Pressing collapses the shadow, increments the hit counter, and flips the status chips between green/red.
- **Minimalism**: a typographic grid tile on the left; grid, type, and density metrics on the right. Tapping switches quiet/dense hierarchy without decorative effects.
- **Material 3**: an expressive tonal container with a FAB-like action on the left; tone, shape, and state metrics on the right. Tapping switches expressive/calm role treatment.

### Implementation Rules

- Prefer a separate private `View` type for nontrivial signature interactions, but do not let that helper impose the page layout.
- It must never reuse another style's signature interaction. Each style owns its own composition and interaction model.
- Localize all status labels and values through `MiL10n.text`.
- Keep the interaction state local to the signature component unless the page design intentionally uses that state to drive surrounding style-specific content.
- Skip Markdown parsing and external data dependencies; the preview demonstrates style, not content.

## Spatial Component Contract

Mira's app shell uses Apple Liquid Glass and a spatial home constellation. Each style demo should therefore identify how it appears in these shared spatial contexts:

- **Home card preview**: screenshot background plus style name when assets exist; otherwise style name plus short introduction.
- **Detail opening experience**: style identity, localized name, category, `Design.md` path, screenshot status, readiness status, and the strongest page-level visual signal.
- **Signature interaction**: an interactive atomic showcase in the opening experience or early detail flow. Tap-to-toggle interaction is required. See "Signature Interaction Contract".
- **Detail navigation**: an accessible style-specific back or close path. Current implementation-ready pages use a floating top navigation control; alternative escape paths require explicit style-level justification.
- **Demo slot coverage**: all required demo slots visible through a style-appropriate information architecture.
- **Token panel**: swatches and implementation roles.
- **Guidance content**: Style Identity, Visual Tokens, Layout Rules, Component Guidance, Motion, Accessibility, Prompt Guidance, Anti-patterns, Acceptance Checklist. These may be sections, cards, annotations, inspector panels, or another style-specific presentation.
- **Unavailable state**: registered but incomplete styles should not open a shared placeholder page in the app. The home card can show a transient AlertToast-style message until the style owns its own module page.
- **Liquid Glass shell**: shared search, navigation, filters, and floating commands may use Liquid Glass; repeated cards and dense content should use lighter readable surfaces.
- **Scrolling performance**: detail demos should keep live blur and `glassEffect` on real controls such as search, segments, buttons, fixed shell controls, and floating commands; repeated section bodies use static gradients, strokes, and sparse tint.

## Implementation Rules

- New Swift types and files must use the `Mi` prefix.
- Style runtime data starts in `MiStyleRepository`; do not introduce Core Data for style entries in this phase.
- The app should not parse Markdown at runtime in the first implementation phase.
- Do not duplicate long style knowledge in Cursor, Claude, or Codex rule adapters.
- Keep Apple Liquid Glass as the app shell unless a task explicitly asks to redesign the shell.
- Style-specific detail pages may own their background, layout rhythm, navigation chrome, section structure, and transitions when that is part of the style. Keep global routing, accessibility, and app safety intact.
- Each implementation-ready style should own its SwiftUI screen code under `Mira/Features/Styles/<StyleModuleName>/`.
- Registered but unimplemented styles should show a lightweight AlertToast notice when tapped from Home.
- Do not use live blur or custom glass on every repeated home card; reserve custom glass for important controls and group adjacent effects with `GlassEffectContainer`.
- Do not put live Liquid Glass effects on every repeated detail section; search, segment, and button demos may use true Liquid Glass when they remain bounded interactive controls with a static fallback.
- Do not extract a shared style detail template that controls every page's layout. Share only neutral utilities that do not erase style-specific composition.

## Acceptance Checklist

- [ ] The target style has `docs/design-system/styles/<style-slug>/Design.md`.
- [ ] The style is registered in `MiStyleRepository`.
- [ ] The detail page uses a style-specific page composition instead of a copied shared template.
- [ ] The detail page covers all required demo slots through a style-appropriate information architecture.
- [ ] The opening experience or early detail flow includes a signature interaction with a reactive readout; tapping the control visibly updates the state.
- [ ] The detail page has a style-native floating top navigation control, an accessible back or close path, and respects safe areas, Dynamic Type, VoiceOver, and reduced motion.
- [ ] The homepage card handles screenshot and no-screenshot branches.
- [ ] Token swatches map to the style's documented tokens.
- [ ] Empty, loading, error, selected, disabled, and reduced-motion states are defined.
- [ ] VoiceOver can identify style name, category, screenshot status, and summary.
- [ ] The implementation follows iOS / SwiftUI baseline rules.
- [ ] All new Swift files and types use the `Mi` prefix.
