import SwiftUI

struct MiPlayfulOutlineHomePreview: View {
    let style: MiDesignStyle
    let focus: MiCardFocus
    let cardSize: CGSize
    let cornerRadius: CGFloat
    let isDragging: Bool

    @Environment(\.miHomePressedStyleID) private var pressedStyleID
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private typealias T = MiPlayfulOutlineTokens
    private var scale: CGFloat { cardSize.width / 174 }
    private var pressed: Bool { pressedStyleID == style.id && !isDragging }

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        ZStack(alignment: .bottomLeading) {
            T.surface

            if let screenshotAssetName = style.screenshotAssetName {
                Image(screenshotAssetName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: cardSize.width, height: cardSize.height)
                    .clipped()
                    .accessibilityHidden(true)
            } else {
                MiPlayfulOutlineWave(phase: pressed && !reduceMotion ? 0.8 : 0, amplitude: 12 * scale)
                    .fill(T.accent)
                    .frame(height: cardSize.height * 0.54)

                ZStack {
                    Circle().fill(pressed ? T.accentStrong : T.ink)
                    MiPlayfulOutlineBeatMark(phase: pressed ? 1 : 0, intensity: pressed && !reduceMotion ? 0.8 : 0)
                        .fill(T.surface)
                        .frame(width: 52 * scale, height: 38 * scale)
                }
                .frame(width: 94 * scale, height: 94 * scale)
                .rotationEffect(.degrees(pressed && !reduceMotion ? -8 : -14))
                .position(x: cardSize.width * 0.60, y: cardSize.height * 0.34)
            }

            VStack(alignment: .leading, spacing: 5 * scale) {
                Text(MiL10n.text(style.name))
                    .font(.system(size: 18 * scale, weight: .bold, design: .rounded))
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .fixedSize(horizontal: false, vertical: true)
                    .miStyleTitleTransition(style.id)

                Text(MiL10n.text("po_card_hook"))
                    .font(.system(size: 11 * scale, weight: .medium))
                    .lineLimit(2)
            }
            .foregroundStyle(T.ink)
            .padding(16 * scale)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(style.screenshotAssetName == nil ? Color.clear : T.paper)
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .clipShape(shape)
        .animation(reduceMotion ? .easeOut(duration: 0.12) : T.response, value: pressed)
    }
}
