//
//  MiNeoBrutalismControls.swift
//  Mira
//
//  Created on 2026/5/22.
//

import SwiftUI

struct MiNeoBrutalismToggle: View {
    @Binding var isOn: Bool
    let title: String

    var body: some View {
        Button {
            withAnimation(MiNeoBrutalismTokens.motion) {
                isOn.toggle()
            }
        } label: {
            HStack(spacing: 12) {
                ZStack(alignment: isOn ? .trailing : .leading) {
                    MiNeoBrutalismSurface(
                        shape: Capsule(style: .continuous),
                        fill: isOn ? MiNeoBrutalismTokens.blue : Color(hex: 0xCCCCCC),
                        lineWidth: MiNeoBrutalismTokens.thinLineWidth,
                        shadow: CGSize(width: 4, height: 4)
                    )

                    Text(MiL10n.text(isOn ? "c_on_s" : "c_off_s"))
                        .font(.system(size: 12, weight: .black, design: .default))
                        .foregroundStyle(MiNeoBrutalismTokens.ink)
                        .frame(width: 30, height: 30)
                        .background {
                            Circle()
                                .fill(MiNeoBrutalismTokens.surface)
                        }
                        .overlay {
                            Circle()
                                .strokeBorder(MiNeoBrutalismTokens.ink, lineWidth: MiNeoBrutalismTokens.thinLineWidth)
                        }
                        .padding(3)
                }
                .frame(width: 72, height: 38)

                Text(MiL10n.text(title))
                    .font(MiNeoBrutalismTokens.label)
                    .foregroundStyle(MiNeoBrutalismTokens.ink)
                    .lineLimit(2)

                Spacer(minLength: 0)
            }
            .frame(minHeight: 44)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(MiL10n.text(title))
        .accessibilityValue(MiL10n.text(isOn ? "c_on" : "c_off"))
    }
}

struct MiNeoBrutalismSegmentedControl: View {
    let items: [String]
    @Binding var selection: String

    var body: some View {
        HStack(spacing: 8) {
            ForEach(items, id: \.self) { item in
                Button {
                    withAnimation(MiNeoBrutalismTokens.motion) {
                        selection = item
                    }
                } label: {
                    Text(MiL10n.text(item))
                        .font(MiNeoBrutalismTokens.label)
                        .foregroundStyle(selection == item ? Color.white : MiNeoBrutalismTokens.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.76)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 44)
                }
                .buttonStyle(MiNeoBrutalismSegmentButtonStyle(isSelected: selection == item))
                .accessibilityValue(MiL10n.text(selection == item ? "c_selected" : "c_not_selected"))
            }
        }
        .padding(8)
        .background {
            MiNeoBrutalismSurface(
                shape: RoundedRectangle(cornerRadius: MiNeoBrutalismTokens.radiusMD, style: .continuous),
                fill: MiNeoBrutalismTokens.orangeSoft,
                shadow: CGSize(width: 4, height: 4)
            )
        }
    }
}

private struct MiNeoBrutalismSegmentButtonStyle: ButtonStyle {
    let isSelected: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed || isSelected
        let offset = isPressed && !reduceMotion ? CGSize(width: 3, height: 3) : .zero
        let shadow = isPressed ? CGSize(width: 1, height: 1) : MiNeoBrutalismTokens.shadowSmall

        configuration.label
            .padding(.horizontal, 8)
            .background {
                MiNeoBrutalismSurface(
                    shape: RoundedRectangle(cornerRadius: MiNeoBrutalismTokens.radiusSM, style: .continuous),
                    fill: isSelected ? MiNeoBrutalismTokens.blue : MiNeoBrutalismTokens.surface,
                    lineWidth: MiNeoBrutalismTokens.thinLineWidth,
                    shadow: shadow
                )
            }
            .offset(x: offset.width, y: offset.height)
            .animation(reduceMotion ? .easeOut(duration: 0.01) : MiNeoBrutalismTokens.motion, value: configuration.isPressed)
    }
}

struct MiNeoBrutalismInput: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let isError: Bool
    let helper: String

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(MiL10n.text(title))
                .font(MiNeoBrutalismTokens.label)
                .foregroundStyle(MiNeoBrutalismTokens.ink)

            HStack(spacing: 10) {
                Image(systemName: isError ? "exclamationmark.triangle.fill" : "magnifyingglass")
                    .font(.system(size: 14, weight: .black))
                    .foregroundStyle(isError ? MiNeoBrutalismTokens.red : MiNeoBrutalismTokens.blue)

                TextField(MiL10n.text(placeholder), text: $text)
                    .focused($isFocused)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textFieldStyle(.plain)
                    .font(MiNeoBrutalismTokens.body)
                    .foregroundStyle(MiNeoBrutalismTokens.ink)
                    .tint(MiNeoBrutalismTokens.blue)
            }
            .padding(.horizontal, 14)
            .frame(minHeight: 48)
            .background {
                MiNeoBrutalismSurface(
                    shape: RoundedRectangle(cornerRadius: MiNeoBrutalismTokens.radiusSM, style: .continuous),
                    fill: isError ? Color(hex: 0xFFE0E0) : isFocused ? MiNeoBrutalismTokens.blueSoft : MiNeoBrutalismTokens.surface,
                    lineWidth: isFocused || isError ? MiNeoBrutalismTokens.lineWidth : MiNeoBrutalismTokens.thinLineWidth,
                    shadow: CGSize(width: isFocused ? 6 : 4, height: isFocused ? 6 : 4)
                )
            }

            Text(MiL10n.text(helper))
                .font(.system(size: 12, weight: .bold, design: .default))
                .foregroundStyle(isError ? MiNeoBrutalismTokens.red : MiNeoBrutalismTokens.muted)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct MiNeoBrutalismSpecCard: View {
    let number: String
    let title: String
    let subtitle: String
    let fill: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                Text(number)
                    .font(.system(size: 17, weight: .black, design: .default))
                    .foregroundStyle(MiNeoBrutalismTokens.ink)
                    .frame(width: 42, height: 42)
                    .background {
                        MiNeoBrutalismSurface(
                            shape: Circle(),
                            fill: fill,
                            lineWidth: MiNeoBrutalismTokens.thinLineWidth,
                            shadow: CGSize(width: 3, height: 3)
                        )
                    }

                VStack(alignment: .leading, spacing: 5) {
                    Text(MiL10n.text(title))
                        .font(MiNeoBrutalismTokens.body)
                        .foregroundStyle(MiNeoBrutalismTokens.ink)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(MiL10n.text(subtitle))
                        .font(.system(size: 12, weight: .bold, design: .default))
                        .foregroundStyle(MiNeoBrutalismTokens.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 96, alignment: .leading)
        }
        .buttonStyle(MiNeoBrutalismBlockButtonStyle(fill: MiNeoBrutalismTokens.surface))
        .accessibilityLabel("\(MiL10n.text(title)), \(MiL10n.text(subtitle))")
    }
}

private struct MiNeoBrutalismBlockButtonStyle: ButtonStyle {
    let fill: Color
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        let offset = configuration.isPressed && !reduceMotion ? MiNeoBrutalismTokens.pressOffset : .zero
        let shadow = configuration.isPressed ? .zero : MiNeoBrutalismTokens.shadowSmall

        configuration.label
            .background {
                MiNeoBrutalismSurface(
                    shape: RoundedRectangle(cornerRadius: MiNeoBrutalismTokens.radiusSM, style: .continuous),
                    fill: fill,
                    shadow: shadow
                )
            }
            .offset(x: offset.width, y: offset.height)
            .animation(reduceMotion ? .easeOut(duration: 0.01) : MiNeoBrutalismTokens.motion, value: configuration.isPressed)
    }
}

struct MiNeoBrutalismStateCard: View {
    let title: String
    let detail: String
    let systemImage: String
    let fill: Color

    var body: some View {
        MiNeoBrutalismCard(fill: fill, radius: MiNeoBrutalismTokens.radiusSM, shadow: MiNeoBrutalismTokens.shadowSmall, padding: 12) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: systemImage)
                    .font(.system(size: 18, weight: .black))
                    .foregroundStyle(MiNeoBrutalismTokens.ink)
                    .frame(width: 38, height: 38)
                    .background {
                        Circle()
                            .fill(MiNeoBrutalismTokens.surface)
                    }
                    .overlay {
                        Circle()
                            .strokeBorder(MiNeoBrutalismTokens.ink, lineWidth: MiNeoBrutalismTokens.thinLineWidth)
                    }

                Text(MiL10n.text(title))
                    .font(MiNeoBrutalismTokens.label)
                    .foregroundStyle(MiNeoBrutalismTokens.ink)

                Text(MiL10n.text(detail))
                    .font(.system(size: 12, weight: .bold, design: .default))
                    .foregroundStyle(MiNeoBrutalismTokens.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct MiNeoBrutalismInspectorSheet: View {
    let onClose: () -> Void

    var body: some View {
        ZStack {
            MiNeoBrutalismGridBackground()

            MiNeoBrutalismCard(fill: MiNeoBrutalismTokens.paper, radius: MiNeoBrutalismTokens.radiusMD, shadow: MiNeoBrutalismTokens.shadowLarge, padding: 18) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        RoundedRectangle(cornerRadius: 3, style: .continuous)
                            .fill(MiNeoBrutalismTokens.ink)
                            .frame(width: 46, height: 6)

                        Spacer()

                        MiNeoBrutalismButton("nbd_close", systemImage: "xmark", variant: .secondary, action: onClose)
                            .frame(width: 126)
                    }

                    Text(MiL10n.text("nb_prompt_inspector"))
                        .font(MiNeoBrutalismTokens.title)
                        .foregroundStyle(MiNeoBrutalismTokens.ink)

                    VStack(alignment: .leading, spacing: 10) {
                        MiNeoBrutalismBulletRow(text: "nbd_use3pt_black_borders", fill: MiNeoBrutalismTokens.yellow)
                        MiNeoBrutalismBulletRow(text: "nd_direct_press", fill: MiNeoBrutalismTokens.green)
                        MiNeoBrutalismBulletRow(text: "nbd_avoid_glass_blur", fill: MiNeoBrutalismTokens.red)
                    }
                }
            }
            .padding(20)
        }
    }
}
