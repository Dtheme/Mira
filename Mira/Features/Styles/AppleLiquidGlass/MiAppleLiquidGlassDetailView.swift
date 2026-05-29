//
//  MiAppleLiquidGlassDetailView.swift
//  Mira
//
//  Created on 2026/5/22.
//

import SwiftUI

struct MiAppleLiquidGlassDetailView: View {
    let style: MiDesignStyle
    let onBack: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @State private var demoSearchText = ""
    @State private var selectedDemoMode = "alg_shell"

    init(style: MiDesignStyle, onBack: (() -> Void)? = nil) {
        self.style = style
        self.onBack = onBack
    }

    var body: some View {
        ZStack(alignment: .top) {
            MiColorTokens.appBackground
                .ignoresSafeArea()

            MiDetailAmbientLight(style: style)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: MiSpacingTokens.lg) {
                    MiStyleDetailHeroView(style: style)

                    MiAppleLiquidGlassLiveDemoView(
                        searchText: $demoSearchText,
                        selectedMode: $selectedDemoMode,
                        accent: style.accent
                    )

                    MiAppleLiquidGlassComponentShowcaseView(accent: style.accent)

                    MiDemoSlotOverviewView(style: style)

                    MiVisualTokensView(style: style)

                    ForEach(style.sections) { section in
                        MiStyleDetailSectionView(section: section, accent: style.accent)
                    }
                }
                .padding(.horizontal, MiSpacingTokens.md)
                .padding(.top, 86)
                .padding(.bottom, MiSpacingTokens.xxl)
                .frame(maxWidth: 780, alignment: .leading)
                .frame(maxWidth: .infinity)
            }
            .scrollIndicators(.hidden)

            MiDetailTopBar(style: style) {
                close()
            }
            .padding(.horizontal, MiSpacingTokens.md)
            .padding(.top, MiSpacingTokens.sm)
            .zIndex(20)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func close() {
        if let onBack {
            onBack()
        } else {
            dismiss()
        }
    }
}

private struct MiDetailAmbientLight: View {
    let style: MiDesignStyle

    var body: some View {
        ZStack {
            Rectangle()
                .fill(MiColorTokens.frost050)

            LinearGradient(
                colors: [
                    Color.white.opacity(0.90),
                    style.accent.opacity(0.060),
                    .clear,
                    MiColorTokens.frost100.opacity(0.58)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            LinearGradient(
                colors: [
                    .clear,
                    Color.white.opacity(0.62)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
    }
}

private struct MiDetailTopBar: View {
    let style: MiDesignStyle
    let onBack: () -> Void

    @ViewBuilder
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 30, style: .continuous)

        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            GlassEffectContainer(spacing: 8) {
                barContent
                    .glassEffect(
                        .regular
                            .tint(style.accent.opacity(0.12))
                            .interactive(true),
                        in: shape
                    )
                    .overlay(MiLiquidChromeStroke(shape: shape, accent: style.accent, opacity: 0.30))
            }
        } else {
            barContent
                .background {
                    shape
                        .fill(.ultraThinMaterial)
                        .overlay {
                            shape
                                .fill(style.accent.opacity(0.08))
                        }
                }
                .overlay(MiLiquidChromeStroke(shape: shape, accent: style.accent, opacity: 0.30))
        }
    }

    private var barContent: some View {
        HStack(spacing: MiSpacingTokens.sm) {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .foregroundStyle(MiColorTokens.contentPrimary)
            .accessibilityLabel(MiL10n.text("c_back"))
            .contentShape(Circle())
            .background {
                Circle()
                    .fill(Color.white.opacity(0.58))
                    .overlay {
                        Circle()
                            .strokeBorder(Color.white.opacity(0.78), lineWidth: 1)
                    }
            }

            VStack(alignment: .leading, spacing: 2) {
                let displayName = MiL10n.text(style.name)
                let localizedName = MiL10n.text(style.localizedName)

                Text(displayName)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiColorTokens.contentPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)
                    .miStyleTitleTransition(style.id)

                if localizedName != displayName {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(style.accent)
                            .frame(width: 6, height: 6)

                        Text(localizedName)
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundStyle(MiColorTokens.contentSecondary)
                            .lineLimit(1)
                    }
                }
            }
            .layoutPriority(1)

            Spacer(minLength: MiSpacingTokens.sm)

            Image(systemName: style.isImplementationReady ? "checkmark.seal.fill" : "doc.badge.clock")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(style.isImplementationReady ? MiColorTokens.lime400 : MiColorTokens.amber400)
                .frame(width: 34, height: 34)
                .background {
                    Circle()
                        .fill(Color.white.opacity(0.58))
                }
                .accessibilityHidden(true)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 7)
        .frame(maxWidth: 780)
        .shadow(color: Color(hex: 0x738197).opacity(0.09), radius: 12, x: 0, y: 8)
    }
}

private struct MiLiquidChromeStroke<S: InsettableShape>: View {
    let shape: S
    let accent: Color
    let opacity: Double

    var body: some View {
        shape
            .strokeBorder(
                LinearGradient(
                    colors: [
                        MiColorTokens.frost050.opacity(opacity),
                        accent.opacity(opacity * 0.72),
                        MiColorTokens.frost050.opacity(0.08)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 0.9
            )
    }
}

struct MiAppleLiquidGlassPressButtonStyle: ButtonStyle {
    let isEnabled: Bool

    init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && isEnabled ? 0.982 : 1)
            .brightness(configuration.isPressed && isEnabled ? 0.018 : 0)
            .opacity(isEnabled ? 1 : 0.58)
            .animation(.easeOut(duration: 0.10), value: configuration.isPressed)
    }
}

private struct MiStyleDetailHeroView: View {
    let style: MiDesignStyle

    private let columns = [
        GridItem(.flexible(), spacing: MiSpacingTokens.sm),
        GridItem(.flexible(), spacing: MiSpacingTokens.sm)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: MiSpacingTokens.lg) {
            HStack(alignment: .center, spacing: MiSpacingTokens.sm) {
                Text(MiL10n.text("alg_mira_design_system"))
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiColorTokens.contentSecondary)
                    .lineLimit(1)

                Spacer(minLength: MiSpacingTokens.sm)

                MiImplementationBadgeView(isReady: style.isImplementationReady)
            }

            VStack(alignment: .leading, spacing: MiSpacingTokens.sm) {
                let displayName = MiL10n.text(style.name)
                let localizedName = MiL10n.text(style.localizedName)

                Text(displayName)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(MiColorTokens.contentPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.72)

                if localizedName != displayName {
                    Text(localizedName)
                        .font(.system(size: 19, weight: .semibold, design: .rounded))
                        .foregroundStyle(style.accent)
                        .lineLimit(1)
                        .minimumScaleFactor(0.82)
                }
            }

            Text(MiL10n.text(style.description))
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .lineSpacing(3)
                .foregroundStyle(MiColorTokens.contentSecondary)
                .fixedSize(horizontal: false, vertical: true)

            MiAppleLiquidGlassHeroPreview(accent: style.accent)

            MiAppleLiquidGlassHeroChromeView(accent: style.accent)

            LazyVGrid(columns: columns, alignment: .leading, spacing: MiSpacingTokens.sm) {
                MiHeroInfoPillView(
                    title: "alg_category",
                    value: style.category.title,
                    systemImage: "square.stack.3d.up",
                    accent: style.accent
                )

                MiHeroInfoPillView(
                    title: "alg_document",
                    value: "c_design_md",
                    systemImage: "doc.text",
                    accent: style.accent
                )

                MiHeroInfoPillView(
                    title: "alg_preview",
                    value: style.screenshotStatus,
                    systemImage: style.screenshotAssetName == nil ? "photo.badge.plus" : "photo.fill",
                    accent: style.accent
                )

                MiHeroInfoPillView(
                    title: "alg_shell",
                    value: "alg_liquid_glass",
                    systemImage: "circle.lefthalf.filled",
                    accent: style.accent
                )
            }
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            MiAppleLiquidGlassHeroBackground(accent: style.accent)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.86),
                            style.accent.opacity(0.22),
                            Color.white.opacity(0.48)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
        .shadow(color: Color(hex: 0x738197).opacity(0.075), radius: 14, x: 0, y: 9)
        .accessibilityElement(children: .combine)
    }
}

private struct MiAppleLiquidGlassHeroBackground: View {
    let accent: Color

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 34, style: .continuous)

        shape
            .fill(Color.white.opacity(0.74))
            .overlay {
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.92),
                        accent.opacity(0.115),
                        MiColorTokens.frost100.opacity(0.46)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .clipShape(shape)
            }
            .overlay {
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.54),
                        .clear,
                        accent.opacity(0.060)
                    ],
                    startPoint: .top,
                    endPoint: .bottomTrailing
                )
                .clipShape(shape)
                .allowsHitTesting(false)
            }
    }
}

private struct MiAppleLiquidGlassHeroPreview: View {
    let accent: Color

    @State private var isOn = true

    var body: some View {
        MiAppleLiquidGlassHeroPreviewContent(isOn: $isOn, accent: accent)
            .padding(14)
            .background {
                MiAppleLiquidGlassHeroPreviewShell(accent: accent)
            }
    }
}

private struct MiAppleLiquidGlassHeroPreviewShell: View {
    let accent: Color

    @ViewBuilder
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 24, style: .continuous)

        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            GlassEffectContainer(spacing: 10) {
                shape
                    .fill(Color.clear)
                    .glassEffect(
                        .regular
                            .tint(accent.opacity(0.090))
                            .interactive(true),
                        in: shape
                    )
                    .overlay {
                        MiAppleLiquidGlassHeroPreviewSheen(accent: accent)
                            .clipShape(shape)
                            .allowsHitTesting(false)
                    }
                    .overlay {
                        MiLiquidChromeStroke(
                            shape: shape,
                            accent: accent,
                            opacity: 0.24
                        )
                    }
                    .shadow(color: Color(hex: 0x738197).opacity(0.11), radius: 12, x: 0, y: 7)
            }
        } else {
            MiAppleLiquidGlassHeroPreviewFallback(accent: accent)
                .overlay {
                    shape
                        .strokeBorder(Color.white.opacity(0.66), lineWidth: 1)
                }
        }
    }
}

private struct MiAppleLiquidGlassHeroPreviewContent: View {
    @Binding var isOn: Bool
    let accent: Color

    var body: some View {
        HStack(alignment: .center, spacing: MiSpacingTokens.md) {
            MiAppleLiquidGlassHeroSwitch(isOn: $isOn, accent: accent)
                .frame(width: 134, height: 76)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(isOn ? accent : MiColorTokens.contentMuted.opacity(0.5))
                        .frame(width: 6, height: 6)
                        .transaction { transaction in
                            transaction.animation = nil
                        }

                    Text(MiL10n.text(isOn ? "alg_hero_state_active" : "alg_hero_state_idle"))
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(MiColorTokens.contentPrimary)
                        .tracking(0.4)
                        .textCase(.uppercase)
                        .transaction { transaction in
                            transaction.animation = nil
                        }
                }

                MiAppleLiquidGlassHeroMetricRow(
                    titleKey: "alg_hero_metric_tint",
                    value: isOn ? "14 %" : "0 %",
                    accent: accent,
                    isHighlighted: isOn
                )
                MiAppleLiquidGlassHeroMetricRow(
                    titleKey: "alg_hero_metric_radius",
                    value: "34 pt",
                    accent: accent,
                    isHighlighted: false
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private struct MiAppleLiquidGlassHeroPreviewSheen: View {
    let accent: Color

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.white.opacity(0.28),
                    .clear,
                    accent.opacity(0.070)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            LinearGradient(
                colors: [
                    Color.white.opacity(0.44),
                    Color.white.opacity(0.06),
                    .clear
                ],
                startPoint: .top,
                endPoint: .center
            )

            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            accent.opacity(0.085),
                            .clear
                        ],
                        center: .center,
                        startRadius: 8,
                        endRadius: 58
                    )
                )
                .frame(width: 118, height: 118)
                .offset(x: 112, y: -42)
        }
    }
}

private struct MiAppleLiquidGlassHeroPreviewFallback: View {
    let accent: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(Color.white.opacity(0.52))
            .overlay {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.48),
                                accent.opacity(0.080),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
    }
}

private struct MiAppleLiquidGlassHeroSwitch: View {
    @Binding var isOn: Bool
    let accent: Color

    private let trackWidth: CGFloat = 134
    private let trackHeight: CGFloat = 76
    private let knobInset: CGFloat = 7
    private var knobSize: CGFloat { trackHeight - knobInset * 2 }
    private var knobTravel: CGFloat { trackWidth - knobSize - knobInset * 2 }

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            ZStack(alignment: .leading) {
                track

                knob
                    .padding(knobInset)
                    .offset(x: isOn ? knobTravel : 0)
                    .animation(.easeInOut(duration: 0.18), value: isOn)
            }
            .frame(width: trackWidth, height: trackHeight)
            .contentShape(Capsule(style: .continuous))
        }
        .buttonStyle(MiAppleLiquidGlassPressButtonStyle())
        .accessibilityLabel(MiL10n.text("alg_liquid_shell_demo"))
        .accessibilityValue(MiL10n.text(isOn ? "c_selected" : "c_not_selected"))
    }

    @ViewBuilder
    private var track: some View {
        let shape = Capsule(style: .continuous)

        shape
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.68),
                        MiColorTokens.frost100.opacity(0.56),
                        accent.opacity(0.060)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                shape
                    .fill(accent.opacity(isOn ? 0.145 : 0))
                    .animation(.easeOut(duration: 0.14), value: isOn)
            }
            .overlay {
                shape
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.86),
                                accent.opacity(isOn ? 0.22 : 0.08),
                                Color.white.opacity(0.42)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
            }
    }

    @ViewBuilder
    private var knob: some View {
        let shape = Circle()

        shape
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.96),
                        MiColorTokens.frost050.opacity(0.86),
                        accent.opacity(0.050)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: knobSize, height: knobSize)
            .overlay {
                shape
                    .strokeBorder(Color.white.opacity(0.86), lineWidth: 0.9)
            }
            .overlay { knobGlyph }
            .shadow(color: Color(hex: 0x738197).opacity(0.14), radius: 3, x: 0, y: 2)
    }

    private var knobGlyph: some View {
        Image(systemName: isOn ? "checkmark" : "circle")
            .font(.system(size: 21, weight: .heavy))
            .foregroundStyle(
                LinearGradient(
                    colors: isOn
                        ? [accent, accent.opacity(0.72)]
                        : [MiColorTokens.contentMuted, MiColorTokens.contentMuted.opacity(0.7)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }
}

private struct MiAppleLiquidGlassHeroMetricRow: View {
    let titleKey: String
    let value: String
    let accent: Color
    let isHighlighted: Bool

    var body: some View {
        HStack(spacing: 8) {
            Text(MiL10n.text(titleKey))
                .font(.system(size: 10.5, weight: .semibold, design: .rounded))
                .foregroundStyle(MiColorTokens.contentMuted)
                .tracking(0.4)
                .textCase(.uppercase)

            Spacer(minLength: 6)

            Text(value)
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundStyle(isHighlighted ? accent : MiColorTokens.contentPrimary)
                .padding(.horizontal, 8)
                .frame(height: 22)
                .background {
                    Capsule(style: .continuous)
                        .fill(Color.white.opacity(0.58))
                }
                .overlay {
                    Capsule(style: .continuous)
                        .strokeBorder(Color.white.opacity(0.78), lineWidth: 0.7)
                }
        }
    }
}

private struct MiAppleLiquidGlassHeroChromeView: View {
    let accent: Color

    var body: some View {
        HStack(spacing: MiSpacingTokens.sm) {
            MiAppleLiquidGlassHeroChromePill(title: "slot_nav", systemImage: "sidebar.left", accent: accent)
            MiAppleLiquidGlassHeroChromePill(title: "c_search", systemImage: "magnifyingglass", accent: MiColorTokens.aqua400)
            MiAppleLiquidGlassHeroChromePill(title: "alg_inspector", systemImage: "slider.horizontal.3", accent: MiColorTokens.iris500)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct MiAppleLiquidGlassHeroChromePill: View {
    let title: String
    let systemImage: String
    let accent: Color

    var body: some View {
        let shape = Capsule(style: .continuous)

        content
            .background {
                shape
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.66),
                                MiColorTokens.frost100.opacity(0.48),
                                accent.opacity(0.08)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .overlay(MiLiquidChromeStroke(shape: shape, accent: accent, opacity: 0.18))
    }

    private var content: some View {
        HStack(spacing: 7) {
            Image(systemName: systemImage)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(accent)

            Text(MiL10n.text(title))
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(MiColorTokens.contentPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.76)
        }
        .padding(.horizontal, MiSpacingTokens.sm)
        .frame(height: 34)
    }
}

private struct MiHeroInfoPillView: View {
    let title: String
    let value: String
    let systemImage: String
    let accent: Color

    var body: some View {
        HStack(spacing: MiSpacingTokens.sm) {
            Image(systemName: systemImage)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(accent)
                .frame(width: 30, height: 30)
                .background {
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .fill(accent.opacity(0.13))
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(MiL10n.text(title))
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(MiColorTokens.contentMuted)
                    .lineLimit(1)

                Text(MiL10n.text(value))
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiColorTokens.contentPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.76)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.50))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.white.opacity(0.72), lineWidth: 1)
        }
    }
}

private struct MiAppleLiquidGlassLiveDemoView: View {
    @Binding var searchText: String
    @Binding var selectedMode: String

    let accent: Color

    private let modes = ["alg_shell", "alg_control", "alg_overlay"]
    private let columns = [
        GridItem(.flexible(), spacing: MiSpacingTokens.sm),
        GridItem(.flexible(), spacing: MiSpacingTokens.sm)
    ]
    private let modeAnimation = Animation.easeInOut(duration: 0.18)

    var body: some View {
        MiDetailPanelView(title: "alg_liquid_shell_demo", accent: accent) {
            VStack(alignment: .leading, spacing: MiSpacingTokens.md) {
                MiLiquidDemoStatusStrip(accent: accent)

                MiAppleLiquidGlassSearchControl(
                    text: $searchText,
                    placeholder: "alg_search_apple_liquid",
                    role: .detail,
                    showsResetAction: false,
                    supportText: "alg_real_controls"
                )

                HStack(spacing: MiSpacingTokens.xs) {
                    ForEach(modes, id: \.self) { mode in
                        MiAppleLiquidGlassModeChip(
                            title: mode,
                            isSelected: selectedMode == mode,
                            accent: accent
                        ) {
                            withAnimation(modeAnimation) {
                                selectedMode = mode
                            }
                        }
                    }
                }
                .padding(4)
                .background {
                    Capsule(style: .continuous)
                        .fill(Color.white.opacity(0.50))
                }

                LazyVGrid(columns: columns, spacing: MiSpacingTokens.sm) {
                    MiAppleLiquidGlassSurfaceSample(
                        title: selectedMode,
                        value: "alg_adaptive_tint",
                        systemImage: "circle.lefthalf.filled",
                        accent: accent,
                        prominence: .strong
                    )

                    MiAppleLiquidGlassSurfaceSample(
                        title: "alg_readable",
                        value: "alg_content_layer",
                        systemImage: "text.alignleft",
                        accent: MiColorTokens.aqua400,
                        prominence: .soft
                    )
                }

                MiAppleLiquidGlassFloatingControlRow(accent: accent)
            }
        }
    }
}

private struct MiLiquidDemoStatusStrip: View {
    let accent: Color

    var body: some View {
        HStack(spacing: MiSpacingTokens.sm) {
            Image(systemName: "sparkles")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(accent)
                .frame(width: 28, height: 28)
                .background {
                    Circle()
                        .fill(accent.opacity(0.12))
                }

            Text(MiL10n.text("alg_shell_controls_glass"))
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(MiColorTokens.contentSecondary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: MiSpacingTokens.xs)
        }
        .padding(.horizontal, MiSpacingTokens.sm)
        .padding(.vertical, 9)
        .background {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.48))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.white.opacity(0.70), lineWidth: 1)
        }
    }
}

private struct MiAppleLiquidGlassModeChip: View {
    let title: String
    let isSelected: Bool
    let accent: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(MiL10n.text(title))
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(isSelected ? MiColorTokens.contentPrimary : MiColorTokens.contentSecondary)
                .lineLimit(1)
                .frame(maxWidth: .infinity)
                .frame(height: 38)
        }
        .buttonStyle(MiAppleLiquidGlassPressButtonStyle())
        .modifier(MiAppleLiquidGlassModeChipChrome(isSelected: isSelected, accent: accent))
        .accessibilityValue(MiL10n.text(isSelected ? "c_selected" : "c_not_selected"))
    }
}

private struct MiAppleLiquidGlassModeChipChrome: ViewModifier {
    let isSelected: Bool
    let accent: Color

    func body(content: Content) -> some View {
        let shape = Capsule(style: .continuous)

        content
            .background {
                shape
                    .fill(
                        LinearGradient(
                            colors: isSelected
                                ? [
                                    Color.white.opacity(0.90),
                                    accent.opacity(0.22),
                                    Color.white.opacity(0.66)
                                ]
                                : [
                                    Color.white.opacity(0.36),
                                    MiColorTokens.frost100.opacity(0.28)
                                ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .overlay {
                shape
                    .strokeBorder(isSelected ? accent.opacity(0.24) : Color.white.opacity(0.46), lineWidth: 0.85)
            }
            .opacity(isSelected ? 1 : 0.86)
    }
}

private enum MiAppleLiquidGlassSurfaceProminence: Equatable {
    case strong
    case soft
}

private struct MiAppleLiquidGlassSurfaceSample: View {
    let title: String
    let value: String
    let systemImage: String
    let accent: Color
    let prominence: MiAppleLiquidGlassSurfaceProminence

    var body: some View {
        VStack(alignment: .leading, spacing: MiSpacingTokens.sm) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(accent)

            Spacer(minLength: MiSpacingTokens.xs)

            Text(MiL10n.text(title))
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(MiColorTokens.contentPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.78)

            Text(MiL10n.text(value))
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(MiColorTokens.contentSecondary)
                .lineLimit(2)
        }
        .padding(MiSpacingTokens.md)
        .frame(maxWidth: .infinity, minHeight: 128, alignment: .topLeading)
        .background {
            MiAppleLiquidGlassDemoSurface(accent: accent, prominence: prominence)
        }
    }
}

private struct MiAppleLiquidGlassDemoSurface: View {
    let accent: Color
    let prominence: MiAppleLiquidGlassSurfaceProminence

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 24, style: .continuous)
        let baseOpacity = prominence == .strong ? 0.13 : 0.08

        shape
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(prominence == .strong ? 0.82 : 0.68),
                        MiColorTokens.frost100.opacity(prominence == .strong ? 0.70 : 0.56),
                        accent.opacity(baseOpacity)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                shape
                    .strokeBorder(Color.white.opacity(0.74), lineWidth: 1)
            }
    }
}

private struct MiAppleLiquidGlassFloatingControlRow: View {
    let accent: Color

    var body: some View {
        HStack(alignment: .center, spacing: MiSpacingTokens.sm) {
            HStack(spacing: MiSpacingTokens.sm) {
                MiAppleLiquidGlassRoundButton(systemImage: "slider.horizontal.3", accent: accent)
                MiAppleLiquidGlassRoundButton(systemImage: "rectangle.stack", accent: MiColorTokens.aqua400)
                MiAppleLiquidGlassRoundButton(systemImage: "text.bubble", accent: MiColorTokens.iris500)
            }

            Spacer(minLength: MiSpacingTokens.xs)

            Text(MiL10n.text("alg_floating_layer"))
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(MiColorTokens.contentSecondary)
                .lineLimit(1)
                .padding(.horizontal, MiSpacingTokens.sm)
                .frame(height: 32)
                .background {
                    Capsule(style: .continuous)
                        .fill(Color.white.opacity(0.52))
                }
        }
    }
}

private struct MiAppleLiquidGlassRoundButton: View {
    let systemImage: String
    let accent: Color

    var body: some View {
        Image(systemName: systemImage)
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(MiColorTokens.contentPrimary)
            .frame(width: 44, height: 44)
            .modifier(MiAppleLiquidGlassRoundButtonChrome(accent: accent))
            .accessibilityHidden(true)
    }
}

private struct MiAppleLiquidGlassRoundButtonChrome: ViewModifier {
    let accent: Color

    @ViewBuilder
    func body(content: Content) -> some View {
        let shape = Circle()

        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            content
                .glassEffect(
                    .regular
                        .tint(accent.opacity(0.11))
                        .interactive(true),
                    in: shape
                )
                .overlay {
                    shape
                        .strokeBorder(Color.white.opacity(0.70), lineWidth: 0.9)
                }
        } else {
            content
                .background {
                    MiAppleLiquidGlassDemoSurface(accent: accent, prominence: .soft)
                }
        }
    }
}

private struct MiImplementationBadgeView: View {
    let isReady: Bool

    var body: some View {
        Label(MiL10n.text(isReady ? "c_ready" : "c_registered"), systemImage: isReady ? "checkmark.seal.fill" : "doc.badge.clock")
            .font(MiTypographyTokens.label)
            .foregroundStyle(isReady ? MiColorTokens.obsidian950 : MiColorTokens.contentPrimary)
            .padding(.horizontal, MiSpacingTokens.sm)
            .frame(height: 34)
            .background {
                Capsule(style: .continuous)
                    .fill(isReady ? MiColorTokens.lime400 : Color.white.opacity(0.58))
            }
            .overlay {
                Capsule(style: .continuous)
                    .strokeBorder(MiColorTokens.glassBorder, lineWidth: 1)
            }
    }
}

private struct MiDemoSlotOverviewView: View {
    let style: MiDesignStyle

    private let columns = [
        GridItem(.adaptive(minimum: 148), spacing: MiSpacingTokens.sm)
    ]

    var body: some View {
        MiDetailPanelView(title: "alg_demo_slots", accent: style.accent) {
            LazyVGrid(columns: columns, alignment: .leading, spacing: MiSpacingTokens.sm) {
                ForEach(style.demoSlots) { slot in
                    MiDemoSlotTileView(slot: slot, accent: style.accent)
                }
            }
        }
    }
}

private struct MiDemoSlotTileView: View {
    let slot: MiDemoSlot
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: MiSpacingTokens.sm) {
            Image(systemName: slot.systemImage)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(accent)
                .frame(width: 32, height: 32)
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(accent.opacity(0.12))
                }

            Text(MiL10n.text(slot.title))
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(MiColorTokens.contentPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(MiL10n.text(slot.description))
                .font(.caption)
                .foregroundStyle(MiColorTokens.contentSecondary)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(MiSpacingTokens.sm)
        .frame(maxWidth: .infinity, minHeight: 126, alignment: .topLeading)
        .background {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(0.52))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(Color.white.opacity(0.72), lineWidth: 1)
        }
    }
}

private struct MiVisualTokensView: View {
    let style: MiDesignStyle

    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: MiSpacingTokens.sm)
    ]

    var body: some View {
        MiDetailPanelView(title: "alg_visual_tokens", accent: style.accent) {
            if style.visualTokens.isEmpty {
                MiPendingTokensView(style: style)
            } else {
                LazyVGrid(columns: columns, alignment: .leading, spacing: MiSpacingTokens.sm) {
                    ForEach(style.visualTokens) { token in
                        MiTokenSwatchView(token: token, accent: style.accent)
                    }
                }
            }
        }
    }
}

private struct MiPendingTokensView: View {
    let style: MiDesignStyle

    var body: some View {
        HStack(alignment: .top, spacing: MiSpacingTokens.sm) {
            Image(systemName: "doc.text.magnifyingglass")
                .foregroundStyle(style.accent)
                .font(.title3)
                .frame(width: 34, height: 34)

            VStack(alignment: .leading, spacing: MiSpacingTokens.xs) {
                Text(MiL10n.text("alg_design_md_pending"))
                    .font(.headline)
                    .foregroundStyle(MiColorTokens.contentPrimary)

                Text(MiL10n.text("alg_tokens_shown_style"))
                    .font(MiTypographyTokens.body)
                    .foregroundStyle(MiColorTokens.contentSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(MiSpacingTokens.md)
        .background {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(0.56))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(style.accent.opacity(0.16), lineWidth: 1)
        }
    }
}

private struct MiTokenSwatchView: View {
    let token: MiTokenSpec
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: MiSpacingTokens.sm) {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(MiTokenColorResolver.color(for: token.value) ?? accent)
                .frame(height: 44)
                .overlay {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(MiColorTokens.frost050.opacity(0.34), lineWidth: 1)
                }

            Text(token.name)
                .font(MiTypographyTokens.label)
                .foregroundStyle(MiColorTokens.contentPrimary)
                .lineLimit(2)
                .minimumScaleFactor(0.78)

            Text(token.value)
                .font(.caption.monospaced())
                .foregroundStyle(MiColorTokens.contentMuted)
                .lineLimit(1)

            Text(MiL10n.text(token.role))
                .font(.caption)
                .foregroundStyle(MiColorTokens.contentSecondary)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(MiSpacingTokens.sm)
        .frame(maxWidth: .infinity, minHeight: 158, alignment: .topLeading)
        .background {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(0.52))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(Color.white.opacity(0.70), lineWidth: 1)
        }
    }
}

private enum MiTokenColorResolver {
    static func color(for value: String) -> Color? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.hasPrefix("#") else {
            return nil
        }

        let hexString = String(trimmed.dropFirst())
        guard let hex = UInt(hexString, radix: 16) else {
            return nil
        }

        return Color(hex: hex)
    }
}

private struct MiStyleDetailSectionView: View {
    let section: MiStyleDetailSection
    let accent: Color

    var body: some View {
        MiDetailPanelView(title: section.title, accent: accent) {
            VStack(alignment: .leading, spacing: MiSpacingTokens.md) {
                Text(MiL10n.text(section.summary))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiColorTokens.contentPrimary)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(alignment: .leading, spacing: MiSpacingTokens.sm) {
                    ForEach(section.bullets, id: \.self) { bullet in
                        MiBulletRowView(text: bullet, accent: accent)
                    }
                }
            }
        }
    }
}

private struct MiBulletRowView: View {
    let text: String
    let accent: Color

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: MiSpacingTokens.sm) {
            Circle()
                .fill(accent)
                .frame(width: 7, height: 7)
                .alignmentGuide(.firstTextBaseline) { dimensions in
                    dimensions[VerticalAlignment.center]
                }

            Text(MiL10n.text(text))
                .font(MiTypographyTokens.body)
                .foregroundStyle(MiColorTokens.contentSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct MiDetailPanelView<Content: View>: View {
    let title: String
    let accent: Color
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: MiSpacingTokens.md) {
            HStack(spacing: MiSpacingTokens.xs) {
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .fill(accent)
                    .frame(width: 5, height: 20)

                Text(MiL10n.text(title))
                    .font(MiTypographyTokens.sectionTitle)
                    .foregroundStyle(MiColorTokens.contentPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.82)
            }

            content
        }
        .padding(MiSpacingTokens.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            MiDetailPanelBackground(accent: accent)
        }
    }
}

struct MiDetailPanelBackground: View {
    let accent: Color

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 28, style: .continuous)

        shape
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.76),
                        MiColorTokens.frost100.opacity(0.46),
                        accent.opacity(0.036)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                shape
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.82),
                                accent.opacity(0.14),
                                Color.white.opacity(0.44)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
    }
}

#Preview {
    MiAppleLiquidGlassDetailView(style: MiStyleRepository.styles[0])
}
