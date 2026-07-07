//
//  MiEditorialLuxeHomePreview.swift
//  Mira
//

import SwiftUI

struct MiEditorialLuxeHomePreview: View {
    let style: MiDesignStyle
    let focus: MiCardFocus
    let cardSize: CGSize
    let cornerRadius: CGFloat
    let isDragging: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.miHomePressedStyleID) private var pressedStyleID

    private typealias EdT = MiEditorialLuxeTokens
    private var isPressed: Bool { pressedStyleID == style.id && !isDragging }
    private var scale: CGFloat { cardSize.width / 174 }
    private var monogramSize: CGFloat { min(cardSize.height * 0.415, 116) }

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        let frameInset = 9 * scale
        let ruleBaseWidth = cardSize.width - frameInset * 2 - 24 * scale
        let ruleWidth = (isPressed && !reduceMotion) ? ruleBaseWidth + 10 * scale : ruleBaseWidth

        ZStack {
            shape.fill(EdT.paper)

            // Inner bookplate frame: deliberately sharp-cornered for a print feel.
            ZStack {
                Rectangle()
                    .strokeBorder(EdT.ink.opacity(0.30), lineWidth: 0.75)

                VStack(spacing: 0) {
                    Text(MiL10n.text("ed_feature_kicker_1"))
                        .font(.system(size: 8.5, weight: .semibold))
                        .tracking(1.6)
                        .foregroundStyle(EdT.gold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .padding(.top, 12 * scale)

                    Spacer(minLength: 8 * scale)

                    // Engraved rule runs behind the monogram so it shows through the counters.
                    ZStack {
                        Rectangle()
                            .fill(EdT.gold.opacity(isPressed ? 1.0 : 0.65))
                            .frame(width: ruleWidth, height: 0.75)

                        Text(MiL10n.text("home_ed_monogram"))
                            .font(EdT.serif(monogramSize, .regular).italic())
                            .foregroundStyle(EdT.ink)
                            .fixedSize()
                    }
                    .frame(height: monogramSize * 0.86)

                    Text(MiL10n.text(style.name))
                        .font(EdT.serif(17, .regular))
                        .foregroundStyle(EdT.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                        .miStyleTitleTransition(style.id)
                        .padding(.top, 7 * scale)

                    Spacer(minLength: 8 * scale)

                    HStack(spacing: 6) {
                        Rectangle().fill(EdT.gold).frame(width: 12 * scale, height: 0.75)
                        Text(MiL10n.text("home_ed_folio"))
                            .font(.system(size: 9.5, weight: .semibold, design: .monospaced))
                            .foregroundStyle(EdT.gold)
                        Rectangle().fill(EdT.gold).frame(width: 12 * scale, height: 0.75)
                    }
                    .padding(.bottom, 11 * scale)
                }
                .padding(.horizontal, 13 * scale)
            }
            .padding(frameInset)
            .scaleEffect(isPressed && !reduceMotion ? 0.985 : 1)
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .clipShape(shape)
        .overlay {
            shape.strokeBorder(
                EdT.hairline.opacity(0.55 + focus.borderOpacity * 0.45),
                lineWidth: 1
            )
        }
        .animation(reduceMotion ? .easeOut(duration: 0.01) : .easeOut(duration: 0.18), value: isPressed)
    }
}
