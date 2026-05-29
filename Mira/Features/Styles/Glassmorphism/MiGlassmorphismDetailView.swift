//
//  MiGlassmorphismDetailView.swift
//  Mira
//
//  Created on 2026/5/25.
//

import SwiftUI

struct MiGlassmorphismDetailView: View {
    let style: MiDesignStyle
    let onBack: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var selectedSegment = 0
    @State private var searchText = ""
    @FocusState private var searchFocused: Bool

    var body: some View {
        ZStack(alignment: .top) {
            MiGlassmorphismTokens.pageBackground
                .ignoresSafeArea()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: MiGlassmorphismTokens.sectionSpacing) {
                    hero
                    surfaces
                    components
                    inputAndNavigation
                    states
                    implementationDetails
                    tokens
                    prompt
                }
                .padding(.horizontal, 22)
                .padding(.top, 90)
                .padding(.bottom, 50)
                .frame(maxWidth: 780, alignment: .leading)
                .frame(maxWidth: .infinity)
            }
            .scrollIndicators(.hidden)

            MiGlassmorphismTopBar(style: style) {
                close()
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .zIndex(20)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .animation(reduceMotion ? nil : .spring(response: 0.28, dampingFraction: 0.84), value: selectedSegment)
    }

    private var hero: some View {
        MiGlassmorphismPanel(radius: 34, padding: 22) {
            VStack(alignment: .leading, spacing: 20) {
                MiGlassmorphismChip(titleKey: "glass_badge", isSelected: true)

                VStack(alignment: .leading, spacing: 8) {
                    Text(MiL10n.text(style.name))
                        .font(.system(size: 42, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiGlassmorphismTokens.ink)
                        .lineLimit(2)
                        .minimumScaleFactor(0.72)
                    Text(MiL10n.text("glass_hero_body"))
                        .font(.system(size: 15.5, weight: .medium, design: .rounded))
                        .foregroundStyle(MiGlassmorphismTokens.muted)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }

                MiGlassmorphismHeroPreview()
            }
        }
    }

    private var surfaces: some View {
        MiGlassmorphismSection(titleKey: "glass_surface_lab", bodyKey: "glass_surface_body") {
            LazyVGrid(columns: columns, spacing: 14) {
                MiGlassmorphismSurfaceSample(titleKey: "glass_surface_shell", bodyKey: "glass_surface_shell_body", tint: MiGlassmorphismTokens.blue)
                MiGlassmorphismSurfaceSample(titleKey: "glass_surface_content", bodyKey: "glass_surface_content_body", tint: MiGlassmorphismTokens.mint)
                MiGlassmorphismSurfaceSample(titleKey: "glass_surface_overlay", bodyKey: "glass_surface_overlay_body", tint: MiGlassmorphismTokens.violet)
            }
        }
    }

    private var components: some View {
        MiGlassmorphismSection(titleKey: "glass_components", bodyKey: "glass_components_body") {
            MiGlassmorphismPanel {
                VStack(alignment: .leading, spacing: 16) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        MiGlassmorphismButton(titleKey: "glass_primary", systemImage: "sparkles", isPrimary: true)
                        MiGlassmorphismButton(titleKey: "glass_secondary", systemImage: "square.stack.3d.up")
                        MiGlassmorphismButton(titleKey: "glass_disabled", systemImage: "lock", isDisabled: true)
                    }

                    HStack(spacing: 8) {
                        MiGlassmorphismChip(titleKey: "glass_chip_active", isSelected: true)
                        MiGlassmorphismChip(titleKey: "glass_chip_layer", isSelected: false)
                        MiGlassmorphismChip(titleKey: "glass_chip_blur", isSelected: false)
                    }
                }
            }
        }
    }

    private var inputAndNavigation: some View {
        MiGlassmorphismSection(titleKey: "glass_input_nav", bodyKey: "glass_input_nav_body") {
            VStack(spacing: 14) {
                MiGlassmorphismPanel {
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(MiGlassmorphismTokens.blue)
                        TextField(MiL10n.text("glass_search_placeholder"), text: $searchText)
                            .focused($searchFocused)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(MiGlassmorphismTokens.ink)
                    }
                    .frame(minHeight: 48)
                }

                MiGlassmorphismPanel(padding: 8) {
                    HStack(spacing: 6) {
                        ForEach(0..<3, id: \.self) { index in
                            Button {
                                selectedSegment = index
                            } label: {
                                Text(MiL10n.text(["glass_seg_shell", "glass_seg_depth", "glass_seg_a11y"][index]))
                                    .font(.system(size: 12.5, weight: .bold, design: .rounded))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 42)
                            }
                            .buttonStyle(MiGlassSegmentButtonStyle(isSelected: selectedSegment == index))
                        }
                    }
                }
            }
        }
    }

    private var states: some View {
        MiGlassmorphismSection(titleKey: "glass_states", bodyKey: "glass_states_body") {
            LazyVGrid(columns: columns, spacing: 14) {
                MiGlassmorphismStateCard(titleKey: "glass_empty", bodyKey: "glass_empty_body", systemImage: "tray")
                MiGlassmorphismStateCard(titleKey: "glass_loading", bodyKey: "glass_loading_body", systemImage: "clock", isLoading: true)
                MiGlassmorphismStateCard(titleKey: "glass_error", bodyKey: "glass_error_body", systemImage: "exclamationmark.triangle", tint: MiColorTokens.rose500)
                MiGlassmorphismStateCard(titleKey: "glass_selected", bodyKey: "glass_selected_body", systemImage: "checkmark.circle", tint: MiGlassmorphismTokens.cyan)
            }
        }
    }

    private var implementationDetails: some View {
        MiGlassmorphismSection(titleKey: "glass_details", bodyKey: "glass_details_body") {
            LazyVGrid(columns: columns, spacing: 14) {
                MiGlassmorphismGuidanceCard(
                    titleKey: "glass_layer_title",
                    bodyKey: "glass_layer_body",
                    systemImage: "square.3.layers.3d",
                    tint: MiGlassmorphismTokens.blue
                )
                MiGlassmorphismGuidanceCard(
                    titleKey: "glass_fallback_title",
                    bodyKey: "glass_fallback_body",
                    systemImage: "textformat.size",
                    tint: MiGlassmorphismTokens.mint
                )
                MiGlassmorphismGuidanceCard(
                    titleKey: "glass_motion_title",
                    bodyKey: "glass_motion_body",
                    systemImage: "arrow.triangle.2.circlepath",
                    tint: MiGlassmorphismTokens.violet
                )
            }
        }
    }

    private var tokens: some View {
        MiGlassmorphismSection(titleKey: "glass_tokens", bodyKey: "glass_tokens_body") {
            LazyVGrid(columns: columns, spacing: 14) {
                MiGlassmorphismTokenSwatch(title: "glass-cyan", value: "#62E6F2", color: MiGlassmorphismTokens.cyan)
                MiGlassmorphismTokenSwatch(title: "glass-blue", value: "#6EA8FF", color: MiGlassmorphismTokens.blue)
                MiGlassmorphismTokenSwatch(title: "glass-violet", value: "#B8A2FF", color: MiGlassmorphismTokens.violet)
                MiGlassmorphismTokenSwatch(title: "glass-surface", value: "white 54%", color: Color.white.opacity(0.74))
            }
        }
    }

    private var prompt: some View {
        MiGlassmorphismSection(titleKey: "glass_prompt", bodyKey: "glass_prompt_body") {
            MiGlassmorphismPanel {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(["glass_prompt_1", "glass_prompt_2", "glass_prompt_3", "glass_check_1", "glass_check_2"], id: \.self) { key in
                        Label(MiL10n.text(key), systemImage: key.contains("check") ? "checkmark.circle" : "text.bubble")
                            .font(.system(size: 13.5, weight: .semibold, design: .rounded))
                            .foregroundStyle(MiGlassmorphismTokens.ink)
                            .fixedSize(horizontal: false, vertical: true)
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

private struct MiGlassmorphismTopBar: View {
    let style: MiDesignStyle
    let onBack: () -> Void

    var body: some View {
        MiGlassmorphismPanel(radius: 24, padding: 6) {
            HStack(spacing: 10) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 15, weight: .bold))
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(MiGlassTopButtonStyle())
                .accessibilityLabel(MiL10n.text("c_back"))

                VStack(alignment: .leading, spacing: 1) {
                    Text(MiL10n.text(style.name))
                        .font(.system(size: 13.5, weight: .bold, design: .rounded))
                        .foregroundStyle(MiGlassmorphismTokens.ink)
                        .lineLimit(1)
                    Text(MiL10n.text(style.localizedName))
                        .font(.system(size: 11.5, weight: .medium, design: .rounded))
                        .foregroundStyle(MiGlassmorphismTokens.muted)
                        .lineLimit(1)
                }

                Spacer(minLength: 0)

                MiGlassmorphismChip(titleKey: "c_ready", isSelected: true)
            }
        }
    }
}

private struct MiGlassTopButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(MiGlassmorphismTokens.ink)
            .background {
                Circle()
                    .fill(Color.white.opacity(configuration.isPressed ? 0.72 : 0.42))
                    .overlay { Circle().strokeBorder(Color.white.opacity(0.84), lineWidth: 1) }
            }
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
    }
}

private struct MiGlassSegmentButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isSelected ? MiGlassmorphismTokens.ink : MiGlassmorphismTokens.muted)
            .background {
                Capsule(style: .continuous)
                    .fill(isSelected ? Color.white.opacity(0.72) : Color.clear)
                    .overlay {
                        Capsule(style: .continuous)
                            .strokeBorder(Color.white.opacity(isSelected ? 0.88 : 0), lineWidth: 1)
                    }
            }
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
    }
}

private struct MiGlassmorphismHeroPreview: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isFocused = true

    var body: some View {
        MiGlassmorphismPanel(radius: 28, padding: 18) {
            HStack(alignment: .center, spacing: 18) {
                Button {
                    if reduceMotion {
                        isFocused.toggle()
                    } else {
                        withAnimation(.spring(response: 0.34, dampingFraction: 0.76)) {
                            isFocused.toggle()
                        }
                    }
                } label: {
                    ZStack(alignment: .bottomTrailing) {
                        RoundedRectangle(cornerRadius: 32, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        MiGlassmorphismTokens.cyan.opacity(isFocused ? 0.52 : 0.24),
                                        MiGlassmorphismTokens.blue.opacity(isFocused ? 0.36 : 0.18),
                                        MiGlassmorphismTokens.violet.opacity(isFocused ? 0.42 : 0.26)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(alignment: .topLeading) {
                                Circle()
                                    .fill(Color.white.opacity(0.52))
                                    .frame(width: 50, height: 50)
                                    .blur(radius: 12)
                                    .offset(x: 8, y: 6)
                            }
                            .overlay(alignment: .bottomLeading) {
                                HStack(spacing: 7) {
                                    ForEach(0..<3, id: \.self) { index in
                                        Capsule(style: .continuous)
                                            .fill(Color.white.opacity(index == 0 && isFocused ? 0.80 : 0.46))
                                            .frame(width: index == 0 ? 30 : 18, height: 8)
                                            .overlay {
                                                Capsule(style: .continuous)
                                                    .strokeBorder(Color.white.opacity(0.76), lineWidth: 0.7)
                                            }
                                    }
                                }
                                .padding(14)
                            }
                            .overlay {
                                RoundedRectangle(cornerRadius: 32, style: .continuous)
                                    .strokeBorder(Color.white.opacity(0.62), lineWidth: 1)
                            }

                        RoundedRectangle(cornerRadius: isFocused ? 34 : 26, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .frame(width: 92, height: 104)
                            .overlay {
                                RoundedRectangle(cornerRadius: isFocused ? 34 : 26, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.62),
                                                MiGlassmorphismTokens.cyan.opacity(isFocused ? 0.26 : 0.12),
                                                Color.white.opacity(0.18)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            }
                            .overlay(alignment: .topLeading) {
                                Capsule(style: .continuous)
                                    .fill(Color.white.opacity(0.88))
                                    .frame(width: 38, height: 7)
                                    .rotationEffect(.degrees(-32))
                                    .offset(x: 18, y: 24)
                            }
                            .overlay {
                                RoundedRectangle(cornerRadius: isFocused ? 34 : 26, style: .continuous)
                                    .strokeBorder(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.96),
                                                MiGlassmorphismTokens.cyan.opacity(isFocused ? 0.86 : 0.42),
                                                Color.white.opacity(0.26)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: isFocused ? 1.6 : 1.0
                                    )
                            }
                            .shadow(color: MiGlassmorphismTokens.blue.opacity(isFocused ? 0.34 : 0.14), radius: isFocused ? 18 : 10, x: 0, y: isFocused ? 14 : 8)

                        Image(systemName: isFocused ? "sparkles" : "circle.dotted")
                            .font(.system(size: 20, weight: .black))
                            .foregroundStyle(isFocused ? MiGlassmorphismTokens.ink : MiGlassmorphismTokens.muted)
                            .frame(width: 42, height: 42)
                            .background {
                                Circle()
                                    .fill(Color.white.opacity(isFocused ? 0.72 : 0.44))
                                    .overlay { Circle().strokeBorder(Color.white.opacity(0.86), lineWidth: 1) }
                            }
                            .offset(x: 6, y: 6)
                    }
                    .frame(width: 134, height: 134)
                    .contentShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                }
                .buttonStyle(MiGlassmorphismPreviewButtonStyle())
                .accessibilityLabel(MiL10n.text("glass_hero_toggle"))
                .accessibilityValue(MiL10n.text(isFocused ? "glass_focus" : "glass_quiet"))

                VStack(alignment: .leading, spacing: 10) {
                    MiGlassmorphismMetricRow(labelKey: "glass_metric_layer", value: isFocused ? "4" : "2", isActive: isFocused)
                    MiGlassmorphismMetricRow(labelKey: "glass_metric_blur", value: isFocused ? "22pt" : "11pt", isActive: true)
                    MiGlassmorphismMetricRow(labelKey: "glass_metric_edge", value: MiL10n.text(isFocused ? "glass_high" : "glass_low"), isActive: isFocused)
                    MiGlassmorphismMetricRow(labelKey: "glass_metric_state", value: MiL10n.text(isFocused ? "glass_focus" : "glass_quiet"), isActive: isFocused)
                }
            }
        }
    }
}

private struct MiGlassmorphismPreviewButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.965 : 1)
            .brightness(configuration.isPressed ? -0.025 : 0)
            .animation(.spring(response: 0.18, dampingFraction: 0.86), value: configuration.isPressed)
    }
}

private struct MiGlassmorphismSurfaceSample: View {
    let titleKey: String
    let bodyKey: String
    let tint: Color

    var body: some View {
        MiGlassmorphismPanel(radius: 22, padding: 14) {
            VStack(alignment: .leading, spacing: 10) {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(tint.opacity(0.30))
                    .frame(height: 46)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.82), lineWidth: 1)
                    }
                Text(MiL10n.text(titleKey))
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(MiGlassmorphismTokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(MiGlassmorphismTokens.muted)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

private struct MiGlassmorphismStateCard: View {
    let titleKey: String
    let bodyKey: String
    let systemImage: String
    var tint: Color = MiGlassmorphismTokens.blue
    var isLoading = false

    var body: some View {
        MiGlassmorphismPanel(radius: 22, padding: 14) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: systemImage)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(tint)
                    .symbolEffect(.pulse, options: .repeating, value: isLoading)
                Text(MiL10n.text(titleKey))
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(MiGlassmorphismTokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(MiGlassmorphismTokens.muted)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

private struct MiGlassmorphismGuidanceCard: View {
    let titleKey: String
    let bodyKey: String
    let systemImage: String
    let tint: Color

    var body: some View {
        MiGlassmorphismPanel(radius: 22, padding: 14) {
            VStack(alignment: .leading, spacing: 11) {
                HStack(spacing: 10) {
                    Image(systemName: systemImage)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(tint)
                        .frame(width: 34, height: 34)
                        .background {
                            Circle()
                                .fill(Color.white.opacity(0.42))
                                .overlay { Circle().strokeBorder(Color.white.opacity(0.78), lineWidth: 1) }
                        }

                    Text(MiL10n.text(titleKey))
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(MiGlassmorphismTokens.ink)
                        .lineLimit(2)
                }

                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 12.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiGlassmorphismTokens.muted)
                    .lineSpacing(2.5)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
