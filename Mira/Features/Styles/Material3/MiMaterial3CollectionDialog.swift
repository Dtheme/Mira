import SwiftUI

enum MiMaterial3DialogKind: Equatable { case create, reset }

struct MiMaterial3CollectionDialog: View {
    let kind: MiMaterial3DialogKind
    let onCancel: () -> Void
    let onConfirm: (String) -> Void
    @Environment(\.miMaterial3Palette) private var palette
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var title = ""
    @State private var submitted = false
    @State private var appeared = false
    @AccessibilityFocusState private var headingFocused: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.32).ignoresSafeArea()
                    .onTapGesture(perform: onCancel)
                    .accessibilityHidden(true)
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(MiL10n.text(kind == .create ? "m3_demo_create" : "m3_demo_reset_title"))
                            .font(.title2.weight(.regular))
                            .accessibilityAddTraits(.isHeader)
                            .accessibilityFocused($headingFocused)
                        Text(MiL10n.text(kind == .create ? "m3_demo_create_body" : "m3_demo_reset_body"))
                            .font(.subheadline).foregroundStyle(palette.onSurfaceVariant)
                        if kind == .create {
                            MiMaterial3TextField(titleKey: "m3_demo_collection_name", text: $title,
                                                 errorKey: submitted && title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "m3_demo_name_error" : nil)
                        }
                        ViewThatFits(in: .horizontal) {
                            HStack(spacing: 8) { Spacer(minLength: 0); actions }
                            VStack(alignment: .trailing, spacing: 8) { actions }.frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.top, 8)
                    }
                    .padding(24)
                    .foregroundStyle(palette.onSurface)
                    .frame(maxWidth: 400, alignment: .leading)
                    .background(palette.surfaceContainerHigh, in: RoundedRectangle(cornerRadius: 28))
                    .padding(24)
                    .frame(maxWidth: .infinity, minHeight: geometry.size.height)
                }
                .scrollBounceBehavior(.basedOnSize)
                .scaleEffect(appeared || reduceMotion ? 1 : 0.94)
                .opacity(appeared ? 1 : 0)
            }
        }
        .accessibilityAddTraits(.isModal)
        .accessibilityAction(.escape, onCancel)
        .task {
            withAnimation(.easeOut(duration: reduceMotion ? 0.12 : 0.25)) { appeared = true }
            headingFocused = true
        }
    }

    @ViewBuilder private var actions: some View {
        Button(MiL10n.text("m3_demo_cancel"), action: onCancel)
            .buttonStyle(MiMaterial3ButtonStyle(role: .text))
        Button(role: kind == .reset ? .destructive : nil) {
            submitted = true
            let value = title.trimmingCharacters(in: .whitespacesAndNewlines)
            if kind == .reset || !value.isEmpty { onConfirm(value) }
        } label: {
            Text(MiL10n.text(kind == .create ? "m3_demo_create_action" : "m3_demo_reset_action"))
                .foregroundStyle(kind == .reset ? palette.error : palette.primary)
        }
        .buttonStyle(MiMaterial3ButtonStyle(role: .text))
    }
}
