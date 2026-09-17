---
name: mira-playful-outline
description: Design or implement borderless, shadow-free Playful Outline iOS interfaces with tonal color fields, circular controls, flowing wave divisions, and state-driven motion. Use for this named style or matching references, including its home card and interactive component demo.
---

# Mira Playful Outline

Use this adapter for **Playful Outline / 灵动描线**. The detailed source of truth is `docs/design-system/styles/playful-outline/Design.md`; read it before designing or editing this style.

## Read and apply

1. Read `docs/design-system/overview.md` and `docs/design-system/ai-usage-contract.md` for Mira's knowledge contract.
2. Read the style's `Design.md`, especially Component Guidance, Runtime Component Interfaces, Host Integration, Motion Rules, Accessibility, and Acceptance Checklist.
3. For code, follow `project-standards/vibe-coding.md` and `project-standards/design-demo-standard.md`. Keep runtime work under `Mira/Features/Styles/PlayfulOutline/`.
4. Preserve the user's task and color choices. The reference constrains filled control shapes and flowing color-field edges, not enclosing component strokes; its yellow palette is not mandatory.
5. Before implementation, name the requested controls and their real state transitions. Include cancellation, retry, disabled and reduced-motion behavior where relevant.
6. Verify interactions and both zero-border and zero-shadow constraints. Report syntax, build, simulator and device evidence separately.

## Implementation routing

- Tokens and home specimen: `MiPlayfulOutlineTokens.swift`, `MiPlayfulOutlineWave.swift`, and `MiPlayfulOutlineHomePreview.swift` in the runtime module.
- Buttons and switches: `MiPlayfulOutlineControls.swift`; preserve native Button roles, disabled state, and Toggle accessibility semantics.
- Confirmation flow: `MiPlayfulOutlineDialog.swift`; keep confirmation and dismissal separate so the completed state stays visible. Follow the host responsibilities for background focus isolation and motion suspension in `Design.md`.
- Chapter selection and prompt inspector: `MiPlayfulOutlineSegment.swift` and `MiPlayfulOutlineSheet.swift`; use the documented bindings and native presentation detents instead of adding another navigation or panel system.
- Secondary motion lesson: `MiPlayfulOutlineMotionDetailView.swift`; the parent detail owns its NavigationStack and zoom source, with ordinary native navigation for Reduce Motion.
- When changing the main detail, recheck the hero's visible/active/uncovered conditions and all recoverable form states. The runtime interface table in `Design.md` defines the contracts; this adapter does not redefine them.

## Boundaries

- Keep all component recipes and token values in `Design.md`; this skill is a routing adapter.
- Outline means the edge of a filled shape. Never add enclosing strokes, double rings, or divider lines to components or sections; icon strokes such as checkmarks remain allowed.
- Separate and join full-width sections with tonal contrast and organic wave seams, rather than wrapping every area in a rounded card. Inputs show focus and errors through background color plus visible error text.
- Do not turn this style into glass, skeuomorphism or hard-shadow brutalism.
- Preserve native control semantics, Dynamic Type and modal escape paths.
- Home card replicas remain static at rest; any continuous detail animation is explicitly activated and lifecycle-bound.
- This skill authorizes design and local implementation only, not deployment or publishing.
