//
//  MiNeumorphismControls.swift
//  Mira
//
//  Created on 2026/5/23.
//

import SwiftUI

struct MiNeumorphismToggleControl: View {
    @Binding var isOn: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Button {
            withAnimation(reduceMotion ? .easeOut(duration: 0.01) : .spring(response: 0.22, dampingFraction: 0.80)) {
                isOn.toggle()
            }
        } label: {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(MiL10n.text("neu_toggle_depth"))
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.ink)

                    Text(MiL10n.text(isOn ? "c_on" : "c_off"))
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(isOn ? MiNeumorphismTokens.accentDeep : MiNeumorphismTokens.quietText)
                }

                Spacer(minLength: 0)

                MiNeumorphismToggleSwitch(isOn: isOn)
            }
            .padding(.leading, 2)
        }
        .buttonStyle(.plain)
        .padding(14)
        .background {
            MiNeumorphismSoftSurface(
                cornerRadius: 24,
                depth: isOn ? .raised : .pressed,
                fill: isOn ? MiNeumorphismTokens.base : MiNeumorphismTokens.basePressed,
                contentPadding: 0
            ) {
                EmptyView()
            }
        }
        .accessibilityLabel(MiL10n.text("neu_toggle_depth"))
        .accessibilityValue(MiL10n.text(isOn ? "c_on" : "c_off"))
    }
}

private struct MiNeumorphismToggleSwitch: View {
    let isOn: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            Capsule(style: .continuous)
                .fill(trackFill)
                .frame(width: 68, height: 38)
                .modifier(MiNeumorphismToggleOuterShadow(isOn: isOn))
                .overlay {
                    MiNeumorphismInsetOverlay(cornerRadius: 19)
                        .opacity(isOn ? 0.38 : 0.46)
                }
                .overlay {
                    Capsule(style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(isOn ? 0.74 : 0.42),
                                    MiNeumorphismTokens.focusAccent.opacity(isOn ? 0.46 : 0.08),
                                    MiNeumorphismTokens.shadowDark.opacity(0.20)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: isOn ? 1.1 : 0.8
                        )
                }

            MiNeumorphismToggleKnob(isOn: isOn)
                .offset(x: isOn ? 31 : 3)
        }
        .frame(width: 68, height: 38)
    }

    private var trackFill: LinearGradient {
        LinearGradient(
            colors: isOn
                ? [MiNeumorphismTokens.focusSoft, MiNeumorphismTokens.focusAccent.opacity(0.56)]
                : [MiNeumorphismTokens.basePressed, MiNeumorphismTokens.baseInset],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

private struct MiNeumorphismToggleKnob: View {
    let isOn: Bool

    var body: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [
                        MiNeumorphismTokens.baseLight,
                        isOn ? MiNeumorphismTokens.base : MiNeumorphismTokens.basePressed
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 34, height: 34)
            .overlay {
                Circle()
                    .strokeBorder(Color.white.opacity(isOn ? 0.70 : 0.46), lineWidth: 0.8)
            }
            .overlay {
                Circle()
                    .fill(isOn ? MiNeumorphismTokens.accentDeep.opacity(0.12) : Color.clear)
                    .padding(8)
            }
            .shadow(color: MiNeumorphismTokens.shadowDark.opacity(isOn ? 0.48 : 0.38), radius: 6, x: 4, y: 4)
            .shadow(color: MiNeumorphismTokens.shadowLight.opacity(0.96), radius: 6, x: -4, y: -4)
    }
}

private struct MiNeumorphismToggleOuterShadow: ViewModifier {
    let isOn: Bool

    func body(content: Content) -> some View {
        content
            .shadow(color: MiNeumorphismTokens.shadowDark.opacity(isOn ? 0.32 : 0.22), radius: 8, x: 5, y: 5)
            .shadow(color: MiNeumorphismTokens.shadowLight.opacity(isOn ? 0.88 : 0.64), radius: 8, x: -5, y: -5)
    }
}

struct MiNeumorphismSegmentedControl: View {
    @Binding var selectedIndex: Int
    let itemKeys: [String]

    var body: some View {
        MiNeumorphismSoftSurface(cornerRadius: 22, depth: .inset, contentPadding: 4) {
            HStack(spacing: 6) {
                ForEach(itemKeys.indices, id: \.self) { index in
                    Button {
                        selectedIndex = index
                    } label: {
                        Text(MiL10n.text(itemKeys[index]))
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(index == selectedIndex ? MiNeumorphismTokens.ink : MiNeumorphismTokens.muted)
                            .lineLimit(1)
                            .minimumScaleFactor(0.72)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .overlay(alignment: .bottom) {
                                Capsule(style: .continuous)
                                    .fill(index == selectedIndex ? MiNeumorphismTokens.focusAccent.opacity(0.72) : Color.clear)
                                    .frame(width: 22, height: 3)
                                    .offset(y: -5)
                            }
                    }
                    .buttonStyle(.plain)
                    .background {
                        if index == selectedIndex {
                            MiNeumorphismSoftSurface(
                                cornerRadius: 18,
                                depth: .raised,
                                fill: MiNeumorphismTokens.baseLight,
                                contentPadding: 0
                            ) {
                                EmptyView()
                            }
                            .overlay {
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .strokeBorder(MiNeumorphismTokens.focusAccent.opacity(0.28), lineWidth: 1)
                            }
                        }
                    }
                    .accessibilityValue(MiL10n.text(index == selectedIndex ? "c_selected" : "c_not_selected"))
                }
            }
        }
    }
}

struct MiNeumorphismInputField: View {
    @Binding var text: String
    @FocusState.Binding var isFocused: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(isFocused ? MiNeumorphismTokens.accentDeep : MiNeumorphismTokens.muted)

            TextField(MiL10n.text("neu_search_placeholder"), text: $text)
                .focused($isFocused)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(MiNeumorphismTokens.ink)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(MiNeumorphismTokens.muted.opacity(0.72))
                        .frame(width: 32, height: 32)
                        .background {
                            Circle()
                                .fill(MiNeumorphismTokens.basePressed.opacity(0.86))
                                .shadow(color: MiNeumorphismTokens.shadowLight.opacity(0.70), radius: 3, x: -1.5, y: -1.5)
                                .shadow(color: MiNeumorphismTokens.shadowDark.opacity(0.22), radius: 3, x: 1.5, y: 1.5)
                        }
                }
                .buttonStyle(.plain)
                .accessibilityLabel(MiL10n.text("neu_clear"))
            }
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 56)
        .background {
            MiNeumorphismSoftSurface(
                cornerRadius: 18,
                depth: isFocused ? .inset : .raised,
                fill: isFocused ? MiNeumorphismTokens.baseInset : MiNeumorphismTokens.base,
                contentPadding: 0
            ) {
                EmptyView()
            }
        }
        .overlay {
            if isFocused {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.58),
                                MiNeumorphismTokens.focusAccent.opacity(0.30),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.9
                    )
                    .blendMode(.screen)
            }
        }
        .animation(.easeOut(duration: 0.16), value: isFocused)
    }
}

struct MiNeumorphismStateBadge: View {
    let titleKey: String
    let depth: MiNeumorphismSurfaceDepth

    var body: some View {
        MiNeumorphismSoftSurface(
            cornerRadius: 18,
            depth: depth,
            fill: depth == .pressed ? MiNeumorphismTokens.basePressed : MiNeumorphismTokens.base,
            contentPadding: 12
        ) {
            Text(MiL10n.text(titleKey))
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(depth == .pressed ? MiNeumorphismTokens.accentDeep : MiNeumorphismTokens.ink)
                .frame(maxWidth: .infinity)
        }
        .frame(height: 58)
    }
}
