//
//  MiNeumorphismControls.swift
//  Mira
//
//  Created on 2026/5/23.
//

import SwiftUI

struct MiNeumorphismToggleControl: View {
    @Binding var isOn: Bool

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            HStack(spacing: 12) {
                Text(MiL10n.text("neu_toggle_depth"))
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiNeumorphismTokens.ink)

                Spacer(minLength: 0)

                ZStack(alignment: isOn ? .trailing : .leading) {
                    Capsule(style: .continuous)
                        .fill(isOn ? MiNeumorphismTokens.focusAccent.opacity(0.46) : MiNeumorphismTokens.basePressed)
                        .frame(width: 60, height: 34)
                        .overlay {
                            MiNeumorphismInsetOverlay(cornerRadius: 17)
                                .opacity(isOn ? 0.45 : 0.28)
                        }

                    Circle()
                        .fill(isOn ? MiNeumorphismTokens.baseLight : MiNeumorphismTokens.base)
                        .frame(width: 28, height: 28)
                        .shadow(color: MiNeumorphismTokens.shadowDark.opacity(0.48), radius: 5, x: 3, y: 3)
                        .shadow(color: MiNeumorphismTokens.shadowLight.opacity(0.90), radius: 5, x: -3, y: -3)
                        .padding(3)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(MiL10n.text("neu_toggle_depth"))
        .accessibilityValue(MiL10n.text(isOn ? "c_on" : "c_off"))
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
                }
                .buttonStyle(.plain)
                .accessibilityLabel(MiL10n.text("neu_clear"))
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 54)
        .background {
            MiNeumorphismSoftSurface(
                cornerRadius: 18,
                depth: isFocused ? .inset : .raised,
                fill: MiNeumorphismTokens.base,
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
