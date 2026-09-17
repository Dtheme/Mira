import SwiftUI

struct MiPlayfulOutlineInputDemo: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var query = ""
    @State private var submitted = false
    @State private var filter = 0
    @State private var loadState = 0
    @State private var attempt = 0
    @FocusState private var inputFocused: Bool
    private typealias T = MiPlayfulOutlineTokens
    private let samples = ["po_sample_line", "po_sample_wave", "po_sample_circle"]

    private var matches: [String] {
        samples.enumerated().filter { index, key in
            (filter == 0 || index == filter - 1) && (query.isEmpty || MiL10n.text(key).localizedCaseInsensitiveContains(query))
        }.map(\.element)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(MiL10n.text("po_input_heading"))
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .accessibilityAddTraits(.isHeader)
                Text(MiL10n.text("po_input_body")).font(.callout).foregroundStyle(T.muted)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(MiL10n.text("po_search_label")).font(.subheadline.weight(.semibold))
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(inputFocused ? T.accentStrong : T.muted)
                        .accessibilityHidden(true)
                    TextField("", text: $query, prompt: Text(MiL10n.text("po_search_placeholder")).foregroundStyle(T.muted))
                        .focused($inputFocused)
                        .submitLabel(.search)
                        .onSubmit { submitted = true }
                        .accessibilityLabel(MiL10n.text("po_search_label"))
                    if !query.isEmpty {
                        Button { query = ""; submitted = false } label: {
                            Image(systemName: "xmark").frame(width: 44, height: 44)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(MiL10n.text("po_clear"))
                    }
                }
                .padding(.leading, 16)
                .padding(.trailing, 4)
                .frame(minHeight: 54)
                .background(submitted && query.isEmpty ? T.errorSurface : inputFocused ? T.accent : T.tint, in: RoundedRectangle(cornerRadius: 18))
                if submitted && query.isEmpty {
                    Label(MiL10n.text("po_input_error"), systemImage: "exclamationmark.circle")
                        .font(.caption).foregroundStyle(T.error)
                }
            }

            MiPlayfulOutlineSegment(
                titles: ["po_filter_all", "po_sample_line", "po_sample_wave", "po_sample_circle", "po_switch_disabled"],
                selection: $filter,
                disabledIndices: [4]
            )

            if matches.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text(MiL10n.text("po_empty")).font(.headline)
                    Button { query = ""; filter = 0; submitted = false } label: {
                        Text(MiL10n.text("po_clear_filters"))
                    }
                    .buttonStyle(MiPlayfulOutlineButtonStyle())
                }
            } else {
                VStack(spacing: 0) {
                    ForEach(matches, id: \.self) { key in
                        HStack(spacing: 12) {
                            Image(systemName: key == "po_sample_line" ? "line.diagonal" : key == "po_sample_wave" ? "water.waves" : "circle")
                                .frame(width: 24)
                                .accessibilityHidden(true)
                            Text(MiL10n.text(key))
                            Spacer()
                            Image(systemName: "checkmark").foregroundStyle(T.accentStrong).accessibilityHidden(true)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                    }
                }
                .background(T.surface, in: RoundedRectangle(cornerRadius: 24))
            }

            Button { submitted = true; inputFocused = query.isEmpty } label: {
                Text(MiL10n.text("po_validate")).frame(maxWidth: .infinity)
            }
            .buttonStyle(MiPlayfulOutlineButtonStyle())

            VStack(alignment: .leading, spacing: 12) {
                Text(MiL10n.text("po_load_demo")).font(.subheadline.weight(.semibold))
                Text(MiL10n.text(["po_load_idle", "po_load_loading", "po_load_error", "po_load_success"][loadState]))
                    .font(.callout)
                    .foregroundStyle(loadState == 2 ? T.error : T.muted)
                    .contentTransition(.opacity)
                Button {
                    attempt += 1
                    loadState = 1
                } label: {
                    Label(MiL10n.text(loadState == 2 ? "po_retry" : "po_load_start"), systemImage: loadState == 3 ? "checkmark" : "arrow.clockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(MiPlayfulOutlineButtonStyle(filled: true))
                .disabled(loadState == 1)
            }
            .padding(20)
            .background(T.tint, in: RoundedRectangle(cornerRadius: 24))
        }
        .task(id: attempt) {
            guard attempt > 0, loadState == 1 else { return }
            do { try await Task.sleep(for: .milliseconds(850)) } catch { return }
            guard !Task.isCancelled else { return }
            withAnimation(reduceMotion ? nil : .easeOut(duration: 0.18)) {
                loadState = attempt.isMultiple(of: 2) ? 3 : 2
            }
        }
    }
}
