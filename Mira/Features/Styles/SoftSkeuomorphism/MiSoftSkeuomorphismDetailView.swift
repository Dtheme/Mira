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
                MiSoftSkeuomorphismLoadingCard(tint: MiSoftSkeuomorphismTokens.butter)
                MiSoftSkeuomorphismErrorCard(tint: MiSoftSkeuomorphismTokens.coral)
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


#Preview {
    MiSoftSkeuomorphismDetailView(style: MiStyleRepository.styles[0])
}
