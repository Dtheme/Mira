//
//  MiGlassmorphismHomePreview.swift
//  Mira
//
//  Glassmorphism home style card: a frosted specimen slide tilted +4 deg over a
//  saturated aurora field, with a dim echo pane behind it for layered depth.
//

import SwiftUI

struct MiGlassmorphismHomePreview: View {
    let style: MiDesignStyle
    let focus: MiCardFocus
    let cardSize: CGSize
    let cornerRadius: CGFloat
    let isDragging: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.miHomePressedStyleID) private var pressedStyleID

    private var isPressed: Bool { pressedStyleID == style.id && !isDragging }
    // Pick-up press effects that reduced motion suppresses (pane scale + echo gap);
    // rim and fill brightening stay on so layer hierarchy still reads.
    private var isLifted: Bool { isPressed && !reduceMotion }
    private var k: CGFloat { cardSize.width / 174 }

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        ZStack {
            auroraField(shape: shape)

            echoPane
                .position(x: cardSize.width * 0.62, y: cardSize.height * 0.34)

            specimenPane
                .position(x: cardSize.width * 0.48, y: cardSize.height * 0.60)
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .clipShape(shape)
        .overlay {
            shape.strokeBorder(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.85),
                        MiGlassmorphismTokens.cyan.opacity(0.30 + focus.borderOpacity * 0.35),
                        MiGlassmorphismTokens.violet.opacity(0.18),
                        Color.white.opacity(0.30)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1.1
            )
        }
        .shadow(
            color: MiGlassmorphismTokens.blue.opacity(focus.shadowOpacity * (isDragging ? 0.22 : 0.28)),
            radius: isDragging ? 8 : 22,
            x: 0,
            y: isDragging ? 6 : 14
        )
        .shadow(
            color: MiGlassmorphismTokens.violet.opacity(isDragging ? 0 : focus.shadowOpacity * 0.16),
            radius: 26,
            x: 0,
            y: 18
        )
        .animation(
            reduceMotion ? .easeOut(duration: 0.01) : .spring(response: 0.32, dampingFraction: 0.8),
            value: isPressed
        )
    }

    // MARK: Aurora field

    private func auroraField(shape: RoundedRectangle) -> some View {
        shape
            .fill(
                LinearGradient(
                    colors: [
                        MiGlassmorphismTokens.fieldCyan,
                        MiGlassmorphismTokens.fieldBlue,
                        MiGlassmorphismTokens.fieldViolet
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(alignment: .topLeading) {
                poolCircle(MiGlassmorphismTokens.cyan.opacity(0.85), diameter: 150 * k)
                    .offset(x: -20 * k, y: -26 * k)
            }
            .overlay(alignment: .bottomTrailing) {
                poolCircle(MiGlassmorphismTokens.poolViolet.opacity(0.75), diameter: 190 * k)
                    .offset(x: 38 * k, y: 44 * k)
            }
            .overlay(alignment: .leading) {
                poolCircle(MiGlassmorphismTokens.mint.opacity(0.6), diameter: 70 * k)
                    .offset(x: -22 * k, y: cardSize.height * 0.12)
            }
            .overlay(alignment: .top) {
                LinearGradient(
                    colors: [Color.white.opacity(0.30), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: cardSize.height * 0.40)
            }
    }

    private func poolCircle(_ color: Color, diameter: CGFloat) -> some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [color, .clear],
                    center: .center,
                    startRadius: 1,
                    endRadius: diameter / 2
                )
            )
            .frame(width: diameter, height: diameter)
    }

    // MARK: Echo pane

    private var echoPane: some View {
        let echoShape = RoundedRectangle(cornerRadius: 22 * k, style: .continuous)

        return echoShape
            .fill(Color.white.opacity(isLifted ? 0.18 : 0.13))
            .overlay {
                echoShape.strokeBorder(Color.white.opacity(0.32), lineWidth: 1)
            }
            .frame(width: cardSize.width * 0.60, height: cardSize.height * 0.36)
            .rotationEffect(.degrees(4))
            .offset(x: isLifted ? 3 * k : 0, y: isLifted ? -3 * k : 0)
    }

    // MARK: Front specimen pane

    private var specimenPane: some View {
        let paneW = cardSize.width * 0.82
        let paneH = cardSize.height * 0.50
        let paneShape = RoundedRectangle(cornerRadius: 22 * k, style: .continuous)

        return paneShape
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(isPressed ? 0.50 : 0.44),
                        Color.white.opacity(0.16)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                ZStack(alignment: .topLeading) {
                    if isDragging {
                        Color.white.opacity(0.06)
                    } else {
                        // Frost pass: the field's pools re-drawn milked, as if
                        // color were diffusing through the glass body.
                        poolCircle(MiGlassmorphismTokens.cyan.opacity(0.28), diameter: 130 * k)
                            .position(x: paneW * 0.12, y: paneH * 0.08)
                        poolCircle(MiGlassmorphismTokens.poolViolet.opacity(0.24), diameter: 150 * k)
                            .position(x: paneW * 0.92, y: paneH * 0.96)
                        poolCircle(MiGlassmorphismTokens.mint.opacity(0.12), diameter: 80 * k)
                            .position(x: 0, y: paneH * 0.52)
                    }

                    Capsule(style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.55), Color.white.opacity(0)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 64 * k, height: 10 * k)
                        .rotationEffect(.degrees(-34))
                        .offset(x: 16 * k, y: 18 * k)
                }
                .clipShape(paneShape)
            }
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 3 * k) {
                    Text(MiL10n.text("home_glass_caption").uppercased())
                        .font(.system(size: 8.5 * k, weight: .heavy, design: .rounded))
                        .tracking(1.3)
                        .foregroundStyle(MiGlassmorphismTokens.ink.opacity(0.6))
                        .lineLimit(1)

                    Text(MiL10n.text(style.name))
                        .font(.system(size: 17 * k, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiGlassmorphismTokens.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .miStyleTitleTransition(style.id)
                }
                .padding(14 * k)
            }
            .overlay {
                paneShape.strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(isPressed ? 1.0 : 0.95),
                            MiGlassmorphismTokens.cyan.opacity(isPressed ? 0.75 : 0.55),
                            Color.white.opacity(isPressed ? 0.30 : 0.22)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.2
                )
            }
            .frame(width: paneW, height: paneH)
            .shadow(
                color: MiGlassmorphismTokens.blue.opacity(focus.shadowOpacity * 0.35),
                radius: isDragging ? 6 : 16,
                x: 0,
                y: isDragging ? 5 : 10
            )
            .scaleEffect(isLifted ? 1.02 : 1.0)
            .rotationEffect(.degrees(4))
    }
}
