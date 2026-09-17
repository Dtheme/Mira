import SwiftUI

struct MiMaterial3ComponentLab: View {
    let onNotice: (String) -> Void
    let onReset: () -> Void
    @Environment(\.miMaterial3Palette) private var palette
    @State private var notifications = true
    @State private var offline = false
    @State private var selected = 0
    @State private var choice = false
    @State private var name = ""
    @State private var validated = false
    @State private var loadState = MiMaterial3LoadState.idle
    @State private var loadAttempt = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            VStack(alignment: .leading, spacing: 8) {
                Text(MiL10n.text("m3_components")).font(.largeTitle.weight(.regular)).accessibilityAddTraits(.isHeader)
                Text(MiL10n.text("m3_demo_components_intro")).font(.body).foregroundStyle(palette.onSurfaceVariant)
            }
            MiMaterial3LabSection(titleKey: "m3_demo_actions", bodyKey: "m3_demo_actions_body") {
                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 12) { primaryButtons }
                    VStack(alignment: .leading, spacing: 8) { primaryButtons }
                }
                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 12) { supportingButtons }
                    VStack(alignment: .leading, spacing: 8) { supportingButtons }
                }
                Button(MiL10n.text("m3_disabled")) {}.buttonStyle(MiMaterial3ButtonStyle(role: .filled)).disabled(true)
            }
            MiMaterial3LabSection(titleKey: "m3_demo_selection", bodyKey: "m3_demo_selection_body") {
                MiMaterial3Segment(titles: ["m3_demo_day", "m3_demo_week", "m3_demo_month"], selection: $selected)
                Text(MiL10n.text(["m3_demo_day_result", "m3_demo_week_result", "m3_demo_month_result"][selected]))
                    .font(.body).foregroundStyle(palette.onSurfaceVariant)
                MiMaterial3Chip(titleKey: "m3_demo_chip_choice", systemImage: "star", isSelected: choice) { choice.toggle() }
                Toggle(MiL10n.text("m3_demo_notifications"), isOn: $notifications)
                Toggle(MiL10n.text("m3_demo_offline"), isOn: $offline)
                Toggle(MiL10n.text("m3_demo_unavailable"), isOn: .constant(false)).disabled(true)
            }
            MiMaterial3LabSection(titleKey: "m3_demo_field", bodyKey: "m3_demo_field_body") {
                MiMaterial3TextField(titleKey: "m3_demo_collection_name", text: $name,
                                     errorKey: validated && name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "m3_demo_name_error" : nil)
                Button(MiL10n.text("m3_demo_validate")) {
                    validated = true
                    if !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { onNotice("m3_demo_field_success") }
                }
                .buttonStyle(MiMaterial3ButtonStyle(role: .filled))
            }
            MiMaterial3LabSection(titleKey: "m3_demo_recovery", bodyKey: "m3_demo_recovery_body") {
                VStack(alignment: .leading, spacing: 16) {
                    switch loadState {
                    case .idle:
                        Text(MiL10n.text("m3_demo_load_idle")).font(.body)
                        Button(MiL10n.text("m3_demo_load")) { loadAttempt = 1; loadState = .loading }
                            .buttonStyle(MiMaterial3ButtonStyle(role: .tonal))
                    case .loading:
                        HStack(spacing: 16) {
                            ProgressView().tint(palette.primary)
                            Text(MiL10n.text("m3_demo_loading")).font(.body)
                        }
                        .frame(minHeight: 48)
                    case .failed:
                        Label(MiL10n.text("m3_demo_load_error"), systemImage: "exclamationmark.circle")
                            .font(.body).foregroundStyle(palette.error)
                        Button(MiL10n.text("m3_demo_retry")) { loadAttempt += 1; loadState = .loading }
                            .buttonStyle(MiMaterial3ButtonStyle(role: .tonal))
                    case .loaded:
                        Label(MiL10n.text("m3_demo_load_success"), systemImage: "checkmark.circle")
                            .font(.body).foregroundStyle(palette.primary)
                        Button(MiL10n.text("m3_demo_repeat")) { loadState = .idle; loadAttempt = 0 }
                            .buttonStyle(MiMaterial3ButtonStyle(role: .text))
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(loadState == .failed ? palette.errorContainer : palette.surfaceContainer, in: RoundedRectangle(cornerRadius: 12))
            }
            MiMaterial3LabSection(titleKey: "m3_demo_dialog", bodyKey: "m3_demo_dialog_body") {
                Button(role: .destructive, action: onReset) {
                    Text(MiL10n.text("m3_demo_reset")).foregroundStyle(palette.error)
                }
                .buttonStyle(MiMaterial3ButtonStyle(role: .outlined))
            }
        }
        .toggleStyle(MiMaterial3ToggleStyle())
        .task(id: loadState) {
            guard loadState == .loading else { return }
            do { try await Task.sleep(for: .milliseconds(800)) } catch { return }
            guard !Task.isCancelled else { return }
            loadState = loadAttempt == 1 ? .failed : .loaded
        }
    }

    @ViewBuilder private var primaryButtons: some View {
        Button { onNotice("m3_demo_filled_result") } label: { Label(MiL10n.text("m3_filled"), systemImage: "plus") }
            .buttonStyle(MiMaterial3ButtonStyle(role: .filled))
        Button { onNotice("m3_demo_tonal_result") } label: { Label(MiL10n.text("m3_tonal"), systemImage: "checkmark") }
            .buttonStyle(MiMaterial3ButtonStyle(role: .tonal))
    }

    @ViewBuilder private var supportingButtons: some View {
        Button(MiL10n.text("m3_outlined")) { onNotice("m3_demo_outlined_result") }.buttonStyle(MiMaterial3ButtonStyle(role: .outlined))
        Button(MiL10n.text("m3_demo_text_button")) { onNotice("m3_demo_text_result") }.buttonStyle(MiMaterial3ButtonStyle(role: .text))
    }
}

private enum MiMaterial3LoadState: Equatable { case idle, loading, failed, loaded }

struct MiMaterial3LabSection<Content: View>: View {
    let titleKey: String
    let bodyKey: String
    @ViewBuilder var content: Content
    @Environment(\.miMaterial3Palette) private var palette

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(MiL10n.text(titleKey)).font(.title2.weight(.regular)).accessibilityAddTraits(.isHeader)
            Text(MiL10n.text(bodyKey)).font(.subheadline).foregroundStyle(palette.onSurfaceVariant)
                .fixedSize(horizontal: false, vertical: true)
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
