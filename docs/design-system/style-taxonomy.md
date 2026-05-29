# Style Taxonomy / 风格分类体系

## Purpose

This taxonomy keeps Mira's design styles searchable and comparable. A style may belong to one primary category and several secondary tags, but each `Design.md` should still describe one coherent design language.

## Required Style File

Every style in this taxonomy must have a matching file:

```text
docs/design-system/styles/<style-slug>/Design.md
```

Taxonomy entries are only an index. The `Design.md` file is the operational source that the skill uses for style-specific tokens, layout rules, component guidance, SwiftUI notes, anti-patterns, and acceptance checks.

When adding a style:

1. Create `docs/design-system/styles/<style-slug>/Design.md` from `docs/design-system/design-md-template.md`.
2. Fill enough content for an AI agent to apply the style without guessing.
3. Add or update the taxonomy row with the exact `Design.md` path.
4. Do not mark the style as usable until the `Design.md` includes an Acceptance Checklist.

## Primary Categories

### Experimental Visual / 实验视觉

High-expression styles that rely on unusual color, typography, distortion, collage, or visual tension.

Typical styles:

- Acid Graphic / 酸性美学 (moved out of Mira's first implementation batch)
- Y2K Futurism
- Cyberpunk
- Glitch
- Psychedelic

Use carefully in iOS: keep navigation, form input, and readability stable while allowing visual expression in hero areas, cards, covers, or editorial surfaces.

### Material & Surface / 材质与表面

Styles defined by material simulation, depth, lighting, blur, translucency, or tactile surface behavior.

Typical styles:

- Apple Liquid Glass / 苹果液态玻璃
- Glassmorphism / 玻璃拟物化设计
- Neumorphism
- Skeuomorphism
- Claymorphism
- Liquid Metal

Use carefully in iOS: map effects to SwiftUI materials, shadows, overlays, and depth hierarchy without sacrificing contrast.

### System Framework / 系统框架

Styles or demos that translate an official platform framework into inspectable UI patterns.

Typical styles:

- Material 3 / Material You

Use carefully in iOS: preserve the framework's real concepts, runtime boundaries, component semantics, and platform accessibility requirements instead of turning it into a purely visual skin.

### Anti-design & Structural / 反设计与结构表达

Styles that expose layout structure, hard edges, intentional imbalance, raw typography, or visible interaction affordances.

Typical styles:

- Neo-Brutalism / 新粗野主义
- Brutalism
- Swiss Grid Brutalism
- Terminal / CLI-inspired UI
- Editorial Raw

Use carefully in iOS: strong borders and unusual composition are allowed, but tap targets, hierarchy, and navigation predictability remain mandatory.

### Minimal & Systematic / 极简与系统化

Styles that emphasize restraint, hierarchy, spacing, and product utility.

Typical styles:

- Minimalism / 极简主义
- Swiss International
- Bento Grid
- Calm Productivity
- Utility SaaS

Use carefully in iOS: avoid empty generic minimalism; every simplification should improve clarity, repeated use, or content scanning.

### Futuristic & Immersive / 未来感与沉浸式

Styles that use depth, spatial UI, glowing systems, cinematic transitions, or futuristic visual language.

Typical styles:

- Spatial UI
- VisionOS-inspired
- Holographic
- Sci-fi Dashboard
- AI Native Interface

Use carefully in iOS: treat glow, depth, and motion as hierarchy tools, not decoration.

### Cultural & Editorial / 文化与编辑设计

Styles shaped by media, fashion, art direction, subculture, or publication language.

Typical styles:

- Luxury Editorial
- Magazine Layout
- Kawaii
- Streetwear
- Art Museum

Use carefully in iOS: keep brand expression strong while preserving system usability.

## Tag Dimensions

Each style may include tags from these dimensions:

- **Platform Fit**: iOS, iPadOS, watchOS, visionOS, web reference only
- **Expression Level**: quiet, balanced, expressive, extreme
- **Content Density**: sparse, medium, dense
- **Motion Level**: static, subtle, expressive, immersive
- **Accessibility Risk**: low, medium, high
- **Implementation Risk**: low, medium, high

## Registered Style Index

| Style | Primary Category | Expression | Accessibility Risk | Implementation Risk | Design.md |
| --- | --- | --- | --- | --- | --- |
| Apple Liquid Glass | Material & Surface | Expressive | Medium | Medium | `docs/design-system/styles/apple-liquid-glass/Design.md` |
| Glassmorphism | Material & Surface | Balanced | Medium | Medium | `docs/design-system/styles/glassmorphism/Design.md` |
| Neumorphism | Material & Surface | Balanced | Medium | Medium | `docs/design-system/styles/neumorphism/Design.md` |
| Claymorphism | Material & Surface | Expressive | Medium | Medium | `docs/design-system/styles/claymorphism/Design.md` |
| Neo-Brutalism | Anti-design & Structural | Expressive | Medium | Low | `docs/design-system/styles/neo-brutalism/Design.md` |
| Minimalism | Minimal & Systematic | Quiet | Low | Low | `docs/design-system/styles/minimalism/Design.md` |
| Material 3 | System Framework | Balanced | Low | Medium | `docs/design-system/styles/material-3/Design.md` |
