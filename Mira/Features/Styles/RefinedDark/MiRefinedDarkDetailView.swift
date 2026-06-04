//
//  MiRefinedDarkDetailView.swift
//  Mira
//

import SwiftUI

struct MiRefinedDarkDetailView: View {
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
            MiRefinedDarkTokens.pageBackground
                .ignoresSafeArea()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: MiRefinedDarkTokens.sectionSpacing) {
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

            MiRDTopBar(style: style) { close() }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .zIndex(20)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 16) {
            MiRDChip(titleKey: "rd_badge", tint: MiRefinedDarkTokens.accent)

            Text(MiL10n.text(style.name))
                .font(.system(size: 38, weight: .semibold, design: .rounded))
                .foregroundStyle(MiRefinedDarkTokens.ink)
                .lineLimit(2)
                .minimumScaleFactor(0.72)
                .miStyleTitleTransition(style.id)

            Text(MiL10n.text("rd_hero_body"))
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundStyle(MiRefinedDarkTokens.muted)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)

            MiRDSignature()
        }
    }

    private var surfaces: some View {
        MiRDSection(titleKey: "rd_surfaces", bodyKey: "rd_surfaces_body") {
            LazyVGrid(columns: columns, spacing: 12) {
                MiRDStateCard(titleKey: "rd_surface_card", bodyKey: "rd_surface_card_body", systemImage: "rectangle.portrait", tint: MiRefinedDarkTokens.accent)
                MiRDStateCard(titleKey: "rd_surface_field", bodyKey: "rd_surface_field_body", systemImage: "character.cursor.ibeam", tint: MiRefinedDarkTokens.positive)
                MiRDStateCard(titleKey: "rd_surface_segment", bodyKey: "rd_surface_segment_body", systemImage: "square.split.2x1", tint: MiRefinedDarkTokens.accentDeep)
            }
        }
    }

    private var styleCard: some View {
        MiRDSection(titleKey: "rd_components", bodyKey: "rd_components_body") {
            MiRDCard(fill: MiRefinedDarkTokens.base, padding: 16) {
                MiRefinedDarkHomePreview(
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
        MiRDSection(titleKey: "rd_components", bodyKey: "rd_components_body") {
            MiRDCard(padding: 16) {
                VStack(alignment: .leading, spacing: 14) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        MiRDButton(titleKey: "rd_primary", systemImage: "bolt.fill", role: .primary)
                        MiRDButton(titleKey: "rd_secondary", systemImage: "square.on.square", role: .secondary)
                        MiRDButton(titleKey: "rd_ghost", systemImage: "circle", role: .ghost)
                        MiRDButton(titleKey: "rd_disabled", systemImage: "lock", role: .disabled)
                    }

                    HStack(spacing: 8) {
                        MiRDChip(titleKey: "rd_chip_all", tint: MiRefinedDarkTokens.accent)
                        MiRDChip(titleKey: "rd_chip_active", tint: MiRefinedDarkTokens.positive)
                        MiRDChip(titleKey: "rd_chip_done", tint: MiRefinedDarkTokens.muted)
                    }
                }
            }
        }
    }

    private var inputNavigation: some View {
        MiRDSection(titleKey: "rd_input_nav", bodyKey: "rd_input_nav_body") {
            VStack(spacing: 14) {
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(searchFocused ? MiRefinedDarkTokens.accent : MiRefinedDarkTokens.muted)
                    TextField(MiL10n.text("rd_search_placeholder"), text: $searchText)
                        .focused($searchFocused)
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundStyle(MiRefinedDarkTokens.ink)
                }
                .padding(.horizontal, 14)
                .frame(minHeight: 48)
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(MiRefinedDarkTokens.surface)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .strokeBorder(searchFocused ? MiRefinedDarkTokens.accent.opacity(0.7) : MiRefinedDarkTokens.hairlineStrong, lineWidth: searchFocused ? 1.4 : 1)
                        }
                }
                .animation(.easeOut(duration: 0.16), value: searchFocused)

                MiRDCard(radius: 12, padding: 5) {
                    HStack(spacing: 5) {
                        ForEach(0..<3, id: \.self) { index in
                            Button {
                                selectedNav = index
                            } label: {
                                Text(MiL10n.text(["rd_nav_overview", "rd_nav_tasks", "rd_nav_insights"][index]))
                                    .font(.system(size: 12.5, weight: .semibold, design: .rounded))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 40)
                            }
                            .buttonStyle(MiRDSegmentStyle(isSelected: selectedNav == index))
                        }
                    }
                }
            }
        }
    }

    private var states: some View {
        MiRDSection(titleKey: "rd_states", bodyKey: "rd_states_body") {
            LazyVGrid(columns: columns, spacing: 12) {
                MiRDStateCard(titleKey: "rd_empty", bodyKey: "rd_empty_body", systemImage: "tray", tint: MiRefinedDarkTokens.muted)
                MiRDLoadingCard()
                MiRDErrorCard()
                MiRDStateCard(titleKey: "rd_selected", bodyKey: "rd_selected_body", systemImage: "checkmark.circle.fill", tint: MiRefinedDarkTokens.accent)
            }
        }
    }

    private var tokensAndPrompt: some View {
        MiRDSection(titleKey: "rd_tokens", bodyKey: "rd_tokens_body") {
            VStack(spacing: 14) {
                LazyVGrid(columns: columns, spacing: 12) {
                    MiRDTokenSwatch(title: "rd-base", value: "#0E0E11", color: MiRefinedDarkTokens.base)
                    MiRDTokenSwatch(title: "rd-surface", value: "#161619", color: MiRefinedDarkTokens.surface)
                    MiRDTokenSwatch(title: "rd-ink", value: "#F4F4F7", color: MiRefinedDarkTokens.ink)
                    MiRDTokenSwatch(title: "rd-accent", value: "#7C8CFF", color: MiRefinedDarkTokens.accent)
                    MiRDTokenSwatch(title: "rd-accent-deep", value: "#5664E0", color: MiRefinedDarkTokens.accentDeep)
                    MiRDTokenSwatch(title: "rd-muted", value: "#9A9AA6", color: MiRefinedDarkTokens.muted)
                }

                MiRDCard(padding: 16) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(MiL10n.text("rd_prompt"))
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(MiRefinedDarkTokens.ink)
                        ForEach(["rd_prompt_1", "rd_prompt_2", "rd_prompt_3", "rd_check_1", "rd_check_2"], id: \.self) { key in
                            Label(MiL10n.text(key), systemImage: key.contains("check") ? "checkmark.circle" : "circle.dotted")
                                .font(.system(size: 13, weight: .regular, design: .rounded))
                                .foregroundStyle(MiRefinedDarkTokens.muted)
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

private struct MiRDTopBar: View {
    let style: MiDesignStyle
    let onBack: () -> Void

    var body: some View {
        MiRDCard(fill: MiRefinedDarkTokens.surface, radius: 14, padding: 6) {
            HStack(spacing: 10) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(MiRefinedDarkTokens.ink)
                        .frame(width: 44, height: 44)
                        .background { RoundedRectangle(cornerRadius: 11, style: .continuous).fill(MiRefinedDarkTokens.surfaceRaised).overlay { RoundedRectangle(cornerRadius: 11, style: .continuous).strokeBorder(MiRefinedDarkTokens.hairlineStrong, lineWidth: 1) } }
                }
                .buttonStyle(.plain)
                .accessibilityLabel(MiL10n.text("c_back"))

                VStack(alignment: .leading, spacing: 1) {
                    Text(MiL10n.text(style.name))
                        .font(.system(size: 13.5, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiRefinedDarkTokens.ink)
                        .lineLimit(1)
                    Text(MiL10n.text(style.localizedName))
                        .font(.system(size: 11.5, weight: .regular, design: .rounded))
                        .foregroundStyle(MiRefinedDarkTokens.muted)
                        .lineLimit(1)
                }

                Spacer(minLength: 0)

                MiRDChip(titleKey: "c_ready", tint: MiRefinedDarkTokens.positive)
            }
        }
        .frame(maxWidth: 780)
    }
}

// MARK: - Signature interaction: status control

private struct MiRDSignature: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var status = 1   // 0 backlog, 1 in progress, 2 done

    private let statusKeys = ["rd_status_backlog", "rd_status_progress", "rd_status_done"]
    private let progressValues: [Double] = [0.12, 0.64, 1.0]
    private let priorityKeys = ["rd_priority_low", "rd_priority_high", "rd_priority_med"]

    var body: some View {
        MiRDCard(padding: 18) {
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .center, spacing: 18) {
                    ring.frame(width: 132)
                    metrics
                }
                VStack(alignment: .leading, spacing: 16) {
                    ring.frame(maxWidth: .infinity)
                    metrics
                }
            }
        }
        .animation(reduceMotion ? .easeOut(duration: 0.01) : .spring(response: 0.34, dampingFraction: 0.84), value: status)
    }

    private var ring: some View {
        Button {
            if reduceMotion { status = (status + 1) % 3 } else {
                withAnimation(.spring(response: 0.34, dampingFraction: 0.84)) { status = (status + 1) % 3 }
            }
        } label: {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(MiRefinedDarkTokens.surfaceRaised, lineWidth: 9)
                    Circle()
                        .trim(from: 0, to: progressValues[status])
                        .stroke(
                            LinearGradient(colors: [MiRefinedDarkTokens.accent, MiRefinedDarkTokens.accentDeep], startPoint: .topLeading, endPoint: .bottomTrailing),
                            style: StrokeStyle(lineWidth: 9, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .shadow(color: MiRefinedDarkTokens.accent.opacity(0.4), radius: 6)
                    Text("\(Int(progressValues[status] * 100))%")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiRefinedDarkTokens.ink)
                        .contentTransition(.numericText())
                }
                .frame(width: 108, height: 108)

                Text(MiL10n.text(statusKeys[status]))
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiRefinedDarkTokens.ink)
                    .padding(.horizontal, 14)
                    .frame(height: 32)
                    .background { Capsule().fill(MiRefinedDarkTokens.surfaceRaised).overlay { Capsule().strokeBorder(MiRefinedDarkTokens.accent.opacity(0.4), lineWidth: 1) } }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(MiL10n.text("rd_signature"))
        .accessibilityValue(MiL10n.text(statusKeys[status]))
    }

    private var metrics: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(MiL10n.text("rd_signature"), systemImage: "circle.grid.cross")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(MiRefinedDarkTokens.ink)

            Text(MiL10n.text("rd_signature_body"))
                .font(.system(size: 12.5, weight: .regular, design: .rounded))
                .foregroundStyle(MiRefinedDarkTokens.muted)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)

            MiRDMetricRow(labelKey: "rd_metric_status", value: MiL10n.text(statusKeys[status]), tint: MiRefinedDarkTokens.accent)
            MiRDMetricRow(labelKey: "rd_metric_progress", value: "\(Int(progressValues[status] * 100))%", tint: MiRefinedDarkTokens.positive)
            MiRDMetricRow(labelKey: "rd_metric_priority", value: MiL10n.text(priorityKeys[status]), tint: MiRefinedDarkTokens.accentDeep)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
