# Mira Claude Instructions

Mira is an iOS-first design system encyclopedia app. The current first-stage work focuses on AI-readable design knowledge, not app UI implementation.

## Read Order

For design-system work:

1. `docs/design-system/overview.md`
2. `docs/design-system/ai-usage-contract.md`
3. `docs/design-system/style-taxonomy.md`
4. `docs/design-system/design-md-template.md`

For future vibe coding or SwiftUI implementation:

1. `project-standards/README.md`
2. `project-standards/vibe-coding.md`
3. `project-standards/ios-swiftui-baseline.md`
4. `project-standards/repository-structure.md`
5. `docs/design-system/styles/apple-liquid-glass/Design.md`
6. `docs/design-system/mira-app-design-system.md`

For implemented style modules:

- `docs/design-system/styles/apple-liquid-glass/Design.md`
- `docs/design-system/styles/glassmorphism/Design.md`
- `docs/design-system/styles/neumorphism/Design.md`
- `docs/design-system/styles/claymorphism/Design.md`
- `docs/design-system/styles/soft-skeuomorphism/Design.md`
- `docs/design-system/styles/neo-brutalism/Design.md`
- `docs/design-system/styles/neo-brutalism/component-spec.md`
- `docs/design-system/styles/minimalism/Design.md`
- `docs/design-system/styles/material-3/Design.md`
- `docs/design-system/styles/bento-grid/Design.md`
- `docs/design-system/styles/refined-dark/Design.md`
- `docs/design-system/styles/editorial-luxe/Design.md`
- `docs/design-system/styles/handdrawn-vlog/Design.md`

## Rules

- Treat `docs/design-system/` as the source of truth for design style knowledge.
- Treat `project-standards/` as the source of truth for project implementation standards.
- Mira app UI uses `Apple Liquid Glass / 苹果液态玻璃` as its default app shell style; follow `docs/design-system/styles/apple-liquid-glass/Design.md` unless explicitly overridden.
- Use `docs/design-system/mira-app-design-system.md` for concrete Mira palette, home screen layout, and style-card rules.
- Every new design style must have a matching `docs/design-system/styles/<style-slug>/Design.md` before it is used for detailed UI implementation.
- Neo-Brutalism implementation uses `Mira/Features/Styles/NeoBrutalism/` and must not reuse the Apple Liquid Glass detail template.
- Neumorphism / Soft UI uses `docs/design-system/styles/neumorphism/Design.md` and `Mira/Features/Styles/Neumorphism/`; translate web shadow recipes into iOS raised/inset surface states instead of copying CSS literally.
- Claymorphism uses `docs/design-system/styles/claymorphism/Design.md` and `Mira/Features/Styles/Claymorphism/`; use matte pastel puffy surfaces, huge radii, dual outer shadows, masked inner shadows, inset inputs, and springy press feedback.
- Soft Skeuomorphism uses `docs/design-system/styles/soft-skeuomorphism/Design.md` and `Mira/Features/Styles/SoftSkeuomorphism/`; use warm cream surfaces, organic product-object controls, moss/peach accents, soft gauges, and readable tactile depth.
- Glassmorphism uses `docs/design-system/styles/glassmorphism/Design.md` and `Mira/Features/Styles/Glassmorphism/`; keep it distinct from Apple Liquid Glass by defining layer roles and readable opacity limits.
- Minimalism uses `docs/design-system/styles/minimalism/Design.md` and `Mira/Features/Styles/Minimalism/`; use grid, typography, whitespace, and hairline rules instead of decoration.
- Material 3 uses `docs/design-system/styles/material-3/Design.md` and `Mira/Features/Styles/Material3/`; adapt semantic color roles, tonal containers, shape scale, and state layers to iOS.
- Bento Grid uses `docs/design-system/styles/bento-grid/Design.md` and `Mira/Features/Styles/BentoGrid/`; build a modular mosaic with spanning cells (`Grid` + `gridCellColumns`), one hero tile, consistent radius/gutters, and hierarchy from cell size, not decoration.
- Refined Dark uses `docs/design-system/styles/refined-dark/Design.md` and `Mira/Features/Styles/RefinedDark/`; a precise dark product UI (Linear-style) — deep base, 1pt hairline borders, subtle gradients, one restrained indigo accent with soft glow, crisp type, and fast micro-motion; separation from contrast/borders, not heavy shadows.
- Editorial Luxe uses `docs/design-system/styles/editorial-luxe/Design.md` and `Mira/Features/Styles/EditorialLuxe/`; elegant magazine luxury — serif (`design: .serif`) headlines, ivory paper, generous whitespace, thin gold/ink hairline rules, large imagery, and one restrained gold accent; elegance from type and space, not effects.
- Hand-drawn Vlog uses `docs/design-system/styles/handdrawn-vlog/Design.md` and `Mira/Features/Styles/HanddrawnVlog/`; Korean film-diary cute — warm cream paper, faded film tones (not candy pastels), polaroid framing, handwriting, washi tape, and `Path`/`Canvas` hand-drawn doodles with one dried-rose accent. Home preview card + bespoke detail page implemented (a diary/scrapbook feed with a tap-to-flip polaroid memory-board signature); it must not reuse another style's detail template.
- Keep style guidance iOS / SwiftUI first.
- Avoid AI-stereotyped, templated design. Follow the `Anti-AI-Slop Discipline` in `skills/mira-ios-design-system/SKILL.md`: state a one-line Design Read first; one accent, one radius system, one theme; tint shadows to the surface and avoid pure black/white; zero em-dash in UI copy; real imagery over fake (hand-drawn doodles only where the style calls for them); restrained decoration and varied layout; motivated motion with a reduced-motion fallback. The chosen style's `Design.md` always wins over a generic instinct.
- For new Mira app code, every newly created Swift type and matching Swift file must use the `Mi` prefix, for example `MiStyleListView.swift` or `MiDesignStyle.swift`.
- Do not duplicate long style content in tool-specific adapter files.
- Do not modify SwiftUI app code when the user asks only for planning, docs, rules, or skill work.
- When implementing UI later, preserve Dynamic Type, VoiceOver, safe areas, touch targets, readable contrast, and reduced-motion support.

## Current Boundary

Mira now has app UI implementation work in progress. Do not modify SwiftUI app code when the user asks only for planning, docs, rules, or skill work; when implementation is requested, follow the style-specific docs and report verification.
