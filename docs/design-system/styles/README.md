# Style Documents / 设计风格文档

Every design style in Mira must have a dedicated `Design.md` under this folder.

Required path pattern:

```text
docs/design-system/styles/<style-slug>/Design.md
```

Examples:

```text
docs/design-system/styles/apple-liquid-glass/Design.md
docs/design-system/styles/claymorphism/Design.md
docs/design-system/styles/glassmorphism/Design.md
docs/design-system/styles/minimalism/Design.md
docs/design-system/styles/material-3/Design.md
docs/design-system/styles/neo-brutalism/Design.md
docs/design-system/styles/soft-skeuomorphism/Design.md
docs/design-system/styles/bento-grid/Design.md
docs/design-system/styles/refined-dark/Design.md
docs/design-system/styles/editorial-luxe/Design.md
docs/design-system/styles/handdrawn-vlog/Design.md
```

Mira's own app shell style is `docs/design-system/styles/apple-liquid-glass/Design.md`.

Use `docs/design-system/design-md-template.md` as the starting point for every style.

Do not treat a style as implementation-ready until its `Design.md` includes style identity, visual tokens, layout rules, component guidance, iOS / SwiftUI notes, accessibility, anti-patterns, and an acceptance checklist.
