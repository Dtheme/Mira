import SwiftUI

struct MiMaterial3DetailView: View {
    let style: MiDesignStyle
    let onBack: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var palette = MiMaterial3Palette.violet
    @State private var destination = 0
    @State private var query = ""
    @State private var selection = 0
    @State private var category = 0
    @State private var collections = MiMaterial3Collection.examples
    @State private var dialog: MiMaterial3DialogKind?
    @State private var showsPrompt = false
    @State private var snackbar: String?
    @State private var undoCollections: [MiMaterial3Collection]?
    @AccessibilityFocusState private var createFocused: Bool

    var body: some View {
        ZStack {
            page
                .disabled(dialog != nil)
                .allowsHitTesting(dialog == nil)
                .accessibilityHidden(dialog != nil)
            if let dialog {
                MiMaterial3CollectionDialog(kind: dialog, onCancel: closeDialog) { title in
                    let previous = collections
                    if case .create = dialog {
                        collections.insert(MiMaterial3Collection(title: title, subtitle: MiL10n.text("m3_demo_new_note"), category: 0), at: 0)
                        query = ""
                        category = 0
                        selection = 0
                        notify("m3_demo_created", previous: previous)
                    } else {
                        collections = MiMaterial3Collection.examples
                        notify("m3_demo_reset_done", previous: previous)
                    }
                    closeDialog()
                }
                .zIndex(5)
            }
        }
        .environment(\.miMaterial3Palette, palette)
        .tint(palette.primary)
        .sheet(isPresented: $showsPrompt) {
            MiMaterial3PromptSheet(style: style)
                .environment(\.miMaterial3Palette, palette)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var page: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    Group {
                        switch destination {
                        case 0:
                            MiMaterial3Library(
                                palette: $palette, query: $query, selection: $selection, category: $category,
                                collections: collections, onBookmark: toggleBookmark
                            )
                        case 1:
                            MiMaterial3ComponentLab(onNotice: { notify($0) }, onReset: { dialog = .reset })
                        default:
                            MiMaterial3ReferenceView(style: style, onPrompt: { showsPrompt = true })
                        }
                    }
                    .frame(maxWidth: 640, alignment: .leading)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, destination == 0 ? 88 : 24)
                }
                .scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.interactively)
                .id(destination)

                if destination == 0 {
                    Button { dialog = .create } label: { Image(systemName: "plus").font(.system(size: 24)) }
                        .buttonStyle(MiMaterial3FABStyle())
                        .accessibilityLabel(MiL10n.text("m3_demo_create"))
                        .accessibilityFocused($createFocused)
                        .padding(16)
                }
            }
            if let snackbar {
                HStack(spacing: 8) {
                    Text(MiL10n.text(snackbar))
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if undoCollections != nil {
                        Button(MiL10n.text("m3_demo_undo")) {
                            if let undoCollections { collections = undoCollections }
                            self.undoCollections = nil
                            self.snackbar = nil
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(palette.inversePrimary)
                        .frame(minWidth: 48, minHeight: 48)
                    }
                    Button { self.snackbar = nil; undoCollections = nil } label: {
                        Image(systemName: "xmark").frame(width: 44, height: 48)
                    }
                    .accessibilityLabel(MiL10n.text("m3_demo_close"))
                }
                .foregroundStyle(palette.inverseOnSurface)
                .padding(.leading, 16)
                .background(palette.inverseSurface, in: RoundedRectangle(cornerRadius: 4))
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                .accessibilityElement(children: .contain)
                .transition(.opacity)
            }
        }
        .foregroundStyle(palette.onSurface)
        .background(palette.surface.ignoresSafeArea())
        .safeAreaInset(edge: .top, spacing: 0) {
            HStack(spacing: 8) {
                Button { if let onBack { onBack() } else { dismiss() } } label: { Image(systemName: "arrow.left") }
                    .buttonStyle(MiMaterial3IconButtonStyle())
                    .accessibilityLabel(MiL10n.text("c_back"))
                Text(MiL10n.text(style.name)).font(.title3).frame(maxWidth: .infinity, alignment: .leading)
                Button { showsPrompt = true } label: { Image(systemName: "info.circle") }
                    .buttonStyle(MiMaterial3IconButtonStyle())
                    .accessibilityLabel(MiL10n.text("m3_demo_reference"))
            }
            .padding(.horizontal, 4)
            .frame(minHeight: 64)
            .background(palette.surface)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            MiMaterial3Navigation(selection: $destination)
        }
        .animation(reduceMotion ? nil : .easeOut(duration: 0.18), value: snackbar != nil)
    }

    private func toggleBookmark(_ id: UUID) {
        guard let index = collections.firstIndex(where: { $0.id == id }) else { return }
        let previous = collections
        collections[index].isSaved.toggle()
        notify(collections[index].isSaved ? "m3_demo_saved" : "m3_demo_unsaved", previous: previous)
    }

    private func notify(_ key: String, previous: [MiMaterial3Collection]? = nil) {
        snackbar = key
        undoCollections = previous
    }

    private func closeDialog() {
        let wasCreate = dialog == .create
        dialog = nil
        if wasCreate { createFocused = true }
    }
}

private struct MiMaterial3Navigation: View {
    @Binding var selection: Int
    @Environment(\.miMaterial3Palette) private var palette
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    private let titles = ["m3_demo_library", "m3_components", "m3_demo_reference"]
    private let icons = ["square.stack", "square.grid.2x2", "book.closed"]

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(titles.indices, id: \.self) { index in
                Button {
                    withAnimation(reduceMotion ? nil : .easeOut(duration: 0.18)) { selection = index }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: icons[index] + (selection == index ? ".fill" : ""))
                            .font(.system(size: 22))
                            .frame(width: 64, height: 32)
                            .background(selection == index ? palette.secondaryContainer : .clear, in: Capsule())
                        Text(MiL10n.text(titles[index]))
                            .font(.caption.weight(selection == index ? .semibold : .medium))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .foregroundStyle(selection == index ? palette.onSecondaryContainer : palette.onSurfaceVariant)
                    .frame(maxWidth: .infinity, minHeight: 64, alignment: .top)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(selection == index ? .isSelected : [])
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 4)
        .frame(minHeight: 80)
        .background(palette.surfaceContainer.ignoresSafeArea(edges: .bottom))
    }
}
