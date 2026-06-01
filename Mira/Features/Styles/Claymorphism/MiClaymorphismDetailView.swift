//
//  MiClaymorphismDetailView.swift
//  Mira
//
//  Created on 2026/5/29.
//

import SwiftUI

struct MiClaymorphismDetailView: View {
    let style: MiDesignStyle
    let onBack: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var selectedSegment = 0
    @State private var inputText = ""
    @State private var isPressedSample = false
    @FocusState private var inputFocused: Bool

    var body: some View {
        ZStack(alignment: .top) {
            MiClaymorphismTokens.pageBackground
                .ignoresSafeArea()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: MiClaymorphismTokens.sectionSpacing) {
                    hero
                    surfaceSystem
                    styleCard
                    componentLab
                    inputNavigation
                    states
                    tokensAndPrompt
                }
                .padding(.horizontal, 22)
                .padding(.top, 86)
                .padding(.bottom, 50)
                .frame(maxWidth: 780, alignment: .leading)
                .frame(maxWidth: .infinity)
            }
            .scrollIndicators(.hidden)

            MiClaymorphismTopBar(style: style) {
                close()
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .zIndex(20)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .animation(reduceMotion ? nil : .spring(response: 0.28, dampingFraction: 0.72), value: selectedSegment)
        .animation(reduceMotion ? nil : .spring(response: 0.22, dampingFraction: 0.68), value: isPressedSample)
    }

    private var hero: some View {
        MiClaymorphismPanel(radius: 34, padding: 22) {
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .top, spacing: 18) {
                    heroCopy
                    MiClaymorphismHeroPreview()
                        .frame(maxWidth: 368)
                }

                VStack(alignment: .leading, spacing: 18) {
                    heroCopy
                    MiClaymorphismHeroPreview()
                }
            }
        }
    }

    private var heroCopy: some View {
        VStack(alignment: .leading, spacing: 14) {
            MiClaymorphismChip(titleKey: "clay_badge", fill: MiClaymorphismTokens.butter)

            VStack(alignment: .leading, spacing: 8) {
                Text(MiL10n.text(style.name))
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.ink)
                    .lineLimit(2)
                    .minimumScaleFactor(0.68)
                Text(MiL10n.text("clay_hero_body"))
                    .font(.system(size: 15.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.muted)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var styleCard: some View {
        MiClaymorphismSection(titleKey: "clay_card_demo", bodyKey: "clay_card_demo_body") {
            MiClaymorphismPanel(radius: 30, padding: 18) {
                ViewThatFits(in: .horizontal) {
                    HStack(alignment: .center, spacing: 20) {
                        clayHomeCardDemo
                        styleCardNotes
                    }

                    VStack(alignment: .leading, spacing: 18) {
                        clayHomeCardDemo
                            .frame(maxWidth: .infinity, alignment: .center)
                        styleCardNotes
                    }
                }
            }
        }
    }

    private var clayHomeCardDemo: some View {
        MiClaymorphismHomePreview(
            style: style,
            focus: MiCardFocus(scale: 1, opacity: 1, shadowOpacity: 0.24, borderOpacity: 0.42, zIndex: 1),
            cardSize: MiSpacingTokens.homeCardRegular,
            cornerRadius: MiSpacingTokens.homeCardRadiusRegular,
            isDragging: false
        )
    }

    private var styleCardNotes: some View {
        VStack(alignment: .leading, spacing: 12) {
            MiClaymorphismGuidanceCard(titleKey: "clay_card_rule_one", bodyKey: "clay_card_rule_one_body", systemImage: "circle.hexagongrid.fill", fill: MiClaymorphismTokens.mint.opacity(0.70))
            MiClaymorphismGuidanceCard(titleKey: "clay_card_rule_two", bodyKey: "clay_card_rule_two_body", systemImage: "hand.tap.fill", fill: MiClaymorphismTokens.lilac.opacity(0.66))
        }
        .frame(maxWidth: .infinity)
    }

    private var surfaceSystem: some View {
        MiClaymorphismSection(titleKey: "clay_surface", bodyKey: "clay_surface_body") {
            VStack(spacing: 14) {
                LazyVGrid(columns: columns, spacing: 14) {
                    MiClaymorphismDepthCard(titleKey: "clay_raised", bodyKey: "clay_raised_body", kind: .raised)
                    MiClaymorphismDepthCard(titleKey: "clay_inset", bodyKey: "clay_inset_body", kind: .inset)
                    MiClaymorphismDepthCard(titleKey: "clay_pressed", bodyKey: "clay_pressed_body", kind: .pressed)
                }

                MiClaymorphismPanel(radius: 28, padding: 18) {
                    LazyVGrid(columns: compactColumns, spacing: 10) {
                        MiClaymorphismRolePill(titleKey: "clay_role_matte", fill: MiClaymorphismTokens.peach.opacity(0.78))
                        MiClaymorphismRolePill(titleKey: "clay_role_inner", fill: MiClaymorphismTokens.sky.opacity(0.72))
                        MiClaymorphismRolePill(titleKey: "clay_role_float", fill: MiClaymorphismTokens.butter.opacity(0.78))
                        MiClaymorphismRolePill(titleKey: "clay_role_pastel", fill: MiClaymorphismTokens.mint.opacity(0.72))
                    }
                }
            }
        }
    }

    private var componentLab: some View {
        MiClaymorphismSection(titleKey: "clay_components", bodyKey: "clay_components_body") {
            MiClaymorphismPanel(radius: 30) {
                VStack(alignment: .leading, spacing: 18) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        MiClaymorphismButton(titleKey: "clay_primary", systemImage: "sparkles", role: .primary)
                        MiClaymorphismButton(titleKey: "clay_secondary", systemImage: "paintpalette", role: .secondary)
                        MiClaymorphismButton(titleKey: "clay_destructive", systemImage: "xmark", role: .destructive)
                        MiClaymorphismButton(titleKey: "clay_disabled", systemImage: "lock", role: .disabled)
                    }

                    Button {
                        isPressedSample.toggle()
                    } label: {
                        HStack(spacing: 14) {
                            MiClaymorphismToggleBlob(isOn: isPressedSample)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(MiL10n.text("clay_jelly_press"))
                                    .font(.system(size: 14.5, weight: .black, design: .rounded))
                                    .foregroundStyle(MiClaymorphismTokens.ink)
                                Text(MiL10n.text(isPressedSample ? "clay_jelly_pressed_body" : "clay_jelly_rest_body"))
                                    .font(.system(size: 12.5, weight: .medium, design: .rounded))
                                    .foregroundStyle(MiClaymorphismTokens.muted)
                                    .lineSpacing(2.5)
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            Spacer(minLength: 0)

                            MiClaymorphismChip(titleKey: isPressedSample ? "c_on" : "c_off", fill: isPressedSample ? MiClaymorphismTokens.mint : MiClaymorphismTokens.surfaceLight)
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, minHeight: 86, alignment: .leading)
                        .background {
                            MiClaymorphismClayShape(fill: MiClaymorphismTokens.surfaceLight, radius: 26, isPressed: isPressedSample, isInset: false)
                        }
                    }
                    .buttonStyle(MiClaymorphismPressButtonStyle())
                    .accessibilityLabel(MiL10n.text("clay_jelly_press"))
                    .accessibilityValue(MiL10n.text(isPressedSample ? "c_on" : "c_off"))
                }
            }
        }
    }

    private var inputNavigation: some View {
        MiClaymorphismSection(titleKey: "clay_input_nav", bodyKey: "clay_input_nav_body") {
            VStack(spacing: 14) {
                MiClaymorphismPanel(radius: 24) {
                    VStack(alignment: .leading, spacing: 10) {
                        Label(MiL10n.text("clay_input_label"), systemImage: "pencil")
                            .font(.system(size: 12, weight: .black, design: .rounded))
                            .foregroundStyle(MiClaymorphismTokens.muted)

                        HStack(spacing: 10) {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(MiClaymorphismTokens.coral)
                            TextField(MiL10n.text("clay_input_placeholder"), text: $inputText)
                                .focused($inputFocused)
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundStyle(MiClaymorphismTokens.ink)
                        }
                        .padding(.horizontal, 14)
                        .frame(minHeight: 54)
                        .background {
                            MiClaymorphismClayShape(fill: MiClaymorphismTokens.background, radius: 20, isPressed: inputFocused, isInset: true)
                        }
                    }
                }

                MiClaymorphismPanel(radius: 30, padding: 8) {
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { index in
                            Button {
                                selectedSegment = index
                            } label: {
                                Text(MiL10n.text(["clay_nav_play", "clay_nav_make", "clay_nav_rest"][index]))
                                    .font(.system(size: 12.5, weight: .black, design: .rounded))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 46)
                            }
                            .buttonStyle(MiClaymorphismSegmentButtonStyle(isSelected: selectedSegment == index))
                        }
                    }
                }
            }
        }
    }

    private var states: some View {
        MiClaymorphismSection(titleKey: "clay_states", bodyKey: "clay_states_body") {
            LazyVGrid(columns: columns, spacing: 14) {
                MiClaymorphismStateCard(titleKey: "clay_empty", bodyKey: "clay_empty_body", systemImage: "tray", fill: MiClaymorphismTokens.sky.opacity(0.62))
                MiClaymorphismLoadingCard(fill: MiClaymorphismTokens.butter.opacity(0.70))
                MiClaymorphismErrorCard(fill: MiClaymorphismTokens.coral.opacity(0.58))
                MiClaymorphismStateCard(titleKey: "clay_selected", bodyKey: "clay_selected_body", systemImage: "checkmark.circle.fill", fill: MiClaymorphismTokens.mint.opacity(0.70))
            }
        }
    }

    private var tokensAndPrompt: some View {
        MiClaymorphismSection(titleKey: "clay_token_prompt", bodyKey: "clay_token_prompt_body") {
            VStack(spacing: 14) {
                LazyVGrid(columns: columns, spacing: 14) {
                    MiClaymorphismTokenSwatch(title: "clay-peach", value: "#FFB08A", color: MiClaymorphismTokens.peach)
                    MiClaymorphismTokenSwatch(title: "clay-lilac", value: "#C9B7FF", color: MiClaymorphismTokens.lilac)
                    MiClaymorphismTokenSwatch(title: "clay-mint", value: "#A9E8D0", color: MiClaymorphismTokens.mint)
                    MiClaymorphismTokenSwatch(title: "clay-sky", value: "#A8D8FF", color: MiClaymorphismTokens.sky)
                    MiClaymorphismTokenSwatch(title: "clay-butter", value: "#FFE29A", color: MiClaymorphismTokens.butter)
                    MiClaymorphismTokenSwatch(title: "clay-shadow", value: "#D09C8D", color: MiClaymorphismTokens.shadowDark)
                }

                MiClaymorphismPanel(radius: 26) {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(["clay_prompt_1", "clay_prompt_2", "clay_prompt_3", "clay_check_1", "clay_check_2"], id: \.self) { key in
                            Label(MiL10n.text(key), systemImage: key.contains("check") ? "checkmark.circle" : "text.bubble")
                                .font(.system(size: 13.5, weight: .semibold, design: .rounded))
                                .foregroundStyle(MiClaymorphismTokens.ink)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
    }

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 156), spacing: 14)]
    }

    private var compactColumns: [GridItem] {
        [GridItem(.adaptive(minimum: 108), spacing: 10)]
    }

    private func close() {
        if let onBack {
            onBack()
        } else {
            dismiss()
        }
    }
}

private struct MiClaymorphismTopBar: View {
    let style: MiDesignStyle
    let onBack: () -> Void

    var body: some View {
        MiClaymorphismPanel(radius: 24, padding: 6) {
            HStack(spacing: 10) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 15, weight: .black))
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(MiClaymorphismTopButtonStyle())
                .accessibilityLabel(MiL10n.text("c_back"))

                VStack(alignment: .leading, spacing: 1) {
                    Text(MiL10n.text(style.name))
                        .font(.system(size: 13.5, weight: .black, design: .rounded))
                        .foregroundStyle(MiClaymorphismTokens.ink)
                        .lineLimit(1)
                    Text(MiL10n.text(style.localizedName))
                        .font(.system(size: 11.5, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiClaymorphismTokens.muted)
                        .lineLimit(1)
                }

                Spacer()

                MiClaymorphismChip(titleKey: "c_ready", fill: MiClaymorphismTokens.mint)
            }
        }
    }
}

private struct MiClaymorphismHeroPreview: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isPressed = false

    var body: some View {
        MiClaymorphismPanel(fill: MiClaymorphismTokens.backgroundWarm.opacity(0.76), radius: 30, padding: 14) {
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .center, spacing: 14) {
                    signatureButton
                        .frame(width: 160, height: 160)
                    statusPanel
                }

                VStack(alignment: .leading, spacing: 14) {
                    signatureButton
                        .frame(maxWidth: .infinity)
                        .frame(height: 160)
                    statusPanel
                }
            }
        }
        .animation(reduceMotion ? .easeOut(duration: 0.01) : .spring(response: 0.24, dampingFraction: 0.62), value: isPressed)
    }

    private var signatureButton: some View {
        Button {
            isPressed.toggle()
        } label: {
            ZStack {
                MiClaymorphismClayShape(fill: MiClaymorphismTokens.peach, radius: 58, isPressed: isPressed, isInset: false)
                    .frame(width: 130, height: 130)
                    .overlay(alignment: .topLeading) {
                        Circle()
                            .fill(Color.white.opacity(isPressed ? 0.16 : 0.38))
                            .frame(width: 36, height: 28)
                            .blur(radius: 3)
                            .offset(x: 22, y: 20)
                    }

                VStack(spacing: 6) {
                    Image(systemName: isPressed ? "hand.tap.fill" : "hand.point.up.left.fill")
                        .font(.system(size: 26, weight: .black))
                    Text(MiL10n.text(isPressed ? "clay_preview_pressed" : "clay_preview_idle"))
                        .font(.system(size: 12, weight: .black, design: .rounded))
                }
                .foregroundStyle(MiClaymorphismTokens.ink)
            }
            .scaleEffect(isPressed ? 0.94 : 1)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(MiL10n.text("clay_preview_signature_component"))
        .accessibilityValue(MiL10n.text(isPressed ? "clay_preview_pressed" : "clay_preview_idle"))
    }

    private var statusPanel: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(MiL10n.text("clay_preview_signature_component"), systemImage: "hand.tap.fill")
                .font(.system(size: 13, weight: .black, design: .rounded))
                .foregroundStyle(MiClaymorphismTokens.ink)

            MiClaymorphismMetricRow(labelKey: "clay_metric_state", valueKey: isPressed ? "clay_preview_pressed" : "clay_preview_idle", fill: isPressed ? MiClaymorphismTokens.mint.opacity(0.72) : MiClaymorphismTokens.surfaceLight)
            MiClaymorphismMetricRow(labelKey: "clay_metric_depth", valueKey: isPressed ? "clay_depth_inset" : "clay_depth_float", fill: MiClaymorphismTokens.sky.opacity(0.62))
            MiClaymorphismMetricRow(labelKey: "clay_metric_shadow", valueKey: isPressed ? "clay_shadow_inner" : "clay_shadow_outer", fill: MiClaymorphismTokens.lilac.opacity(0.62))
            MiClaymorphismMetricRow(labelKey: "clay_metric_motion", valueKey: reduceMotion ? "clay_motion_reduced" : "clay_motion_spring", fill: MiClaymorphismTokens.butter.opacity(0.70))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
