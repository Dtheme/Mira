# Apple Liquid Glass / 苹果液态玻璃

## Style Identity

- **Definition**: Apple Liquid Glass is a dynamic Apple platform material style that creates a floating functional layer for controls, navigation, search, toolbars, and transient interface elements.
- **Core Feeling**: 轻盈、流动、半透明、有光学折射感，同时保持 Apple 系统级秩序和可读性。
- **Visual Keywords**: liquid, lensing, translucency, floating controls, depth, adaptive tint, soft refraction, rounded geometry, luminous edge, content peeking.
- **iOS Interpretation**: Mira should use Liquid Glass as a prominent light-first app shell language: navigation, search, filters, tab/sidebar surfaces, floating actions, inspectors, and preview overlays should feel glass-like. The encyclopedia content itself remains readable and structured.
- **Mira Default Expression**: Soft Frost Liquid Glass. Use pale backgrounds, translucent white glass, subtle blue-gray depth, dark graphite text, and sparse accent tint.

## Source References / 官方参考

- Apple Technology Overview: `https://developer.apple.com/documentation/TechnologyOverviews/liquid-glass`
- Apple adoption guide: `https://developer.apple.com/documentation/TechnologyOverviews/adopting-liquid-glass`
- SwiftUI custom effect API: `glassEffect(_:in:)`
- SwiftUI grouping API: `GlassEffectContainer`

Official interpretation for Mira:

- Liquid Glass is a functional top layer for controls and navigation, not a decorative background treatment for every surface.
- Standard SwiftUI, UIKit, and AppKit controls should pick up the platform appearance first; custom glass is only for important app-specific controls.
- Custom backgrounds on navigation and control chrome can interfere with system-provided Liquid Glass, scroll-edge behavior, and focus adaptation.
- `GlassEffectContainer` should group nearby custom glass controls so SwiftUI can render them together and let shapes interact or morph.
- Users may reduce transparency or motion in Settings; Mira must remain readable and operable when those effects are reduced.

## Best Use Cases

- Suitable screens:
  - home dashboard / style discovery
  - style list and search
  - style detail navigation shell
  - floating filter panels
  - compare and preview tools
  - AI prompt helper surfaces
- Suitable product moods:
  - Apple-native design intelligence
  - curated design archive
  - premium creative tool
  - dynamic visual encyclopedia
- Suitable content types:
  - style cards
  - live previews
  - token panels
  - prompt guidance snippets
  - structured metadata
- Best audience fit:
  - designers, developers, AI-assisted builders, product makers, and users who expect polished iOS-native interactions.

## Avoid When

- Do not use for:
  - dense long-form reading surfaces where transparency weakens legibility
  - plain content cells that should be easy to scan
  - every card in a grid
  - background decoration with no functional role
  - high-frequency panning or scrolling content where each item would require live material rendering
- Risky contexts:
  - high-frequency scrolling lists
  - small text overlays on colorful previews
  - nested glass over glass
  - style samples that already use strong effects, such as Glassmorphism
- Accessibility concerns:
  - foreground text can lose contrast over colorful content
  - blur and tint can make hierarchy ambiguous
  - excessive motion can create fatigue
- Product mismatch:
  - avoid turning Mira into a generic glass demo. Liquid Glass should frame the encyclopedia, not replace the style content.

## Visual Tokens

### Color Tokens

- Primitive:
  - `mi-glass-white`: translucent white
  - `mi-glass-ink`: deep graphite foreground
  - `mi-glass-blue`: cool Apple-like accent
  - `mi-glass-violet`: creative accent for AI actions
  - `mi-glass-lime`: sparse highlight for active style tags
- Semantic:
  - `mi-color-background`: clean pale layered app background
  - `mi-color-content`: primary readable content surface
  - `mi-color-glass-control`: floating control material
  - `mi-color-glass-navigation`: tab, sidebar, and toolbar material
  - `mi-color-glass-accent`: active command and selected state tint
  - `mi-color-glass-separator`: subtle luminous border
- Component:
  - `mi-search-glass-background`
  - `mi-tab-glass-background`
  - `mi-filter-chip-glass-background`
  - `mi-floating-panel-glass-background`
  - `mi-preview-overlay-glass-background`

### Typography Tokens

- Display:
  - large, confident, San Francisco-like system typography
  - use for app title, style collection headings, and major discovery moments
- Title:
  - medium weight, compact line height, clear hierarchy
  - use for style cards and detail sections
- Body:
  - system body text with Dynamic Type support
  - keep long explanations on opaque or near-opaque content surfaces
- Label:
  - small but readable metadata labels
  - avoid decorative micro text over translucent surfaces

### Shape / Radius Tokens

- Surface:
  - large continuous rounded rectangles that echo Apple hardware geometry
- Button:
  - capsule or rounded rect depending on density
- Card:
  - content cards should be stable and readable, not all glass
- Control:
  - prominent glass controls use capsule geometry with soft borders

### Elevation / Material Tokens

- Surface depth:
  - content layer at base
  - Liquid Glass functional layer above
  - modal or inspector layer highest
- Shadow:
  - soft blue-gray outer shadow for separation
  - inner edge highlight for glass definition
- Blur / material:
  - use SwiftUI material for navigation and floating controls
  - use `glassEffect(_:in:)` only for important custom controls on supported OS versions
  - group related custom glass controls in `GlassEffectContainer`
  - increase opacity when text or icons need contrast
- Border:
  - thin luminous stroke on glass surfaces
  - avoid heavy borders except inside style-specific previews

## Layout Rules

- Composition:
  - keep content and controls in separate visual layers
  - let content scroll beneath navigation/search glass where appropriate
  - avoid placing primary long text directly inside transparent glass
  - keep live Liquid Glass on top-level controls; keep high-frequency card canvases on lighter static surfaces
- Mira app system:
  - follow `docs/design-system/mira-app-design-system.md` for the concrete app palette, homepage layout, and style-card behavior
- Grid:
  - style cards may use a clean editorial grid
  - glass controls can float above the grid for search/filter/sort
  - the home screen uses a two-axis spatial card constellation inspired by Apple Watch app list navigation, but with medium rounded-rectangle cards
- Spacing:
  - use generous spacing around floating controls to make the glass layer intentional
  - avoid cramped translucent clusters
- Density:
  - app shell can be visually expressive; content sections stay calm and readable
- Hierarchy:
  - glass means "interactive shell" or "temporary control", not "all surfaces"
  - active glass elements should have stronger tint, edge, and shadow than passive surfaces
- Safe area:
  - respect top/bottom safe areas
  - bottom navigation glass should feel integrated with the home indicator area

## Component Guidance

- Navigation:
  - use system navigation, toolbar, tab, sheet, and menu components before building custom chrome
  - use Liquid Glass for tab bars, sidebars, toolbar backgrounds, and navigation controls
  - selected tab uses brighter tint and stronger edge highlight
- Button:
  - primary actions can use tinted glass capsules
  - destructive actions should not rely on glass tint alone; include clear labels and color semantics
- Card:
  - style cards should show style-specific previews on the content layer
  - cards may have subtle static chrome or action strips, but the main content must remain inspectable
  - home cards with screenshots use full-bleed screenshot backgrounds plus readable style names
  - home cards without screenshots show the style name and a short introduction on a lightweight, readable white/frost placeholder surface
  - avoid applying live glass material to every card in the Apple Watch-style home canvas
  - the Apple Liquid Glass home card (`MiAppleLiquidGlassHomePreview`) demonstrates the doctrine itself: an opaque soft-frost content page (title, hook, quiet page furniture) with ONE floating glass dock capsule as the signature control, whose lens uses a browse (grid) semantic, not search; glass is double-gated (`glassEffect` behind `#available(iOS 26,*)`, `ultraThinMaterial` fallback, flat gradient while the canvas pans)
- Sheet / Modal:
  - use glass for sheet chrome, grabber area, close/action controls, and inspector headers
  - body content uses readable grouped sections
- Form:
  - search and filters can be glass
  - text entry fields need sufficient opacity and clear focus states
- Tab / Segmented Control:
  - segmented controls are strong candidates for Liquid Glass
  - selected state should feel like a light-concentrated lens
  - in scrolling detail demos, use true `glassEffect(_:in:)` for the segment control itself on supported systems, with a static fallback on older systems
  - keep labels readable and touch targets at least 44 pt high when the selector is used as a primary control
- Empty state:
  - use a quiet opaque message surface with a glass primary action
- Paywall / subscription surface:
  - if introduced later, glass can emphasize plan switcher, feature highlights, and sticky CTA, but pricing text must remain high contrast.

## iOS / SwiftUI Notes

- SwiftUI primitives:
  - use system materials for glass-like functional layers
  - prefer standard SwiftUI controls and containers so the platform can provide Liquid Glass behavior automatically
  - use rounded rectangles, capsules, overlays, shadows, and safe-area-aware layout
  - use `TabView`, `NavigationStack`, `toolbar`, sheets, and native controls where possible
- Recommended modifiers:
  - `glassEffect(_:in:)` for important custom shell controls on supported OS versions
  - `GlassEffectContainer` around related search, action, segmented, and inspector controls
  - material backgrounds for fallback shell controls on older OS versions
  - subtle overlay stroke for glass definition
  - shadow and highlight pairing for elevation
  - scroll-edge-aware visual treatment for top and bottom bars
- Native controls to preserve:
  - navigation back behavior
  - sheet dismissal gestures
  - tab selection
  - search field conventions
  - context menus where useful
- Performance notes:
  - do not stack multiple large blur layers over scrolling content
  - avoid animating blur radius directly
  - prefer opacity, transform, and material state changes
  - keep true `glassEffect(_:in:)` on shell controls such as navigation, top bars, search, segmented selectors, buttons, and high-value floating commands
  - represent repeated scrolling panels and noninteractive content with static frost gradients, luminous strokes, and sparse tint instead of live material
  - avoid live material on every repeated card in the home constellation
  - cap visible spatial cards and render only cards close to the viewport
  - use static gradients, scrims, and strokes for content cards when they need to pan at 60 fps
- Dynamic Type notes:
  - text inside glass must be tested with larger accessibility sizes
  - if glass cannot preserve legibility, switch the text container to a more opaque content surface

## Motion Rules

- Transition:
  - glass controls should materialize, slide, or morph in response to navigation and filtering
  - use short, fluid transitions that preserve spatial continuity
- Press feedback:
  - controls can subtly compress, brighten, or concentrate tint on press
  - avoid exaggerated bounce
- Loading:
  - use skeleton or progressive reveal for style cards
  - avoid loading spinners inside highly translucent text areas
- Gesture response:
  - floating panels should track drag gestures smoothly
  - avoid gesture-only critical actions
- Reduced motion fallback:
  - replace morphing/zooming with fade and subtle opacity changes
  - preserve state clarity without movement

## Accessibility

- Contrast:
  - test every text-on-glass pair over light, dark, and colorful preview content
  - increase material opacity or add a readable surface behind text when needed
- VoiceOver:
  - glass effects must not change semantic reading order
  - label icon-only glass controls
- Dynamic Type:
  - controls expand or wrap instead of clipping
  - long descriptions move to content surfaces
- Touch target:
  - all glass controls remain at least 44x44 pt
- Color-only meaning:
  - selected filters and states need label, shape, or icon support in addition to tint

## Prompt Guidance

### Use This Style When Prompt Says

- Trigger phrases:
  - Apple Liquid Glass
  - 苹果液态玻璃
  - iOS 26 style
  - Apple new design system
  - translucent floating controls
  - premium iOS glass shell
- Related product scenarios:
  - Mira app shell
  - Mira home spatial style constellation
  - design encyclopedia navigation
  - AI style search and filtering
  - style preview inspection
  - prompt helper and compare mode

### AI Output Should Include

- Visual direction:
  - prominent Liquid Glass app shell, readable content layer
- Token suggestions:
  - material, tint, border, shadow, radius, spacing, and motion tokens
- Component behavior:
  - glass navigation/search/filter/floating actions
  - content cards that preserve style preview clarity
- SwiftUI notes:
  - native material-backed surfaces and safe-area-aware bars
- Risks and acceptance checks:
  - contrast, blur stacking, content-layer misuse, and motion fallback

## Anti-patterns

- Do not:
  - apply Liquid Glass to every card and paragraph
  - make style preview content unreadable beneath glass
  - use glass as a decorative background blob
  - ignore contrast because the surface looks premium
  - replace platform navigation with custom gestures
  - override standard navigation, toolbar, sheet, or search backgrounds without a specific product reason
- Avoid:
  - nested translucent surfaces
  - tiny labels over colorful previews
  - large animated blur stacks
  - confusing Glassmorphism style examples with Mira's own app shell
- Common shallow interpretation:
  - "Add blur everywhere" is not Liquid Glass. The style is about functional hierarchy, adaptive material, optical depth, and Apple-native interaction.

## Acceptance Checklist

- [ ] Mira's app shell visibly uses Liquid Glass for navigation, search, filters, toolbars, floating actions, or inspector panels.
- [ ] Mira's default visual expression is light Soft Frost Liquid Glass, with dark surfaces reserved for scrims, screenshots, or future dark mode.
- [ ] The content layer remains readable and does not become a wall of transparent cards.
- [ ] Style examples can express their own design style without being overpowered by the app shell.
- [ ] Custom Liquid Glass is limited to important controls and grouped with `GlassEffectContainer` when several glass controls are adjacent.
- [ ] Repeated or high-frequency scrolling/panning cards avoid live blur and use lightweight static surfaces.
- [ ] Detail-page demos reserve true Liquid Glass for controls, not repeated static panels.
- [ ] Search, segmented controls, and buttons use true Liquid Glass on supported systems, with readable static fallbacks.
- [ ] Text-on-glass contrast is checked against light, dark, and colorful content.
- [ ] Touch targets are at least 44x44 pt.
- [ ] Dynamic Type does not clip labels inside glass controls.
- [ ] VoiceOver labels exist for icon-only glass controls.
- [ ] Motion has a reduced-motion fallback.
- [ ] SwiftUI implementation uses native iOS concepts where possible.
- [ ] The result feels Apple-native, not like generic web Glassmorphism.
