# Vibe Coding Standard / AI 协作编码标准

## Purpose

This standard keeps future AI-assisted implementation aligned with Mira's design-system goal. Vibe coding is allowed, but output must remain structured, reviewable, and testable.

## Required Workflow

Before editing app code, an AI agent should:

1. Read `project-standards/README.md`.
2. Read `project-standards/ios-swiftui-baseline.md`.
3. Read `docs/design-system/styles/apple-liquid-glass/Design.md` as Mira's default app shell style.
4. Read `docs/design-system/mira-app-design-system.md` for Mira's concrete palette, homepage, and component direction.
5. Read `project-standards/design-demo-standard.md` when adding or changing a design style demo.
6. Read any additional relevant design-system docs under `docs/design-system/`.
7. State which screen, component, or data surface will change.
8. Keep the change scoped to that surface.

## Request Shape

Good implementation prompts should include:

```text
Target screen:
Primary user action:
Selected design style:
Required content:
States to support:
Device focus:
Out of scope:
Acceptance checks:
```

If a prompt omits design style for Mira app implementation, use `Apple Liquid Glass / 苹果液态玻璃` from `docs/design-system/styles/apple-liquid-glass/Design.md` as the default app shell style.

## AI Output Requirements

Implementation-oriented AI output should include:

- changed files
- UI states handled
- style rules applied
- Apple Liquid Glass shell rules applied, when changing Mira app UI
- Mira app design system rules applied, especially home constellation and style-card behavior when relevant
- design demo slots and states handled, when changing a style demo
- accessibility checks
- verification commands run
- known gaps, if any

## Change Discipline

- Do not rewrite unrelated files.
- Do not change Xcode project settings unless required.
- Do not introduce third-party libraries for visual styling without a clear reason.
- Do not hard-code large style decisions into individual views if they should become tokens.
- Do not mix multiple strong styles in one screen without stating the hierarchy.
- Name all newly created Swift types and matching Swift files with the `Mi` prefix, for example `MiDesignStyle`, `MiStyleListView`, and `MiStyleRepository`.
- Do not introduce new unprefixed app types such as `HomeView`, `StyleModel`, or `DesignService`.

## Design-to-Code Rule

Design style guidance should flow in this order:

```text
Design.md -> tokens -> reusable view helpers/components -> screen composition -> preview states
```

Do not start with arbitrary modifiers on a screen and call the result a design system.

## Acceptance Checks

- [ ] The change has a clear target screen or component.
- [ ] The selected style is named and applied through concrete UI decisions.
- [ ] Mira app shell changes follow `docs/design-system/styles/apple-liquid-glass/Design.md` unless the task explicitly overrides the shell style.
- [ ] Style demo changes follow `project-standards/design-demo-standard.md`.
- [ ] The implementation remains SwiftUI-native.
- [ ] Every newly created Swift type and file uses the `Mi` prefix.
- [ ] Accessibility baseline is preserved.
- [ ] Preview or verification path is documented.
- [ ] Unrelated template code is removed only when the task explicitly includes app implementation.
