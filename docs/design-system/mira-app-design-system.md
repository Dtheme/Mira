# Mira App Design System / Mira App 设计系统

## Design Direction

Mira App uses **Apple Liquid Glass / 苹果液态玻璃** as the default app shell style.

Source style file:

```text
docs/design-system/styles/apple-liquid-glass/Design.md
```

Implementation demo standard:

```text
project-standards/design-demo-standard.md
```

The app should feel like a premium iOS-native design encyclopedia: liquid, spatial, luminous, and highly interactive. Mira defaults to a light **Soft Frost Liquid Glass** expression: pale system backgrounds, white glass cards, soft blue-gray shadows, and dark readable content. The shell can be visually prominent, but style content must remain readable and inspectable.

Official Apple Liquid Glass contract:

- Use standard SwiftUI controls, navigation, sheets, menus, and toolbars whenever they satisfy the UI need.
- Treat Liquid Glass as a functional top layer for search, navigation, filters, inspectors, and transient controls.
- Keep encyclopedia content and high-frequency home cards on readable, lightweight surfaces.
- Use `GlassEffectContainer` when several custom glass controls sit near each other.
- Test custom glass under reduced transparency, reduced motion, Dynamic Type, and high-contrast display settings.

## Design Principles

- **Liquid shell, readable content**: navigation, search, filters, and overlays use Liquid Glass; long text and dense style details use stable readable surfaces.
- **Light-first visual system**: the default app appearance is soft, pale, and frosted. Dark surfaces are reserved for screenshots, scrims, or future dark mode.
- **Spatial discovery**: the home screen is a full-screen two-axis style constellation, inspired by Apple Watch's app list navigation, adapted to medium rounded-rectangle cards.
- **Style-first previews**: if a style has a screenshot, the card uses it as the primary visual. If not, the card shows the style name and short introduction.
- **AI-reference clarity**: each style card should help users and AI quickly understand what the style is, whether or not visual assets exist.
- **SwiftUI-native implementation**: use native gestures, materials, safe areas, Dynamic Type, VoiceOver, and reduced-motion fallbacks.
- **Performance as design quality**: the Apple Watch-style canvas must feel fluid; do not spend the frame budget on live blur for every repeated card.

## Color System

### Primitive Tokens

Use these as the first implementation palette. They can later become `MiColorTokens`.

| Token | Value | Usage |
| --- | --- | --- |
| `mi-obsidian-950` | `#05070D` | dark scrim and future dark-mode foundation |
| `mi-graphite-900` | `#111827` | deep readable foreground and dark fallback surface |
| `mi-frost-050` | `#F7FBFF` | light glass highlight |
| `mi-frost-100` | `#EAF2FF` | pale luminous surface |
| `mi-apple-blue-500` | `#0A84FF` | primary Apple-like action |
| `mi-aqua-400` | `#00C7BE` | secondary liquid accent |
| `mi-iris-500` | `#7C3AED` | AI / creative accent |
| `mi-lime-400` | `#C7F464` | active discovery accent |
| `mi-rose-500` | `#FF375F` | warning/destructive accent |
| `mi-amber-400` | `#FFD60A` | highlight and attention accent |

### Semantic Tokens

| Token | Light Role | Dark Role |
| --- | --- | --- |
| `mi-color-app-background` | frosted pale gradient | obsidian layered gradient |
| `mi-color-content-primary` | graphite text | frost text |
| `mi-color-content-secondary` | graphite at reduced opacity | frost at reduced opacity |
| `mi-color-glass-shell` | frost material with blue tint | dark material with blue/iris tint |
| `mi-color-glass-border` | white highlight + blue opacity | white highlight + aqua opacity |
| `mi-color-primary-action` | Apple blue | Apple blue |
| `mi-color-ai-action` | iris | iris |
| `mi-color-active-style` | lime or aqua | lime or aqua |

Default light roles:

- `mi-color-app-background`: pale frost gradient with very soft blue, aqua, and iris depth.
- `mi-color-content-primary`: dark graphite-blue text.
- `mi-color-content-secondary`: muted blue-gray text.
- `mi-color-glass-shell`: translucent white with subtle Apple blue tint.
- `mi-color-glass-border`: white highlight plus low-opacity blue/accent edge.
- `mi-color-card-surface`: static white/frost gradient, not per-card live blur.

### Component Tokens

| Token | Description |
| --- | --- |
| `mi-home-background-gradient` | full-screen light layered color field with subtle frost and blue depth, no live blur requirement |
| `mi-home-card-radius` | medium rounded rectangle radius, 28-32 pt on iPhone |
| `mi-home-card-screenshot-overlay` | bottom-to-top gradient scrim for readable style name |
| `mi-home-card-placeholder-background` | lightweight static white/frost glass-tinted surface for styles without screenshots |
| `mi-home-search-glass` | floating top search/control shell |
| `mi-home-filter-glass` | category filter capsule rail |
| `mi-home-card-focus-shadow` | soft large shadow plus luminous edge for centered card |

## Typography

- Use system typography first.
- Large title: app-level moments such as "Mira" or collection names.
- Title 2 / Title 3: style names on cards and detail headers.
- Body: descriptions and style explanations.
- Caption: category, risk, and metadata chips.
- Text inside screenshot cards must have a scrim or readable glass label behind it.

## Home Screen: Spatial Style Constellation

### Core Interaction

The home screen uses a full-screen **two-axis free pan canvas** inspired by the Apple Watch app list.

- Users can slide the canvas horizontally, vertically, and diagonally across the full screen.
- The interaction should feel 360-degree in navigation freedom, but it is a 2D spatial canvas, not a 3D sphere.
- Cards form a loose constellation/grid of design styles.
- The card nearest the center becomes visually focused through scale, shadow, brightness, and stronger glass edge.
- Momentum, rubber-banding, and subtle parallax are allowed when they remain comfortable.
- A search/filter glass shell should remain reachable without blocking exploration.

### Card Form

Cards are medium rounded rectangles, not Apple Watch circular icons.

Recommended starting sizes:

| Device | Card Width | Card Height | Radius |
| --- | --- | --- | --- |
| iPhone compact | 174 pt | 222 pt | 28 pt |
| iPhone regular | 186 pt | 236 pt | 30 pt |
| iPhone large | 198 pt | 250 pt | 32 pt |
| iPad | 220 pt | 272 pt | 34 pt |

Cards may scale around the center focus:

- focused: 1.20-1.26
- normal: 1.0
- distant: 0.58-0.80

### Card Content Rules

#### With Screenshot

If a style has a homepage screenshot:

- Use the screenshot as a full-bleed background.
- Apply a bottom scrim or compact glass label for the style name.
- Keep the style name readable over colorful screenshots.
- Optional metadata chip can show category or style family.
- Do not cover the screenshot with long text.

Required content:

```text
Style screenshot + style name
```

#### Without Screenshot

If a style has no screenshot:

- Use a lightweight Apple-style placeholder surface; avoid live material on every repeated home card.
- Show the style name prominently.
- Show a 1-2 line simple introduction.
- Use subtle accent tint from the style category.
- Keep placeholder cards visually distinct from screenshot cards but not empty.

Required content:

```text
Style name + short introduction
```

### Layout Behavior

- Use a loose honeycomb or staggered grid so diagonal movement feels natural.
- Avoid perfectly uniform rows that make the interaction feel like a normal scroll view.
- Keep enough spacing between cards so rounded rectangles do not visually merge.
- The initial viewport should show one dominant center card and partial surrounding cards.
- The app should support quick return to center/home cluster.
- Render only cards near the viewport; target about 12 cards on iPhone and about 14 on iPad so the spatial buffer can avoid edge pop-in.
- During drag, card effects should rely on transform, opacity, static gradient, lightweight stroke, and reduced shadow layers rather than per-card live blur.
- The spatial renderer should use a stable anchored neighborhood of card slots instead of sorting and replacing the nearest cards every frame.
- Drag offset should be continuous state, not a gesture state that resets before release animation starts.
- On drag end, if a card is already close to the viewport center, the canvas should use a short spring to snap that card into the exact center.

### Navigation

- Tapping a card opens that style's detail page.
- Long press can later open quick actions: view Design.md, copy prompt guidance, compare style.
- Search should jump or animate to matching cards.
- Category filters can dim nonmatching cards instead of immediately removing them, preserving the spatial map.

### Empty / Loading States

- Loading: show translucent card skeletons in the constellation positions.
- Empty search: show a centered glass message with one recovery action.
- Missing screenshots: use the placeholder card rule, not a blank asset.

## Detail Screen: Soft Frost Liquid Glass

- Fixed navigation, back controls, search shells, segmented controls, and buttons should use true Liquid Glass when the platform supports it.
- Scrolling detail content should use lightweight static frost surfaces: single gradient fill, luminous stroke, sparse accent tint, and minimal or no shadow.
- Do not place `glassEffect(_:in:)`, large live material, or heavy multi-shadow stacks on repeated sections, token tiles, bullets, or component cards.
- Segment selectors should use `glassEffect(_:in:)` on supported systems, with a pale capsule container, lens-like selected segment, readable labels, and at least 44 pt touch targets.
- Selected-state motion should be short and interruptible, using opacity, tint, and transform rather than animating blur radius or layout size.
- Long text remains on stable readable surfaces; Liquid Glass is the chrome around navigation and controls, not the paragraph background itself.

## SwiftUI Implementation Contract

Future code should use `Mi`-prefixed names. Suggested future units:

- `MiHomeView`
- `MiStyleConstellationView`
- `MiStyleCardView`
- `MiStyleCardContent`
- `MiDesignStyle`
- `MiStyleScreenshot`
- `MiColorTokens`
- `MiGlassSurfaceModifier`
- `MiAppleLiquidGlassSearchControl`

The implementation should separate:

- style data
- spatial card layout
- card rendering
- Liquid Glass shell controls
- detail navigation

Home implementation rules:

- The top search and floating commands are the primary Liquid Glass surfaces.
- The canvas background is a static light layered color field with optional system fallback material only in small shell controls.
- Style cards use static gradients, scrims, strokes, and restrained shadows so the pan gesture remains fluid.
- Detail pages use the same Soft Frost Liquid Glass foundation as Home: pale ambient background, white glass panels, dark readable text, and accent-only style identity.
- Detail pages keep live `glassEffect` limited to actual controls such as search, segmented selectors, buttons, and fixed shell chrome; ordinary scroll sections use static glass-like gradients and strokes for smoother movement.
- The centered home card should read as a raised main object: brighter white glass, stronger blue-gray ambient shadow, subtle accent shadow, and a clearer luminous border.
- Dragging should temporarily simplify card shadows, then restore full depth after the gesture settles.
- The nearest card to the center owns the largest scale and visual priority; surrounding cards remain visible but cheaper.
- Search should focus the best matching card by moving it to the center, not by replacing the spatial map.

Each implementation-ready style detail should also satisfy the component slots and state requirements in `project-standards/design-demo-standard.md`.

## Accessibility

- Provide a non-spatial ordered navigation path for VoiceOver users.
- VoiceOver should read style name, category, screenshot availability, and short introduction.
- Dynamic Type should not clip card titles; screenshot cards may move text into a readable label.
- Reduced Motion should disable large parallax and focus zoom, using opacity and clear selection states instead.
- The full-screen pan canvas must not hide primary actions behind gesture-only interaction.

## Acceptance Checklist

- [ ] Home uses full-screen two-axis spatial panning inspired by Apple Watch app list navigation.
- [ ] Cards are medium rounded rectangles, not circles.
- [ ] Cards with screenshots show screenshot background plus style name.
- [ ] Cards without screenshots show style name and a short introduction.
- [ ] Liquid Glass is prominent in shell controls and card treatment without weakening readability.
- [ ] Home card rendering avoids live blur on every repeated card.
- [ ] Home renders about 10 cards on iPhone and about 12 on iPad.
- [ ] Center/focused card has a clear visual state.
- [ ] Search/filter controls remain reachable.
- [ ] Detail scrolling content avoids live glass effects on ordinary panels, repeated heavy shadows, and expensive nested material layers.
- [ ] Apple Liquid Glass detail demos include real Liquid Glass search, segmented selectors, and buttons on supported systems.
- [ ] VoiceOver has an ordered fallback path through styles.
- [ ] Reduced Motion has a non-parallax fallback.
- [ ] All new Swift types and files use the `Mi` prefix.
- [ ] Implementation-ready style demos expose the required slots from `project-standards/design-demo-standard.md`.
