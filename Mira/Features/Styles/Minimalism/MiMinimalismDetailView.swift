//
//  MiMinimalismDetailView.swift
//  Mira
//
//  Created on 2026/5/25.
//

import SwiftUI

struct MiMinimalismDetailView: View {
    let style: MiDesignStyle
    let onBack: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @State private var isDense = false
    @State private var selectedIndex = 0
    @State private var input = ""

    var body: some View {
        ZStack(alignment: .top) {
            MiMinimalismTokens.pageBackground
                .ignoresSafeArea()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: MiMinimalismTokens.sectionSpacing) {
                    hero
                    surface
                    components
                    formAndNavigation
                    states
                    implementationDetails
                    tokens
                    prompt
                }
                .padding(.horizontal, 22)
                .padding(.top, 88)
                .padding(.bottom, 50)
                .frame(maxWidth: 720, alignment: .leading)
                .frame(maxWidth: .infinity)
            }
            .scrollIndicators(.hidden)

            MiMinimalismTopBar(style: style) {
                close()
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .zIndex(20)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var hero: some View {
        MiMinimalismPanel(padding: 22) {
            VStack(alignment: .leading, spacing: 20) {
                Text(MiL10n.text("min_badge").uppercased())
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                    .foregroundStyle(MiMinimalismTokens.muted)
                    .tracking(1)

                HStack(alignment: .firstTextBaseline, spacing: 14) {
                    Text("01")
                        .font(.system(size: 14, weight: .semibold, design: .monospaced))
                        .foregroundStyle(MiMinimalismTokens.muted)
                    Text(MiL10n.text(style.name))
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundStyle(MiMinimalismTokens.ink)
                        .lineLimit(2)
                        .minimumScaleFactor(0.70)
                }

                Text(MiL10n.text("min_hero_body"))
                    .font(.system(size: 15.5, weight: .regular))
                    .foregroundStyle(MiMinimalismTokens.muted)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)

                MiMinimalismHeroPreview()
            }
        }
    }

    private var surface: some View {
        MiMinimalismSection(index: "02", titleKey: "min_surface", bodyKey: "min_surface_body") {
            LazyVGrid(columns: columns, spacing: 14) {
                MiMinimalismRuleCard(titleKey: "min_grid", bodyKey: "min_grid_body", mark: "12")
                MiMinimalismRuleCard(titleKey: "min_type", bodyKey: "min_type_body", mark: "Aa")
                MiMinimalismRuleCard(titleKey: "min_space", bodyKey: "min_space_body", mark: "8")
            }
        }
    }

    private var components: some View {
        MiMinimalismSection(index: "03", titleKey: "min_components", bodyKey: "min_components_body") {
            MiMinimalismPanel {
                VStack(alignment: .leading, spacing: 15) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        MiMinimalismButton(titleKey: "min_primary", isPrimary: true)
                        MiMinimalismButton(titleKey: "min_secondary")
                        MiMinimalismButton(titleKey: "min_disabled", isDisabled: true)
                    }

                    HStack(spacing: 8) {
                        MiMinimalismChip(titleKey: "min_selected", isSelected: true)
                        MiMinimalismChip(titleKey: "min_filter", isSelected: false)
                        MiMinimalismChip(titleKey: "min_meta", isSelected: false)
                    }
                }
            }
        }
    }

    private var formAndNavigation: some View {
        MiMinimalismSection(index: "04", titleKey: "min_input_nav", bodyKey: "min_input_nav_body") {
            VStack(spacing: 14) {
                MiMinimalismPanel {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(MiL10n.text("min_search_label").uppercased())
                            .font(.system(size: 10.5, weight: .semibold, design: .monospaced))
                            .foregroundStyle(MiMinimalismTokens.muted)
                        TextField(MiL10n.text("min_search_placeholder"), text: $input)
                            .font(.system(size: 16, weight: .regular))
                            .frame(minHeight: 44)
                        Rectangle()
                            .fill(input.isEmpty ? MiMinimalismTokens.ink.opacity(0.35) : MiMinimalismTokens.ink)
                            .frame(height: 1)
                    }
                }

                MiMinimalismPanel(padding: 10) {
                    HStack(spacing: 0) {
                        ForEach(0..<3, id: \.self) { index in
                            Button {
                                selectedIndex = index
                            } label: {
                                Text(MiL10n.text(["min_seg_grid", "min_seg_type", "min_seg_state"][index]))
                                    .font(.system(size: 12.5, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 42)
                            }
                            .buttonStyle(MiMinimalismSegmentStyle(isSelected: selectedIndex == index))
                        }
                    }
                }
            }
        }
    }

    private var states: some View {
        MiMinimalismSection(index: "05", titleKey: "min_states", bodyKey: "min_states_body") {
            LazyVGrid(columns: columns, spacing: 14) {
                MiMinimalismStateCard(titleKey: "min_empty", bodyKey: "min_empty_body", symbol: "00")
                MiMinimalismLoadingCard()
                MiMinimalismErrorCard()
                MiMinimalismStateCard(titleKey: "min_selected", bodyKey: "min_selected_body", symbol: "01")
            }
        }
    }

    private var implementationDetails: some View {
        MiMinimalismSection(index: "06", titleKey: "min_details", bodyKey: "min_details_body") {
            LazyVGrid(columns: columns, spacing: 14) {
                MiMinimalismDetailCard(titleKey: "min_rhythm_title", bodyKey: "min_rhythm_body", mark: "T")
                MiMinimalismDetailCard(titleKey: "min_error_title", bodyKey: "min_error_detail_body", mark: "!")
                MiMinimalismDetailCard(titleKey: "min_a11y_title", bodyKey: "min_a11y_body", mark: "VO")
            }
        }
    }

    private var tokens: some View {
        MiMinimalismSection(index: "07", titleKey: "min_tokens", bodyKey: "min_tokens_body") {
            LazyVGrid(columns: columns, spacing: 14) {
                MiMinimalismTokenSwatch(title: "min-paper", value: "#FCFCFA", color: MiMinimalismTokens.paper)
                MiMinimalismTokenSwatch(title: "min-ink", value: "#111111", color: MiMinimalismTokens.ink)
                MiMinimalismTokenSwatch(title: "min-hairline", value: "#D9D9D4", color: MiMinimalismTokens.hairline)
                MiMinimalismTokenSwatch(title: "min-accent", value: "#0A84FF", color: MiMinimalismTokens.accent)
            }
        }
    }

    private var prompt: some View {
        MiMinimalismSection(index: "08", titleKey: "min_prompt", bodyKey: "min_prompt_body") {
            MiMinimalismPanel {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(["min_prompt_1", "min_prompt_2", "min_prompt_3", "min_check_1", "min_check_2"], id: \.self) { key in
                        HStack(alignment: .top, spacing: 10) {
                            Text(key.contains("check") ? "/" : "+")
                                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                                .foregroundStyle(MiMinimalismTokens.ink)
                            Text(MiL10n.text(key))
                                .font(.system(size: 13.5, weight: .regular))
                                .foregroundStyle(MiMinimalismTokens.ink)
                                .lineSpacing(3)
                        }
                    }
                }
            }
        }
    }

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 156), spacing: 14)]
    }

    private func close() {
        if let onBack {
            onBack()
        } else {
            dismiss()
        }
    }
}

private struct MiMinimalismTopBar: View {
    let style: MiDesignStyle
    let onBack: () -> Void

    var body: some View {
        MiMinimalismPanel(padding: 4) {
            HStack(spacing: 10) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(MiMinimalismTopButtonStyle())
                .accessibilityLabel(MiL10n.text("c_back"))

                VStack(alignment: .leading, spacing: 1) {
                    Text(MiL10n.text(style.name))
                        .font(.system(size: 13.5, weight: .semibold))
                        .foregroundStyle(MiMinimalismTokens.ink)
                        .lineLimit(1)
                    Text(MiL10n.text(style.localizedName))
                        .font(.system(size: 11.5, weight: .regular, design: .monospaced))
                        .foregroundStyle(MiMinimalismTokens.muted)
                        .lineLimit(1)
                }

                Spacer()

                Text(MiL10n.text("c_ready").uppercased())
                    .font(.system(size: 10.5, weight: .semibold, design: .monospaced))
                    .padding(.horizontal, 10)
                    .frame(height: 32)
                    .background {
                        Rectangle()
                            .fill(MiMinimalismTokens.quiet)
                            .overlay { Rectangle().stroke(MiMinimalismTokens.ink, lineWidth: 1) }
                    }
            }
        }
    }
}

private struct MiMinimalismTopButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(configuration.isPressed ? Color.white : MiMinimalismTokens.ink)
            .background {
                Rectangle()
                    .fill(configuration.isPressed ? MiMinimalismTokens.ink : Color.white)
                    .overlay { Rectangle().stroke(MiMinimalismTokens.ink, lineWidth: 1) }
            }
    }
}

private struct MiMinimalismSegmentStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isSelected ? Color.white : MiMinimalismTokens.ink)
            .background {
                Rectangle()
                    .fill(isSelected ? MiMinimalismTokens.ink : Color.white)
                    .overlay { Rectangle().stroke(MiMinimalismTokens.ink, lineWidth: 0.75) }
            }
            .opacity(configuration.isPressed ? 0.72 : 1)
    }
}

private struct MiMinimalismHeroPreview: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isDense = false

    var body: some View {
        MiMinimalismPanel {
            HStack(alignment: .center, spacing: 18) {
                Button {
                    if reduceMotion {
                        isDense.toggle()
                    } else {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            isDense.toggle()
                        }
                    }
                } label: {
                    ZStack(alignment: .topLeading) {
                        Rectangle()
                            .fill(Color.white)
                            .overlay { MiMinimalismGrid(step: isDense ? 12 : 24, color: MiMinimalismTokens.hairline.opacity(isDense ? 0.92 : 0.66)) }
                            .overlay(alignment: .leading) {
                                Rectangle()
                                    .fill(isDense ? MiMinimalismTokens.ink : MiMinimalismTokens.accent)
                                    .frame(width: isDense ? 12 : 7)
                            }
                            .overlay(alignment: .topTrailing) {
                                Text(isDense ? "02" : "01")
                                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                    .foregroundStyle(MiMinimalismTokens.muted)
                                    .padding(10)
                            }
                            .overlay {
                                Rectangle()
                                    .stroke(MiMinimalismTokens.ink, lineWidth: 1.25)
                            }

                        VStack(alignment: .leading, spacing: isDense ? 6 : 12) {
                            Text(isDense ? "Aa" : "Grid")
                                .font(.system(size: isDense ? 38 : 27, weight: .semibold))
                                .foregroundStyle(MiMinimalismTokens.ink)
                                .lineLimit(1)
                                .minimumScaleFactor(0.72)

                            VStack(alignment: .leading, spacing: isDense ? 5 : 8) {
                                Rectangle().fill(MiMinimalismTokens.ink).frame(width: isDense ? 76 : 54, height: isDense ? 4 : 3)
                                Rectangle().fill(MiMinimalismTokens.ink.opacity(0.58)).frame(width: isDense ? 58 : 82, height: 3)
                                Rectangle().fill(MiMinimalismTokens.ink.opacity(0.26)).frame(width: isDense ? 42 : 62, height: 3)
                            }

                            Spacer(minLength: 0)

                            HStack(spacing: 5) {
                                ForEach(0..<4, id: \.self) { index in
                                    Rectangle()
                                        .fill(index == (isDense ? 2 : 0) ? MiMinimalismTokens.accent : MiMinimalismTokens.ink)
                                        .frame(width: index == (isDense ? 2 : 0) ? 20 : 9, height: 5)
                                }
                            }
                        }
                        .padding(.leading, isDense ? 24 : 22)
                        .padding(.top, 24)
                        .padding(.bottom, 14)
                    }
                    .frame(width: 134, height: 134)
                    .contentShape(Rectangle())
                }
                .buttonStyle(MiMinimalismPreviewButtonStyle())
                .accessibilityLabel(MiL10n.text("min_hero_toggle"))
                .accessibilityValue(MiL10n.text(isDense ? "min_dense" : "min_quiet"))

                VStack(alignment: .leading, spacing: 10) {
                    MiMinimalismMetricRow(labelKey: "min_metric_grid", value: isDense ? "12" : "24")
                    MiMinimalismMetricRow(labelKey: "min_metric_type", value: MiL10n.text(isDense ? "min_display" : "min_text"))
                    MiMinimalismMetricRow(labelKey: "min_metric_leading", value: isDense ? "132%" : "156%")
                    MiMinimalismMetricRow(labelKey: "min_metric_state", value: MiL10n.text(isDense ? "min_dense" : "min_quiet"))
                }
            }
        }
    }
}

private struct MiMinimalismPreviewButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .offset(x: configuration.isPressed ? 1 : 0, y: configuration.isPressed ? 1 : 0)
            .opacity(configuration.isPressed ? 0.82 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

private struct MiMinimalismRuleCard: View {
    let titleKey: String
    let bodyKey: String
    let mark: String

    var body: some View {
        MiMinimalismPanel {
            VStack(alignment: .leading, spacing: 12) {
                Text(mark)
                    .font(.system(size: 22, weight: .semibold, design: .monospaced))
                    .foregroundStyle(MiMinimalismTokens.ink)
                Text(MiL10n.text(titleKey))
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(MiMinimalismTokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 12.5, weight: .regular))
                    .foregroundStyle(MiMinimalismTokens.muted)
                    .lineSpacing(3)
            }
        }
    }
}

private struct MiMinimalismStateCard: View {
    let titleKey: String
    let bodyKey: String
    let symbol: String

    var body: some View {
        MiMinimalismPanel {
            VStack(alignment: .leading, spacing: 12) {
                Text(symbol)
                    .font(.system(size: 24, weight: .semibold, design: .monospaced))
                    .foregroundStyle(symbol == "!" ? MiColorTokens.rose500 : MiMinimalismTokens.ink)
                Text(MiL10n.text(titleKey))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(MiMinimalismTokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 12.5, weight: .regular))
                    .foregroundStyle(MiMinimalismTokens.muted)
                    .lineSpacing(3)
            }
        }
    }
}

private struct MiMinimalismDetailCard: View {
    let titleKey: String
    let bodyKey: String
    let mark: String

    var body: some View {
        MiMinimalismPanel {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center, spacing: 10) {
                    Text(mark)
                        .font(.system(size: 12.5, weight: .semibold, design: .monospaced))
                        .foregroundStyle(mark == "!" ? MiColorTokens.rose500 : MiMinimalismTokens.ink)
                        .frame(width: 34, height: 34)
                        .background {
                            Rectangle()
                                .fill(MiMinimalismTokens.quiet)
                                .overlay { Rectangle().stroke(MiMinimalismTokens.ink, lineWidth: 1) }
                        }

                    Text(MiL10n.text(titleKey))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(MiMinimalismTokens.ink)
                        .lineLimit(2)
                }

                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 12.5, weight: .regular))
                    .foregroundStyle(MiMinimalismTokens.muted)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

/// Loading state as a crisp, structural indeterminate bar: an ink segment slides
/// across a quiet track. No blur, gradient, or rounding. Reduce Motion stays static.
private struct MiMinimalismLoadingCard: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var slide = false

    var body: some View {
        MiMinimalismPanel {
            VStack(alignment: .leading, spacing: 12) {
                Text("--")
                    .font(.system(size: 24, weight: .semibold, design: .monospaced))
                    .foregroundStyle(MiMinimalismTokens.ink)
                Text(MiL10n.text("min_loading"))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(MiMinimalismTokens.ink)

                GeometryReader { geo in
                    let width = geo.size.width
                    Rectangle()
                        .fill(MiMinimalismTokens.quiet)
                        .overlay(alignment: .leading) {
                            Rectangle()
                                .fill(MiMinimalismTokens.ink)
                                .frame(width: width * 0.34)
                                .offset(x: reduceMotion ? 0 : (slide ? width * 0.66 : 0))
                        }
                        .clipShape(Rectangle())
                        .overlay {
                            Rectangle().stroke(MiMinimalismTokens.ink, lineWidth: 0.75)
                        }
                }
                .frame(height: 8)

                Text(MiL10n.text("min_loading_body"))
                    .font(.system(size: 12.5, weight: .regular))
                    .foregroundStyle(MiMinimalismTokens.muted)
                    .lineSpacing(3)
            }
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                slide = true
            }
        }
    }
}

/// Error state with a minimal recovery action: a rectangular Retry button switches
/// the card to a ready/recovered state using fill and text only.
private struct MiMinimalismErrorCard: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var recovered = false

    var body: some View {
        MiMinimalismPanel {
            VStack(alignment: .leading, spacing: 12) {
                Text(recovered ? "01" : "!")
                    .font(.system(size: 24, weight: .semibold, design: .monospaced))
                    .foregroundStyle(recovered ? MiMinimalismTokens.ink : MiColorTokens.rose500)
                Text(MiL10n.text(recovered ? "min_recovered" : "min_error"))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(MiMinimalismTokens.ink)
                Text(MiL10n.text(recovered ? "min_recovered_body" : "min_error_body"))
                    .font(.system(size: 12.5, weight: .regular))
                    .foregroundStyle(MiMinimalismTokens.muted)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)

                Button {
                    withAnimation(.easeOut(duration: reduceMotion ? 0.01 : 0.14)) {
                        recovered.toggle()
                    }
                } label: {
                    Text(MiL10n.text(recovered ? "min_recovered" : "min_retry"))
                        .font(.system(size: 13, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 44)
                }
                .buttonStyle(MiMinimalismButtonStyle(isPrimary: recovered, isDisabled: false))
            }
        }
    }
}
