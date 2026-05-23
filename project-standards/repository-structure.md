# Repository Structure Standard / 仓库结构标准

## Current Structure

```text
Mira/
Mira.xcodeproj/
docs/design-system/
project-standards/
skills/mira-ios-design-system/
.cursor/rules/
CLAUDE.md
AGENTS.md
```

## Folder Responsibilities

### `Mira/`

SwiftUI app source, assets, and app-local data model files.

Future expected subfolders:

```text
Mira/App/
Mira/DesignSystem/
Mira/Features/
Mira/Features/Home/
Mira/Features/Styles/
Mira/Models/
Mira/Resources/
Mira/Shared/
```

Do not create these until implementation starts and a screen or subsystem needs them.

Style-specific runtime code should live under:

```text
Mira/Features/Styles/<StyleModuleName>/
```

Examples:

```text
Mira/Features/Styles/AppleLiquidGlass/
Mira/Features/Styles/AcidGraphic/
Mira/Features/Styles/Glassmorphism/
Mira/Features/Styles/NeoBrutalism/
```

Each style module can own its own detail page, preview components, tokens, demo states, and local helpers. Do not force every style into one shared detail page once a style becomes implementation-ready.

### `docs/design-system/`

Source of truth for design style knowledge, taxonomy, AI usage contracts, and `Design.md` templates.

### `project-standards/`

Project-level standards for future implementation and AI collaboration.

### `skills/mira-ios-design-system/`

Codex-compatible skill adapter. It should reference core docs instead of duplicating full style content.

### `.cursor/rules/`

Cursor rule adapter. It should be short and link back to docs and project standards.

### `CLAUDE.md` and `AGENTS.md`

AI entrypoints for Claude and Codex-style agents. They should describe what to read first and what not to modify.

## Naming Rules

- Style folder names should use lowercase kebab-case, for example `glassmorphism`.
- Style documents should be named `Design.md`.
- Style runtime module folders should use PascalCase under `Mira/Features/Styles/`, for example `AppleLiquidGlass`.
- Shared project standards should use lowercase kebab-case.
- New Swift types created for Mira app code must use the `Mi` prefix.
- New Swift file names must match their primary type name and therefore also use the `Mi` prefix.
- SwiftUI view files should use PascalCase, start with `Mi`, and end in `View.swift`, for example `MiHomeView.swift`.
- Token, model, service, modifier, and helper files should use names that describe their level and still start with `Mi`, such as `MiColorTokens.swift`, `MiDesignStyle.swift`, `MiGlassSurfaceModifier.swift`, or `MiStyleRepository.swift`.
- Existing template files such as `MiraApp.swift`, `ContentView.swift`, and `Persistence.swift` do not need to be renamed unless a future implementation task explicitly replaces the template app.

## Boundary Rules

- Design docs must not depend on app runtime code.
- App runtime code may consume future design data, but should not parse unstructured Markdown at runtime unless explicitly planned.
- Every style should have both a documentation folder under `docs/design-system/styles/<style-slug>/` and a runtime module folder under `Mira/Features/Styles/<StyleModuleName>/` once app code exists for that style.
- Registered but unimplemented styles may keep only a small `Mi<StyleName>Module.swift` marker and should show a lightweight unavailable state instead of opening a placeholder detail page.
- Adapter files must not become the source of truth for design style content.
- Project standards should describe process and quality expectations, not duplicate style taxonomy.
