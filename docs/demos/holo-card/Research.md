# Pokémon-style Holographic Card Demo / 仿宝可梦伪3D镭射卡 — Research

> Research / 调研 deliverable. No app code is written by this document. It records the
> verified feasibility study and the locked design decisions for Mira's first interactive
> Demo. Implementation begins only when explicitly requested, following this doc.

## Status

- **Stage**: Research complete, key decisions locked (2026-06-29).
- **Scope**: Mira's first **Demo area** + its flagship demo — a pseudo-3D, gyroscope-driven
  holographic / laser (镭射) trading card, inspired by Pokémon foil cards.
- **Verdict**: Feasible without a heavyweight Metal pipeline. Ship on SwiftUI native shaders.
- **First-of-kind**: This is the project's first Metal (`.metal`) and CoreMotion code. Keep
  it fully isolated under `Mira/Features/Demos/`; it must not regress the all-SwiftUI build.

## Design Read (one line)

A single, original holo card held in the hand: the **effect** is the moving light/shadow as you
tilt the phone — a soft specular sheen glides across the surface with only a faint, low-contrast
pearlescent color shift (**not** a saturated rainbow), light on the facing side and shade on the
away side, while the card tilts in perspective. Restraint over spectacle.

## Art direction (visual restraint) — primary

The user's priority is the **effect** (motion of light/shadow), **not** a flashy rainbow.

- **Low contrast, soft, muted.** No gaudy full-spectrum foil. The color shift is a faint
  undertone, not the headline.
- **Narrow desaturated palette.** Iridescence stays within 2–3 muted hues around the card's
  single accent (think soft pearlescent / satin / oil-sheen), saturation ~0.15–0.30 — not the
  red→orange→yellow→green→cyan→blue→violet rainbow of the reference.
- **Soft blends, low strength.** Prefer `soft-light`/`screen` over `color-dodge` (dodge blows
  out highlights → high contrast). Master `holoStrength` ~0.2–0.35.
- **The moving glare is the star.** A soft, wide, low-opacity hotspot tinted toward the card
  surface (never pure white) plus the away-side shade and rim is the main readable cue; the hue
  shift is secondary.
- **Sparkle minimal or off** by default — glitter reads as "花哨". Subtlety over twinkle.
- This aligns with the anti-AI-slop discipline: one accent, surface-tinted light, restraint.

## 1. Rendering routes

The reference technique is **simeydotme/pokemon-cards-css (poke-holo)**: pure CSS layering
(repeating gradients + blend modes + masks + a 3D `rotateX/rotateY` transform), driven on
mobile by `deviceorientation` gamma/beta. Our gyroscope replaces the pointer. Any route must
reproduce: a base art layer, a foil/holo hue-shift layer, a specular glare, sparkle, and a 3D
tilt.

| Route | Mechanism | Fidelity | Complexity | Fit with Mira (SwiftUI-first, single-ZStack) | Verdict |
|---|---|---|---|---|---|
| **A. SwiftUI `Shader` (`.colorEffect`/`.layerEffect`) + `rotation3DEffect` + CoreMotion** | One `[[stitchable]]` MSL fragment fn; gyro → uniforms; `TimelineView` clock | High (~90% of reference) | Low–medium | Excellent — it *is* SwiftUI; drops into the existing dissolve | **Primary** |
| D. Pure SwiftUI, no Metal | `AngularGradient`/`MeshGradient` + `.blendMode` + `rotation3DEffect` | Medium–low | Lowest | Excellent | **Fallback** (Reduce Motion / no sensor / Low Power) |
| B. `MTKView` (UIViewRepresentable) + MSL render loop | Own drawable, pipeline, buffers, `CADisplayLink` | Highest (true mesh/parallax/refraction, free 120Hz control) | High | Poor — imperative GPU island | Escalate only if 4+ bound textures or true vertex perspective are needed |
| C. SceneKit / RealityKit | 3D card + PBR materials | High but awkward | Medium | Poor | **Rejected** — SceneKit soft-deprecated; 3D engine for a flat card is overkill |

**Decision**: Route **A** primary, Route **D** fallback (shared `MiHoloCardView` API so the
fallback is nearly free), Route **B** escalation contingency, Route **C** rejected.

`.colorEffect` gives the shader `(float2 position, half4 color) -> half4`. `.layerEffect`
additionally hands a `SwiftUI::Layer` you sample via `layer.sample(pos)` (needed to read the
composited card art). `.distortionEffect` remaps position only. All iOS 17+, unconditionally
available at the iOS 26 deployment target.

## 2. Critical shader constraint (load-bearing)

**SwiftUI `Shader` binds at most ~one `.image()` texture argument** (plus the view's own
`SwiftUI::Layer`). Passing several independent textures **fails silently** (no compile error).
A naïve "base art + holo mask + sparkle texture" three-texture design does **not** work under
Route A. WWDC 2026 session 322 demonstrates the supported shape: `layerEffect` with a single
`.image(Image("Noise"))` mapping to one `texture2d<half>` alongside the layer.

**Correct approach (mandatory):**
1. **Pre-composite base art + holo mask into one RGBA image** (mask packed into the alpha
   channel). The view renders that image; the shader reads it via the incoming `color` /
   `layer.sample()`.
2. **Make foil / iridescence / sparkle fully procedural in-shader** (cosine spectral palette +
   hash noise). This also looks better than a static glitter texture.
3. **Reserve the single `.image()` slot** for one optional authored galaxy/dust texture if a
   cosmos variant is wanted.

Only a 4+ simultaneous-texture need (authored base + mask + sparkle + galaxy) or a true
vertex-perspective foil warp forces Route B. The recommended *procedural* look does not.

## 3. Holographic visual anatomy → shader

Decompose the foil look into layers (each reacts to tilt differently):

1. **Base artwork** — substrate; does not react to tilt.
2. **Holo / foil mask** — grayscale α gating where foil appears → pre-composited into base alpha.
3. **Iridescent sheen (subtle, secondary)** — a soft low-saturation pearlescent shift whose
   phase moves with tilt; a narrow palette (2–3 muted hues around the card accent), **not** a
   saturated rainbow. Blend ≈ `soft-light`/`screen` (avoid `color-dodge`).
4. **Specular glare (primary effect)** — a soft, wide, low-opacity hotspot tracking the tilt
   vector, tinted toward the surface (never pure white). This moving light is the headline cue —
   the *light* side.
5. **Sparkle / glitter (minimal or off)** — keep very sparse and low-intensity, or disabled by
   default; glitter reads as "花哨".
6. **Rim light / dark side** — facing edge brightens, away side darkens → the *shade*, plus
   volume when combined with the 3D tilt.
7. **Parallax inner layers (optional)** — 2–3 planes offset at different gains for depth.

Shader math (single `[[stitchable]]` fn; uniforms `tilt: float2 (-1..1)`, `time: float`,
`resolution: float2`, `holoStrength: float`):

- Iridescence (subtle): `phase = dot(uv, dir)*k + tilt·gain` with **small gains** so the hue
  drifts gently (not a running rainbow). Map `phase` through a **narrow desaturated palette**
  centered on the card accent (IQ cosine palette with low `b`/saturation, ~0.15–0.30), not the
  full spectrum. Mix at low `holoStrength` (~0.2–0.35).
- Glare (primary): `center = 0.5 + tilt*0.4`; a **soft wide** falloff
  `glare = smoothstep(0.85, 0.15, distance(uv, center))` at low opacity, tinted to the surface.
- Sparkle: minimal or omitted; if used, very sparse `hash21` cells, low intensity.
- Blends are **hand-written** (MSL has no CSS blend builtins). Prefer `softLight` / `screen`
  for low contrast; **avoid `colorDodge`** (blows out highlights). `overlay`/`hardLight` only at
  low strength.
- Anti-slop: glare tinted toward the card surface, **not pure white**; clamp UV at borders
  (`SwiftUI::Layer.sample` has no `clamp_to_edge`, edges can smear under the perspective scale).

```metal
// Illustrative only — not final source.
[[ stitchable ]] half4 miHoloCard(float2 position, SwiftUI::Layer layer,
                                  float2 resolution, float2 tilt,
                                  float time, float holoStrength) {
    float2 uv   = position / resolution;
    half4  base = layer.sample(position);      // base art + mask(in alpha), pre-composited
    half   mask = base.a;
    float2 c    = 0.5 + tilt * 0.4;
    half   glare = half(smoothstep(0.85, 0.15, distance(uv, c)));   // soft, wide, low
    float  phase = dot(uv, float2(cos(radians(110.0)), sin(radians(110.0))) ) * 1.4
                 + tilt.x * 1.1 + tilt.y * 1.4;                     // small gains: gentle drift
    half3  sheen = softPearl(fract(phase));    // narrow desaturated palette around accent
    half3 foil = softLightBlend(base.rgb, sheen * (0.30h * mask * half(holoStrength)));
    foil       = softLightBlend(foil, mix(base.rgb, half3(1.0h), 0.6h) * glare * 0.35h); // surface-tinted glare
    return half4(mix(base.rgb, foil, half(holoStrength) * mask), base.a);
}
```

## 4. Gyroscope → light/shadow mapping (core requirement)

The gyroscope-driven light/shadow change is the core interaction, not optional.

- **Input**: `CMMotionManager.deviceMotion` (sensor fusion, drift-corrected). Read
  `attitude.roll` / `attitude.pitch` (or the `gravity` vector — robust, no trig). Reference
  frame `.xArbitraryZVertical` (no magnetometer). `deviceMotionUpdateInterval = 1/60`. Do not
  use `yaw`.
- **Mapping**: `roll → tiltX`, `pitch → tiltY`; clamp half-range ~±35° → normalize to −1…1.
- **Smoothing**: per render frame `current += (target − current) * k` (k ≈ 0.12–0.16) — a
  one-pole low-pass; without it the glare visibly buzzes from hand tremor.
- **Light AND shade**: tilt drives both the glare hotspot + iridescent hue (light) and the
  away-side darkening + rim (shade) and the `rotation3DEffect` perspective — all from the same
  tilt vector, locked together.
- **Threading**: own `CMMotionManager` on a `@MainActor @Observable` provider; deliver on a
  background `OperationQueue`, publish the smoothed value via a lock/atomic
  (`OSAllocatedUnfairLock` / `Mutex`), **not** a `Task { @MainActor }` per sample.
- **Lifecycle**: `start()` when the showcase appears / becomes active; `stop()` on disappear,
  on dissolve away, and on `scenePhase != .active`. CoreMotion left running drains battery.

```swift
// Illustrative provider sketch — not final source.
@MainActor @Observable final class MiMotionTiltProvider {
    private(set) var tilt: SIMD2<Float> = .zero
    var isAvailable: Bool { motion.isDeviceMotionAvailable }
    // start(): deviceMotionUpdateInterval = 1/60; map roll/pitch → clamp(±35°) → target.
    // advance(reduceMotion:): lerp tilt toward target (k≈0.16, heavier when reduceMotion).
    // setDragTilt(_:): fallback path writes the same normalized target.
}
```

### Fallback & accessibility (mandatory)

- **Gyro is device-only** — it does not run in the iOS Simulator and is the only way to
  capture App Store screenshots/video. A `DragGesture` (and/or slow auto-sway) maps to the
  **same** normalized `tilt`, so there is one downstream code path. Gate on
  `isDeviceMotionAvailable`.
- **Reduce Motion**: freeze/strongly damp tilt, stop the `time` animation, show a single static
  flattering sheen.
- **Reduce Transparency / Increase Contrast**: flatten foil, raise base contrast.
- **VoiceOver**: the card is one element with a static label; foil layers `accessibilityHidden`.
- Dynamic Type in captions, safe areas, ≥44pt targets.

## 5. Single-card Hero interaction

- **One card at a time**: a single Hero card centered, occupying the main viewport. The
  gyroscope holo runs only on this one card.
- **Switch decks by left/right swipe** (paged). Non-active cards do **not** run the shader;
  a card "lights up" only when it reaches center. This keeps the per-pixel shader cost to one
  card and avoids multi-card overdraw.
- Demo **list** (multiple entries) → holo **showcase** (single card, swipe to switch). List is
  many; showcase is one — no conflict.

## 6. Home demo entry — iOS system flat card

- The home demo entry is an **iOS system flat-style card**, explicitly **not** a Liquid-Glass
  capsule: `RoundedRectangle(cornerRadius: 16, style: .continuous)` filled with
  `Color(.secondarySystemGroupedBackground)`, a hairline/soft shadow, SF Symbol +
  title + subtitle + trailing `chevron.right`. One accent from `MiColorTokens`, Dynamic Type,
  ≥44pt target.
- Home is a full-screen ZStack: liquid backdrop → draggable constellation → floating glass
  search header. Place the flat entry card above the constellation, clear of the main drag
  area. Let it read as a distinct, native "system entry"; do not blend it into the glass —
  avoid a half-glass/half-flat hybrid.
- The flat entry card and the high-decoration holo showcase card are two different things: the
  entry is restrained; the showcase card is the spectacle.

## 7. Mira integration

- **Data model** — do not overload `MiDesignStyle` (a demo has no tokens/category/slug/Design.md):
  ```swift
  struct MiDemo: Identifiable, Hashable { let id, titleKey, subtitleKey, systemImage: String
                                          let accentHex: UInt; let isReady: Bool }
  enum MiDemoRepository { static let demos: [MiDemo] = [ /* holo-card */ ] }
  ```
- **Routing** — mirror the style-module pattern: `MiHoloCardModule.canOpen(_:) /
  showcaseView(for:onBack:)`.
- **Navigation** — reuse the existing single-ZStack dissolve (no `NavigationStack`). Add a
  route enum in `MiAppRootView`, e.g. `enum MiRootRoute { case styleDetail(MiDesignStyle);
  case demoList; case demoShowcase(MiDemo) }`, layered in the same ZStack with the same
  `detailTransition` / `dissolveAnimation` and reduced-motion handling. List and showcase are
  each one full-screen layer; back sets the route to the previous case.
- **File / type layout** (all `Mi`-prefixed):
  ```
  Mira/Features/Demos/
    MiDemo.swift
    MiDemoRepository.swift
    MiDemoListView.swift
    MiDemoEntryCard.swift          // iOS system flat entry card
  Mira/Features/Demos/HoloCard/
    MiHoloCardModule.swift
    MiHoloCardShowcaseView.swift   // single-card Hero + swipe deck
    MiHoloCardView.swift           // card body; Route A <-> D switch
    MiMotionTiltProvider.swift
    MiHoloFoil.metal               // [[stitchable]] fragment shader
  ```
- **Touch points (implementation phase)**: add route state + demo layers to `MiAppRootView`;
  add `MiDemoEntryCard` into `MiHomeView`'s ZStack; new `MiL10n` keys; add the `.metal` file to
  the app target's Compile Sources (the only non-Swift build input and only `project.pbxproj`
  change). Build/run via `Mira.xcworkspace` (CocoaPods).

## 8. Constraints (binding)

- **IP originality (hard)**: the reference and its images are Pokémon IP. `pokemon-cards-css`
  code is MIT but its **card images are not** — do not vendor them. Use an **original creature +
  original card frame/type ribbon**; do not clone the TCG frame/trade dress.
- **Mi prefix** on every new type and file, including the `.metal`.
- **Anti-AI-slop**: one accent, one radius system, one theme; glare tinted to surface (no pure
  white clip); zero em-dash in UI copy; motivated motion (the tilt) with a reduced-motion
  fallback; restraint comes from the showcase chrome, not the card.
- **120Hz is best-effort on iPhone**: a system frame governor caps app-driven animation; add
  `CADisableMinimumFrameDurationOnPhone = true`, expect "60Hz baseline, 120Hz best-effort",
  verify on a real ProMotion device with the Metal HUD. Escalating to Route B does **not** fix
  the iPhone governor.
- **Perf budget**: the shipping shader is `layerEffect` (offscreen pass), budget accordingly —
  not `colorEffect`-cheap. Cap CoreMotion at 60Hz. Stop motion + timeline when off-screen.
- **Premium upgrades (optional)**: author assets in Display P3, push the specular into EDR
  highlight headroom for extra "pop"; a subtle Core Haptics transient as the glare crosses
  center (gated by accessibility).

## 9. Phased plan

Effort: S ≈ <½ day, M ≈ ~1 day, L ≈ 2–3 days (one engineer).

| Phase | Scope | Size | Exit |
|---|---|---|---|
| 1. Skeleton | `MiDemo` + repository; flat entry card on home; demo list; dissolve route in `MiAppRootView`; L10n. No card. | M | Tap entry → list dissolves; VoiceOver + reduce-motion work; pure SwiftUI, build green |
| 2. Static card | Showcase + `MiHoloCardView` with original art, frame, caption, static `rotation3DEffect`, swipe deck (one active) | S–M | Handsome static single-card showcase, no motion/shader |
| 3. Procedural holo shader | `MiHoloFoil.metal` (`[[stitchable]]`, pre-composited image + procedural foil/sparkle); slider-driven tilt for Simulator testing | M–L | Slider produces convincing foil hue-shift + glare in Simulator |
| 4. Gyroscope | `MiMotionTiltProvider`; feed tilt → shader + 3D tilt; `TimelineView`; auto-sway / drag fallback | M | On a real device the card tilts and foil shifts with the phone; Simulator auto-orbits; reduce-motion static |
| 5. Polish | Anti-slop, P3/EDR, ProMotion check, masked sparkle, energy/thermal, accessibility, copy | M | Smooth on device, no battery spike, accessibility verified |

## 10. Risks / unknowns

1. Gyro is device-only — validate via Phase-3 sliders + auto-sway; the fallback must look
   intentional.
2. Foil "AI-slop" risk — solved by angle-dependent, surface-tinted procedural hue + masked
   sparkle + restrained glare. Make-or-break craft step.
3. First Metal/CoreMotion in the app — isolate under `Features/Demos`; correct motion lifecycle.
4. 120Hz not guaranteed on iPhone — verify on device; do not escalate to Route B for frame rate.
5. `layerEffect` offscreen cost — budget realistically; gate sparkle density under Low Power.
6. Route ceiling — true parallax/refraction would require Route B; the procedural look does not.

## 11. Sources

- [simeydotme/pokemon-cards-css (poke-holo)](https://github.com/simeydotme/pokemon-cards-css) · [live demo](https://poke-holo.simey.me/)
- [Apple — SwiftUI Shader / colorEffect / layerEffect / distortionEffect](https://developer.apple.com/documentation/swiftui/shader)
- [Hacking with Swift — Metal shaders via layer effects](https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-metal-shaders-to-swiftui-views-using-layer-effects)
- [WWDC 2026 session 322 — Compose advanced graphics effects with SwiftUI](https://developer.apple.com/videos/play/wwdc2026/322/) (one-extra-texture pattern)
- [Apple DTS forum — passing textures to SwiftUI shaders](https://developer.apple.com/forums/thread/763420)
- [Apple — CMMotionManager](https://developer.apple.com/documentation/coremotion/cmmotionmanager) · [NSHipster — CMDeviceMotion](https://nshipster.com/cmdevicemotion/)
- [Apple — rotation3DEffect](https://developer.apple.com/documentation/swiftui/view/rotation3deffect(_:axis:anchor:anchorz:perspective:))
- [twostraws/Inferno](https://github.com/twostraws/Inferno) · [krispuckett/SwiftUIShaders](https://github.com/krispuckett/SwiftUIShaders) — reference `[[stitchable]]` foil shaders

> Note: MSL/Swift snippets are illustrative (compile-shaped, not test-run). Gyroscope behavior
> and 120Hz must be verified on a physical device. Energy figures are order-of-magnitude, not
> Instruments-measured.
