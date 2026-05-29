# Material 3 / Material You

## Style Identity

- **Status**: Implementation-ready. Runtime demo lives in `Mira/Features/Styles/Material3/`.
- **Definition**: Material 3 is a systematic style language built from dynamic color, semantic color roles, type scale, shape scale, motion/state layers, elevation, and accessible component states.
- **Core Feeling**: 柔和、系统化、组件清晰、状态明确。
- **iOS Interpretation**: Mira adapts Material 3 visual language into SwiftUI while preserving iOS navigation, safe areas, Dynamic Type, and platform expectations. Do not copy Android navigation behavior directly.

## Best Use Cases

- Component-heavy tools, dashboards, onboarding, filters, search, and settings.
- Interfaces that need predictable tokens and stateful controls.
- AI prompt generation where semantic roles and component states must be explicit.

## Avoid When

- The UI must feel purely Apple-native.
- The product should avoid Google/Android associations.
- Strong editorial, brutalist, or luxury visual language is more appropriate.

## Visual Tokens

- `mi-m3-primary`: primary action, selected state, and source role.
- `mi-m3-primary-container`: high-emphasis tonal container.
- `mi-m3-secondary-container`: chips, tonal buttons, and supporting panels.
- `mi-m3-tertiary-container`: expressive accent container.
- `mi-m3-surface-container-*`: surface hierarchy ladder before relying on shadow.
- `mi-m3-outline-variant`: dividers, lower-emphasis boundaries, and outline strokes.
- Type: display, headline, title, body, and label roles.
- Shape: small, medium, large, extra-large, and full shapes for cards, chips, sheets, and FABs.

## Layout Rules

- Start from semantic color roles, not raw colors.
- Group content in surface containers with clear hierarchy.
- Use chips, tonal buttons, and segmented navigation to expose state.
- Preserve iOS-safe top bars and back behavior when used inside Mira.

## Component Guidance

- Buttons: filled, tonal, outlined, disabled, and destructive/error variants.
- Chips: selected chips include icon/shape support, not color alone.
- Search/Input: use surface container, visible icon/placeholder, clear focus treatment.
- Navigation: Material-like segmented/tab controls are allowed, but iOS back behavior remains native.
- Home Card: show the same signature idea at card scale: source color, compact role chips, one tonal container, and one FAB. Avoid search bars, bottom navigation, or full app chrome on the card.
- Hero Preview: show one focused signature component, not a crowded miniature app. The preferred demo is a dynamic tonal component: one source color generates primary/secondary/tertiary/neutral roles, a primary container, FAB color, shape radius, and state-layer feedback.

## iOS / SwiftUI Notes

- Runtime module path: `Mira/Features/Styles/Material3/`.
- Use SwiftUI rounded rectangles, capsules, labels, overlays, and state-layer-style pressed fills.
- Keep all controls at least 44pt high.
- Use iOS sheets/navigation conventions even when visual components reference Material.

## Motion Rules

- Use short state-layer feedback on press.
- Shape and tint can transition gently, but avoid large layout shifts.
- Reduced Motion should retain selected fills, icons, and labels.

## Accessibility

- State must be shown through label, icon, shape, and color role.
- Contrast must be checked for tonal containers.
- Dynamic Type should wrap chips and button labels instead of clipping.
- VoiceOver labels should describe selected and disabled state.

## Prompt Guidance

Ask AI to output Material 3 roles first: primary, secondary, tertiary, surface, outline, error, state layer, shape scale, and component state matrix. Then ask for SwiftUI implementation notes and iOS adaptation boundaries.

## Anti-patterns

- Copying Android navigation into iOS without adapting.
- Using purple rounded cards and calling it Material 3.
- Omitting state layers, disabled states, or error roles.
- Using raw hex colors directly inside components.

## Acceptance Checklist

- [ ] Semantic color roles are named before component styling.
- [ ] Filled, tonal, outlined, selected, disabled, loading, and error states are represented.
- [ ] iOS safe areas, navigation, Dynamic Type, and touch targets are preserved.
- [ ] Token swatches, forms, navigation, states, prompt guidance, and checklist are included.
- [ ] State meaning does not rely on color alone.
