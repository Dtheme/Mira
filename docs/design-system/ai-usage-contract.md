# AI Usage Contract / AI 使用约定

## Purpose

This contract defines how AI agents should use Mira's design system knowledge. The goal is consistent, implementable iOS design guidance rather than decorative style name-dropping.

## Input Contract

An AI request should include:

```text
Target screen: the screen or workflow being designed
User scenario: who uses it and why
Selected style: one style or a clear style combination
Platform constraints: iOS / iPadOS / SwiftUI / device size
Functional constraints: required actions, states, data, and edge cases
```

If a request does not specify a style, the agent should ask for one or choose a conservative iOS-native default only when the user asks for a recommendation.

## Output Contract

AI output should include:

- **Style Direction**: how the selected style translates to this screen.
- **Token Suggestions**: color, typography, shape, material, elevation, and motion tokens.
- **Layout Guidance**: hierarchy, spacing, density, safe area, and scrolling behavior.
- **Component Guidance**: how key components should look and behave.
- **SwiftUI Notes**: concrete SwiftUI primitives or modifiers that fit the style.
- **Accessibility Checks**: contrast, Dynamic Type, VoiceOver, touch target, reduced motion.
- **Anti-pattern Check**: style-specific mistakes to avoid.
- **Acceptance Checklist**: measurable checks before implementation is accepted.

## Must Rules

- Use `docs/design-system/design-md-template.md` as the required schema for every style.
- Every new design style must create and maintain `docs/design-system/styles/<style-slug>/Design.md`.
- Do not treat a style as implementation-ready unless its `Design.md` exists and includes an Acceptance Checklist.
- Use iOS / SwiftUI interpretation first, even when a style originated on the web.
- Preserve Apple platform conventions unless the user explicitly asks for an experimental prototype.
- Keep text readable and controls operable before adding visual effects.
- Prefer semantic and component tokens over one-off color or blur values.
- State risks when a style has accessibility, performance, or readability tradeoffs.

## Should Rules

- Recommend native SwiftUI materials, gradients, shadows, animations, and controls when they fit.
- Use style taxonomy tags to explain fit, risk, and implementation complexity.
- Include "what to avoid" for every generated design direction.
- Keep strong visual styles focused on high-impact surfaces rather than every control.

## Avoid Rules

- Do not output only keywords, mood words, or generic visual adjectives.
- Do not use web CSS as the implementation plan for iOS.
- Do not reduce a style to a single effect, such as blur for Glassmorphism or thick borders for Neo-Brutalism.
- Do not suggest text smaller than practical iOS readability allows.
- Do not rely on color alone to communicate state.

## Style Combination Rules

Combining styles is allowed only when each style has a clear role:

- one dominant style for overall composition
- one secondary style for selected surfaces or interactions
- one shared accessibility baseline

Avoid combining two high-expression styles unless the target screen is editorial, promotional, or experimental.

## Validation Workflow

Before an AI agent claims a design recommendation is ready, it should verify:

- The style has a registered category in `style-taxonomy.md`.
- The style has a concrete `docs/design-system/styles/<style-slug>/Design.md` file.
- The style-specific `Design.md` follows the standard schema and includes an Acceptance Checklist.
- The recommendation includes tokens, layout, components, SwiftUI notes, and accessibility checks.
- The output does not duplicate long docs content from adapters.
