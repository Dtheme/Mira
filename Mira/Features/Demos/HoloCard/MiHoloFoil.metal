//
//  MiHoloFoil.metal
//  Mira
//
//  Created on 2026/6/29.
//
//  Complete holographic trading-card foil for a SwiftUI `.colorEffect`, an
//  elegant one-pass substitute for the reference's stacked CSS blend layers
//  (glare / shine / sparkle / mask). Values tuned to the pokemon-cards-css
//  reference: discrete sunpillar palette, color-dodge shine, a 3-stop pointer
//  glare (overlay, 0.5 floor), procedural glitter, and a regular-holo foil mask
//  confined to the art window. Driven by one pointer vector (touch or gyro).
//
//  `style`: floor() selects the foil (0 rainbow rare / 1 cosmos / 2 regular holo),
//           fract() is intensity (0 => shader off).
//

#include <metal_stdlib>
using namespace metal;

namespace miholo {

// Discrete "sunpillar" rainbow (exact reference HSLs), cyclic 6-stop ramp.
inline half3 sunpillar(half t) {
    const half3 p0 = half3(1.00h, 0.46h, 0.45h); // hsl(2,100,73)
    const half3 p1 = half3(1.00h, 0.91h, 0.37h); // hsl(53,100,69)
    const half3 p2 = half3(0.66h, 1.00h, 0.37h); // hsl(93,100,69)
    const half3 p3 = half3(0.51h, 1.00h, 0.96h); // hsl(176,100,76)
    const half3 p4 = half3(0.46h, 0.55h, 1.00h); // hsl(228,100,74)
    const half3 p5 = half3(0.78h, 0.46h, 1.00h); // hsl(283,100,73)
    half x = fract(t) * 6.0h;
    int i = int(x);
    half f = fract(x);
    half3 a, b;
    if      (i == 0) { a = p0; b = p1; }
    else if (i == 1) { a = p1; b = p2; }
    else if (i == 2) { a = p2; b = p3; }
    else if (i == 3) { a = p3; b = p4; }
    else if (i == 4) { a = p4; b = p5; }
    else             { a = p5; b = p0; }
    return mix(a, b, f);
}

inline half3 colorDodge(half3 b, half3 s) {
    return select(min(half3(1.0h), b / max(1.0h - s, 1e-3h)), half3(1.0h), s >= 1.0h);
}
inline half3 screenBlend(half3 b, half3 s) { return 1.0h - (1.0h - b) * (1.0h - s); }
inline half3 overlayBlend(half3 b, half3 s) {
    return select(2.0h * b * s, 1.0h - 2.0h * (1.0h - b) * (1.0h - s), b >= 0.5h);
}

inline half3 contrastSat(half3 c, half contrast, half sat) {
    c = (c - 0.5h) * contrast + 0.5h;
    half lum = dot(c, half3(0.299h, 0.587h, 0.114h));
    return clamp(mix(half3(lum), c, sat), 0.0h, 1.0h);
}

inline half hash21(float2 p) {
    p = fract(p * float2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return half(fract(p.x * p.y));
}

inline half vnoise(float2 p) {
    float2 i = floor(p), f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    half a = hash21(i), b = hash21(i + float2(1, 0));
    half c = hash21(i + float2(0, 1)), d = hash21(i + float2(1, 1));
    return mix(mix(a, b, half(f.x)), mix(c, d, half(f.x)), half(f.y));
}

// Soft rounded-rect mask in uv space (1 inside, 0 outside).
inline half roundedRectMask(float2 uv, float2 mn, float2 mx, float2 r, float aa) {
    float2 ctr = (mn + mx) * 0.5;
    float2 hf = (mx - mn) * 0.5 - r;
    float2 q = abs(uv - ctr) - hf;
    float d = length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - r.x;
    return half(1.0 - smoothstep(-aa, aa, d));
}

// A single soft iridescent light band swept by the pointer; it disperses into
// rainbow across its width (like light through foil) rather than tiling a
// repeating pattern — reads as a real moving reflection, not a texture.
inline half3 iriBand(float2 uv, float2 ptr, float time, float angleDeg, float width, float sweep) {
    float a = angleDeg * 0.017453292;
    float2 dir = float2(cos(a), sin(a));
    float b = dot(uv - 0.5, dir) - (ptr.x * sweep + ptr.y * sweep * 0.7) - time * 0.02;
    half band = half(exp(-(b * b) / (width * width)));
    half3 hue = sunpillar(half(0.5 + b * 1.3));
    return hue * band;
}

} // namespace miholo

[[ stitchable ]]
half4 miHoloFoil(float2 position, half4 color,
                 float2 size, float ptrX, float ptrY,
                 float time, float style, float3 tint) {
    using namespace miholo;

    float intensity = fract(style);
    if (color.a < 0.01h || intensity < 0.001) { return color; }
    float foil = floor(style + 0.001);

    float2 uv  = position / size;            // 0..1
    float2 ptr = float2(ptrX, ptrY);         // -1..1 pointer
    float2 ptrUV = ptr * 0.5 + 0.5;          // 0..1
    float tiltMag = clamp(max(abs(ptr.x), abs(ptr.y)), 0.0, 1.0);

    half3 base = color.rgb / max(color.a, 0.001h);
    half baseLum = dot(base, half3(0.299h, 0.587h, 0.114h));

    // ---- moving "rake" light: broad soft bands swept by the pointer. This is the light
    //      that rakes across the foil; the holographic pattern only lights up where it
    //      passes, the way real foil catches the light as you tilt it. ----
    float a1 = -22.0 * 0.017453292;
    float2 d1 = float2(cos(a1), sin(a1));
    float b1 = dot(uv - 0.5, d1) - (ptr.x * 0.85 + ptr.y * 0.58) - time * 0.02;
    half rake1 = half(exp(-(b1 * b1) / (0.30 * 0.30)));
    float a2 = 34.0 * 0.017453292;
    float2 d2 = float2(cos(a2), sin(a2));
    float b2 = dot(uv - 0.5, d2) - (ptr.x * 0.5 + ptr.y * 0.36) - time * 0.017 + 0.15;
    half rake2 = half(exp(-(b2 * b2) / (0.18 * 0.18))) * 0.6h;

    // ---- holographic colour: an always-on broad iridescence so the foil never reads dead,
    //      bright rainbow dispersion along the moving rake bands, plus a fine linear holo
    //      grain revealed where the rake passes — the premium "foil texture". ----
    float ac = dot(uv - 0.5, float2(0.80, 1.0));
    half3 ambIri = sunpillar(half(ac * 1.6 + ptr.x * 0.62 + ptr.y * 0.46 + 0.2));
    half3 sweep = sunpillar(half(0.5 + b1 * 1.1)) * rake1
                + sunpillar(half(0.35 + b2 * 1.3)) * rake2;
    float gc = dot(uv - 0.5, float2(0.93, 0.37));
    half lines = half(0.5 + 0.5 * sin(gc * 52.0 + (ptr.x * 3.4 + ptr.y * 2.2) + time * 0.12));
    lines = lines * lines;                                   // fine micro-lines
    half3 grain = sunpillar(half(gc * 2.6 + ptr.x * 0.6 + time * 0.01)) * lines;
    half reveal = clamp(0.05h + 0.95h * (rake1 + rake2), 0.0h, 1.2h);
    // a whisper of always-on iridescence, restrained rake bands as the moving accents,
    // and a fine grain that only glints where the light actually rakes across — felt
    // as material, never a wash over the art
    half3 sheen = ambIri * 0.10h + sweep * 0.30h + grain * reveal * 0.15h;

    // glitter sparkle: small round star-points at hashed positions, jittered by the
    // pointer so they relocate as you move, and brighter where the rake light passes.
    float2 sc  = (uv + ptr * 0.02) * (size / 8.0);
    float2 cid = floor(sc);
    float2 cf  = fract(sc);
    half tw = hash21(cid);
    float2 sp = float2(float(hash21(cid + 0.13)), float(hash21(cid + 0.37)));
    half sd = half(distance(cf, sp));
    half starThresh = (foil >= 0.5 && foil < 1.5) ? 0.70h : 0.84h;
    half spark = half(smoothstep(0.16h, 0.0h, sd))
               * half(step(starThresh, tw))
               * (0.55h + 0.45h * half(sin(time * 3.0 + float(tw) * 40.0)))
               * (0.55h + 0.7h * (rake1 + rake2));

    // per-foil character
    half foilAmt;
    half sparkAmt;
    if (foil < 0.5) {                         // VIBRANT: saturated iridescent rainbow foil
        sheen = contrastSat(sheen, 1.5h, 0.95h);
        foilAmt = 0.26h;
        sparkAmt = 0.4h;
    } else if (foil < 1.5) {                  // COSMOS: sweep + nebula + stars
        half neb = 0.65h * vnoise(uv * 4.0 + ptr * 0.25)
                 + 0.35h * vnoise(uv * 9.0 - ptr * 0.4 + 5.0);
        neb = neb * neb;
        half3 space = mix(half3(0.015h, 0.02h, 0.06h), half3(0.14h, 0.06h, 0.26h), neb);
        sheen = contrastSat(sheen, 1.4h, 0.88h) * (0.6h + 0.7h * neb) + space * 0.45h;
        foilAmt = 0.3h;
        sparkAmt = 0.7h;
    } else {                                  // SUBTLE: gentle, cool reflection
        sheen = contrastSat(sheen, 1.28h, 0.78h);
        foilAmt = 0.2h;
        sparkAmt = 0.26h;
    }

    // bias the iridescence toward the scene's ambient light (cold snow / warm
    // dawn / teal aurora / violet tide) so the reflection reads scene-appropriate.
    half3 tintH = clamp(half3(tint), 0.0h, 1.0h);
    half sLum = dot(sheen, half3(0.299h, 0.587h, 0.114h));
    sheen = mix(sheen, tintH * sLum * 1.7h, 0.24h);

    // brightness stays strong across the whole tilt range and the sweep sings a
    // touch brighter as the card tilts — no global dimming toward the edges.
    foilAmt *= half(intensity) * (1.0h + 0.3h * half(tiltMag));
    // let the reflection sing on the darks yet keep light areas alive too.
    foilAmt *= (0.68h + 0.4h * (1.0h - baseLum));

    // ---- pointer glare: a tight bright hotspot, floored at 0.5 so the overlay
    //      only ever brightens the art (never darkens it — that floor was the
    //      source of the card sinking dark as the tilt moved). ----
    float gdist = distance(uv, ptrUV);
    half glare = 0.5h + 0.27h * (1.0h - half(smoothstep(0.04, 0.6, gdist)));

    // ---- broad directional light / shade keyed to tilt: a clearly lit side and a
    //      gently shaded away-side, tinted to the surface (never pure black), that
    //      slide across the face as the card turns — the crisp premium 光影. ----
    half2 pdir = half2(ptr);
    half pmag = length(pdir);
    half2 pn = (pmag > 0.001h) ? pdir / pmag : half2(0.0h, -1.0h);
    half grad = dot(half2(uv) - 0.5h, pn) * 2.0h;        // +1 toward tilt, -1 away
    half tiltLit = smoothstep(0.03h, 0.5h, pmag);         // engage once tilting
    half lit   = clamp(grad, 0.0h, 1.0h) * tiltLit;
    half shade = clamp(-grad, 0.0h, 1.0h) * tiltLit;
    half3 litCol   = mix(half3(1.0h), tintH, 0.32h);
    half3 shadeCol = mix(half3(1.0h), tintH * 0.55h, 0.5h);

    // ---- compose: base, away-side shade, lit-side bloom, sheen, glitter, glare ----
    half3 col = base;
    col *= (half3(1.0h) - (half3(1.0h) - shadeCol) * (shade * 0.18h));
    col = screenBlend(col, litCol * (lit * 0.16h * half(intensity)));
    col = screenBlend(col, sheen * foilAmt);
    col = screenBlend(col, half3(spark) * sparkAmt * half(intensity));
    col = overlayBlend(col, half3(glare));

    half3 outc = clamp(col, 0.0h, 1.0h);
    return half4(outc * color.a, color.a);
}
