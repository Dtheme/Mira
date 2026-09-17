import SwiftUI

struct MiMaterial3Collection: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var subtitle: String
    var category: Int
    var isSaved = false

    var symbol: String { ["square.stack", "paintpalette", "textformat", "hand.tap"][category] }

    static var examples: [Self] {
        [
            Self(title: MiL10n.text("m3_demo_color_title"), subtitle: MiL10n.text("m3_demo_color_note"), category: 1),
            Self(title: MiL10n.text("m3_demo_type_title"), subtitle: MiL10n.text("m3_demo_type_note"), category: 2, isSaved: true),
            Self(title: MiL10n.text("m3_demo_motion_title"), subtitle: MiL10n.text("m3_demo_motion_note"), category: 3)
        ]
    }
}

struct MiMaterial3Library: View {
    @Binding var palette: MiMaterial3Palette
    @Binding var query: String
    @Binding var selection: Int
    @Binding var category: Int
    let collections: [MiMaterial3Collection]
    let onBookmark: (UUID) -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var results: [MiMaterial3Collection] {
        collections.filter {
            (selection == 0 || $0.isSaved) && (category == 0 || $0.category == category)
                && (query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    || ($0.title + $0.subtitle).localizedCaseInsensitiveContains(query.trimmingCharacters(in: .whitespacesAndNewlines)))
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(MiL10n.text("m3_demo_library_title"))
                    .font(.largeTitle.weight(.regular))
                    .accessibilityAddTraits(.isHeader)
                Text(MiL10n.text("m3_demo_library_body"))
                    .font(.subheadline).foregroundStyle(palette.onSurfaceVariant)
            }
            MiMaterial3PalettePreview(palette: $palette)
            MiMaterial3TextField(titleKey: "m3_demo_search", text: $query)
            VStack(spacing: 4) {
                MiMaterial3Segment(titles: ["m3_demo_all", "m3_demo_bookmarks"], selection: $selection)
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(Array(["m3_demo_everything", "m3_demo_colors", "m3_demo_type", "m3_demo_motion"].enumerated()), id: \.offset) { index, title in
                            MiMaterial3Chip(titleKey: title, isSelected: category == index) { category = index }
                        }
                        MiMaterial3Chip(titleKey: "m3_demo_shared", systemImage: "person.2") {}
                            .disabled(true)
                    }
                }
                .scrollIndicators(.hidden)
            }
            HStack {
                Text(MiL10n.text("m3_demo_collections"))
                    .font(.title3).accessibilityAddTraits(.isHeader)
                Spacer()
                Text(MiL10n.format("m3_demo_result_count", results.count))
                    .font(.subheadline).foregroundStyle(palette.onSurfaceVariant)
            }
            if results.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Image(systemName: "bookmark").font(.title).foregroundStyle(palette.primary)
                    Text(MiL10n.text("m3_demo_empty_title")).font(.headline)
                    Text(MiL10n.text("m3_demo_empty_body")).font(.subheadline).foregroundStyle(palette.onSurfaceVariant)
                    Button(MiL10n.text("m3_demo_clear_filters")) { query = ""; selection = 0; category = 0 }
                        .buttonStyle(MiMaterial3ButtonStyle(role: .tonal))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 16)
            } else {
                VStack(spacing: 12) {
                    ForEach(results) { collection in
                        MiMaterial3CollectionRow(collection: collection) { onBookmark(collection.id) }
                    }
                }
            }
        }
        .animation(reduceMotion ? nil : .easeOut(duration: 0.18), value: selection)
        .animation(reduceMotion ? nil : .easeOut(duration: 0.18), value: category)
    }
}

private struct MiMaterial3PalettePreview: View {
    @Binding var palette: MiMaterial3Palette
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Button {
                withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.25)) {
                    palette = palette == .violet ? .sage : .violet
                }
            } label: {
                Image(systemName: "paintpalette").font(.system(size: 24))
            }
            .buttonStyle(MiMaterial3FABStyle())
            .accessibilityLabel(MiL10n.text("m3_demo_change_palette"))
            .accessibilityValue(MiL10n.text(palette == .violet ? "m3_demo_violet" : "m3_demo_sage"))

            VStack(alignment: .leading, spacing: 8) {
                Text(MiL10n.text("m3_demo_your_colors")).font(.title3)
                Text(MiL10n.text(palette == .violet ? "m3_demo_violet" : "m3_demo_sage"))
                    .font(.subheadline.weight(.medium))
                HStack(spacing: 6) {
                    ForEach(0..<3) { index in
                        Circle().fill([palette.primary, palette.secondaryContainer, palette.tertiaryContainer][index])
                            .frame(width: 16, height: 16)
                    }
                    Text(MiL10n.text(palette == .violet ? "m3_demo_violet_roles" : "m3_demo_sage_roles"))
                        .font(.caption).fixedSize(horizontal: false, vertical: true)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(MiL10n.text(palette == .violet ? "m3_demo_violet_roles" : "m3_demo_sage_roles"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundStyle(palette.onPrimaryContainer)
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(palette.primaryContainer, in: RoundedRectangle(cornerRadius: 24))
    }
}

private struct MiMaterial3CollectionRow: View {
    let collection: MiMaterial3Collection
    let onBookmark: () -> Void
    @Environment(\.miMaterial3Palette) private var palette
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            if !dynamicTypeSize.isAccessibilitySize {
                Image(systemName: collection.symbol)
                    .font(.title2)
                    .foregroundStyle(palette.onSecondaryContainer)
                    .frame(width: 48, height: 56)
                    .background(palette.secondaryContainer, in: RoundedRectangle(cornerRadius: 8))
                    .accessibilityHidden(true)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(collection.title).font(.headline.weight(.medium))
                Text(collection.subtitle).font(.subheadline).foregroundStyle(palette.onSurfaceVariant)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
            Button(action: onBookmark) {
                Image(systemName: collection.isSaved ? "bookmark.fill" : "bookmark")
            }
            .buttonStyle(MiMaterial3IconButtonStyle())
            .accessibilityLabel(MiL10n.format(collection.isSaved ? "m3_demo_unsave_named" : "m3_demo_save_named", collection.title))
            .accessibilityAddTraits(collection.isSaved ? .isSelected : [])
        }
        .padding(16)
        .background(palette.surfaceContainerLow, in: RoundedRectangle(cornerRadius: 12))
    }
}
