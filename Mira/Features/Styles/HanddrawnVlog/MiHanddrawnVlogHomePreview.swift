//
//  MiHanddrawnVlogHomePreview.swift
//  Mira
//
//  Hand-drawn Vlog / Vlog 手绘风 — home style card.
//  Signature: a hand-placed polaroid (warm film-photo + handwritten date) with a
//  procedural hand-drawn doodle, a washi-tape strip, a wavy underline, and one
//  corner sticker. Doodles are drawn with Path/Canvas (the brief explicitly asks
//  for hand-drawn expression); real photo / illustration assets can drop into the
//  photo slot later. One locked accent (dried rose). Warm-tinted shadows only.
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

    private var polaroidWidth: CGFloat { min(cardSize.width * 0.60, cardSize.width - 46) }
    private var photoHeight: CGFloat { polaroidWidth * 0.66 }

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        ZStack(alignment: .topLeading) {
            shape.fill(HV.cream)

            // Soft warm paper sheen, top-down — replaces heavy grain for performance.
            shape
                .fill(
                    LinearGradient(
                        colors: [HV.paper.opacity(0.9), .clear, HV.shadow.opacity(0.16)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .blendMode(.softLight)

            VStack(alignment: .leading, spacing: 9) {
                polaroid
                    .padding(.leading, 4)

                Spacer(minLength: 0)

                VStack(alignment: .leading, spacing: 4) {
                    Text(MiL10n.text(style.name))
                        .font(HV.hand(16, .semibold))
                        .italic()
                        .foregroundStyle(HV.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .miStyleTitleTransition(style.id)

                    MiHVWave()
                        .stroke(HV.rose, style: StrokeStyle(lineWidth: 2.2, lineCap: .round, lineJoin: .round))
                        .frame(width: polaroidWidth * 0.78, height: 6)
                        .opacity(0.9)
                }

                Text(MiL10n.text("home_hv_short"))
                    .font(HV.rounded(10.5, .medium))
                    .foregroundStyle(HV.pencil)
                    .lineSpacing(1.5)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 15)
            .padding(.top, 15)
            .padding(.bottom, 14)
            .offset(y: isPressed ? 1 : 0)
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .clipShape(shape)
        .overlay(alignment: .topTrailing) {
            cornerSticker
                .padding(.top, 12)
                .padding(.trailing, 13)
        }
        .overlay {
            shape.strokeBorder(
                LinearGradient(
                    colors: [
                        HV.rose.opacity(0.30 + focus.borderOpacity * 0.28),
                        HV.shadow.opacity(0.5)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1
            )
        }
        .animation(reduceMotion ? .easeOut(duration: 0.01) : .easeOut(duration: 0.2), value: isPressed)
    }

    // MARK: Polaroid

    private var polaroid: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 6) {
                // Film-photo placeholder: warm gradient + a hand-drawn sun + sparkles.
                RoundedRectangle(cornerRadius: HV.photoRadius, style: .continuous)
                    .fill(HV.photoGradient(0))
                    .frame(width: polaroidWidth, height: photoHeight)
                    .overlay(alignment: .topLeading) {
                        MiHVSun()
                            .stroke(HV.ink.opacity(0.8), style: StrokeStyle(lineWidth: 1.6, lineCap: .round, lineJoin: .round))
                            .frame(width: 22, height: 22)
                            .padding(.leading, 11)
                            .padding(.top, 10)
                    }
                    .overlay(alignment: .bottomTrailing) {
                        MiHVStar()
                            .fill(HV.paper.opacity(0.95))
                            .overlay {
                                MiHVStar().stroke(HV.ink.opacity(0.65), lineWidth: 1.1)
                            }
                            .frame(width: 13, height: 13)
                            .padding(.trailing, 12)
                            .padding(.bottom, 9)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: HV.photoRadius, style: .continuous))

                // Handwritten mat: date + heart.
                HStack(spacing: 4) {
                    Text("5.24")
                        .font(HV.hand(10, .semibold))
                        .italic()
                        .foregroundStyle(HV.pencil)
                    Spacer(minLength: 0)
                    MiHVHeart()
                        .fill(HV.rose)
                        .frame(width: 9, height: 9)
                }
                .frame(width: polaroidWidth)
            }
            .padding(.horizontal, 7)
            .padding(.top, 7)
            .padding(.bottom, 9)
            .background(
                RoundedRectangle(cornerRadius: HV.photoRadius + 3, style: .continuous)
                    .fill(HV.paper)
            )
            .overlay {
                RoundedRectangle(cornerRadius: HV.photoRadius + 3, style: .continuous)
                    .strokeBorder(HV.shadow.opacity(0.55), lineWidth: 1)
            }
            .shadow(color: HV.clay.opacity(0.22), radius: 6, x: 0, y: 4)
            .rotationEffect(.degrees(isPressed ? 0 : HV.photoTilt))

            // Washi tape across the top edge.
            Capsule(style: .continuous)
                .fill(HV.butter.opacity(0.72))
                .frame(width: 34, height: 13)
                .overlay {
                    Capsule(style: .continuous).strokeBorder(HV.butter.opacity(0.4), lineWidth: 1)
                }
                .rotationEffect(.degrees(-9))
                .offset(x: polaroidWidth * 0.18, y: -5)
        }
        .frame(width: polaroidWidth + 24, alignment: .leading)
    }

    // MARK: Corner sticker

    private var cornerSticker: some View {
        MiHVStar()
            .fill(HV.rose)
            .overlay { MiHVStar().stroke(HV.ink.opacity(0.7), lineWidth: 1.2) }
            .frame(width: 18, height: 18)
            .rotationEffect(.degrees(HV.stickerTilt))
            .shadow(color: HV.clay.opacity(0.18), radius: 2, x: 0, y: 1)
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
