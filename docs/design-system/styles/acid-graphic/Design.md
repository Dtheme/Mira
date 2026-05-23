# Acid Graphic / 酸性美学

## Style Identity

- **Status**: Registered draft. This file exists so AI tools can resolve the style path, but the style is not implementation-ready yet.
- **Definition**: Acid Graphic uses high-saturation color, distorted typography, collage tension, noisy gradients, sharp contrast, and experimental composition.
- **iOS Interpretation**: Use it as controlled visual energy inside previews, hero moments, editorial cards, or campaign-like surfaces. Do not apply it to every navigation or reading surface.

## Best Use Cases

- Visual encyclopedia hero samples.
- Experimental style previews.
- Creative tool onboarding or spotlight modules.
- Small promotional areas where expressive visual identity matters more than dense reading.

## Avoid When

- The screen is text-heavy, form-heavy, or requires calm task completion.
- Accessibility contrast cannot be preserved.
- The style would fight Mira's Apple Liquid Glass app shell.
- The product needs a conservative, enterprise, medical, financial, or system-utility tone.

## Visual Tokens

- Draft color direction: electric lime, acid green, hot pink, deep black, saturated violet.
- Draft type direction: bold display typography, tight editorial rhythm, occasional warped or oversized lettering.
- Draft surface direction: flat high-contrast blocks, translucent overlays used sparingly, noisy or poster-like backgrounds.
- Draft image direction: collage, distortion, scanline/noise texture, iridescent highlights.

## Layout Rules

- Use asymmetric composition intentionally, with one clear focal object.
- Keep primary actions and labels in stable readable zones.
- Limit distortion to decorative or preview content, not functional copy.
- Preserve a readable fallback layout for Dynamic Type and VoiceOver.

## Component Guidance

- Cards: high-energy artwork or color-block background with a readable label area.
- Buttons: high-contrast, direct shapes; avoid tiny text on noisy backgrounds.
- Tags: bold color chips with explicit selected state.
- Sheets and inspectors: use calmer Mira shell treatment so text remains inspectable.

## iOS / SwiftUI Notes

- Prefer gradients, blend modes, clipped shapes, image assets, and controlled overlays.
- Avoid expensive constantly animated noise or blur stacks.
- Keep Acid Graphic content inside style demo areas; do not replace global Mira navigation.

## Motion Rules

- Use quick cuts, color shifts, or small scale/rotation accents.
- Avoid large chaotic motion that makes spatial navigation uncomfortable.
- Reduced Motion should remove distortion movement and preserve static contrast.

## Accessibility

- Never rely on color-only status.
- Add scrims or solid labels when text appears over acid visuals.
- Check contrast across bright green, pink, yellow, and violet backgrounds.
- Keep functional hit targets at least 44x44 pt.

## Prompt Guidance

Use this style when the prompt asks for acid visual design, experimental graphics, high-energy creative visuals, or poster-like UI moments. Output should include token suggestions, readable zones, contrast controls, and explicit anti-patterns.

## Anti-patterns

- Applying distortion to body text.
- Making every control neon and noisy.
- Hiding interaction state behind abstract visuals.
- Treating Acid Graphic as a generic gradient theme.

## Acceptance Checklist

- [ ] The demo has one strong acid visual focal point.
- [ ] Functional text remains readable.
- [ ] Buttons and selected states are explicit.
- [ ] Reduced Motion removes chaotic movement.
- [ ] Mira's Apple Liquid Glass shell remains coherent.
