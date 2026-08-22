//
//  MiHoloEgg.metal
//  Mira
//
//  Created on 2026/8/20.
//
//  Metal passes for the opal-egg demo. The egg itself is a SwiftUI stack of
//  real gaussian-blurred layers (see MiHoloEggView); Metal handles what it is
//  best at here:
//
//  `miSparkleField` — the flowing sparkle backdrop: a slow aurora luminance
//  drift plus four parallax layers of star-dust with slow lifecycles, all
//  hash-grid GPU particles (no CPU emitter).
//
//  `miEggGrain` — a fine static matte grain multiplied over the composed egg
//  (the frosted-latex micro-texture).
//

#include <metal_stdlib>
using namespace metal;

namespace miegg {

inline float hash21(float2 p) {
    p = fract(p * float2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

inline float2 hash22(float2 p) {
    float n = hash21(p);
    return float2(n, hash21(p + n + 17.17));
}

inline float vnoise(float2 p) {
    float2 i = floor(p), f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    float a = hash21(i), b = hash21(i + float2(1, 0));
    float c = hash21(i + float2(0, 1)), d = hash21(i + float2(1, 1));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

inline float fbm(float2 p) {
    float v = 0.0, a = 0.5;
    for (int i = 0; i < 3; i++) {
        v += a * vnoise(p);
        p = p * 2.03 + 19.7;
        a *= 0.5;
    }
    return v;
}

inline half3 screenBlend(half3 b, half3 s) { return 1.0h - (1.0h - b) * (1.0h - s); }

// One parallax layer of star-dust with a slow lifecycle: each mote fades in,
// drifts, gently swells and shrinks, then dissolves and is reborn at a fresh
// spot in its cell.
inline half3 starLayer(float2 position, float time,
                       float cellPx, float speed, float keep, float radius, float gain) {
    // screen motion is along -dir, so this drifts the dust up with a slight lean
    float2 dir = float2(-0.22, 1.0) * 0.9805;
    float2 sc = (position + dir * (time * speed)) / cellPx;
    float2 cid = floor(sc), cf = fract(sc);
    float h = hash21(cid);
    if (h < keep) { return half3(0.0h); }

    // slow lifecycle (8-17s), hashed phase; slow appear -> hold -> slow annihilate
    float lifeSpd = 0.06 + 0.06 * h;
    float cyc = floor(time * lifeSpd + h * 7.31);
    float life = fract(time * lifeSpd + h * 7.31);
    float env = smoothstep(0.0, 0.30, life) * (1.0 - smoothstep(0.62, 1.0, life));

    float2 sp = hash22(cid + 0.17 + cyc * 0.61) * 0.72 + 0.14;
    float d = distance(cf, sp);

    // the mote swells gently as it lives and breathes a little on top
    float rad = radius * (0.70 + 0.45 * env + 0.12 * sin(time * (0.5 + h) + h * 20.0));
    float shimmer = 0.80 + 0.20 * sin(time * (0.6 + h * 2.0) + h * 60.0);
    float g = smoothstep(rad, rad * 0.15, d) * env * shimmer * gain;
    float pick = hash21(cid + 7.7);
    half3 c = half3(0.99h, 0.95h, 0.90h);              // warm white
    if (pick > 0.62) { c = half3(0.99h, 0.72h, 0.86h); } // pink
    if (pick > 0.86) { c = half3(0.76h, 0.66h, 0.99h); } // lavender
    return c * half(g);
}

} // namespace miegg

[[ stitchable ]]
half4 miSparkleField(float2 position, half4 color,
                     float2 size, float time, float strength) {
    using namespace miegg;

    float s = clamp(strength, 0.0, 1.0);
    if (color.a < 0.01h || s < 0.001) { return color; }

    float2 uv = position / size;
    half3 base = color.rgb / max(color.a, 0.001h);

    // slow aurora luminance drift, tinted to the stage (never a gray wash)
    float nb = fbm(uv * float2(2.2, 3.0) + float2(time * 0.012, time * 0.02));
    base = screenBlend(base, half3(0.78h, 0.45h, 0.98h)
                             * half(smoothstep(0.52, 0.95, nb) * 0.08 * s));

    // four parallax layers of star-dust, fine dense grain first (far -> near);
    // pinprick specks dominate, a few soft motes float closest
    half3 stars = half3(0.0h);
    stars += starLayer(position, time,  7.0, 0.8, 0.55, 0.085, 0.60);
    stars += starLayer(position, time, 12.0, 1.4, 0.72, 0.10,  0.75);
    stars += starLayer(position, time, 20.0, 2.2, 0.80, 0.11,  0.85);
    stars += starLayer(position, time, 54.0, 0.6, 0.90, 0.16,  0.65);
    base = screenBlend(base, clamp(stars, 0.0h, 1.0h) * half(s));

    half3 outc = clamp(base, 0.0h, 1.0h);
    return half4(outc * color.a, color.a);
}

[[ stitchable ]]
half4 miEggGrain(float2 position, half4 color, float amount) {
    using namespace miegg;

    if (color.a < 0.01h || amount < 0.0005) { return color; }
    half3 base = color.rgb / max(color.a, 0.001h);

    // two fine octaves, weighted toward the midtones: frosted materials show
    // their grain in the body of the tone, never as dirt on the highlights
    float g1 = vnoise(position * 1.7);
    float g2 = vnoise(position * 3.4 + 13.7);
    float g = ((g1 * 0.65 + g2 * 0.35) - 0.5) * amount;
    float lum = dot(float3(base), float3(0.299, 0.587, 0.114));
    g *= 4.0 * lum * (1.0 - lum) * 0.9 + 0.1;

    base = clamp(base * half(1.0 + g), 0.0h, 1.0h);
    return half4(base * color.a, color.a);
}
