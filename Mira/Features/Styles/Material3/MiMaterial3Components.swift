//
//  MiMaterial3Components.swift
//  Mira
//
//  Created on 2026/5/25.
//

import SwiftUI

struct MiMaterial3Panel<Content: View>: View {
    let fill: Color
    let radius: CGFloat
    let padding: CGFloat
    let content: Content

    init(
        fill: Color = MiMaterial3Tokens.surfaceContainer,
        radius: CGFloat = MiMaterial3Tokens.radius,
        padding: CGFloat = 18,
        @ViewBuilder content: () -> Content
    ) {
        self.fill = fill
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
                    .fill(fill)
                    .overlay {
                        shape
                            .strokeBorder(MiMaterial3Tokens.outlineVariant.opacity(0.46), lineWidth: 0.8)
                    }
            }
            .shadow(color: MiMaterial3Tokens.primary.opacity(0.045), radius: 10, x: 0, y: 4)
    }
}

struct MiMaterial3Section<Content: View>: View {
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
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(MiMaterial3Tokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 13.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiMaterial3Tokens.muted)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            content
        }
    }
}

struct MiMaterial3Button: View {
    let titleKey: String
    let systemImage: String
    let role: MiMaterial3ButtonRole

    var body: some View {
        Button {} label: {
            Label(MiL10n.text(titleKey), systemImage: systemImage)
                .font(.system(size: 13.5, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity)
                .frame(minHeight: 48)
        }
        .buttonStyle(MiMaterial3ButtonStyle(role: role))
        .disabled(role == .disabled)
    }
}

enum MiMaterial3ButtonRole {
    case filled
    case tonal
    case outlined
    case disabled
}

struct MiMaterial3ButtonStyle: ButtonStyle {
    let role: MiMaterial3ButtonRole

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(foreground.opacity(role == .disabled ? 0.42 : 1))
            .padding(.horizontal, 16)
            .background {
                Capsule(style: .continuous)
                    .fill(background.opacity(configuration.isPressed ? 0.82 : 1))
                    .overlay {
                        Capsule(style: .continuous)
                            .strokeBorder(role == .outlined ? MiMaterial3Tokens.outline : Color.clear, lineWidth: 1)
                    }
            }
            .overlay {
                if configuration.isPressed {
                    Capsule(style: .continuous)
                        .fill(stateLayer)
                }
            }
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.20, dampingFraction: 0.86), value: configuration.isPressed)
    }

    private var background: Color {
        switch role {
        case .filled:
            return MiMaterial3Tokens.primary
        case .tonal:
            return MiMaterial3Tokens.secondaryContainer
        case .outlined:
            return Color.clear
        case .disabled:
            return MiMaterial3Tokens.surfaceContainerHigh
        }
    }

    private var foreground: Color {
        switch role {
        case .filled:
            return MiMaterial3Tokens.onPrimary
        case .tonal:
            return MiMaterial3Tokens.onSecondaryContainer
        case .outlined:
            return MiMaterial3Tokens.primary
        default:
            return MiMaterial3Tokens.ink
        }
    }

    private var stateLayer: Color {
        switch role {
        case .filled:
            return Color.white.opacity(0.12)
        default:
            return MiMaterial3Tokens.primary.opacity(0.12)
        }
    }
}

struct MiMaterial3Chip: View {
    let titleKey: String
    let isSelected: Bool

    var body: some View {
        Label(MiL10n.text(titleKey), systemImage: isSelected ? "checkmark" : "circle")
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .foregroundStyle(MiMaterial3Tokens.ink)
            .padding(.horizontal, 12)
            .frame(height: 34)
            .background {
                Capsule(style: .continuous)
                    .fill(isSelected ? MiMaterial3Tokens.secondaryContainer : MiMaterial3Tokens.surfaceContainerLowest)
                    .overlay {
                        Capsule(style: .continuous)
                            .strokeBorder(MiMaterial3Tokens.outline.opacity(isSelected ? 0 : 0.55), lineWidth: 1)
                    }
            }
    }
}

struct MiMaterial3MetricRow: View {
    let labelKey: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            Text(MiL10n.text(labelKey).uppercased())
                .font(.system(size: 10.5, weight: .bold, design: .rounded))
                .foregroundStyle(MiMaterial3Tokens.muted)
                .tracking(0.5)
            Spacer()
            Text(value)
                .font(.system(size: 12, weight: .black, design: .rounded))
                .foregroundStyle(MiMaterial3Tokens.ink)
                .padding(.horizontal, 10)
                .frame(height: 28)
                .background {
                    Capsule(style: .continuous)
                        .fill(color)
                        .overlay {
                            Capsule(style: .continuous)
                                .strokeBorder(MiMaterial3Tokens.outlineVariant.opacity(0.30), lineWidth: 0.7)
                        }
                }
        }
    }
}

struct MiMaterial3TokenSwatch: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        MiMaterial3Panel(fill: MiMaterial3Tokens.surface, radius: 18, padding: 12) {
            VStack(alignment: .leading, spacing: 10) {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(color)
                    .frame(height: 42)
                    .overlay {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .strokeBorder(MiMaterial3Tokens.outlineVariant.opacity(0.38), lineWidth: 0.8)
                    }
                Text(title)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(MiMaterial3Tokens.ink)
                Text(value)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(MiMaterial3Tokens.muted)
            }
        }
    }
}
