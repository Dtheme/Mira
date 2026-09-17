import SwiftUI

struct MiPlayfulOutlineHomePreview: View {
    let style: MiDesignStyle
    let focus: MiCardFocus
    let cardSize: CGSize
    let cornerRadius: CGFloat
    let isDragging: Bool

    @Environment(\.miHomePressedStyleID) private var pressedStyleID
    private typealias T = MiPlayfulOutlineTokens
    private var scale: CGFloat { cardSize.width / 174 }
    private var pressed: Bool { pressedStyleID == style.id && !isDragging }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            T.tint
            if let screenshotAssetName = style.screenshotAssetName {
                Image(screenshotAssetName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: cardSize.width, height: cardSize.height)
                    .clipped()
                    .accessibilityHidden(true)
            } else {
                MiPlayfulOutlineNoteCard(isSaved: pressed, compact: true, scale: scale)
                    .padding(12 * scale)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
            }
            VStack(alignment: .leading, spacing: 5 * scale) {
                Text(MiL10n.text(style.name))
                    .font(.system(size: 18 * scale, weight: .bold, design: .rounded))
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
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
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}
