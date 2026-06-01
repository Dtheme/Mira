//
//  MiMaterial3DetailView.swift
//  Mira
//
//  Created on 2026/5/25.
//

import SwiftUI

struct MiMaterial3DetailView: View {
    let style: MiDesignStyle
    let onBack: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    @State private var query = ""
    @State private var componentSwitchOn = true

    var body: some View {
        ZStack(alignment: .top) {
            MiMaterial3Tokens.pageBackground
                .ignoresSafeArea()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: MiMaterial3Tokens.sectionSpacing) {
                    hero
                    roleFoundation
                    styleCard
                    componentLab
                    inputNavigation
                    stateGuidance
                    tokensAndPrompt
                }
                .padding(.horizontal, 22)
                .padding(.top, 86)
                .padding(.bottom, 50)
                .frame(maxWidth: 780, alignment: .leading)
                .frame(maxWidth: .infinity)
            }
            .scrollIndicators(.hidden)

            MiMaterial3TopBar(style: style) {
                close()
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .zIndex(20)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .animation(.spring(response: 0.28, dampingFraction: 0.84), value: selectedTab)
    }

    private var hero: some View {
        MiMaterial3Panel(fill: MiMaterial3Tokens.surfaceContainer, radius: 32, padding: 22) {
            VStack(alignment: .leading, spacing: 20) {
                ViewThatFits(in: .horizontal) {
                    HStack(alignment: .top, spacing: 18) {
                        heroCopy
                        MiMaterial3HeroPreview()
                            .frame(maxWidth: 360)
                    }

                    VStack(alignment: .leading, spacing: 18) {
                        heroCopy
                        MiMaterial3HeroPreview()
                    }
                }
            }
        }
    }

    private var heroCopy: some View {
        VStack(alignment: .leading, spacing: 14) {
            MiMaterial3Chip(titleKey: "m3_badge", isSelected: true)

            VStack(alignment: .leading, spacing: 8) {
                Text(MiL10n.text(style.name))
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(MiMaterial3Tokens.ink)
                    .lineLimit(2)
                    .minimumScaleFactor(0.72)
                Text(MiL10n.text("m3_hero_body"))
                    .font(.system(size: 15.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiMaterial3Tokens.muted)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var styleCard: some View {
        MiMaterial3Section(titleKey: "m3_card_demo", bodyKey: "m3_card_demo_body") {
            MiMaterial3Panel(fill: MiMaterial3Tokens.surface, radius: 28, padding: 18) {
                ViewThatFits(in: .horizontal) {
                    HStack(alignment: .center, spacing: 20) {
                        material3HomeCardDemo
                        styleCardNotes
                    }

                    VStack(alignment: .leading, spacing: 18) {
                        material3HomeCardDemo
                            .frame(maxWidth: .infinity, alignment: .center)
                        styleCardNotes
                    }
                }
            }
        }
    }

    private var material3HomeCardDemo: some View {
        MiMaterial3HomePreview(
            style: style,
            focus: MiCardFocus(scale: 1, opacity: 1, shadowOpacity: 0.24, borderOpacity: 0.42, zIndex: 1),
            cardSize: MiSpacingTokens.homeCardRegular,
            cornerRadius: MiSpacingTokens.homeCardRadiusRegular,
            isDragging: false
        )
    }

    private var styleCardNotes: some View {
        VStack(alignment: .leading, spacing: 12) {
            MiMaterial3GuidanceCard(
                titleKey: "m3_card_rule_one",
                bodyKey: "m3_card_rule_one_body",
                systemImage: "switch.2",
                fill: MiMaterial3Tokens.primaryContainer
            )
            MiMaterial3GuidanceCard(
                titleKey: "m3_card_rule_two",
                bodyKey: "m3_card_rule_two_body",
                systemImage: "circle.hexagongrid",
                fill: MiMaterial3Tokens.secondaryContainer
            )
        }
        .frame(maxWidth: .infinity)
    }

    private var roleFoundation: some View {
        MiMaterial3Section(titleKey: "m3_role_foundation", bodyKey: "m3_role_foundation_body") {
            VStack(spacing: 14) {
                MiMaterial3RoleFoundationPanel()

                LazyVGrid(columns: columns, spacing: 14) {
                    MiMaterial3StyleSpecCard(titleKey: "m3_type_scale", bodyKey: "m3_type_scale_body", kind: .type)
                    MiMaterial3StyleSpecCard(titleKey: "m3_shape_scale", bodyKey: "m3_shape_scale_body", kind: .shape)
                    MiMaterial3StyleSpecCard(titleKey: "m3_motion_layer", bodyKey: "m3_motion_layer_body", kind: .motion)
                }
            }
        }
    }

    private var componentLab: some View {
        MiMaterial3Section(titleKey: "m3_components", bodyKey: "m3_components_body") {
            MiMaterial3Panel(fill: MiMaterial3Tokens.surface) {
                VStack(alignment: .leading, spacing: 18) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        MiMaterial3Button(titleKey: "m3_filled", systemImage: "checkmark", role: .filled)
                        MiMaterial3Button(titleKey: "m3_tonal", systemImage: "paintpalette", role: .tonal)
                        MiMaterial3Button(titleKey: "m3_outlined", systemImage: "circle", role: .outlined)
                        MiMaterial3Button(titleKey: "m3_disabled", systemImage: "lock", role: .disabled)
                    }

                    MiMaterial3SwitchRow(isOn: $componentSwitchOn)

                    LazyVGrid(columns: compactColumns, spacing: 8) {
                        MiMaterial3Chip(titleKey: "m3_filter", isSelected: true)
                        MiMaterial3Chip(titleKey: "m3_assist", isSelected: false)
                        MiMaterial3Chip(titleKey: "m3_input", isSelected: false)
                    }
                }
            }
        }
    }

    private var inputNavigation: some View {
        MiMaterial3Section(titleKey: "m3_input_nav", bodyKey: "m3_input_nav_body") {
            VStack(spacing: 14) {
                MiMaterial3Panel(fill: MiMaterial3Tokens.surface, radius: 18) {
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(MiMaterial3Tokens.primary)
                        TextField(MiL10n.text("m3_search_placeholder"), text: $query)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundStyle(MiMaterial3Tokens.ink)
                    }
                    .frame(minHeight: 48)
                }

                MiMaterial3Panel(fill: MiMaterial3Tokens.surface, radius: 28, padding: 8) {
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { index in
                            Button {
                                selectedTab = index
                            } label: {
                                Label(
                                    MiL10n.text(["m3_nav_home", "m3_nav_tokens", "m3_nav_states"][index]),
                                    systemImage: ["house", "swatchpalette", "checklist"][index]
                                )
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                            }
                            .buttonStyle(MiMaterial3NavButtonStyle(isSelected: selectedTab == index))
                        }
                    }
                }
            }
        }
    }

    private var stateGuidance: some View {
        MiMaterial3Section(titleKey: "m3_states", bodyKey: "m3_states_body") {
            VStack(spacing: 14) {
                LazyVGrid(columns: columns, spacing: 14) {
                    MiMaterial3StateCard(titleKey: "m3_empty", bodyKey: "m3_empty_body", systemImage: "inbox")
                    MiMaterial3LoadingCard()
                    MiMaterial3ErrorCard()
                    MiMaterial3StateCard(titleKey: "m3_selected", bodyKey: "m3_selected_body", systemImage: "checkmark.circle.fill", fill: MiMaterial3Tokens.secondaryContainer)
                }

                LazyVGrid(columns: columns, spacing: 14) {
                    MiMaterial3GuidanceCard(
                        titleKey: "m3_state_layer_title",
                        bodyKey: "m3_state_layer_body",
                        systemImage: "hand.tap",
                        fill: MiMaterial3Tokens.primaryContainer
                    )
                    MiMaterial3GuidanceCard(
                        titleKey: "m3_ios_title",
                        bodyKey: "m3_ios_body",
                        systemImage: "iphone",
                        fill: MiMaterial3Tokens.secondaryContainer
                    )
                    MiMaterial3GuidanceCard(
                        titleKey: "m3_roles_title",
                        bodyKey: "m3_roles_body",
                        systemImage: "rectangle.3.group",
                        fill: MiMaterial3Tokens.tertiaryContainer
                    )
                }
            }
        }
    }

    private var tokensAndPrompt: some View {
        MiMaterial3Section(titleKey: "m3_token_prompt", bodyKey: "m3_token_prompt_body") {
            VStack(spacing: 14) {
                LazyVGrid(columns: columns, spacing: 14) {
                    MiMaterial3TokenSwatch(title: "m3-primary", value: "#6750A4", color: MiMaterial3Tokens.primary)
                    MiMaterial3TokenSwatch(title: "m3-primary-container", value: "#EADDFF", color: MiMaterial3Tokens.primaryContainer)
                    MiMaterial3TokenSwatch(title: "m3-secondary-container", value: "#E8DEF8", color: MiMaterial3Tokens.secondaryContainer)
                    MiMaterial3TokenSwatch(title: "m3-tertiary-container", value: "#FFD8E4", color: MiMaterial3Tokens.tertiaryContainer)
                    MiMaterial3TokenSwatch(title: "m3-surface-container", value: "#F3EDF7", color: MiMaterial3Tokens.surfaceContainer)
                    MiMaterial3TokenSwatch(title: "m3-outline-variant", value: "#CAC4D0", color: MiMaterial3Tokens.outlineVariant)
                }

                promptChecklist
            }
        }
    }

    private var promptChecklist: some View {
        MiMaterial3Panel(fill: MiMaterial3Tokens.surface) {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(["m3_prompt_1", "m3_prompt_2", "m3_prompt_3", "m3_check_1", "m3_check_2"], id: \.self) { key in
                    Label(MiL10n.text(key), systemImage: key.contains("check") ? "checkmark.circle" : "text.bubble")
                        .font(.system(size: 13.5, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiMaterial3Tokens.ink)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 156), spacing: 14)]
    }

    private var compactColumns: [GridItem] {
        [GridItem(.adaptive(minimum: 96), spacing: 8)]
    }

    private func close() {
        if let onBack {
            onBack()
        } else {
            dismiss()
        }
    }
}

private struct MiMaterial3TopBar: View {
    let style: MiDesignStyle
    let onBack: () -> Void

    var body: some View {
        MiMaterial3Panel(fill: MiMaterial3Tokens.surface.opacity(0.96), radius: 24, padding: 6) {
            HStack(spacing: 10) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 15, weight: .bold))
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(MiMaterial3TopButtonStyle())
                .accessibilityLabel(MiL10n.text("c_back"))

                VStack(alignment: .leading, spacing: 1) {
                    Text(MiL10n.text(style.name))
                        .font(.system(size: 13.5, weight: .bold, design: .rounded))
                        .foregroundStyle(MiMaterial3Tokens.ink)
                    Text(MiL10n.text(style.localizedName))
                        .font(.system(size: 11.5, weight: .medium, design: .rounded))
                        .foregroundStyle(MiMaterial3Tokens.muted)
                }

                Spacer()

                MiMaterial3Chip(titleKey: "c_ready", isSelected: true)
            }
        }
    }
}

private struct MiMaterial3TopButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(MiMaterial3Tokens.ink)
            .background {
                Circle()
                    .fill(configuration.isPressed ? MiMaterial3Tokens.primaryContainer : MiMaterial3Tokens.surfaceContainerHigh)
            }
    }
}

private struct MiMaterial3NavButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .labelStyle(.titleAndIcon)
            .foregroundStyle(isSelected ? MiMaterial3Tokens.ink : MiMaterial3Tokens.muted)
            .background {
                Capsule(style: .continuous)
                    .fill(isSelected ? MiMaterial3Tokens.secondaryContainer : Color.clear)
                    .overlay {
                        if configuration.isPressed {
                            Capsule(style: .continuous)
                                .fill(MiMaterial3Tokens.primary.opacity(0.10))
                        }
                    }
            }
    }
}

private struct MiMaterial3RoleFoundationPanel: View {
    var body: some View {
        MiMaterial3Panel(fill: MiMaterial3Tokens.surface, radius: 26, padding: 18) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .center, spacing: 14) {
                    MiMaterial3SourceWell(palette: .violet, isPersonalized: true)

                    VStack(alignment: .leading, spacing: 5) {
                        Text(MiL10n.text("m3_preview_source_to_roles"))
                            .font(.system(size: 17, weight: .black, design: .rounded))
                            .foregroundStyle(MiMaterial3Tokens.ink)
                        Text(MiL10n.text("m3_role_foundation_note"))
                            .font(.system(size: 12.5, weight: .medium, design: .rounded))
                            .foregroundStyle(MiMaterial3Tokens.muted)
                            .lineSpacing(2.5)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 92), spacing: 8)], spacing: 8) {
                    MiMaterial3RolePill(label: "P", titleKey: "m3_primary_container", fill: MiMaterial3Tokens.primary, foreground: Color.white)
                    MiMaterial3RolePill(label: "S", titleKey: "m3_secondary_container", fill: MiMaterial3Tokens.secondaryContainer, foreground: MiMaterial3Tokens.onSecondaryContainer)
                    MiMaterial3RolePill(label: "T", titleKey: "m3_tertiary_container", fill: MiMaterial3Tokens.tertiaryContainer, foreground: MiMaterial3Tokens.onTertiaryContainer)
                    MiMaterial3RolePill(label: "N", titleKey: "m3_surface_container", fill: MiMaterial3Tokens.surfaceContainerHighest, foreground: MiMaterial3Tokens.onSurfaceVariant)
                }

                MiMaterial3SurfaceLadder()
            }
        }
    }
}

private struct MiMaterial3RolePill: View {
    let label: String
    let titleKey: String
    let fill: Color
    let foreground: Color

    var body: some View {
        HStack(spacing: 8) {
            Text(label)
                .font(.system(size: 12, weight: .black, design: .rounded))
                .foregroundStyle(foreground)
                .frame(width: 30, height: 30)
                .background {
                    Circle()
                        .fill(fill)
                }

            Text(MiL10n.text(titleKey))
                .font(.system(size: 11.5, weight: .bold, design: .rounded))
                .foregroundStyle(MiMaterial3Tokens.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.72)
        }
        .padding(.horizontal, 9)
        .frame(height: 42)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            Capsule(style: .continuous)
                .fill(MiMaterial3Tokens.surfaceContainerLowest)
                .overlay {
                    Capsule(style: .continuous)
                        .strokeBorder(MiMaterial3Tokens.outlineVariant.opacity(0.36), lineWidth: 0.8)
                }
        }
    }
}

private struct MiMaterial3SurfaceLadder: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(MiL10n.text("m3_surface_ladder").uppercased())
                .font(.system(size: 10.5, weight: .black, design: .rounded))
                .foregroundStyle(MiMaterial3Tokens.muted)
                .tracking(0.5)

            HStack(spacing: 8) {
                MiMaterial3SurfaceStep(width: 0.22, fill: MiMaterial3Tokens.surfaceContainerLow)
                MiMaterial3SurfaceStep(width: 0.32, fill: MiMaterial3Tokens.surfaceContainer)
                MiMaterial3SurfaceStep(width: 0.46, fill: MiMaterial3Tokens.surfaceContainerHigh)
            }
        }
    }
}

private struct MiMaterial3SurfaceStep: View {
    let width: CGFloat
    let fill: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(fill)
            .frame(maxWidth: .infinity)
            .frame(height: 42 + width * 52)
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(MiMaterial3Tokens.outlineVariant.opacity(0.42), lineWidth: 0.8)
            }
    }
}

private struct MiMaterial3SwitchRow: View {
    @Binding var isOn: Bool

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.26, dampingFraction: 0.86)) {
                isOn.toggle()
            }
        } label: {
            HStack(spacing: 14) {
                MiMaterial3InlineSwitch(isOn: isOn)

                VStack(alignment: .leading, spacing: 4) {
                    Text(MiL10n.text("m3_preview_switch"))
                        .font(.system(size: 14.5, weight: .black, design: .rounded))
                        .foregroundStyle(MiMaterial3Tokens.ink)
                    Text(MiL10n.text(isOn ? "m3_switch_on_body" : "m3_switch_off_body"))
                        .font(.system(size: 12.5, weight: .medium, design: .rounded))
                        .foregroundStyle(MiMaterial3Tokens.muted)
                        .lineSpacing(2.5)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)

                Text(MiL10n.text(isOn ? "m3_on" : "m3_off"))
                    .font(.system(size: 11.5, weight: .black, design: .rounded))
                    .foregroundStyle(isOn ? MiMaterial3Tokens.onPrimaryContainer : MiMaterial3Tokens.onSurfaceVariant)
                    .padding(.horizontal, 10)
                    .frame(height: 30)
                    .background {
                        Capsule(style: .continuous)
                            .fill(isOn ? MiMaterial3Tokens.primaryContainer : MiMaterial3Tokens.surfaceContainerHigh)
                    }
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 86, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(MiMaterial3Tokens.surfaceContainerLow)
                    .overlay {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .strokeBorder(MiMaterial3Tokens.outlineVariant.opacity(0.44), lineWidth: 0.8)
                    }
            }
        }
        .buttonStyle(MiMaterial3PreviewButtonStyle())
        .accessibilityLabel(MiL10n.text("m3_preview_switch"))
        .accessibilityValue(MiL10n.text(isOn ? "m3_on" : "m3_off"))
    }
}

private struct MiMaterial3InlineSwitch: View {
    let isOn: Bool

    var body: some View {
        ZStack(alignment: isOn ? .trailing : .leading) {
            Capsule(style: .continuous)
                .fill(isOn ? MiMaterial3Tokens.primaryContainer : MiMaterial3Tokens.surfaceContainerHighest)
                .frame(width: 74, height: 44)
                .overlay {
                    Capsule(style: .continuous)
                        .strokeBorder(MiMaterial3Tokens.outlineVariant.opacity(0.54), lineWidth: 1)
                }

            Circle()
                .fill(isOn ? MiMaterial3Tokens.primary : MiMaterial3Tokens.surfaceContainerLowest)
                .frame(width: 34, height: 34)
                .overlay {
                    Image(systemName: isOn ? "checkmark" : "minus")
                        .font(.system(size: 11, weight: .black))
                        .foregroundStyle(isOn ? Color.white : MiMaterial3Tokens.onSurfaceVariant)
                }
                .shadow(color: MiMaterial3Tokens.primary.opacity(isOn ? 0.20 : 0.06), radius: 7, x: 0, y: 4)
                .padding(5)
        }
        .frame(width: 74, height: 44)
    }
}

private struct MiMaterial3HeroPreview: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isOn = true

    private var palette: MiMaterial3HeroPalette {
        isOn ? .violet : .teal
    }

    var body: some View {
        MiMaterial3Panel(fill: palette.surface, radius: 30, padding: 16) {
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .center, spacing: 16) {
                    signatureControl
                        .frame(width: 154)
                    statusPanel
                }

                VStack(alignment: .leading, spacing: 16) {
                    signatureControl
                        .frame(maxWidth: .infinity, alignment: .center)
                    statusPanel
                }
            }
        }
    }

    private var signatureControl: some View {
        Button {
            togglePalette()
        } label: {
            MiMaterial3HeroSwitchControl(palette: palette, isOn: isOn)
        }
        .buttonStyle(MiMaterial3PreviewButtonStyle())
        .accessibilityLabel(MiL10n.text("m3_hero_toggle"))
        .accessibilityValue(MiL10n.text(isOn ? "m3_on" : "m3_off"))
    }

    private var statusPanel: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(MiL10n.text("m3_preview_signature_component"), systemImage: "switch.2")
                .font(.system(size: 13, weight: .black, design: .rounded))
                .foregroundStyle(palette.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.78)

            MiMaterial3MetricRow(labelKey: "m3_metric_tone", value: MiL10n.text(isOn ? "m3_expressive" : "m3_calm"), color: palette.primaryContainer)
            MiMaterial3MetricRow(labelKey: "m3_metric_shape", value: MiL10n.text(isOn ? "m3_shape_full" : "m3_shape_large"), color: palette.secondaryContainer)
            MiMaterial3MetricRow(labelKey: "m3_metric_state", value: MiL10n.text(isOn ? "m3_on" : "m3_off"), color: palette.tertiaryContainer)
            MiMaterial3MetricRow(labelKey: "m3_metric_layer", value: isOn ? "12%" : "6%", color: palette.neutralContainer)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func togglePalette() {
        if reduceMotion {
            isOn.toggle()
        } else {
            withAnimation(.spring(response: 0.32, dampingFraction: 0.84)) {
                isOn.toggle()
            }
        }
    }
}

private struct MiMaterial3HeroSwitchControl: View {
    let palette: MiMaterial3HeroPalette
    let isOn: Bool

    var body: some View {
        VStack(spacing: 14) {
            ZStack(alignment: isOn ? .trailing : .leading) {
                Capsule(style: .continuous)
                    .fill(isOn ? palette.primaryContainer : palette.neutralContainer)
                    .frame(width: 132, height: 76)
                    .overlay(alignment: .leading) {
                        if isOn {
                            Circle()
                                .fill(palette.primary.opacity(0.10))
                                .frame(width: 64, height: 64)
                                .padding(.leading, 8)
                        }
                    }
                    .overlay {
                        Capsule(style: .continuous)
                            .strokeBorder(MiMaterial3Tokens.outlineVariant.opacity(0.54), lineWidth: 1)
                    }

                Circle()
                    .fill(isOn ? palette.primary : MiMaterial3Tokens.surfaceContainerLowest)
                    .frame(width: 58, height: 58)
                    .overlay {
                        Image(systemName: isOn ? "checkmark" : "minus")
                            .font(.system(size: 17, weight: .black))
                            .foregroundStyle(isOn ? Color.white : palette.primary)
                    }
                    .shadow(color: palette.primary.opacity(isOn ? 0.24 : 0.08), radius: isOn ? 12 : 6, x: 0, y: isOn ? 7 : 4)
                    .padding(9)
            }

            Text(MiL10n.text("m3_preview_switch"))
                .font(.system(size: 13.5, weight: .black, design: .rounded))
                .foregroundStyle(MiMaterial3Tokens.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.78)
        }
        .frame(width: 154, height: 154)
        .background {
            RoundedRectangle(cornerRadius: isOn ? 34 : 26, style: .continuous)
                .fill(isOn ? palette.primaryContainer.opacity(0.58) : palette.surface)
                .overlay(alignment: .bottomTrailing) {
                    Circle()
                        .fill(palette.primary.opacity(isOn ? 0.13 : 0.06))
                        .frame(width: 62, height: 62)
                        .offset(x: 18, y: 18)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: isOn ? 34 : 26, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.48), lineWidth: 1)
                }
        }
    }
}

private struct MiMaterial3PreviewButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay {
                if configuration.isPressed {
                    RoundedRectangle(cornerRadius: 34, style: .continuous)
                        .fill(MiMaterial3Tokens.primary.opacity(0.10))
                }
            }
            .scaleEffect(configuration.isPressed ? 0.965 : 1)
            .animation(.spring(response: 0.18, dampingFraction: 0.86), value: configuration.isPressed)
    }
}

private struct MiMaterial3HeroPalette {
    let sourceHex: String
    let source: Color
    let primary: Color
    let primaryContainer: Color
    let onPrimaryContainer: Color
    let secondaryContainer: Color
    let onSecondaryContainer: Color
    let tertiaryContainer: Color
    let onTertiaryContainer: Color
    let neutralContainer: Color
    let surface: Color

    static let violet = MiMaterial3HeroPalette(
        sourceHex: "#6750A4",
        source: MiMaterial3Tokens.primary,
        primary: MiMaterial3Tokens.primary,
        primaryContainer: MiMaterial3Tokens.primaryContainer,
        onPrimaryContainer: MiMaterial3Tokens.onPrimaryContainer,
        secondaryContainer: MiMaterial3Tokens.secondaryContainer,
        onSecondaryContainer: MiMaterial3Tokens.onSecondaryContainer,
        tertiaryContainer: MiMaterial3Tokens.tertiaryContainer,
        onTertiaryContainer: MiMaterial3Tokens.onTertiaryContainer,
        neutralContainer: MiMaterial3Tokens.surfaceContainerHighest,
        surface: MiMaterial3Tokens.surfaceContainerLow
    )

    static let teal = MiMaterial3HeroPalette(
        sourceHex: "#006A60",
        source: Color(hex: 0x006A60),
        primary: Color(hex: 0x006A60),
        primaryContainer: Color(hex: 0x9FF2E6),
        onPrimaryContainer: Color(hex: 0x00201C),
        secondaryContainer: Color(hex: 0xCCE8E1),
        onSecondaryContainer: Color(hex: 0x06201C),
        tertiaryContainer: Color(hex: 0xEADCF8),
        onTertiaryContainer: Color(hex: 0x21172C),
        neutralContainer: Color(hex: 0xDDE5E1),
        surface: Color(hex: 0xF4FBF7)
    )
}

private struct MiMaterial3SourceWell: View {
    let palette: MiMaterial3HeroPalette
    let isPersonalized: Bool

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Circle()
                .fill(palette.source)
                .frame(width: isPersonalized ? 66 : 58, height: isPersonalized ? 66 : 58)
                .shadow(color: palette.primary.opacity(0.18), radius: 12, x: 0, y: 7)
            Circle()
                .fill(palette.secondaryContainer)
                .frame(width: 31, height: 31)
                .offset(x: 3, y: 1)
            Circle()
                .strokeBorder(Color.white.opacity(0.72), lineWidth: 2)
                .frame(width: isPersonalized ? 66 : 58, height: isPersonalized ? 66 : 58)
        }
        .frame(width: 72, height: 72)
    }
}

private enum MiMaterial3StyleSpecKind {
    case type
    case shape
    case motion
}

private struct MiMaterial3StyleSpecCard: View {
    let titleKey: String
    let bodyKey: String
    let kind: MiMaterial3StyleSpecKind

    var body: some View {
        MiMaterial3Panel(fill: MiMaterial3Tokens.surfaceContainerLowest, radius: 22) {
            VStack(alignment: .leading, spacing: 12) {
                preview
                    .frame(height: 56)
                Text(MiL10n.text(titleKey))
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(MiMaterial3Tokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 12.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiMaterial3Tokens.muted)
                    .lineSpacing(2.5)
            }
        }
    }

    @ViewBuilder
    private var preview: some View {
        switch kind {
        case .type:
            HStack(alignment: .lastTextBaseline, spacing: 8) {
                Text("Aa")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                Text(MiL10n.text("m3_type_title_sample"))
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                Text(MiL10n.text("m3_type_body_sample"))
                    .font(.system(size: 12, weight: .medium, design: .rounded))
            }
            .foregroundStyle(MiMaterial3Tokens.primary)
        case .shape:
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(MiMaterial3Tokens.primaryContainer)
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(MiMaterial3Tokens.secondaryContainer)
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(MiMaterial3Tokens.tertiaryContainer)
            }
        case .motion:
            HStack(spacing: 8) {
                Capsule(style: .continuous)
                    .fill(MiMaterial3Tokens.primary)
                    .frame(width: 56)
                Capsule(style: .continuous)
                    .fill(MiMaterial3Tokens.primary.opacity(0.28))
                    .frame(width: 36)
                Capsule(style: .continuous)
                    .fill(MiMaterial3Tokens.primary.opacity(0.14))
                    .frame(width: 24)
            }
        }
    }
}

private struct MiMaterial3StateCard: View {
    let titleKey: String
    let bodyKey: String
    let systemImage: String
    var fill: Color = MiMaterial3Tokens.surface
    var iconColor: Color = MiMaterial3Tokens.primary

    var body: some View {
        MiMaterial3Panel(fill: fill, radius: 22) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: systemImage)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(iconColor)
                Text(MiL10n.text(titleKey))
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(MiMaterial3Tokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 12.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiMaterial3Tokens.muted)
                    .lineSpacing(2.5)
            }
        }
    }
}

private struct MiMaterial3GuidanceCard: View {
    let titleKey: String
    let bodyKey: String
    let systemImage: String
    let fill: Color

    var body: some View {
        MiMaterial3Panel(fill: fill, radius: 22) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    Image(systemName: systemImage)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(MiMaterial3Tokens.primary)
                        .frame(width: 36, height: 36)
                        .background {
                            Circle()
                                .fill(Color.white.opacity(0.44))
                        }

                    Text(MiL10n.text(titleKey))
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(MiMaterial3Tokens.ink)
                        .lineLimit(2)
                }

                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 12.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiMaterial3Tokens.muted)
                    .lineSpacing(2.5)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

/// Material 3 indeterminate linear progress indicator: a track with a primary
/// segment that slides back and forth. Reduce Motion shows a determinate segment.
private struct MiMaterial3LinearProgress: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var slide = false

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            Capsule(style: .continuous)
                .fill(MiMaterial3Tokens.surfaceContainerHighest)
                .overlay(alignment: .leading) {
                    Capsule(style: .continuous)
                        .fill(MiMaterial3Tokens.primary)
                        .frame(width: width * 0.4)
                        .offset(x: reduceMotion ? 0 : (slide ? width * 0.6 : 0))
                }
                .clipShape(Capsule(style: .continuous))
        }
        .frame(height: 6)
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) {
                slide = true
            }
        }
    }
}

/// Loading state using the Material 3 linear progress indicator instead of a
/// static icon.
private struct MiMaterial3LoadingCard: View {
    var body: some View {
        MiMaterial3Panel(fill: MiMaterial3Tokens.primaryContainer, radius: 22) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: "hourglass")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(MiMaterial3Tokens.primary)
                Text(MiL10n.text("m3_loading"))
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(MiMaterial3Tokens.ink)

                MiMaterial3LinearProgress()

                Text(MiL10n.text("m3_loading_body"))
                    .font(.system(size: 12.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiMaterial3Tokens.muted)
                    .lineSpacing(2.5)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

/// Error state with an in-style recovery action. The retry button is a tonal
/// Material 3 button, so its press fires the standard state-layer overlay; recovery
/// switches the card from the error role to the secondary container role.
private struct MiMaterial3ErrorCard: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var recovered = false

    var body: some View {
        MiMaterial3Panel(fill: recovered ? MiMaterial3Tokens.secondaryContainer : MiMaterial3Tokens.errorContainer, radius: 22) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: recovered ? "checkmark.circle.fill" : "exclamationmark.circle")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(recovered ? MiMaterial3Tokens.primary : MiMaterial3Tokens.error)
                Text(MiL10n.text(recovered ? "m3_recovered" : "m3_error"))
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(MiMaterial3Tokens.ink)
                Text(MiL10n.text(recovered ? "m3_recovered_body" : "m3_error_body"))
                    .font(.system(size: 12.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiMaterial3Tokens.muted)
                    .lineSpacing(2.5)
                    .fixedSize(horizontal: false, vertical: true)

                Button {
                    withAnimation(reduceMotion ? .easeOut(duration: 0.01) : .spring(response: 0.3, dampingFraction: 0.86)) {
                        recovered.toggle()
                    }
                } label: {
                    Label(
                        MiL10n.text(recovered ? "m3_recovered" : "m3_retry"),
                        systemImage: recovered ? "checkmark" : "arrow.clockwise"
                    )
                    .font(.system(size: 12.5, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 44)
                }
                .buttonStyle(MiMaterial3ButtonStyle(role: recovered ? .filled : .tonal))
            }
        }
    }
}
