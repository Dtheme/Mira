//
//  MiRefinedDarkHomePreview.swift
//  Mira
//

import SwiftUI

struct MiRefinedDarkHomePreview: View {
    let style: MiDesignStyle
    let focus: MiCardFocus
    let cardSize: CGSize
    let cornerRadius: CGFloat
    let isDragging: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.miHomePressedStyleID) private var pressedStyleID

    private var isPressed: Bool { pressedStyleID == style.id && !isDragging }
    private var pressActive: Bool { isPressed && !reduceMotion }

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        ZStack {
            shape.fill(MiRefinedDarkTokens.base)

            LinearGradient(
                colors: [Color.white.opacity(0.04), .clear],
                startPoint: .top,
                endPoint: UnitPoint(x: 0.5, y: 0.35)
            )

            dotGrid

            RadialGradient(
                colors: [MiRefinedDarkTokens.accent.opacity(bloomOpacity), .clear],
                center: UnitPoint(x: 0.5, y: 0.36),
                startRadius: 0,
                endRadius: cardSize.width * 0.63
            )

            RadialGradient(
                colors: [MiRefinedDarkTokens.accent.opacity(isDragging ? 0.05 : 0.09), .clear],
                center: UnitPoint(x: 0.5, y: 0.52),
                startRadius: 0,
                endRadius: 80
            )

            commandBar
                .position(x: cardSize.width / 2, y: cardSize.height * 0.40)

            footer
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .clipShape(shape)
        .overlay {
            shape.strokeBorder(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.11 + focus.borderOpacity * 0.06),
                        Color.white.opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1
            )
        }
        .overlay(alignment: .top) {
            // Signature 1 pt top highlight line (see refined-dark Design.md card spec).
            LinearGradient(
                colors: [.clear, Color.white.opacity(0.30), .clear],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: 1)
            .padding(.horizontal, cornerRadius * 0.6)
            .padding(.top, 1)
        }
        .shadow(
            color: MiRefinedDarkTokens.cardShadow.opacity((isDragging ? 0.30 : 0.45) * focus.shadowOpacity),
            radius: isDragging ? 7 : 16,
            x: 0,
            y: 10
        )
        .scaleEffect(pressActive ? 0.985 : 1)
        .animation(.easeOut(duration: reduceMotion ? 0.01 : 0.16), value: isPressed)
    }

    // MARK: - Layers

    private var dotGrid: some View {
        Canvas { context, size in
            let topY: CGFloat = 14
            let bottomY = size.height * 0.40 - 26
            guard bottomY > topY else { return }
            let inset: CGFloat = 16
            let spacing: CGFloat = 13
            let dotRadius: CGFloat = 0.75
            var y = topY
            while y <= bottomY {
                // Row opacity decays linearly from 0.06 to 0 toward the command bar.
                let opacity = 0.06 * Double(1 - (y - topY) / (bottomY - topY))
                if opacity > 0.001 {
                    var x = inset
                    while x <= size.width - inset {
                        let rect = CGRect(
                            x: x - dotRadius,
                            y: y - dotRadius,
                            width: dotRadius * 2,
                            height: dotRadius * 2
                        )
                        context.fill(Path(ellipseIn: rect), with: .color(.white.opacity(opacity)))
                        x += spacing
                    }
                }
                y += spacing
            }
        }
        .allowsHitTesting(false)
    }

    private var commandBar: some View {
        let barShape = RoundedRectangle(cornerRadius: MiRefinedDarkTokens.smallRadius, style: .continuous)

        return HStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 1, style: .continuous)
                .fill(MiRefinedDarkTokens.accent)
                .frame(width: 2, height: 15)

            Text(MiL10n.text("rd_home_placeholder"))
                .font(.system(size: 11))
                .foregroundStyle(MiRefinedDarkTokens.muted)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Spacer(minLength: 6)

            Text(MiL10n.text("rd_home_cmdk"))
                .font(.system(size: 9.5, weight: .semibold, design: .monospaced))
                .foregroundStyle(MiRefinedDarkTokens.ink.opacity(0.85))
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(Color.white.opacity(0.06))
                        .overlay {
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .strokeBorder(Color.white.opacity(0.14), lineWidth: 1)
                        }
                }
        }
        .padding(.leading, 13)
        .padding(.trailing, 10)
        .frame(width: cardSize.width - 44, height: 40)
        .background { barShape.fill(barFill) }
        .overlay(alignment: .top) {
            // 1 pt inner highlight echoing the card-level top line.
            Rectangle()
                .fill(Color.white.opacity(0.22))
                .frame(height: 1)
                .padding(.horizontal, 10)
                .padding(.top, 1)
        }
        .overlay { barShape.strokeBorder(barBorder, lineWidth: 1) }
        .brightness(pressActive ? 0.04 : 0)
        .shadow(
            color: MiRefinedDarkTokens.accent.opacity(glowOpacity),
            radius: pressActive ? 14 : 12,
            x: 0,
            y: 5
        )
    }

    private var footer: some View {
        VStack(alignment: .leading, spacing: 12) {
            Rectangle()
                .fill(Color.white.opacity(0.07))
                .frame(height: 1)
                .overlay(alignment: .leading) {
                    Rectangle()
                        .fill(MiRefinedDarkTokens.accent.opacity(0.7))
                        .frame(width: 12, height: 1)
                }

            Text(MiL10n.text(style.name))
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundStyle(MiRefinedDarkTokens.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .miStyleTitleTransition(style.id)
        }
        .padding(.horizontal, 18)
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
    }

    // MARK: - Press / drag states

    private var barFill: AnyShapeStyle {
        if reduceMotion && isPressed {
            return AnyShapeStyle(MiRefinedDarkTokens.surfaceRaised)
        }
        return AnyShapeStyle(
            LinearGradient(
                colors: [MiRefinedDarkTokens.surfaceRaised, MiRefinedDarkTokens.surface],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    private var barBorder: LinearGradient {
        LinearGradient(
            colors: isPressed
                ? [MiRefinedDarkTokens.accent.opacity(0.9), MiRefinedDarkTokens.accent.opacity(0.4)]
                : [MiRefinedDarkTokens.accent.opacity(0.55), MiRefinedDarkTokens.accent.opacity(0.22)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var glowOpacity: Double {
        if isDragging { return 0 }
        return pressActive ? 0.45 : 0.30
    }

    private var bloomOpacity: Double {
        if isDragging { return 0.06 }
        return pressActive ? 0.14 : 0.10
    }
}
