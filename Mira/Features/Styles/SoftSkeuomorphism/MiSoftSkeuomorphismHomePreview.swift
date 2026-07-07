//
//  MiSoftSkeuomorphismHomePreview.swift
//  Mira
//
//  Created on 2026/5/29.
//

import SwiftUI

struct MiSoftSkeuomorphismHomePreview: View {
    let style: MiDesignStyle
    let focus: MiCardFocus
    let cardSize: CGSize
    let cornerRadius: CGFloat
    let isDragging: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.miHomePressedStyleID) private var pressedStyleID

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        let w = cardSize.width
        let h = cardSize.height
        let s = w / 174
        let shelfY = h * 0.70
        let poolSide = w * 0.62
        let contactSide = w * 0.34
        let lampHeight = w * 0.52 * 0.60 + 36 * s

        ZStack {
            LinearGradient(
                stops: [
                    .init(color: MiSoftSkeuomorphismTokens.creamLight, location: 0),
                    .init(color: MiSoftSkeuomorphismTokens.cream, location: 0.55),
                    .init(color: MiSoftSkeuomorphismTokens.cream, location: 0.70)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            RadialGradient(
                colors: [MiSoftSkeuomorphismTokens.peach.opacity(0.14), .clear],
                center: UnitPoint(x: 0.85, y: 0.06),
                startRadius: 0,
                endRadius: w * 0.50
            )

            RadialGradient(
                colors: [
                    MiSoftSkeuomorphismTokens.glow.opacity(isPressed ? 0.55 : 0.34),
                    MiSoftSkeuomorphismTokens.peach.opacity(isPressed ? 0.20 : 0.12),
                    .clear
                ],
                center: UnitPoint(x: 0.50, y: 0.46),
                startRadius: 0,
                endRadius: h * 0.46
            )

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            MiSoftSkeuomorphismTokens.cardDeep,
                            MiSoftSkeuomorphismTokens.shadow.opacity(0.92)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(MiSoftSkeuomorphismTokens.creamLight.opacity(0.85))
                        .frame(height: 1)
                }
                .frame(height: h * 0.30)
                .frame(maxHeight: .infinity, alignment: .bottom)

            // Squashed circular gradients stand in for blurred ellipses (no blur at idle).
            RadialGradient(
                colors: [MiSoftSkeuomorphismTokens.glow.opacity(isPressed ? 0.80 : 0.50), .clear],
                center: .center,
                startRadius: 0,
                endRadius: poolSide / 2
            )
            .frame(width: poolSide, height: poolSide)
            .scaleEffect(x: isPressed ? 1.08 : 1, y: 24 * s / poolSide)
            .position(x: w * 0.50, y: shelfY + 10 * s)

            RadialGradient(
                colors: [MiSoftSkeuomorphismTokens.warmShadow.opacity(0.30), .clear],
                center: .center,
                startRadius: 0,
                endRadius: contactSide / 2
            )
            .frame(width: contactSide, height: contactSide)
            .scaleEffect(x: 1, y: 10 * s / contactSide)
            .position(x: w * 0.50, y: shelfY + 2 * s)

            MiSoftSkeuomorphismHeroLamp(
                cardWidth: w,
                scaleFactor: s,
                isBlooming: isPressed,
                isDragging: isDragging
            )
            .scaleEffect(isPressed && !reduceMotion ? 1.02 : 1, anchor: .bottom)
            .position(x: w * 0.50, y: shelfY - lampHeight / 2)

            Text(MiL10n.text(style.name))
                .font(.system(size: 17.5 * s, weight: .semibold, design: .rounded))
                .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.62)
                .miStyleTitleTransition(style.id)
                .padding(.horizontal, 18 * s)
                .padding(.top, 18 * s)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            Text(MiL10n.text("home_softsk_nameplate"))
                .font(.system(size: 9.5 * s, weight: .medium, design: .rounded))
                .kerning(0.8)
                .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                .padding(.leading, 18 * s)
                .padding(.bottom, 13 * s)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .clipShape(shape)
        .overlay {
            shape
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            MiSoftSkeuomorphismTokens.highlight.opacity(0.75),
                            MiSoftSkeuomorphismTokens.warmShadow.opacity(0.12 + focus.borderOpacity * 0.10)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
        .shadow(
            color: MiSoftSkeuomorphismTokens.highlight.opacity(isPressed ? 0.40 : 0.74),
            radius: isDragging ? 8 : 18,
            x: -8,
            y: -8
        )
        .shadow(
            color: MiSoftSkeuomorphismTokens.shadow.opacity(focus.shadowOpacity * (isPressed ? 0.36 : 0.62)),
            radius: isDragging ? 10 : 24,
            x: 0,
            y: isDragging ? 8 : 18
        )
        .animation(reduceMotion ? .easeOut(duration: 0.01) : .spring(response: 0.30, dampingFraction: 0.80), value: isPressed)
    }

    private var isPressed: Bool {
        pressedStyleID == style.id && !isDragging
    }
}

// Card-only hero lamp; the shared MiSoftSkeuomorphismLampObject below stays for the detail view.
private struct MiSoftSkeuomorphismHeroLamp: View {
    let cardWidth: CGFloat
    let scaleFactor: CGFloat
    let isBlooming: Bool
    let isDragging: Bool

    var body: some View {
        let s = scaleFactor
        let domeWidth = cardWidth * 0.52
        let domeHeight = domeWidth * 0.60
        let stemHeight = 44 * s
        let overlap = 8 * s

        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 16 * s, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            MiSoftSkeuomorphismTokens.creamLight,
                            MiSoftSkeuomorphismTokens.card,
                            MiSoftSkeuomorphismTokens.peach.opacity(0.50)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: cardWidth * 0.20, height: stemHeight)
                .overlay(alignment: .topLeading) {
                    if !isDragging {
                        Capsule(style: .continuous)
                            .fill(MiSoftSkeuomorphismTokens.highlight.opacity(0.40))
                            .frame(width: 12 * s, height: 30 * s)
                            .blur(radius: 3)
                            .offset(x: 5 * s, y: 5 * s)
                    }
                }

            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [
                            MiSoftSkeuomorphismTokens.creamLight,
                            MiSoftSkeuomorphismTokens.butter.opacity(isBlooming ? 0.95 : 0.72),
                            MiSoftSkeuomorphismTokens.peach
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: domeWidth, height: domeHeight)
                .shadow(
                    color: MiSoftSkeuomorphismTokens.warmShadow.opacity(0.22),
                    radius: isDragging ? 5 : 12,
                    x: 0,
                    y: isDragging ? 4 : 8
                )
                .overlay {
                    Ellipse()
                        .strokeBorder(MiSoftSkeuomorphismTokens.highlight.opacity(0.70), lineWidth: 1)
                        .mask(alignment: .top) {
                            Rectangle().frame(height: domeHeight * 0.5)
                        }
                }
                .overlay(alignment: .bottom) {
                    if isDragging {
                        Capsule(style: .continuous)
                            .fill(MiSoftSkeuomorphismTokens.glow.opacity(0.5))
                            .frame(width: cardWidth * 0.36, height: 6 * s)
                            .offset(y: 1)
                    } else {
                        Capsule(style: .continuous)
                            .fill(MiSoftSkeuomorphismTokens.glow.opacity(isBlooming ? 0.85 : 0.55))
                            .frame(width: cardWidth * 0.36, height: 6 * s)
                            .blur(radius: 4)
                            .offset(y: 1)
                    }
                }
                .offset(y: -(stemHeight - overlap))
        }
        .frame(width: domeWidth, height: stemHeight + domeHeight - overlap, alignment: .bottom)
    }
}

struct MiSoftSkeuomorphismLampObject: View {
    let isBlooming: Bool
    let scale: CGFloat
    var isDragging: Bool = false

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            MiSoftSkeuomorphismTokens.glow.opacity(isBlooming ? 0.70 : 0.36),
                            MiSoftSkeuomorphismTokens.peach.opacity(isBlooming ? 0.30 : 0.16),
                            .clear
                        ],
                        center: .center,
                        startRadius: 8,
                        endRadius: 74
                    )
                )
                .frame(width: 142, height: 142)
                .offset(y: -8)

            VStack(spacing: -4) {
                Ellipse()
                    .fill(
                        LinearGradient(
                            colors: [
                                MiSoftSkeuomorphismTokens.creamLight,
                                MiSoftSkeuomorphismTokens.butter.opacity(isBlooming ? 0.92 : 0.70),
                                MiSoftSkeuomorphismTokens.peach
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 112, height: 66)
                    .overlay(alignment: .bottom) {
                        // Blurred shade glow — skip while panning (blur re-rasterizes per frame).
                        if !isDragging {
                            Capsule(style: .continuous)
                                .fill(MiSoftSkeuomorphismTokens.glow.opacity(isBlooming ? 0.56 : 0.26))
                                .frame(width: 84, height: 10)
                                .blur(radius: 5)
                                .offset(y: -2)
                        }
                    }
                    .shadow(color: MiSoftSkeuomorphismTokens.warmShadow.opacity(isBlooming ? 0.30 : 0.18), radius: 12, x: 0, y: 8)

                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                MiSoftSkeuomorphismTokens.creamLight,
                                MiSoftSkeuomorphismTokens.card,
                                MiSoftSkeuomorphismTokens.peach.opacity(0.56)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 52, height: 66)
                    .overlay(alignment: .topLeading) {
                        // Blurred specular highlight — skip while panning.
                        if !isDragging {
                            Capsule(style: .continuous)
                                .fill(MiSoftSkeuomorphismTokens.highlight.opacity(0.42))
                                .frame(width: 16, height: 38)
                                .blur(radius: 3)
                                .offset(x: 9, y: 7)
                        }
                    }
                    .shadow(color: MiSoftSkeuomorphismTokens.shadow.opacity(0.28), radius: 10, x: 0, y: 8)
            }
        }
        .scaleEffect(scale * (isBlooming ? 1.03 : 1))
        .accessibilityHidden(true)
    }
}
