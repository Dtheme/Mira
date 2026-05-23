//
//  MiNeumorphismDetailView.swift
//  Mira
//
//  Created on 2026/5/23.
//

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

    init(style: MiDesignStyle, onBack: (() -> Void)? = nil) {
        self.style = style
        self.onBack = onBack
    }

    var body: some View {
        ZStack(alignment: .top) {
            MiNeumorphismTokens.pageBackground
                .ignoresSafeArea()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 28) {
                    MiNeumorphismHeroView(style: style)

                    styleCardSection

                    surfaceStatesSection

                    componentSection

                    formSection

                    sheetSection

                    statesSection

                    tokenSection

                    motionAccessibilitySection

                    promptSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 94)
                .padding(.bottom, 42)
                .frame(maxWidth: 780, alignment: .leading)
                .frame(maxWidth: .infinity)
            }
            .scrollIndicators(.hidden)

            MiNeumorphismTopBar(style: style) {
                close()
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            .zIndex(20)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .animation(reduceMotion ? nil : .spring(response: 0.28, dampingFraction: 0.82), value: isToggleOn)
        .animation(reduceMotion ? nil : .spring(response: 0.25, dampingFraction: 0.86), value: selectedSegment)
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
            MiNeumorphismSoftSurface(cornerRadius: 24, contentPadding: 16) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 12) {
                        Button(MiL10n.text("neu_primary")) {}
                            .buttonStyle(MiNeumorphismButtonStyle(isPrimary: true))

                        Button(MiL10n.text("neu_secondary")) {}
                            .buttonStyle(MiNeumorphismButtonStyle(isPrimary: false))
                    }

                    MiNeumorphismToggleControl(isOn: $isToggleOn)

                    MiNeumorphismSegmentedControl(
                        selectedIndex: $selectedSegment,
                        itemKeys: MiNeumorphismDetailContent.segmentKeys
                    )

                    HStack(spacing: 10) {
                        MiNeumorphismPill(titleKey: "neu_selected", isSelected: true)
                        MiNeumorphismPill(titleKey: "neu_disabled", isSelected: false)
                    }
                }
            }
        }
    }

    private var formSection: some View {
        MiNeumorphismSection(titleKey: "neu_form_lab", bodyKey: "neu_form_body") {
            VStack(alignment: .leading, spacing: 14) {
                MiNeumorphismInputField(text: $inputText, isFocused: $inputFocused)

                LazyVGrid(columns: adaptiveColumns, spacing: 12) {
                    MiNeumorphismPill(titleKey: inputFocused ? "neu_focused" : "neu_resting", isSelected: inputFocused)
                    MiNeumorphismPill(titleKey: inputText.isEmpty ? "neu_empty" : "neu_filled", isSelected: !inputText.isEmpty)
                    MiNeumorphismPill(titleKey: "neu_error", isSelected: false)
                }
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
            LazyVGrid(columns: adaptiveColumns, spacing: 14) {
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
            LazyVGrid(columns: adaptiveColumns, spacing: 14) {
                ForEach(MiNeumorphismDetailContent.tokenSwatches, id: \.titleKey) { swatch in
                    MiNeumorphismTokenSwatch(
                        titleKey: swatch.titleKey,
                        value: swatch.value,
                        color: swatch.color
                    )
                }
            }
        }
    }

    private var motionAccessibilitySection: some View {
        MiNeumorphismSection(titleKey: "neu_motion_a11y", bodyKey: "neu_motion_a11y_body") {
            MiNeumorphismMotionAccessibilityPanel()
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
        [GridItem(.adaptive(minimum: 148), spacing: 14)]
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
        MiNeumorphismSoftSurface(cornerRadius: 28, contentPadding: 8) {
            HStack(spacing: 10) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(MiNeumorphismTokens.ink)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(MiNeumorphismButtonStyle(isPrimary: false))
                .frame(width: 54)
                .accessibilityLabel(MiL10n.text("c_back"))

                VStack(alignment: .leading, spacing: 2) {
                    Text(MiL10n.text(style.name))
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.ink)
                        .lineLimit(1)

                    Text(MiL10n.text("neu_soft_ui"))
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.muted)
                }

                Spacer(minLength: 0)

                Text(MiL10n.text("c_ready"))
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(MiNeumorphismTokens.accentDeep)
                    .padding(.horizontal, 12)
                    .frame(height: 34)
                    .background {
                        MiNeumorphismSoftSurface(cornerRadius: 17, depth: .inset, contentPadding: 0) {
                            EmptyView()
                        }
                    }
            }
        }
        .frame(maxWidth: 780)
    }
}

private struct MiNeumorphismHeroView: View {
    let style: MiDesignStyle

    var body: some View {
        MiNeumorphismSoftSurface(cornerRadius: 32, contentPadding: 22) {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(MiL10n.text("neu_soft_lab"))
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.accentDeep)

                    Text(MiL10n.text(style.name))
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.ink)
                        .lineLimit(2)
                        .minimumScaleFactor(0.72)

                    Text(MiL10n.text("neu_hero_body"))
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.muted)
                        .lineSpacing(3)
                }

                MiNeumorphismHeroPreview()
            }
        }
    }
}

private struct MiNeumorphismHeroPreview: View {
    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            MiNeumorphismSoftSurface(cornerRadius: 24, contentPadding: 14) {
                VStack(alignment: .leading, spacing: 12) {
                    MiNeumorphismPill(titleKey: "neu_raised", isSelected: false)
                    MiNeumorphismPill(titleKey: "neu_inset", isSelected: true)
                    MiNeumorphismPill(titleKey: "neu_pressed", isSelected: false)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 142)

            MiNeumorphismSoftSurface(cornerRadius: 24, depth: .inset, contentPadding: 16) {
                VStack(spacing: 14) {
                    Circle()
                        .fill(MiNeumorphismTokens.focusAccent.opacity(0.72))
                        .frame(width: 48, height: 48)
                        .shadow(color: MiNeumorphismTokens.shadowDark.opacity(0.42), radius: 7, x: 4, y: 4)
                        .shadow(color: MiNeumorphismTokens.shadowLight.opacity(0.90), radius: 7, x: -4, y: -4)

                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(MiNeumorphismTokens.muted.opacity(0.18))
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(MiNeumorphismTokens.focusAccent.opacity(0.35))
                        .frame(width: 74, height: 8)
                }
            }
            .frame(width: 122, height: 142)
        }
    }
}

private struct MiNeumorphismStyleCardDemo: View {
    let style: MiDesignStyle

    var body: some View {
        MiNeumorphismSoftSurface(cornerRadius: 30, contentPadding: 18) {
            VStack(alignment: .leading, spacing: 16) {
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
                            .font(.system(size: 24, weight: .bold, design: .rounded))
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
                    .foregroundStyle(MiNeumorphismTokens.muted)
                    .lineSpacing(2)

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
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    MiNeumorphismDepthGlyph(depth: depth)

                    Text(MiL10n.text(titleKey))
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.ink)
                }

                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(MiNeumorphismTokens.muted)
                    .lineSpacing(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(minHeight: 126)
    }
}

private struct MiNeumorphismDepthGlyph: View {
    let depth: MiNeumorphismSurfaceDepth

    var body: some View {
        MiNeumorphismSoftSurface(
            cornerRadius: 14,
            depth: depth,
            fill: depth == .pressed ? MiNeumorphismTokens.basePressed : MiNeumorphismTokens.base,
            contentPadding: 0
        ) {
            Circle()
                .fill(glyphFill)
                .frame(width: 14, height: 14)
        }
        .frame(width: 34, height: 34)
    }

    private var glyphFill: Color {
        switch depth {
        case .raised:
            return MiNeumorphismTokens.focusAccent.opacity(0.54)
        case .inset:
            return MiNeumorphismTokens.accentDeep.opacity(0.50)
        case .pressed:
            return MiNeumorphismTokens.shadowDark.opacity(0.42)
        }
    }
}

private struct MiNeumorphismInspectorDemo: View {
    var body: some View {
        MiNeumorphismSoftSurface(cornerRadius: 28, contentPadding: 18) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(MiL10n.text("neu_inspector"))
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(MiNeumorphismTokens.ink)

                        Text(MiL10n.text("neu_inspector_hint"))
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(MiNeumorphismTokens.muted)
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
                    Capsule(style: .continuous)
                        .fill(MiNeumorphismTokens.focusAccent.opacity(0.18))
                }
        }
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
                HStack(spacing: 10) {
                    Image(systemName: symbolName)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(accent)
                        .frame(width: 34, height: 34)
                        .background {
                            Circle()
                                .fill(accent.opacity(0.14))
                        }

                    Text(MiL10n.text(titleKey))
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.ink)
                }

                if isLoading {
                    MiNeumorphismSkeletonLines()
                } else {
                    Text(MiL10n.text(bodyKey))
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.muted)
                        .lineSpacing(2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .opacity(isDisabled ? 0.56 : 1)
        .frame(minHeight: 136)
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
                    .foregroundStyle(MiNeumorphismTokens.muted)
                    .lineSpacing(2)
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
            VStack(alignment: .leading, spacing: 12) {
                Text(MiL10n.text(titleKey))
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(MiNeumorphismTokens.ink)

                ForEach(items) { item in
                    HStack(alignment: .top, spacing: 10) {
                        Circle()
                            .fill(MiNeumorphismTokens.focusAccent.opacity(0.74))
                            .frame(width: 8, height: 8)
                            .padding(.top, 6)

                        Text(MiL10n.text(item.key))
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(MiNeumorphismTokens.muted)
                            .lineSpacing(2)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
