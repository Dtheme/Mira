---
name: mira-playful-outline
description: Design or implement borderless, shadow-free Playful Outline iOS interfaces with content-led components, soft color fields, and gentle curved divisions. Use for this named style or matching references, including its home note specimen and interactive component demo.
---

# Mira Playful Outline

Use this adapter for **Playful Outline / 灵动描线**. The detailed source of truth is `docs/design-system/styles/playful-outline/Design.md`; read it before designing or editing this style.

## Read and apply

1. Read `docs/design-system/overview.md` and `docs/design-system/ai-usage-contract.md` for Mira's knowledge contract.
2. Read the style's `Design.md`, especially Component Guidance, Runtime Component Interfaces, Host Integration, Motion Rules, Accessibility, and Acceptance Checklist.
3. For code, follow `project-standards/vibe-coding.md` and `project-standards/design-demo-standard.md`. Keep runtime work under `Mira/Features/Styles/PlayfulOutline/`.
4. Preserve the user's task and color choices. Curves serve whitespace or meaningful separation. The current home specimen is a static collectible note, without a player or mini tabs; flowing navigation belongs only to the three detail destinations.
5. Before implementation, name the requested controls and their real state transitions. Include cancellation, retry, disabled and reduced-motion behavior where relevant.
6. Verify interactions and both zero-border and zero-shadow constraints. Report syntax, build, simulator and device evidence separately.

## Implementation routing

- Tokens, note component, and home specimen: `MiPlayfulOutlineTokens.swift`, `MiPlayfulOutlineNoteCard.swift`, and `MiPlayfulOutlineHomePreview.swift` in the runtime module. The home card uses the note's compact noninteractive form; the detail binds its real save action.
- Three destinations and flowing navigation: `MiPlayfulOutlineDetailView.swift`, `MiPlayfulOutlineInspirationView.swift`, and `MiPlayfulOutlineFlowTabBar.swift`; keep inspiration, components, and reference as real content destinations. Curve behavior, appearance, and state lifetime follow the contracts in `Design.md`.
- Input state: `MiPlayfulOutlineInputDemo.swift` reads the host-owned state from `MiPlayfulOutlineInputState.swift`; preserve input, filters, and results across tabs while keeping focus and loading-task lifetime local to the visible form.
- Buttons and switches: `MiPlayfulOutlineControls.swift`; preserve native Button roles, disabled state, and Toggle accessibility semantics.
- Confirmation flow: `MiPlayfulOutlineDialog.swift`; keep confirmation and dismissal separate so the completed state stays visible. Follow the host responsibilities for background focus isolation in `Design.md`.
- Local component selection and prompt inspector: `MiPlayfulOutlineSegment.swift` and `MiPlayfulOutlineSheet.swift`; preserve their documented bindings and native presentation detents.
- Secondary motion lesson: `MiPlayfulOutlineMotionDetailView.swift`; the parent detail owns its NavigationStack and zoom source, with ordinary native navigation for Reduce Motion.
- When changing the main detail, recheck shared saved/input state, stable navigation identity, the elastic setting, task cancellation/resumption, and modal escape paths. The runtime interface table in `Design.md` defines the contracts; this adapter does not redefine them.

## Boundaries

- Keep all component recipes and token values in `Design.md`; this skill is a routing adapter.
- Outline means the edge of a filled shape. Never add enclosing strokes, double rings, or divider lines to components or sections; icon strokes such as checkmarks remain allowed.
- Use a gentle local curve when it separates content from an action or clarifies navigation. Do not fill otherwise quiet pages with waves. Keep the detail tab's broad flowing boundary continuous inside its stable container.
- Do not turn this style into glass, skeuomorphism or hard-shadow brutalism.
- Preserve native control semantics, Dynamic Type and modal escape paths.
- Home card replicas remain static at rest and while dragging. Tab motion is selection-driven and interruptible; the elastic setting and Reduce Motion fallbacks follow `Design.md`.
- This skill authorizes design and local implementation only, not deployment or publishing.
