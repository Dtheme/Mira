//
//  MiArtCardScene.swift
//  Mira
//
//  Created on 2026/6/30.
//
//  Fully procedural atmospheric art for a holographic "art rare" card, drawn in a
//  single Canvas. The scene is STATIC (no time / pointer inputs) so SwiftUI caches
//  the raster once; the holo foil shader and the 3D tilt provide all the motion.
//
//  Lighting is coherent with the orb (sun / moon): a warm scatter halo, crepuscular
//  "god rays" at dawn, and a directional rim light along the ridge crests that
//  brightens on the side facing the light. No external image assets, no IP.
//

import SwiftUI

struct MiArtScene: Hashable {
    enum Kind: Int, Hashable { case aurora, clouds, tide, snow, waterfall }
    let kind: Kind
    let skyTop: UInt
    let skyMid: UInt
    let skyBottom: UInt
    let orb: UInt        // moon / sun (also the light colour)
    let aurora: UInt     // aurora ribbon / cloud highlight
    let ridge: UInt      // front ridge silhouette (darkest)
    let star: UInt
}

struct MiArtSceneView: View {
    let scene: MiArtScene

    var body: some View {
        Canvas(rendersAsynchronously: false) { context, size in
            drawSky(context, size)
            if scene.kind == .snow {
                drawSnowScene(context, size)
                drawVignette(context, size)
                return
            }
            if scene.kind == .waterfall {
                drawWaterfallScene(context, size)
                drawVignette(context, size)
                return
            }
            if scene.kind != .clouds { drawStars(context, size) }
            if scene.kind == .clouds { drawSunScatter(context, size) }
            switch scene.kind {
            case .aurora: drawAurora(context, size)
            case .clouds: drawClouds(context, size)
            case .tide:   drawWispClouds(context, size)
            case .snow, .waterfall: break
            }
            if scene.kind == .clouds { drawGodRays(context, size) }
            drawOrb(context, size)
            if scene.kind == .tide {
                drawRidges(context, size)   // distant hills sit on the horizon
                drawWater(context, size)    // foreground moonlit water covers their feet
            } else {
                drawRidges(context, size)
            }
            drawAccent(context, size)
            drawVignette(context, size)
        }
        .drawingGroup()   // rasterize the scene once; the foil shader runs over it
    }

    // MARK: helpers

    private func rnd(_ n: Int) -> CGFloat {
        let x = sin(Double(n) * 12.9898) * 43758.5453
        return CGFloat(x - floor(x))
    }

    private func col(_ hex: UInt, _ a: Double = 1) -> Color { Color(hex: hex, alpha: a) }

    /// Light source (sun / moon) centre and radius.
    private func orbInfo(_ size: CGSize) -> (center: CGPoint, radius: CGFloat) {
        switch scene.kind {
        case .aurora: return (CGPoint(x: size.width * 0.72, y: size.height * 0.2),  size.width * 0.13)
        case .clouds: return (CGPoint(x: size.width * 0.3,  y: size.height * 0.27), size.width * 0.15)
        case .tide:   return (CGPoint(x: size.width * 0.5,  y: size.height * 0.24), size.width * 0.16)
        case .snow:   return (CGPoint(x: size.width * 0.64, y: size.height * 0.16), size.width * 0.1)
        case .waterfall: return (CGPoint(x: size.width * 0.70, y: size.height * 0.12), size.width * 0.13)
        }
    }

    // MARK: sky

    private func drawSky(_ ctx: GraphicsContext, _ size: CGSize) {
        let rect = CGRect(origin: .zero, size: size)
        ctx.fill(
            Path(rect),
            with: .linearGradient(
                Gradient(colors: [col(scene.skyTop), col(scene.skyMid), col(scene.skyBottom)]),
                startPoint: .zero, endPoint: CGPoint(x: 0, y: size.height)
            )
        )
    }

    private func drawStars(_ ctx: GraphicsContext, _ size: CGSize) {
        for i in 0..<90 {
            let x = rnd(i * 2 + 1) * size.width
            let y = rnd(i * 2 + 7) * size.height * 0.66
            let b = 0.25 + 0.75 * rnd(i * 3 + 4)
            let r = 0.5 + 1.6 * rnd(i * 5 + 9)
            let dot = Path(ellipseIn: CGRect(x: x, y: y, width: r, height: r))
            ctx.fill(dot, with: .color(col(scene.star, b)))
        }
    }

    // MARK: dawn light — scatter + god rays

    private func drawSunScatter(_ ctx: GraphicsContext, _ size: CGSize) {
        let (c, _) = orbInfo(size)
        var g = ctx
        g.blendMode = .screen
        let r = size.width * 0.85
        g.fill(
            Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2)),
            with: .radialGradient(
                Gradient(colors: [col(scene.orb, 0.4), col(scene.orb, 0.12), col(scene.orb, 0)]),
                center: c, startRadius: 0, endRadius: r)
        )
    }

    private func drawGodRays(_ ctx: GraphicsContext, _ size: CGSize) {
        let (c, _) = orbInfo(size)
        var g = ctx
        g.blendMode = .screen
        g.drawLayer { layer in
            layer.addFilter(.blur(radius: 7))
            let rays = 11
            let len = size.height * 1.3
            for i in 0..<rays {
                let t = CGFloat(i) / CGFloat(rays - 1)
                let ang = CGFloat.pi * (0.1 + 0.78 * t)            // fan downward into the scene
                let dx = cos(ang), dy = sin(ang)
                let pX = -dy, pY = dx                              // perpendicular
                let nearW = size.width * (0.006 + 0.012 * rnd(i * 3 + 1))
                let farW = size.width * (0.03 + 0.04 * rnd(i * 5 + 2))
                let far = CGPoint(x: c.x + dx * len, y: c.y + dy * len)
                var p = Path()
                p.move(to: CGPoint(x: c.x + pX * nearW, y: c.y + pY * nearW))
                p.addLine(to: CGPoint(x: c.x - pX * nearW, y: c.y - pY * nearW))
                p.addLine(to: CGPoint(x: far.x - pX * farW, y: far.y - pY * farW))
                p.addLine(to: CGPoint(x: far.x + pX * farW, y: far.y + pY * farW))
                p.closeSubpath()
                let op = 0.05 + 0.06 * rnd(i * 7 + 3)
                layer.fill(p, with: .linearGradient(
                    Gradient(colors: [col(scene.orb, op * 1.7), col(scene.orb, 0)]),
                    startPoint: c, endPoint: far))
            }
        }
    }

    // MARK: skies — aurora / clouds

    private func drawAurora(_ ctx: GraphicsContext, _ size: CGSize) {
        let W = size.width, H = size.height
        let green = scene.aurora            // luminous aurora green
        let teal: UInt = 0x55D9D2
        let violet: UInt = 0x8F7BE8
        let pink: UInt = 0xDD8FBE

        // a faint violet-teal veil high in the sky (the diffuse upper glow)
        ctx.drawLayer { l in
            l.addFilter(.blur(radius: 26))
            var g = l; g.blendMode = .screen
            g.fill(Path(ellipseIn: CGRect(x: -W * 0.08, y: H * 0.0, width: W * 0.95, height: H * 0.34)),
                   with: .linearGradient(
                    Gradient(colors: [col(violet, 0.18), col(teal, 0.06), col(violet, 0)]),
                    startPoint: CGPoint(x: W * 0.3, y: 0), endPoint: CGPoint(x: W * 0.38, y: H * 0.34)))
        }

        // one sweeping curtain: a waved base line crossing the sky, dense rays rising
        // from it and fading upward — brightest along the lower edge, the way a real
        // aurora band hangs; a faint pink fringe hugs the underside
        func curtain(baseY: CGFloat, slope: CGFloat, wave: CGFloat, phase: CGFloat,
                     tMin: CGFloat, tMax: CGFloat, rayH: CGFloat, tilt: CGFloat,
                     strength: Double, seed: Int) {
            func basePt(_ t: CGFloat) -> CGPoint {
                let x = W * (-0.06 + 1.12 * t)
                let y = H * baseY - H * slope * t
                    + sin(t * 5.2 + phase) * H * wave
                    + sin(t * 11.0 + phase * 1.7) * H * wave * 0.45
                return CGPoint(x: x, y: y)
            }
            // the rays (drawn first, the edge glow sits over their feet)
            ctx.drawLayer { l in
                l.addFilter(.blur(radius: 2.2))
                var g = l; g.blendMode = .screen
                let n = 130
                for i in 0..<n {
                    let t0 = CGFloat(i) / CGFloat(n - 1)
                    if rnd(i * 7 + seed) < 0.12 { continue }        // streaky gaps
                    let t = tMin + (tMax - tMin) * t0
                    let p = basePt(t)
                    let env = pow(sin(t0 * .pi), 0.8)               // curtain ends dissolve
                    let hgt = rayH * H * (0.45 + 0.55 * rnd(i * 3 + seed + 1)) * env
                    if hgt < H * 0.01 { continue }
                    let lean = (t - 0.5) * tilt * W * 0.35          // rays fan slightly
                    let top = CGPoint(x: p.x + lean, y: p.y - hgt)
                    var ray = Path()
                    ray.move(to: p); ray.addLine(to: top)
                    let op = strength * (0.34 + 0.5 * Double(rnd(i * 5 + seed + 2))) * Double(env)
                    g.stroke(ray, with: .linearGradient(
                        Gradient(stops: [
                            .init(color: col(0xC8FFE3, op * 0.9), location: 0),
                            .init(color: col(green, op * 0.85), location: 0.16),
                            .init(color: col(teal, op * 0.5), location: 0.5),
                            .init(color: col(violet, op * 0.26), location: 0.8),
                            .init(color: col(violet, 0), location: 1)]),
                        startPoint: p, endPoint: top),
                        style: StrokeStyle(lineWidth: W * (0.008 + 0.007 * rnd(i * 9 + seed + 3)),
                                           lineCap: .round))
                }
            }
            // luminous lower edge + pink fringe just beneath it
            var edge = Path(), fringe = Path()
            let steps = 44
            for s in 0...steps {
                let ts = CGFloat(s) / CGFloat(steps)
                let t = tMin + (tMax - tMin) * ts
                let p = basePt(t)
                let f = CGPoint(x: p.x, y: p.y + H * 0.009)
                if s == 0 { edge.move(to: p); fringe.move(to: f) }
                else { edge.addLine(to: p); fringe.addLine(to: f) }
            }
            // a wide soft under-glow bleeding below the edge (atmospheric scatter), so the
            // band never ends on a hard line
            ctx.drawLayer { l in
                l.addFilter(.blur(radius: 11))
                var g = l; g.blendMode = .screen
                g.stroke(edge, with: .color(col(green, 0.2 * strength)),
                         style: StrokeStyle(lineWidth: 16, lineCap: .round, lineJoin: .round))
            }
            ctx.drawLayer { l in
                l.addFilter(.blur(radius: 4.5))
                var g = l; g.blendMode = .screen
                g.stroke(edge, with: .color(col(0x9CF4C8, 0.75 * strength)),
                         style: StrokeStyle(lineWidth: 5.5, lineCap: .round, lineJoin: .round))
            }
            ctx.drawLayer { l in
                l.addFilter(.blur(radius: 4))
                var g = l; g.blendMode = .screen
                g.stroke(fringe, with: .color(col(pink, 0.28 * strength)),
                         style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round))
            }
        }

        // one hero band sweeping up toward the moon but dissolving before it — the moon
        // keeps clean sky, and a single curtain reads calmer than parallel echoes
        curtain(baseY: 0.44, slope: 0.16, wave: 0.045, phase: 0.7,
                tMin: 0, tMax: 0.78, rayH: 0.28, tilt: 0.28, strength: 0.6, seed: 11)
    }

    private func drawClouds(_ ctx: GraphicsContext, _ size: CGSize) {
        let W = size.width, H = size.height
        // layered dawn cloud banks — each a cluster of overlapping puffs, lit warm on the
        // crown by the low sun and cool-shadowed beneath; nearer banks larger and softer
        for band in 0..<4 {
            let by = H * (0.13 + 0.11 * CGFloat(band)) + (rnd(band * 7 + 1) - 0.5) * H * 0.02
            let puffs = 5 + band
            ctx.drawLayer { l in
                l.addFilter(.blur(radius: 9 - CGFloat(band) * 1.4))
                for i in 0..<puffs {
                    let t = CGFloat(i) / CGFloat(puffs - 1)
                    let x = -W * 0.12 + t * W * 1.24 + (rnd(i * 5 + band * 11 + 2) - 0.5) * W * 0.1
                    let w = W * (0.13 + 0.13 * rnd(i * 7 + band * 3 + 1))
                    let h = H * (0.04 + 0.03 * rnd(i * 9 + band + 2)) * (1.0 + 0.45 * CGFloat(band))
                    let y = by + (rnd(i * 3 + band * 5 + 4) - 0.5) * H * 0.025
                    let op = 0.64 + 0.32 * rnd(i * 13 + band + 3)
                    // bright warm crown over a cool dusk-mauve shadow — the contrast is what
                    // finally makes the clouds read against the luminous dawn sky
                    l.fill(Path(ellipseIn: CGRect(x: x - w, y: y - h / 2, width: w * 2, height: h)),
                           with: .linearGradient(
                            Gradient(colors: [col(0xFFF4E6, 0.82 * op), col(scene.orb, 0.6 * op),
                                              col(0xE7B6BE, 0.5 * op), col(0xAE99C6, 0.6 * op)]),
                            startPoint: CGPoint(x: x, y: y - h / 2), endPoint: CGPoint(x: x, y: y + h / 2)))
                }
            }
        }
    }

    private func drawWispClouds(_ ctx: GraphicsContext, _ size: CGSize) {
        ctx.drawLayer { layer in
            layer.addFilter(.blur(radius: 7))
            for i in 0..<4 {
                let y = size.height * (0.14 + 0.16 * CGFloat(i))
                let w = size.width * (0.6 + 0.3 * rnd(i * 3 + 2))
                let x = rnd(i * 7 + 4) * size.width * 0.4
                let e = Path(ellipseIn: CGRect(x: x, y: y, width: w, height: size.height * 0.02))
                layer.fill(e, with: .color(col(scene.aurora, 0.3)))
            }
        }
    }

    // MARK: orb (moon / sun)

    private func drawOrb(_ ctx: GraphicsContext, _ size: CGSize) {
        let (c, r) = orbInfo(size)
        // a large, soft, low halo — luminous but not a harsh spotlight
        ctx.drawLayer { layer in
            layer.addFilter(.blur(radius: r * 1.1))
            let halo = Path(ellipseIn: CGRect(x: c.x - r * 2.0, y: c.y - r * 2.0, width: r * 4.0, height: r * 4.0))
            layer.fill(halo, with: .radialGradient(
                Gradient(colors: [col(scene.orb, 0.4), col(scene.orb, 0.0)]),
                center: c, startRadius: 0, endRadius: r * 2.0))
        }
        // soft luminous disc (no pure-white core)
        let disc = Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2))
        ctx.fill(disc, with: .radialGradient(
            Gradient(colors: [col(scene.orb, 1.0), col(scene.orb, 0.9), col(scene.orb, 0.66)]),
            center: CGPoint(x: c.x - r * 0.22, y: c.y - r * 0.22), startRadius: 0, endRadius: r * 1.18))
    }

    // MARK: water (tide)

    private func drawWater(_ ctx: GraphicsContext, _ size: CGSize) {
        let W = size.width, H = size.height
        let (oc, _) = orbInfo(size)
        let top = H * 0.6
        let rect = CGRect(x: 0, y: top, width: W, height: H - top)
        // moonlit water: a cool sheen at the waterline deepening toward the viewer
        ctx.fill(Path(rect), with: .linearGradient(
            Gradient(colors: [col(scene.skyMid), col(scene.skyBottom), col(0x2C1B46)]),
            startPoint: CGPoint(x: 0, y: top), endPoint: CGPoint(x: 0, y: H)))
        // a broad soft pool of moonlight on the water below the moon
        ctx.drawLayer { l in
            l.addFilter(.blur(radius: 18))
            var g = l; g.blendMode = .screen
            g.fill(Path(ellipseIn: CGRect(x: oc.x - W * 0.5, y: top - H * 0.02, width: W, height: H * 0.18)),
                   with: .radialGradient(
                    Gradient(colors: [col(scene.orb, 0.34), col(scene.orb, 0)]),
                    center: CGPoint(x: oc.x, y: top + H * 0.05), startRadius: 0, endRadius: W * 0.5))
        }
        // the moon's reflection column — broken glints at irregular intervals that widen and
        // dim toward the viewer, with occasional gaps, so it shimmers rather than laddering
        ctx.drawLayer { l in
            l.addFilter(.blur(radius: 1.5))
            var g = l; g.blendMode = .screen
            var yy = top + (H - top) * 0.02
            for i in 0..<26 {
                yy += (H - top) * (0.02 + 0.06 * rnd(i * 11 + 7))
                if yy > H { break }
                if rnd(i * 13 + 3) < 0.22 { continue }              // occasional break in the column
                let t = (yy - top) / (H - top)
                let w = W * (0.012 + 0.11 * t) * (0.5 + 0.9 * rnd(i * 5 + 3))
                let op = (0.58 - 0.36 * Double(t)) * (0.4 + 0.6 * Double(rnd(i * 7 + 1)))
                let cx = oc.x + (rnd(i * 3 + 2) - 0.5) * W * 0.05
                let hgt = 1.8 + 2.0 * rnd(i * 9 + 2)
                g.fill(Path(roundedRect: CGRect(x: cx - w, y: yy, width: w * 2, height: hgt), cornerRadius: hgt * 0.4),
                       with: .color(col(scene.orb, op)))
            }
        }
        // long tide ripple strokes catching a little light
        ctx.drawLayer { l in
            l.addFilter(.blur(radius: 0.6))
            for i in 0..<7 {
                let y = top + H * 0.02 + CGFloat(i) / 7 * (H - top) * 0.92
                let bx = W * (0.05 + 0.5 * rnd(i * 3 + 1))
                let len = W * (0.2 + 0.3 * rnd(i * 5 + 2))
                var p = Path()
                p.move(to: CGPoint(x: bx, y: y))
                p.addQuadCurve(to: CGPoint(x: bx + len, y: y),
                               control: CGPoint(x: bx + len * 0.5, y: y + (rnd(i * 7 + 3) - 0.5) * 4))
                l.stroke(p, with: .color(col(scene.orb, 0.1 + 0.06 * rnd(i * 9 + 4))),
                         style: StrokeStyle(lineWidth: 0.8, lineCap: .round))
            }
        }
    }

    // MARK: snow scene (lone fisherman on the cold river — an ink-and-snow card)

    private func drawSnowScene(_ ctx: GraphicsContext, _ size: CGSize) {
        let W = size.width, H = size.height
        let (oc, orad) = orbInfo(size)

        // faint cold sun behind the haze
        ctx.drawLayer { l in
            l.addFilter(.blur(radius: orad))
            let g = Path(ellipseIn: CGRect(x: oc.x - orad * 2, y: oc.y - orad * 2, width: orad * 4, height: orad * 4))
            l.fill(g, with: .radialGradient(
                Gradient(colors: [col(scene.orb, 0.7), col(scene.orb, 0)]),
                center: oc, startRadius: 0, endRadius: orad * 2))
        }
        ctx.fill(
            Path(ellipseIn: CGRect(x: oc.x - orad * 0.6, y: oc.y - orad * 0.6, width: orad * 1.2, height: orad * 1.2)),
            with: .color(col(0xFCFDFF, 0.85)))

        // far snowfall behind the mountains (tiny, dim)
        snowLayer(ctx, size, seed: 101, count: 70, minR: 0.5, maxR: 1.1, opacity: 0.35)

        // distant mountains — three ink-wash layers, hazy to near
        snowMountain(ctx, size, baseY: H * 0.37, amp: 0.04, seed: 2.0, fill: 0xEDF2F6, cap: 0.0, rim: 0.16)
        snowMountain(ctx, size, baseY: H * 0.47, amp: 0.06, seed: 5.3, fill: 0xE1EAF1, cap: 0.45, rim: 0.22)
        snowMountain(ctx, size, baseY: H * 0.575, amp: 0.08, seed: 8.7, fill: 0xD2DEE8, cap: 0.7, rim: 0.3)

        // low mist veiling the bases
        ctx.drawLayer { l in
            l.addFilter(.blur(radius: 12))
            l.fill(Path(CGRect(x: -10, y: H * 0.52, width: W + 20, height: H * 0.12)),
                   with: .color(col(0xF1F5F8, 0.72)))
        }

        // the cold river
        let riverTop = H * 0.64
        ctx.fill(Path(CGRect(x: 0, y: riverTop, width: W, height: H - riverTop)),
                 with: .linearGradient(
                    Gradient(colors: [col(0xCBD8E4), col(0xB9C9D9), col(0xC8D5E1)]),
                    startPoint: CGPoint(x: 0, y: riverTop), endPoint: CGPoint(x: 0, y: H)))
        riverReflection(ctx, size, riverTop: riverTop, orbX: oc.x)

        // foreground bank, bare tree, reeds (lower-left anchor)
        foregroundBank(ctx, size, riverTop: riverTop)

        // the lone boat & fisherman, with a faint reflection
        fisher(ctx, x: W * 0.46, y: riverTop + (H - riverTop) * 0.24, scale: W * 0.17)

        // mid & near snowfall (depth)
        snowLayer(ctx, size, seed: 211, count: 55, minR: 1.0, maxR: 2.0, opacity: 0.7)
        nearSnow(ctx, size)
    }

    private func snowMountain(_ ctx: GraphicsContext, _ size: CGSize, baseY: CGFloat, amp: CGFloat, seed: CGFloat, fill: UInt, cap: Double, rim: Double) {
        let W = size.width, H = size.height
        var crest: [CGPoint] = []
        let steps = 24
        for s in 0...steps {
            let t = CGFloat(s) / CGFloat(steps)
            let x = t * W
            let y = baseY
                + sin(t * 3.0 + seed) * H * amp
                + sin(t * 7.0 + seed * 1.7) * H * amp * 0.45
                + sin(t * 17.0 + seed * 2.3) * H * amp * 0.22   // fine jagged ink edge
            crest.append(CGPoint(x: x, y: y))
        }
        var p = Path()
        p.move(to: CGPoint(x: 0, y: H))
        p.addLine(to: crest[0])
        for pt in crest.dropFirst() { p.addLine(to: pt) }
        p.addLine(to: CGPoint(x: W, y: H))
        p.closeSubpath()
        ctx.fill(p, with: .color(col(fill)))
        ctx.fill(p, with: .linearGradient(
            Gradient(colors: [col(scene.aurora, 0), col(scene.aurora, 0.2)]),
            startPoint: CGPoint(x: 0, y: baseY), endPoint: CGPoint(x: 0, y: baseY + H * 0.2)))
        var rimP = Path()
        rimP.move(to: crest[0])
        for pt in crest.dropFirst() { rimP.addLine(to: pt) }
        if cap > 0 {   // soft snow-cap glow along the ridge (blurred, not a hard line)
            ctx.drawLayer { l in
                l.addFilter(.blur(radius: 2.5))
                l.stroke(rimP, with: .color(col(0xFFFFFF, cap)),
                         style: StrokeStyle(lineWidth: 4.5, lineCap: .round, lineJoin: .round))
            }
        }
        // a faint, softly blurred edge instead of a crisp ink outline
        ctx.drawLayer { l in
            l.addFilter(.blur(radius: 1.2))
            l.stroke(rimP, with: .color(col(scene.ridge, rim * 0.55)),
                     style: StrokeStyle(lineWidth: 1.4, lineCap: .round, lineJoin: .round))
        }
    }

    private func reeds(_ ctx: GraphicsContext, _ size: CGSize, x: CGFloat, baseY: CGFloat, n: Int) {
        for i in 0..<n {
            let rx = x + (rnd(i * 5 + 1) - 0.5) * size.width * 0.14
            let hh = size.height * (0.06 + 0.055 * rnd(i * 7 + 3))
            let bend = (rnd(i * 9 + 2) - 0.5) * size.width * 0.05
            var p = Path()
            p.move(to: CGPoint(x: rx, y: baseY))
            p.addQuadCurve(to: CGPoint(x: rx + bend, y: baseY - hh),
                           control: CGPoint(x: rx + bend * 0.4, y: baseY - hh * 0.6))
            ctx.stroke(p, with: .color(col(scene.ridge, 0.7)), style: StrokeStyle(lineWidth: 1.4, lineCap: .round))
            let tip = CGPoint(x: rx + bend, y: baseY - hh)
            ctx.fill(Path(ellipseIn: CGRect(x: tip.x - 1.5, y: tip.y - 3, width: 3, height: 5)),
                     with: .color(col(scene.ridge, 0.6)))
        }
    }

    private func fisher(_ ctx: GraphicsContext, x: CGFloat, y: CGFloat, scale s: CGFloat) {
        // a faint, flipped reflection on the water (drawn first, under the boat)
        var rc = ctx
        rc.opacity = 0.16
        rc.translateBy(x: 0, y: y * 1.5)
        rc.scaleBy(x: 1, y: -0.5)
        fisherSilhouette(rc, x: x, y: y, s: s, withTackle: false)

        fisherSilhouette(ctx, x: x, y: y, s: s, withTackle: true)

        // water contact ripples spreading from the hull
        for k in 0..<3 {
            let rw = s * (0.55 + 0.45 * CGFloat(k))
            let e = Path(ellipseIn: CGRect(x: x - rw, y: y + s * 0.1 + CGFloat(k) * 3.5,
                                           width: rw * 2, height: rw * 0.42))
            ctx.stroke(e, with: .color(col(0xFFFFFF, 0.2 - 0.055 * Double(k))),
                       style: StrokeStyle(lineWidth: 0.8))
        }
        // a small ripple where the line meets the water
        let lx = x + s * 0.82, ly = y + s * 0.34
        for k in 0..<2 {
            let rw = s * (0.1 + 0.09 * CGFloat(k))
            ctx.stroke(Path(ellipseIn: CGRect(x: lx - rw, y: ly - rw * 0.4, width: rw * 2, height: rw * 0.8)),
                       with: .color(col(0xFFFFFF, 0.24 - 0.09 * Double(k))), lineWidth: 0.7)
        }
    }

    private func fisherSilhouette(_ ctx: GraphicsContext, x: CGFloat, y: CGFloat, s: CGFloat, withTackle: Bool) {
        let ink = col(scene.ridge)

        // sampan hull — a long shallow boat with upturned bow & stern
        var boat = Path()
        boat.move(to: CGPoint(x: x - s * 0.68, y: y - s * 0.07))
        boat.addQuadCurve(to: CGPoint(x: x + s * 0.68, y: y - s * 0.06),
                          control: CGPoint(x: x, y: y + s * 0.22))
        boat.addQuadCurve(to: CGPoint(x: x - s * 0.68, y: y - s * 0.07),
                          control: CGPoint(x: x, y: y + s * 0.03))
        boat.closeSubpath()
        ctx.fill(boat, with: .color(ink))
        // a thin snow highlight along the gunwale
        var gun = Path()
        gun.move(to: CGPoint(x: x - s * 0.6, y: y - s * 0.05))
        gun.addQuadCurve(to: CGPoint(x: x + s * 0.6, y: y - s * 0.045),
                         control: CGPoint(x: x, y: y + s * 0.03))
        ctx.stroke(gun, with: .color(col(0xFFFFFF, 0.5)), style: StrokeStyle(lineWidth: 0.8, lineCap: .round))

        // hunched figure: rounded straw cape
        let fx = x - s * 0.05, fy = y - s * 0.03
        var cape = Path()
        cape.move(to: CGPoint(x: fx - s * 0.17, y: fy))
        cape.addQuadCurve(to: CGPoint(x: fx - s * 0.12, y: fy - s * 0.24),
                          control: CGPoint(x: fx - s * 0.2, y: fy - s * 0.12))
        cape.addQuadCurve(to: CGPoint(x: fx + s * 0.12, y: fy - s * 0.24),
                          control: CGPoint(x: fx, y: fy - s * 0.35))
        cape.addQuadCurve(to: CGPoint(x: fx + s * 0.17, y: fy),
                          control: CGPoint(x: fx + s * 0.2, y: fy - s * 0.12))
        cape.closeSubpath()
        ctx.fill(cape, with: .color(ink))

        // wide conical hat (笠) with a brim and a peak
        var hat = Path()
        hat.move(to: CGPoint(x: fx - s * 0.27, y: fy - s * 0.24))
        hat.addQuadCurve(to: CGPoint(x: fx + s * 0.27, y: fy - s * 0.24),
                         control: CGPoint(x: fx, y: fy - s * 0.17))
        hat.addQuadCurve(to: CGPoint(x: fx, y: fy - s * 0.45),
                         control: CGPoint(x: fx + s * 0.12, y: fy - s * 0.4))
        hat.addQuadCurve(to: CGPoint(x: fx - s * 0.27, y: fy - s * 0.24),
                         control: CGPoint(x: fx - s * 0.12, y: fy - s * 0.4))
        hat.closeSubpath()
        ctx.fill(hat, with: .color(ink))
        // a touch of snow on the brim
        var snowOnHat = Path()
        snowOnHat.move(to: CGPoint(x: fx - s * 0.2, y: fy - s * 0.255))
        snowOnHat.addQuadCurve(to: CGPoint(x: fx + s * 0.2, y: fy - s * 0.255),
                               control: CGPoint(x: fx, y: fy - s * 0.33))
        ctx.stroke(snowOnHat, with: .color(col(0xFFFFFF, 0.4)), style: StrokeStyle(lineWidth: 0.7, lineCap: .round))

        if withTackle {
            var rod = Path()
            rod.move(to: CGPoint(x: fx + s * 0.16, y: fy - s * 0.18))
            rod.addQuadCurve(to: CGPoint(x: x + s * 0.82, y: y - s * 0.12),
                             control: CGPoint(x: x + s * 0.5, y: y - s * 0.26))
            ctx.stroke(rod, with: .color(col(scene.ridge, 0.9)), style: StrokeStyle(lineWidth: 1.1, lineCap: .round))
            var thread = Path()
            thread.move(to: CGPoint(x: x + s * 0.82, y: y - s * 0.12))
            thread.addLine(to: CGPoint(x: x + s * 0.82, y: y + s * 0.34))
            ctx.stroke(thread, with: .color(col(scene.ridge, 0.45)), style: StrokeStyle(lineWidth: 0.6, lineCap: .round))
        }
    }

    private func snowLayer(_ ctx: GraphicsContext, _ size: CGSize, seed: Int, count: Int, minR: CGFloat, maxR: CGFloat, opacity: Double) {
        for i in 0..<count {
            let x = rnd(i * 2 + seed) * size.width
            let y = rnd(i * 2 + seed + 1) * size.height
            let r = minR + (maxR - minR) * rnd(i * 5 + seed + 7)
            let b = opacity * (0.5 + 0.5 * rnd(i * 3 + seed + 5))
            ctx.fill(Path(ellipseIn: CGRect(x: x, y: y, width: r, height: r)),
                     with: .color(col(scene.star, b)))
        }
    }

    private func nearSnow(_ ctx: GraphicsContext, _ size: CGSize) {
        ctx.drawLayer { l in
            l.addFilter(.blur(radius: 1.4))
            for i in 0..<16 {
                let x = rnd(i * 9 + 31) * size.width
                let y = rnd(i * 9 + 37) * size.height
                let r = 2.4 + 2.2 * rnd(i * 5 + 41)
                l.fill(Path(ellipseIn: CGRect(x: x, y: y, width: r, height: r)),
                       with: .color(col(0xFFFFFF, 0.92)))
            }
        }
    }

    private func riverReflection(_ ctx: GraphicsContext, _ size: CGSize, riverTop: CGFloat, orbX: CGFloat) {
        let W = size.width, H = size.height
        // a pale mountain reflection wash near the top of the river
        ctx.fill(Path(CGRect(x: 0, y: riverTop, width: W, height: (H - riverTop) * 0.42)),
                 with: .linearGradient(Gradient(colors: [col(0xE4ECF3, 0.42), col(0xE4ECF3, 0)]),
                                       startPoint: CGPoint(x: 0, y: riverTop),
                                       endPoint: CGPoint(x: 0, y: riverTop + (H - riverTop) * 0.42)))
        // the cold sun's broken shimmer column
        ctx.drawLayer { l in
            l.addFilter(.blur(radius: 2))
            for i in 0..<9 {
                let y = riverTop + CGFloat(i) / 9 * (H - riverTop)
                let w = W * (0.02 + 0.02 * rnd(i * 5 + 3))
                l.fill(Path(roundedRect: CGRect(x: orbX - w, y: y, width: w * 2, height: 2), cornerRadius: 1),
                       with: .color(col(scene.orb, 0.42 - 0.038 * Double(i))))
            }
        }
        // gentle ripple brush-strokes
        for i in 0..<10 {
            let y = riverTop + 6 + CGFloat(i) / 10 * (H - riverTop)
            let baseX = W * (0.06 + 0.48 * rnd(i * 3 + 1))
            let len = W * (0.18 + 0.34 * rnd(i * 5 + 2))
            var p = Path()
            p.move(to: CGPoint(x: baseX, y: y))
            p.addQuadCurve(to: CGPoint(x: baseX + len, y: y),
                           control: CGPoint(x: baseX + len * 0.5, y: y + (rnd(i * 7 + 3) - 0.5) * 4))
            ctx.stroke(p, with: .color(col(scene.aurora, 0.12 + 0.07 * rnd(i * 9 + 4))),
                       style: StrokeStyle(lineWidth: 0.9, lineCap: .round))
        }
    }

    private func foregroundBank(_ ctx: GraphicsContext, _ size: CGSize, riverTop: CGFloat) {
        let W = size.width, H = size.height
        var bank = Path()
        bank.move(to: CGPoint(x: 0, y: H))
        bank.addLine(to: CGPoint(x: 0, y: H * 0.9))
        bank.addQuadCurve(to: CGPoint(x: W * 0.44, y: H * 0.99), control: CGPoint(x: W * 0.2, y: H * 0.915))
        bank.addLine(to: CGPoint(x: W * 0.44, y: H))
        bank.closeSubpath()
        ctx.fill(bank, with: .color(col(0xEAF0F5)))
        ctx.stroke(bank, with: .color(col(scene.aurora, 0.28)), lineWidth: 1)
        bareTree(ctx, x: W * 0.12, baseY: H * 0.915, h: H * 0.21)
        reeds(ctx, size, x: W * 0.3, baseY: H * 0.96, n: 4)
    }

    private func bareTree(_ ctx: GraphicsContext, x: CGFloat, baseY: CGFloat, h: CGFloat) {
        var trunk = Path()
        trunk.move(to: CGPoint(x: x, y: baseY))
        trunk.addQuadCurve(to: CGPoint(x: x - h * 0.04, y: baseY - h),
                           control: CGPoint(x: x + h * 0.03, y: baseY - h * 0.5))
        ctx.stroke(trunk, with: .color(col(scene.ridge)), style: StrokeStyle(lineWidth: 2.6, lineCap: .round))
        for k in 0..<5 {
            let yy = baseY - h * (0.45 + 0.12 * CGFloat(k))
            let dir: CGFloat = (k % 2 == 0) ? 1 : -1
            let len = h * (0.26 - 0.03 * CGFloat(k))
            var b = Path()
            b.move(to: CGPoint(x: x, y: yy))
            b.addQuadCurve(to: CGPoint(x: x + dir * len, y: yy - len * 0.7),
                           control: CGPoint(x: x + dir * len * 0.5, y: yy - len * 0.15))
            ctx.stroke(b, with: .color(col(scene.ridge, 0.9)), style: StrokeStyle(lineWidth: max(0.8, 1.6 - 0.15 * CGFloat(k)), lineCap: .round))
        }
    }

    // MARK: ridges (with directional rim light)

    private func drawRidges(_ ctx: GraphicsContext, _ size: CGSize) {
        let (orb, _) = orbInfo(size)
        let ox = orb.x / size.width
        let rimBoost: Double = scene.kind == .clouds ? 1.0 : 0.45
        // rim brightens on the side facing the light
        let rimStops: [Color]
        if ox < 0.4 { rimStops = [col(scene.orb, 1), col(scene.orb, 0)] }
        else if ox > 0.6 { rimStops = [col(scene.orb, 0), col(scene.orb, 1)] }
        else { rimStops = [col(scene.orb, 0), col(scene.orb, 1), col(scene.orb, 0)] }

        let layers: [(baseY: CGFloat, amp: CGFloat, seed: CGFloat, op: Double)] = [
            (0.5, 0.045, 1.3, 0.5),
            (0.62, 0.06, 4.1, 0.74),
            (0.78, 0.085, 7.9, 1.0)
        ]
        let steps = 26
        for layer in layers {
            let baseY = size.height * layer.baseY
            var crest: [CGPoint] = []
            for s in 0...steps {
                let t = CGFloat(s) / CGFloat(steps)
                let x = t * size.width
                let y = baseY
                    + sin(t * 4.0 + layer.seed) * size.height * layer.amp
                    + sin(t * 9.0 + layer.seed * 1.7) * size.height * layer.amp * 0.4
                    + sin(t * 19.0 + layer.seed * 2.3) * size.height * layer.amp * 0.18   // organic ink edge
                crest.append(CGPoint(x: x, y: y))
            }
            var p = Path()
            p.move(to: CGPoint(x: 0, y: size.height))
            p.addLine(to: crest[0])
            for pt in crest.dropFirst() { p.addLine(to: pt) }
            p.addLine(to: CGPoint(x: size.width, y: size.height))
            p.closeSubpath()
            ctx.fill(p, with: .color(col(scene.ridge, layer.op)))

            var rim = Path()
            rim.move(to: crest[0])
            for pt in crest.dropFirst() { rim.addLine(to: pt) }

            // soft mist veil hugging the crest — dissolves the hard edge into the
            // sky for an ink-wash atmosphere (the biggest "less synthetic" cue)
            ctx.drawLayer { l in
                l.addFilter(.blur(radius: 8))
                l.stroke(rim, with: .color(col(scene.skyBottom, 0.55 * layer.op)),
                         style: StrokeStyle(lineWidth: 11, lineCap: .round, lineJoin: .round))
            }

            // directional rim light — softly blurred so the crest reads as CATCHING LIGHT,
            // never a crisp drawn contour line (the previous 1pt stroke looked synthetic)
            ctx.drawLayer { l in
                l.addFilter(.blur(radius: 2.6))
                var rg = l
                rg.blendMode = .screen
                rg.opacity = layer.op * rimBoost * 0.85
                rg.stroke(rim, with: .linearGradient(Gradient(colors: rimStops),
                                                     startPoint: .zero, endPoint: CGPoint(x: size.width, y: 0)),
                          style: StrokeStyle(lineWidth: 2.8, lineCap: .round, lineJoin: .round))
            }
        }
    }

    // MARK: hero accents

    private func drawAccent(_ ctx: GraphicsContext, _ size: CGSize) {
        switch scene.kind {
        case .aurora:
            pine(ctx, x: size.width * 0.34, baseY: size.height * 0.84, h: size.height * 0.2)
            pine(ctx, x: size.width * 0.2,  baseY: size.height * 0.86, h: size.height * 0.12)
            pine(ctx, x: size.width * 0.62, baseY: size.height * 0.87, h: size.height * 0.10)
            birds(ctx, around: CGPoint(x: size.width * 0.6, y: size.height * 0.34), n: 4, scale: 9)
        case .clouds:
            birds(ctx, around: CGPoint(x: size.width * 0.6, y: size.height * 0.28), n: 3, scale: 6.5)
            birds(ctx, around: CGPoint(x: size.width * 0.42, y: size.height * 0.2), n: 4, scale: 4.5)
        case .tide:
            loneBoat(ctx, x: size.width * 0.64, waterY: size.height * 0.72, scale: size.width * 0.12)
        case .snow, .waterfall:
            break
        }
    }

    private func loneBoat(_ ctx: GraphicsContext, x: CGFloat, waterY: CGFloat, scale s: CGFloat) {
        // faint reflection first
        var rc = ctx
        rc.opacity = 0.18
        rc.translateBy(x: 0, y: waterY * 1.5)
        rc.scaleBy(x: 1, y: -0.5)
        boatSilhouette(rc, x: x, y: waterY, s: s)
        boatSilhouette(ctx, x: x, y: waterY, s: s)
        // soft contact ripples on the moonlit water
        for k in 0..<2 {
            let rw = s * (0.7 + 0.5 * CGFloat(k))
            ctx.stroke(Path(ellipseIn: CGRect(x: x - rw, y: waterY + s * 0.08 + CGFloat(k) * 3,
                                              width: rw * 2, height: rw * 0.4)),
                       with: .color(col(scene.orb, 0.22 - 0.08 * Double(k))), lineWidth: 0.8)
        }
    }

    private func boatSilhouette(_ ctx: GraphicsContext, x: CGFloat, y: CGFloat, s: CGFloat) {
        let ink = col(scene.ridge)
        var hull = Path()
        hull.move(to: CGPoint(x: x - s * 0.6, y: y))
        hull.addQuadCurve(to: CGPoint(x: x + s * 0.6, y: y - s * 0.04), control: CGPoint(x: x, y: y + s * 0.18))
        hull.addQuadCurve(to: CGPoint(x: x - s * 0.6, y: y), control: CGPoint(x: x, y: y - s * 0.03))
        hull.closeSubpath()
        ctx.fill(hull, with: .color(ink))
        var mast = Path()
        mast.move(to: CGPoint(x: x - s * 0.04, y: y - s * 0.05))
        mast.addLine(to: CGPoint(x: x - s * 0.04, y: y - s * 0.86))
        ctx.stroke(mast, with: .color(ink), style: StrokeStyle(lineWidth: 1.1, lineCap: .round))
        // a curved junk sail
        var sail = Path()
        sail.move(to: CGPoint(x: x - s * 0.04, y: y - s * 0.82))
        sail.addQuadCurve(to: CGPoint(x: x - s * 0.04, y: y - s * 0.12), control: CGPoint(x: x + s * 0.44, y: y - s * 0.46))
        sail.closeSubpath()
        ctx.fill(sail, with: .color(ink))
    }

    private func pine(_ ctx: GraphicsContext, x: CGFloat, baseY: CGFloat, h: CGFloat) {
        var p = Path()
        let w = h * 0.5
        p.addRect(CGRect(x: x - h * 0.03, y: baseY - h * 0.1, width: h * 0.06, height: h * 0.12))
        for k in 0..<3 {
            let ty = baseY - h * (0.1 + 0.26 * CGFloat(k))
            let tw = w * (1.0 - 0.22 * CGFloat(k))
            let th = h * 0.42
            p.move(to: CGPoint(x: x, y: ty - th))
            p.addLine(to: CGPoint(x: x - tw / 2, y: ty))
            p.addLine(to: CGPoint(x: x + tw / 2, y: ty))
            p.closeSubpath()
        }
        ctx.fill(p, with: .color(col(scene.ridge)))
    }

    private func bird(_ ctx: GraphicsContext, center c: CGPoint, scale s: CGFloat) {
        var p = Path()
        p.move(to: CGPoint(x: c.x - s, y: c.y))
        p.addQuadCurve(to: CGPoint(x: c.x, y: c.y - s * 0.28),
                       control: CGPoint(x: c.x - s * 0.45, y: c.y - s * 0.5))
        p.addQuadCurve(to: CGPoint(x: c.x + s, y: c.y),
                       control: CGPoint(x: c.x + s * 0.45, y: c.y - s * 0.5))
        ctx.stroke(p, with: .color(col(scene.ridge)), style: StrokeStyle(lineWidth: s * 0.14, lineCap: .round))
    }

    private func birds(_ ctx: GraphicsContext, around c: CGPoint, n: Int, scale s: CGFloat) {
        for i in 0..<n {
            let p = CGPoint(x: c.x + (rnd(i * 3 + 1) - 0.5) * s * 6,
                            y: c.y + (rnd(i * 3 + 2) - 0.5) * s * 4)
            bird(ctx, center: p, scale: s * (0.7 + 0.5 * rnd(i * 7 + 5)))
        }
    }

    private func whaleFluke(_ ctx: GraphicsContext, x: CGFloat, waterY: CGFloat, scale s: CGFloat) {
        var p = Path()
        p.move(to: CGPoint(x: x - s * 0.12, y: waterY))
        p.addQuadCurve(to: CGPoint(x: x, y: waterY - s * 0.9),
                       control: CGPoint(x: x - s * 0.2, y: waterY - s * 0.5))
        p.addQuadCurve(to: CGPoint(x: x - s * 0.7, y: waterY - s * 1.15),
                       control: CGPoint(x: x - s * 0.4, y: waterY - s * 1.2))
        p.addQuadCurve(to: CGPoint(x: x - s * 0.06, y: waterY - s * 0.78),
                       control: CGPoint(x: x - s * 0.34, y: waterY - s * 0.86))
        p.addQuadCurve(to: CGPoint(x: x + s * 0.7, y: waterY - s * 1.1),
                       control: CGPoint(x: x + s * 0.36, y: waterY - s * 1.2))
        p.addQuadCurve(to: CGPoint(x: x + s * 0.12, y: waterY),
                       control: CGPoint(x: x + s * 0.34, y: waterY - s * 0.5))
        p.closeSubpath()
        ctx.fill(p, with: .color(col(scene.ridge)))
        for k in 0..<3 {
            let rw = s * (0.5 + 0.4 * CGFloat(k))
            let e = Path(ellipseIn: CGRect(x: x - rw, y: waterY - 2 + CGFloat(k) * 4, width: rw * 2, height: 4))
            ctx.stroke(e, with: .color(col(scene.orb, 0.3 - 0.08 * Double(k))), lineWidth: 1)
        }
    }

    // MARK: waterfall scene — a misty monsoon gorge (after the reference photo):
    // layered charcoal-green ridges with thick fog banks stacked between them, a tall
    // thin cascade dropping from a notch and swallowed mid-fall by cloud, a lush green
    // treeline below, and a faint bow half-lost in the drifting spray (the card's 虹)

    private func drawWaterfallScene(_ ctx: GraphicsContext, _ size: CGSize) {
        let W = size.width, H = size.height
        let (oc, orad) = orbInfo(size)

        // overcast light — a soft, diffuse brightening high in the sky, no hard disc.
        // The sun is lost in monsoon cloud; it only pales the fog behind it.
        ctx.drawLayer { l in
            l.addFilter(.blur(radius: orad))
            l.fill(Path(ellipseIn: CGRect(x: oc.x - orad * 2.6, y: oc.y - orad * 2.6,
                                          width: orad * 5.2, height: orad * 5.2)),
                   with: .radialGradient(
                    Gradient(colors: [col(scene.orb, 0.6), col(scene.orb, 0)]),
                    center: oc, startRadius: 0, endRadius: orad * 2.6))
        }

        let fallX   = W * 0.53
        let topY    = H * 0.31
        let poolY   = H * 0.70
        let topHalf = W * 0.009
        let botHalf = W * 0.028

        // Ranges receding into fog: each ridge is trailed by a broken fog bank, so the
        // mountains read as stacked planes dissolving into white. Far (pale) to near.
        ridgeLayer(ctx, size, baseY: H * 0.13, amp: 0.04, seed: 3.1, fill: 0xBAC9C3, haze: H * 0.12)
        mistBank(ctx, size, y: H * 0.165, height: H * 0.09, seed: 11, opacity: 0.72, blur: 16, count: 8)

        ridgeLayer(ctx, size, baseY: H * 0.19, amp: 0.05, seed: 6.4, fill: 0x93A69D, haze: H * 0.10)
        mistBank(ctx, size, y: H * 0.225, height: H * 0.075, seed: 23, opacity: 0.64, blur: 14, count: 8)

        // the dark near mountain the fall runs down — a continuous mass whose ridge sits
        // ABOVE the fall; the water is a gully on its face, not a spring from the summit
        darkMassif(ctx, size, fallX: fallX, topY: topY, poolY: poolY)

        // an upper fog band veiling the fall's source on the face — it emerges from cloud,
        // the way a real fall's top is lost in mist rather than starting at a sharp peak
        mistBank(ctx, size, y: topY - H * 0.01, height: H * 0.055, seed: 91, opacity: 0.56, blur: 13, count: 8)

        // the white thread on the face — thin, running down the visible dark rock
        drawWaterfall(ctx, size, fallX: fallX, topY: topY, poolY: poolY, topHalf: topHalf, botHalf: botHalf)

        // a single broken veil drifting across the upper-mid face — soft and uneven, it
        // leaves the dark rock clearly visible between wisps (no flat grey murk)
        mistBank(ctx, size, y: H * 0.42, height: H * 0.05, seed: 47, opacity: 0.3, blur: 13, count: 6)

        // the fall's spray bloom at the foot — concentrated where the water lands, so it
        // reads as rising mist rather than a broad muddy halo washing the whole gorge
        ctx.drawLayer { l in
            l.addFilter(.blur(radius: 18))
            l.fill(Path(ellipseIn: CGRect(x: fallX - W * 0.2, y: H * 0.56, width: W * 0.4, height: H * 0.15)),
                   with: .radialGradient(
                    Gradient(colors: [col(0xF3F8F5, 0.74), col(0xEDF4F1, 0.32), col(0xFFFFFF, 0)]),
                    center: CGPoint(x: fallX - W * 0.01, y: H * 0.63), startRadius: 0, endRadius: W * 0.2))
        }

        // the bow forming in the rising spray — partial, luminous, uneven (the card's 虹)
        drawRainbow(ctx, size, center: CGPoint(x: fallX - W * 0.015, y: poolY - H * 0.02), radius: W * 0.23)

        // a pale fogged basin where the fall lands (the 水 — a misty pool in the valley)
        ctx.drawLayer { l in
            l.addFilter(.blur(radius: 12))
            l.fill(Path(ellipseIn: CGRect(x: fallX - W * 0.27, y: poolY - H * 0.05, width: W * 0.54, height: H * 0.1)),
                   with: .radialGradient(
                    Gradient(colors: [col(0xEDF3F1, 0.62), col(0xEDF3F1, 0.22), col(0xFFFFFF, 0)]),
                    center: CGPoint(x: fallX, y: poolY - H * 0.005), startRadius: 0, endRadius: W * 0.27))
        }

        // lush dark-green forested valley, then a darker leafy foreground framing the edges
        forestBase(ctx, size, poolY: poolY, fallX: fallX)
        foregroundTrees(ctx, size, fallX: fallX)

        // low fog threading the treeline — kept broken and soft so it never reads as a stripe
        mistBank(ctx, size, y: poolY + H * 0.02, height: H * 0.04, seed: 71, opacity: 0.22, blur: 13, count: 5)

        // a few distant birds in the fogged sky
        birds(ctx, around: CGPoint(x: W * 0.24, y: H * 0.09), n: 3, scale: 5.5)
    }

    // one receding misty ridge plane — filled flat, with directional light (cool shadow
    // left, warm light right) and a cool haze wash sinking into its foot so the trailing
    // mist bank can dissolve the base edge
    private func ridgeLayer(_ ctx: GraphicsContext, _ size: CGSize,
                            baseY: CGFloat, amp: CGFloat, seed: CGFloat, fill: UInt, haze: CGFloat) {
        let W = size.width, H = size.height
        var crest: [CGPoint] = []
        let steps = 48
        for s in 0...steps {
            let t = CGFloat(s) / CGFloat(steps)
            let y = baseY
                + sin(t * 2.3 + seed) * H * amp
                + sin(t * 5.1 + seed * 1.7) * H * amp * 0.5
                + sin(t * 11.0 + seed * 2.9) * H * amp * 0.24
                + sin(t * 23.0 + seed * 3.3) * H * amp * 0.1
            crest.append(CGPoint(x: t * W, y: y))
        }
        var p = Path()
        p.move(to: CGPoint(x: 0, y: H))
        p.addLine(to: crest[0])
        for pt in crest.dropFirst() { p.addLine(to: pt) }
        p.addLine(to: CGPoint(x: W, y: H))
        p.closeSubpath()
        ctx.fill(p, with: .color(col(fill)))
        ctx.fill(p, with: .linearGradient(
            Gradient(colors: [col(0x39493F, 0.18), col(0x39493F, 0), col(0xFDFDF6, 0), col(0xFDFDF6, 0.16)]),
            startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: W, y: 0)))
        ctx.fill(p, with: .linearGradient(
            Gradient(colors: [col(0xE9F0EE, 0.0), col(0xE9F0EE, 0.6)]),
            startPoint: CGPoint(x: 0, y: baseY),
            endPoint: CGPoint(x: 0, y: baseY + haze)))
    }

    // the dark near mountains the fall drops between — an asymmetric, craggy range with a
    // dominant peak on the right and a cut cleft at the fall; shaded with directional
    // light, gorge ambient-occlusion, and spray-lit rock hugging the channel
    private func darkMassif(_ ctx: GraphicsContext, _ size: CGSize,
                            fallX: CGFloat, topY: CGFloat, poolY: CGFloat) {
        let W = size.width, H = size.height

        func peak(_ x: CGFloat, _ c: CGFloat, _ w: CGFloat) -> CGFloat {
            CGFloat(exp(-pow(Double((x - c) / w), 2)))
        }
        func crestY(_ t: CGFloat) -> CGFloat {
            let x = t * W
            var y = H * 0.34
                + sin(t * 3.0 + 0.6) * H * 0.02
                + sin(t * 6.5 + 2.0) * H * 0.012
                + sin(t * 15.0 + 4.0) * H * 0.006
                + sin(t * 33.0 + 1.2) * H * 0.003                 // craggy grain
            y -= H * 0.20 * peak(x, W * 0.60, W * 0.20)           // broad dominant mass (fall on its left face)
            y -= H * 0.10 * peak(x, W * 0.82, W * 0.09)           // right secondary peak
            y -= H * 0.09 * peak(x, W * 0.30, W * 0.10)           // left hill
            y -= H * 0.05 * peak(x, W * 0.14, W * 0.07)           // far-left crag
            return y
        }
        // continuous ridge (no cleft): the summit stays ABOVE the fall; the water is drawn
        // as a gully on the face, its source hidden by the upper fog band
        var crest: [CGPoint] = []
        let steps = 72
        for s in 0...steps {
            let t = CGFloat(s) / CGFloat(steps)
            crest.append(CGPoint(x: t * W, y: crestY(t)))
        }
        var p = Path()
        p.move(to: CGPoint(x: 0, y: poolY))
        p.addLine(to: crest[0])
        for pt in crest.dropFirst() { p.addLine(to: pt) }
        p.addLine(to: CGPoint(x: W, y: poolY))
        p.closeSubpath()
        ctx.fill(p, with: .linearGradient(
            Gradient(colors: [col(0x44554A), col(0x304037), col(0x28362E)]),
            startPoint: CGPoint(x: 0, y: H * 0.14), endPoint: CGPoint(x: 0, y: poolY)))
        ctx.drawLayer { l in
            l.clip(to: p)
            // directional light: the sunlit right flank vs. the shadowed left
            l.fill(Path(CGRect(x: 0, y: 0, width: W, height: H)),
                   with: .linearGradient(
                    Gradient(colors: [col(0x0E1510, 0.35), col(0x0E1510, 0), col(0xBFD3C9, 0), col(0xBFD3C9, 0.16)]),
                    startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: W, y: 0)))
            // ambient occlusion sinking into the base of the valley (gentle)
            l.fill(Path(CGRect(x: 0, y: 0, width: W, height: H)),
                   with: .radialGradient(
                    Gradient(colors: [col(0x0C120E, 0.3), col(0x0C120E, 0)]),
                    center: CGPoint(x: fallX, y: poolY * 0.99), startRadius: 0, endRadius: W * 0.55))
            // a shadowed gully the water runs down — a recessed vertical channel on the face
            l.drawLayer { g in
                g.addFilter(.blur(radius: 6))
                g.fill(Path(ellipseIn: CGRect(x: fallX - W * 0.055, y: topY - H * 0.01,
                                              width: W * 0.11, height: (poolY - topY) * 0.72)),
                       with: .radialGradient(
                        Gradient(colors: [col(0x0A110D, 0.5), col(0x0A110D, 0)]),
                        center: CGPoint(x: fallX, y: topY + (poolY - topY) * 0.22), startRadius: 0, endRadius: W * 0.09))
            }
            // spray-lit rock hugging the lower fall channel
            l.fill(Path(CGRect(x: 0, y: 0, width: W, height: H)),
                   with: .radialGradient(
                    Gradient(colors: [col(0xB6CCC1, 0.26), col(0xB6CCC1, 0)]),
                    center: CGPoint(x: fallX, y: (topY + poolY) * 0.6), startRadius: 0, endRadius: W * 0.11))
            // soft tonal light on the sunlit shoulder for form
            l.fill(Path(CGRect(x: 0, y: 0, width: W, height: H)),
                   with: .radialGradient(
                    Gradient(colors: [col(0xA9C1B6, 0.18), col(0xA9C1B6, 0)]),
                    center: CGPoint(x: W * 0.66, y: H * 0.24), startRadius: 0, endRadius: W * 0.26))
            // deepen the shadowed left flank so the mass reads as a rounded volume, not a slab
            l.fill(Path(CGRect(x: 0, y: 0, width: W, height: H)),
                   with: .radialGradient(
                    Gradient(colors: [col(0x0B120E, 0.34), col(0x0B120E, 0)]),
                    center: CGPoint(x: W * 0.14, y: H * 0.5), startRadius: 0, endRadius: W * 0.4))
        }
        // light rim catching the sky along the crest (brighter on the right)
        var rimP = Path()
        rimP.move(to: crest[0])
        for pt in crest.dropFirst() { rimP.addLine(to: pt) }
        ctx.stroke(rimP, with: .linearGradient(
            Gradient(colors: [col(scene.aurora, 0.12), col(scene.aurora, 0.5)]),
            startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: W, y: 0)),
            style: StrokeStyle(lineWidth: 1.2, lineCap: .round, lineJoin: .round))
    }

    private func drawWaterfall(_ ctx: GraphicsContext, _ size: CGSize, fallX: CGFloat, topY: CGFloat, poolY: CGFloat, topHalf: CGFloat, botHalf: CGFloat) {
        let span = poolY - topY
        let steps = 30

        // a sampled centreline: near-straight at the lip, a lazy waver lower down, thin
        // throughout with a slight fan near the base — reads alive, never a ruler-straight cut
        var mid: [CGPoint] = []
        var halfW: [CGFloat] = []
        for s in 0...steps {
            let t = CGFloat(s) / CGFloat(steps)
            let drift = sin(t * .pi * 1.1 + 0.4) * topHalf * 0.6 + sin(t * .pi * 2.7) * topHalf * 0.28
            mid.append(CGPoint(x: fallX + drift * (0.3 + 0.7 * t), y: topY + span * t))
            let w = topHalf * (0.8 + 0.5 * sin(t * .pi)) + botHalf * (t * t) * 0.8
            halfW.append(max(topHalf * 0.5, w))
        }

        func edge(_ spread: CGFloat) -> Path {
            var p = Path()
            p.move(to: CGPoint(x: mid[0].x - halfW[0] * spread, y: mid[0].y))
            for i in 0...steps { p.addLine(to: CGPoint(x: mid[i].x - halfW[i] * spread, y: mid[i].y)) }
            for i in stride(from: steps, through: 0, by: -1) {
                p.addLine(to: CGPoint(x: mid[i].x + halfW[i] * spread, y: mid[i].y))
            }
            p.closeSubpath()
            return p
        }

        // vertical fade: bright at the lip, translucent through the drop, gone by ~70% —
        // the water dissolves into the gorge mist rather than reading as a bright beam
        let bodyGrad = Gradient(stops: [
            .init(color: col(0xF3F9F6, 0.7), location: 0.0),
            .init(color: col(0xFFFFFF, 0.82), location: 0.12),
            .init(color: col(0xF3F9F6, 0.42), location: 0.4),
            .init(color: col(0xEEF5F2, 0.14), location: 0.58),
            .init(color: col(0xEEF5F2, 0.0), location: 0.72),
        ])

        // a narrow soft veil hugging the water (subtle)
        ctx.drawLayer { l in
            l.addFilter(.blur(radius: 3.5))
            l.fill(edge(1.7), with: .linearGradient(
                Gradient(stops: [
                    .init(color: col(0xEFF6F2, 0.0), location: 0.0),
                    .init(color: col(0xEFF6F2, 0.16), location: 0.2),
                    .init(color: col(0xEFF6F2, 0.05), location: 0.6),
                    .init(color: col(0xEFF6F2, 0.0), location: 0.85),
                ]),
                startPoint: CGPoint(x: 0, y: topY), endPoint: CGPoint(x: 0, y: poolY)))
        }

        // the water body, soft-edged
        ctx.drawLayer { l in
            l.addFilter(.blur(radius: 0.7))
            l.fill(edge(1), with: .linearGradient(
                bodyGrad, startPoint: CGPoint(x: 0, y: topY), endPoint: CGPoint(x: 0, y: poolY)))
        }

        // bright inner thread, brightest at the lip, faded well before the base
        var thread = Path()
        thread.move(to: mid[0])
        for i in 1...steps { thread.addLine(to: mid[i]) }
        ctx.stroke(thread, with: .linearGradient(
            Gradient(stops: [
                .init(color: col(0xFFFFFF, 0.85), location: 0.0),
                .init(color: col(0xFFFFFF, 0.4), location: 0.32),
                .init(color: col(0xFFFFFF, 0.0), location: 0.56),
            ]),
            startPoint: CGPoint(x: 0, y: topY), endPoint: CGPoint(x: 0, y: poolY)),
            style: StrokeStyle(lineWidth: max(0.7, topHalf * 0.45), lineCap: .round, lineJoin: .round))

        // faint parallel streaks inside the ribbon (falling-water texture)
        ctx.drawLayer { l in
            for j in [-0.42, 0.4] {
                var st = Path()
                st.move(to: mid[0])
                for i in 1...steps { st.addLine(to: CGPoint(x: mid[i].x + halfW[i] * CGFloat(j), y: mid[i].y)) }
                l.stroke(st, with: .linearGradient(
                    Gradient(stops: [
                        .init(color: col(0xFFFFFF, 0.4), location: 0.05),
                        .init(color: col(0xFFFFFF, 0.0), location: 0.6),
                    ]),
                    startPoint: CGPoint(x: 0, y: topY), endPoint: CGPoint(x: 0, y: poolY)),
                    style: StrokeStyle(lineWidth: 0.6, lineCap: .round))
            }
        }

        // a soft vertical smear where the water first appears out of the mist (not a star)
        ctx.drawLayer { l in
            l.addFilter(.blur(radius: 3))
            l.fill(Path(ellipseIn: CGRect(x: fallX - topHalf * 1.4, y: topY - topHalf,
                                          width: topHalf * 2.8, height: topHalf * 6)),
                   with: .color(col(0xFFFFFF, 0.38)))
        }
    }

    private func drawRainbow(_ ctx: GraphicsContext, _ size: CGSize, center: CGPoint, radius: CGFloat) {
        // a luminous, delicate bow born in the spray: a broad soft underglow, a bright inner
        // rim, then six jewel-soft bands — all fading hard at the ends (pow env) so the arc
        // dissolves into the mist and never reads as a printed decal
        let bands: [(UInt, Double)] = [
            (0xF0968C, 0.26),  // rose
            (0xF3B87E, 0.25),  // amber
            (0xEFE293, 0.23),  // gold
            (0x9FD9A2, 0.25),  // green
            (0x8FC2EE, 0.25),  // sky
            (0xBBA6E6, 0.22),  // violet
        ]
        let bandW = radius * 0.055
        let a0 = 208.0, a1 = 332.0
        func pt(_ r: CGFloat, _ deg: Double) -> CGPoint {
            let a = CGFloat(deg * .pi / 180)
            return CGPoint(x: center.x + r * cos(a), y: center.y + r * sin(a))
        }
        // broad soft underglow lifting the whole bow out of the spray
        ctx.drawLayer { l in
            l.addFilter(.blur(radius: 14))
            var g = l; g.blendMode = .screen
            let r = radius - bandW * 2.6
            let segs = 44
            for s in 0..<segs {
                let t0 = Double(s) / Double(segs)
                let env = sin(t0 * .pi)
                let op = 0.12 * pow(env, 1.6)
                if op < 0.008 { continue }
                var seg = Path()
                seg.move(to: pt(r, a0 + (a1 - a0) * t0))
                seg.addLine(to: pt(r, a0 + (a1 - a0) * (Double(s + 1) / Double(segs))))
                g.stroke(seg, with: .color(col(0xF2F8FF, op)), style: StrokeStyle(lineWidth: bandW * 7, lineCap: .round))
            }
        }
        ctx.drawLayer { layer in
            layer.addFilter(.blur(radius: 3))
            var g = layer; g.blendMode = .screen
            let segs = 60
            // a bright warm inner rim just inside the rose band (rainbows glow brightest here)
            let rimR = radius + bandW * 0.9
            for s in 0..<segs {
                let t0 = Double(s) / Double(segs)
                let env = sin(t0 * .pi)
                let breathe = 0.7 + 0.3 * sin(t0 * .pi * 2.1 + 0.6)
                let op = 0.16 * pow(env, 2.0) * breathe
                if op < 0.01 { continue }
                var seg = Path()
                seg.move(to: pt(rimR, a0 + (a1 - a0) * t0))
                seg.addLine(to: pt(rimR, a0 + (a1 - a0) * (Double(s + 1) / Double(segs))))
                g.stroke(seg, with: .color(col(0xFBF6EE, op)), style: StrokeStyle(lineWidth: bandW * 1.2, lineCap: .round))
            }
            for (i, band) in bands.enumerated() {
                let r = radius - CGFloat(i) * bandW
                for s in 0..<segs {
                    let t0 = Double(s) / Double(segs)
                    let env = sin(t0 * .pi)
                    let breathe = 0.66 + 0.34 * sin(t0 * .pi * 2.3 + Double(i) * 0.9)
                    let op = band.1 * pow(env, 2.1) * breathe
                    if op < 0.012 { continue }
                    var seg = Path()
                    seg.move(to: pt(r, a0 + (a1 - a0) * t0))
                    seg.addLine(to: pt(r, a0 + (a1 - a0) * (Double(s + 1) / Double(segs))))
                    g.stroke(seg, with: .color(col(band.0, op)), style: StrokeStyle(lineWidth: bandW + 1.4, lineCap: .round))
                }
            }
        }
    }

    // a volumetric fog bank — a faint bound band and clustered billowing puffs, topped by
    // a brighter, tighter highlight cap catching the sky light. Weaves between the ranges
    // and across the fall; the atmosphere that carries the whole scene.
    private func mistBank(_ ctx: GraphicsContext, _ size: CGSize,
                          y: CGFloat, height: CGFloat, seed: Int, opacity: Double, blur: CGFloat, count: Int) {
        let W = size.width
        ctx.drawLayer { l in
            l.addFilter(.blur(radius: blur))
            // a soft continuous band binding the bank together
            l.fill(Path(ellipseIn: CGRect(x: -W * 0.12, y: y - height * 0.28,
                                          width: W * 1.24, height: height * 0.6)),
                   with: .color(col(0xEFF5F2, opacity * 0.28)))
            // clustered puffs of varied size for a billowing, uneven crown
            for i in 0..<count {
                let cx = -W * 0.1 + rnd(i * 3 + seed) * W * 1.2
                let cy = y + (rnd(i * 5 + seed + 1) - 0.5) * height * 1.1
                let w = W * (0.13 + 0.22 * rnd(i * 7 + seed + 2))
                let h = height * (0.4 + 0.7 * rnd(i * 9 + seed + 3))
                let op = opacity * (0.35 + 0.6 * Double(rnd(i * 11 + seed + 4)))
                l.fill(Path(ellipseIn: CGRect(x: cx - w, y: cy - h / 2, width: w * 2, height: h)),
                       with: .color(col(0xF6FAF8, op)))
            }
        }
        // brighter highlight cap along the crown, catching the sky light (fog volume)
        ctx.drawLayer { l in
            l.addFilter(.blur(radius: blur * 0.5))
            for i in 0..<count {
                let cx = -W * 0.08 + rnd(i * 4 + seed + 40) * W * 1.16
                let cy = y - height * (0.1 + 0.16 * rnd(i * 6 + seed + 41))
                let w = W * (0.07 + 0.12 * rnd(i * 8 + seed + 42))
                let h = height * (0.18 + 0.22 * rnd(i * 10 + seed + 43))
                let op = opacity * 0.42 * (0.5 + 0.5 * Double(rnd(i * 12 + seed + 44)))
                l.fill(Path(ellipseIn: CGRect(x: cx - w, y: cy - h / 2, width: w * 2, height: h)),
                       with: .color(col(0xFFFFFF, op)))
            }
        }
    }

    // lush dark-green forested foot — a paler hazed far treeline over a dark near forest
    // wall, with a few tall firs breaking the crown. The top edge is left ragged so the
    // low fog can dissolve it, the way the treeline vanishes into cloud in the reference.
    private func forestBase(_ ctx: GraphicsContext, _ size: CGSize, poolY: CGFloat, fallX: CGFloat) {
        let W = size.width, H = size.height
        treeRow(ctx, size, baseY: poolY + H * 0.03,  amp: H * 0.02, bumps: 26, seed: 5,  fill: 0x546B5B, blur: 2.5)
        treeRow(ctx, size, baseY: poolY + H * 0.075, amp: H * 0.03, bumps: 32, seed: 9,  fill: 0x27392B, blur: 0.5)
        treeRow(ctx, size, baseY: poolY + H * 0.135, amp: H * 0.03, bumps: 36, seed: 17, fill: 0x1A281C, blur: 0)
        for i in 0..<8 {
            let x = W * (0.05 + 0.13 * CGFloat(i)) + (rnd(i * 7 + 3) - 0.5) * W * 0.05
            if abs(x - fallX) < W * 0.05 { continue }
            fir(ctx, x: x, baseY: poolY + H * 0.09 + rnd(i * 5 + 1) * H * 0.03,
                h: H * (0.04 + 0.03 * rnd(i * 3 + 2)), fill: 0x16241A)
        }
    }

    // near-ground: a dark leafy canopy rising from the bottom, higher at the edges and
    // dipping in the centre so it frames the scene without blocking the fall and pool
    private func foregroundTrees(_ ctx: GraphicsContext, _ size: CGSize, fallX: CGFloat) {
        let W = size.width, H = size.height
        var pts: [CGPoint] = []
        let steps = 64
        for s in 0...steps {
            let t = CGFloat(s) / CGFloat(steps)
            let edge = pow(abs(t - 0.5) * 2, 1.6)                       // 0 centre → 1 at the edges
            let y = H * 0.95 - edge * H * 0.17
                - (0.5 + 0.5 * sin(t * 9 * .pi + 1.0)) * H * 0.022      // rounded leafy bumps
                - (0.5 + 0.5 * sin(t * 23 * .pi + 3.0)) * H * 0.012
            pts.append(CGPoint(x: t * W, y: y))
        }
        var p = Path()
        p.move(to: CGPoint(x: 0, y: H)); p.addLine(to: pts[0])
        for pt in pts.dropFirst() { p.addLine(to: pt) }
        p.addLine(to: CGPoint(x: W, y: H)); p.closeSubpath()
        ctx.fill(p, with: .linearGradient(
            Gradient(colors: [col(0x14200F), col(0x0A1108)]),
            startPoint: CGPoint(x: 0, y: H * 0.78), endPoint: CGPoint(x: 0, y: H)))
        // a faint misty rim catching light along the canopy crown
        var rim = Path()
        rim.move(to: pts[0])
        for pt in pts.dropFirst() { rim.addLine(to: pt) }
        ctx.drawLayer { l in
            l.addFilter(.blur(radius: 2.5))
            l.stroke(rim, with: .color(col(0x3A5030, 0.35)),
                     style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }

    // one canopy layer — a filled silhouette whose top edge is a ridge of abs-sine humps
    // (treetop clumps); soft-blurred for the hazed far row, crisp for the near wall
    private func treeRow(_ ctx: GraphicsContext, _ size: CGSize,
                         baseY: CGFloat, amp: CGFloat, bumps: CGFloat, seed: Int, fill: UInt, blur: CGFloat) {
        let W = size.width, H = size.height
        var pts: [CGPoint] = []
        let steps = 90
        for s in 0...steps {
            let t = CGFloat(s) / CGFloat(steps)
            let y = baseY
                - abs(sin(t * bumps * .pi + CGFloat(seed))) * amp
                - abs(sin(t * bumps * 0.37 * .pi + CGFloat(seed) * 1.3)) * amp * 0.6
            pts.append(CGPoint(x: t * W, y: y))
        }
        var p = Path()
        p.move(to: CGPoint(x: 0, y: H))
        p.addLine(to: pts[0])
        for pt in pts.dropFirst() { p.addLine(to: pt) }
        p.addLine(to: CGPoint(x: W, y: H))
        p.closeSubpath()
        if blur > 0 {
            ctx.drawLayer { l in l.addFilter(.blur(radius: blur)); l.fill(p, with: .color(col(fill))) }
        } else {
            ctx.fill(p, with: .color(col(fill)))
        }
    }

    // a small conifer silhouette — three stacked triangles on a slim trunk
    private func fir(_ ctx: GraphicsContext, x: CGFloat, baseY: CGFloat, h: CGFloat, fill: UInt) {
        var p = Path()
        let w = h * 0.42
        for k in 0..<3 {
            let ty = baseY - h * 0.26 * CGFloat(k)
            let tw = w * (1 - CGFloat(k) * 0.2)
            p.move(to: CGPoint(x: x, y: ty - h * 0.55))
            p.addLine(to: CGPoint(x: x - tw / 2, y: ty))
            p.addLine(to: CGPoint(x: x + tw / 2, y: ty))
            p.closeSubpath()
        }
        p.addRect(CGRect(x: x - h * 0.02, y: baseY, width: h * 0.04, height: h * 0.08))
        ctx.fill(p, with: .color(col(fill)))
    }

    // MARK: vignette

    private func drawVignette(_ ctx: GraphicsContext, _ size: CGSize) {
        let rect = CGRect(origin: .zero, size: size)
        let strength = (scene.kind == .clouds || scene.kind == .waterfall) ? 0.2 : 0.32
        ctx.fill(Path(rect), with: .radialGradient(
            Gradient(colors: [Color.black.opacity(0), Color.black.opacity(strength)]),
            center: CGPoint(x: size.width * 0.5, y: size.height * 0.42),
            startRadius: size.width * 0.36, endRadius: size.width * 0.85))
    }
}
