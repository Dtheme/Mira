//
//  MiAppleLiquidGlassComponentShowcaseView.swift
//  Mira
//
//  Created on 2026/5/22.
//

import SwiftUI

struct MiAppleLiquidGlassComponentShowcaseView: View {
    let accent: Color

    @State private var selectedSegment = "algc_controls"
    @State private var selectedGlassSegment = "algc_material"
    @State private var componentSearchText = ""
    @State private var promptText = MiL10n.text("ac_glass_readable")

    private let segments = ["algc_controls", "algc_inputs", "slot_states"]
    private let glassSegments = ["algc_material", "ds_motion", "nbd_prompt"]
    private let columns = [
        GridItem(.adaptive(minimum: 146), spacing: MiSpacingTokens.sm)
    ]

    var body: some View {
        MiDetailPanelView(title: "algc_component_examples", accent: accent) {
            VStack(alignment: .leading, spacing: MiSpacingTokens.md) {
                MiAppleLiquidGlassShowcaseIntro(accent: accent)

                MiAppleLiquidGlassSegmentedPicker(
                    items: segments,
                    selection: $selectedSegment,
                    accent: accent
                )

                MiAppleLiquidGlassSegmentSelectorDemo(
                    items: glassSegments,
                    selection: $selectedGlassSegment,
                    accent: accent
                )

                LazyVGrid(columns: columns, alignment: .leading, spacing: MiSpacingTokens.sm) {
                    MiAppleLiquidGlassComponentCard(
                        title: "c_search",
                        value: "algc_focused_shell",
                        systemImage: "magnifyingglass",
                        accent: accent
                    )

                    MiAppleLiquidGlassComponentCard(
                        title: "algc_buttons",
                        value: "algc_action_states",
                        systemImage: "button.programmable",
                        accent: MiColorTokens.aqua400
                    )

                    MiAppleLiquidGlassComponentCard(
                        title: "alg_inspector",
                        value: "alg_floating_layer",
                        systemImage: "sidebar.trailing",
                        accent: MiColorTokens.iris500
                    )

                    MiAppleLiquidGlassComponentCard(
                        title: "algc_feedback",
                        value: "ac_feedback_states",
                        systemImage: "checkmark.seal",
                        accent: MiColorTokens.lime400
                    )
                }

                MiAppleLiquidGlassButtonShowcase(accent: accent)

                MiAppleLiquidGlassInputShowcase(
                    searchText: $componentSearchText,
                    promptText: $promptText,
                    accent: accent
                )

                MiAppleLiquidGlassTagRail(accent: accent)

                MiAppleLiquidGlassInspectorSample(accent: accent)

                MiAppleLiquidGlassStateShowcase(accent: accent)
            }
        }
    }
}

private struct MiAppleLiquidGlassShowcaseIntro: View {
    let accent: Color

    var body: some View {
        HStack(alignment: .top, spacing: MiSpacingTokens.sm) {
            Image(systemName: "square.stack.3d.up")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(accent)
                .frame(width: 34, height: 34)
                .background {
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .fill(accent.opacity(0.12))
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(MiL10n.text("ac_shell_components"))
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiColorTokens.contentPrimary)

                Text(MiL10n.text("ac_search_tags"))
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundStyle(MiColorTokens.contentSecondary)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(MiSpacingTokens.sm)
        .background {
            MiAppleLiquidGlassStaticSurface(cornerRadius: 20, accent: accent.opacity(0.10))
        }
    }
}

private struct MiAppleLiquidGlassSegmentedPicker: View {
    let items: [String]
    @Binding var selection: String
    let accent: Color

    @ViewBuilder
    var body: some View {
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            GlassEffectContainer(spacing: 4) {
                segmentItems
                    .padding(4)
                    .glassEffect(
                        .regular
                            .tint(accent.opacity(0.055))
                            .interactive(false),
                        in: Capsule(style: .continuous)
                    )
                    .overlay(MiAppleLiquidGlassSegmentContainerStroke(accent: accent))
            }
        } else {
            segmentItems
                .padding(4)
                .background {
                    Capsule(style: .continuous)
                        .fill(Color.white.opacity(0.52))
                }
                .overlay(MiAppleLiquidGlassSegmentContainerStroke(accent: accent))
        }
    }

    private var segmentItems: some View {
        HStack(spacing: 4) {
            ForEach(items, id: \.self) { item in
                Button {
                    withAnimation(.easeInOut(duration: 0.18)) {
                        selection = item
                    }
                } label: {
                    Text(MiL10n.text(item))
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(selection == item ? MiColorTokens.obsidian950 : MiColorTokens.contentSecondary)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                }
                .buttonStyle(MiAppleLiquidGlassPressButtonStyle())
                .modifier(MiAppleLiquidGlassSegmentItemChrome(isSelected: selection == item, accent: accent))
                .accessibilityValue(MiL10n.text(selection == item ? "c_selected" : "c_not_selected"))
            }
        }
    }
}

private struct MiAppleLiquidGlassSegmentSelectorDemo: View {
    let items: [String]
    @Binding var selection: String
    let accent: Color

    var body: some View {
        MiAppleLiquidGlassSubsection(title: "algc_segment_selector", systemImage: "rectangle.split.3x1", accent: accent) {
            VStack(alignment: .leading, spacing: MiSpacingTokens.sm) {
                MiAppleLiquidGlassSegmentSelector(
                    items: items,
                    selection: $selection,
                    accent: accent
                )

                HStack(alignment: .top, spacing: MiSpacingTokens.sm) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(MiL10n.text(selection))
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(MiColorTokens.contentPrimary)
                            .lineLimit(1)

                        Text(MiL10n.text(description))
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundStyle(MiColorTokens.contentSecondary)
                            .lineSpacing(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer(minLength: MiSpacingTokens.xs)

                    VStack(alignment: .trailing, spacing: 5) {
                        MiAppleLiquidGlassSelectorMetric(title: "algc_44pt", value: "algc_touch", accent: accent)
                        MiAppleLiquidGlassSelectorMetric(title: "algc_glass", value: "algc_ios26", accent: MiColorTokens.aqua400)
                    }
                }
                .padding(MiSpacingTokens.sm)
                .background {
                    MiAppleLiquidGlassStaticSurface(cornerRadius: 18, accent: accent.opacity(0.08))
                }
            }
        }
    }

    private var description: String {
        switch selection {
        case "algc_material":
            return "algc_real_liquid_glass"
        case "ds_motion":
            return "ac_selected_motion"
        default:
            return "ac_prompt_guidance"
        }
    }
}

private struct MiAppleLiquidGlassSegmentSelector: View {
    let items: [String]
    @Binding var selection: String
    let accent: Color

    @ViewBuilder
    var body: some View {
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            GlassEffectContainer(spacing: 5) {
                selectorItems
                    .padding(5)
                    .glassEffect(
                        .regular
                            .tint(accent.opacity(0.070))
                            .interactive(false),
                        in: Capsule(style: .continuous)
                    )
                    .overlay(MiAppleLiquidGlassSegmentContainerStroke(accent: accent))
            }
        } else {
            selectorItems
                .padding(5)
                .background {
                    Capsule(style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.72),
                                    MiColorTokens.frost100.opacity(0.46),
                                    accent.opacity(0.045)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .overlay(MiAppleLiquidGlassSegmentContainerStroke(accent: accent))
        }
    }

    private var selectorItems: some View {
        HStack(spacing: 5) {
            ForEach(items, id: \.self) { item in
                Button {
                    withAnimation(.easeOut(duration: 0.16)) {
                        selection = item
                    }
                } label: {
                    Text(MiL10n.text(item))
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(selection == item ? MiColorTokens.contentPrimary : MiColorTokens.contentSecondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)
                        .frame(maxWidth: .infinity)
                        .frame(height: 38)
                }
                .buttonStyle(MiAppleLiquidGlassPressButtonStyle())
                .modifier(MiAppleLiquidGlassSegmentItemChrome(isSelected: selection == item, accent: accent))
                .accessibilityValue(MiL10n.text(selection == item ? "c_selected" : "c_not_selected"))
            }
        }
    }
}

private struct MiAppleLiquidGlassSegmentItemChrome: ViewModifier {
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
                                    Color.white.opacity(0.88),
                                    accent.opacity(0.24),
                                    Color.white.opacity(0.66)
                                ]
                                : [
                                    Color.white.opacity(0.30),
                                    MiColorTokens.frost100.opacity(0.20)
                                ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .overlay {
                shape
                    .strokeBorder(isSelected ? accent.opacity(0.22) : Color.white.opacity(0.42), lineWidth: 0.85)
            }
            .opacity(isSelected ? 1 : 0.86)
    }
}

private struct MiAppleLiquidGlassSegmentContainerStroke: View {
    let accent: Color

    var body: some View {
        Capsule(style: .continuous)
            .strokeBorder(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.76),
                        accent.opacity(0.16),
                        Color.white.opacity(0.46)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 0.9
            )
    }
}

private struct MiAppleLiquidGlassSelectorMetric: View {
    let title: String
    let value: String
    let accent: Color

    var body: some View {
        VStack(alignment: .trailing, spacing: 1) {
            Text(MiL10n.text(title))
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(accent)
                .lineLimit(1)

            Text(MiL10n.text(value))
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundStyle(MiColorTokens.contentMuted)
                .lineLimit(1)
        }
        .padding(.horizontal, 8)
        .frame(height: 34)
        .background {
            Capsule(style: .continuous)
                .fill(Color.white.opacity(0.54))
        }
        .overlay {
            Capsule(style: .continuous)
                .strokeBorder(Color.white.opacity(0.70), lineWidth: 1)
        }
    }
}

private struct MiAppleLiquidGlassComponentCard: View {
    let title: String
    let value: String
    let systemImage: String
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: MiSpacingTokens.sm) {
            Image(systemName: systemImage)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(accent)
                .frame(width: 34, height: 34)
                .background {
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .fill(accent.opacity(0.12))
                }

            Spacer(minLength: 0)

            Text(MiL10n.text(title))
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(MiColorTokens.contentPrimary)
                .lineLimit(1)

            Text(MiL10n.text(value))
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(MiColorTokens.contentSecondary)
                .lineLimit(2)
        }
        .padding(MiSpacingTokens.sm)
        .frame(maxWidth: .infinity, minHeight: 128, alignment: .topLeading)
        .background {
            MiAppleLiquidGlassStaticSurface(cornerRadius: 22, accent: accent.opacity(0.08))
        }
    }
}

private struct MiAppleLiquidGlassButtonShowcase: View {
    let accent: Color

    var body: some View {
        MiAppleLiquidGlassSubsection(title: "algc_buttons", systemImage: "button.programmable", accent: accent) {
            VStack(spacing: MiSpacingTokens.sm) {
                HStack(spacing: MiSpacingTokens.sm) {
                    MiAppleLiquidGlassDemoButton(title: "algc_primary", systemImage: "sparkles", variant: .primary, accent: accent)
                    MiAppleLiquidGlassDemoButton(title: "algc_secondary", systemImage: "slider.horizontal.3", variant: .secondary, accent: accent)
                }

                HStack(spacing: MiSpacingTokens.sm) {
                    MiAppleLiquidGlassDemoButton(title: "algc_disabled", systemImage: "lock", variant: .disabled, accent: accent)
                    MiAppleLiquidGlassDemoButton(title: "algc_destructive", systemImage: "trash", variant: .destructive, accent: MiColorTokens.rose500)
                }
            }
        }
    }
}

private enum MiAppleLiquidGlassButtonVariant {
    case primary
    case secondary
    case disabled
    case destructive
}

private struct MiAppleLiquidGlassDemoButton: View {
    let title: String
    let systemImage: String
    let variant: MiAppleLiquidGlassButtonVariant
    let accent: Color

    var body: some View {
        Button {} label: {
            HStack(spacing: 7) {
                Image(systemName: systemImage)
                    .font(.system(size: 12, weight: .semibold))

                Text(MiL10n.text(title))
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)
            }
            .foregroundStyle(foreground)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .modifier(
                MiAppleLiquidGlassButtonChrome(
                    variant: variant,
                    accent: accent,
                    fill: fill,
                    stroke: stroke
                )
            )
        }
        .buttonStyle(MiAppleLiquidGlassPressButtonStyle(isEnabled: variant != .disabled))
        .disabled(variant == .disabled)
    }

    private var fill: Color {
        switch variant {
        case .primary:
            return accent
        case .secondary:
            return Color.white.opacity(0.54)
        case .disabled:
            return Color.white.opacity(0.32)
        case .destructive:
            return accent.opacity(0.20)
        }
    }

    private var foreground: Color {
        switch variant {
        case .primary:
            return MiColorTokens.obsidian950
        case .secondary:
            return MiColorTokens.contentPrimary
        case .disabled:
            return MiColorTokens.contentMuted
        case .destructive:
            return MiColorTokens.rose500
        }
    }

    private var stroke: Color {
        switch variant {
        case .primary:
            return Color.white.opacity(0.72)
        case .secondary:
            return Color.white.opacity(0.74)
        case .disabled:
            return Color.white.opacity(0.48)
        case .destructive:
            return MiColorTokens.rose500.opacity(0.28)
        }
    }
}

private struct MiAppleLiquidGlassButtonChrome: ViewModifier {
    let variant: MiAppleLiquidGlassButtonVariant
    let accent: Color
    let fill: Color
    let stroke: Color

    @ViewBuilder
    func body(content: Content) -> some View {
        let shape = Capsule(style: .continuous)

        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            content
                .glassEffect(
                    .regular
                        .tint(glassTint)
                        .interactive(variant != .disabled),
                    in: shape
                )
                .overlay {
                    MiAppleLiquidGlassButtonSheen(
                        shape: shape,
                        accent: accent,
                        variant: variant
                    )
                    .allowsHitTesting(false)
                }
                .overlay {
                    shape
                        .strokeBorder(buttonStroke, lineWidth: 0.9)
                }
                .opacity(variant == .disabled ? 0.58 : 1)
        } else {
            content
                .background {
                    shape
                        .fill(buttonFallbackFill)
                }
                .overlay {
                    shape
                        .strokeBorder(buttonStroke, lineWidth: 1)
                }
        }
    }

    private var glassTint: Color {
        switch variant {
        case .primary:
            return accent.opacity(0.16)
        case .secondary:
            return accent.opacity(0.060)
        case .disabled:
            return MiColorTokens.contentMuted.opacity(0.040)
        case .destructive:
            return MiColorTokens.rose500.opacity(0.12)
        }
    }

    private var buttonStroke: Color {
        switch variant {
        case .primary:
            return Color.white.opacity(0.74)
        case .secondary:
            return Color.white.opacity(0.68)
        case .disabled:
            return Color.white.opacity(0.40)
        case .destructive:
            return MiColorTokens.rose500.opacity(0.24)
        }
    }

    private var buttonFallbackFill: LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(variant == .primary ? 0.82 : 0.62),
                fill.opacity(variant == .primary ? 0.42 : 0.76),
                Color.white.opacity(0.42)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

private struct MiAppleLiquidGlassButtonSheen<S: InsettableShape>: View {
    let shape: S
    let accent: Color
    let variant: MiAppleLiquidGlassButtonVariant

    var body: some View {
        shape
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(variant == .disabled ? 0.10 : 0.28),
                        accent.opacity(variant == .primary ? 0.12 : 0.04),
                        .clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .opacity(variant == .disabled ? 0.46 : 1)
            .clipShape(shape)
    }
}

private struct MiAppleLiquidGlassInputShowcase: View {
    @Binding var searchText: String
    @Binding var promptText: String
    let accent: Color

    var body: some View {
        MiAppleLiquidGlassSubsection(title: "algc_search_input", systemImage: "magnifyingglass", accent: accent) {
            VStack(spacing: MiSpacingTokens.sm) {
                MiAppleLiquidGlassSearchControl(
                    text: $searchText,
                    placeholder: "algc_search_components",
                    role: .detail,
                    showsResetAction: false,
                    supportText: "alg_real_controls"
                )

                HStack(spacing: MiSpacingTokens.sm) {
                    Image(systemName: "text.cursor")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(accent)

                    TextField(MiL10n.text("algc_prompt_guidance"), text: $promptText)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textFieldStyle(.plain)
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundStyle(MiColorTokens.contentPrimary)
                        .tint(accent)
                }
                .padding(.horizontal, MiSpacingTokens.sm)
                .frame(height: 42)
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white.opacity(0.52))
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.72), lineWidth: 1)
                }
            }
        }
    }
}

private struct MiAppleLiquidGlassTagRail: View {
    let accent: Color

    private let tags = ["alg_shell", "alg_readable", "ds_motion", "algc_a11y"]

    var body: some View {
        MiAppleLiquidGlassSubsection(title: "algc_filter_tags", systemImage: "line.3.horizontal.decrease.circle", accent: accent) {
            HStack(spacing: MiSpacingTokens.xs) {
                ForEach(tags, id: \.self) { tag in
                    Text(MiL10n.text(tag))
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(tag == "alg_shell" ? MiColorTokens.obsidian950 : MiColorTokens.contentSecondary)
                        .lineLimit(1)
                        .padding(.horizontal, MiSpacingTokens.sm)
                        .frame(height: 32)
                        .background {
                            Capsule(style: .continuous)
                                .fill(tag == "alg_shell" ? accent : Color.white.opacity(0.52))
                        }
                        .overlay {
                            Capsule(style: .continuous)
                                .strokeBorder(Color.white.opacity(tag == "alg_shell" ? 0.68 : 0.72), lineWidth: 1)
                        }
                }
            }
        }
    }
}

private struct MiAppleLiquidGlassInspectorSample: View {
    let accent: Color

    var body: some View {
        MiAppleLiquidGlassSubsection(title: "nb_sheet_inspector", systemImage: "sidebar.trailing", accent: accent) {
            VStack(alignment: .leading, spacing: MiSpacingTokens.sm) {
                HStack(spacing: MiSpacingTokens.sm) {
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .fill(MiColorTokens.contentMuted)
                        .frame(width: 38, height: 5)

                    Spacer()

                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(MiColorTokens.contentSecondary)
                        .frame(width: 28, height: 28)
                        .background {
                            Circle()
                                .fill(Color.white.opacity(0.52))
                        }
                }

                Text(MiL10n.text("nb_prompt_inspector"))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiColorTokens.contentPrimary)

                MiAppleLiquidGlassInspectorRow(title: "algc_style", value: "style_alg", accent: accent)
                MiAppleLiquidGlassInspectorRow(title: "slot_surface", value: "ac_nav_search_sheet", accent: MiColorTokens.aqua400)
                MiAppleLiquidGlassInspectorRow(title: "algc_avoid", value: "algc_glass_behind_long", accent: MiColorTokens.rose500)
            }
            .padding(MiSpacingTokens.md)
            .background {
                MiAppleLiquidGlassStaticSurface(cornerRadius: 24, accent: accent.opacity(0.08))
            }
        }
    }
}

private struct MiAppleLiquidGlassInspectorRow: View {
    let title: String
    let value: String
    let accent: Color

    var body: some View {
        HStack(spacing: MiSpacingTokens.sm) {
            Circle()
                .fill(accent)
                .frame(width: 7, height: 7)

            Text(MiL10n.text(title))
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(MiColorTokens.contentSecondary)

            Spacer(minLength: MiSpacingTokens.xs)

            Text(MiL10n.text(value))
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(MiColorTokens.contentPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.72)
        }
    }
}

private struct MiAppleLiquidGlassStateShowcase: View {
    let accent: Color

    private let columns = [GridItem(.adaptive(minimum: 124), spacing: MiSpacingTokens.sm)]

    var body: some View {
        MiAppleLiquidGlassSubsection(title: "algc_feedback_states", systemImage: "checkmark.seal", accent: accent) {
            LazyVGrid(columns: columns, spacing: MiSpacingTokens.sm) {
                MiAppleLiquidGlassSimpleStateTile(
                    titleKey: "algc_empty",
                    captionKey: "algc_no_match",
                    systemImage: "doc.text.magnifyingglass",
                    tint: MiColorTokens.contentMuted
                )

                MiAppleLiquidGlassLoadingStateTile()

                MiAppleLiquidGlassSimpleStateTile(
                    titleKey: "c_selected",
                    captionKey: "c_ready",
                    systemImage: "checkmark.seal.fill",
                    tint: MiColorTokens.lime400
                )

                MiAppleLiquidGlassErrorStateTile(accent: accent)
            }
        }
    }
}

private struct MiAppleLiquidGlassSimpleStateTile: View {
    let titleKey: String
    let captionKey: String
    let systemImage: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: MiSpacingTokens.xs) {
            Image(systemName: systemImage)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(tint)

            Text(MiL10n.text(titleKey))
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(MiColorTokens.contentPrimary)

            Text(MiL10n.text(captionKey))
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(MiColorTokens.contentSecondary)
        }
        .padding(MiSpacingTokens.sm)
        .frame(maxWidth: .infinity, minHeight: 88, alignment: .topLeading)
        .background {
            MiAppleLiquidGlassStaticSurface(cornerRadius: 18, accent: tint.opacity(0.08))
        }
    }
}

/// Loading state as a progressive skeleton reveal (Design.md: skeleton or
/// progressive reveal for cards). Reduce Motion shows a steady skeleton.
private struct MiAppleLiquidGlassLoadingStateTile: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var shimmer = false

    var body: some View {
        VStack(alignment: .leading, spacing: MiSpacingTokens.xs) {
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(MiColorTokens.appleBlue500)

            Text(MiL10n.text("algc_loading"))
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(MiColorTokens.contentPrimary)

            VStack(alignment: .leading, spacing: 5) {
                skeletonBar(width: nil)
                skeletonBar(width: 52)
            }
            .opacity(reduceMotion ? 1 : (shimmer ? 0.45 : 1))
        }
        .padding(MiSpacingTokens.sm)
        .frame(maxWidth: .infinity, minHeight: 88, alignment: .topLeading)
        .background {
            MiAppleLiquidGlassStaticSurface(cornerRadius: 18, accent: MiColorTokens.appleBlue500.opacity(0.08))
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                shimmer = true
            }
        }
    }

    private func skeletonBar(width: CGFloat?) -> some View {
        Capsule(style: .continuous)
            .fill(Color.white.opacity(0.62))
            .frame(width: width, height: 8)
            .overlay {
                Capsule(style: .continuous)
                    .strokeBorder(Color.white.opacity(0.7), lineWidth: 0.6)
            }
    }
}

/// Error state with a glass primary recovery action (Design.md: quiet surface
/// plus a glass primary action). The retry button reuses the glass button chrome.
private struct MiAppleLiquidGlassErrorStateTile: View {
    let accent: Color

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var recovered = false

    var body: some View {
        VStack(alignment: .leading, spacing: MiSpacingTokens.xs) {
            Image(systemName: recovered ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(recovered ? MiColorTokens.lime400 : MiColorTokens.rose500)

            Text(MiL10n.text(recovered ? "algc_recovered" : "algc_error"))
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(MiColorTokens.contentPrimary)

            Text(MiL10n.text(recovered ? "algc_recovered_caption" : "algc_contrast"))
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(MiColorTokens.contentSecondary)

            Button {
                withAnimation(reduceMotion ? .easeOut(duration: 0.01) : .easeOut(duration: 0.22)) {
                    recovered.toggle()
                }
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: recovered ? "checkmark" : "arrow.clockwise")
                        .font(.system(size: 11, weight: .semibold))
                    Text(MiL10n.text(recovered ? "algc_recovered" : "algc_retry"))
                        .font(.system(size: 11.5, weight: .semibold, design: .rounded))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .foregroundStyle(MiColorTokens.obsidian950)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .modifier(
                    MiAppleLiquidGlassButtonChrome(
                        variant: .primary,
                        accent: accent,
                        fill: accent,
                        stroke: Color.white.opacity(0.72)
                    )
                )
            }
            .buttonStyle(MiAppleLiquidGlassPressButtonStyle(isEnabled: true))
            .padding(.top, 2)
        }
        .padding(MiSpacingTokens.sm)
        .frame(maxWidth: .infinity, minHeight: 88, alignment: .topLeading)
        .background {
            MiAppleLiquidGlassStaticSurface(cornerRadius: 18, accent: (recovered ? MiColorTokens.lime400 : MiColorTokens.rose500).opacity(0.08))
        }
    }
}

private struct MiAppleLiquidGlassSubsection<Content: View>: View {
    let title: String
    let systemImage: String
    let accent: Color
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: MiSpacingTokens.sm) {
            HStack(spacing: MiSpacingTokens.xs) {
                Image(systemName: systemImage)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(accent)
                    .frame(width: 24, height: 24)

                Text(MiL10n.text(title))
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiColorTokens.contentPrimary)
            }

            content
        }
        .padding(MiSpacingTokens.sm)
        .background {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(0.50))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(Color.white.opacity(0.70), lineWidth: 1)
        }
    }
}

private struct MiAppleLiquidGlassStaticSurface: View {
    let cornerRadius: CGFloat
    let accent: Color

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.78),
                        MiColorTokens.frost100.opacity(0.58),
                        accent
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.72), lineWidth: 1)
            }
    }
}

#Preview {
    ZStack {
        MiColorTokens.appBackground
            .ignoresSafeArea()

        ScrollView {
            MiAppleLiquidGlassComponentShowcaseView(accent: MiColorTokens.appleBlue500)
                .padding()
        }
    }
}
