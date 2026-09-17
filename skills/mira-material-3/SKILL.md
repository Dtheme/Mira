---
name: mira-material-3
description: Design, implement, or review Material 3 classic iOS interfaces in Mira, including its home card, semantic palettes, standard controls, and interactive demo. Use for Material 3 or Material You requests; do not silently substitute Material 3 Expressive.
---

# Mira Material 3

Use `docs/design-system/styles/material-3/Design.md` as the source of truth. This adapter routes work to the design contract and runtime; it does not redefine tokens.

## Read and apply

1. Read `docs/design-system/overview.md` and `docs/design-system/ai-usage-contract.md` for the knowledge boundary.
2. Read this style's `Design.md`. Its classic baseline, semantic color pairing, component proportions, and iOS adaptations take priority over generic design habits.
3. Before code, read `project-standards/vibe-coding.md` and `project-standards/design-demo-standard.md`.
4. Identify the real task and required states before arranging components. For the existing demo, retain search, filtering, saved items, creation validation, cancellation, reset confirmation with undo and local retry behavior.
5. Check both appearance modes and palette presets, disabled/error states, Dynamic Type, native semantics, and Reduce Motion. Report source checks, builds and runtime verification separately.

## Implementation routing

- Runtime remains under `Mira/Features/Styles/Material3/`; every new Swift type and matching file uses the `Mi` prefix.
- Adaptive palette roles and state timing: `MiMaterial3Tokens.swift`; shapes and dimensions are defined in their components and documented in `Design.md`.
- Reusable button, chip, switch, segment and field behavior: `MiMaterial3Components.swift` and the runtime interface list in `Design.md`.
- Homepage specimen: `MiMaterial3HomePreview.swift`; preserve the home canvas press environment, title transition and static-at-rest contract.
- Demo host: `MiMaterial3DetailView.swift`; it owns session-local collections, palette, navigation, modal state and one-step undo. Changes are not persisted after leaving the demo.
- Library: `MiMaterial3Library.swift`; search, category chips, All/Saved segment and bookmarks operate on the host collection.
- Component exercises: `MiMaterial3ComponentLab.swift`; reset restores the complete sample library, not one deleted item; its asynchronous exercise is a local failure/retry simulation.
- Create/reset modal: `MiMaterial3CollectionDialog.swift`; keep title validation, cancel behavior and accessibility escape.
- Reference and native prompt sheet: `MiMaterial3ReferenceView.swift`.
- Module integration: `MiMaterial3Module.swift`; other styles and Mira's Apple Liquid Glass shell are outside this adapter's scope.

## Boundaries

- Implement Material 3 classic unless the user explicitly requests another version. Do not mix Expressive geometry or Playful Outline's zero-border rule into baseline components.
- Use palette roles for all component backgrounds and foregrounds. The sage palette is a locally curated preset, not an official fixed green scheme. Preset switching is not wallpaper extraction or arbitrary runtime palette generation.
- Keep depth tonal by default; use only the local elevation justified by the component. Avoid purple glow, decorative background gradients and repeated card nesting.
- Standard outlined components retain their functional borders; filled components do not acquire an extra frame.
- Preserve native SwiftUI control semantics and at least 44 pt touch targets even where the visual component is smaller.
- Home replicas remain static at rest. No unrelated architecture, dependencies, deployment or publishing is authorized by this skill.
