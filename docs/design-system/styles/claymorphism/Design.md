# Claymorphism / 黏土形态

## Style Identity

- **Definition**: Claymorphism is a soft 3D interface style that makes digital components feel like matte clay objects: puffy, rounded, tactile, and gently floating above the surface.
- **Core Feeling**: 温暖、乐观、安全、可触摸；界面元素像被手工捏出来的柔软实体，而不是冰冷像素。
- **Visual Keywords**: clay, puffy, matte, pastel, soft 3D, large radius, inner shadow, outer shadow, squishy press, toy-like safety.
- **iOS Interpretation**: Mira should translate Claymorphism into SwiftUI-native rounded shapes, layered shadows, masked inner highlights, spring press feedback, and readable pastel panels. It should not copy CSS literally.

## Best Use Cases

- Web3, NFT, avatar, metaverse, and creative identity products that benefit from playful 3D personality.
- Children's education, early learning, and casual game UI where safety and friendliness matter.
- Portfolio, creative blog, wellness, meditation, and low-stress lifestyle interfaces.
- Small interactive components where touch feedback is central to the experience.

## Avoid When

- Dense dashboards, admin tools, financial tables, or legal document workflows where information density and authority matter more than playfulness.
- Screens that require many compact controls, because large radius, thick shadows, and generous spacing consume space.
- Contexts where pastel color alone would weaken contrast or make state ambiguous.

## Visual Tokens

### Color Tokens

- Primitive:
  - `mi-clay-background`: `#FFF4F2`
  - `mi-clay-surface`: `#FFE2CD`
  - `mi-clay-peach`: `#FFB08A`
  - `mi-clay-coral`: `#FF7E8A`
  - `mi-clay-lilac`: `#C9B7FF`
  - `mi-clay-mint`: `#A9E8D0`
  - `mi-clay-sky`: `#A8D8FF`
  - `mi-clay-butter`: `#FFE29A`
  - `mi-clay-ink`: `#46334A`
- Semantic:
  - `mi-clay-matte-surface`: soft pastel base with no glossy reflection.
  - `mi-clay-raised-object`: puffy floating component with dual outer shadows.
  - `mi-clay-inset-object`: carved input or slot with inner shadow.
  - `mi-clay-pressed-object`: compressed state with reduced outer shadow and stronger inner edge.
  - `mi-clay-safe-accent`: friendly selected state color.

### Typography Tokens

- Display: rounded, heavy system title for playful identity.
- Title: bold rounded labels on cards and controls.
- Body: medium system text; avoid tiny captions because the style already has low-density surfaces.
- Label: uppercase metric labels are acceptable in inspectors, but keep tracking moderate.

### Shape / Radius Tokens

- Cards: very large continuous rounded rectangles, usually 30-36 pt.
- Buttons: capsule or puffy rounded rectangles, 22-32 pt radius.
- Inputs: inset rounded troughs with 18-24 pt radius.
- Decorative blobs: circles and soft rounded rectangles, never sharp polygons.

### Elevation / Shadow Tokens

- Outer shadow: one light upper-left shadow and one warm lower-right shadow.
- Inner shadow: masked white top-left highlight plus warm lower-right occlusion.
- Matte finish: no glass blur and no sharp specular highlight.
- Pressed state: outer shadow contracts, shape scales down slightly, and inner shadow becomes more visible.

## Layout Rules

- Use generous spacing so puffy components do not collide.
- Prefer one strong clay object per hero or card instead of many small clay controls.
- Keep explanatory copy on readable pastel panels with dark ink text.
- Let the global Mira shell remain Apple Liquid Glass; Claymorphism lives inside the style preview and detail content.
- Avoid applying clay shadows to every repeated small item.

## Component Guidance

- Hero Preview:
  - Use one oversized puffy button or soft knob as the signature control.
  - Tapping toggles raised and pressed states.
  - Status rows must update with state, depth, shadow, and motion values.
- Home Card:
  - One poked clay specimen: a matte peach ellipse (wider than tall, center at 0.63 card height) with a thumbprint dent carved into its upper-left face and two tiny mint/butter crumbs resting low-right at its base.
  - The field stays quiet: a near-flat cream vertical gradient plus one flat lilac arc cropping into the top-right corner; copy is only the style name and one hook line, top-left.
  - Press is the poke: the ball squashes volume-preservingly (scale x 1.06, y 0.92, anchored at its bottom) while the dent grows and darkens; dual outer shadows pull in tight, then everything springs back with a jelly rebound. Reduced motion drops the squash and offset, keeping only shadow contraction and dent darkening.
  - The masked inner puff and the dent's blurred inset strokes render only at rest; while the home canvas pans (isDragging) they fall back to flat fills plus a plain hairline, and shadow radii roughly halve.
- Buttons:
  - Minimum 44 pt touch target.
  - Press feedback must show physical compression, not only color change.
- Inputs:
  - Use inset soft troughs; focused state may deepen inner shadow and tint edge.
- Chips / tags:
  - Use small capsules with pastel fills, but keep text contrast high.

## iOS / SwiftUI Notes

- Use `RoundedRectangle(style: .continuous)`, `Capsule`, `Circle`, `shadow`, masked `stroke`, and `overlay` to build soft depth.
- Use spring animations for press/release feedback; respect Reduce Motion by shortening or removing bouncy movement.
- Use semantic tokens for shadow colors and surface fills rather than one-off colors.
- Do not introduce 3D or WebGL dependencies for this style demo.

## Motion Rules

- Press: scale down slightly, move 1-2 pt, reduce outer shadow, deepen inner edge.
- Release: spring back with a gentle jelly feel.
- Hover-style lift is not primary on iPhone; touch feedback is.
- Avoid continuous bouncing; motion should follow user action.

## Accessibility

- Pastel surfaces need dark text and explicit state labels.
- Do not rely on color alone for selected or error states.
- Maintain 44x44 pt touch targets.
- Keep Dynamic Type readable by allowing cards and panels to grow vertically.
- VoiceOver should identify controls as buttons, selected states, and pressed values.

## Prompt Guidance

### Use This Style When Prompt Says

- Claymorphism
- 黏土形态
- puffy UI
- soft 3D
- pastel toy-like interface
- squishy button
- matte clay material

### AI Output Should Include

- Matte pastel palette.
- Large radius and inflated shapes.
- Dual outer shadows and masked inner shadows.
- Pressed state with physical compression.
- Inset input troughs.
- Accessibility constraints for contrast and target size.

## Anti-patterns

- Do not turn Claymorphism into glossy plastic, glass, or pure Neumorphism.
- Do not use tiny dense tables or dashboard grids as the main expression.
- Do not rely on pastel color without readable ink text.
- Do not use sharp corners, flat buttons, or color-only press feedback.
- Do not overuse clay treatment on every small icon.

## Acceptance Checklist

- [ ] The demo uses large, puffy, matte clay shapes.
- [ ] Components include dual outer shadows and inner edge shadows.
- [ ] The Hero Preview has one oversized interactive puffy control.
- [ ] Pressed state visibly compresses and changes depth.
- [ ] Inputs use an inset carved-surface treatment.
- [ ] Home card clearly communicates Claymorphism in one glance.
- [ ] Text contrast and touch targets remain accessible.
- [ ] Reduced Motion has a comfortable fallback.
