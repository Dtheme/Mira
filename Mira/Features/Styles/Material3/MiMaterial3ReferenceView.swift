import SwiftUI

struct MiMaterial3ReferenceView: View {
    let style: MiDesignStyle
    let onPrompt: () -> Void
    @Environment(\.miMaterial3Palette) private var palette

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            VStack(alignment: .leading, spacing: 8) {
                Text(MiL10n.text("m3_demo_reference")).font(.largeTitle.weight(.regular)).accessibilityAddTraits(.isHeader)
                Text(MiL10n.text("m3_demo_reference_intro")).font(.body).foregroundStyle(palette.onSurfaceVariant)
            }
            MiMaterial3LabSection(titleKey: "m3_demo_color_roles", bodyKey: "m3_demo_color_roles_body") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 8)], spacing: 8) {
                    role("Primary", palette.primary, palette.onPrimary)
                    role("Primary container", palette.primaryContainer, palette.onPrimaryContainer)
                    role("Secondary container", palette.secondaryContainer, palette.onSecondaryContainer)
                    role("Tertiary container", palette.tertiaryContainer, palette.onTertiaryContainer)
                    role("Surface", palette.surface, palette.onSurface)
                    role("Error container", palette.errorContainer, palette.onErrorContainer)
                }
                HStack(spacing: 0) {
                    ForEach(0..<4) { index in
                        [palette.surfaceContainerLow, palette.surfaceContainer, palette.surfaceContainerHigh, palette.surfaceContainerHighest][index]
                            .frame(height: 48)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .accessibilityLabel(MiL10n.text("m3_demo_surface_ladder"))
                Text(MiL10n.text("m3_demo_palette_honesty")).font(.caption).foregroundStyle(palette.onSurfaceVariant)
            }
            MiMaterial3LabSection(titleKey: "m3_demo_type_shape", bodyKey: "m3_demo_type_shape_body") {
                Text(MiL10n.text("m3_demo_type_sample")).font(.largeTitle.weight(.regular))
                Text(MiL10n.text("m3_demo_type_body")).font(.body)
                Text(MiL10n.text("m3_demo_dimensions")).font(.caption.monospaced()).foregroundStyle(palette.onSurfaceVariant)
            }
            MiMaterial3LabSection(titleKey: "m3_card_demo", bodyKey: "m3_demo_specimen_body") {
                MiMaterial3HomePreview(style: style, focus: MiCardFocus(scale: 1, opacity: 1, shadowOpacity: 0.2, borderOpacity: 0, zIndex: 1),
                                       cardSize: CGSize(width: 174, height: 222), cornerRadius: 28, isDragging: false)
                    .frame(maxWidth: .infinity)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(MiL10n.text("m3_card_demo"))
            }
            MiMaterial3LabSection(titleKey: "m3_demo_implementation", bodyKey: "m3_demo_implementation_body") {
                Label(style.category.title + " · " + MiL10n.text("c_ready"), systemImage: "checkmark.circle")
                Text(style.designDocumentPath).font(.caption.monospaced()).textSelection(.enabled)
                Text(style.screenshotStatus).font(.caption).foregroundStyle(palette.onSurfaceVariant)
                Button(action: onPrompt) { Label(MiL10n.text("m3_demo_open_prompt"), systemImage: "doc.text") }
                    .buttonStyle(MiMaterial3ButtonStyle(role: .tonal))
            }
        }
    }

    private func role(_ name: String, _ color: Color, _ foreground: Color) -> some View {
        Text(name)
            .font(.subheadline.weight(.medium))
            .foregroundStyle(foreground)
            .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
            .padding(16)
            .background(color, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct MiMaterial3PromptSheet: View {
    let style: MiDesignStyle
    @Environment(\.dismiss) private var dismiss
    @Environment(\.miMaterial3Palette) private var palette

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(MiL10n.text("m3_demo_open_prompt")).font(.title2)
                Spacer()
                Button { dismiss() } label: { Image(systemName: "xmark") }
                    .buttonStyle(MiMaterial3IconButtonStyle())
                    .accessibilityLabel(MiL10n.text("m3_demo_close"))
            }
            .padding(.horizontal, 24).padding(.top, 20).padding(.bottom, 8)
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(MiL10n.text("m3_demo_prompt")).font(.body).textSelection(.enabled)
                    Text(MiL10n.text("m3_demo_adaptation")).font(.subheadline).foregroundStyle(palette.onSurfaceVariant)
                    Text(style.designDocumentPath).font(.caption.monospaced()).textSelection(.enabled)
                }
                .padding(24)
            }
        }
        .foregroundStyle(palette.onSurface)
        .presentationBackground(palette.surfaceContainerLow)
        .background(palette.surfaceContainerLow)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(28)
    }
}
