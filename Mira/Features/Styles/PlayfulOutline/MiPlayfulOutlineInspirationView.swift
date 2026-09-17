import SwiftUI

struct MiPlayfulOutlineInspirationView: View {
    let styleName: String
    @Binding var isSaved: Bool
    private typealias T = MiPlayfulOutlineTokens

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            VStack(alignment: .leading, spacing: 12) {
                Text(MiL10n.text(styleName))
                    .font(.system(.largeTitle, design: .rounded, weight: .black))
                    .accessibilityAddTraits(.isHeader)
                Text(MiL10n.text("po_hero_body"))
                    .font(.body)
                    .foregroundStyle(T.muted)
            }
            .fixedSize(horizontal: false, vertical: true)

            MiPlayfulOutlineNoteCard(isSaved: isSaved) { isSaved.toggle() }

            VStack(alignment: .leading, spacing: 8) {
                Text(MiL10n.text(isSaved ? "po_note_collection_saved" : "po_note_collection_empty"))
                    .font(.system(.headline, design: .rounded, weight: .bold))
                Text(MiL10n.text("po_note_collection_body"))
                    .font(.callout)
                    .foregroundStyle(T.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .accessibilityElement(children: .combine)
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 32)
    }
}
