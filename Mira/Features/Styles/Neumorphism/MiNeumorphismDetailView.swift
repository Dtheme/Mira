//
//  MiNeumorphismDetailView.swift
//  Mira
//
//  Created on 2026/5/23.
//

import Foundation
import SwiftUI

struct MiNeumorphismDetailView: View {
    let style: MiDesignStyle
    let onBack: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isToggleOn = true
    @State private var selectedSegment = 0
    @State private var inputText = ""
    @FocusState private var inputFocused: Bool
    @State private var isRevealed = false

    init(style: MiDesignStyle, onBack: (() -> Void)? = nil) {
        self.style = style
        self.onBack = onBack
    }

    var body: some View {
        ZStack(alignment: .top) {
            MiNeumorphismTokens.pageBackground
                .ignoresSafeArea()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: MiNeumorphismTokens.sectionSpacing) {
                    MiNeumorphismHeroView(style: style)
                        .miStaggeredReveal(index: 0, isRevealed: isRevealed)

                    styleCardSection
                        .miStaggeredReveal(index: 1, isRevealed: isRevealed)

                    surfaceStatesSection
                        .miStaggeredReveal(index: 2, isRevealed: isRevealed)

                    componentSection
                        .miStaggeredReveal(index: 3, isRevealed: isRevealed)

                    formSection
                        .miStaggeredReveal(index: 4, isRevealed: isRevealed)

                    sheetSection
                        .miStaggeredReveal(index: 5, isRevealed: isRevealed)

                    statesSection
                        .miStaggeredReveal(index: 6, isRevealed: isRevealed)

                    tokenSection
                        .miStaggeredReveal(index: 7, isRevealed: isRevealed)

                    motionAccessibilitySection
                        .miStaggeredReveal(index: 8, isRevealed: isRevealed)

                    promptSection
                        .miStaggeredReveal(index: 9, isRevealed: isRevealed)
                }
                .padding(.horizontal, 22)
                .padding(.top, 86)
                .padding(.bottom, 48)
                .frame(maxWidth: 780, alignment: .leading)
                .frame(maxWidth: .infinity)
            }
            .scrollIndicators(.hidden)

            MiNeumorphismTopBar(style: style) {
                close()
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .zIndex(20)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .animation(reduceMotion ? nil : .spring(response: 0.28, dampingFraction: 0.82), value: isToggleOn)
        .animation(reduceMotion ? nil : .spring(response: 0.25, dampingFraction: 0.86), value: selectedSegment)
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

    private var surfaceStatesSection: some View {
        MiNeumorphismSection(titleKey: "neu_surface_states", bodyKey: "neu_surface_body") {
            LazyVGrid(columns: adaptiveColumns, spacing: 14) {
                MiNeumorphismSurfaceStateCard(titleKey: "neu_raised", bodyKey: "neu_raised_body", depth: .raised)
                MiNeumorphismSurfaceStateCard(titleKey: "neu_inset", bodyKey: "neu_inset_body", depth: .inset)
                MiNeumorphismSurfaceStateCard(titleKey: "neu_pressed", bodyKey: "neu_pressed_body", depth: .pressed)
            }
        }
    }

    private var styleCardSection: some View {
        MiNeumorphismSection(titleKey: "neu_card_demo", bodyKey: "neu_card_demo_body") {
            MiNeumorphismStyleCardDemo(style: style)
        }
    }

    private var componentSection: some View {
        MiNeumorphismSection(titleKey: "neu_component_lab", bodyKey: "neu_component_body") {
            VStack(alignment: .leading, spacing: 16) {
                MiNeumorphismDemoPanel {
                    MiNeumorphismButtonShowcase()
                }

                MiNeumorphismDemoPanel {
                    VStack(alignment: .leading, spacing: 18) {
                        MiNeumorphismToggleControl(isOn: $isToggleOn)

                        MiNeumorphismSegmentedControl(
                            selectedIndex: $selectedSegment,
                            itemKeys: MiNeumorphismDetailContent.segmentKeys
                        )
                    }
                }

                MiNeumorphismDemoPanel {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 10) {
                            MiNeumorphismPill(titleKey: "neu_selected", isSelected: true)
                            MiNeumorphismPill(titleKey: "neu_disabled", isSelected: false, isDisabled: true)
                        }

                        MiNeumorphismTagRail()
                    }
                }
            }
        }
    }

    private var formSection: some View {
        MiNeumorphismSection(titleKey: "neu_form_lab", bodyKey: "neu_form_body") {
            VStack(alignment: .leading, spacing: 16) {
                MiNeumorphismDemoPanel {
                    VStack(alignment: .leading, spacing: 14) {
                        MiNeumorphismInputField(text: $inputText, isFocused: $inputFocused)

                        LazyVGrid(columns: adaptiveColumns, spacing: 12) {
                            MiNeumorphismPill(titleKey: inputFocused ? "neu_focused" : "neu_resting", isSelected: inputFocused)
                            MiNeumorphismPill(titleKey: inputText.isEmpty ? "neu_empty" : "neu_filled", isSelected: !inputText.isEmpty)
                            MiNeumorphismPill(titleKey: "neu_error", isSelected: false)
                        }
                    }
                }

                MiNeumorphismInputStateGallery()
            }
        }
    }

    private var sheetSection: some View {
        MiNeumorphismSection(titleKey: "neu_sheet_lab", bodyKey: "neu_sheet_body") {
            MiNeumorphismInspectorDemo()
        }
    }

    private var statesSection: some View {
        MiNeumorphismSection(titleKey: "neu_states_lab", bodyKey: "neu_states_body") {
            LazyVGrid(columns: adaptiveColumns, spacing: 16) {
                MiNeumorphismDemoStateCard(titleKey: "neu_state_empty", bodyKey: "neu_state_empty_body", symbolName: "tray")
                MiNeumorphismDemoStateCard(titleKey: "neu_state_loading", bodyKey: "neu_state_loading_body", symbolName: "clock", isLoading: true)
                MiNeumorphismDemoStateCard(titleKey: "neu_state_error", bodyKey: "neu_state_error_body", symbolName: "exclamationmark.triangle", accent: MiNeumorphismTokens.error)
                MiNeumorphismDemoStateCard(titleKey: "neu_selected", bodyKey: "neu_state_selected_body", symbolName: "checkmark.circle", depth: .inset)
                MiNeumorphismDemoStateCard(titleKey: "neu_disabled", bodyKey: "neu_state_disabled_body", symbolName: "slash.circle", isDisabled: true)
            }
        }
    }

    private var tokenSection: some View {
        MiNeumorphismSection(titleKey: "neu_tokens", bodyKey: "neu_tokens_body") {
            VStack(alignment: .leading, spacing: 18) {
                LazyVGrid(columns: adaptiveColumns, spacing: 16) {
                    ForEach(MiNeumorphismDetailContent.tokenSwatches, id: \.titleKey) { swatch in
                        MiNeumorphismTokenSwatch(
                            titleKey: swatch.titleKey,
                            value: swatch.value,
                            color: swatch.color
                        )
                    }
                }

                MiNeumorphismShadowTokenGallery()
            }
        }
    }

    private var motionAccessibilitySection: some View {
        MiNeumorphismSection(titleKey: "neu_motion_a11y", bodyKey: "neu_motion_a11y_body") {
            VStack(alignment: .leading, spacing: 14) {
                MiNeumorphismMotionSamplePanel()
                MiNeumorphismMotionAccessibilityPanel()
            }
        }
    }

    private var promptSection: some View {
        MiNeumorphismSection(titleKey: "neu_prompt_guidance", bodyKey: "neu_prompt_body") {
            VStack(spacing: 14) {
                MiNeumorphismListPanel(
                    titleKey: "neu_prompt_guidance",
                    items: MiNeumorphismDetailContent.promptItems
                )

                MiNeumorphismListPanel(
                    titleKey: "neu_acceptance",
                    items: MiNeumorphismDetailContent.checklistItems
                )
            }
        }
    }

    private var adaptiveColumns: [GridItem] {
        [GridItem(.adaptive(minimum: 158), spacing: 16)]
    }

    private func close() {
        if let onBack {
            onBack()
        } else {
            dismiss()
        }
    }
}

private struct MiNeumorphismTopBar: View {
    let style: MiDesignStyle
    let onBack: () -> Void

    var body: some View {
        MiNeumorphismSoftSurface(cornerRadius: 22, contentPadding: 4) {
            HStack(spacing: 10) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(MiNeumorphismTokens.ink)
                }
                .buttonStyle(MiNeumorphismNavigationButtonStyle())
                .accessibilityLabel(MiL10n.text("c_back"))

                VStack(alignment: .leading, spacing: 1) {
                    Text(MiL10n.text(style.name))
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.ink)
                        .lineLimit(1)
                        .miStyleTitleTransition(style.id)

                    Text(MiL10n.text("neu_soft_ui"))
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.muted)
                        .tracking(0.4)
                }
                .layoutPriority(1)

                Spacer(minLength: 0)

                MiNeumorphismStatusIndicator(titleKey: "c_ready")
            }
            .padding(.trailing, 6)
        }
        .frame(maxWidth: 780)
        .frame(height: 52)
    }
}

private struct MiNeumorphismBrandGlyph: View {
    var body: some View {
        MiNeumorphismSoftSurface(
            cornerRadius: 12,
            depth: .inset,
            fill: MiNeumorphismTokens.baseInset,
            contentPadding: 0
        ) {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            MiNeumorphismTokens.baseLight,
                            MiNeumorphismTokens.base
                        ],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: 22
                    )
                )
                .frame(width: 18, height: 18)
                .shadow(color: MiNeumorphismTokens.shadowDark.opacity(0.36), radius: 2, x: 1.2, y: 1.2)
                .shadow(color: MiNeumorphismTokens.shadowLight.opacity(0.92), radius: 2, x: -1.2, y: -1.2)
                .overlay {
                    Circle()
                        .fill(MiNeumorphismTokens.focusAccent.opacity(0.32))
                        .frame(width: 6, height: 6)
                        .offset(x: -1, y: -1)
                }
        }
        .frame(width: 32, height: 32)
    }
}

private struct MiNeumorphismStatusIndicator: View {
    let titleKey: String

    var body: some View {
        HStack(spacing: 7) {
            Circle()
                .fill(MiNeumorphismTokens.success)
                .frame(width: 7, height: 7)
                .shadow(color: MiNeumorphismTokens.success.opacity(0.46), radius: 3, x: 0, y: 0)
                .shadow(color: MiNeumorphismTokens.shadowLight.opacity(0.62), radius: 1.2, x: -0.6, y: -0.6)
                .shadow(color: MiNeumorphismTokens.shadowDark.opacity(0.30), radius: 1.2, x: 0.6, y: 0.6)

            Text(MiL10n.text(titleKey))
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundStyle(MiNeumorphismTokens.accentDeep)
                .lineLimit(1)
                .tracking(0.4)
                .textCase(.uppercase)
        }
    }
}

private struct MiNeumorphismNavigationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 44, height: 44)
            .background {
                MiNeumorphismSoftSurface(
                    cornerRadius: 18,
                    depth: configuration.isPressed ? .pressed : .raised,
                    fill: configuration.isPressed ? MiNeumorphismTokens.basePressed : MiNeumorphismTokens.base,
                    contentPadding: 0
                ) {
                    EmptyView()
                }
            }
            .offset(x: configuration.isPressed ? 1 : 0, y: configuration.isPressed ? 1 : 0)
    }
}

private struct MiNeumorphismHeroView: View {
    let style: MiDesignStyle

    var body: some View {
        MiNeumorphismSoftSurface(cornerRadius: 28, contentPadding: 22) {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 10) {
                    MiNeumorphismHeroEyebrow()

                    Text(MiL10n.text(style.name))
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.ink)
                        .lineLimit(2)
                        .minimumScaleFactor(0.72)
                        .tracking(-0.4)
                        .padding(.top, 2)

                    Text(MiL10n.text("neu_hero_body"))
                        .font(.system(size: 14.5, weight: .medium, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.quietText)
                        .lineSpacing(4)
                        .frame(maxWidth: 560, alignment: .leading)
                }

                MiNeumorphismHeroPreview()
            }
        }
    }
}

private struct MiNeumorphismHeroEyebrow: View {
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(MiNeumorphismTokens.focusAccent)
                .frame(width: 6, height: 6)
                .shadow(color: MiNeumorphismTokens.shadowLight.opacity(0.72), radius: 1, x: -0.6, y: -0.6)
                .shadow(color: MiNeumorphismTokens.shadowDark.opacity(0.28), radius: 1, x: 0.6, y: 0.6)

            Text(MiL10n.text("neu_soft_lab"))
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundStyle(MiNeumorphismTokens.accentDeep)
                .tracking(0.6)
                .textCase(.uppercase)
        }
        .padding(.horizontal, 12)
        .frame(height: 28)
        .background {
            MiNeumorphismSoftSurface(
                cornerRadius: 14,
                depth: .inset,
                fill: MiNeumorphismTokens.baseInset,
                contentPadding: 0
            ) {
                EmptyView()
            }
        }
    }
}

private struct MiNeumorphismHeroPreview: View {
    @State private var isOn = true

    var body: some View {
        MiNeumorphismSoftSurface(cornerRadius: 22, depth: .inset, contentPadding: 16) {
            HStack(alignment: .center, spacing: 18) {
                MiNeumorphismHeroPowerControl(isOn: $isOn)
                    .frame(width: 128, height: 128)

                MiNeumorphismHeroStatusPanel(isOn: isOn)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

private struct MiNeumorphismHeroPowerControl: View {
    @Binding var isOn: Bool

    @State private var isPressed = false
    @GestureState private var dragInside = true

    var body: some View {
        ZStack {
            insetTrack

            centerButton
        }
        .contentShape(Circle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .updating($dragInside) { value, state, _ in
                    let distance = hypot(value.location.x - 64, value.location.y - 64)
                    state = distance <= 64
                }
                .onChanged { _ in
                    guard !isPressed else { return }
                    withAnimation(.spring(response: 0.18, dampingFraction: 0.82)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    let wasInside = dragInside
                    withAnimation(.spring(response: 0.26, dampingFraction: 0.78)) {
                        isPressed = false
                    }
                    if wasInside {
                        withAnimation(.spring(response: 0.36, dampingFraction: 0.74)) {
                            isOn.toggle()
                        }
                    }
                }
        )
    }

    private var insetTrack: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [
                        MiNeumorphismTokens.baseLight.opacity(0.78),
                        MiNeumorphismTokens.baseInset,
                        MiNeumorphismTokens.basePressed.opacity(0.58)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                Circle()
                    .stroke(MiNeumorphismTokens.shadowDark.opacity(0.34), lineWidth: 3)
                    .blur(radius: 5)
                    .offset(x: 5, y: 5)
                    .mask {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.clear, .black.opacity(0.86)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
            }
            .overlay {
                Circle()
                    .stroke(MiNeumorphismTokens.shadowLight.opacity(0.88), lineWidth: 3)
                    .blur(radius: 5)
                    .offset(x: -5, y: -5)
                    .mask {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.black.opacity(0.86), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
            }
    }

    private var centerButton: some View {
        MiNeumorphismSoftSurface(
            cornerRadius: 44,
            depth: isPressed ? .pressed : .raised,
            fill: isOn ? MiNeumorphismTokens.base : MiNeumorphismTokens.basePressed,
            contentPadding: 0
        ) {
            ZStack {
                Image(systemName: stateIconName)
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundStyle(
                        LinearGradient(
                            colors: isOn
                                ? [MiNeumorphismTokens.focusAccent, MiNeumorphismTokens.accentDeep]
                                : [MiNeumorphismTokens.muted, MiNeumorphismTokens.accent.opacity(0.62)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(
                        color: isOn ? MiNeumorphismTokens.focusAccent.opacity(0.22) : .clear,
                        radius: 3.5,
                        x: 0, y: 0
                    )
                    .id(stateIconName)
                    .transition(.scale(scale: 0.72).combined(with: .opacity))
            }
            .animation(.spring(response: 0.28, dampingFraction: 0.76), value: stateIconName)
        }
        .frame(width: 84, height: 84)
        .scaleEffect(isPressed ? 0.94 : 1.0)
        .offset(x: isPressed ? 1 : 0, y: isPressed ? 1 : 0)
    }

    private var stateIconName: String {
        isOn ? "checkmark" : "power"
    }
}

private struct MiNeumorphismHeroStatusPanel: View {
    let isOn: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Circle()
                    .fill(isOn ? MiNeumorphismTokens.success : MiNeumorphismTokens.muted.opacity(0.46))
                    .frame(width: 7, height: 7)
                    .overlay {
                        Circle()
                            .strokeBorder(Color.white.opacity(0.42), lineWidth: 0.6)
                    }

                Text(MiL10n.text(isOn ? "neu_hero_state_active" : "neu_hero_state_idle"))
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(MiNeumorphismTokens.ink)
                    .tracking(0.5)
                    .textCase(.uppercase)
            }

            VStack(alignment: .leading, spacing: 9) {
                MiNeumorphismHeroMetric(
                    titleKey: "neu_hero_metric_depth",
                    value: isOn ? "+12 dp" : "0 dp",
                    isHighlighted: isOn
                )
                MiNeumorphismHeroMetric(
                    titleKey: "neu_hero_metric_glow",
                    value: isOn ? "On" : "Idle",
                    isHighlighted: isOn
                )
                MiNeumorphismHeroMetric(
                    titleKey: "neu_hero_metric_tap",
                    value: MiL10n.text("neu_hero_tap_hint"),
                    isHighlighted: false
                )
            }
        }
    }
}

private struct MiNeumorphismHeroMetric: View {
    let titleKey: String
    let value: String
    let isHighlighted: Bool

    var body: some View {
        HStack(spacing: 8) {
            Text(MiL10n.text(titleKey))
                .font(.system(size: 10.5, weight: .semibold, design: .rounded))
                .foregroundStyle(MiNeumorphismTokens.muted)
                .tracking(0.5)
                .textCase(.uppercase)

            Spacer(minLength: 6)

            Text(value)
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundStyle(isHighlighted ? MiNeumorphismTokens.accentDeep : MiNeumorphismTokens.ink)
                .padding(.horizontal, 8)
                .frame(height: 22)
                .background {
                    MiNeumorphismSoftSurface(
                        cornerRadius: 7,
                        depth: .inset,
                        fill: MiNeumorphismTokens.baseInset,
                        contentPadding: 0
                    ) {
                        EmptyView()
                    }
                }
        }
    }
}

private struct MiNeumorphismStyleCardDemo: View {
    let style: MiDesignStyle

    var body: some View {
        MiNeumorphismSoftSurface(cornerRadius: 30, contentPadding: 18) {
            VStack(alignment: .leading, spacing: 18) {
                HStack(alignment: .center, spacing: 12) {
                    MiNeumorphismSoftSurface(cornerRadius: 16, contentPadding: 0) {
                        Text("NU")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(MiNeumorphismTokens.ink)
                            .frame(width: 44, height: 32)
                    }
                    .fixedSize()

                    VStack(alignment: .leading, spacing: 3) {
                        Text(MiL10n.text(style.name))
                            .font(.system(size: 25, weight: .black, design: .rounded))
                            .foregroundStyle(MiNeumorphismTokens.ink)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)

                        Text(MiL10n.text("neu_soft_ui"))
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundStyle(MiNeumorphismTokens.accentDeep)
                    }

                    Spacer(minLength: 0)
                }

                Text(MiL10n.text("neu_card_summary"))
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(MiNeumorphismTokens.quietText)
                    .lineSpacing(3)

                MiNeumorphismMiniInputPreview()

                HStack(spacing: 10) {
                    MiNeumorphismPill(titleKey: "neu_raised", isSelected: false)
                    MiNeumorphismPill(titleKey: "neu_inset", isSelected: true)
                    MiNeumorphismPill(titleKey: "neu_pressed", isSelected: false)
                }
            }
        }
    }
}

private struct MiNeumorphismMiniInputPreview: View {
    var body: some View {
        MiNeumorphismSoftSurface(cornerRadius: 18, depth: .inset, contentPadding: 0) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(MiNeumorphismTokens.accentDeep)

                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(MiNeumorphismTokens.muted.opacity(0.20))
                    .frame(width: 118, height: 7)

                Spacer(minLength: 0)

                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(MiNeumorphismTokens.focusAccent.opacity(0.42))
                    .frame(width: 38, height: 7)
            }
            .padding(.horizontal, 16)
            .frame(height: 54)
        }
    }
}

private struct MiNeumorphismSurfaceStateCard: View {
    let titleKey: String
    let bodyKey: String
    let depth: MiNeumorphismSurfaceDepth

    var body: some View {
        MiNeumorphismSoftSurface(
            cornerRadius: 22,
            depth: depth,
            fill: depth == .pressed ? MiNeumorphismTokens.basePressed : MiNeumorphismTokens.base,
            contentPadding: 14
        ) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .center, spacing: 12) {
                    MiNeumorphismDepthGlyph(depth: depth)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(MiL10n.text(titleKey))
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundStyle(MiNeumorphismTokens.ink)
                            .lineLimit(1)

                        Text(depthMnemonic)
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundStyle(MiNeumorphismTokens.accentDeep)
                            .tracking(0.4)
                    }

                    Spacer(minLength: 0)
                }

                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 12.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiNeumorphismTokens.quietText)
                    .lineSpacing(3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(minHeight: 144)
    }

    private var depthMnemonic: String {
        switch depth {
        case .raised: return "+ Z"
        case .inset: return "− Z"
        case .pressed: return "↓ Z"
        }
    }
}

private struct MiNeumorphismDepthGlyph: View {
    let depth: MiNeumorphismSurfaceDepth

    var body: some View {
        MiNeumorphismSoftSurface(
            cornerRadius: 13,
            depth: outerDepth,
            fill: outerFill,
            contentPadding: 0
        ) {
            ZStack {
                if depth == .inset {
                    MiNeumorphismInsetOverlay(cornerRadius: 9)
                        .frame(width: 22, height: 22)
                }

                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(coreFill)
                    .frame(width: 22, height: 22)
                    .modifier(MiNeumorphismDepthGlyphShadow(depth: depth))
            }
        }
        .frame(width: 38, height: 38)
    }

    private var outerDepth: MiNeumorphismSurfaceDepth {
        depth == .pressed ? .pressed : .raised
    }

    private var outerFill: Color {
        switch depth {
        case .raised: return MiNeumorphismTokens.base
        case .inset: return MiNeumorphismTokens.baseInset
        case .pressed: return MiNeumorphismTokens.basePressed
        }
    }

    private var coreFill: LinearGradient {
        switch depth {
        case .raised:
            return LinearGradient(
                colors: [MiNeumorphismTokens.focusAccent, MiNeumorphismTokens.accentDeep],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .inset:
            return LinearGradient(
                colors: [MiNeumorphismTokens.basePressed, MiNeumorphismTokens.baseInset],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .pressed:
            return LinearGradient(
                colors: [MiNeumorphismTokens.muted.opacity(0.42), MiNeumorphismTokens.shadowDark.opacity(0.52)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

private struct MiNeumorphismDepthGlyphShadow: ViewModifier {
    let depth: MiNeumorphismSurfaceDepth

    func body(content: Content) -> some View {
        switch depth {
        case .raised:
            content
                .shadow(color: MiNeumorphismTokens.accentDeep.opacity(0.36), radius: 3, x: 1.5, y: 1.5)
                .shadow(color: MiNeumorphismTokens.shadowLight.opacity(0.72), radius: 2, x: -1, y: -1)
        case .inset:
            content
                .overlay {
                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                        .stroke(MiNeumorphismTokens.shadowDark.opacity(0.36), lineWidth: 1)
                        .blur(radius: 1.4)
                        .offset(x: 1, y: 1)
                        .mask {
                            RoundedRectangle(cornerRadius: 9, style: .continuous)
                        }
                }
        case .pressed:
            content
                .overlay {
                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                        .stroke(MiNeumorphismTokens.shadowLight.opacity(0.78), lineWidth: 0.6)
                        .offset(x: -0.5, y: -0.5)
                }
        }
    }
}

private struct MiNeumorphismInspectorDemo: View {
    var body: some View {
        MiNeumorphismDemoPanel(cornerRadius: 28) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(MiL10n.text("neu_inspector"))
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(MiNeumorphismTokens.ink)

                        Text(MiL10n.text("neu_inspector_hint"))
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(MiNeumorphismTokens.quietText)
                    }

                    Spacer(minLength: 0)

                    MiNeumorphismSoftSurface(cornerRadius: 17, depth: .pressed, contentPadding: 0) {
                        Image(systemName: "xmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(MiNeumorphismTokens.muted)
                            .frame(width: 34, height: 34)
                    }
                    .fixedSize()
                }

                VStack(spacing: 10) {
                    MiNeumorphismInspectorRow(titleKey: "neu_sheet_row_1", valueKey: "neu_seg_raised")
                    MiNeumorphismInspectorRow(titleKey: "neu_sheet_row_2", valueKey: "neu_seg_inset")
                    MiNeumorphismInspectorRow(titleKey: "neu_sheet_row_3", valueKey: "neu_seg_focus")
                }

                MiNeumorphismSoftSurface(cornerRadius: 18, depth: .inset, contentPadding: 14) {
                    Text(MiL10n.text("neu_sheet_prompt"))
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.accentDeep)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

private struct MiNeumorphismInspectorRow: View {
    let titleKey: String
    let valueKey: String

    var body: some View {
        HStack(spacing: 10) {
            Text(MiL10n.text(titleKey))
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(MiNeumorphismTokens.ink)

            Spacer(minLength: 8)

            Text(MiL10n.text(valueKey))
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(MiNeumorphismTokens.accentDeep)
                .padding(.horizontal, 10)
                .frame(height: 28)
                .background {
                    MiNeumorphismSoftSurface(cornerRadius: 14, depth: .pressed, fill: MiNeumorphismTokens.focusSoft.opacity(0.88), contentPadding: 0) {
                        EmptyView()
                    }
                }
        }
        .padding(.vertical, 2)
    }
}

private struct MiNeumorphismDemoStateCard: View {
    let titleKey: String
    let bodyKey: String
    let symbolName: String
    var depth: MiNeumorphismSurfaceDepth = .raised
    var accent: Color = MiNeumorphismTokens.focusAccent
    var isLoading = false
    var isDisabled = false

    var body: some View {
        MiNeumorphismSoftSurface(
            cornerRadius: 22,
            depth: depth,
            fill: isDisabled ? MiNeumorphismTokens.basePressed : MiNeumorphismTokens.base,
            contentPadding: 14
        ) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center, spacing: 12) {
                    MiNeumorphismSoftSurface(
                        cornerRadius: 12,
                        depth: .inset,
                        fill: MiNeumorphismTokens.baseInset,
                        contentPadding: 0
                    ) {
                        Image(systemName: symbolName)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(accent)
                            .frame(width: 34, height: 34)
                    }
                    .fixedSize()

                    Text(MiL10n.text(titleKey))
                        .font(.system(size: 14.5, weight: .bold, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Spacer(minLength: 0)
                }

                if isLoading {
                    MiNeumorphismSkeletonLines()
                } else {
                    Text(MiL10n.text(bodyKey))
                        .font(.system(size: 12.5, weight: .medium, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.quietText)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .opacity(isDisabled ? 0.56 : 1)
        .frame(minHeight: 144)
    }
}

private struct MiNeumorphismSkeletonLines: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(MiNeumorphismTokens.muted.opacity(0.14))
                .frame(height: 8)

            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(MiNeumorphismTokens.focusAccent.opacity(0.20))
                .frame(width: 94, height: 8)
        }
    }
}

private struct MiNeumorphismMotionAccessibilityPanel: View {
    var body: some View {
        MiNeumorphismSoftSurface(cornerRadius: 24, contentPadding: 16) {
            VStack(spacing: 12) {
                MiNeumorphismAccessibilityRow(symbolName: "hand.tap", titleKey: "neu_a11y_touch", bodyKey: "neu_a11y_touch_body")
                MiNeumorphismAccessibilityRow(symbolName: "textformat.size", titleKey: "neu_a11y_type", bodyKey: "neu_a11y_type_body")
                MiNeumorphismAccessibilityRow(symbolName: "waveform.path.ecg", titleKey: "neu_a11y_motion", bodyKey: "neu_a11y_motion_body")
                MiNeumorphismAccessibilityRow(symbolName: "eye", titleKey: "neu_a11y_contrast", bodyKey: "neu_a11y_contrast_body")
            }
        }
    }
}

private struct MiNeumorphismAccessibilityRow: View {
    let symbolName: String
    let titleKey: String
    let bodyKey: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            MiNeumorphismSoftSurface(cornerRadius: 16, contentPadding: 0) {
                Image(systemName: symbolName)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(MiNeumorphismTokens.accentDeep)
                    .frame(width: 42, height: 42)
            }
            .fixedSize()

            VStack(alignment: .leading, spacing: 4) {
                Text(MiL10n.text(titleKey))
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(MiNeumorphismTokens.ink)

                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(MiNeumorphismTokens.quietText)
                    .lineSpacing(3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private struct MiNeumorphismListPanel: View {
    let titleKey: String
    let items: [MiNeumorphismPromptItem]

    var body: some View {
        MiNeumorphismSoftSurface(cornerRadius: 22, contentPadding: 16) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 1.5, style: .continuous)
                        .fill(MiNeumorphismTokens.focusAccent)
                        .frame(width: 3, height: 14)

                    Text(MiL10n.text(titleKey))
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.ink)
                        .tracking(-0.1)
                }

                VStack(alignment: .leading, spacing: 10) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        HStack(alignment: .top, spacing: 12) {
                            MiNeumorphismListIndex(number: index + 1)

                            Text(MiL10n.text(item.key))
                                .font(.system(size: 13.5, weight: .medium, design: .rounded))
                                .foregroundStyle(MiNeumorphismTokens.quietText)
                                .lineSpacing(3)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top, 4)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private struct MiNeumorphismListIndex: View {
    let number: Int

    var body: some View {
        MiNeumorphismSoftSurface(
            cornerRadius: 9,
            depth: .inset,
            fill: MiNeumorphismTokens.baseInset,
            contentPadding: 0
        ) {
            Text("\(number)")
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundStyle(MiNeumorphismTokens.accentDeep)
        }
        .frame(width: 24, height: 24)
        .fixedSize()
    }
}

