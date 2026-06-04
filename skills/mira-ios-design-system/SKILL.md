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

## Core Workflow

When the user asks for a style direction, UI plan, or SwiftUI implementation:

1. Identify the target screen, user scenario, selected style, and platform constraints.
2. Check the style category in `style-taxonomy.md`.
3. Locate `docs/design-system/styles/<style-slug>/Design.md` for the selected style.
4. If the style-specific `Design.md` exists, follow it. If it does not exist, create or request that file before treating the style as implementation-ready.
5. Use `design-md-template.md` as the required structure for any new style document.
6. Produce iOS / SwiftUI-first guidance: tokens, layout, components, motion, accessibility, anti-patterns, and acceptance checks.
7. For code changes, follow `project-standards/vibe-coding.md` before editing.

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
- For Bento Grid implementation, follow `docs/design-system/styles/bento-grid/Design.md`; build a modular mosaic with spanning cells (`Grid` + `gridCellColumns`), one hero tile, consistent radius and gutters, neutral elevated surfaces, and hierarchy from cell size — not decoration. Runtime code lives under `Mira/Features/Styles/BentoGrid/`.
- For Refined Dark implementation, follow `docs/design-system/styles/refined-dark/Design.md`; a precise dark product UI (Linear-style) with a deep base, 1 pt hairline borders, subtle gradients, one restrained indigo accent with a soft glow, crisp type, and fast micro-motion. Separation comes from contrast and borders, not heavy shadows. Runtime code lives under `Mira/Features/Styles/RefinedDark/`.
- For Editorial Luxe implementation, follow `docs/design-system/styles/editorial-luxe/Design.md`; elegant magazine-style luxury with serif headlines (`design: .serif`), ivory paper, generous whitespace, thin gold/ink hairline rules, large imagery, and one restrained gold accent. Elegance comes from type and space, not effects; keep gold an accent and body text high-contrast. Runtime code lives under `Mira/Features/Styles/EditorialLuxe/`.
- Do not duplicate full design style content inside this skill.
- Do not treat web CSS effects as direct iOS implementation instructions.
- Do not reduce a style to one visual trick, such as "blur equals glass" or "thick border equals brutalism".
- Preserve iOS usability: safe areas, Dynamic Type, VoiceOver, 44x44 pt touch targets, reduced motion, and readable contrast.
- Prefer native SwiftUI concepts before adding dependencies.
- For new Mira app code, every newly created Swift type and matching Swift file must use the `Mi` prefix, such as `MiHomeView.swift`, `MiDesignStyle.swift`, or `MiStyleRepository.swift`.

## Output Shape

For design-only work, include:

- Style Direction
- Token Suggestions
- Layout Guidance
- Component Guidance
- SwiftUI Notes
- Accessibility Checks
- Anti-pattern Check
- Acceptance Checklist

For implementation work, also include:

- files changed
- states handled
- verification commands
- known gaps
