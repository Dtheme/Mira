//
//  MiNeumorphismShowcaseViews.swift
//  Mira
//
//  Created on 2026/5/23.
//

import SwiftUI

struct MiNeumorphismButtonShowcase: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(MiL10n.text("neu_button_states"))
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(MiNeumorphismTokens.ink)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 138), spacing: 12)], spacing: 12) {
                Button(MiL10n.text("neu_primary")) {}
                    .buttonStyle(MiNeumorphismButtonStyle(role: .primary))

                Button(MiL10n.text("neu_secondary")) {}
                    .buttonStyle(MiNeumorphismButtonStyle(role: .secondary))

                Button(MiL10n.text("neu_destructive")) {}
                    .buttonStyle(MiNeumorphismButtonStyle(role: .destructive))

                Button(MiL10n.text("neu_disabled_action")) {}
                    .buttonStyle(MiNeumorphismButtonStyle(role: .secondary))
                    .disabled(true)
            }
        }
    }
}

struct MiNeumorphismTagRail: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(MiL10n.text("neu_tag_rail"))
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(MiNeumorphismTokens.ink)

            ViewThatFits(in: .horizontal) {
                HStack(spacing: 10) {
                    tags
                }

                VStack(alignment: .leading, spacing: 10) {
                    tags
                }
            }
        }
    }

    @ViewBuilder
    private var tags: some View {
        MiNeumorphismPill(titleKey: "neu_tag_surface", isSelected: true)
        MiNeumorphismPill(titleKey: "neu_tag_focus", isSelected: false)
        MiNeumorphismPill(titleKey: "neu_tag_disabled", isSelected: false, isDisabled: true)
    }
}

struct MiNeumorphismInputStateGallery: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(MiL10n.text("neu_input_states"))
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(MiNeumorphismTokens.ink)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 154), spacing: 12)], spacing: 12) {
                MiNeumorphismInputStateTile(
                    titleKey: "neu_input_default",
                    valueKey: "neu_resting",
                    depth: .raised
                )

                MiNeumorphismInputStateTile(
                    titleKey: "neu_input_focused",
                    valueKey: "neu_focused",
                    depth: .inset,
                    accent: MiNeumorphismTokens.focusAccent
                )

                MiNeumorphismInputStateTile(
                    titleKey: "neu_input_filled",
                    valueKey: "neu_filled",
                    depth: .raised,
                    accent: MiNeumorphismTokens.accentDeep
                )

                MiNeumorphismInputStateTile(
                    titleKey: "neu_input_error",
                    valueKey: "neu_error",
                    depth: .pressed,
                    accent: MiNeumorphismTokens.error
                )
            }
        }
    }
}

private struct MiNeumorphismInputStateTile: View {
    let titleKey: String
    let valueKey: String
    let depth: MiNeumorphismSurfaceDepth
    var accent: Color = MiNeumorphismTokens.muted

    var body: some View {
        MiNeumorphismSoftSurface(
            cornerRadius: 20,
            depth: depth,
            fill: depth == .pressed ? MiNeumorphismTokens.basePressed : MiNeumorphismTokens.base,
            contentPadding: 14
        ) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Circle()
                        .fill(accent.opacity(0.64))
                        .frame(width: 10, height: 10)

                    Text(MiL10n.text(titleKey))
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.76)
                }

                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .fill(accent.opacity(0.18))
                    .frame(height: 9)

                Text(MiL10n.text(valueKey))
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(accent)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minHeight: 118)
    }
}

struct MiNeumorphismShadowTokenGallery: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(MiL10n.text("neu_shadow_tokens"))
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(MiNeumorphismTokens.ink)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 126), spacing: 12)], spacing: 12) {
                MiNeumorphismShadowTokenTile(titleKey: "neu_shadow_small", depth: .raised, size: 34)
                MiNeumorphismShadowTokenTile(titleKey: "neu_shadow_inset", depth: .inset, size: 34)
                MiNeumorphismShadowTokenTile(titleKey: "neu_shadow_pressed", depth: .pressed, size: 34)
            }
        }
    }
}

private struct MiNeumorphismShadowTokenTile: View {
    let titleKey: String
    let depth: MiNeumorphismSurfaceDepth
    let size: CGFloat

    var body: some View {
        MiNeumorphismSoftSurface(
            cornerRadius: 20,
            depth: depth,
            fill: depth == .pressed ? MiNeumorphismTokens.basePressed : MiNeumorphismTokens.base,
            contentPadding: 14
        ) {
            HStack(spacing: 12) {
                MiNeumorphismSoftSurface(cornerRadius: 14, depth: depth, contentPadding: 0) {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(MiNeumorphismTokens.focusAccent.opacity(0.34))
                        .frame(width: size, height: size)
                }
                .frame(width: 48, height: 48)

                Text(MiL10n.text(titleKey))
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiNeumorphismTokens.ink)
                    .lineLimit(2)
                    .minimumScaleFactor(0.80)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct MiNeumorphismMotionSamplePanel: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isPressed = false

    var body: some View {
        MiNeumorphismSoftSurface(cornerRadius: 24, contentPadding: 16) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(MiL10n.text("neu_motion_sample"))
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundStyle(MiNeumorphismTokens.ink)

                        Text(MiL10n.text("neu_press_motion_body"))
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(MiNeumorphismTokens.muted)
                            .lineSpacing(2)
                    }

                    Spacer(minLength: 0)

                    Text(reduceMotion ? MiL10n.text("neu_reduced") : MiL10n.text("neu_spring"))
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.accentDeep)
                        .padding(.horizontal, 10)
                        .frame(height: 30)
                        .background {
                            Capsule(style: .continuous)
                                .fill(MiNeumorphismTokens.focusAccent.opacity(0.16))
                        }
                }

                Button {
                    isPressed.toggle()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: isPressed ? "checkmark" : "hand.tap")
                            .font(.system(size: 15, weight: .bold))

                        Text(MiL10n.text("neu_press_motion"))
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(MiNeumorphismButtonStyle(role: isPressed ? .primary : .secondary))
                .animation(reduceMotion ? nil : .spring(response: 0.20, dampingFraction: 0.78), value: isPressed)
            }
        }
    }
}
