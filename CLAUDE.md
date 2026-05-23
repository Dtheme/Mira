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
- `docs/design-system/styles/neumorphism/Design.md`
- `docs/design-system/styles/neo-brutalism/Design.md`
- `docs/design-system/styles/neo-brutalism/component-spec.md`

## Rules

- Treat `docs/design-system/` as the source of truth for design style knowledge.
- Treat `project-standards/` as the source of truth for project implementation standards.
- Mira app UI uses `Apple Liquid Glass / 苹果液态玻璃` as its default app shell style; follow `docs/design-system/styles/apple-liquid-glass/Design.md` unless explicitly overridden.
- Use `docs/design-system/mira-app-design-system.md` for concrete Mira palette, home screen layout, and style-card rules.
- Every new design style must have a matching `docs/design-system/styles/<style-slug>/Design.md` before it is used for detailed UI implementation.
- Neo-Brutalism implementation uses `Mira/Features/Styles/NeoBrutalism/` and must not reuse the Apple Liquid Glass detail template.
- Neumorphism / Soft UI uses `docs/design-system/styles/neumorphism/Design.md` and `Mira/Features/Styles/Neumorphism/`; translate web shadow recipes into iOS raised/inset surface states instead of copying CSS literally.
- Keep style guidance iOS / SwiftUI first.
- For new Mira app code, every newly created Swift type and matching Swift file must use the `Mi` prefix, for example `MiStyleListView.swift` or `MiDesignStyle.swift`.
- Do not duplicate long style content in tool-specific adapter files.
- Do not modify SwiftUI app code when the user asks only for planning, docs, rules, or skill work.
- When implementing UI later, preserve Dynamic Type, VoiceOver, safe areas, touch targets, readable contrast, and reduced-motion support.

## Current Boundary

Mira now has app UI implementation work in progress. Do not modify SwiftUI app code when the user asks only for planning, docs, rules, or skill work; when implementation is requested, follow the style-specific docs and report verification.
