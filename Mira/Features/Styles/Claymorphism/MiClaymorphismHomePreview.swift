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
        let s = cardSize.width / 174
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        ZStack {
            shape
                .fill(
                    LinearGradient(
                        colors: [
                            MiClaymorphismTokens.surfaceLight,
                            MiClaymorphismTokens.background
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay {
                    Circle()
                        .fill(MiClaymorphismTokens.lilac.opacity(0.40))
                        .frame(width: 140 * s, height: 140 * s)
                        .offset(x: 72 * s, y: -92 * s)
                        .allowsHitTesting(false)
                }
                .shadow(
                    color: MiClaymorphismTokens.shadowLight.opacity(0.85),
                    radius: (isDragging ? 8 : 18) * s,
                    x: (isPressed ? -5 : -10) * s,
                    y: (isPressed ? -5 : -10) * s
                )
                .shadow(
                    color: MiClaymorphismTokens.shadowDark.opacity(focus.shadowOpacity * 0.60 * (isPressed ? 0.6 : 1)),
                    radius: (isDragging ? 9 : 24) * s,
                    x: (isPressed ? 7 : 14) * s,
                    y: (isPressed ? 9 : 18) * s
                )

            ZStack {
                VStack(alignment: .leading, spacing: 3 * s) {
                    Text(MiL10n.text(style.name))
                        .font(.system(size: 20 * s, weight: .black, design: .rounded))
                        .foregroundStyle(MiClaymorphismTokens.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.62)
                        .miStyleTitleTransition(style.id)

                    Text(MiL10n.text("home_clay_hook"))
                        .font(.system(size: 11 * s, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiClaymorphismTokens.muted)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal, 18 * s)
                .padding(.top, 18 * s)

                clayBall(s: s)
                    .offset(y: ballCenterOffsetY)

                crumb(color: MiClaymorphismTokens.mint, diameter: 14 * s, s: s)
                    .offset(x: 72 * s, y: ballCenterOffsetY + 38 * s)

                crumb(color: MiClaymorphismTokens.butter, diameter: 9 * s, s: s)
                    .offset(x: 56 * s, y: ballCenterOffsetY + 50 * s)
            }
            .offset(y: isPressed && !reduceMotion ? 1.5 * s : 0)
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .clipShape(shape)
        .overlay {
            shape
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.72),
                            MiClaymorphismTokens.shadowDark.opacity(0.16 + focus.borderOpacity * 0.20)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
        .animation(reduceMotion ? .easeOut(duration: 0.01) : .spring(response: 0.24, dampingFraction: 0.58), value: isPressed)
    }

    private var isPressed: Bool {
        pressedStyleID == style.id && !isDragging
    }

    // Ball center sits at 140/222 of the card height (0.63): the load-bearing anchor.
    private var ballCenterOffsetY: CGFloat {
        cardSize.height * (140.0 / 222.0 - 0.5)
    }

    private func clayBall(s: CGFloat) -> some View {
        let squash = isPressed && !reduceMotion

        return Ellipse()
            .fill(
                LinearGradient(
                    colors: [
                        MiClaymorphismTokens.peachLight,
                        MiClaymorphismTokens.peach,
                        MiClaymorphismTokens.peachDeep
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 124 * s, height: 102 * s)
            .shadow(
                color: MiClaymorphismTokens.shadowLight.opacity(isPressed ? 0.35 : 0.90),
                radius: (isPressed ? 6 : (isDragging ? 6 : 14)) * s,
                x: (isPressed ? -3 : -8) * s,
                y: (isPressed ? -3 : -8) * s
            )
            .shadow(
                color: MiClaymorphismTokens.shadowDark.opacity(isPressed ? 0.26 : 0.55 * focus.shadowOpacity),
                radius: (isPressed ? 8 : (isDragging ? 8 : 18)) * s,
                x: (isPressed ? 4 : 10) * s,
                y: (isPressed ? 6 : 14) * s
            )
            .overlay {
                if !isDragging {
                    ballPuff(s: s)
                }
            }
            .overlay {
                thumbDent(s: s)
                    .offset(x: -8 * s, y: -16 * s)
            }
            .scaleEffect(x: squash ? 1.06 : 1, y: squash ? 0.92 : 1, anchor: .bottom)
    }

    // Blur+mask is GPU heavy; the puff renders only at rest — while panning the
    // gradient plus dual outer shadows still read as clay.
    private func ballPuff(s: CGFloat) -> some View {
        ZStack {
            Ellipse()
                .stroke(Color.white.opacity(0.50), lineWidth: 6 * s)
                .blur(radius: 5 * s)
                .offset(x: -4 * s, y: -5 * s)
                .mask(Ellipse())

            Ellipse()
                .stroke(MiClaymorphismTokens.shadowDark.opacity(0.14), lineWidth: 5 * s)
                .blur(radius: 6 * s)
                .offset(x: 5 * s, y: 6 * s)
                .mask(Ellipse())
        }
    }

    private func thumbDent(s: CGFloat) -> some View {
        ZStack {
            Ellipse()
                .fill(MiClaymorphismTokens.dentClay)

            if isDragging {
                Ellipse()
                    .strokeBorder(MiClaymorphismTokens.shadowDark.opacity(0.35), lineWidth: 1)
            } else {
                Ellipse()
                    .stroke(MiClaymorphismTokens.shadowDark.opacity(isPressed ? 0.88 : 0.62), lineWidth: 4 * s)
                    .blur(radius: 3 * s)
                    .offset(x: 2.5 * s, y: 3.5 * s)
                    .mask(Ellipse())

                Ellipse()
                    .stroke(Color.white.opacity(0.55), lineWidth: 3 * s)
                    .blur(radius: 2 * s)
                    .offset(x: -2 * s, y: -2.5 * s)
                    .mask(Ellipse())
            }
        }
        .frame(width: 44 * s, height: 34 * s)
        .scaleEffect(isPressed && !reduceMotion ? 1.12 : 1)
    }

    private func crumb(color: Color, diameter: CGFloat, s: CGFloat) -> some View {
        Circle()
            .fill(color)
            .frame(width: diameter, height: diameter)
            .shadow(
                color: MiClaymorphismTokens.shadowDark.opacity(0.35),
                radius: (isDragging ? 2 : 3) * s,
                x: 2 * s,
                y: 3 * s
            )
    }
}
