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

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        ZStack {
            shape
                .fill(MiRefinedDarkTokens.surface)
                .overlay {
                    shape.fill(
                        RadialGradient(
                            colors: [MiRefinedDarkTokens.accent.opacity(isPressed ? 0.26 : 0.16), .clear],
                            center: .init(x: 0.82, y: 0.0),
                            startRadius: 0,
                            endRadius: 150
                        )
                    )
                }
                .shadow(color: Color.black.opacity(0.3), radius: isDragging ? 8 : 16, x: 0, y: 10)

            VStack(alignment: .leading, spacing: 11) {
                HStack(spacing: 9) {
                    Text("RD")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(width: 36, height: 28)
                        .background {
                            RoundedRectangle(cornerRadius: 9, style: .continuous)
                                .fill(LinearGradient(colors: [MiRefinedDarkTokens.accent, MiRefinedDarkTokens.accentDeep], startPoint: .topLeading, endPoint: .bottomTrailing))
                        }

                    Text(MiL10n.text(style.name))
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiRefinedDarkTokens.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .miStyleTitleTransition(style.id)
                }

                Text(MiL10n.text("home_rd_short"))
                    .font(.system(size: 11.5, weight: .regular, design: .rounded))
                    .foregroundStyle(MiRefinedDarkTokens.muted)
                    .lineSpacing(2)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)

                // Mini status row
                HStack(spacing: 6) {
                    Circle().fill(MiRefinedDarkTokens.accent).frame(width: 7, height: 7)
                        .shadow(color: MiRefinedDarkTokens.accent.opacity(0.7), radius: 4)
                    Text(MiL10n.text("rd_status_progress"))
                        .font(.system(size: 10.5, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiRefinedDarkTokens.ink)
                    Spacer(minLength: 0)
                    Text("64%")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundStyle(MiRefinedDarkTokens.muted)
                }

                // Thin progress bar
                GeometryReader { geo in
                    Capsule().fill(MiRefinedDarkTokens.surfaceRaised)
                        .overlay(alignment: .leading) {
                            Capsule()
                                .fill(LinearGradient(colors: [MiRefinedDarkTokens.accent, MiRefinedDarkTokens.accentDeep], startPoint: .leading, endPoint: .trailing))
                                .frame(width: geo.size.width * 0.64)
                                .shadow(color: MiRefinedDarkTokens.accent.opacity(0.5), radius: 4)
                        }
                }
                .frame(height: 5)
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
                    colors: [Color.white.opacity(0.14), MiRefinedDarkTokens.accent.opacity(0.12 + focus.borderOpacity * 0.2), MiRefinedDarkTokens.hairline],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1
            )
        }
        .animation(reduceMotion ? .easeOut(duration: 0.01) : .easeOut(duration: 0.18), value: isPressed)
    }
}
