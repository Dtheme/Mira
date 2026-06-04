//
//  MiEditorialLuxeDetailView.swift
//  Mira
//

import SwiftUI

struct MiEditorialLuxeDetailView: View {
    let style: MiDesignStyle
    let onBack: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedNav = 0
    @FocusState private var searchFocused: Bool

    private typealias EdT = MiEditorialLuxeTokens

    init(style: MiDesignStyle, onBack: (() -> Void)? = nil) {
        self.style = style
        self.onBack = onBack
    }

    var body: some View {
        ZStack(alignment: .top) {
            EdT.pageBackground
                .ignoresSafeArea()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: EdT.sectionSpacing) {
                    hero
                    surfaces
                    styleCard
                    components
                    inputNavigation
                    states
                    tokensAndPrompt
                }
                .padding(.horizontal, 20)
                .padding(.top, 86)
                .padding(.bottom, 50)
                .frame(maxWidth: 780, alignment: .leading)
                .frame(maxWidth: .infinity)
            }
            .scrollIndicators(.hidden)

            MiEdTopBar(style: style) { close() }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .zIndex(20)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 16) {
            MiEdKicker(titleKey: "ed_badge")

            Text(MiL10n.text(style.name))
                .font(EdT.serif(40, .regular))
                .foregroundStyle(EdT.ink)
                .lineLimit(2)
                .minimumScaleFactor(0.72)
                .miStyleTitleTransition(style.id)

            Text(MiL10n.text("ed_hero_body"))
                .font(.system(size: 15, weight: .regular, design: .default))
                .foregroundStyle(EdT.muted)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)

            MiEdFeature()
        }
    }

    private var surfaces: some View {
        MiEdSection(kickerKey: "ed_badge", titleKey: "ed_surfaces", bodyKey: "ed_surfaces_body") {
            LazyVGrid(columns: columns, spacing: 12) {
                MiEdStateCard(titleKey: "ed_surface_cover", bodyKey: "ed_surface_cover_body", systemImage: "photo")
                MiEdStateCard(titleKey: "ed_surface_column", bodyKey: "ed_surface_column_body", systemImage: "text.alignleft")
                MiEdStateCard(titleKey: "ed_surface_rule", bodyKey: "ed_surface_rule_body", systemImage: "minus")
            }
        }
    }

    private var styleCard: some View {
        MiEdSection(kickerKey: "ed_badge", titleKey: "ed_components", bodyKey: "ed_components_body") {
            MiEdCard(fill: EdT.cardWarm, padding: 16) {
                MiEditorialLuxeHomePreview(
                    style: style,
                    focus: MiCardFocus(scale: 1, opacity: 1, shadowOpacity: 0.2, borderOpacity: 0.4, zIndex: 1),
                    cardSize: MiSpacingTokens.homeCardRegular,
                    cornerRadius: MiSpacingTokens.homeCardRadiusRegular,
                    isDragging: false
                )
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }

    private var components: some View {
        MiEdSection(kickerKey: "ed_badge", titleKey: "ed_components", bodyKey: "ed_components_body") {
            MiEdCard(padding: 16) {
                VStack(alignment: .leading, spacing: 16) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 130), spacing: 12)], spacing: 12) {
                        MiEdButton(titleKey: "ed_primary", role: .primary)
                        MiEdButton(titleKey: "ed_secondary", role: .secondary)
                        MiEdButton(titleKey: "ed_disabled", role: .disabled)
                    }

                    HStack(spacing: 18) {
                        MiEdButton(titleKey: "ed_link", role: .link)
                        Spacer(minLength: 0)
                    }

                    Rectangle().fill(EdT.hairline).frame(height: 1)

                    HStack(spacing: 20) {
                        MiEdChip(titleKey: "ed_chip_style", isSelected: true)
                        MiEdChip(titleKey: "ed_chip_culture", isSelected: false)
                        MiEdChip(titleKey: "ed_chip_design", isSelected: false)
                        Spacer(minLength: 0)
                    }
                }
            }
        }
    }

    private var inputNavigation: some View {
        MiEdSection(kickerKey: "ed_badge", titleKey: "ed_input_nav", bodyKey: "ed_input_nav_body") {
            VStack(spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(searchFocused ? EdT.gold : EdT.muted)
                        TextField(MiL10n.text("ed_search_placeholder"), text: $searchText)
                            .font(EdT.serif(16, .regular))
                            .foregroundStyle(EdT.ink)
                            .focused($searchFocused)
                    }
                    .frame(minHeight: 40)
                    Rectangle()
                        .fill(searchFocused ? EdT.gold : EdT.hairline)
                        .frame(height: searchFocused ? 1.6 : 1)
                }
                .animation(.easeOut(duration: 0.18), value: searchFocused)

                HStack(spacing: 26) {
                    ForEach(0..<3, id: \.self) { index in
                        Button {
                            selectedNav = index
                        } label: {
                            MiEdChip(titleKey: ["ed_nav_read", "ed_nav_saved", "ed_nav_about"][index], isSelected: selectedNav == index)
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer(minLength: 0)
                }
            }
        }
    }

    private var states: some View {
        MiEdSection(kickerKey: "ed_badge", titleKey: "ed_states", bodyKey: "ed_states_body") {
            LazyVGrid(columns: columns, spacing: 12) {
                MiEdStateCard(titleKey: "ed_empty", bodyKey: "ed_empty_body", systemImage: "tray")
                MiEdLoadingCard()
                MiEdErrorCard()
                MiEdStateCard(titleKey: "ed_selected", bodyKey: "ed_selected_body", systemImage: "checkmark.seal")
            }
        }
    }

    private var tokensAndPrompt: some View {
        MiEdSection(kickerKey: "ed_badge", titleKey: "ed_tokens", bodyKey: "ed_tokens_body") {
            VStack(spacing: 14) {
                LazyVGrid(columns: columns, spacing: 12) {
                    MiEdTokenSwatch(title: "ed-paper", value: "#F6F1E9", color: EdT.paper)
                    MiEdTokenSwatch(title: "ed-ink", value: "#211C16", color: EdT.ink)
                    MiEdTokenSwatch(title: "ed-gold", value: "#AD8A52", color: EdT.gold)
                    MiEdTokenSwatch(title: "ed-muted", value: "#756B5E", color: EdT.muted)
                    MiEdTokenSwatch(title: "ed-hairline", value: "#E5DDCF", color: EdT.hairline)
                    MiEdTokenSwatch(title: "ed-cover", value: "#2A241C", color: EdT.coverInk)
                }

                MiEdCard(padding: 16) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(MiL10n.text("ed_prompt"))
                            .font(EdT.serif(18, .regular))
                            .foregroundStyle(EdT.ink)
                        ForEach(["ed_prompt_1", "ed_prompt_2", "ed_prompt_3", "ed_check_1", "ed_check_2"], id: \.self) { key in
                            HStack(alignment: .top, spacing: 10) {
                                Text(key.contains("check") ? "—" : "·")
                                    .font(EdT.serif(14, .regular))
                                    .foregroundStyle(EdT.gold)
                                Text(MiL10n.text(key))
                                    .font(.system(size: 13, weight: .regular, design: .default))
                                    .foregroundStyle(EdT.muted)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
            }
        }
    }

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 150), spacing: 12)]
    }

    private func close() {
        if let onBack { onBack() } else { dismiss() }
    }
}

private struct MiEdTopBar: View {
    let style: MiDesignStyle
    let onBack: () -> Void
    private typealias EdT = MiEditorialLuxeTokens

    var body: some View {
        MiEdCard(fill: EdT.surface, radius: 12, padding: 8) {
            HStack(spacing: 12) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(EdT.ink)
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(MiL10n.text("c_back"))

                VStack(alignment: .leading, spacing: 1) {
                    Text(MiL10n.text(style.name))
                        .font(EdT.serif(15, .regular))
                        .foregroundStyle(EdT.ink)
                        .lineLimit(1)
                    Text(MiL10n.text(style.localizedName))
                        .font(.system(size: 11, weight: .regular, design: .default))
                        .foregroundStyle(EdT.muted)
                        .lineLimit(1)
                }

                Spacer(minLength: 0)

                Text(MiL10n.text("c_ready").uppercased())
                    .font(.system(size: 10, weight: .semibold, design: .default))
                    .tracking(1.0)
                    .foregroundStyle(EdT.gold)
            }
        }
        .frame(maxWidth: 780)
    }
}

// MARK: - Signature interaction: featured story

private struct MiEdFeature: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var edition = 0
    private typealias EdT = MiEditorialLuxeTokens

    private let kickers = ["ed_feature_kicker_1", "ed_feature_kicker_2", "ed_feature_kicker_3"]
    private let titles = ["ed_feature_title_1", "ed_feature_title_2", "ed_feature_title_3"]
    private let sections = ["ed_chip_design", "ed_chip_style", "ed_chip_culture"]
    private let reads = ["6 min", "4 min", "8 min"]

    var body: some View {
        MiEdCard(padding: 0) {
            VStack(alignment: .leading, spacing: 0) {
                cover
                VStack(alignment: .leading, spacing: 14) {
                    Text(MiL10n.text("ed_feature_byline"))
                        .font(EdT.serif(13, .regular))
                        .italic()
                        .foregroundStyle(EdT.muted)

                    VStack(spacing: 10) {
                        MiEdMetricRow(labelKey: "ed_metric_edition", value: String(format: "No.%02d", edition + 1))
                        MiEdMetricRow(labelKey: "ed_metric_section", value: MiL10n.text(sections[edition]))
                        MiEdMetricRow(labelKey: "ed_metric_read", value: reads[edition])
                    }

                    Text(MiL10n.text("ed_signature_body"))
                        .font(.system(size: 12.5, weight: .regular, design: .default))
                        .foregroundStyle(EdT.muted)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(18)
            }
        }
    }

    private var cover: some View {
        Button {
            if reduceMotion { edition = (edition + 1) % 3 } else {
                withAnimation(.easeInOut(duration: 0.35)) { edition = (edition + 1) % 3 }
            }
        } label: {
            ZStack(alignment: .bottomLeading) {
                LinearGradient(
                    colors: [EdT.coverInk, Color(hex: 0x4A4034), EdT.gold.opacity(0.5)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .overlay(alignment: .topTrailing) {
                    Text(String(format: "No.%02d", edition + 1))
                        .font(.system(size: 11, weight: .semibold, design: .monospaced))
                        .foregroundStyle(EdT.paper.opacity(0.8))
                        .padding(14)
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 7) {
                        Rectangle().fill(EdT.goldSoft).frame(width: 18, height: 1.5)
                        Text(MiL10n.text(kickers[edition]))
                            .font(.system(size: 10, weight: .semibold, design: .default))
                            .tracking(1.4)
                            .foregroundStyle(EdT.goldSoft)
                    }
                    Text(MiL10n.text(titles[edition]))
                        .font(EdT.serif(28, .regular))
                        .foregroundStyle(EdT.paper)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(18)
            }
            .frame(height: 188)
            .frame(maxWidth: .infinity)
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: EdT.radius, topTrailingRadius: EdT.radius))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(MiL10n.text("ed_signature"))
        .accessibilityValue(MiL10n.text(titles[edition]))
    }
}
