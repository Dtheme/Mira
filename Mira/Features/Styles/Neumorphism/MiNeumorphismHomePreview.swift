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
                shadowScale: boardShadowScale,
                borderOpacity: focus.borderOpacity,
                isPressed: isPressed
            )

            ZStack {
                knob
                textBlock
            }
            .frame(width: cardSize.width, height: cardSize.height)
            .offset(pressedContentOffset)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .animation(
            reduceMotion ? .easeOut(duration: 0.01) : .spring(response: 0.18, dampingFraction: 0.82),
            value: isPressed
        )
    }

    // MARK: - Signature knob

    private var knob: some View {
        ZStack {
            groove
            dial.offset(pressedDialOffset)
        }
        .position(x: cardSize.width * 0.5, y: cardSize.height * 0.40)
    }

    private var groove: some View {
        Circle()
            .fill(MiNeumorphismTokens.baseInset)
            .frame(width: grooveDiameter, height: grooveDiameter)
            .overlay { grooveCarving }
    }

    // Inner-shadow carving uses blur + mask (GPU heavy). Render it only at rest;
    // while the constellation is panning, drop it for a cheap flat inset stroke.
    @ViewBuilder
    private var grooveCarving: some View {
        let circle = Circle()

        if isDragging {
            circle.strokeBorder(MiNeumorphismTokens.shadowDark.opacity(0.16), lineWidth: 1.5)
        } else {
            ZStack {
                circle
                    .stroke(MiNeumorphismTokens.shadowDark.opacity(0.50), lineWidth: 2)
                    .blur(radius: 3)
                    .offset(x: 3, y: 3)
                    .mask {
                        circle.fill(
                            LinearGradient(
                                colors: [.clear, .black.opacity(0.84)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    }

                circle
                    .stroke(MiNeumorphismTokens.shadowLight.opacity(0.92), lineWidth: 2)
                    .blur(radius: 3)
                    .offset(x: -3, y: -3)
                    .mask {
                        circle.fill(
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

    private var dial: some View {
        Circle()
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
            .frame(width: dialDiameter, height: dialDiameter)
            .shadow(
                color: MiNeumorphismTokens.shadowDark.opacity(0.62),
                radius: max(2, 12 * knobShadowScale),
                x: 7 * knobShadowScale,
                y: 7 * knobShadowScale
            )
            .shadow(
                color: MiNeumorphismTokens.shadowLight.opacity(0.95),
                radius: max(2, 11 * knobShadowScale),
                x: -7 * knobShadowScale,
                y: -7 * knobShadowScale
            )
            .overlay {
                Circle()
                    .strokeBorder(
                        LinearGradient(
                            colors: [Color.white.opacity(0.55), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
            .overlay { indicatorDot }
    }

    private var indicatorDot: some View {
        Circle()
            .fill(MiNeumorphismTokens.focusAccent)
            .frame(width: dotSize, height: dotSize)
            .shadow(color: MiNeumorphismTokens.shadowDark.opacity(0.30), radius: 2, x: 1.5, y: 1.5)
            .shadow(color: Color.white.opacity(0.70), radius: 2, x: -1.5, y: -1.5)
            .offset(x: dotOffset, y: dotOffset)
    }

    // MARK: - Text block

    private var textBlock: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(MiL10n.text("neu_soft_ui"))
                .font(.system(size: kickerSize, weight: .medium, design: .rounded))
                .foregroundStyle(MiNeumorphismTokens.quietText)
                .tracking(1.4)
                .textCase(.uppercase)

            Text(MiL10n.text(style.name))
                .font(.system(size: titleSize, weight: .semibold, design: .rounded))
                .foregroundStyle(MiNeumorphismTokens.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.62)
                .miStyleTitleTransition(style.id)
        }
        .padding(textPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
    }

    // MARK: - State

    private var isPressed: Bool {
        pressedStyleID == style.id && !isDragging
    }

    private var baseShadowScale: CGFloat {
        let focusScale = 0.64 + CGFloat(focus.shadowOpacity) * 1.12
        let dragScale = isDragging ? MiNeumorphismTokens.dragShadowScale : 1
        return focusScale * dragScale
    }

    private var boardShadowScale: CGFloat {
        baseShadowScale * (isPressed ? 0.42 : 1)
    }

    private var knobShadowScale: CGFloat {
        baseShadowScale * (isPressed ? 0.30 : 1)
    }

    private var pressedContentOffset: CGSize {
        guard isPressed, !reduceMotion else {
            return .zero
        }
        return CGSize(width: 1.5, height: 1.5)
    }

    private var pressedDialOffset: CGSize {
        guard isPressed, !reduceMotion else {
            return .zero
        }
        return CGSize(width: 1, height: 1)
    }

    // MARK: - Metrics

    private var dialDiameter: CGFloat {
        cardSize.width * 0.58
    }

    private var grooveDiameter: CGFloat {
        dialDiameter + 18
    }

    private var dotSize: CGFloat {
        7 * cardSize.width / 174
    }

    private var dotOffset: CGFloat {
        -0.707 * 0.62 * dialDiameter * 0.5
    }

    private var textPadding: CGFloat {
        cardSize.width < 180 ? 16 : 18
    }

    private var kickerSize: CGFloat {
        cardSize.width < 180 ? 10.5 : 11
    }

    private var titleSize: CGFloat {
        cardSize.width < 180 ? 17 : 19
    }
}

private struct MiNeumorphismRaisedSurface: View {
    let cornerRadius: CGFloat
    let shadowScale: CGFloat
    let borderOpacity: Double
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
                color: MiNeumorphismTokens.shadowDark.opacity(isPressed ? 0.40 : 0.80),
                radius: max(4, MiNeumorphismTokens.outerShadow * shadowScale),
                x: 11 * shadowScale,
                y: 11 * shadowScale
            )
            .shadow(
                color: MiNeumorphismTokens.shadowLight.opacity(isPressed ? 0.60 : 0.94),
                radius: max(4, (MiNeumorphismTokens.outerShadow - 1) * shadowScale),
                x: -11 * shadowScale,
                y: -11 * shadowScale
            )
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.22),
                                .clear,
                                MiNeumorphismTokens.shadowDark.opacity(0.04)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.60),
                                MiNeumorphismTokens.stroke.opacity(0.55),
                                MiNeumorphismTokens.shadowDark.opacity(0.18)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
                    .opacity(borderOpacity)
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
