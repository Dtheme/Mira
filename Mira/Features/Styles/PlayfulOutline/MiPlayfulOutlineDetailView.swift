import SwiftUI

struct MiPlayfulOutlineDetailView: View {
    let style: MiDesignStyle
    var onBack: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Namespace private var navigationNamespace
    @State private var chapter = 0
    @State private var destination = 0
    @State private var inputState = MiPlayfulOutlineInputState()
    @State private var isSaved = false
    @State private var elastic = true
    @State private var showsDialog = false
    @State private var showsSheet = false
    @State private var showsDetail = false
    @State private var confirmationCount = 0
    @State private var alertSource = 0
    @AccessibilityFocusState private var alertButtonFocused: Int?

    private typealias T = MiPlayfulOutlineTokens

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                topBar
                ZStack {
                    ScrollView {
                        destinationContent
                            .frame(maxWidth: 660)
                            .frame(maxWidth: .infinity)
                    }
                    .id(destination)
                    .transition(.opacity)
                    .scrollIndicators(.hidden)
                    .scrollDismissesKeyboard(.interactively)
                }
                .frame(maxHeight: .infinity)
                .animation(reduceMotion || !elastic ? nil : .easeOut(duration: 0.16), value: destination)

                MiPlayfulOutlineFlowTabBar(selection: $destination, isElastic: elastic)
            }
            .background(T.paper.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(isPresented: $showsDetail) {
                if reduceMotion {
                    MiPlayfulOutlineMotionDetailView()
                } else {
                    MiPlayfulOutlineMotionDetailView()
                        .navigationTransition(.zoom(sourceID: "outline-motion", in: navigationNamespace))
                }
            }
        }
        .foregroundStyle(T.ink)
        .tint(T.ink)
        .preferredColorScheme(.light)
        .disabled(showsDialog)
        .accessibilityHidden(showsDialog)
        .allowsHitTesting(!showsDialog)
        .overlay {
            if showsDialog {
                MiPlayfulOutlineDialog {
                    showsDialog = false
                    alertButtonFocused = alertSource
                } onConfirm: {
                    confirmationCount += 1
                }
            }
        }
        .sheet(isPresented: $showsSheet) {
            MiPlayfulOutlineSheet(titleKey: "po_sheet_title", onClose: { showsSheet = false }) {
                VStack(alignment: .leading, spacing: 16) {
                    Text(MiL10n.text("po_prompt_heading"))
                        .font(.system(.title3, design: .rounded, weight: .bold))
                    Text(MiL10n.text("po_prompt"))
                        .font(.body)
                        .textSelection(.enabled)
                    Label(MiL10n.text("po_sheet_footer"), systemImage: "hand.draw")
                        .font(.callout)
                        .foregroundStyle(T.muted)
                }
            }
        }
    }

    @ViewBuilder
    private var destinationContent: some View {
        switch destination {
        case 0:
            MiPlayfulOutlineInspirationView(styleName: style.localizedName, isSaved: $isSaved)
        case 1:
            VStack(alignment: .leading, spacing: 48) {
                componentLab
                presentationLab
                MiPlayfulOutlineInputDemo(state: $inputState)
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 36)
        default:
            designNotes
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 36)
        }
    }

    private var topBar: some View {
        HStack(spacing: 12) {
            Button {
                if let onBack { onBack() } else { dismiss() }
            } label: {
                Image(systemName: "arrow.left")
            }
            .buttonStyle(MiPlayfulOutlineCircleButtonStyle())
            .accessibilityLabel(MiL10n.text("c_back"))

            Text(MiL10n.text("po_studio"))
                .font(.system(.subheadline, design: .rounded, weight: .bold))
            Spacer(minLength: 4)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
        .background(T.paper)
    }

    private var componentLab: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionHeading("po_controls_heading", "po_controls_body")
            MiPlayfulOutlineSegment(titles: ["po_tab_buttons", "po_tab_switches"], selection: $chapter)
            Group {
                if chapter == 0 { buttons } else { switches }
            }
            .id(chapter)
            .transition(reduceMotion || !elastic ? .opacity : .opacity.combined(with: .offset(y: 10)))
        }
    }

    private var buttons: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button { isSaved.toggle() } label: {
                Label(MiL10n.text(isSaved ? "po_saved" : "po_save"), systemImage: isSaved ? "checkmark" : "plus")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(MiPlayfulOutlineButtonStyle(filled: true))
            .accessibilityAddTraits(isSaved ? [.isSelected] : [])

            HStack(spacing: 12) {
                Button { isSaved = false } label: {
                    Text(MiL10n.text("po_reset")).frame(maxWidth: .infinity)
                }
                .buttonStyle(MiPlayfulOutlineButtonStyle())
                .disabled(!isSaved)

                Button { alertButtonFocused = nil; alertSource = 0; showsDialog = true } label: {
                    Text(MiL10n.text("po_remove")).frame(maxWidth: .infinity)
                }
                .buttonStyle(MiPlayfulOutlineButtonStyle(destructive: true))
                .accessibilityFocused($alertButtonFocused, equals: 0)
            }
            Text(MiL10n.text(isSaved ? "po_saved_hint" : "po_button_hint"))
                .font(.callout)
                .foregroundStyle(T.muted)
                .contentTransition(.opacity)
        }
    }

    private var switches: some View {
        VStack(alignment: .leading, spacing: 24) {
            Toggle(isOn: $isSaved) { switchLabel("po_switch_saved", "po_switch_saved_body") }
            Toggle(isOn: $elastic) { switchLabel("po_switch_elastic", "po_switch_elastic_body") }
            Toggle(isOn: .constant(false)) { switchLabel("po_switch_disabled", "po_switch_disabled_body") }
                .disabled(true)
            Text(MiL10n.text(reduceMotion ? "po_reduced" : "po_switch_hint"))
                .font(.callout)
                .foregroundStyle(T.muted)
        }
        .toggleStyle(MiPlayfulOutlineToggleStyle())
    }

    private var presentationLab: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionHeading("po_present_heading", "po_present_body")
            VStack(spacing: 12) {
                Button { showsDetail = true } label: {
                    HStack(spacing: 16) {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                            .font(.title2)
                            .frame(width: 48, height: 48)
                            .background(T.surface, in: Circle())
                        VStack(alignment: .leading, spacing: 4) {
                            Text(MiL10n.text("po_open_detail")).font(.headline)
                            Text(MiL10n.text("po_open_detail_hint")).font(.caption).foregroundStyle(T.muted)
                        }
                        Spacer(minLength: 0)
                        Image(systemName: "arrow.up.right")
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(T.accent, in: RoundedRectangle(cornerRadius: 28))
                }
                .buttonStyle(.plain)
                .matchedTransitionSource(id: "outline-motion", in: navigationNamespace)

                Button { showsSheet = true } label: {
                    Label(MiL10n.text("po_open_sheet"), systemImage: "arrow.up.to.line")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(MiPlayfulOutlineButtonStyle())

                Button { alertButtonFocused = nil; alertSource = 1; showsDialog = true } label: {
                    Label(MiL10n.text("po_open_alert"), systemImage: "square.on.square")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(MiPlayfulOutlineButtonStyle())
                .accessibilityFocused($alertButtonFocused, equals: 1)
            }
            if confirmationCount > 0 {
                Label(MiL10n.format("po_confirmed_count", confirmationCount), systemImage: "checkmark.circle")
                    .font(.callout)
                    .foregroundStyle(T.accentStrong)
            }
        }
    }

    private var designNotes: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionHeading("po_design_heading", "po_design_body")
            VStack(alignment: .leading, spacing: 6) {
                Text(style.category.title + " · " + MiL10n.text("c_ready"))
                Text(style.designDocumentPath).textSelection(.enabled)
                Text(style.screenshotStatus)
            }
            .font(.caption)
            .foregroundStyle(T.muted)
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .center, spacing: 24) { homeCard; tokenList }
                VStack(alignment: .leading, spacing: 24) { homeCard; tokenList }
            }
            Text(MiL10n.text("po_layout_tokens"))
                .font(.caption.monospaced())
                .foregroundStyle(T.muted)
                .fixedSize(horizontal: false, vertical: true)
            ForEach(style.sections) { section in
                DisclosureGroup {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(MiL10n.text(section.summary))
                        ForEach(section.bullets, id: \.self) { bullet in
                            Text("— " + MiL10n.text(bullet))
                        }
                    }
                    .font(.callout)
                    .foregroundStyle(T.muted)
                    .padding(.vertical, 12)
                } label: {
                    Text(MiL10n.text(section.title)).font(.headline)
                }
                .padding(.vertical, 4)
            }
            Text(MiL10n.text("po_avoid"))
                .font(.callout)
                .foregroundStyle(T.muted)
        }
    }

    private var homeCard: some View {
        MiPlayfulOutlineHomePreview(
            style: style,
            focus: MiCardFocus(scale: 1, opacity: 1, shadowOpacity: 0, borderOpacity: 1, zIndex: 1),
            cardSize: CGSize(width: 174, height: 226),
            cornerRadius: 26,
            isDragging: false
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(MiL10n.text("po_home_preview"))
    }

    private var tokenList: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(style.visualTokens) { token in
                HStack(spacing: 10) {
                    if token.value.hasPrefix("#") {
                        Circle()
                            .fill(Color(hex: UInt(token.value.dropFirst(), radix: 16) ?? 0))
                            .frame(width: 24, height: 24)
                            .accessibilityHidden(true)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(MiL10n.text(token.name)).font(.caption.weight(.medium))
                        Text(token.value).font(.caption.monospaced()).foregroundStyle(T.muted)
                    }
                }
            }
        }
    }

    private func sectionHeading(_ title: String, _ body: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(MiL10n.text(title))
                .font(.system(.title2, design: .rounded, weight: .bold))
                .accessibilityAddTraits(.isHeader)
            Text(MiL10n.text(body)).font(.callout).foregroundStyle(T.muted)
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    private func switchLabel(_ title: String, _ body: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(MiL10n.text(title)).font(.headline)
            Text(MiL10n.text(body)).font(.caption).foregroundStyle(T.muted)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}
