# Mira Agent Instructions

Mira is being built as an iOS-first design system encyclopedia for AI-assisted interface design.

## Primary Knowledge Sources

- Design-system knowledge: `docs/design-system/`
- Project implementation standards: `project-standards/`
- Codex skill adapter: `skills/mira-ios-design-system/SKILL.md`
- Cursor rule adapter: `.cursor/rules/mira-design-system.mdc`
- Claude adapter: `CLAUDE.md`

## Agent Rules

- Use `docs/design-system/overview.md` and `docs/design-system/ai-usage-contract.md` before producing design guidance.
- For Mira app UI implementation, use `docs/design-system/styles/apple-liquid-glass/Design.md` as the default app shell style unless the user explicitly overrides it.
- Use `docs/design-system/mira-app-design-system.md` for Mira's concrete palette, homepage layout, and style-card behavior.
- Use `docs/design-system/design-md-template.md` for every future style-specific `Design.md`.
- Every new design style must add `docs/design-system/styles/<style-slug>/Design.md`; taxonomy-only style entries are not enough for implementation guidance.
- Use `project-standards/vibe-coding.md` before making app code changes.
- Keep output iOS / SwiftUI first.
- For new Mira app code, name every new Swift type and matching Swift file with the `Mi` prefix, for example `MiHomeView.swift` and `MiDesignStyle.swift`.
- Do not duplicate detailed style knowledge in adapters.
- Do not change `Mira/` or `Mira.xcodeproj/` for docs-only tasks.
- Report verification commands and known gaps after implementation work.
