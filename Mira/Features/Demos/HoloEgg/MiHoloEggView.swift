//
//  MiHoloEggView.swift
//  Mira
//
//  Created on 2026/8/20.
//
//  The opal egg, rebuilt the way the reference image itself was authored:
//  a stack of REAL gaussian-blurred color layers clipped to an egg silhouette.
//  Every blurred layer is rasterized once (`drawingGroup`) and then only
//  translated / rotated / scaled by the slow liquid drift, so the per-frame
//  cost is a handful of cached-texture transforms. A Metal grain pass
//  (`miEggGrain`) adds the frosted-latex micro-texture, and the star-dust
//  stage stays fully procedural in `miSparkleField`.
//
//  Layers, bottom to top (all clipped to MiEggShape):
//  base lavender shell -> blue field -> rainbow rim strip -> rose wash ->
//  periwinkle belly -> membrane whites (bloom, swirl, crown) -> inner white
//  light -> milky wall + glass edge. Outside the clip: hazy halo, dawn glow,
//  contact shadow.
//

import SwiftUI

/// The egg silhouette: half-width factor w(y) = 0.795 + 0.06y - 0.045y^2,
/// y down in -1...1 — a plump crown easing into a classic egg taper.
private struct MiEggShape: InsettableShape {
    var insetAmount: CGFloat = 0

    func inset(by amount: CGFloat) -> MiEggShape {
        var shape = self
        shape.insetAmount += amount
        return shape
    }

    func path(in rect: CGRect) -> Path {
        let r = rect.insetBy(dx: insetAmount, dy: insetAmount)
        guard r.width > 0, r.height > 0 else { return Path() }
        let cx = r.midX, cy = r.midY
        let hw = r.width / 2, hh = r.height / 2
        let wMax = 0.817
        var points: [CGPoint] = []
        let n = 220
        for i in 0..<n {
            let u = Double(i) / Double(n) * 2 * .pi
            let y = cos(u)
            let w = 0.80 + 0.045 * y - 0.03 * y * y
            let x = w * sin(u) / wMax
            points.append(CGPoint(x: cx + x * hw, y: cy + y * hh))
        }
        var path = Path()
        path.addLines(points)
        path.closeSubpath()
        return path
    }
}

struct MiHoloEggView: View {
    static let eggSize = CGSize(width: 260, height: 322)
    /// Stage room around the egg so the glows and shadow are not clipped.
    static let stageSize = CGSize(width: 340, height: 430)

    let time: Float
    /// 1 full effect; lower tames the grain and star field
    /// (Reduce Transparency / Increase Contrast).
    let strength: Float
    var zoomed: Bool = false
    var reduceMotion: Bool = false

    var body: some View {
        let w = Self.eggSize.width
        let h = Self.eggSize.height
        let bob: CGFloat = reduceMotion ? 0 : CGFloat(sin(time * 0.9)) * 3.5

        ZStack {
            // contact shadow, tinted to the violet stage (never pure black)
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: 0x1C0A33).opacity(0.38), .clear],
                        center: .center, startRadius: 2, endRadius: w * 0.4
                    )
                )
                .frame(width: w * 0.78, height: h * 0.16)
                .blur(radius: 10)
                .drawingGroup()
                .offset(y: h * 0.52)
                .scaleEffect(zoomed ? 1.16 : 1)
                .opacity(zoomed ? 0.8 : 1)

            ZStack {
                outerGlows
                haze
                eggBody
            }
            .offset(y: bob)
            .scaleEffect(zoomed ? 1.42 : 1)
        }
        .frame(width: Self.stageSize.width, height: Self.stageSize.height)
    }

    // MARK: outer light

    // The dawn glow leaning well past the lower-right silhouette, and a faint
    // cool answer upper left.
    private var outerGlows: some View {
        let w = Self.eggSize.width
        return ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: 0xF0A874).opacity(0.55), .clear],
                        center: .center, startRadius: 4, endRadius: w * 0.52
                    )
                )
                .frame(width: w * 1.05, height: w * 1.05)
                .offset(x: w * 0.34, y: w * 0.34)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: 0x9FD8FF).opacity(0.22), .clear],
                        center: .center, startRadius: 4, endRadius: w * 0.4
                    )
                )
                .frame(width: w * 0.72, height: w * 0.72)
                .offset(x: -w * 0.24, y: -w * 0.12)
        }
        // raster bounds must cover the glow's full reach, or the drawingGroup
        // edge clips it into a visible rectangle
        .frame(width: Self.stageSize.width + 180, height: Self.stageSize.height + 180)
        .blur(radius: 22)
        .drawingGroup()
    }

    // The hazy halo hugging the whole silhouette. The padding keeps the blur
    // tail inside the drawingGroup raster (no rectangle cut).
    private var haze: some View {
        MiEggShape()
            .stroke(Color.white.opacity(0.6), lineWidth: 10)
            .frame(width: Self.eggSize.width + 12, height: Self.eggSize.height + 12)
            .padding(48)
            .blur(radius: 16)
            .drawingGroup()
    }

    // MARK: the egg

    // The shell exists everywhere EXCEPT the bitten openings, which are
    // erased to full transparency. The erasure is confined inside the
    // silhouette (inset 12) so the rim wall always stays whole.
    private func shellMask(w: CGFloat, h: CGFloat, t: Double) -> some View {
        ZStack {
            Rectangle().fill(Color.white)
            ZStack {
                Ellipse()
                    .fill(Color.black)
                    .frame(width: w * 0.52, height: h * 0.62)
                    .rotationEffect(.degrees(-12 + 2 * sin(t * 0.06)))
                    .blur(radius: 20)
                    .offset(x: -w * 0.26 + 6 * sin(t * 0.10),
                            y: -h * 0.04 + 8 * sin(t * 0.083 + 1.7))
                Capsule()
                    .fill(Color.black)
                    .frame(width: w * 0.16, height: h * 0.46)
                    .rotationEffect(.degrees(5 + 2 * sin(t * 0.075 + 0.9)))
                    .blur(radius: 16)
                    .offset(x: w * 0.34 + 4 * sin(t * 0.07 + 2.0),
                            y: -h * 0.02 + 6 * cos(t * 0.09))
            }
            .compositingGroup()
            .mask(MiEggShape().inset(by: 18).fill(Color.white).blur(radius: 12))
            .blendMode(.destinationOut)
        }
        .compositingGroup()
    }

    // Everything that lives UNDER the glass: base milk, inner light, blooms,
    // color fields, liquid whites, pearl clouds.
    private func innerContent(w: CGFloat, h: CGFloat, t: Double) -> some View {
        ZStack {
            // base shell: lavender milk deepening toward the belly
            MiEggShape()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: Color(hex: 0xEAE3F5), location: 0.0),
                            .init(color: Color(hex: 0xDDD2F0), location: 0.5),
                            .init(color: Color(hex: 0xBBA9E3), location: 1.0)
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                )

            // the white light source inside the egg (under the colors: it
            // lifts the milk without diluting the color cores)
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [Color.white.opacity(0.5), .clear],
                        center: .center, startRadius: 2, endRadius: w * 0.5
                    )
                )
                .frame(width: w * 0.95, height: w * 0.95)
                .offset(x: -w * 0.02, y: -h * 0.08)

            // membrane whites that live UNDER the color fields
            Ellipse()   // broad lit bloom, upper center-left
                .fill(Color.white.opacity(0.65))
                .frame(width: w * 0.60, height: h * 0.44)
                .blur(radius: 34)
                .drawingGroup()
                .scaleEffect(1 + 0.025 * sin(t * 0.05))
                .offset(x: -w * 0.06 + 3 * sin(t * 0.045),
                        y: -h * 0.20 + 3 * cos(t * 0.06))
            Ellipse()   // whitened crown
                .fill(Color.white.opacity(0.5))
                .frame(width: w * 0.55, height: h * 0.20)
                .blur(radius: 22)
                .drawingGroup()
                .offset(y: -h * 0.385)

            // periwinkle pooling at the belly (stage violet soaked in)
            Ellipse()
                .fill(Color(hex: 0x9C8AD6).opacity(0.66))
                .frame(width: w * 0.62, height: h * 0.36)
                .blur(radius: 30)
                .drawingGroup()
                .offset(x: 5 * sin(t * 0.06 + 3.1),
                        y: h * 0.30 + 3 * cos(t * 0.05))

            // rose wash glowing through the shell, upper right
            Ellipse()
                .fill(Color(hex: 0xEFB8D8).opacity(0.4))
                .frame(width: w * 0.5, height: h * 0.34)
                .blur(radius: 30)
                .drawingGroup()
                .offset(x: w * 0.19 + 5 * sin(t * 0.055 + 0.8),
                        y: -h * 0.25 + 4 * cos(t * 0.075 + 2.2))

            // the blue field: fills the left half like the reference — azure
            // shoulder sinking through cobalt into royal, bleeding off the
            // left rim so only the shell wall parts it from the stage
            Ellipse()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: Color(hex: 0x6FAAF4), location: 0.0),
                            .init(color: Color(hex: 0x2E5FE8), location: 0.5),
                            .init(color: Color(hex: 0x1E3FD8), location: 1.0)
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .frame(width: w * 0.60, height: h * 0.72)
                .rotationEffect(.degrees(-12 + 2 * sin(t * 0.06)))
                .blur(radius: 22)
                .drawingGroup()
                .offset(x: -w * 0.26 + 6 * sin(t * 0.10),
                        y: -h * 0.04 + 8 * sin(t * 0.083 + 1.7))

            // light soaking through the blue: an azure hot zone on its
            // upper-right shoulder, tracking the same drift
            Ellipse()
                .fill(Color(hex: 0x8FC2F8).opacity(0.65))
                .frame(width: w * 0.26, height: h * 0.30)
                .blur(radius: 18)
                .drawingGroup()
                .offset(x: -w * 0.12 + 6 * sin(t * 0.10),
                        y: -h * 0.16 + 8 * sin(t * 0.083 + 1.7))

            // the rainbow strip hugging the right rim: cyan, magenta, orange,
            // yellow, green kneaded by the blur
            Capsule()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: Color(hex: 0x7ECFF0), location: 0.00),
                            .init(color: Color(hex: 0xF23D96), location: 0.30),
                            .init(color: Color(hex: 0xF2903A), location: 0.55),
                            .init(color: Color(hex: 0xF2DA33), location: 0.72),
                            .init(color: Color(hex: 0x6FCC42), location: 1.00)
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .frame(width: w * 0.165, height: h * 0.50)
                .rotationEffect(.degrees(5 + 2 * sin(t * 0.075 + 0.9)))
                .blur(radius: 15)
                .drawingGroup()
                .offset(x: w * 0.34 + 4 * sin(t * 0.07 + 2.0),
                        y: -h * 0.02 + 6 * cos(t * 0.09))

            // ---- bite edges: each color field is a piece bitten out of the
            //      shell — a bright shell lip around the opening and a
            //      recessed shadow along its lit (upper-left) side ----
            Ellipse()
                .stroke(Color.white.opacity(0.42), lineWidth: 9)
                .frame(width: w * 0.60, height: h * 0.72)
                .rotationEffect(.degrees(-12 + 2 * sin(t * 0.06)))
                .padding(20)
                .blur(radius: 8)
                .drawingGroup()
                .offset(x: -w * 0.26 + 6 * sin(t * 0.10),
                        y: -h * 0.04 + 8 * sin(t * 0.083 + 1.7))
            Ellipse()
                .stroke(Color(hex: 0x2B2566).opacity(0.28), lineWidth: 13)
                .frame(width: w * 0.55, height: h * 0.66)
                .rotationEffect(.degrees(-12 + 2 * sin(t * 0.06)))
                .padding(20)
                .blur(radius: 11)
                .drawingGroup()
                .offset(x: -w * 0.26 + 6 * sin(t * 0.10),
                        y: -h * 0.04 + 8 * sin(t * 0.083 + 1.7))
                .mask(
                    LinearGradient(
                        stops: [
                            .init(color: .white, location: 0.0),
                            .init(color: .white.opacity(0.0), location: 0.55)
                        ],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
            Capsule()
                .stroke(Color.white.opacity(0.38), lineWidth: 7)
                .frame(width: w * 0.19, height: h * 0.52)
                .rotationEffect(.degrees(5 + 2 * sin(t * 0.075 + 0.9)))
                .padding(16)
                .blur(radius: 7)
                .drawingGroup()
                .offset(x: w * 0.34 + 4 * sin(t * 0.07 + 2.0),
                        y: -h * 0.02 + 6 * cos(t * 0.09))
            Capsule()
                .stroke(Color(hex: 0x4A2E66).opacity(0.24), lineWidth: 9)
                .frame(width: w * 0.17, height: h * 0.48)
                .rotationEffect(.degrees(5 + 2 * sin(t * 0.075 + 0.9)))
                .padding(16)
                .blur(radius: 9)
                .drawingGroup()
                .offset(x: w * 0.34 + 4 * sin(t * 0.07 + 2.0),
                        y: -h * 0.02 + 6 * cos(t * 0.09))
                .mask(
                    LinearGradient(
                        stops: [
                            .init(color: .white, location: 0.0),
                            .init(color: .white.opacity(0.0), location: 0.55)
                        ],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )

            // the whites that flow OVER the colors: the bright liquid column
            // parting blue from the strip, and the frosted light-source disc
            Capsule()
                .fill(Color.white.opacity(0.55))
                .frame(width: w * 0.28, height: h * 0.54)
                .rotationEffect(.degrees(14 + 3 * sin(t * 0.05)))
                .blur(radius: 30)
                .drawingGroup()
                .offset(x: w * 0.06 + 4 * sin(t * 0.08 + 1.2),
                        y: h * 0.02 + 5 * cos(t * 0.065 + 0.4))

            // the visible inner light: a soft-edged frosted disc, upper center
            Ellipse()
                .fill(Color.white.opacity(0.9))
                .frame(width: w * 0.30, height: w * 0.30)
                .blur(radius: 15)
                .drawingGroup()
                .scaleEffect(1 + 0.03 * sin(t * 0.06))
                .offset(x: -w * 0.03 + 2 * sin(t * 0.05),
                        y: -h * 0.20 + 2 * cos(t * 0.055))

            // mother-of-pearl depth: faint clouds adrift in the milk
            Ellipse()
                .fill(Color(hex: 0xEDE6F8).opacity(0.22))
                .frame(width: w * 0.55, height: h * 0.40)
                .blur(radius: 38)
                .drawingGroup()
                .offset(x: w * 0.02 + 4 * sin(t * 0.05 + 0.6),
                        y: h * 0.05 + 4 * cos(t * 0.06 + 1.9))
            Ellipse()
                .fill(Color.white.opacity(0.14))
                .frame(width: w * 0.45, height: h * 0.30)
                .blur(radius: 34)
                .drawingGroup()
                .offset(x: -w * 0.15 + 4 * sin(t * 0.045 + 2.8),
                        y: h * 0.30 + 3 * cos(t * 0.05 + 0.7))

        }
        .saturation(1.06)
    }

    private var eggBody: some View {
        let w = Self.eggSize.width
        let h = Self.eggSize.height
        let t = Double(time)

        return ZStack {
            innerContent(w: w, h: h, t: t)

            // Everything below is SHELL SURFACE. It is erased to 100%
            // transparency over the bitten openings (shellMask), so the
            // exposed color inside stays completely bare.
            Group {
            // REAL frosted-glass diffusion: the same content re-blurred,
            // lifted and gently desaturated, laid back over itself — the
            // optics of light scattering in the shell, strongest toward the
            // rim where the glass path is longest
            innerContent(w: w, h: h, t: t)
                .blur(radius: 16)
                .saturation(0.85)
                .brightness(0.05)
                .opacity(0.50)
                .mask(
                    RadialGradient(
                        stops: [
                            .init(color: .white.opacity(0.30), location: 0.0),
                            .init(color: .white.opacity(0.40), location: 0.60),
                            .init(color: .white, location: 1.0)
                        ],
                        center: UnitPoint(x: 0.5, y: 0.46),
                        startRadius: w * 0.1,
                        endRadius: w * 0.62
                    )
                )

            // a whisper of frost unifying the surface
            MiEggShape()
                .fill(Color.white.opacity(0.04))

            // glass-surface sheen: one broad diagonal reflection band
            Capsule()
                .fill(Color.white.opacity(0.10))
                .frame(width: w * 1.05, height: h * 0.26)
                .rotationEffect(.degrees(-28))
                .blur(radius: 26)
                .drawingGroup()
                .offset(x: -w * 0.04, y: -h * 0.24)

            // ---- shell wall: transparent thickness, built inside out ----

            // stage violet bleeding through the rim (the transparency cue;
            // the egg stays opaque, the shell look carries it). Masked off the
            // crown: the top rim stays clean milk like the reference.
            MiEggShape()
                .strokeBorder(Color(hex: 0xA13FD9).opacity(0.26), lineWidth: 12)
                .blur(radius: 9)
                .drawingGroup()
                .mask(
                    LinearGradient(
                        stops: [
                            .init(color: .white.opacity(0.15), location: 0.0),
                            .init(color: .white, location: 0.45)
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                )

            // wide soft milky wall
            MiEggShape()
                .strokeBorder(Color.white.opacity(0.35), lineWidth: 15)
                .blur(radius: 12)
                .drawingGroup()

            // faint dark ring marking the wall's inner boundary (refraction),
            // soft enough to be felt rather than seen
            MiEggShape()
                .inset(by: 6)
                .strokeBorder(Color(hex: 0x5B2E8F).opacity(0.10), lineWidth: 2.5)
                .blur(radius: 3.5)

            // luminous wall cross-section
            MiEggShape()
                .strokeBorder(Color.white.opacity(0.55), lineWidth: 5)
                .blur(radius: 4)

            // glass line at the silhouette
            MiEggShape()
                .strokeBorder(Color.white.opacity(0.6), lineWidth: 1.4)
                .blur(radius: 0.8)

            // crown edge catch-light: the key light grazing the top of the wall
            MiEggShape()
                .strokeBorder(Color.white.opacity(0.85), lineWidth: 3)
                .blur(radius: 2)
                .mask(
                    LinearGradient(
                        stops: [
                            .init(color: .white, location: 0.0),
                            .init(color: .white.opacity(0.0), location: 0.42)
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                )

            // light pooling along the bottom inner rim (through-the-shell glow)
            MiEggShape()
                .inset(by: 3)
                .strokeBorder(Color(hex: 0xF2ECFF).opacity(0.55), lineWidth: 8)
                .blur(radius: 7)
                .drawingGroup()
                .mask(
                    LinearGradient(
                        stops: [
                            .init(color: .white.opacity(0.0), location: 0.62),
                            .init(color: .white, location: 1.0)
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                )
            }
            .compositingGroup()
            .mask(shellMask(w: w, h: h, t: t))
        }
        .compositingGroup()
        .clipShape(MiEggShape())
        .colorEffect(ShaderLibrary.miEggGrain(.float(0.028 * strength)))
        .frame(width: w, height: h)
    }
}
