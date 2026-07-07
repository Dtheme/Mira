//
//  MiHanddrawnVlogHomePreview.swift
//  Mira
//
//  Hand-drawn Vlog / Vlog 手绘风 — home style card.
//  One oversized tilted polaroid taped to a cream diary page: faded-film photo
//  window with a hand-drawn sun / star / sea-horizon wave inside it, and the
//  style title handwritten on the mat as the caption (dried-rose heart at its
//  end — the single rose moment). A pencil date note sits on the empty page
//  below. Press flattens the print (-2.5° -> 0°, 1 pt nudge, tighter shadow).
//

import SwiftUI

struct MiHanddrawnVlogHomePreview: View {
    let style: MiDesignStyle
    let focus: MiCardFocus
    let cardSize: CGSize
    let cornerRadius: CGFloat
    let isDragging: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.miHomePressedStyleID) private var pressedStyleID

    private typealias HV = MiHanddrawnVlogTokens
    private var isPressed: Bool { pressedStyleID == style.id && !isDragging }
    private var scale: CGFloat { cardSize.width / 174 }

    // Reduced motion keeps the static idle tilt (layout, not motion) and skips
    // the spatial press response; only the shadow still softens as feedback.
    private var pressStraightens: Bool { isPressed && !reduceMotion }

    private var matWidth: CGFloat { cardSize.width * 0.80 }
    private var matPadding: CGFloat { 8 * scale }
    private var photoWidth: CGFloat { matWidth - matPadding * 2 }
    private var photoHeight: CGFloat { photoWidth * 0.90 }

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        ZStack(alignment: .top) {
            shape.fill(HV.cream)

            paperSheen(in: shape)

            polaroid
                .padding(.top, cardSize.height * 0.10)
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .overlay(alignment: .bottomLeading) { pageNote }
        .clipShape(shape)
        .overlay {
            shape.strokeBorder(
                HV.shadow.opacity(0.45 + focus.borderOpacity * 0.3),
                lineWidth: 1
            )
        }
        .animation(reduceMotion ? .easeOut(duration: 0.01) : .easeOut(duration: 0.2), value: isPressed)
    }

    // MARK: Paper sheen

    // Soft-light blend is the one offscreen pass on this card; while the home
    // canvas pans it falls back to a plain non-blended gradient overlay.
    @ViewBuilder
    private func paperSheen(in shape: RoundedRectangle) -> some View {
        let gradient = LinearGradient(
            colors: [HV.paper.opacity(0.9), .clear, HV.shadow.opacity(0.16)],
            startPoint: .top,
            endPoint: .bottom
        )
        if isDragging {
            shape.fill(gradient).opacity(0.35)
        } else {
            shape.fill(gradient).blendMode(.softLight)
        }
    }

    // MARK: Polaroid

    private var polaroid: some View {
        let matShape = RoundedRectangle(cornerRadius: HV.photoRadius + 2, style: .continuous)

        return ZStack(alignment: .top) {
            VStack(spacing: 0) {
                photoWindow
                captionStrip
            }
            .padding([.horizontal, .top], matPadding)
            .background(matShape.fill(HV.paper))
            .overlay {
                matShape.strokeBorder(HV.shadow.opacity(0.55), lineWidth: 1)
            }
            .shadow(
                color: HV.clay.opacity(focus.shadowOpacity * (isDragging ? 0.43 : (isPressed ? 0.64 : 0.79))),
                radius: (isDragging ? 3 : (isPressed ? 5 : 7)) * scale,
                x: 0,
                y: (isDragging ? 3 : (isPressed ? 4 : 5)) * scale
            )

            washiTape
                .offset(x: 10 * scale, y: -8 * scale)
        }
        .rotationEffect(.degrees(pressStraightens ? 0 : HV.homePolaroidTilt))
        .offset(y: pressStraightens ? 1 : 0)
    }

    // Faded-film photo whose content is a tiny hand-drawn postcard scene:
    // sun over a drawn sea horizon, one sparkle in the sky.
    private var photoWindow: some View {
        let photoShape = RoundedRectangle(cornerRadius: HV.photoRadius, style: .continuous)

        return photoShape
            .fill(HV.photoGradient(0))
            .frame(width: photoWidth, height: photoHeight)
            .overlay(alignment: .topLeading) {
                MiHVSun()
                    .stroke(HV.ink.opacity(0.75), style: StrokeStyle(lineWidth: 1.6 * scale, lineCap: .round, lineJoin: .round))
                    .frame(width: 24 * scale, height: 24 * scale)
                    .padding(.leading, 12 * scale)
                    .padding(.top, 12 * scale)
            }
            .overlay(alignment: .topTrailing) {
                MiHVStar()
                    .fill(HV.paper.opacity(0.95))
                    .overlay {
                        MiHVStar().stroke(HV.ink.opacity(0.6), lineWidth: 1.1 * scale)
                    }
                    .frame(width: 11 * scale, height: 11 * scale)
                    .padding(.trailing, 14 * scale)
                    .padding(.top, 16 * scale)
            }
            .overlay {
                MiHVWave()
                    .stroke(HV.ink.opacity(0.5), style: StrokeStyle(lineWidth: 1.4 * scale, lineCap: .round))
                    .frame(width: photoWidth * 0.90, height: 5 * scale)
                    .offset(y: photoHeight * 0.14)
            }
            .clipShape(photoShape)
    }

    // The mat caption: the style title as diary handwriting, one rose heart.
    private var captionStrip: some View {
        HStack(spacing: 0) {
            Text(MiL10n.text(style.name))
                .font(HV.hand(15 * scale, .semibold))
                .italic()
                .foregroundStyle(HV.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .miStyleTitleTransition(style.id)

            Spacer(minLength: 5 * scale)

            MiHVHeart()
                .fill(HV.rose)
                .frame(width: 9 * scale, height: 9 * scale)
        }
        .padding(.top, 7 * scale)
        .padding(.bottom, 10 * scale)
        .padding(.horizontal, 2 * scale)
        .frame(width: photoWidth)
    }

    private var washiTape: some View {
        let tapeShape = RoundedRectangle(cornerRadius: 2, style: .continuous)

        return tapeShape
            .fill(HV.butter.opacity(0.75))
            .overlay {
                tapeShape.strokeBorder(HV.butter.opacity(0.4), lineWidth: 1)
            }
            .frame(width: 44 * scale, height: 16 * scale)
            .rotationEffect(.degrees(-8))
    }

    // MARK: Page note

    private var pageNote: some View {
        HStack(spacing: 5 * scale) {
            Text("5.24")
                .font(HV.hand(10.5 * scale, .semibold))
                .italic()
                .foregroundStyle(HV.pencil)

            Text(MiL10n.text("hv_mem_cap_1"))
                .font(HV.hand(10.5 * scale, .medium))
                .italic()
                .foregroundStyle(HV.pencil.opacity(0.9))
                .lineLimit(1)
        }
        .padding(.leading, 18 * scale)
        .padding(.bottom, 14 * scale)
    }
}

// MARK: - Hand-drawn doodle shapes (shared across the style's views)

/// Wavy hand-drawn underline (gentle, slightly irregular sine).
struct MiHVWave: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midY = rect.midY
        let amplitude = rect.height * 0.5
        let steps = 28
        path.move(to: CGPoint(x: rect.minX, y: midY))
        for i in 1...steps {
            let t = CGFloat(i) / CGFloat(steps)
            let x = rect.minX + rect.width * t
            // 2.2 cycles, with a touch of decay for a hand-drawn feel.
            let y = midY - sin(t * .pi * 2.2) * amplitude * (1 - t * 0.18)
            path.addLine(to: CGPoint(x: x, y: y))
        }
        return path
    }
}

/// Four-point sparkle / sticker star (concave, on-axis points).
struct MiHVStar: Shape {
    func path(in rect: CGRect) -> Path {
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let outer = min(rect.width, rect.height) / 2
        let inner = outer * 0.34
        var path = Path()
        for i in 0..<8 {
            let angle = (.pi / 4) * CGFloat(i) - .pi / 2
            let r = i.isMultiple(of: 2) ? outer : inner
            let p = CGPoint(x: c.x + cos(angle) * r, y: c.y + sin(angle) * r)
            if i == 0 { path.move(to: p) } else { path.addLine(to: p) }
        }
        path.closeSubpath()
        return path
    }
}

/// Sun: circle body with radiating rays (single strokable path).
struct MiHVSun: Shape {
    func path(in rect: CGRect) -> Path {
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let bodyR = min(rect.width, rect.height) * 0.28
        var path = Path()
        path.addEllipse(in: CGRect(x: c.x - bodyR, y: c.y - bodyR, width: bodyR * 2, height: bodyR * 2))
        let rayInner = bodyR * 1.35
        let rayOuter = min(rect.width, rect.height) * 0.5
        for i in 0..<8 {
            let angle = (.pi / 4) * CGFloat(i)
            let p1 = CGPoint(x: c.x + cos(angle) * rayInner, y: c.y + sin(angle) * rayInner)
            let p2 = CGPoint(x: c.x + cos(angle) * rayOuter, y: c.y + sin(angle) * rayOuter)
            path.move(to: p1)
            path.addLine(to: p2)
        }
        return path
    }
}

/// Small heart for the handwritten mat.
struct MiHVHeart: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        path.move(to: CGPoint(x: w * 0.5, y: h * 0.95))
        path.addCurve(
            to: CGPoint(x: w * 0.02, y: h * 0.30),
            control1: CGPoint(x: w * 0.18, y: h * 0.72),
            control2: CGPoint(x: w * 0.02, y: h * 0.52)
        )
        path.addArc(
            center: CGPoint(x: w * 0.26, y: h * 0.28),
            radius: w * 0.24,
            startAngle: .degrees(165),
            endAngle: .degrees(-15),
            clockwise: false
        )
        path.addArc(
            center: CGPoint(x: w * 0.74, y: h * 0.28),
            radius: w * 0.24,
            startAngle: .degrees(195),
            endAngle: .degrees(15),
            clockwise: false
        )
        path.addCurve(
            to: CGPoint(x: w * 0.5, y: h * 0.95),
            control1: CGPoint(x: w * 0.98, y: h * 0.52),
            control2: CGPoint(x: w * 0.82, y: h * 0.72)
        )
        path.closeSubpath()
        return path
    }
}
