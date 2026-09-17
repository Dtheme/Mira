import SwiftUI

struct MiPlayfulOutlineSheet<Content: View>: View {
    let titleKey: String
    let onClose: () -> Void
    private let content: Content

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State private var selectedDetent = PresentationDetent.medium

    init(titleKey: String, onClose: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.titleKey = titleKey
        self.onClose = onClose
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 16) {
                Text(MiL10n.text(titleKey))
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityAddTraits(.isHeader)

                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.body.weight(.semibold))
                }
                .buttonStyle(MiPlayfulOutlineCircleButtonStyle())
                .accessibilityLabel(MiL10n.text("po_sheet_close"))
            }
            .padding(.horizontal, 24)
            .padding(.top, 28)
            .padding(.bottom, 32)
            .background(MiPlayfulOutlineTokens.accent)
            .overlay(alignment: .bottom) {
                MiPlayfulOutlineWave(phase: 0.5, amplitude: 8)
                    .fill(MiPlayfulOutlineTokens.paper)
                    .frame(height: 24)
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(MiL10n.text("po_sheet_resize_hint"))
                            .font(.callout)
                            .foregroundStyle(MiPlayfulOutlineTokens.muted)
                            .fixedSize(horizontal: false, vertical: true)

                        ScrollView(.horizontal) {
                            HStack(spacing: 8) {
                                detentButton("po_sheet_compact", detent: .height(280))
                                detentButton("po_sheet_medium", detent: .medium)
                                    .disabled(verticalSizeClass == .compact)
                                detentButton("po_sheet_large", detent: .large)
                            }
                            .padding(1)
                        }
                        .scrollIndicators(.hidden)

                        Text(MiL10n.text(currentDetentKey))
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(MiPlayfulOutlineTokens.accentStrong)
                            .contentTransition(.opacity)
                    }

                    content
                }
                .frame(maxWidth: 620, alignment: .leading)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
        }
        .foregroundStyle(MiPlayfulOutlineTokens.ink)
        .background(MiPlayfulOutlineTokens.paper)
        .presentationBackground(MiPlayfulOutlineTokens.paper)
        .presentationDetents([.height(280), .medium, .large], selection: $selectedDetent)
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(32)
        .presentationContentInteraction(.resizes)
        .accessibilityAction(.escape, onClose)
        .onAppear {
            if dynamicTypeSize.isAccessibilitySize {
                selectedDetent = .large
            }
        }
        .onChange(of: dynamicTypeSize) { _, size in
            if size.isAccessibilitySize {
                selectedDetent = .large
            }
        }
    }

    private var currentDetentKey: String {
        if selectedDetent == .height(280) {
            return "po_sheet_current_compact"
        }
        return selectedDetent == .medium ? "po_sheet_current_medium" : "po_sheet_current_large"
    }

    private func detentButton(_ titleKey: String, detent: PresentationDetent) -> some View {
        Button {
            withAnimation(reduceMotion ? nil : MiPlayfulOutlineTokens.response) {
                selectedDetent = detent
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "checkmark")
                    .opacity(selectedDetent == detent ? 1 : 0)
                    .accessibilityHidden(true)
                Text(MiL10n.text(titleKey))
                    .fixedSize(horizontal: true, vertical: false)
            }
            .font(.subheadline.weight(.semibold))
        }
        .buttonStyle(MiPlayfulOutlineButtonStyle(filled: selectedDetent == detent))
        .accessibilityAddTraits(selectedDetent == detent ? [.isSelected] : [])
    }
}
