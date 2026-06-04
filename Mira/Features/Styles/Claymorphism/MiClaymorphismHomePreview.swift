//
//  MiClaymorphismHomePreview.swift
//  Mira
//
//  Created on 2026/5/29.
//

import SwiftUI

struct MiClaymorphismHomePreview: View {
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
                            MiClaymorphismTokens.surfaceLight,
                            MiClaymorphismTokens.surface,
                            Color(hex: 0xF6E4FF)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(MiClaymorphismBlobField(focus: focus))
                .shadow(color: MiClaymorphismTokens.shadowLight.opacity(isPressed ? 0.46 : 0.88), radius: isDragging ? 8 : 18, x: isPressed ? -4 : -10, y: isPressed ? -4 : -10)
                .shadow(color: MiClaymorphismTokens.shadowDark.opacity(focus.shadowOpacity * (isPressed ? 0.32 : 0.66)), radius: isDragging ? 9 : 24, x: isPressed ? 5 : 14, y: isPressed ? 6 : 18)

            VStack(alignment: .leading, spacing: 11) {
                HStack(spacing: 9) {
                    MiClaymorphismHomeBadge(isPressed: isPressed)

                    Text(MiL10n.text(style.name))
                        .font(.system(size: 19, weight: .black, design: .rounded))
                        .foregroundStyle(MiClaymorphismTokens.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.62)
                        .miStyleTitleTransition(style.id)
                }

                Text(MiL10n.text("home_clay_short"))
                    .font(.system(size: 11.8, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.muted)
                    .lineSpacing(2.2)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)

                MiClaymorphismPuffyButtonPreview(isPressed: isPressed, compact: cardSize.width < 185, isDragging: isDragging)
                    .frame(maxWidth: .infinity, alignment: .center)

                HStack(spacing: 7) {
                    MiClaymorphismHomePill(titleKey: "home_clay_matte", fill: MiClaymorphismTokens.butter.opacity(0.78))
                    MiClaymorphismHomePill(titleKey: "home_clay_soft", fill: MiClaymorphismTokens.mint.opacity(0.76))

                    Spacer(minLength: 0)

                    Text(MiL10n.text("home_clay_press"))
                        .font(.system(size: 9.5, weight: .black, design: .rounded))
                        .foregroundStyle(MiClaymorphismTokens.ink)
                        .padding(.horizontal, 9)
                        .frame(height: 24)
                        .background {
                            Capsule(style: .continuous)
                                .fill(MiClaymorphismTokens.sky.opacity(0.78))
                                .overlay {
                                    Capsule(style: .continuous)
                                        .strokeBorder(Color.white.opacity(0.54), lineWidth: 1)
                                }
                        }
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 19)
            .padding(.bottom, 17)
            .offset(x: isPressed ? 1.2 : 0, y: isPressed ? 1.6 : 0)
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .clipShape(shape)
        .overlay {
            shape
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.72),
                            MiClaymorphismTokens.peach.opacity(0.18 + focus.borderOpacity * 0.24),
                            MiClaymorphismTokens.shadowDark.opacity(0.16)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.1
                )
        }
        .animation(reduceMotion ? .easeOut(duration: 0.01) : .spring(response: 0.22, dampingFraction: 0.72), value: isPressed)
    }

    private var isPressed: Bool {
        pressedStyleID == style.id && !isDragging
    }
}

private struct MiClaymorphismBlobField: View {
    let focus: MiCardFocus

    var body: some View {
        ZStack {
            Circle()
                .fill(MiClaymorphismTokens.lilac.opacity(0.48 + focus.borderOpacity * 0.10))
                .frame(width: 112, height: 112)
                .offset(x: 58, y: -70)

            Circle()
                .fill(MiClaymorphismTokens.mint.opacity(0.42))
                .frame(width: 96, height: 96)
                .offset(x: -72, y: 60)

            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(MiClaymorphismTokens.butter.opacity(0.42))
                .frame(width: 96, height: 64)
                .rotationEffect(.degrees(-12))
                .offset(x: 46, y: 54)
        }
        .allowsHitTesting(false)
    }
}

private struct MiClaymorphismHomeBadge: View {
    let isPressed: Bool

    var body: some View {
        Text("CL")
            .font(.system(size: 11, weight: .black, design: .rounded))
            .foregroundStyle(MiClaymorphismTokens.ink)
            .frame(width: 38, height: 30)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(MiClaymorphismTokens.mint)
                    .shadow(color: MiClaymorphismTokens.shadowLight.opacity(isPressed ? 0.40 : 0.86), radius: isPressed ? 4 : 9, x: isPressed ? -2 : -5, y: isPressed ? -2 : -5)
                    .shadow(color: MiClaymorphismTokens.shadowDark.opacity(isPressed ? 0.22 : 0.44), radius: isPressed ? 4 : 10, x: isPressed ? 3 : 6, y: isPressed ? 3 : 8)
            }
    }
}

private struct MiClaymorphismPuffyButtonPreview: View {
    let isPressed: Bool
    let compact: Bool
    let isDragging: Bool

    private var radius: CGFloat { compact ? 24 : 30 }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            MiClaymorphismTokens.coral.opacity(0.86),
                            MiClaymorphismTokens.peach,
                            MiClaymorphismTokens.butter.opacity(0.84)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: compact ? 116 : 132, height: compact ? 64 : 72)
                .shadow(color: MiClaymorphismTokens.shadowLight.opacity(isPressed ? 0.24 : 0.88), radius: isPressed ? 5 : 14, x: isPressed ? -2 : -8, y: isPressed ? -2 : -8)
                .shadow(color: MiClaymorphismTokens.shadowDark.opacity(isPressed ? 0.22 : 0.56), radius: isPressed ? 6 : 18, x: isPressed ? 4 : 10, y: isPressed ? 5 : 14)
                .overlay { puffyInnerShadow }

            Image(systemName: isPressed ? "hand.tap.fill" : "sparkles")
                .font(.system(size: compact ? 20 : 23, weight: .black))
                .foregroundStyle(MiClaymorphismTokens.ink.opacity(0.86))
        }
        .scaleEffect(isPressed ? 0.96 : 1)
    }

    // Dual masked inner shadows make the clay look puffy, but blur+mask is GPU heavy.
    // Skip it while the home canvas is panning — the gradient + outer shadows still
    // read as a clay button, and the blur is imperceptible during motion.
    @ViewBuilder
    private var puffyInnerShadow: some View {
        if !isDragging {
            let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)
            ZStack {
                shape
                    .stroke(Color.white.opacity(isPressed ? 0.16 : 0.46), lineWidth: 5)
                    .blur(radius: 4)
                    .offset(x: -3, y: -4)
                    .mask(shape)

                shape
                    .stroke(MiClaymorphismTokens.shadowDark.opacity(isPressed ? 0.24 : 0.12), lineWidth: 4)
                    .blur(radius: 5)
                    .offset(x: 4, y: 5)
                    .mask(shape)
            }
        }
    }
}

private struct MiClaymorphismHomePill: View {
    let titleKey: String
    let fill: Color

    var body: some View {
        Text(MiL10n.text(titleKey))
            .font(.system(size: 9.2, weight: .black, design: .rounded))
            .foregroundStyle(MiClaymorphismTokens.ink)
            .padding(.horizontal, 8)
            .frame(height: 22)
            .background {
                Capsule(style: .continuous)
                    .fill(fill)
                    .overlay {
                        Capsule(style: .continuous)
                            .strokeBorder(Color.white.opacity(0.48), lineWidth: 0.9)
                    }
            }
    }
}
