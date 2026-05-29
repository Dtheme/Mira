//
//  MiGlassmorphismHomePreview.swift
//  Mira
//
//  Created on 2026/5/25.
//

import SwiftUI

struct MiGlassmorphismHomePreview: View {
    let style: MiDesignStyle
    let focus: MiCardFocus
    let cardSize: CGSize
    let cornerRadius: CGFloat
    let isDragging: Bool

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        ZStack(alignment: .topLeading) {
            MiGlassmorphismHomeBackground(shape: shape, focus: focus)

            MiGlassmorphismFloatingLens(focus: focus, isDragging: isDragging)
                .frame(width: cardSize.width * 0.58, height: cardSize.height * 0.54)
                .offset(x: cardSize.width * 0.35, y: cardSize.height * 0.18)

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 8) {
                    MiGlassmorphismBadge()

                    Text(MiL10n.text(style.name))
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiGlassmorphismTokens.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.66)
                        .miStyleTitleTransition(style.id)
                }

                Text(MiL10n.text("home_glass_short"))
                    .font(.system(size: 11.8, weight: .semibold, design: .rounded))
                    .lineSpacing(2.4)
                    .foregroundStyle(MiGlassmorphismTokens.ink.opacity(0.78))
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)

                MiGlassmorphismHomeMetrics(isDragging: isDragging)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 22)
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .clipShape(shape)
        .overlay {
            shape
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.96),
                            MiGlassmorphismTokens.cyan.opacity(0.32 + focus.borderOpacity * 0.54),
                            MiGlassmorphismTokens.violet.opacity(0.18),
                            Color.white.opacity(0.38)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.35
                )
        }
        .overlay(alignment: .topLeading) {
            shape
                .strokeBorder(Color.white.opacity(0.32 + focus.borderOpacity * 0.20), lineWidth: 5)
                .blendMode(.screen)
                .padding(1.5)
        }
        .shadow(color: MiGlassmorphismTokens.cyan.opacity(focus.shadowOpacity * 0.36), radius: isDragging ? 8 : 24, x: 0, y: isDragging ? 5 : 14)
        .shadow(color: MiGlassmorphismTokens.blue.opacity(focus.shadowOpacity * 0.24), radius: isDragging ? 10 : 28, x: 0, y: isDragging ? 7 : 18)
        .shadow(color: Color(hex: 0x75859C).opacity(focus.shadowOpacity * 0.28), radius: isDragging ? 12 : 30, x: 0, y: isDragging ? 8 : 20)
    }
}

private struct MiGlassmorphismHomeBackground: View {
    let shape: RoundedRectangle
    let focus: MiCardFocus

    var body: some View {
        shape
            .fill(
                LinearGradient(
                    colors: [
                        Color(hex: 0xF9FEFF),
                        MiGlassmorphismTokens.cyan.opacity(0.24 + focus.borderOpacity * 0.12),
                        MiGlassmorphismTokens.blue.opacity(0.18),
                        MiGlassmorphismTokens.violet.opacity(0.24)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(alignment: .topTrailing) {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                MiGlassmorphismTokens.cyan.opacity(0.62),
                                MiGlassmorphismTokens.blue.opacity(0.18),
                                .clear
                            ],
                            center: .center,
                            startRadius: 4,
                            endRadius: 96
                        )
                    )
                    .frame(width: 132, height: 132)
                    .offset(x: 30, y: -34)
            }
            .overlay(alignment: .bottomLeading) {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                MiGlassmorphismTokens.violet.opacity(0.48),
                                MiGlassmorphismTokens.mint.opacity(0.18),
                                .clear
                            ],
                            center: .center,
                            startRadius: 8,
                            endRadius: 112
                        )
                    )
                    .frame(width: 154, height: 154)
                    .offset(x: -46, y: 42)
            }
            .overlay(alignment: .topLeading) {
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.70),
                        Color.white.opacity(0.18),
                        .clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
    }
}

private struct MiGlassmorphismFloatingLens: View {
    let focus: MiCardFocus
    let isDragging: Bool

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(isDragging ? 0.42 : 0.54),
                            Color.white.opacity(0.20),
                            MiGlassmorphismTokens.cyan.opacity(0.16)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(alignment: .topLeading) {
                    Capsule(style: .continuous)
                        .fill(Color.white.opacity(0.82))
                        .frame(width: 54, height: 8)
                        .rotationEffect(.degrees(-34))
                        .offset(x: 18, y: 23)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 34, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.96),
                                    MiGlassmorphismTokens.cyan.opacity(0.58),
                                    Color.white.opacity(0.22)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.35
                        )
                }
                .shadow(color: MiGlassmorphismTokens.blue.opacity(focus.shadowOpacity * 0.34), radius: isDragging ? 8 : 18, x: 0, y: isDragging ? 5 : 13)

            HStack(spacing: 6) {
                MiGlassmorphismMiniPill(width: 26, color: MiGlassmorphismTokens.cyan)
                MiGlassmorphismMiniPill(width: 18, color: MiGlassmorphismTokens.blue)
                MiGlassmorphismMiniPill(width: 22, color: MiGlassmorphismTokens.violet)
            }
            .padding(13)
        }
    }
}

private struct MiGlassmorphismBadge: View {
    var body: some View {
        Text("G")
            .font(.system(size: 11, weight: .black, design: .rounded))
            .foregroundStyle(MiGlassmorphismTokens.ink)
            .frame(width: 30, height: 30)
            .background {
                Circle()
                    .fill(Color.white.opacity(0.66))
                    .overlay {
                        Circle()
                            .strokeBorder(Color.white.opacity(0.96), lineWidth: 1)
                    }
            }
    }
}

private struct MiGlassmorphismHomeMetrics: View {
    let isDragging: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            MiGlassmorphismHomeMetric(labelKey: "home_glass_frost", value: isDragging ? "42%" : "58%")
            MiGlassmorphismHomeMetric(labelKey: "home_glass_depth", value: "3L")
            MiGlassmorphismHomeMetric(labelKey: "home_glass_edge", value: MiL10n.text("glass_high"))
        }
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.46))
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.84), lineWidth: 1)
                }
        }
    }
}

private struct MiGlassmorphismHomeMetric: View {
    let labelKey: String
    let value: String

    var body: some View {
        HStack(spacing: 8) {
            Text(MiL10n.text(labelKey).uppercased())
                .font(.system(size: 8.8, weight: .black, design: .rounded))
                .foregroundStyle(MiGlassmorphismTokens.muted)
                .tracking(0.5)
                .lineLimit(1)

            Spacer(minLength: 6)

            Text(value)
                .font(.system(size: 10, weight: .black, design: .rounded))
                .foregroundStyle(MiGlassmorphismTokens.ink)
                .padding(.horizontal, 7)
                .frame(height: 20)
                .background {
                    Capsule(style: .continuous)
                        .fill(Color.white.opacity(0.62))
                }
        }
    }
}

private struct MiGlassmorphismMiniPill: View {
    let width: CGFloat
    let color: Color

    var body: some View {
        Capsule(style: .continuous)
            .fill(color.opacity(0.42))
            .frame(width: width, height: 8)
            .overlay {
                Capsule(style: .continuous)
                    .strokeBorder(Color.white.opacity(0.9), lineWidth: 0.8)
            }
    }
}
