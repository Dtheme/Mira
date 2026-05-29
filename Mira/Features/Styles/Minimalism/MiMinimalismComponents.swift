//
//  MiMinimalismComponents.swift
//  Mira
//
//  Created on 2026/5/25.
//

import SwiftUI

struct MiMinimalismPanel<Content: View>: View {
    let padding: CGFloat
    let content: Content

    init(padding: CGFloat = 18, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: MiMinimalismTokens.radius, style: .continuous)

        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                shape
                    .fill(Color.white.opacity(0.96))
                    .overlay {
                        shape
                            .strokeBorder(MiMinimalismTokens.ink.opacity(0.82), lineWidth: 1)
                    }
            }
    }
}

struct MiMinimalismSection<Content: View>: View {
    let index: String
    let titleKey: String
    let bodyKey: String
    let content: Content

    init(index: String, titleKey: String, bodyKey: String, @ViewBuilder content: () -> Content) {
        self.index = index
        self.titleKey = titleKey
        self.bodyKey = bodyKey
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .firstTextBaseline, spacing: 14) {
                Text(index)
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .foregroundStyle(MiMinimalismTokens.muted)
                    .frame(width: 34, alignment: .leading)

                VStack(alignment: .leading, spacing: 6) {
                    Text(MiL10n.text(titleKey))
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(MiMinimalismTokens.ink)
                    Text(MiL10n.text(bodyKey))
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(MiMinimalismTokens.muted)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            content
        }
    }
}

struct MiMinimalismButton: View {
    let titleKey: String
    let isPrimary: Bool
    let isDisabled: Bool

    init(titleKey: String, isPrimary: Bool = false, isDisabled: Bool = false) {
        self.titleKey = titleKey
        self.isPrimary = isPrimary
        self.isDisabled = isDisabled
    }

    var body: some View {
        Button {} label: {
            Text(MiL10n.text(titleKey))
                .font(.system(size: 13, weight: .semibold))
                .frame(maxWidth: .infinity)
                .frame(minHeight: 46)
        }
        .buttonStyle(MiMinimalismButtonStyle(isPrimary: isPrimary, isDisabled: isDisabled))
        .disabled(isDisabled)
    }
}

struct MiMinimalismButtonStyle: ButtonStyle {
    let isPrimary: Bool
    let isDisabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isPrimary ? Color.white : MiMinimalismTokens.ink.opacity(isDisabled ? 0.34 : 1))
            .background {
                Rectangle()
                    .fill(isPrimary ? MiMinimalismTokens.ink : Color.white)
                    .overlay {
                        Rectangle()
                            .stroke(MiMinimalismTokens.ink.opacity(isDisabled ? 0.24 : 0.9), lineWidth: 1)
                    }
            }
            .opacity(isDisabled ? 0.68 : 1)
            .offset(y: configuration.isPressed ? 1 : 0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct MiMinimalismChip: View {
    let titleKey: String
    let isSelected: Bool

    var body: some View {
        Text(MiL10n.text(titleKey))
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(isSelected ? Color.white : MiMinimalismTokens.ink)
            .padding(.horizontal, 11)
            .frame(height: 32)
            .background {
                Rectangle()
                    .fill(isSelected ? MiMinimalismTokens.ink : Color.white)
                    .overlay { Rectangle().stroke(MiMinimalismTokens.ink, lineWidth: 1) }
            }
    }
}

struct MiMinimalismMetricRow: View {
    let labelKey: String
    let value: String

    var body: some View {
        HStack {
            Text(MiL10n.text(labelKey).uppercased())
                .font(.system(size: 10.5, weight: .semibold, design: .monospaced))
                .foregroundStyle(MiMinimalismTokens.muted)
            Spacer()
            Text(value)
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                .foregroundStyle(MiMinimalismTokens.ink)
                .padding(.horizontal, 8)
                .frame(height: 26)
                .background {
                    Rectangle()
                        .fill(MiMinimalismTokens.quiet)
                        .overlay { Rectangle().stroke(MiMinimalismTokens.ink, lineWidth: 1) }
                }
        }
    }
}

struct MiMinimalismTokenSwatch: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        MiMinimalismPanel(padding: 12) {
            VStack(alignment: .leading, spacing: 10) {
                Rectangle()
                    .fill(color)
                    .frame(height: 42)
                    .overlay { Rectangle().stroke(MiMinimalismTokens.ink.opacity(0.85), lineWidth: 1) }
                Text(title)
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .foregroundStyle(MiMinimalismTokens.ink)
                Text(value)
                    .font(.system(size: 11, weight: .regular, design: .monospaced))
                    .foregroundStyle(MiMinimalismTokens.muted)
            }
        }
    }
}
