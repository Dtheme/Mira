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

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        ZStack {
            shape.fill(EdT.paper)

            VStack(alignment: .leading, spacing: 9) {
                HStack(spacing: 7) {
                    Rectangle().fill(EdT.gold).frame(width: 16, height: 1.5)
                    Text(MiL10n.text("ed_feature_kicker_1"))
                        .font(.system(size: 9, weight: .semibold, design: .default))
                        .tracking(1.2)
                        .foregroundStyle(EdT.gold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }

                Text(MiL10n.text(style.name))
                    .font(EdT.serif(22, .regular))
                    .foregroundStyle(EdT.ink)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                    .fixedSize(horizontal: false, vertical: true)
                    .miStyleTitleTransition(style.id)

                Text(MiL10n.text("home_ed_short"))
                    .font(.system(size: 11, weight: .regular, design: .default))
                    .foregroundStyle(EdT.muted)
                    .lineSpacing(2)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)

                Rectangle().fill(EdT.hairline).frame(height: 1)

                HStack {
                    Text(MiL10n.text("ed_feature_byline"))
                        .font(EdT.serif(11, .regular))
                        .italic()
                        .foregroundStyle(EdT.muted)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    Spacer(minLength: 0)
                    Text("No.01")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .foregroundStyle(EdT.gold)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 15)
            .offset(y: isPressed ? 1 : 0)
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .clipShape(shape)
        .overlay {
            shape.strokeBorder(
                LinearGradient(
                    colors: [EdT.gold.opacity(0.4 + focus.borderOpacity * 0.3), EdT.hairline],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1
            )
        }
        .animation(reduceMotion ? .easeOut(duration: 0.01) : .easeOut(duration: 0.18), value: isPressed)
    }
}
