import SwiftUI

struct MiMaterial3HomePreview: View {
    let style: MiDesignStyle
    let focus: MiCardFocus
    let cardSize: CGSize
    let cornerRadius: CGFloat
    let isDragging: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.miHomePressedStyleID) private var pressedStyleID

    private let palette = MiMaterial3Palette.violet
    private var scale: CGFloat { cardSize.width / 174 }
    private var isPressed: Bool { pressedStyleID == style.id && !isDragging }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            palette.surfaceContainerLow

            if let screenshotAssetName = style.screenshotAssetName {
                Image(screenshotAssetName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: cardSize.width, height: cardSize.height)
                    .clipped()
                    .accessibilityHidden(true)
            } else {
                VStack {
                    signature
                        .padding(.top, 28 * scale)
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity)
            }

            VStack(alignment: .leading, spacing: 5 * scale) {
                Text(MiL10n.text(style.name))
                    .font(.system(size: 20 * scale, weight: .medium))
                    .foregroundStyle(palette.onSurface)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                    .miStyleTitleTransition(style.id)

                Text(MiL10n.text("m3_home_hook"))
                    .font(.system(size: 11 * scale, weight: .regular))
                    .foregroundStyle(palette.onSurfaceVariant)
                    .lineLimit(2)
            }
            .padding(.horizontal, 20 * scale)
            .padding(.top, 14 * scale)
            .padding(.bottom, 16 * scale)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(style.screenshotAssetName == nil ? Color.clear : palette.surfaceContainerLow)
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .animation(.easeOut(duration: reduceMotion ? 0.10 : 0.15), value: isPressed)
    }

    private var signature: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24 * scale, style: .continuous)
                .fill(palette.primaryContainer)

            RoundedRectangle(cornerRadius: 16 * scale, style: .continuous)
                .fill(palette.primary)
                .overlay {
                    RoundedRectangle(cornerRadius: 16 * scale, style: .continuous)
                        .fill(palette.onPrimary.opacity(isPressed ? 0.12 : 0))
                }
                .overlay {
                    Image(systemName: "pencil")
                        .font(.system(size: 24 * scale, weight: .regular))
                        .foregroundStyle(palette.onPrimary)
                }
                .frame(width: 56 * scale, height: 56 * scale)
                .shadow(
                    color: .black.opacity(isDragging ? 0 : 0.18),
                    radius: (isPressed ? 2 : 3) * scale,
                    x: 0,
                    y: (isPressed ? 1 : 3) * scale
                )
        }
        .frame(width: 104 * scale, height: 100 * scale)
        .accessibilityHidden(true)
    }
}
