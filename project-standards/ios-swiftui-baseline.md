# iOS / SwiftUI Baseline / iOS 与 SwiftUI 质量底线

## Platform Rules

- Use SwiftUI-native layout, state, navigation, animation, and materials where possible.
- Respect safe areas, keyboard behavior, Dynamic Island/notch constraints, and the home indicator.
- Prefer platform-standard navigation and modal behavior unless the task is explicitly experimental.
- Keep primary touch targets at least 44x44 pt.
- Preserve predictable back behavior and state restoration where relevant.

## Apple Liquid Glass Rules

- Prefer standard SwiftUI controls, navigation, toolbars, sheets, menus, and search behaviors before building custom glass chrome.
- Use Liquid Glass as the top functional layer for navigation, search, filters, inspectors, and floating commands.
- Use `glassEffect(_:in:)` only for important custom controls on supported OS versions, with a readable fallback on earlier OS versions.
- Group adjacent custom glass controls with `GlassEffectContainer` so SwiftUI can render effects together.
- Avoid live material on every repeated card, list row, or high-frequency panning item.
- Remove custom control backgrounds when they interfere with system-provided Liquid Glass or scroll-edge behavior.
- Test reduced transparency, reduced motion, high contrast, and Dynamic Type for every custom glass surface.

## Typography

- Use Dynamic Type-compatible text styles before custom fixed sizing.
- Avoid tiny labels that break readability on iPhone.
- Use weight, size, spacing, and color together to express hierarchy.
- Never rely on decorative typography if it weakens primary task comprehension.

## Color & Material

- Define style color decisions as tokens before scattering one-off values.
- Keep foreground/background contrast readable across light and dark contexts.
- Use SwiftUI `Material`, overlays, gradients, and shadows intentionally.
- Avoid stacking blur, opacity, and shadows until text contrast becomes unclear.
- For high-frequency gestures, prefer static gradients, scrims, strokes, and transform/opacity changes over repeated live blur.

## Layout

- Use stable spacing scales.
- Avoid nested cards unless the style specifically requires framed surfaces.
- Keep screen-level structure easy to scan on iPhone first.
- Do not place key actions behind gesture-only interactions.

## Motion

- Use motion to explain state changes, hierarchy, or gesture response.
- Keep animations interruptible and short.
- Provide reduced-motion alternatives for expressive transitions.
- Avoid animation that blocks input or causes layout instability.

## Accessibility

- Provide useful accessibility labels for icon-only controls.
- Support VoiceOver reading order that matches visible hierarchy.
- Do not communicate status by color alone.
- Keep error and empty states actionable.
- Verify important visual styles against contrast and Dynamic Type risks.

## SwiftUI Implementation Preferences

- Prefer small focused views with clear state inputs.
- Keep reusable style logic in tokens, modifiers, or components.
- Use previews to show major states: default, empty, loading, error, long text, and accessibility text size when practical.
- Avoid view files that combine data loading, navigation policy, and visual styling without clear boundaries.

## Localization

- Put app-facing copy in `Localizable.strings` for English and Simplified Chinese.
- Use short lower-snake-case keys without a `mi_` prefix, for example `nb_open_style` or `ac_glass_readable`.
- Keep keys descriptive enough to find by module, but avoid long sentence-like names.
- New Swift code should call `MiL10n.text` or `MiL10n.format` instead of hard-coding visible copy.
