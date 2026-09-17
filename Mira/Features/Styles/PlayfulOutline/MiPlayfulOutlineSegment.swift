import SwiftUI

struct MiPlayfulOutlineSegment: View {
    let titles: [String]
    @Binding var selection: Int
    var disabledIndices: Set<Int> = []

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Namespace private var selectionNamespace

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 4) {
                ForEach(titles.indices, id: \.self) { index in
                    Button {
                        withAnimation(reduceMotion ? nil : MiPlayfulOutlineTokens.response) {
                            selection = index
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark")
                                .font(.caption.weight(.bold))
                                .opacity(selection == index ? 1 : 0)
                                .accessibilityHidden(true)
                            Text(MiL10n.text(titles[index]))
                                .font(.subheadline.weight(.semibold))
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .foregroundStyle(selection == index ? MiPlayfulOutlineTokens.paper : MiPlayfulOutlineTokens.ink)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .frame(minHeight: 44)
                        .background {
                            if selection == index {
                                if reduceMotion {
                                    Capsule()
                                        .fill(MiPlayfulOutlineTokens.ink)
                                        .transition(.opacity.animation(.easeOut(duration: 0.16)))
                                } else {
                                    Capsule()
                                        .fill(MiPlayfulOutlineTokens.ink)
                                        .matchedGeometryEffect(id: "selection", in: selectionNamespace)
                                }
                            }
                        }
                        .contentShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .disabled(disabledIndices.contains(index))
                    .opacity(disabledIndices.contains(index) ? 0.42 : 1)
                    .accessibilityAddTraits(selection == index ? [.isSelected] : [])
                }
            }
            .padding(4)
            .background(MiPlayfulOutlineTokens.control, in: Capsule())
        }
        .scrollIndicators(.hidden)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(MiL10n.text("po_segment_accessibility"))
    }
}
