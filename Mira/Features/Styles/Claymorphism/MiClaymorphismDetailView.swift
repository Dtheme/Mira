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
                MiClaymorphismStateCard(titleKey: "clay_loading", bodyKey: "clay_loading_body", systemImage: "clock", fill: MiClaymorphismTokens.butter.opacity(0.70))
                MiClaymorphismStateCard(titleKey: "clay_error", bodyKey: "clay_error_body", systemImage: "exclamationmark.triangle", fill: MiClaymorphismTokens.coral.opacity(0.58))
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

private struct MiClaymorphismPanel<MiClaymorphismContent: View>: View {
    let fill: Color
    let radius: CGFloat
    let padding: CGFloat
    @ViewBuilder let content: MiClaymorphismContent

    init(
        fill: Color = MiClaymorphismTokens.surfaceLight.opacity(0.82),
        radius: CGFloat = MiClaymorphismTokens.cardRadius,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> MiClaymorphismContent
    ) {
        self.fill = fill
        self.radius = radius
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background {
                MiClaymorphismClayShape(fill: fill, radius: radius, isPressed: false, isInset: false)
            }
    }
}

private struct MiClaymorphismClayShape: View {
    let fill: Color
    let radius: CGFloat
    let isPressed: Bool
    let isInset: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: radius, style: .continuous)
            .fill(fill)
            .shadow(color: isInset ? .clear : MiClaymorphismTokens.shadowLight.opacity(isPressed ? 0.36 : 0.82), radius: isPressed ? 5 : 14, x: isPressed ? -3 : -9, y: isPressed ? -3 : -9)
            .shadow(color: isInset ? .clear : MiClaymorphismTokens.shadowDark.opacity(isPressed ? 0.24 : 0.46), radius: isPressed ? 6 : 18, x: isPressed ? 4 : 10, y: isPressed ? 5 : 13)
            .overlay {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(Color.white.opacity(isPressed || isInset ? 0.20 : 0.48), lineWidth: isInset ? 2 : 5)
                    .blur(radius: isInset ? 5 : 4)
                    .offset(x: isInset ? -2 : -4, y: isInset ? -2 : -5)
                    .mask(RoundedRectangle(cornerRadius: radius, style: .continuous))
            }
            .overlay {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(MiClaymorphismTokens.shadowDark.opacity(isPressed || isInset ? 0.28 : 0.13), lineWidth: isInset ? 5 : 4)
                    .blur(radius: isInset ? 7 : 5)
                    .offset(x: isInset ? 4 : 4, y: isInset ? 5 : 5)
                    .mask(RoundedRectangle(cornerRadius: radius, style: .continuous))
            }
    }
}

private struct MiClaymorphismSection<MiClaymorphismContent: View>: View {
    let titleKey: String
    let bodyKey: String
    @ViewBuilder let content: MiClaymorphismContent

    init(titleKey: String, bodyKey: String, @ViewBuilder content: () -> MiClaymorphismContent) {
        self.titleKey = titleKey
        self.bodyKey = bodyKey
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(MiL10n.text(titleKey))
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 14.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.muted)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }

            content
        }
    }
}

private struct MiClaymorphismMetricRow: View {
    let labelKey: String
    let valueKey: String
    let fill: Color

    var body: some View {
        HStack(spacing: 9) {
            Text(MiL10n.text(labelKey).uppercased())
                .font(.system(size: 10.5, weight: .black, design: .rounded))
                .foregroundStyle(MiClaymorphismTokens.muted)
                .frame(width: 68, alignment: .leading)

            Text(MiL10n.text(valueKey))
                .font(.system(size: 12.2, weight: .black, design: .rounded))
                .foregroundStyle(MiClaymorphismTokens.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.66)
                .padding(.horizontal, 10)
                .frame(height: 30)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background {
                    Capsule(style: .continuous)
                        .fill(fill)
                        .overlay {
                            Capsule(style: .continuous)
                                .strokeBorder(Color.white.opacity(0.46), lineWidth: 0.9)
                        }
                }
        }
    }
}

private struct MiClaymorphismChip: View {
    let titleKey: String
    let fill: Color

    var body: some View {
        Text(MiL10n.text(titleKey))
            .font(.system(size: 11.5, weight: .black, design: .rounded))
            .foregroundStyle(MiClaymorphismTokens.ink)
            .padding(.horizontal, 11)
            .frame(height: 32)
            .background {
                Capsule(style: .continuous)
                    .fill(fill.opacity(0.82))
                    .overlay {
                        Capsule(style: .continuous)
                            .strokeBorder(Color.white.opacity(0.54), lineWidth: 1)
                    }
            }
    }
}

private enum MiClaymorphismDepthKind {
    case raised
    case inset
    case pressed
}

private struct MiClaymorphismDepthCard: View {
    let titleKey: String
    let bodyKey: String
    let kind: MiClaymorphismDepthKind

    var body: some View {
        MiClaymorphismPanel(fill: fill, radius: 24) {
            VStack(alignment: .leading, spacing: 12) {
                MiClaymorphismClayShape(fill: fill, radius: 22, isPressed: kind == .pressed, isInset: kind == .inset)
                    .frame(height: 62)
                    .overlay {
                        Image(systemName: icon)
                            .font(.system(size: 19, weight: .black))
                            .foregroundStyle(MiClaymorphismTokens.ink.opacity(0.82))
                    }

                Text(MiL10n.text(titleKey))
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 12.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.muted)
                    .lineSpacing(2.5)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var fill: Color {
        switch kind {
        case .raised:
            return MiClaymorphismTokens.peach.opacity(0.72)
        case .inset:
            return MiClaymorphismTokens.background
        case .pressed:
            return MiClaymorphismTokens.lilac.opacity(0.68)
        }
    }

    private var icon: String {
        switch kind {
        case .raised:
            return "arrow.up.left.and.arrow.down.right"
        case .inset:
            return "tray"
        case .pressed:
            return "hand.tap.fill"
        }
    }
}

private struct MiClaymorphismRolePill: View {
    let titleKey: String
    let fill: Color

    var body: some View {
        Text(MiL10n.text(titleKey))
            .font(.system(size: 11.5, weight: .black, design: .rounded))
            .foregroundStyle(MiClaymorphismTokens.ink)
            .padding(.horizontal, 12)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background {
                MiClaymorphismClayShape(fill: fill, radius: 20, isPressed: false, isInset: false)
            }
    }
}

private enum MiClaymorphismButtonRole {
    case primary
    case secondary
    case destructive
    case disabled
}

private struct MiClaymorphismButton: View {
    let titleKey: String
    let systemImage: String
    let role: MiClaymorphismButtonRole

    var body: some View {
        Button {} label: {
            Label(MiL10n.text(titleKey), systemImage: systemImage)
                .font(.system(size: 13.5, weight: .black, design: .rounded))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
        }
        .buttonStyle(MiClaymorphismFilledButtonStyle(role: role))
        .disabled(role == .disabled)
    }
}

private struct MiClaymorphismFilledButtonStyle: ButtonStyle {
    let role: MiClaymorphismButtonRole

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(role == .disabled ? MiClaymorphismTokens.muted.opacity(0.58) : MiClaymorphismTokens.ink)
            .background {
                MiClaymorphismClayShape(fill: fill.opacity(role == .disabled ? 0.46 : 0.86), radius: 23, isPressed: configuration.isPressed, isInset: false)
            }
            .scaleEffect(configuration.isPressed && role != .disabled ? 0.97 : 1)
            .opacity(role == .disabled ? 0.68 : 1)
            .animation(.spring(response: 0.18, dampingFraction: 0.68), value: configuration.isPressed)
    }

    private var fill: Color {
        switch role {
        case .primary:
            return MiClaymorphismTokens.peach
        case .secondary:
            return MiClaymorphismTokens.sky
        case .destructive:
            return MiClaymorphismTokens.coral
        case .disabled:
            return MiClaymorphismTokens.surface
        }
    }
}

private struct MiClaymorphismPressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
            .animation(.spring(response: 0.16, dampingFraction: 0.68), value: configuration.isPressed)
    }
}

private struct MiClaymorphismTopButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(MiClaymorphismTokens.ink)
            .background {
                MiClaymorphismClayShape(fill: MiClaymorphismTokens.surface, radius: 22, isPressed: configuration.isPressed, isInset: false)
            }
    }
}

private struct MiClaymorphismSegmentButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(MiClaymorphismTokens.ink)
            .background {
                MiClaymorphismClayShape(
                    fill: isSelected ? MiClaymorphismTokens.mint.opacity(0.82) : MiClaymorphismTokens.surfaceLight.opacity(0.76),
                    radius: 23,
                    isPressed: configuration.isPressed || isSelected,
                    isInset: isSelected
                )
            }
    }
}

private struct MiClaymorphismToggleBlob: View {
    let isOn: Bool

    var body: some View {
        ZStack {
            MiClaymorphismClayShape(fill: isOn ? MiClaymorphismTokens.mint : MiClaymorphismTokens.surface, radius: 26, isPressed: isOn, isInset: false)
            Image(systemName: isOn ? "checkmark" : "sparkle")
                .font(.system(size: 17, weight: .black))
                .foregroundStyle(MiClaymorphismTokens.ink)
        }
        .frame(width: 54, height: 54)
    }
}

private struct MiClaymorphismGuidanceCard: View {
    let titleKey: String
    let bodyKey: String
    let systemImage: String
    let fill: Color

    var body: some View {
        MiClaymorphismPanel(fill: fill, radius: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: systemImage)
                    .font(.system(size: 20, weight: .black))
                    .foregroundStyle(MiClaymorphismTokens.ink)
                    .frame(width: 42, height: 42)
                    .background {
                        MiClaymorphismClayShape(fill: Color.white.opacity(0.42), radius: 20, isPressed: false, isInset: false)
                    }

                Text(MiL10n.text(titleKey))
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 12.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.muted)
                    .lineSpacing(2.5)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

private struct MiClaymorphismStateCard: View {
    let titleKey: String
    let bodyKey: String
    let systemImage: String
    let fill: Color

    var body: some View {
        MiClaymorphismPanel(fill: fill, radius: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: systemImage)
                    .font(.system(size: 22, weight: .black))
                    .foregroundStyle(MiClaymorphismTokens.ink)
                Text(MiL10n.text(titleKey))
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 12.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.muted)
                    .lineSpacing(2.5)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

private struct MiClaymorphismTokenSwatch: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        MiClaymorphismPanel(radius: 24) {
            VStack(alignment: .leading, spacing: 11) {
                MiClaymorphismClayShape(fill: color, radius: 18, isPressed: false, isInset: false)
                    .frame(height: 52)

                Text(title)
                    .font(.system(size: 13, weight: .black, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
                Text(value)
                    .font(.system(size: 11.5, weight: .semibold, design: .monospaced))
                    .foregroundStyle(MiClaymorphismTokens.muted)
            }
        }
    }
}
