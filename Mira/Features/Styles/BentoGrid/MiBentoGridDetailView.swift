//
//  MiBentoGridDetailView.swift
//  Mira
//

import SwiftUI

struct MiBentoGridDetailView: View {
    let style: MiDesignStyle
    let onBack: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedNav = 0
    @FocusState private var searchFocused: Bool

    init(style: MiDesignStyle, onBack: (() -> Void)? = nil) {
        self.style = style
        self.onBack = onBack
    }

    var body: some View {
        ZStack(alignment: .top) {
            MiBentoGridTokens.pageBackground
                .ignoresSafeArea()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: MiBentoGridTokens.sectionSpacing) {
                    hero
                    mosaicSection
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

            MiBentoTopBar(style: style) { close() }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .zIndex(20)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 16) {
            MiBentoTag(titleKey: "bento_badge", tint: MiBentoGridTokens.accent)

            Text(MiL10n.text(style.name))
                .font(.system(size: 40, weight: .heavy, design: .rounded))
                .foregroundStyle(MiBentoGridTokens.ink)
                .lineLimit(2)
                .minimumScaleFactor(0.72)
                .miStyleTitleTransition(style.id)

            Text(MiL10n.text("bento_hero_body"))
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(MiBentoGridTokens.muted)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)

            MiBentoSignatureTile()
        }
    }

    private var mosaicSection: some View {
        MiBentoSection(titleKey: "bento_mosaic", bodyKey: "bento_mosaic_body") {
            MiBentoMosaicBoard()
        }
    }

    private var styleCard: some View {
        MiBentoSection(titleKey: "bento_components", bodyKey: "bento_components_body") {
            MiBentoCell(fill: MiBentoGridTokens.surfaceAlt, padding: 16) {
                MiBentoGridHomePreview(
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
        MiBentoSection(titleKey: "bento_components", bodyKey: "bento_components_body") {
            MiBentoCell(padding: 16) {
                VStack(alignment: .leading, spacing: 14) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        MiBentoButton(titleKey: "bento_primary", systemImage: "bolt.fill", role: .primary)
                        MiBentoButton(titleKey: "bento_tonal", systemImage: "circle.lefthalf.filled", role: .tonal)
                        MiBentoButton(titleKey: "bento_outlined", systemImage: "square", role: .outlined)
                        MiBentoButton(titleKey: "bento_disabled", systemImage: "lock", role: .disabled)
                    }

                    HStack(spacing: 8) {
                        MiBentoTag(titleKey: "bento_chip_all", tint: MiBentoGridTokens.accent)
                        MiBentoTag(titleKey: "bento_chip_fav", tint: MiBentoGridTokens.accent2)
                        MiBentoTag(titleKey: "bento_chip_recent", tint: MiBentoGridTokens.muted)
                    }
                }
            }
        }
    }

    private var inputNavigation: some View {
        MiBentoSection(titleKey: "bento_input_nav", bodyKey: "bento_input_nav_body") {
            VStack(spacing: 14) {
                MiBentoCell(radius: MiBentoGridTokens.smallRadius, padding: 6) {
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(searchFocused ? MiBentoGridTokens.accent : MiBentoGridTokens.muted)
                            .padding(.leading, 8)
                        TextField(MiL10n.text("bento_search_placeholder"), text: $searchText)
                            .focused($searchFocused)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundStyle(MiBentoGridTokens.ink)
                    }
                    .frame(minHeight: 44)
                }

                MiBentoCell(radius: MiBentoGridTokens.smallRadius, padding: 6) {
                    HStack(spacing: 6) {
                        ForEach(0..<3, id: \.self) { index in
                            Button {
                                selectedNav = index
                            } label: {
                                Text(MiL10n.text(["bento_nav_overview", "bento_nav_detail", "bento_nav_settings"][index]))
                                    .font(.system(size: 12.5, weight: .bold, design: .rounded))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 40)
                            }
                            .buttonStyle(MiBentoSegmentStyle(isSelected: selectedNav == index))
                        }
                    }
                }
            }
        }
    }

    private var states: some View {
        MiBentoSection(titleKey: "bento_states", bodyKey: "bento_states_body") {
            LazyVGrid(columns: columns, spacing: 12) {
                MiBentoStateCard(titleKey: "bento_empty", bodyKey: "bento_empty_body", systemImage: "tray", tint: MiBentoGridTokens.muted)
                MiBentoLoadingCard()
                MiBentoErrorCard()
                MiBentoStateCard(titleKey: "bento_selected", bodyKey: "bento_selected_body", systemImage: "checkmark.circle.fill", tint: MiBentoGridTokens.accent)
            }
        }
    }

    private var tokensAndPrompt: some View {
        MiBentoSection(titleKey: "bento_tokens", bodyKey: "bento_tokens_body") {
            VStack(spacing: 14) {
                LazyVGrid(columns: columns, spacing: 12) {
                    MiBentoTokenSwatch(title: "bento-canvas", value: "#EEF0F4", color: MiBentoGridTokens.canvas)
                    MiBentoTokenSwatch(title: "bento-surface", value: "#FFFFFF", color: MiBentoGridTokens.surface)
                    MiBentoTokenSwatch(title: "bento-ink", value: "#1A1D24", color: MiBentoGridTokens.ink)
                    MiBentoTokenSwatch(title: "bento-accent", value: "#5B6CFF", color: MiBentoGridTokens.accent)
                    MiBentoTokenSwatch(title: "bento-accent-2", value: "#15C39A", color: MiBentoGridTokens.accent2)
                    MiBentoTokenSwatch(title: "bento-stroke", value: "#E3E6EC", color: MiBentoGridTokens.stroke)
                }

                MiBentoCell(padding: 16) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(MiL10n.text("bento_prompt"))
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundStyle(MiBentoGridTokens.ink)
                        ForEach(["bento_prompt_1", "bento_prompt_2", "bento_prompt_3", "bento_check_1", "bento_check_2"], id: \.self) { key in
                            Label(MiL10n.text(key), systemImage: key.contains("check") ? "checkmark.square" : "square.grid.2x2")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundStyle(MiBentoGridTokens.muted)
                                .fixedSize(horizontal: false, vertical: true)
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

private struct MiBentoTopBar: View {
    let style: MiDesignStyle
    let onBack: () -> Void

    var body: some View {
        MiBentoCell(radius: 20, padding: 6) {
            HStack(spacing: 10) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 15, weight: .bold))
                        .frame(width: 44, height: 44)
                        .foregroundStyle(MiBentoGridTokens.ink)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(MiL10n.text("c_back"))

                VStack(alignment: .leading, spacing: 1) {
                    Text(MiL10n.text(style.name))
                        .font(.system(size: 13.5, weight: .bold, design: .rounded))
                        .foregroundStyle(MiBentoGridTokens.ink)
                        .lineLimit(1)
                    Text(MiL10n.text(style.localizedName))
                        .font(.system(size: 11.5, weight: .medium, design: .rounded))
                        .foregroundStyle(MiBentoGridTokens.muted)
                        .lineLimit(1)
                }

                Spacer(minLength: 0)

                Text(MiL10n.text("c_ready").uppercased())
                    .font(.system(size: 10.5, weight: .black, design: .rounded))
                    .foregroundStyle(MiBentoGridTokens.accent2)
                    .padding(.horizontal, 10)
                    .frame(height: 30)
                    .background { Capsule().fill(MiBentoGridTokens.accent2.opacity(0.14)) }
            }
        }
        .frame(maxWidth: 780)
    }
}

private struct MiBentoSegmentStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isSelected ? Color.white : MiBentoGridTokens.muted)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isSelected ? MiBentoGridTokens.accent : Color.clear)
            }
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

// MARK: - Signature interaction: an interactive hero metric tile

private struct MiBentoSignatureTile: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isMonth = false

    private let weekBars: [CGFloat] = [0.4, 0.7, 0.5, 0.9, 0.55, 0.8, 0.6]
    private let monthBars: [CGFloat] = [0.5, 0.65, 0.78, 0.6, 0.92, 0.72, 1.0]

    var body: some View {
        MiBentoCell(padding: 18) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(MiL10n.text("bento_signature").uppercased())
                            .font(.system(size: 10.5, weight: .black, design: .rounded))
                            .tracking(0.5)
                            .foregroundStyle(MiBentoGridTokens.muted)
                        Text(isMonth ? "2,480" : "612")
                            .font(.system(size: 38, weight: .heavy, design: .rounded))
                            .foregroundStyle(MiBentoGridTokens.ink)
                            .contentTransition(.numericText())
                    }

                    Spacer()

                    HStack(spacing: 0) {
                        segButton("bento_view_week", selected: !isMonth) { setMonth(false) }
                        segButton("bento_view_month", selected: isMonth) { setMonth(true) }
                    }
                    .padding(3)
                    .background { Capsule(style: .continuous).fill(MiBentoGridTokens.surfaceAlt) }
                }

                HStack(alignment: .bottom, spacing: 7) {
                    let bars = isMonth ? monthBars : weekBars
                    ForEach(bars.indices, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(index == bars.count - 1 ? MiBentoGridTokens.accent : MiBentoGridTokens.accent.opacity(0.28))
                            .frame(maxWidth: .infinity)
                            .frame(height: 46 * bars[index])
                    }
                }
                .frame(height: 48, alignment: .bottom)

                VStack(spacing: 8) {
                    MiBentoMetricRow(labelKey: "bento_range", value: MiL10n.text(isMonth ? "bento_view_month" : "bento_view_week"), tint: MiBentoGridTokens.accent)
                    MiBentoMetricRow(labelKey: "bento_value", value: isMonth ? "2,480" : "612", tint: MiBentoGridTokens.accent2)
                    MiBentoMetricRow(labelKey: "bento_trend", value: isMonth ? "+12%" : "+4%", tint: MiBentoGridTokens.accent)
                }
            }
        }
        .animation(reduceMotion ? .easeOut(duration: 0.01) : .spring(response: 0.32, dampingFraction: 0.86), value: isMonth)
    }

    private func setMonth(_ value: Bool) {
        if reduceMotion {
            isMonth = value
        } else {
            withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) { isMonth = value }
        }
    }

    private func segButton(_ key: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(MiL10n.text(key))
                .font(.system(size: 11.5, weight: .bold, design: .rounded))
                .foregroundStyle(selected ? Color.white : MiBentoGridTokens.muted)
                .padding(.horizontal, 12)
                .frame(height: 28)
                .background {
                    Capsule(style: .continuous).fill(selected ? MiBentoGridTokens.accent : Color.clear)
                }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Mosaic board: spanning cells (the defining Bento trait)

private struct MiBentoMosaicBoard: View {
    var body: some View {
        Grid(horizontalSpacing: MiBentoGridTokens.gutter, verticalSpacing: MiBentoGridTokens.gutter) {
            GridRow {
                roleCell(titleKey: "bento_cell_hero", span: "2×2", systemImage: "square.grid.2x2.fill", tint: MiBentoGridTokens.accent, minHeight: 120, isHero: true)
                    .gridCellColumns(2)
                roleCell(titleKey: "bento_cell_metric", span: "1×1", systemImage: "chart.bar.fill", tint: MiBentoGridTokens.accent2, minHeight: 120)
            }
            GridRow {
                roleCell(titleKey: "bento_cell_media", span: "1×1", systemImage: "photo.fill", tint: MiBentoGridTokens.muted, minHeight: 84)
                roleCell(titleKey: "bento_cell_action", span: "1×1", systemImage: "bolt.fill", tint: MiBentoGridTokens.accent, minHeight: 84)
                roleCell(titleKey: "bento_cell_tag", span: "1×1", systemImage: "tag.fill", tint: MiBentoGridTokens.accent2, minHeight: 84)
            }
        }
    }

    private func roleCell(titleKey: String, span: String, systemImage: String, tint: Color, minHeight: CGFloat, isHero: Bool = false) -> some View {
        MiBentoCell(fill: isHero ? MiBentoGridTokens.accent.opacity(0.10) : MiBentoGridTokens.surface, radius: MiBentoGridTokens.smallRadius, padding: 14) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: systemImage)
                        .font(.system(size: isHero ? 20 : 15, weight: .bold))
                        .foregroundStyle(tint)
                    Spacer()
                    Text(span)
                        .font(.system(size: 10, weight: .black, design: .monospaced))
                        .foregroundStyle(MiBentoGridTokens.muted)
                }
                Spacer(minLength: 0)
                Text(MiL10n.text(titleKey))
                    .font(.system(size: isHero ? 16 : 13, weight: .bold, design: .rounded))
                    .foregroundStyle(MiBentoGridTokens.ink)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(minHeight: minHeight, alignment: .topLeading)
        }
    }
}
