//
//  MiSoftSkeuomorphismDetailView.swift
//  Mira
//
//  Created on 2026/5/29.
//

import SwiftUI

struct MiSoftSkeuomorphismDetailView: View {
    let style: MiDesignStyle
    let onBack: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isBlooming = true
    @State private var selectedPace = 1

    init(style: MiDesignStyle, onBack: (() -> Void)? = nil) {
        self.style = style
        self.onBack = onBack
    }

    var body: some View {
        ZStack(alignment: .top) {
            MiSoftSkeuomorphismTokens.pageBackground
                .ignoresSafeArea()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: MiSoftSkeuomorphismTokens.sectionSpacing) {
                    hero
                    controlPanel
                    styleCard
                    components
                    states
                    tokensAndPrompt
                }
                .padding(.horizontal, 22)
                .padding(.top, 88)
                .padding(.bottom, 50)
                .frame(maxWidth: 780, alignment: .leading)
                .frame(maxWidth: .infinity)
            }
            .scrollIndicators(.hidden)

            MiSoftSkeuomorphismTopBar(style: style) {
                close()
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .zIndex(20)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .animation(reduceMotion ? .easeOut(duration: 0.01) : .spring(response: 0.30, dampingFraction: 0.82), value: isBlooming)
        .animation(reduceMotion ? .easeOut(duration: 0.01) : .easeInOut(duration: 0.18), value: selectedPace)
    }

    private var hero: some View {
        MiSoftSkeuomorphismPanel(radius: 38, padding: 22) {
            VStack(alignment: .leading, spacing: 20) {
                MiSoftSkeuomorphismCapsule(titleKey: "softsk_badge", fill: MiSoftSkeuomorphismTokens.moss.opacity(0.20))

                VStack(alignment: .leading, spacing: 8) {
                    Text(MiL10n.text(style.name))
                        .font(.system(size: 42, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                        .lineLimit(2)
                        .minimumScaleFactor(0.72)
                        .miStyleTitleTransition(style.id)

                    Text(MiL10n.text("softsk_hero_body"))
                        .font(.system(size: 15.5, weight: .medium, design: .rounded))
                        .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }

                MiSoftSkeuomorphismSignature(isBlooming: $isBlooming)
            }
        }
    }

    private var controlPanel: some View {
        MiSoftSkeuomorphismSection(titleKey: "softsk_control_panel", bodyKey: "softsk_control_body") {
            MiSoftSkeuomorphismPanel {
                VStack(alignment: .leading, spacing: 18) {
                    HStack(spacing: 10) {
                        Circle()
                            .stroke(MiSoftSkeuomorphismTokens.teal, lineWidth: 2)
                            .frame(width: 18, height: 18)
                        Text(MiL10n.text("softsk_energy"))
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                        Spacer()
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(MiSoftSkeuomorphismTokens.mossDeep)
                    }

                    HStack(alignment: .center, spacing: 20) {
                        MiSoftSkeuomorphismGauge(
                            progress: isBlooming ? 0.74 : 0.48,
                            titleKey: isBlooming ? "softsk_value_bloom" : "softsk_value_rest",
                            captionKey: "softsk_balanced",
                            tint: MiSoftSkeuomorphismTokens.teal
                        )

                        MiSoftSkeuomorphismScoreRing(isBlooming: isBlooming)
                    }

                    MiSoftSkeuomorphismNotificationPanel(isBlooming: isBlooming)
                }
            }
        }
    }

    private var styleCard: some View {
        MiSoftSkeuomorphismSection(titleKey: "softsk_style_card", bodyKey: "softsk_style_card_body") {
            MiSoftSkeuomorphismHomePreview(
                style: style,
                focus: MiCardFocus(scale: 1, opacity: 1, shadowOpacity: 0.30, borderOpacity: 0.48, zIndex: 1),
                cardSize: CGSize(width: 190, height: 236),
                cornerRadius: 32,
                isDragging: false
            )
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    private var components: some View {
        MiSoftSkeuomorphismSection(titleKey: "softsk_components", bodyKey: "softsk_components_body") {
            MiSoftSkeuomorphismPanel {
                VStack(alignment: .leading, spacing: 18) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        MiSoftSkeuomorphismButton(titleKey: "softsk_primary", systemImage: "lightbulb.fill", role: .primary)
                        MiSoftSkeuomorphismButton(titleKey: "softsk_secondary", systemImage: "moon.fill", role: .secondary)
                        MiSoftSkeuomorphismButton(titleKey: "softsk_disabled", systemImage: "lock.fill", role: .disabled)
                    }

                    MiSoftSkeuomorphismInsetField()

                    VStack(alignment: .leading, spacing: 10) {
                        Text(MiL10n.text("softsk_metric_pace").uppercased())
                            .font(.system(size: 10.5, weight: .black, design: .rounded))
                            .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                            .tracking(0.6)

                        HStack(spacing: 8) {
                            ForEach(Array(paceOptions.enumerated()), id: \.offset) { index, key in
                                Button {
                                    selectedPace = index
                                } label: {
                                    Text(MiL10n.text(key))
                                        .font(.system(size: 12, weight: .black, design: .rounded))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 42)
                                }
                                .buttonStyle(MiSoftSkeuomorphismSegmentStyle(isSelected: selectedPace == index))
                            }
                        }
                    }

                    HStack(spacing: 8) {
                        MiSoftSkeuomorphismCapsule(titleKey: "softsk_filter_rest", fill: MiSoftSkeuomorphismTokens.moss.opacity(0.20))
                        MiSoftSkeuomorphismCapsule(titleKey: "softsk_filter_sleep", fill: MiSoftSkeuomorphismTokens.teal.opacity(0.18))
                        MiSoftSkeuomorphismCapsule(titleKey: "softsk_filter_focus", fill: MiSoftSkeuomorphismTokens.butter.opacity(0.34))
                    }
                }
            }
        }
    }

    private var states: some View {
        MiSoftSkeuomorphismSection(titleKey: "softsk_states", bodyKey: "softsk_states_body") {
            LazyVGrid(columns: columns, spacing: 12) {
                MiSoftSkeuomorphismStateCard(titleKey: "softsk_empty", bodyKey: "softsk_empty_body", systemImage: "tray", tint: MiSoftSkeuomorphismTokens.moss)
                MiSoftSkeuomorphismStateCard(titleKey: "softsk_loading", bodyKey: "softsk_loading_body", systemImage: "rays", tint: MiSoftSkeuomorphismTokens.butter)
                MiSoftSkeuomorphismStateCard(titleKey: "softsk_error", bodyKey: "softsk_error_body", systemImage: "exclamationmark.triangle", tint: MiSoftSkeuomorphismTokens.coral)
                MiSoftSkeuomorphismStateCard(titleKey: "softsk_selected", bodyKey: "softsk_selected_body", systemImage: "checkmark.circle", tint: MiSoftSkeuomorphismTokens.teal)
                MiSoftSkeuomorphismStateCard(titleKey: "softsk_disabled_state", bodyKey: "softsk_disabled_body", systemImage: "lock", tint: MiSoftSkeuomorphismTokens.shadow)
            }
        }
    }

    private var tokensAndPrompt: some View {
        MiSoftSkeuomorphismSection(titleKey: "softsk_tokens_prompt", bodyKey: "softsk_tokens_body") {
            VStack(alignment: .leading, spacing: 14) {
                LazyVGrid(columns: columns, spacing: 12) {
                    MiSoftSkeuomorphismTokenSwatch(title: "mi-softsk-cream", value: "#F8EAD8", roleKey: "softsk_token_cream", color: MiSoftSkeuomorphismTokens.cream)
                    MiSoftSkeuomorphismTokenSwatch(title: "mi-softsk-surface", value: "#FFF7EA", roleKey: "softsk_token_surface", color: MiSoftSkeuomorphismTokens.creamLight)
                    MiSoftSkeuomorphismTokenSwatch(title: "mi-softsk-moss", value: "#88A58E", roleKey: "softsk_token_moss", color: MiSoftSkeuomorphismTokens.moss)
                    MiSoftSkeuomorphismTokenSwatch(title: "mi-softsk-teal", value: "#6EAFA7", roleKey: "softsk_token_teal", color: MiSoftSkeuomorphismTokens.teal)
                    MiSoftSkeuomorphismTokenSwatch(title: "mi-softsk-peach", value: "#F6B08A", roleKey: "softsk_token_peach", color: MiSoftSkeuomorphismTokens.peach)
                    MiSoftSkeuomorphismTokenSwatch(title: "mi-softsk-butter", value: "#F5D38B", roleKey: "softsk_token_butter", color: MiSoftSkeuomorphismTokens.butter)
                }

                MiSoftSkeuomorphismPanel {
                    VStack(alignment: .leading, spacing: 12) {
                        Label(MiL10n.text("softsk_prompt_line"), systemImage: "text.bubble.fill")
                            .font(.system(size: 14, weight: .black, design: .rounded))
                            .foregroundStyle(MiSoftSkeuomorphismTokens.ink)

                        MiSoftSkeuomorphismBullet("softsk_prompt_1")
                        MiSoftSkeuomorphismBullet("softsk_prompt_2")
                        MiSoftSkeuomorphismBullet("softsk_prompt_3")
                    }
                }
            }
        }
    }

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 154), spacing: 12)]
    }

    private var paceOptions: [String] {
        ["softsk_pace_slow", "softsk_pace_calm", "softsk_pace_deep"]
    }

    private func close() {
        if let onBack {
            onBack()
        } else {
            dismiss()
        }
    }
}

private struct MiSoftSkeuomorphismTopBar: View {
    let style: MiDesignStyle
    let onBack: () -> Void

    var body: some View {
        MiSoftSkeuomorphismPanel(radius: 24, padding: 5) {
            HStack(spacing: 10) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 15, weight: .bold))
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(MiSoftSkeuomorphismTopButtonStyle())
                .accessibilityLabel(MiL10n.text("c_back"))

                VStack(alignment: .leading, spacing: 1) {
                    Text(MiL10n.text(style.name))
                        .font(.system(size: 13.5, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                        .lineLimit(1)
                    Text(MiL10n.text(style.localizedName))
                        .font(.system(size: 11.5, weight: .medium, design: .rounded))
                        .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                        .lineLimit(1)
                }

                Spacer(minLength: 0)

                MiSoftSkeuomorphismCapsule(titleKey: "c_ready", fill: MiSoftSkeuomorphismTokens.moss.opacity(0.20))
            }
        }
        .frame(maxWidth: 780)
    }
}

private struct MiSoftSkeuomorphismPanel<Content: View>: View {
    let radius: CGFloat
    let padding: CGFloat
    let content: Content

    init(radius: CGFloat = MiSoftSkeuomorphismTokens.cardRadius, padding: CGFloat = 18, @ViewBuilder content: () -> Content) {
        self.radius = radius
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)

        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                shape
                    .fill(
                        LinearGradient(
                            colors: [
                                MiSoftSkeuomorphismTokens.creamLight,
                                MiSoftSkeuomorphismTokens.card,
                                MiSoftSkeuomorphismTokens.moss.opacity(0.07)
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
                                        MiSoftSkeuomorphismTokens.highlight.opacity(0.84),
                                        MiSoftSkeuomorphismTokens.moss.opacity(0.16),
                                        MiSoftSkeuomorphismTokens.shadow.opacity(0.15)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    }
            }
            .shadow(color: MiSoftSkeuomorphismTokens.highlight.opacity(0.64), radius: 12, x: -6, y: -6)
            .shadow(color: MiSoftSkeuomorphismTokens.shadow.opacity(0.28), radius: 20, x: 0, y: 12)
    }
}

private struct MiSoftSkeuomorphismSection<Content: View>: View {
    let titleKey: String
    let bodyKey: String
    let content: Content

    init(titleKey: String, bodyKey: String, @ViewBuilder content: () -> Content) {
        self.titleKey = titleKey
        self.bodyKey = bodyKey
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(MiL10n.text(titleKey))
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 13.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }

            content
        }
    }
}

private struct MiSoftSkeuomorphismSignature: View {
    @Binding var isBlooming: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        MiSoftSkeuomorphismPanel(radius: 34, padding: 18) {
            HStack(alignment: .center, spacing: 18) {
                Button {
                    if reduceMotion {
                        isBlooming.toggle()
                    } else {
                        withAnimation(.spring(response: 0.30, dampingFraction: 0.74)) {
                            isBlooming.toggle()
                        }
                    }
                } label: {
                    VStack(spacing: 10) {
                        MiSoftSkeuomorphismLampObject(isBlooming: isBlooming, scale: 1.0)
                            .frame(width: 168, height: 142)

                        Text(MiL10n.text("softsk_bloom_action"))
                            .font(.system(size: 13, weight: .black, design: .rounded))
                            .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                            .padding(.horizontal, 18)
                            .frame(height: 42)
                            .background {
                                Capsule(style: .continuous)
                                    .fill(MiSoftSkeuomorphismTokens.creamLight)
                                    .shadow(color: MiSoftSkeuomorphismTokens.shadow.opacity(isBlooming ? 0.22 : 0.32), radius: isBlooming ? 8 : 13, x: 0, y: isBlooming ? 5 : 9)
                            }
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(MiL10n.text("softsk_bloom_action"))
                .accessibilityValue(MiL10n.text(isBlooming ? "softsk_bloom_on" : "softsk_bloom_idle"))

                VStack(alignment: .leading, spacing: 10) {
                    Label(MiL10n.text("softsk_signature"), systemImage: "lightbulb.max.fill")
                        .font(.system(size: 14, weight: .black, design: .rounded))
                        .foregroundStyle(MiSoftSkeuomorphismTokens.ink)

                    Text(MiL10n.text("softsk_signature_body"))
                        .font(.system(size: 12.5, weight: .medium, design: .rounded))
                        .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)

                    MiSoftSkeuomorphismMetricRow(labelKey: "softsk_metric_brightness", valueKey: isBlooming ? "softsk_value_bloom" : "softsk_value_rest", fill: isBlooming ? MiSoftSkeuomorphismTokens.butter.opacity(0.50) : MiSoftSkeuomorphismTokens.cardDeep.opacity(0.50))
                    MiSoftSkeuomorphismMetricRow(labelKey: "softsk_metric_warmth", valueKey: isBlooming ? "softsk_value_warm" : "softsk_value_low", fill: MiSoftSkeuomorphismTokens.peach.opacity(isBlooming ? 0.34 : 0.18))
                    MiSoftSkeuomorphismMetricRow(labelKey: "softsk_metric_pace", valueKey: isBlooming ? "softsk_value_4s" : "softsk_value_6s", fill: MiSoftSkeuomorphismTokens.moss.opacity(0.20))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

private struct MiSoftSkeuomorphismGauge: View {
    let progress: Double
    let titleKey: String
    let captionKey: String
    let tint: Color

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(MiSoftSkeuomorphismTokens.cardDeep.opacity(0.55), lineWidth: 12)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(
                            colors: [MiSoftSkeuomorphismTokens.peach, MiSoftSkeuomorphismTokens.butter, tint],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                Text(MiL10n.text(titleKey))
                    .font(.system(size: 21, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                    .minimumScaleFactor(0.70)
            }
            .frame(width: 112, height: 112)

            Text(MiL10n.text(captionKey))
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct MiSoftSkeuomorphismScoreRing: View {
    let isBlooming: Bool

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(MiSoftSkeuomorphismTokens.cardDeep.opacity(0.55), lineWidth: 12)
                Circle()
                    .trim(from: 0, to: isBlooming ? 0.78 : 0.62)
                    .stroke(MiSoftSkeuomorphismTokens.moss, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 0) {
                    Text(isBlooming ? "7.8" : "6.4")
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                    Text(MiL10n.text("softsk_days"))
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                }
            }
            .frame(width: 112, height: 112)

            Text(MiL10n.text("softsk_sleep_score"))
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct MiSoftSkeuomorphismNotificationPanel: View {
    let isBlooming: Bool

    var body: some View {
        MiSoftSkeuomorphismPanel(radius: 28, padding: 16) {
            VStack(spacing: 12) {
                Text(MiL10n.text("softsk_notification"))
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(MiL10n.text(isBlooming ? "softsk_bloom_on" : "softsk_bloom_idle"))
                    .font(.system(size: 15, weight: .black, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                    .padding(.horizontal, 20)
                    .frame(height: 44)
                    .background {
                        Capsule(style: .continuous)
                            .fill(MiSoftSkeuomorphismTokens.creamLight)
                            .shadow(color: MiSoftSkeuomorphismTokens.shadow.opacity(0.22), radius: 12, x: 0, y: 8)
                    }

                Text(MiL10n.text("softsk_notification_body"))
                    .font(.system(size: 12.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

private struct MiSoftSkeuomorphismButton: View {
    let titleKey: String
    let systemImage: String
    let role: MiSoftSkeuomorphismButtonRole

    var body: some View {
        Button {} label: {
            Label(MiL10n.text(titleKey), systemImage: systemImage)
                .font(.system(size: 13.5, weight: .black, design: .rounded))
                .frame(maxWidth: .infinity)
                .frame(minHeight: 48)
        }
        .buttonStyle(MiSoftSkeuomorphismButtonStyle(role: role))
        .disabled(role == .disabled)
    }
}

private enum MiSoftSkeuomorphismButtonRole {
    case primary
    case secondary
    case disabled
}

private struct MiSoftSkeuomorphismButtonStyle: ButtonStyle {
    let role: MiSoftSkeuomorphismButtonRole

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(role == .primary ? MiSoftSkeuomorphismTokens.ink : MiSoftSkeuomorphismTokens.mossDeep.opacity(role == .disabled ? 0.48 : 1))
            .padding(.horizontal, 14)
            .background {
                Capsule(style: .continuous)
                    .fill(background.opacity(configuration.isPressed ? 0.86 : 1))
                    .overlay {
                        Capsule(style: .continuous)
                            .strokeBorder(MiSoftSkeuomorphismTokens.highlight.opacity(0.62), lineWidth: 1)
                    }
            }
            .shadow(color: MiSoftSkeuomorphismTokens.shadow.opacity(role == .disabled ? 0.08 : 0.24), radius: configuration.isPressed ? 5 : 12, x: 0, y: configuration.isPressed ? 3 : 8)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.20, dampingFraction: 0.82), value: configuration.isPressed)
    }

    private var background: Color {
        switch role {
        case .primary:
            return MiSoftSkeuomorphismTokens.butter.opacity(0.76)
        case .secondary:
            return MiSoftSkeuomorphismTokens.creamLight
        case .disabled:
            return MiSoftSkeuomorphismTokens.cardDeep.opacity(0.42)
        }
    }
}

private struct MiSoftSkeuomorphismTopButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
            .background {
                Circle()
                    .fill(MiSoftSkeuomorphismTokens.creamLight)
                    .shadow(color: MiSoftSkeuomorphismTokens.shadow.opacity(configuration.isPressed ? 0.12 : 0.22), radius: configuration.isPressed ? 4 : 9, x: 0, y: configuration.isPressed ? 2 : 6)
            }
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
    }
}

private struct MiSoftSkeuomorphismSegmentStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isSelected ? MiSoftSkeuomorphismTokens.ink : MiSoftSkeuomorphismTokens.muted)
            .background {
                Capsule(style: .continuous)
                    .fill(isSelected ? MiSoftSkeuomorphismTokens.moss.opacity(0.26) : MiSoftSkeuomorphismTokens.creamLight.opacity(0.78))
                    .overlay {
                        Capsule(style: .continuous)
                            .strokeBorder(isSelected ? MiSoftSkeuomorphismTokens.moss.opacity(0.46) : MiSoftSkeuomorphismTokens.highlight.opacity(0.58), lineWidth: 1)
                    }
            }
            .opacity(configuration.isPressed ? 0.78 : 1)
    }
}

private struct MiSoftSkeuomorphismInsetField: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(MiL10n.text("softsk_input_label").uppercased())
                .font(.system(size: 10.5, weight: .black, design: .rounded))
                .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                .tracking(0.6)

            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.mossDeep)
                Text(MiL10n.text("softsk_input_placeholder"))
                    .font(.system(size: 13.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                Spacer()
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.shadow)
            }
            .padding(.horizontal, 14)
            .frame(height: 48)
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(MiSoftSkeuomorphismTokens.card.opacity(0.86))
                    .shadow(color: MiSoftSkeuomorphismTokens.shadow.opacity(0.20), radius: 8, x: 3, y: 5)
                    .shadow(color: MiSoftSkeuomorphismTokens.highlight.opacity(0.70), radius: 6, x: -3, y: -3)
            }
        }
    }
}

private struct MiSoftSkeuomorphismCapsule: View {
    let titleKey: String
    let fill: Color

    var body: some View {
        Text(MiL10n.text(titleKey))
            .font(.system(size: 11.5, weight: .black, design: .rounded))
            .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
            .padding(.horizontal, 12)
            .frame(height: 34)
            .background {
                Capsule(style: .continuous)
                    .fill(fill)
                    .overlay {
                        Capsule(style: .continuous)
                            .strokeBorder(MiSoftSkeuomorphismTokens.highlight.opacity(0.62), lineWidth: 1)
                    }
            }
    }
}

private struct MiSoftSkeuomorphismMetricRow: View {
    let labelKey: String
    let valueKey: String
    let fill: Color

    var body: some View {
        HStack(spacing: 10) {
            Text(MiL10n.text(labelKey).uppercased())
                .font(.system(size: 10.5, weight: .black, design: .rounded))
                .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                .tracking(0.6)

            Spacer(minLength: 8)

            Text(MiL10n.text(valueKey))
                .font(.system(size: 12, weight: .black, design: .rounded))
                .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                .padding(.horizontal, 10)
                .frame(height: 28)
                .background {
                    Capsule(style: .continuous)
                        .fill(fill)
                        .overlay {
                            Capsule(style: .continuous)
                                .strokeBorder(MiSoftSkeuomorphismTokens.highlight.opacity(0.58), lineWidth: 1)
                        }
                }
        }
    }
}

private struct MiSoftSkeuomorphismStateCard: View {
    let titleKey: String
    let bodyKey: String
    let systemImage: String
    let tint: Color

    var body: some View {
        MiSoftSkeuomorphismPanel(radius: 24, padding: 14) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: systemImage)
                    .font(.system(size: 18, weight: .black))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                    .frame(width: 36, height: 36)
                    .background {
                        Circle()
                            .fill(tint.opacity(0.26))
                    }
                Text(MiL10n.text(titleKey))
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(minHeight: 152)
    }
}

private struct MiSoftSkeuomorphismTokenSwatch: View {
    let title: String
    let value: String
    let roleKey: String
    let color: Color

    var body: some View {
        MiSoftSkeuomorphismPanel(radius: 22, padding: 12) {
            VStack(alignment: .leading, spacing: 10) {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(color)
                    .frame(height: 42)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(MiSoftSkeuomorphismTokens.highlight.opacity(0.72), lineWidth: 1)
                    }
                Text(title)
                    .font(.system(size: 12, weight: .black, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                    .lineLimit(1)
                Text(value)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.mossDeep)
                Text(MiL10n.text(roleKey))
                    .font(.system(size: 11.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(minHeight: 158)
    }
}

private struct MiSoftSkeuomorphismBullet: View {
    let key: String

    init(_ key: String) {
        self.key = key
    }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(MiSoftSkeuomorphismTokens.moss)
                .frame(width: 7, height: 7)
                .padding(.top, 7)
            Text(MiL10n.text(key))
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    MiSoftSkeuomorphismDetailView(style: MiStyleRepository.styles[0])
}
