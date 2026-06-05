# Mira Design System Encyclopedia / Mira 设计系统百科

## Purpose

Mira is planned as an iOS-first design system encyclopedia for AI-assisted product design and implementation. Its knowledge base should help AI agents understand visual styles, translate them into SwiftUI-friendly interface decisions, and avoid shallow keyword-only styling.

Mira 的第一阶段目标不是立即实现 App UI，而是建立一个稳定、可扩展、可被 AI 引用的设计知识底座。

## Knowledge Architecture

Mira uses a "Skill Core + Adapter Layer" architecture:

- **Core Knowledge**: `docs/design-system/` is the single source of truth for design style definitions, templates, taxonomy, and AI usage contracts.
- **Codex Adapter**: `skills/mira-ios-design-system/SKILL.md` tells Codex-style agents how to use the core knowledge.
- **Cursor Adapter**: `.cursor/rules/mira-design-system.mdc` exposes the same rules to Cursor.
- **Claude Adapter**: `CLAUDE.md` provides the Claude-facing project entrypoint.
- **Project Standards**: `project-standards/` defines Mira-specific vibe coding standards that apply when changing the app later.

Adapters must point back to the core docs instead of duplicating long design guidance.

## Style Document Rule

Every design style added to Mira must have its own `Design.md`:

```text
docs/design-system/styles/<style-slug>/Design.md
```

The style index may register a style only when the corresponding `Design.md` path is created or explicitly marked as the immediate next authoring task. AI agents should not treat a style as usable for implementation when it only appears as a taxonomy keyword.

## iOS / SwiftUI First

All design guidance should prioritize iOS app quality:

- Prefer Apple platform navigation patterns, safe areas, Dynamic Type, VoiceOver, and native gestures.
- Translate web-native effects into SwiftUI-native equivalents instead of copying CSS effects literally.
- Treat visual styles as constraints for composition, tokens, motion, and component behavior, not as decorative overlays.
- Preserve touch target size, contrast, readability, and performance even when the style is expressive.

## Mira App Shell Style

Mira's own app interface uses **Apple Liquid Glass / 苹果液态玻璃** as its default and prominent visual style.

Source document:

```text
docs/design-system/styles/apple-liquid-glass/Design.md
```

Concrete app design system:

```text
docs/design-system/mira-app-design-system.md
```

This style applies to the app shell: navigation, search, filters, toolbars, floating actions, inspectors, and preview overlays. The content layer should remain readable and structured so each style encyclopedia entry can express its own design language without being overwhelmed by the shell.

## AI Usage Boundary

When an AI agent uses Mira, it should produce practical interface guidance:

- visual direction
- style-specific tokens
- layout and hierarchy rules
- SwiftUI implementation notes
- accessibility checks
- anti-patterns
- acceptance checklist

The AI should not only repeat style labels such as "acid", "glass", or "brutalist". Every style recommendation must connect back to concrete UI decisions.

## First Style Backlog

The first batch is a backlog for authoring. Each style must receive a dedicated `Design.md` before it is considered usable by the skill for detailed UI generation.

| Style | 中文名 | Category | Required Design.md |
| --- | --- | --- | --- |
| Apple Liquid Glass | 苹果液态玻璃 | Material / Surface | `docs/design-system/styles/apple-liquid-glass/Design.md` |
| Glassmorphism | 玻璃拟物化设计 | Material / Surface | `docs/design-system/styles/glassmorphism/Design.md` |
| Neumorphism | 新拟态 / Soft UI | Material / Surface | `docs/design-system/styles/neumorphism/Design.md` |
| Claymorphism | 黏土形态 | Material / Surface | `docs/design-system/styles/claymorphism/Design.md` |
| Soft Skeuomorphism | 柔和有机拟物 | Material / Surface | `docs/design-system/styles/soft-skeuomorphism/Design.md` |
| Neo-Brutalism | 新粗野主义 | Anti-design / Structural | `docs/design-system/styles/neo-brutalism/Design.md` |
| Minimalism | 极简主义 | Minimal / Systematic | `docs/design-system/styles/minimalism/Design.md` |
| Material 3 | Material You | System Framework | `docs/design-system/styles/material-3/Design.md` |
| Bento Grid | 便当网格 | Minimal / Systematic | `docs/design-system/styles/bento-grid/Design.md` |
| Refined Dark | 精致暗色 | Minimal / Systematic | `docs/design-system/styles/refined-dark/Design.md` |
| Editorial Luxe | 轻奢编辑 | Minimal / Systematic | `docs/design-system/styles/editorial-luxe/Design.md` |
| Hand-drawn Vlog | Vlog 手绘风 | Cultural / Editorial | `docs/design-system/styles/handdrawn-vlog/Design.md` |
