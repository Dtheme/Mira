//
//  MiHanddrawnVlogDetailView.swift
//  Mira
//
//  Bespoke Hand-drawn Vlog detail page: a Korean film-diary scrapbook feed.
//  Signature interaction = a polaroid "memory board" you tap to flip through days.
//  Built from the style's own primitives (MiHanddrawnVlogComponents); does NOT
//  reuse any other style's detail template.
//

import SwiftUI

struct MiHanddrawnVlogDetailView: View {
    let style: MiDesignStyle
    let onBack: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @State private var noteText = ""
    @State private var selectedNav = 0
    @FocusState private var noteFocused: Bool

    private typealias HV = MiHanddrawnVlogTokens

    init(style: MiDesignStyle, onBack: (() -> Void)? = nil) {
        self.style = style
        self.onBack = onBack
    }

    var body: some View {
        ZStack(alignment: .top) {
            HV.pageBackground.ignoresSafeArea()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: HV.sectionSpacing) {
                    hero
                    styleCard
                    materials
                    components
                    inputNavigation
                    states
                    tokensAndPrompt
                }
                .padding(.horizontal, 20)
                .padding(.top, 86)
                .padding(.bottom, 54)
                .frame(maxWidth: 780, alignment: .leading)
                .frame(maxWidth: .infinity)
            }
            .scrollIndicators(.hidden)

            MiHVTopBar(style: style) { close() }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .zIndex(20)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: Hero

    private var hero: some View {
        VStack(alignment: .leading, spacing: 16) {
            MiHVKicker(titleKey: "hv_badge")

            Text(MiL10n.text(style.name))
                .font(HV.rounded(38, .bold))
                .foregroundStyle(HV.ink)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
                .miStyleTitleTransition(style.id)

            Text(MiL10n.text("hv_hero_body"))
                .font(HV.rounded(15, .regular))
                .foregroundStyle(HV.pencil)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)

            MiHVMemoryBoard()
        }
    }

    // MARK: Style card

    private var styleCard: some View {
        MiHVSection(kickerKey: "hv_badge", titleKey: "hv_style_card", bodyKey: "hv_style_card_body") {
            MiHVCard(fill: HV.cream, padding: 18) {
                MiHanddrawnVlogHomePreview(
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

    // MARK: Materials

    private var materials: some View {
        MiHVSection(kickerKey: "hv_badge", titleKey: "hv_materials", bodyKey: "hv_materials_body") {
            LazyVGrid(columns: columns, spacing: 12) {
                MiHVNoteCard(doodle: .wave, doodleColor: HV.clay, titleKey: "hv_mat_paper", bodyKey: "hv_mat_paper_body")
                MiHVNoteCard(doodle: .sun, doodleColor: HV.clay, titleKey: "hv_mat_photo", bodyKey: "hv_mat_photo_body")
                MiHVNoteCard(doodle: .star, doodleColor: HV.butter, titleKey: "hv_mat_tape", bodyKey: "hv_mat_tape_body")
                MiHVNoteCard(doodle: .heart, doodleColor: HV.rose, titleKey: "hv_mat_doodle", bodyKey: "hv_mat_doodle_body")
            }
        }
    }

    // MARK: Components

    private var components: some View {
        MiHVSection(kickerKey: "hv_badge", titleKey: "hv_components", bodyKey: "hv_components_body") {
            MiHVCard(padding: 16) {
                VStack(alignment: .leading, spacing: 16) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 130), spacing: 12)], spacing: 12) {
                        MiHVButton(titleKey: "hv_primary", role: .primary)
                        MiHVButton(titleKey: "hv_secondary", role: .secondary)
                        MiHVButton(titleKey: "hv_disabled", role: .disabled)
                    }

                    HStack(spacing: 18) {
                        MiHVButton(titleKey: "hv_link", role: .link)
                        Spacer(minLength: 0)
                    }

                    MiHVWave()
                        .stroke(HV.shadow.opacity(0.7), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                        .frame(height: 6)

                    HStack(spacing: 12) {
                        MiHVChip(titleKey: "hv_chip_today", isSelected: true)
                        MiHVChip(titleKey: "hv_chip_film", isSelected: false)
                        MiHVChip(titleKey: "hv_chip_trip", isSelected: false)
                        Spacer(minLength: 0)
                    }
                }
            }
        }
    }

    // MARK: Input & navigation

    private var inputNavigation: some View {
        MiHVSection(kickerKey: "hv_badge", titleKey: "hv_input_nav", bodyKey: "hv_input_nav_body") {
            MiHVCard(padding: 16) {
                VStack(spacing: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 10) {
                            MiHVHeart()
                                .fill(noteFocused ? HV.rose : HV.pencil)
                                .frame(width: 13, height: 13)
                            TextField(MiL10n.text("hv_search_placeholder"), text: $noteText)
                                .font(HV.rounded(15, .regular))
                                .foregroundStyle(HV.ink)
                                .focused($noteFocused)
                        }
                        .frame(minHeight: 40)
                        RoundedRectangle(cornerRadius: 2, style: .continuous)
                            .fill(noteFocused ? HV.rose : HV.shadow.opacity(0.7))
                            .frame(height: noteFocused ? 2.2 : 1.4)
                    }
                    .animation(.easeOut(duration: 0.18), value: noteFocused)

                    HStack(spacing: 14) {
                        ForEach(0..<3, id: \.self) { index in
                            Button {
                                selectedNav = index
                            } label: {
                                MiHVChip(titleKey: ["hv_nav_diary", "hv_nav_film", "hv_nav_me"][index], isSelected: selectedNav == index)
                            }
                            .buttonStyle(.plain)
                        }
                        Spacer(minLength: 0)
                    }
                }
            }
        }
    }

    // MARK: States

    private var states: some View {
        MiHVSection(kickerKey: "hv_badge", titleKey: "hv_states", bodyKey: "hv_states_body") {
            LazyVGrid(columns: columns, spacing: 12) {
                emptyCard
                MiHVLoadingNote()
                MiHVErrorNote()
                MiHVNoteCard(doodle: .star, doodleColor: HV.rose, titleKey: "hv_selected", bodyKey: "hv_selected_body")
            }
        }
    }

    private var emptyCard: some View {
        MiHVCard(padding: 14) {
            VStack(alignment: .leading, spacing: 8) {
                MiHVMascot(size: 50)
                Text(MiL10n.text("hv_empty"))
                    .font(HV.rounded(14.5, .semibold))
                    .foregroundStyle(HV.ink)
                Text(MiL10n.text("hv_empty_body"))
                    .font(HV.rounded(12, .regular))
                    .foregroundStyle(HV.pencil)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    // MARK: Tokens & prompt

    private var tokensAndPrompt: some View {
        MiHVSection(kickerKey: "hv_badge", titleKey: "hv_tokens", bodyKey: "hv_tokens_body") {
            VStack(spacing: 14) {
                LazyVGrid(columns: columns, spacing: 12) {
                    MiHVSwatch(name: "hv-cream", hex: "#F6EFE1", color: HV.cream)
                    MiHVSwatch(name: "hv-ink", hex: "#4B4138", color: HV.ink)
                    MiHVSwatch(name: "hv-rose", hex: "#E0A79C", color: HV.rose)
                    MiHVSwatch(name: "hv-butter", hex: "#EAD6A0", color: HV.butter)
                    MiHVSwatch(name: "hv-matcha", hex: "#A9B795", color: HV.matcha)
                    MiHVSwatch(name: "hv-clay", hex: "#C7896B", color: HV.clay)
                }

                MiHVCard(padding: 16) {
                    VStack(alignment: .leading, spacing: 11) {
                        Text(MiL10n.text("hv_prompt"))
                            .font(HV.rounded(17, .semibold))
                            .foregroundStyle(HV.ink)
                        ForEach(["hv_prompt_1", "hv_prompt_2", "hv_prompt_3", "hv_check_1", "hv_check_2"], id: \.self) { key in
                            HStack(alignment: .top, spacing: 10) {
                                MiHVDoodle(
                                    kind: key.contains("check") ? .heart : .star,
                                    size: 12,
                                    color: key.contains("check") ? HV.matcha : HV.rose
                                )
                                .padding(.top, 2)
                                Text(MiL10n.text(key))
                                    .font(HV.rounded(13, .regular))
                                    .foregroundStyle(HV.pencil)
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

// MARK: - Signature interaction: polaroid memory board

private struct MiHVMemoryBoard: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var index = 0
    private typealias HV = MiHanddrawnVlogTokens

    private let captions = ["hv_mem_cap_1", "hv_mem_cap_2", "hv_mem_cap_3"]
    private let dates = ["5.24", "6.02", "6.11"]

    var body: some View {
        MiHVCard(padding: 18) {
            VStack(spacing: 16) {
                Button {
                    cycle()
                } label: {
                    MiHVPolaroid(
                        photoIndex: index,
                        date: dates[index],
                        caption: MiL10n.text(captions[index]),
                        width: 208,
                        tilt: index.isMultiple(of: 2) ? -3 : 3
                    )
                    .id(index)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .transition(reduceMotion ? .opacity : .opacity.combined(with: .scale(scale: 0.96)))

                HStack(spacing: 7) {
                    ForEach(0..<3, id: \.self) { dot in
                        Circle()
                            .fill(dot == index ? HV.rose : HV.shadow.opacity(0.8))
                            .frame(width: 6, height: 6)
                    }
                    Spacer(minLength: 0)
                    Text(MiL10n.text("hv_tap_hint"))
                        .font(HV.hand(12, .semibold))
                        .italic()
                        .foregroundStyle(HV.pencil)
                }
            }
        }
    }

    private func cycle() {
        if reduceMotion {
            index = (index + 1) % 3
        } else {
            withAnimation(.spring(response: 0.34, dampingFraction: 0.82)) {
                index = (index + 1) % 3
            }
        }
    }
}
