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
| Hero Preview | interactive atomic showcase living inside the Hero card (signature control + reactive status panel) | Required for every implementation-ready style. Must reveal the style's tactile philosophy in one glance and respond to at least one tap-to-toggle interaction. See "Hero Preview Contract" below. |
| Style Card | homepage card with screenshot branch and no-screenshot branch | Must follow Mira's medium rounded-rectangle card rule. |
| Surface / Material | primary content surface, shell surface, transient surface | For Liquid Glass, shell may be glass while content stays readable. |
| Button | primary, secondary, selected, disabled, destructive | At least 44x44 pt touch target. |
| Search / Input | default, focused, filled, cleared, error | For Liquid Glass, search is a functional glass shell control; it must stay readable over the app background. |
| Filter / Tag | unselected, selected, disabled, overflow | Category and style metadata chips belong here. |
| Navigation / Segmented | back, tab or segment, active indicator | Must preserve native iOS navigation expectations; Liquid Glass demos should use true glass for segment selectors on supported systems and keep a readable fallback. The detail page top bar must follow the "Detail Top Bar Contract" below. |
| Sheet / Inspector | floating panel, close action, prompt helper | Chrome can be glass; body copy must not sit on low-contrast translucent material. |
| Empty / Loading / Error | recoverable empty, skeleton/loading, error action | No blank screenshots or dead states. |
| Selected / Disabled | explicit visual and semantic states | Do not rely on color alone. |
| Motion Sample | press feedback, transition, reduced-motion fallback | Avoid animating blur radius directly. |
| Accessibility Sample | VoiceOver label, Dynamic Type, contrast, touch target | Include readable fallback if style effects reduce contrast. |
| Token Swatches | color, type, spacing, radius, material, shadow | Token names should match or map to `Design.md`. |
| Prompt Guidance | AI prompt phrase, anti-patterns, acceptance checklist | Keep it implementation-oriented, not mood-only. |

## Detail Top Bar Contract

Every style's detail page must use a **floating top bar** whose layout matches the Apple Liquid Glass detail page exactly. Visual style stays in the style's own language — but the layout, hierarchy, and scroll relationship are identical across all detail pages.

### Required Layout (identical across all styles)

1. The detail page's root is a `ZStack(alignment: .top)`.
2. The content lives inside a `ScrollView` whose top padding leaves room for the floating bar (Apple Liquid Glass uses `86`, Neumorphism uses `86`, Neo-Brutalism uses `104` to accommodate hard-offset shadow — pick the smallest value that fully clears the bar plus a small breathing gap).
3. The top bar is placed **after** the `ScrollView` inside the `ZStack`, with `.padding(.horizontal, …)`, `.padding(.top, 8)`, and `.zIndex(20)`. The bar is a single self-contained card / capsule — never a `VStack` with a fade gradient or a full-width opaque banner.
4. Scrolling list content must pass **behind** the top bar (no fade mask, no gradient cover above the content). The bar's own surface (glass, raised neumorphic card, brutalist card, etc.) is what visually separates it from the scrolling content.
5. The top bar attaches `.navigationBarBackButtonHidden(true)` and `.toolbar(.hidden, for: .navigationBar)` at the root.

### Visual Style (per-style, not shared)

- **Do not** extract a shared `MiDetailTopBar` component across styles. Each style owns its own private top bar view inside its module (`MiAppleLiquidGlass… MiDetailTopBar`, `MiNeumorphismTopBar`, `MiNeoBrutalismTopBar`, etc.).
- The bar's surface — glass, raised soft surface, brutalist card with offset shadow — must follow the style's own design language.
- The bar's contents (back button, title, status indicator) should match the style's typography, palette, and chrome (e.g. SF semibold rounded for Liquid Glass, black weight uppercase for Neo-Brutalism, soft surface inner controls for Neumorphism).

### Anti-patterns

- ❌ Adding a fade `LinearGradient` strip below the top bar (this stops content from truly scrolling past).
- ❌ Painting an opaque full-width banner behind the bar (the bar should sit on its own card surface, not on top of a colored strip).
- ❌ Extracting a single shared `MiDetailTopBar` SwiftUI type used by multiple styles.
- ❌ Embedding the top bar inside the `ScrollView` instead of pinning it via `ZStack` + `zIndex`.

## Hero Preview Contract

Every implementation-ready style must embed a **Hero Preview** inside its detail Hero card. The Hero Preview is the single most important visual artifact of the style — it should let any viewer (human or AI agent) understand the style's tactile philosophy within a glance.

### Required Structure

A Hero Preview is a horizontal two-column composition that lives inside (or directly beneath) the Hero title block:

| Column | Required Content | Notes |
| --- | --- | --- |
| Left (signature control) | a **single, oversized, interactive** atomic element built in the style's native language — e.g. a knob, switch, button, control surface | Must be the style's strongest visual idiom rendered at large scale (≥ 110pt on the short side). |
| Right (reactive status panel) | a vertical stack of **2–4 metric rows** that reflect the control's state in real time | Each row is a label (uppercase, tracked) + a styled value chip. Values must visibly change when the control toggles. |

### Required Interaction

- The signature control **must respond to at least one tap-to-toggle state change** (e.g. ON/OFF, Active/Idle, mode cycle).
- The reactive status panel **must visibly update** in response to the control's state.
- A press-down feedback (depth change, offset shift, scale, or shadow loss) is expected on platforms where it suits the style language.
- Continuous decorative animation (pulse, breathing glow, water ripple, etc.) is allowed only when intrinsic to the style's identity; it must not interfere with the discrete tap interaction.

### Style-Specific Examples (current implementations)

- **Apple Liquid Glass**: a large glass orb with accent inner glow and reflective highlight on the left; mode selector pills (Shell / Focus / Quiet) plus Tint / Radius metrics on the right. Tapping the orb cycles modes; the accent color, tint percentage, and corner radius all update.
- **Glassmorphism**: a frosted orb with translucent edge highlight on the left; layer, blur, and focus metrics on the right. Tapping toggles the glass focus state.
- **Neumorphism / Soft UI**: a raised circular power button with an inset dot constellation surrounding it; Status / Glow / Tap metrics on the right. Tapping toggles the power state; the button transitions raised↔pressed, dots illuminate in focusAccent with a breathing pulse.
- **Claymorphism**: an oversized puffy clay button with matte pastel fill and inner bevel shadows on the left; State / Depth / Shadow / Motion metrics on the right. Tapping compresses the object with a springy jelly press and updates the metrics.
- **Neo-Brutalism**: a square brutalist button with thick black border and large offset shadow (icon + uppercase label); Status / Hits / Mode metrics with hard-edged value chips on the right. Pressing collapses the shadow, increments the hit counter, and flips the status chips between green/red.
- **Minimalism**: a typographic grid tile on the left; grid, type, and density metrics on the right. Tapping switches quiet/dense hierarchy without decorative effects.
- **Material 3**: an expressive tonal container with a FAB-like action on the left; tone, shape, and state metrics on the right. Tapping switches expressive/calm role treatment.

### Implementation Rules

- The Hero Preview is a **separate `View` type** inside the style's module (e.g. `MiNeumorphismHeroPreview`, `MiAppleLiquidGlassHeroPreview`).
- It must **never reuse another style's Hero Preview** — each style owns its own composition.
- Localize all status labels and values through `MiL10n.text`; use uppercase letter-spaced labels for that "instrument-grade" feel.
- Keep the Hero Preview self-contained: its state is `@State` local to the preview, not lifted into the detail view.
- Skip Markdown parsing and external data dependencies; the preview demonstrates style, not content.

## Spatial Component Contract

Mira's app shell uses Apple Liquid Glass and a spatial home constellation. Each style demo should therefore identify how it appears in these shared spatial contexts:

- **Home card preview**: screenshot background plus style name when assets exist; otherwise style name plus short introduction.
- **Detail hero**: style identity, localized name, category, `Design.md` path, screenshot status, readiness status.
- **Detail hero preview**: an interactive atomic showcase embedded in the Hero card — a signature control on the left and reactive status panel on the right. Tap-to-toggle interaction is required. See "Hero Preview Contract".
- **Detail top bar**: a floating, style-native top bar pinned to the top of the detail page via `ZStack` + `zIndex`. Scrolling list content must pass behind it with no fade mask. See "Detail Top Bar Contract".
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
- [ ] The detail Hero embeds a Hero Preview with a signature interactive control and a reactive status panel; tapping the control visibly updates the panel.
- [ ] The detail page uses a floating top bar (ZStack + zIndex, no fade mask, no opaque banner); scrolling content passes behind the bar; the bar's visual style follows the style's own language and is not shared across styles.
- [ ] The homepage card handles screenshot and no-screenshot branches.
- [ ] Token swatches map to the style's documented tokens.
- [ ] Empty, loading, error, selected, disabled, and reduced-motion states are defined.
- [ ] VoiceOver can identify style name, category, screenshot status, and summary.
- [ ] The implementation follows iOS / SwiftUI baseline rules.
- [ ] All new Swift files and types use the `Mi` prefix.
