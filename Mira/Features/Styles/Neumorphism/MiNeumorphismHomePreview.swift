//
//  MiNeumorphismHomePreview.swift
//  Mira
//
//  Created on 2026/5/23.
//

import SwiftUI

struct MiNeumorphismHomePreview: View {
    let style: MiDesignStyle
    let focus: MiCardFocus
    let cardSize: CGSize
    let cornerRadius: CGFloat
    let isDragging: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.miHomePressedStyleID) private var pressedStyleID

    var body: some View {
        ZStack {
            MiNeumorphismRaisedSurface(
                cornerRadius: cornerRadius,
                shadowScale: shadowScale,
                isPressed: isPressed
            )

            VStack(alignment: .leading, spacing: verticalSpacing) {
                HStack(alignment: .center, spacing: 10) {
                    MiNeumorphismBadge(shadowScale: shadowScale, isPressed: isPressed)

                    Text(MiL10n.text(style.name))
                        .font(.system(size: titleSize, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.62)

                    Spacer(minLength: 0)
                }

                Text(MiL10n.text("neu_card_summary"))
                    .font(.system(size: summarySize, weight: .medium, design: .rounded))
                    .foregroundStyle(MiNeumorphismTokens.muted)
                    .lineSpacing(2.0)
                    .lineLimit(4)
                    .minimumScaleFactor(0.72)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)

                MiNeumorphismInsetInputPreview(shadowScale: shadowScale)

                MiNeumorphismControlStrip(shadowScale: shadowScale, isPressed: isPressed)
            }
            .padding(cardPadding)
            .offset(pressedOffset)
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .animation(reduceMotion ? .easeOut(duration: 0.01) : .spring(response: 0.18, dampingFraction: 0.82), value: isPressed)
    }

    private var shadowScale: CGFloat {
        let focusScale = 0.64 + CGFloat(focus.shadowOpacity) * 1.12
        let dragScale = isDragging ? MiNeumorphismTokens.dragShadowScale : 1
        let pressScale: CGFloat = isPressed ? 0.42 : 1
        return focusScale * dragScale * pressScale
    }

    private var isPressed: Bool {
        pressedStyleID == style.id && !isDragging
    }

    private var pressedOffset: CGSize {
        guard isPressed, !reduceMotion else {
            return .zero
        }
        return CGSize(width: 1.5, height: 1.5)
    }

    private var cardPadding: CGFloat {
        cardSize.width < 180 ? 14 : 16
    }

    private var verticalSpacing: CGFloat {
        cardSize.height < 230 ? 10 : 12
    }

    private var titleSize: CGFloat {
        cardSize.width < 180 ? 17 : 18.5
    }

    private var summarySize: CGFloat {
        cardSize.width < 180 ? 12.4 : 13.1
    }
}

private struct MiNeumorphismRaisedSurface: View {
    let cornerRadius: CGFloat
    let shadowScale: CGFloat
    let isPressed: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        isPressed ? MiNeumorphismTokens.base : MiNeumorphismTokens.baseLight,
                        isPressed ? MiNeumorphismTokens.basePressed : MiNeumorphismTokens.base
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .shadow(
                color: MiNeumorphismTokens.shadowDark.opacity(isPressed ? 0.42 : 0.82),
                radius: max(4, MiNeumorphismTokens.outerShadow * shadowScale),
                x: (isPressed ? 4 : 11) * shadowScale,
                y: (isPressed ? 4 : 11) * shadowScale
            )
            .shadow(
                color: MiNeumorphismTokens.shadowLight.opacity(isPressed ? 0.60 : 0.94),
                radius: max(4, (MiNeumorphismTokens.outerShadow - 1) * shadowScale),
                x: (isPressed ? -3 : -11) * shadowScale,
                y: (isPressed ? -3 : -11) * shadowScale
            )
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(isPressed ? 0.42 : 0.62),
                                MiNeumorphismTokens.stroke.opacity(0.62),
                                MiNeumorphismTokens.shadowDark.opacity(isPressed ? 0.38 : 0.18)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(isPressed ? 0.06 : 0.26),
                                .clear,
                                MiNeumorphismTokens.shadowDark.opacity(isPressed ? 0.08 : 0.04)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .overlay {
                if isPressed {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.58),
                                    Color.white.opacity(0.20),
                                    Color.white.opacity(0.06),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.85
                        )
                        .blendMode(.screen)
                }
            }
    }
}

private struct MiNeumorphismBadge: View {
    let shadowScale: CGFloat
    let isPressed: Bool

    var body: some View {
        ZStack {
            MiNeumorphismRaisedSurface(
                cornerRadius: 14,
                shadowScale: shadowScale * 0.50,
                isPressed: isPressed
            )

            Text("NU")
                .font(.system(size: 11.5, weight: .bold, design: .rounded))
                .foregroundStyle(MiNeumorphismTokens.ink)
        }
        .frame(width: 42, height: 28)
    }
}

private struct MiNeumorphismInsetInputPreview: View {
    let shadowScale: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: MiNeumorphismTokens.smallRadius, style: .continuous)
            .fill(MiNeumorphismTokens.base)
            .frame(height: 48)
            .overlay(alignment: .leading) {
                HStack(spacing: 8) {
                    MiNeumorphismSoftDot(
                        fill: MiNeumorphismTokens.focusAccent.opacity(0.92),
                        size: 12,
                        shadowScale: shadowScale * 0.54
                    )

                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(MiNeumorphismTokens.muted.opacity(0.20))
                        .frame(width: 70, height: 6)

                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(MiNeumorphismTokens.focusAccent.opacity(0.34))
                        .frame(width: 26, height: 6)

                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 15)
            }
            .overlay {
                RoundedRectangle(cornerRadius: MiNeumorphismTokens.smallRadius, style: .continuous)
                    .stroke(MiNeumorphismTokens.shadowDark.opacity(0.50), lineWidth: 2)
                    .blur(radius: 3)
                    .offset(x: 3, y: 3)
                    .mask {
                        RoundedRectangle(cornerRadius: MiNeumorphismTokens.smallRadius, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [.clear, .black.opacity(0.84)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
            }
            .overlay {
                RoundedRectangle(cornerRadius: MiNeumorphismTokens.smallRadius, style: .continuous)
                    .stroke(MiNeumorphismTokens.shadowLight.opacity(0.92), lineWidth: 2)
                    .blur(radius: 3)
                    .offset(x: -3, y: -3)
                    .mask {
                        RoundedRectangle(cornerRadius: MiNeumorphismTokens.smallRadius, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [.black.opacity(0.86), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
            }
    }
}

private struct MiNeumorphismControlStrip: View {
    let shadowScale: CGFloat
    let isPressed: Bool

    var body: some View {
        HStack(spacing: 9) {
            MiNeumorphismSoftPill(
                width: 42,
                fill: MiNeumorphismTokens.focusAccent.opacity(0.78),
                shadowScale: shadowScale,
                isPressed: isPressed
            )
            MiNeumorphismSoftPill(
                width: 28,
                fill: MiNeumorphismTokens.baseLight,
                shadowScale: shadowScale,
                isPressed: false
            )
            MiNeumorphismSoftPill(
                width: 28,
                fill: MiNeumorphismTokens.base,
                shadowScale: shadowScale,
                isPressed: false
            )
            Spacer(minLength: 0)
            MiNeumorphismSoftDot(
                fill: MiNeumorphismTokens.baseLight,
                size: 22,
                shadowScale: shadowScale * 0.74
            )
        }
        .frame(height: 26)
    }
}

private struct MiNeumorphismSoftPill: View {
    let width: CGFloat
    let fill: Color
    let shadowScale: CGFloat
    let isPressed: Bool

    var body: some View {
        Capsule(style: .continuous)
            .fill(fill)
            .frame(width: width, height: 12)
            .shadow(
                color: MiNeumorphismTokens.shadowDark.opacity(isPressed ? 0.22 : 0.48),
                radius: max(2, 5 * shadowScale),
                x: (isPressed ? 1 : 4) * shadowScale,
                y: (isPressed ? 1 : 4) * shadowScale
            )
            .shadow(
                color: MiNeumorphismTokens.shadowLight.opacity(0.82),
                radius: max(2, 5 * shadowScale),
                x: (isPressed ? -1 : -4) * shadowScale,
                y: (isPressed ? -1 : -4) * shadowScale
            )
            .overlay {
                Capsule(style: .continuous)
                    .stroke(Color.white.opacity(0.34), lineWidth: 0.8)
            }
    }
}

private struct MiNeumorphismSoftDot: View {
    let fill: Color
    let size: CGFloat
    let shadowScale: CGFloat

    var body: some View {
        Circle()
            .fill(fill)
            .frame(width: size, height: size)
            .shadow(
                color: MiNeumorphismTokens.shadowDark.opacity(0.46),
                radius: max(2, 5 * shadowScale),
                x: 3.5 * shadowScale,
                y: 3.5 * shadowScale
            )
            .shadow(
                color: MiNeumorphismTokens.shadowLight.opacity(0.88),
                radius: max(2, 5 * shadowScale),
                x: -3.5 * shadowScale,
                y: -3.5 * shadowScale
            )
    }
}
