---
name: mira-ios-design-system
description: Use when designing or reviewing Mira iOS app interfaces with a specific visual style, creating style Design.md files, translating design styles into SwiftUI guidance, or checking whether AI-generated UI follows Mira's design-system encyclopedia rules.
---

# Mira iOS Design System

Use this skill for Mira's iOS-first design-system encyclopedia. The skill is an adapter; the source of truth lives in `docs/design-system/` and `project-standards/`.

## Read First

For design guidance:

1. `docs/design-system/overview.md`
2. `docs/design-system/ai-usage-contract.md`
3. `docs/design-system/style-taxonomy.md`
4. `docs/design-system/design-md-template.md`

For implementation or vibe coding:

1. `project-standards/README.md`
2. `project-standards/vibe-coding.md`
3. `project-standards/ios-swiftui-baseline.md`
4. `project-standards/repository-structure.md`
5. `docs/design-system/styles/apple-liquid-glass/Design.md`
6. `docs/design-system/mira-app-design-system.md`

For implemented style modules:

- Apple Liquid Glass: `docs/design-system/styles/apple-liquid-glass/Design.md`
- Glassmorphism: `docs/design-system/styles/glassmorphism/Design.md`
- Neumorphism / Soft UI: `docs/design-system/styles/neumorphism/Design.md`
- Claymorphism: `docs/design-system/styles/claymorphism/Design.md`
- Soft Skeuomorphism: `docs/design-system/styles/soft-skeuomorphism/Design.md`
- Neo-Brutalism: `docs/design-system/styles/neo-brutalism/Design.md`
- Neo-Brutalism component spec: `docs/design-system/styles/neo-brutalism/component-spec.md`
- Minimalism: `docs/design-system/styles/minimalism/Design.md`
- Material 3: `docs/design-system/styles/material-3/Design.md`
- Bento Grid: `docs/design-system/styles/bento-grid/Design.md`
- Refined Dark: `docs/design-system/styles/refined-dark/Design.md`
- Editorial Luxe: `docs/design-system/styles/editorial-luxe/Design.md`
- Hand-drawn Vlog: `docs/design-system/styles/handdrawn-vlog/Design.md`

## Core Workflow

When the user asks for a style direction, UI plan, or SwiftUI implementation:

1. Identify the target screen, user scenario, selected style, and platform constraints, and state a one-line Design Read (see Anti-AI-Slop Discipline).
2. Check the style category in `style-taxonomy.md`.
3. Locate `docs/design-system/styles/<style-slug>/Design.md` for the selected style.
4. If the style-specific `Design.md` exists, follow it. If it does not exist, create or request that file before treating the style as implementation-ready.
5. Use `design-md-template.md` as the required structure for any new style document.
6. Produce iOS / SwiftUI-first guidance: tokens, layout, components, motion, accessibility, anti-patterns, and acceptance checks.
7. For code changes, follow `project-standards/vibe-coding.md` before editing.
8. Before delivering, run the Anti-AI-Slop pre-flight in the Anti-AI-Slop Discipline section.

## Rules

- Mira app UI uses `Apple Liquid Glass / 苹果液态玻璃` as its default app shell style. Follow `docs/design-system/styles/apple-liquid-glass/Design.md` unless the user explicitly overrides the shell style.
- Mira's concrete app palette, home screen, and style-card behavior live in `docs/design-system/mira-app-design-system.md`.
- Every design style added to Mira must have its own `docs/design-system/styles/<style-slug>/Design.md`.
- Do not use taxonomy-only style entries as enough context for detailed implementation.
- For Neo-Brutalism implementation, follow `docs/design-system/styles/neo-brutalism/Design.md` and `docs/design-system/styles/neo-brutalism/component-spec.md`; do not reuse the Apple Liquid Glass detail template.
- For Neumorphism implementation, follow `docs/design-system/styles/neumorphism/Design.md`; translate paired light/dark CSS shadows into accessible raised and inset SwiftUI surface states, and keep runtime code under `Mira/Features/Styles/Neumorphism/`.
- For Claymorphism implementation, follow `docs/design-system/styles/claymorphism/Design.md`; use matte pastel puffy surfaces, large radii, dual outer shadows, masked inner shadows, inset inputs, and springy press feedback. Runtime code lives under `Mira/Features/Styles/Claymorphism/`.
- For Soft Skeuomorphism implementation, follow `docs/design-system/styles/soft-skeuomorphism/Design.md`; use warm cream surfaces, organic product objects, moss/peach accents, soft gauges, tactile pills, and low-contrast but readable depth. Runtime code lives under `Mira/Features/Styles/SoftSkeuomorphism/`.
- For Glassmorphism implementation, follow `docs/design-system/styles/glassmorphism/Design.md`; keep it distinct from Apple Liquid Glass by defining background, shell glass, content glass, overlay glass, and readable opacity boundaries. Runtime code lives under `Mira/Features/Styles/Glassmorphism/`.
- For Minimalism implementation, follow `docs/design-system/styles/minimalism/Design.md`; use grid, type scale, whitespace, hairlines, and explicit states instead of decorative effects. Runtime code lives under `Mira/Features/Styles/Minimalism/`.
- For Material 3 implementation, follow `docs/design-system/styles/material-3/Design.md`; define semantic color roles, tonal containers, shape scale, state layers, and iOS adaptation boundaries. Runtime code lives under `Mira/Features/Styles/Material3/`.
- For Bento Grid implementation, follow `docs/design-system/styles/bento-grid/Design.md`; build a modular mosaic with spanning cells (`Grid` + `gridCellColumns`), one hero tile, consistent radius and gutters, neutral elevated surfaces, and hierarchy from cell size, not decoration. Runtime code lives under `Mira/Features/Styles/BentoGrid/`.
- For Refined Dark implementation, follow `docs/design-system/styles/refined-dark/Design.md`; a precise dark product UI (Linear-style) with a deep base, 1 pt hairline borders, subtle gradients, one restrained indigo accent with a soft glow, crisp type, and fast micro-motion. Separation comes from contrast and borders, not heavy shadows. Runtime code lives under `Mira/Features/Styles/RefinedDark/`.
- For Editorial Luxe implementation, follow `docs/design-system/styles/editorial-luxe/Design.md`; elegant magazine-style luxury with serif headlines (`design: .serif`), ivory paper, generous whitespace, thin gold/ink hairline rules, large imagery, and one restrained gold accent. Elegance comes from type and space, not effects; keep gold an accent and body text high-contrast. Runtime code lives under `Mira/Features/Styles/EditorialLuxe/`.
- For Hand-drawn Vlog implementation, follow `docs/design-system/styles/handdrawn-vlog/Design.md`; Korean film-diary cute with warm cream paper, faded film tones (not candy pastels), polaroid framing, handwriting, washi tape, and `Path`/`Canvas` hand-drawn doodles with one dried-rose accent and warm-tinted shadows. Charm comes from paper, film tone, framing, handwriting, and restraint (max 1-2 decorations per card), not saturation. Runtime code lives under `Mira/Features/Styles/HanddrawnVlog/`; do not reuse another style's detail template.
- Do not duplicate full design style content inside this skill.
- Do not treat web CSS effects as direct iOS implementation instructions.
- Do not reduce a style to one visual trick, such as "blur equals glass" or "thick border equals brutalism".
- Preserve iOS usability: safe areas, Dynamic Type, VoiceOver, 44x44 pt touch targets, reduced motion, and readable contrast.
- Prefer native SwiftUI concepts before adding dependencies.
- For new Mira app code, every newly created Swift type and matching Swift file must use the `Mi` prefix, such as `MiHomeView.swift`, `MiDesignStyle.swift`, or `MiStyleRepository.swift`.

## Anti-AI-Slop Discipline

Generic AI interfaces share a set of tells. Before generating any design or SwiftUI, avoid the default reaches below so the result reads as the chosen style, not as a template. These rules govern the UI and the sample copy you produce, not this internal document. The selected style's `Design.md` always wins over a generic instinct.

### Read before you generate

- State a one-line Design Read first: target screen, audience, and the selected style's identity (from its `Design.md`). Do not start from a default look.
- If a generic instinct conflicts with the style's `Design.md`, follow the `Design.md`.

### Default reaches to avoid (iOS tells)

- AI purple/blue gradient glows, and neon or outer glows. Use one restrained accent plus a soft tinted shadow.
- `.ultraThinMaterial` or blur on everything. Treat glass as a top-layer tool, not a default surface.
- Three identical SF Symbol feature cards in a row. Vary the layout and use the style's real hierarchy.
- The same centered hero on every screen (big bold title, one-line subtitle, two capsule buttons).
- `.rounded` font plus a tinted gradient plus an SF Symbol as the answer to every component, regardless of style.
- Gradient or rainbow headline text, pure black (`#000000`), or pure white (`#FFFFFF`). Use off-black and off-white tuned to the style.

### Lock color, shape, and theme

- One accent color, used across the whole screen, with restrained saturation.
- Tint shadows to the surface hue; never a pure-black drop shadow on a light surface.
- One radius system per screen. A dual system (for example a soft card with a near-square photo) is allowed only as a documented, consistent rule.
- One theme per screen; sections do not flip light or dark mid-scroll.
- For premium or craft briefs, do not default to beige plus brass plus espresso. Use warm paper only when the style intrinsically calls for it (Editorial Luxe ivory, Hand-drawn Vlog cream) and say why; otherwise rotate to a different palette family.

### Typography

- Serif is not the default "creative" or "premium" reach. Use serif only for genuinely editorial or luxury styles, and avoid the Fraunces / Instrument Serif cliche.
- Emphasize a word inside a headline with italic or bold of the same family, not a stray serif word in a sans headline.
- Build hierarchy from weight, size, color, and space, not from oversized headlines.

### Real imagery over fakery

- Do not fake a product UI out of stacked rectangles, and do not hand-roll decorative SVG or `Canvas` as filler.
- Prefer real photo or illustration assets, or SF Symbols. Use hand-drawn `Path` or `Canvas` doodles only when the style explicitly calls for them (for example Hand-drawn Vlog).
- Where the style expects imagery, include at least one real visual rather than a text-only placeholder.

### Sample copy in designs

- Zero em-dash (`—` and `–`) in any user-visible copy. Use a hyphen, comma, colon, or period.
- No generic names (John Doe), no startup-slop brand names (Acme, Nexus, SmartFlow), and no fake-precise numbers (`99.99%`, `4.1x`) unless they are real or labeled as mock.
- No filler verbs (Elevate, Seamless, Unleash, Next-Gen, Revolutionize). Re-read every visible string and cut cute-but-broken AI phrasing.

### Restrain decoration and vary layout

- Do not place a small uppercase eyebrow or kicker above every section. Mira's detail-page convention uses a per-section kicker; keep that for existing pages, but for new screens prefer fewer (about one per three sections) or none.
- No section-number eyebrows (`00 / INDEX`), decorative status dots on every row, version or beta labels, locale/weather/time strips, or "scroll" cues.
- Vary layout families across a screen instead of stacking identical rows. Every decoration earns its place or is cut.

### Motion

- Every animation must communicate feedback, hierarchy, state, or sequence, not exist for show. Always provide a reduced-motion fallback.

### Anti-slop pre-flight (run before declaring done)

- [ ] Design Read stated; output reads as the chosen style, not generic.
- [ ] One accent, one radius system, one theme; off-black and off-white; shadows tinted.
- [ ] Zero em-dash; copy is human and specific.
- [ ] Imagery is real where the style expects it; doodles only where the style calls for them.
- [ ] Decoration restrained; layout families varied.
- [ ] Motion is motivated and has a reduced-motion fallback.

## Output Shape

For design-only work, include:

- Style Direction
- Token Suggestions
- Layout Guidance
- Component Guidance
- SwiftUI Notes
- Accessibility Checks
- Anti-pattern Check
- Anti-AI-Slop Pre-flight
- Acceptance Checklist

For implementation work, also include:

- files changed
- states handled
- verification commands
- known gaps
