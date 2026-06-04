# Bento Grid / 便当网格

## Style Identity

- **Status**: Style documented. Runtime detail page pending under `Mira/Features/Styles/BentoGrid/`.
- **Definition**: Bento Grid is a layout-led style that arranges content into a modular mosaic of rounded rectangular cells of varied sizes — like a Japanese bento box — where each cell is a self-contained, scannable module.
- **Core Feeling**: 模块化、清晰、信息有密度但有呼吸、精致现代、可快速扫描。
- **Visual Keywords**: modular cells, varied tile sizes, rounded rectangles, consistent gutters, dashboard mosaic, asymmetric balance, one hero tile, calm neutral surfaces.
- **iOS Interpretation**: Treat Bento Grid as a composition system, not a material effect. Use `Grid`/`LazyVGrid` with spanning cells, consistent corner radius and gutters, neutral elevated surfaces, and hierarchy driven by cell size and content rather than decoration.

## Best Use Cases

- Suitable screens: dashboards, profile/overview, feature highlights, analytics summaries, settings overview, onboarding feature grids, "what's new" boards.
- Suitable product moods: modern, organized, premium, product-marketing, confident.
- Suitable content types: metrics, sparklines/charts, media thumbnails, single actions, short list snippets, toggles, status tiles.
- Best audience fit: SaaS, productivity, analytics, portfolio, and product landing experiences.

## Avoid When

- Do not use for: long-form reading, single linear task flows, deep hierarchical drill-down where a grid fragments attention.
- Risky contexts: very small screens with too many cells, content that does not chunk into modules.
- Accessibility concerns: tiny cramped cells with small text; fixed-height cells that clip at large Dynamic Type.
- Product mismatch: immersive media players, document editors, or step-by-step wizards.

## Visual Tokens

### Color Tokens

- Primitive:
  - `mi-bento-canvas`: `#EEF0F4` slightly darker neutral page so cells read as raised.
  - `mi-bento-surface`: `#FFFFFF` primary cell surface.
  - `mi-bento-surface-alt`: `#F6F7F9` secondary/muted cell.
  - `mi-bento-ink`: `#1A1D24` titles and metrics.
  - `mi-bento-muted`: `#6B7280` captions and labels.
  - `mi-bento-accent`: `#5B6CFF` primary accent for one highlighted tile.
  - `mi-bento-accent-2`: `#15C39A` secondary accent for a category tile.
- Semantic:
  - `mi-bento-hero-cell`: largest weighted module (metric or feature).
  - `mi-bento-metric-cell`: number-led summary module.
  - `mi-bento-media-cell`: image/preview module.
  - `mi-bento-action-cell`: single-action or toggle module.
- Component:
  - `mi-bento-cell-background`, `mi-bento-cell-stroke`, `mi-bento-tag-background`.

### Typography Tokens

- Display: large rounded numbers/titles for hero and metric cells.
- Title: medium-bold cell headers.
- Body: short supporting copy inside cells; avoid paragraphs.
- Label: small uppercase category tags inside cells.

### Shape / Radius Tokens

- Surface: continuous rounded rectangles, 20-28 pt, identical radius across the whole board.
- Button: rounded rect or capsule inside a cell.
- Card: each cell IS the card; keep one consistent radius for visual cohesion.
- Control: small rounded chips and pills inside cells.

### Elevation / Material Tokens

- Surface depth: cells sit subtly above the canvas via a soft low shadow OR a hairline; keep it clean, never heavy.
- Shadow: small soft neutral shadow (e.g., 8-12 pt blur, low opacity); avoid hard or colored shadows.
- Blur / material: no glass blur; flat neutral fills keep the mosaic crisp.
- Border: optional 1 pt hairline `mi-bento-cell-stroke` for separation on light canvases.

## Layout Rules

- Composition: build a responsive mosaic where cells span different column/row counts (1x1, 2x1, 1x2, 2x2). Exactly one hero cell is visually largest.
- Grid: consistent column count and a single gutter value; never mix radii or gutter sizes.
- Spacing: equal gutters between all cells; generous outer margins so the board breathes.
- Density: medium; group related modules adjacently; do not chase maximum tiles.
- Hierarchy: express priority through cell size and content weight, not borders or color noise.
- Safe area: respect top/bottom safe areas; on iPhone collapse to 2 columns and let hero/wide cells span full width.

## Component Guidance

- Navigation: standard iOS navigation; tapping a cell opens its detail. Use SwiftUI `NavigationStack`.
- Button: action cells contain one clear primary control; keep at least 44 pt height.
- Card: each cell is a module with a header label, a focal value/visual, and optional one-line caption. Build with `RoundedRectangle(style: .continuous)` surfaces.
- Sheet / Modal: cell detail can open in a sheet that reuses the same rounded surface language.
- Form: inputs live inside a dedicated input cell with a visible label and clear focus ring.
- Tab / Segmented Control: a board-level segmented control can switch the mosaic's data set.
- Empty state: per-cell empty placeholder with a short recovery action, not a blank tile.
- Paywall / subscription surface: a hero plan cell plus supporting feature cells; keep pricing text high contrast on a solid cell.

## iOS / SwiftUI Notes

- SwiftUI primitives: use `Grid` with `gridCellColumns(_:)` for spanning, or `LazyVGrid` with explicit wide/tall cells; `RoundedRectangle(style: .continuous)` for every cell.
- Recommended modifiers: consistent `.cornerRadius`/`clipShape`, `.shadow` (soft), `.aspectRatio` or pinned row heights for a tidy mosaic, `miStaggeredReveal` for entrance.
- Native controls to preserve: navigation, sheet dismissal, tab selection, list/scroll behavior inside cells.
- Performance notes: keep cell backgrounds flat (no live material); reuse a single shadow style; avoid nesting scroll views inside cells.
- Dynamic Type notes: let cells grow vertically; never hard-clip a fixed-height cell; wide cells should reflow content at large sizes.

## Motion Rules

- Transition: cells stagger-reveal on appear with a short offset+opacity.
- Press feedback: subtle scale-down (0.97) on a tappable cell; no bounce.
- Loading: per-cell skeleton blocks that match each cell's shape.
- Gesture response: optional reorder/expand of a focused cell with a gentle spring.
- Reduced motion fallback: replace stagger and scale with simple opacity changes.

## Accessibility

- Contrast: dark ink on light cells; check muted captions against `mi-bento-surface-alt`.
- VoiceOver: each cell is one element that announces its title and value; group inner content.
- Dynamic Type: cells expand; wide cells reflow; never truncate critical metrics.
- Touch target: any in-cell control is at least 44x44 pt.
- Color-only meaning: status tiles need an icon or label in addition to accent color.

## Prompt Guidance

### Use This Style When Prompt Says

- Trigger phrases: Bento Grid, 便当网格, modular dashboard, mosaic layout, tile grid, keynote-style grid, feature bento.
- Related product scenarios: overview dashboards, feature highlight pages, profile summaries, analytics boards.

### AI Output Should Include

- Visual direction: clean modular mosaic, one hero cell, consistent radius and gutters, neutral elevated surfaces.
- Token suggestions: canvas vs surface neutrals, one or two accents, soft shadow, single radius scale.
- Component behavior: spanning cells, per-cell modules, tap-to-detail, per-cell skeleton/empty/error states.
- SwiftUI notes: `Grid`/`gridCellColumns` or `LazyVGrid`, continuous rounded rectangles, soft shadows, Dynamic-Type-safe cells.
- Risks and acceptance checks: cramped tiny cells, inconsistent radii/gutters, fixed-height clipping, no clear hierarchy.

## Anti-patterns

- Do not: cram many tiny equal cells with no hero; mix corner radii or gutter sizes; use the grid for linear reading; rely on color alone for status.
- Avoid: heavy or colored shadows; glass/blur surfaces that muddy the crisp mosaic; deep scroll-inside-cell nesting.
- Common shallow interpretation: "just put cards in a grid" — Bento Grid needs deliberate size hierarchy, consistent rhythm, and one focal hero cell.

## Acceptance Checklist

- [ ] The result is recognizable as a Bento mosaic with varied cell spans and one hero cell.
- [ ] Corner radius and gutters are consistent across the whole board.
- [ ] The result remains usable on iPhone (collapses to fewer columns).
- [ ] Touch targets are at least 44x44 pt.
- [ ] Body text supports Dynamic Type and cells grow instead of clipping.
- [ ] Contrast is checked for all text-on-cell pairs.
- [ ] Empty, loading, error, and selected cell states are defined.
- [ ] Motion has a reduced-motion fallback.
- [ ] SwiftUI notes use native iOS concepts (`Grid`/`LazyVGrid`, continuous rounded rectangles).
- [ ] Anti-patterns from this document are avoided.
