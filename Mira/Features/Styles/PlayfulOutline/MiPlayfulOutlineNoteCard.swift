import SwiftUI

struct MiPlayfulOutlineNoteCard: View {
    let isSaved: Bool
    var compact = false
    var scale: CGFloat = 1
    var onSave: (() -> Void)?

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    private typealias T = MiPlayfulOutlineTokens

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: compact ? 6 * scale : 18) {
                Text(MiL10n.text("po_note_label"))
                    .font(compact ? .system(size: 10 * scale, weight: .medium) : .subheadline.weight(.medium))
                    .foregroundStyle(T.muted)
                Text(MiL10n.text("po_note_content"))
                    .font(compact ? .system(size: 12 * scale, weight: .bold, design: .rounded) : .system(.title2, design: .rounded, weight: .bold))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(compact ? 10 * scale : 24)
            .frame(maxWidth: .infinity, alignment: .leading)

            Group {
                if let onSave {
                    Button(action: onSave) { saveLabel }
                        .buttonStyle(.plain)
                        .accessibilityLabel(MiL10n.text(isSaved ? "po_note_unsave" : "po_note_save"))
                        .accessibilityAddTraits(isSaved ? .isSelected : [])
                } else {
                    saveLabel
                }
            }
            .padding(.horizontal, compact ? 12 * scale : 24)
            .padding(.top, compact ? 12 * scale : 24)
            .padding(.bottom, compact ? 7 * scale : 12)
            .background {
                MiPlayfulOutlineWave(phase: 0.4, amplitude: compact ? 7 * scale : 12)
                    .fill(isSaved ? T.apricot : T.accent)
            }
        }
        .foregroundStyle(T.ink)
        .background(T.surface)
        .clipShape(RoundedRectangle(cornerRadius: compact ? 14 * scale : 28))
        .animation(reduceMotion ? nil : .easeOut(duration: 0.22), value: isSaved)
    }

    private var saveLabel: some View {
        HStack(spacing: 8) {
            Text(MiL10n.text(isSaved ? "po_note_saved" : "po_note_save"))
                .font(compact ? .system(size: 11 * scale, weight: .semibold) : .system(.subheadline, design: .rounded, weight: .semibold))
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
            Image(systemName: isSaved ? "checkmark" : "bookmark")
                .font(compact ? .system(size: 13 * scale, weight: .semibold) : .title3)
                .contentTransition(reduceMotion ? .opacity : .symbolEffect(.replace))
                .accessibilityHidden(true)
        }
        .frame(minHeight: compact ? 16 * scale : 44)
        .contentShape(Rectangle())
    }
}
