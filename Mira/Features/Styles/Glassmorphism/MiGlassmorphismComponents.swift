//
//  MiGlassmorphismComponents.swift
//  Mira
//
//  Created on 2026/5/25.
//

import SwiftUI

struct MiGlassmorphismPanel<Content: View>: View {
    let radius: CGFloat
    let padding: CGFloat
    let content: Content

    init(
        radius: CGFloat = MiGlassmorphismTokens.radius,
        padding: CGFloat = 18,
        @ViewBuilder content: () -> Content
    ) {
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
                    .fill(.ultraThinMaterial)
                    .overlay {
                        shape
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.58),
                                        MiGlassmorphismTokens.cyan.opacity(0.12),
                                        MiGlassmorphismTokens.violet.opacity(0.10)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    .overlay {
                        shape
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.92),
                                        MiGlassmorphismTokens.cyan.opacity(0.52),
                                        Color.white.opacity(0.28)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.15
                            )
                    }
            }
            .shadow(color: MiGlassmorphismTokens.blue.opacity(0.18), radius: 24, x: 0, y: 16)
    }
}

struct MiGlassmorphismSection<Content: View>: View {
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
                    .foregroundStyle(MiGlassmorphismTokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 13.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiGlassmorphismTokens.muted)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }

            content
        }
    }
}

struct MiGlassmorphismButton: View {
    let titleKey: String
    let systemImage: String
    let isPrimary: Bool
    let isDisabled: Bool

    init(titleKey: String, systemImage: String, isPrimary: Bool = false, isDisabled: Bool = false) {
        self.titleKey = titleKey
        self.systemImage = systemImage
        self.isPrimary = isPrimary
        self.isDisabled = isDisabled
    }

    var body: some View {
        Button {} label: {
            Label(MiL10n.text(titleKey), systemImage: systemImage)
                .font(.system(size: 13.5, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity)
                .frame(minHeight: 48)
        }
        .buttonStyle(MiGlassmorphismButtonStyle(isPrimary: isPrimary, isDisabled: isDisabled))
        .disabled(isDisabled)
    }
}

struct MiGlassmorphismButtonStyle: ButtonStyle {
    let isPrimary: Bool
    let isDisabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isPrimary ? Color.white : MiGlassmorphismTokens.ink.opacity(isDisabled ? 0.42 : 0.92))
            .padding(.horizontal, 14)
            .background {
                Capsule(style: .continuous)
                    .fill(isPrimary ? MiGlassmorphismTokens.blue.opacity(0.82) : Color.white.opacity(isDisabled ? 0.24 : 0.40))
                    .overlay {
                        Capsule(style: .continuous)
                            .strokeBorder(Color.white.opacity(isPrimary ? 0.55 : 0.82), lineWidth: 1)
                    }
            }
            .shadow(color: MiGlassmorphismTokens.blue.opacity(isPrimary ? 0.24 : 0.10), radius: configuration.isPressed ? 6 : 14, x: 0, y: configuration.isPressed ? 4 : 9)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.22, dampingFraction: 0.82), value: configuration.isPressed)
    }
}

struct MiGlassmorphismChip: View {
    let titleKey: String
    let isSelected: Bool

    var body: some View {
        Text(MiL10n.text(titleKey))
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .foregroundStyle(isSelected ? MiGlassmorphismTokens.ink : MiGlassmorphismTokens.muted)
            .padding(.horizontal, 12)
            .frame(height: 34)
            .background {
                Capsule(style: .continuous)
                    .fill(isSelected ? Color.white.opacity(0.62) : Color.white.opacity(0.30))
                    .overlay {
                        Capsule(style: .continuous)
                            .strokeBorder(Color.white.opacity(isSelected ? 0.88 : 0.44), lineWidth: 1)
                    }
            }
    }
}

struct MiGlassmorphismMetricRow: View {
    let labelKey: String
    let value: String
    let isActive: Bool

    var body: some View {
        HStack {
            Text(MiL10n.text(labelKey).uppercased())
                .font(.system(size: 10.5, weight: .bold, design: .rounded))
                .foregroundStyle(MiGlassmorphismTokens.muted)
                .tracking(0.6)

            Spacer(minLength: 10)

            Text(value)
                .font(.system(size: 12, weight: .black, design: .rounded))
                .foregroundStyle(isActive ? MiGlassmorphismTokens.ink : MiGlassmorphismTokens.muted)
                .padding(.horizontal, 10)
                .frame(height: 28)
                .background {
                    Capsule(style: .continuous)
                        .fill(isActive ? Color.white.opacity(0.72) : Color.white.opacity(0.34))
                        .overlay {
                            Capsule(style: .continuous)
                                .strokeBorder(Color.white.opacity(0.78), lineWidth: 1)
                        }
                }
        }
    }
}

struct MiGlassmorphismTokenSwatch: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        MiGlassmorphismPanel(radius: 20, padding: 12) {
            VStack(alignment: .leading, spacing: 10) {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(color)
                    .frame(height: 42)
                    .overlay {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.8), lineWidth: 1)
                    }
                Text(title)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(MiGlassmorphismTokens.ink)
                    .lineLimit(1)
                Text(value)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(MiGlassmorphismTokens.muted)
            }
        }
        .frame(minHeight: 132)
    }
}
