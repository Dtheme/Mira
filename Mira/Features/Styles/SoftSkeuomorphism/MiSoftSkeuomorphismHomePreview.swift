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

        ZStack {
            shape
                .fill(
                    LinearGradient(
                        colors: [
                            MiSoftSkeuomorphismTokens.creamLight,
                            MiSoftSkeuomorphismTokens.cream,
                            MiSoftSkeuomorphismTokens.peach.opacity(0.34),
                            MiSoftSkeuomorphismTokens.moss.opacity(0.18)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(MiSoftSkeuomorphismAmbientField(focus: focus, isBlooming: isPressed))
                .shadow(color: MiSoftSkeuomorphismTokens.highlight.opacity(isPressed ? 0.40 : 0.74), radius: isDragging ? 8 : 18, x: -8, y: -8)
                .shadow(color: MiSoftSkeuomorphismTokens.shadow.opacity(focus.shadowOpacity * (isPressed ? 0.34 : 0.64)), radius: isDragging ? 10 : 24, x: 0, y: isDragging ? 8 : 18)

            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 9) {
                    MiSoftSkeuomorphismHomeBadge()

                    Text(MiL10n.text(style.name))
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.62)
                        .miStyleTitleTransition(style.id)
                }

                Text(MiL10n.text("home_softsk_short"))
                    .font(.system(size: 11.6, weight: .medium, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                    .lineSpacing(2.2)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)

                MiSoftSkeuomorphismLampObject(isBlooming: isPressed, scale: cardSize.width < 185 ? 0.78 : 0.86, isDragging: isDragging)
                    .frame(maxWidth: .infinity)
                    .frame(height: 92)

                HStack(spacing: 7) {
                    MiSoftSkeuomorphismHomePill(titleKey: "home_softsk_cream", fill: MiSoftSkeuomorphismTokens.creamLight)
                    MiSoftSkeuomorphismHomePill(titleKey: "home_softsk_moss", fill: MiSoftSkeuomorphismTokens.moss.opacity(0.62))

                    Spacer(minLength: 0)

                    Text(MiL10n.text(isPressed ? "softsk_bloom_on" : "softsk_bloom_idle"))
                        .font(.system(size: 9.5, weight: .black, design: .rounded))
                        .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                        .padding(.horizontal, 9)
                        .frame(height: 24)
                        .background {
                            Capsule(style: .continuous)
                                .fill(isPressed ? MiSoftSkeuomorphismTokens.butter.opacity(0.82) : MiSoftSkeuomorphismTokens.card)
                                .overlay {
                                    Capsule(style: .continuous)
                                        .strokeBorder(MiSoftSkeuomorphismTokens.highlight.opacity(0.68), lineWidth: 1)
                                }
                        }
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 19)
            .padding(.bottom, 17)
            .offset(y: isPressed ? 1.2 : 0)
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .clipShape(shape)
        .overlay {
            shape
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            MiSoftSkeuomorphismTokens.highlight.opacity(0.76),
                            MiSoftSkeuomorphismTokens.moss.opacity(0.16 + focus.borderOpacity * 0.20),
                            MiSoftSkeuomorphismTokens.shadow.opacity(0.12)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.1
                )
        }
        .animation(reduceMotion ? .easeOut(duration: 0.01) : .spring(response: 0.28, dampingFraction: 0.78), value: isPressed)
    }

    private var isPressed: Bool {
        pressedStyleID == style.id && !isDragging
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

private struct MiSoftSkeuomorphismAmbientField: View {
    let focus: MiCardFocus
    let isBlooming: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(MiSoftSkeuomorphismTokens.moss.opacity(0.20 + focus.borderOpacity * 0.08))
                .frame(width: 118, height: 118)
                .offset(x: 70, y: -72)

            Circle()
                .fill(MiSoftSkeuomorphismTokens.peach.opacity(isBlooming ? 0.38 : 0.24))
                .frame(width: 136, height: 136)
                .offset(x: -64, y: 64)

            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(MiSoftSkeuomorphismTokens.card.opacity(0.72))
                .frame(width: 112, height: 74)
                .rotationEffect(.degrees(-8))
                .offset(x: 54, y: 66)
        }
        .allowsHitTesting(false)
    }
}

private struct MiSoftSkeuomorphismHomeBadge: View {
    var body: some View {
        Text("SS")
            .font(.system(size: 11, weight: .black, design: .rounded))
            .foregroundStyle(MiSoftSkeuomorphismTokens.mossDeep)
            .frame(width: 38, height: 30)
            .background {
                Capsule(style: .continuous)
                    .fill(MiSoftSkeuomorphismTokens.creamLight.opacity(0.92))
                    .overlay {
                        Capsule(style: .continuous)
                            .strokeBorder(MiSoftSkeuomorphismTokens.moss.opacity(0.25), lineWidth: 1)
                    }
                    .shadow(color: MiSoftSkeuomorphismTokens.shadow.opacity(0.20), radius: 8, x: 0, y: 5)
            }
    }
}

private struct MiSoftSkeuomorphismHomePill: View {
    let titleKey: String
    let fill: Color

    var body: some View {
        Text(MiL10n.text(titleKey))
            .font(.system(size: 9.2, weight: .black, design: .rounded))
            .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
            .padding(.horizontal, 8)
            .frame(height: 22)
            .background {
                Capsule(style: .continuous)
                    .fill(fill)
                    .overlay {
                        Capsule(style: .continuous)
                            .strokeBorder(MiSoftSkeuomorphismTokens.highlight.opacity(0.58), lineWidth: 0.9)
                    }
            }
    }
}
