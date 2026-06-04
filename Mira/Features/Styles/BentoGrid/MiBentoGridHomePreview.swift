//
//  MiBentoGridHomePreview.swift
//  Mira
//

import SwiftUI

struct MiBentoGridHomePreview: View {
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
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white,
                            MiBentoGridTokens.canvas,
                            MiBentoGridTokens.accent.opacity(0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: MiBentoGridTokens.ink.opacity(isPressed ? 0.04 : 0.08), radius: isDragging ? 8 : 16, x: 0, y: isPressed ? 4 : 10)

            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 9) {
                    Text("BG")
                        .font(.system(size: 11, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(width: 38, height: 28)
                        .background {
                            RoundedRectangle(cornerRadius: 9, style: .continuous).fill(MiBentoGridTokens.accent)
                        }

                    Text(MiL10n.text(style.name))
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(MiBentoGridTokens.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .miStyleTitleTransition(style.id)
                }

                Text(MiL10n.text("home_bento_short"))
                    .font(.system(size: 11.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiBentoGridTokens.muted)
                    .lineSpacing(2)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)

                miniMosaic
            }
            .padding(.horizontal, 16)
            .padding(.top, 17)
            .padding(.bottom, 15)
            .offset(y: isPressed ? 1 : 0)
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .clipShape(shape)
        .overlay {
            shape.strokeBorder(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.9),
                        MiBentoGridTokens.accent.opacity(0.14 + focus.borderOpacity * 0.18),
                        MiBentoGridTokens.stroke
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1.1
            )
        }
        .animation(reduceMotion ? .easeOut(duration: 0.01) : .spring(response: 0.26, dampingFraction: 0.8), value: isPressed)
    }

    private var miniMosaic: some View {
        Grid(horizontalSpacing: 5, verticalSpacing: 5) {
            GridRow {
                tile(MiBentoGridTokens.accent.opacity(isPressed ? 0.95 : 0.82), height: 44)
                    .gridCellColumns(2)
                tile(MiBentoGridTokens.surface, height: 44, stroked: true)
            }
            GridRow {
                tile(MiBentoGridTokens.accent2.opacity(0.22), height: 26)
                tile(MiBentoGridTokens.surface, height: 26, stroked: true)
                tile(MiBentoGridTokens.surfaceAlt, height: 26)
            }
        }
    }

    private func tile(_ fill: Color, height: CGFloat, stroked: Bool = false) -> some View {
        RoundedRectangle(cornerRadius: 9, style: .continuous)
            .fill(fill)
            .frame(height: height)
            .frame(maxWidth: .infinity)
            .overlay {
                if stroked {
                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                        .strokeBorder(MiBentoGridTokens.stroke, lineWidth: 1)
                }
            }
    }
}
