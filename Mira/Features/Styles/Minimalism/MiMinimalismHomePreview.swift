//
//  MiMinimalismHomePreview.swift
//  Mira
//
//  Created on 2026/5/25.
//

import SwiftUI

struct MiMinimalismHomePreview: View {
    let style: MiDesignStyle
    let focus: MiCardFocus
    let cardSize: CGSize
    let cornerRadius: CGFloat
    let isDragging: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.miHomePressedStyleID) private var pressedStyleID

    private var isPressed: Bool { pressedStyleID == style.id && !isDragging }
    private var scale: CGFloat { cardSize.width / 174 }

    var body: some View {
        // Style exception: fixed sharp 8 pt shell overrides the shared corner radius.
        let shape = RoundedRectangle(cornerRadius: 8, style: .continuous)
        let lineX = cardSize.width * 0.127
        let lineY = cardSize.height * 0.26
        let contentLeading = lineX + 8 * scale
        let contentMaxWidth = cardSize.width - contentLeading - 14 * scale
        let numeralSize = cardSize.height * 0.50

        ZStack(alignment: .topLeading) {
            shape.fill(MiMinimalismTokens.paper)

            // Structural grid: margin column + title baseline. Never moves on press.
            Rectangle()
                .fill(MiMinimalismTokens.hairline)
                .frame(width: 1, height: cardSize.height)
                .position(x: lineX, y: cardSize.height / 2)

            Rectangle()
                .fill(MiMinimalismTokens.hairline)
                .frame(width: cardSize.width, height: 1)
                .position(x: cardSize.width / 2, y: lineY)

            Rectangle()
                .fill(MiMinimalismTokens.accent)
                .frame(width: 7 * scale, height: 7 * scale)
                .scaleEffect(isPressed ? 1.35 : 1)
                .position(x: lineX, y: lineY)

            ZStack(alignment: .topLeading) {
                Text(MiL10n.text("min_card_axes"))
                    .font(.system(size: 9, weight: .semibold))
                    .tracking(1.4)
                    .foregroundStyle(MiMinimalismTokens.muted)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .frame(maxWidth: contentMaxWidth, alignment: .leading)
                    .padding(.leading, contentLeading)
                    .padding(.top, 15 * scale)

                Text(MiL10n.text(style.name))
                    .font(.system(size: 25 * scale, weight: .semibold))
                    .tracking(-0.4)
                    .foregroundStyle(MiMinimalismTokens.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.62)
                    .miStyleTitleTransition(style.id)
                    .frame(maxWidth: contentMaxWidth, alignment: .leading)
                    .padding(.leading, contentLeading)
                    .padding(.top, lineY + 14 * scale)

                // Poster-scale issue numeral, cropped by the card edge. The extra
                // 0.24 * size offset cancels the font descent so the digit bodies
                // genuinely bleed past the bottom edge instead of resting on it.
                Text("01")
                    .font(.system(size: numeralSize, weight: .semibold))
                    .tracking(-3)
                    .foregroundStyle(MiMinimalismTokens.ink)
                    .fixedSize()
                    .offset(
                        x: cardSize.width * 0.057,
                        y: cardSize.height * 0.115 + numeralSize * 0.24
                    )
                    .frame(width: cardSize.width, height: cardSize.height, alignment: .bottomTrailing)
            }
            .offset(y: isPressed ? 1 : 0)
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .clipShape(shape)
        .overlay {
            shape.strokeBorder(
                MiMinimalismTokens.ink.opacity(isPressed ? 1.0 : 0.85 + focus.borderOpacity * 0.15),
                lineWidth: 1
            )
        }
        .shadow(
            color: MiMinimalismTokens.ink.opacity(focus.shadowOpacity * (isDragging ? 0.08 : 0.16)),
            radius: isDragging ? 3 : 10,
            x: 0,
            y: isDragging ? 2 : 7
        )
        .animation(reduceMotion ? .easeOut(duration: 0.01) : .easeOut(duration: 0.16), value: isPressed)
    }
}
