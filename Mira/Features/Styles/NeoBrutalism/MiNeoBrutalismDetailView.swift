//
//  MiNeoBrutalismDetailView.swift
//  Mira
//
//  Created on 2026/5/22.
//

import SwiftUI

struct MiNeoBrutalismDetailView: View {
    let style: MiDesignStyle
    let onBack: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @State private var selectedSpec = "slot_tokens"
    @State private var selectedSegment = "slot_tokens"
    @State private var inspectModeOn = true
    @State private var searchText = MiL10n.text("nbd_hard_shadow")
    @State private var showsInspector = false
    @State private var isRevealed = false

    init(style: MiDesignStyle, onBack: (() -> Void)? = nil) {
        self.style = style
        self.onBack = onBack
    }

    var body: some View {
        ZStack(alignment: .top) {
            MiNeoBrutalismGridBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    MiNeoBrutalismHeroView(style: style)
                        .miStaggeredReveal(index: 0, isRevealed: isRevealed)

                    MiNeoBrutalismStyleDNASection()
                        .miStaggeredReveal(index: 1, isRevealed: isRevealed)

                    MiNeoBrutalismShadowSection()
                        .miStaggeredReveal(index: 2, isRevealed: isRevealed)

                    MiNeoBrutalismCoreComponentsSection(
                        selectedSpec: $selectedSpec,
                        inspectModeOn: $inspectModeOn
                    )
                    .miStaggeredReveal(index: 3, isRevealed: isRevealed)

                    MiNeoBrutalismLayoutPatternSection(selectedSpec: $selectedSpec)
                        .miStaggeredReveal(index: 4, isRevealed: isRevealed)

                    MiNeoBrutalismFormSection(searchText: $searchText)
                        .miStaggeredReveal(index: 5, isRevealed: isRevealed)

                    MiNeoBrutalismInspectorSection {
                        showsInspector = true
                    }
                    .miStaggeredReveal(index: 6, isRevealed: isRevealed)

                    MiNeoBrutalismStatesSection()
                        .miStaggeredReveal(index: 7, isRevealed: isRevealed)

                    MiNeoBrutalismPromptSection(selectedSegment: $selectedSegment)
                        .miStaggeredReveal(index: 8, isRevealed: isRevealed)
                }
                .padding(.horizontal, 18)
                .padding(.top, 104)
                .padding(.bottom, 40)
                .frame(maxWidth: 860, alignment: .leading)
                .frame(maxWidth: .infinity)
            }
            .scrollIndicators(.hidden)

            MiNeoBrutalismTopBar(style: style) {
                close()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .zIndex(20)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showsInspector) {
            MiNeoBrutalismInspectorSheet {
                showsInspector = false
            }
            .presentationDetents([.medium, .large])
        }
        .onAppear {
            triggerReveal()
        }
    }

    private func triggerReveal() {
        guard !isRevealed else { return }
        DispatchQueue.main.async {
            isRevealed = true
        }
    }

    private func close() {
        if let onBack {
            onBack()
        } else {
            dismiss()
        }
    }
}

private struct MiNeoBrutalismTopBar: View {
    let style: MiDesignStyle
    let onBack: () -> Void

    var body: some View {
        MiNeoBrutalismCard(fill: MiNeoBrutalismTokens.paper, radius: MiNeoBrutalismTokens.radiusMD, shadow: MiNeoBrutalismTokens.shadowSmall, padding: 8) {
            HStack(spacing: 10) {
                MiNeoBrutalismButton("c_back", systemImage: "chevron.left", variant: .secondary, action: onBack)
                    .frame(width: 98)

                VStack(alignment: .leading, spacing: 2) {
                    let displayName = MiL10n.text(style.name)
                    let localizedName = MiL10n.text(style.localizedName)

                    Text(displayName)
                        .font(MiNeoBrutalismTokens.label)
                        .foregroundStyle(MiNeoBrutalismTokens.ink)
                        .lineLimit(1)
                        .miStyleTitleTransition(style.id)

                    if localizedName != displayName {
                        Text(localizedName)
                            .font(.system(size: 11, weight: .black, design: .default))
                            .foregroundStyle(MiNeoBrutalismTokens.muted)
                            .lineLimit(1)
                    }
                }
                .layoutPriority(1)

                Spacer(minLength: 8)

                MiNeoBrutalismPill("c_ready", fill: MiNeoBrutalismTokens.green)
            }
        }
        .frame(maxWidth: 860)
    }
}

private struct MiNeoBrutalismHeroView: View {
    let style: MiDesignStyle

    var body: some View {
        MiNeoBrutalismCard(fill: MiNeoBrutalismTokens.paper, radius: MiNeoBrutalismTokens.radiusMD, shadow: MiNeoBrutalismTokens.shadowLarge, padding: 18) {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 10) {
                    MiNeoBrutalismPill("nb_badge", fill: MiNeoBrutalismTokens.greenSoft)

                    Text(MiL10n.text("nb_title"))
                        .font(MiNeoBrutalismTokens.headline)
                        .foregroundStyle(MiNeoBrutalismTokens.ink)
                        .lineSpacing(1)
                        .lineLimit(2)
                        .minimumScaleFactor(0.68)

                    Text(MiL10n.text("nb_lead"))
                        .font(MiNeoBrutalismTokens.body)
                        .foregroundStyle(MiNeoBrutalismTokens.muted)
                        .lineSpacing(4)
                        .lineLimit(4)
                        .fixedSize(horizontal: false, vertical: true)
                }

                MiNeoBrutalismPreviewStage()
            }
        }
        .accessibilityElement(children: .combine)
    }
}

private struct MiNeoBrutalismPreviewStage: View {
    @State private var isOn = true
    @State private var tapCount = 3
    @State private var isPressed = false

    var body: some View {
        MiNeoBrutalismCard(
            fill: MiNeoBrutalismTokens.yellow,
            radius: MiNeoBrutalismTokens.radiusMD,
            shadow: MiNeoBrutalismTokens.shadowMedium,
            padding: 16
        ) {
            HStack(alignment: .center, spacing: 16) {
                MiNeoBrutalismHeroPunchButton(
                    isOn: isOn,
                    isPressed: isPressed
                )
                .frame(width: 116, height: 116)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            guard !isPressed else { return }
                            withAnimation(MiNeoBrutalismTokens.motion) {
                                isPressed = true
                            }
                        }
                        .onEnded { _ in
                            withAnimation(MiNeoBrutalismTokens.motion) {
                                isPressed = false
                                isOn.toggle()
                                tapCount += 1
                            }
                        }
                )

                VStack(alignment: .leading, spacing: 10) {
                    MiNeoBrutalismHeroMetric(
                        titleKey: "nb_hero_metric_status",
                        value: MiL10n.text(isOn ? "nb_hero_state_on" : "nb_hero_state_off"),
                        accent: isOn ? MiNeoBrutalismTokens.green : MiNeoBrutalismTokens.red
                    )
                    MiNeoBrutalismHeroMetric(
                        titleKey: "nb_hero_metric_count",
                        value: String(format: "%02d", tapCount),
                        accent: MiNeoBrutalismTokens.blue
                    )
                    MiNeoBrutalismHeroMetric(
                        titleKey: "nb_hero_metric_mode",
                        value: MiL10n.text(isOn ? "nb_hero_mode_punch" : "nb_hero_mode_idle"),
                        accent: isOn ? MiNeoBrutalismTokens.orange : MiNeoBrutalismTokens.paperBlue
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

private struct MiNeoBrutalismHeroPunchButton: View {
    let isOn: Bool
    let isPressed: Bool

    var body: some View {
        let offset: CGSize = isPressed ? MiNeoBrutalismTokens.pressOffset : .zero
        let shadow: CGSize = isPressed ? .zero : MiNeoBrutalismTokens.shadowLarge

        ZStack {
            MiNeoBrutalismSurface(
                shape: RoundedRectangle(cornerRadius: MiNeoBrutalismTokens.radiusMD, style: .continuous),
                fill: isOn ? MiNeoBrutalismTokens.green : MiNeoBrutalismTokens.surface,
                lineWidth: MiNeoBrutalismTokens.lineWidth,
                shadow: shadow
            )

            VStack(spacing: 6) {
                Image(systemName: isOn ? "bolt.fill" : "bolt")
                    .font(.system(size: 38, weight: .heavy))
                    .foregroundStyle(MiNeoBrutalismTokens.ink)

                Text(MiL10n.text(isOn ? "nb_hero_label_on" : "nb_hero_label_off"))
                    .font(.system(size: 11, weight: .black, design: .default))
                    .foregroundStyle(MiNeoBrutalismTokens.ink)
                    .tracking(1.4)
                    .textCase(.uppercase)
            }
        }
        .offset(offset)
    }
}

private struct MiNeoBrutalismHeroMetric: View {
    let titleKey: String
    let value: String
    let accent: Color

    var body: some View {
        HStack(spacing: 8) {
            Text(MiL10n.text(titleKey))
                .font(.system(size: 11, weight: .black, design: .default))
                .foregroundStyle(MiNeoBrutalismTokens.ink)
                .tracking(0.6)
                .textCase(.uppercase)

            Spacer(minLength: 6)

            Text(value)
                .font(.system(size: 12, weight: .black, design: .monospaced))
                .foregroundStyle(MiNeoBrutalismTokens.ink)
                .lineLimit(1)
                .padding(.horizontal, 9)
                .frame(height: 24)
                .background {
                    MiNeoBrutalismSurface(
                        shape: RoundedRectangle(cornerRadius: MiNeoBrutalismTokens.radiusXS, style: .continuous),
                        fill: accent,
                        lineWidth: MiNeoBrutalismTokens.thinLineWidth,
                        shadow: CGSize(width: 2.5, height: 2.5)
                    )
                }
        }
    }
}

private struct MiNeoBrutalismStyleDNASection: View {
    private let columns = [GridItem(.adaptive(minimum: 148), spacing: 14)]

    var body: some View {
        MiNeoBrutalismSection(
            title: "nb_style_dna",
            subtitle: "nb_no_soft_skeuomorphic"
        ) {
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(MiNeoBrutalismDemoContent.tokenItems.prefix(4)) { item in
                    MiNeoBrutalismTokenSwatch(title: item.title, value: item.value, detail: item.detail, color: item.color)
                }
            }
        }
    }
}

private struct MiNeoBrutalismShadowSection: View {
    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 14)]

    var body: some View {
        MiNeoBrutalismSection(
            title: "nb_shadow_tokens",
            subtitle: "nb_shadows_hard_offsets"
        ) {
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(MiNeoBrutalismDemoContent.shadowItems) { item in
                    MiNeoBrutalismShadowSample(title: item.title, value: item.value, shadow: item.shadow, isPressed: item.isPressed)
                }
            }
        }
    }
}

private struct MiNeoBrutalismCoreComponentsSection: View {
    @Binding var selectedSpec: String
    @Binding var inspectModeOn: Bool

    var body: some View {
        MiNeoBrutalismSection(
            title: "nb_core_components",
            subtitle: "nb_buttons_toggles_tabs"
        ) {
            MiNeoBrutalismCard(fill: MiNeoBrutalismTokens.paper, radius: MiNeoBrutalismTokens.radiusMD, shadow: MiNeoBrutalismTokens.shadowMedium, padding: 16) {
                VStack(alignment: .leading, spacing: 16) {
                    MiNeoBrutalismSegmentedControl(items: MiNeoBrutalismDemoContent.specTabs, selection: $selectedSpec)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 132), spacing: 12)], spacing: 12) {
                        MiNeoBrutalismButton("algc_primary", systemImage: "arrow.up.right", variant: .primary)
                        MiNeoBrutalismButton("algc_secondary", systemImage: "rectangle.stack", variant: .secondary)
                        MiNeoBrutalismButton("algc_destructive", systemImage: "trash", variant: .destructive)
                        MiNeoBrutalismButton("algc_disabled", systemImage: "lock", variant: .disabled)
                    }

                    MiNeoBrutalismToggle(isOn: $inspectModeOn, title: "nb_inspect_mode")

                    HStack(spacing: 10) {
                        MiNeoBrutalismPill("nb_3pt_border", fill: MiNeoBrutalismTokens.greenSoft)
                        MiNeoBrutalismPill("nb_hard_shadow", fill: MiNeoBrutalismTokens.yellow)
                        MiNeoBrutalismPill("nb_no_blur", fill: Color(hex: 0xDDDDDD), isDisabled: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

private struct MiNeoBrutalismLayoutPatternSection: View {
    @Binding var selectedSpec: String

    var body: some View {
        MiNeoBrutalismSection(
            title: "nb_system_pattern",
            subtitle: "nb_system_pattern_desc"
        ) {
            MiNeoBrutalismSystemLayout(selectedSpec: $selectedSpec)
        }
    }
}

private struct MiNeoBrutalismSystemLayout: View {
    @Binding var selectedSpec: String

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .top, spacing: 16) {
                controller
                    .frame(width: 230)
                stage
                feedback
                    .frame(width: 220)
            }

            VStack(spacing: 16) {
                controller
                stage
                feedback
            }
        }
        .padding(14)
        .background {
            MiNeoBrutalismSurface(
                shape: RoundedRectangle(cornerRadius: MiNeoBrutalismTokens.radiusMD, style: .continuous),
                fill: MiNeoBrutalismTokens.greenSoft,
                shadow: MiNeoBrutalismTokens.shadowLarge
            )
        }
    }

    private var controller: some View {
        MiNeoBrutalismCard(fill: MiNeoBrutalismTokens.surface, radius: MiNeoBrutalismTokens.radiusMD, shadow: MiNeoBrutalismTokens.shadowSmall, padding: 14) {
            VStack(alignment: .leading, spacing: 14) {
                MiNeoBrutalismCard(fill: MiNeoBrutalismTokens.blue, radius: MiNeoBrutalismTokens.radiusSM, shadow: MiNeoBrutalismTokens.shadowSmall, padding: 14) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(MiL10n.text("nb_style_index"))
                            .font(MiNeoBrutalismTokens.caption)
                            .foregroundStyle(Color.white)
                        Text(MiL10n.text(selectedSpec))
                            .font(MiNeoBrutalismTokens.title)
                            .foregroundStyle(Color.white)
                    }
                }

                MiNeoBrutalismSegmentedControl(items: MiNeoBrutalismDemoContent.specTabs, selection: $selectedSpec)

                MiNeoBrutalismSpecCard(number: "01", title: "slot_tokens", subtitle: "nb_tokens_desc", fill: MiNeoBrutalismTokens.orange) {}
                MiNeoBrutalismSpecCard(number: "02", title: "ds_components", subtitle: "nb_components_desc", fill: MiNeoBrutalismTokens.yellow) {}
                MiNeoBrutalismSpecCard(number: "03", title: "slot_states", subtitle: "nb_states_desc", fill: MiNeoBrutalismTokens.green) {}
            }
        }
    }

    private var stage: some View {
        MiNeoBrutalismCard(fill: MiNeoBrutalismTokens.paper, radius: MiNeoBrutalismTokens.radiusMD, shadow: MiNeoBrutalismTokens.shadowLarge, padding: 16) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 8) {
                        MiNeoBrutalismPill("nb_component_stage", fill: MiNeoBrutalismTokens.greenSoft)
                        Text(MiL10n.text("nb_component_spec"))
                            .font(.system(size: 32, weight: .black, design: .default))
                            .foregroundStyle(MiNeoBrutalismTokens.ink)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer(minLength: 8)

                    Text("NB")
                        .font(.system(size: 28, weight: .black, design: .default))
                        .foregroundStyle(MiNeoBrutalismTokens.ink)
                        .frame(width: 64, height: 64)
                        .background {
                            MiNeoBrutalismSurface(
                                shape: RoundedRectangle(cornerRadius: MiNeoBrutalismTokens.radiusSM, style: .continuous),
                                fill: MiNeoBrutalismTokens.yellow,
                                shadow: CGSize(width: 4, height: 4)
                            )
                        }
                }

                MiNeoBrutalismComponentBoard()
            }
        }
    }

    private var feedback: some View {
        MiNeoBrutalismCard(fill: MiNeoBrutalismTokens.surface, radius: MiNeoBrutalismTokens.radiusMD, shadow: MiNeoBrutalismTokens.shadowSmall, padding: 14) {
            VStack(alignment: .leading, spacing: 12) {
                MiNeoBrutalismPill("nb_prompt_rules", fill: MiNeoBrutalismTokens.greenSoft)
                MiNeoBrutalismPill("nb_no_blur", fill: MiNeoBrutalismTokens.yellow)
                MiNeoBrutalismPill("nb_3pt_border", fill: MiNeoBrutalismTokens.orangeSoft)
                MiNeoBrutalismPill("nb_press_move", fill: MiNeoBrutalismTokens.blueSoft)
                MiNeoBrutalismPill("nb_direct_labels", fill: MiNeoBrutalismTokens.surface)
            }
        }
    }
}

private struct MiNeoBrutalismComponentBoard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .center, spacing: 12) {
                Text(MiL10n.text("nb_surface_sample"))
                    .font(.system(size: 24, weight: .black, design: .default))
                    .foregroundStyle(MiNeoBrutalismTokens.ink)
                    .lineLimit(2)
                    .minimumScaleFactor(0.74)

                Spacer(minLength: 0)

                MiNeoBrutalismPill("slot_surface", fill: MiNeoBrutalismTokens.yellow)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                MiNeoBrutalismSurface(
                    shape: RoundedRectangle(cornerRadius: MiNeoBrutalismTokens.radiusSM, style: .continuous),
                    fill: MiNeoBrutalismTokens.blueSoft,
                    shadow: MiNeoBrutalismTokens.shadowMedium
                )
            }

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 116), spacing: 12)], spacing: 12) {
                MiNeoBrutalismButton("algc_primary", variant: .primary)
                MiNeoBrutalismButton("algc_secondary", variant: .secondary)
                MiNeoBrutalismButton("c_selected", variant: .primary)
                MiNeoBrutalismButton("algc_disabled", variant: .disabled)
            }

            HStack(spacing: 12) {
                MiNeoBrutalismSampleBlock(fill: MiNeoBrutalismTokens.yellow, title: "nb_3pt_border")
                MiNeoBrutalismSampleBlock(fill: MiNeoBrutalismTokens.greenSoft, title: "nb_hard_shadow")
                MiNeoBrutalismSampleBlock(fill: MiNeoBrutalismTokens.orangeSoft, title: "nb_press_move")
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 246)
        .background {
            RoundedRectangle(cornerRadius: MiNeoBrutalismTokens.radiusSM, style: .continuous)
                .fill(MiNeoBrutalismTokens.surface)
                .overlay {
                    MiNeoBrutalismBoardGrid()
                        .clipShape(RoundedRectangle(cornerRadius: MiNeoBrutalismTokens.radiusSM, style: .continuous))
                }
                .overlay {
                    RoundedRectangle(cornerRadius: MiNeoBrutalismTokens.radiusSM, style: .continuous)
                        .strokeBorder(MiNeoBrutalismTokens.ink, lineWidth: MiNeoBrutalismTokens.lineWidth)
                }
        }
    }
}

private struct MiNeoBrutalismSampleBlock: View {
    let fill: Color
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: MiNeoBrutalismTokens.radiusXS, style: .continuous)
                .fill(fill)
                .frame(height: 36)
                .overlay {
                    RoundedRectangle(cornerRadius: MiNeoBrutalismTokens.radiusXS, style: .continuous)
                        .strokeBorder(MiNeoBrutalismTokens.ink, lineWidth: MiNeoBrutalismTokens.thinLineWidth)
                }

            Text(MiL10n.text(title))
                .font(.system(size: 11, weight: .black, design: .default))
                .foregroundStyle(MiNeoBrutalismTokens.ink)
                .lineLimit(2)
                .minimumScaleFactor(0.72)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            MiNeoBrutalismSurface(
                shape: RoundedRectangle(cornerRadius: MiNeoBrutalismTokens.radiusSM, style: .continuous),
                fill: MiNeoBrutalismTokens.surface,
                lineWidth: MiNeoBrutalismTokens.thinLineWidth,
                shadow: CGSize(width: 3, height: 3)
            )
        }
    }
}

private struct MiNeoBrutalismBoardGrid: View {
    var body: some View {
        Canvas { context, size in
            var path = Path()
            let step: CGFloat = 22

            for x in stride(from: CGFloat.zero, through: size.width, by: step) {
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
            }

            for y in stride(from: CGFloat.zero, through: size.height, by: step) {
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
            }

            context.stroke(path, with: .color(MiNeoBrutalismTokens.ink.opacity(0.06)), lineWidth: 1)
        }
    }
}

private struct MiNeoBrutalismFormSection: View {
    @Binding var searchText: String

    var body: some View {
        MiNeoBrutalismSection(
            title: "nb_form_search",
            subtitle: "nb_inputs_keep_visible"
        ) {
            VStack(spacing: 14) {
                MiNeoBrutalismInput(title: "nb_search_components", placeholder: "nb_try_buttons_cards", text: $searchText, isError: false, helper: "nb_focused_inputs_blue")
                MiNeoBrutalismInput(title: "nb_error_example", placeholder: "nb_missing_token", text: .constant(""), isError: true, helper: "nb_error_copy_stays")
            }
        }
    }
}

private struct MiNeoBrutalismInspectorSection: View {
    let openInspector: () -> Void

    var body: some View {
        MiNeoBrutalismSection(
            title: "nb_sheet_inspector",
            subtitle: "nb_sheet_surface"
        ) {
            MiNeoBrutalismCard(fill: MiNeoBrutalismTokens.orangeSoft, radius: MiNeoBrutalismTokens.radiusMD, shadow: MiNeoBrutalismTokens.shadowMedium, padding: 16) {
                VStack(alignment: .leading, spacing: 14) {
                    Text(MiL10n.text("nb_prompt_inspector"))
                        .font(MiNeoBrutalismTokens.title)
                        .foregroundStyle(MiNeoBrutalismTokens.ink)

                    Text(MiL10n.text("nb_open_sheet_shows"))
                        .font(MiNeoBrutalismTokens.body)
                        .foregroundStyle(MiNeoBrutalismTokens.muted)
                        .fixedSize(horizontal: false, vertical: true)

                    MiNeoBrutalismButton("nb_open_inspector", systemImage: "sidebar.trailing", variant: .primary, action: openInspector)
                }
            }
        }
    }
}

private struct MiNeoBrutalismStatesSection: View {
    private let columns = [GridItem(.adaptive(minimum: 138), spacing: 14)]

    var body: some View {
        MiNeoBrutalismSection(
            title: "slot_states",
            subtitle: "nb_states_explicit_color"
        ) {
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(MiNeoBrutalismDemoContent.states) { state in
                    switch state.title {
                    case "algc_loading":
                        MiNeoBrutalismLoadingStateCard()
                    case "algc_error":
                        MiNeoBrutalismErrorStateCard()
                    default:
                        MiNeoBrutalismStateCard(title: state.title, detail: state.detail, systemImage: state.systemImage, fill: state.fill)
                    }
                }
            }
        }
    }
}

private struct MiNeoBrutalismPromptSection: View {
    @Binding var selectedSegment: String

    private let columns = [GridItem(.adaptive(minimum: 160), spacing: 14)]

    var body: some View {
        MiNeoBrutalismSection(
            title: "ds_prompt",
            subtitle: "nb_ai_output_operational"
        ) {
            VStack(alignment: .leading, spacing: 16) {
                MiNeoBrutalismSegmentedControl(items: MiNeoBrutalismDemoContent.segments, selection: $selectedSegment)

                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(MiNeoBrutalismDemoContent.rules) { rule in
                        MiNeoBrutalismCard(fill: MiNeoBrutalismTokens.surface, radius: MiNeoBrutalismTokens.radiusSM, shadow: MiNeoBrutalismTokens.shadowSmall, padding: 12) {
                            VStack(alignment: .leading, spacing: 10) {
                                MiNeoBrutalismPill(rule.title, fill: rule.fill)

                                Text(MiL10n.text(rule.detail))
                                    .font(.system(size: 12, weight: .bold, design: .default))
                                    .foregroundStyle(MiNeoBrutalismTokens.muted)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }

                MiNeoBrutalismCard(fill: MiNeoBrutalismTokens.paper, radius: MiNeoBrutalismTokens.radiusMD, shadow: MiNeoBrutalismTokens.shadowMedium, padding: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(MiL10n.text("ds_acceptance"))
                            .font(MiNeoBrutalismTokens.title)
                            .foregroundStyle(MiNeoBrutalismTokens.ink)

                        ForEach(MiNeoBrutalismDemoContent.acceptance, id: \.self) { item in
                            MiNeoBrutalismBulletRow(text: item, fill: MiNeoBrutalismTokens.green)
                        }
                    }
                }
            }
        }
    }
}

private struct MiNeoBrutalismStateIcon: View {
    let systemImage: String

    var body: some View {
        Image(systemName: systemImage)
            .font(.system(size: 18, weight: .black))
            .foregroundStyle(MiNeoBrutalismTokens.ink)
            .frame(width: 38, height: 38)
            .background { Circle().fill(MiNeoBrutalismTokens.surface) }
            .overlay { Circle().strokeBorder(MiNeoBrutalismTokens.ink, lineWidth: MiNeoBrutalismTokens.thinLineWidth) }
    }
}

/// Loading state as a chunky block bar (Design.md: chunky blocks or simple progress,
/// never soft shimmer). A solid blue block slides inside a hard-bordered track.
private struct MiNeoBrutalismLoadingStateCard: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var slide = false

    var body: some View {
        MiNeoBrutalismCard(fill: MiNeoBrutalismTokens.blueSoft, radius: MiNeoBrutalismTokens.radiusSM, shadow: MiNeoBrutalismTokens.shadowSmall, padding: 12) {
            VStack(alignment: .leading, spacing: 10) {
                MiNeoBrutalismStateIcon(systemImage: "arrow.triangle.2.circlepath")

                Text(MiL10n.text("algc_loading"))
                    .font(MiNeoBrutalismTokens.label)
                    .foregroundStyle(MiNeoBrutalismTokens.ink)

                GeometryReader { geo in
                    let width = geo.size.width
                    let shape = RoundedRectangle(cornerRadius: 4, style: .continuous)
                    shape
                        .fill(MiNeoBrutalismTokens.surface)
                        .overlay(alignment: .leading) {
                            Rectangle()
                                .fill(MiNeoBrutalismTokens.blue)
                                .frame(width: width * 0.4)
                                .offset(x: reduceMotion ? 0 : (slide ? width * 0.6 : 0))
                        }
                        .clipShape(shape)
                        .overlay {
                            shape.strokeBorder(MiNeoBrutalismTokens.ink, lineWidth: MiNeoBrutalismTokens.thinLineWidth)
                        }
                }
                .frame(height: 18)

                Text(MiL10n.text("nbd_chunky_blocks_soft"))
                    .font(.system(size: 12, weight: .bold, design: .default))
                    .foregroundStyle(MiNeoBrutalismTokens.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                slide = true
            }
        }
    }
}

/// Error state with a hard recovery action: a Retry button (offset + shadow collapse)
/// flips the card to a recovered/complete state. Reduce Motion keeps state, drops travel.
private struct MiNeoBrutalismErrorStateCard: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var recovered = false

    var body: some View {
        MiNeoBrutalismCard(fill: recovered ? MiNeoBrutalismTokens.greenSoft : Color(hex: 0xFFE0E0), radius: MiNeoBrutalismTokens.radiusSM, shadow: MiNeoBrutalismTokens.shadowSmall, padding: 12) {
            VStack(alignment: .leading, spacing: 10) {
                MiNeoBrutalismStateIcon(systemImage: recovered ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")

                Text(MiL10n.text(recovered ? "nbd_complete" : "algc_error"))
                    .font(MiNeoBrutalismTokens.label)
                    .foregroundStyle(MiNeoBrutalismTokens.ink)

                Text(MiL10n.text(recovered ? "nbd_green_status_short" : "nbd_red_fill_explicit"))
                    .font(.system(size: 12, weight: .bold, design: .default))
                    .foregroundStyle(MiNeoBrutalismTokens.muted)
                    .fixedSize(horizontal: false, vertical: true)

                MiNeoBrutalismButton(
                    recovered ? "algc_recovered" : "algc_retry",
                    systemImage: recovered ? "checkmark" : "arrow.clockwise",
                    variant: recovered ? .primary : .destructive
                ) {
                    withAnimation(reduceMotion ? .easeOut(duration: 0.01) : MiNeoBrutalismTokens.motion) {
                        recovered.toggle()
                    }
                }
            }
        }
    }
}

#Preview {
    MiNeoBrutalismDetailView(style: MiStyleRepository.styles[3])
}
