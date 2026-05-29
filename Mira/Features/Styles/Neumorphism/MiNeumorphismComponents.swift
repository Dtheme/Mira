//
//  MiNeumorphismComponents.swift
//  Mira
//
//  Created on 2026/5/23.
//

import SwiftUI

enum MiNeumorphismSurfaceDepth: Equatable {
    case raised
    case inset
    case pressed
}

enum MiNeumorphismButtonRole {
    case primary
    case secondary
    case destructive
}

struct MiNeumorphismSoftSurface<Content: View>: View {
    let cornerRadius: CGFloat
    let depth: MiNeumorphismSurfaceDepth
    let fill: Color
    let contentPadding: CGFloat
    let content: Content

    init(
        cornerRadius: CGFloat = MiNeumorphismTokens.radius,
        depth: MiNeumorphismSurfaceDepth = .raised,
        fill: Color = MiNeumorphismTokens.base,
        contentPadding: CGFloat = 18,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.depth = depth
        self.fill = fill
        self.contentPadding = contentPadding
        self.content = content()
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(surfaceFill)
                .modifier(MiNeumorphismSurfaceShadow(depth: depth))
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(strokeGradient, lineWidth: depth == .pressed ? 1.1 : 1)
                }
                .overlay(alignment: .topLeading) {
                    if depth == .raised {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.36), lineWidth: 0.8)
                            .blendMode(.screen)
                    }
                }
                .overlay {
                    if depth == .inset {
                        MiNeumorphismInsetOverlay(cornerRadius: cornerRadius)
                    }
                }
                .overlay {
                    if depth == .pressed {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.52),
                                        Color.white.opacity(0.18),
                                        Color.white.opacity(0.05),
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

            content
                .padding(contentPadding)
        }
    }

    private var surfaceFill: LinearGradient {
        LinearGradient(
            colors: [
                depth == .pressed ? fill : MiNeumorphismTokens.baseLight,
                depth == .inset ? MiNeumorphismTokens.baseInset : (depth == .pressed ? MiNeumorphismTokens.basePressed : fill)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var strokeGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(depth == .pressed ? 0.78 : 0.58),
                MiNeumorphismTokens.stroke.opacity(0.74),
                MiNeumorphismTokens.shadowDark.opacity(depth == .inset ? 0.28 : (depth == .pressed ? 0.38 : 0.15))
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

private struct MiNeumorphismSurfaceShadow: ViewModifier {
    let depth: MiNeumorphismSurfaceDepth

    func body(content: Content) -> some View {
        switch depth {
        case .raised:
            content
                .shadow(color: MiNeumorphismTokens.shadowDark.opacity(0.62), radius: MiNeumorphismTokens.outerShadow, x: 11, y: 11)
                .shadow(color: MiNeumorphismTokens.shadowLight.opacity(0.96), radius: MiNeumorphismTokens.outerShadow - 1, x: -11, y: -11)
        case .pressed:
            content
                .shadow(color: MiNeumorphismTokens.shadowDark.opacity(0.30), radius: MiNeumorphismTokens.pressedShadow, x: 2.5, y: 2.5)
                .shadow(color: MiNeumorphismTokens.shadowLight.opacity(0.60), radius: MiNeumorphismTokens.pressedShadow, x: -2.5, y: -2.5)
        case .inset:
            content
        }
    }
}

struct MiNeumorphismInsetOverlay: View {
    let cornerRadius: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(MiNeumorphismTokens.shadowDark.opacity(0.50), lineWidth: 2.5)
            .blur(radius: 5)
            .offset(x: 4.5, y: 4.5)
            .mask {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.88)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(MiNeumorphismTokens.shadowLight.opacity(0.96), lineWidth: 2.5)
                    .blur(radius: 5)
                    .offset(x: -4.5, y: -4.5)
                    .mask {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [.black.opacity(0.88), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
            }
    }
}

struct MiNeumorphismSection<Content: View>: View {
    let titleKey: String
    let bodyKey: String
    let content: Content

    init(
        titleKey: String,
        bodyKey: String,
        @ViewBuilder content: () -> Content
    ) {
        self.titleKey = titleKey
        self.bodyKey = bodyKey
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: MiNeumorphismTokens.groupSpacing) {
            HStack(alignment: .top, spacing: 14) {
                MiNeumorphismSectionMarker()
                    .padding(.top, 4)

                VStack(alignment: .leading, spacing: 6) {
                    Text(MiL10n.text(titleKey))
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.ink)
                        .tracking(-0.2)

                    Text(MiL10n.text(bodyKey))
                        .font(.system(size: 13.5, weight: .medium, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.quietText)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }

            content
        }
    }
}

private struct MiNeumorphismSectionMarker: View {
    var body: some View {
        MiNeumorphismSoftSurface(
            cornerRadius: 4,
            depth: .inset,
            fill: MiNeumorphismTokens.baseInset,
            contentPadding: 0
        ) {
            RoundedRectangle(cornerRadius: 2.5, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            MiNeumorphismTokens.focusAccent,
                            MiNeumorphismTokens.accentDeep.opacity(0.82)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 5, height: 18)
                .shadow(color: MiNeumorphismTokens.shadowLight.opacity(0.78), radius: 1.2, x: -0.8, y: -0.8)
                .shadow(color: MiNeumorphismTokens.shadowDark.opacity(0.30), radius: 1.2, x: 0.8, y: 0.8)
        }
        .frame(width: 8, height: 28)
    }
}

struct MiNeumorphismButtonStyle: ButtonStyle {
    let role: MiNeumorphismButtonRole

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(isPrimary: Bool) {
        self.role = isPrimary ? .primary : .secondary
    }

    init(role: MiNeumorphismButtonRole) {
        self.role = role
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .semibold, design: .rounded))
            .foregroundStyle(foregroundColor)
            .frame(minHeight: 44)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .background {
                MiNeumorphismSoftSurface(
                    cornerRadius: 18,
                    depth: depth(isPressed: configuration.isPressed),
                    fill: fillColor(isPressed: configuration.isPressed),
                    contentPadding: 0
                ) {
                    EmptyView()
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(edgeGradient(isPressed: configuration.isPressed), lineWidth: configuration.isPressed && isEnabled ? 1.2 : 0.9)
                    .opacity(edgeOpacity(isPressed: configuration.isPressed))
            }
            .opacity(isEnabled ? 1 : 0.48)
            .scaleEffect(configuration.isPressed && isEnabled && !reduceMotion ? 0.992 : 1)
            .offset(x: configuration.isPressed && isEnabled && !reduceMotion ? 1 : 0, y: configuration.isPressed && isEnabled && !reduceMotion ? 1 : 0)
            .animation(reduceMotion ? .easeOut(duration: 0.01) : .spring(response: 0.18, dampingFraction: 0.78), value: configuration.isPressed)
    }

    private var foregroundColor: Color {
        guard isEnabled else {
            return MiNeumorphismTokens.muted
        }

        switch role {
        case .primary:
            return Color(hex: 0x283342)
        case .secondary:
            return MiNeumorphismTokens.accentDeep
        case .destructive:
            return MiNeumorphismTokens.error
        }
    }

    private func depth(isPressed: Bool) -> MiNeumorphismSurfaceDepth {
        guard isEnabled else {
            return .pressed
        }
        return isPressed ? .pressed : .raised
    }

    private func fillColor(isPressed: Bool) -> Color {
        guard isEnabled else {
            return MiNeumorphismTokens.basePressed
        }

        switch role {
        case .primary:
            return isPressed ? MiNeumorphismTokens.focusSoft.opacity(0.86) : MiNeumorphismTokens.focusSoft
        case .secondary:
            return MiNeumorphismTokens.base
        case .destructive:
            return MiNeumorphismTokens.error.opacity(isPressed ? 0.12 : 0.18)
        }
    }

    private func edgeGradient(isPressed: Bool) -> LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(isPressed ? 0.78 : 0.46),
                roleAccent.opacity(role == .secondary ? 0.14 : 0.30),
                MiNeumorphismTokens.shadowDark.opacity(isPressed ? 0.24 : 0.10)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private func edgeOpacity(isPressed: Bool) -> Double {
        if !isEnabled {
            return 0.48
        }
        return role == .secondary && !isPressed ? 0.62 : 1
    }

    private var roleAccent: Color {
        switch role {
        case .primary:
            return MiNeumorphismTokens.focusAccent
        case .secondary:
            return MiNeumorphismTokens.accent
        case .destructive:
            return MiNeumorphismTokens.error
        }
    }
}

struct MiNeumorphismPill: View {
    let titleKey: String
    let isSelected: Bool
    var isDisabled = false

    var body: some View {
        HStack(spacing: 7) {
            if isSelected {
                Circle()
                    .fill(MiNeumorphismTokens.focusAccent)
                    .frame(width: 7, height: 7)
                    .shadow(color: MiNeumorphismTokens.shadowLight.opacity(0.85), radius: 2, x: -1, y: -1)
                    .shadow(color: MiNeumorphismTokens.shadowDark.opacity(0.32), radius: 2, x: 1, y: 1)
            }

            Text(MiL10n.text(titleKey))
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(textColor)
                .lineLimit(1)
                .minimumScaleFactor(0.80)
        }
        .frame(minHeight: 36)
        .padding(.horizontal, isSelected ? 13 : 15)
        .background {
            MiNeumorphismSoftSurface(
                cornerRadius: 17,
                depth: isDisabled ? .pressed : (isSelected ? .inset : .raised),
                fill: isSelected ? MiNeumorphismTokens.basePressed : MiNeumorphismTokens.base,
                contentPadding: 0
            ) {
                EmptyView()
            }
        }
        .opacity(isDisabled ? 0.50 : 1)
        .accessibilityValue(MiL10n.text(isSelected ? "c_selected" : "c_not_selected"))
    }

    private var textColor: Color {
        if isDisabled {
            return MiNeumorphismTokens.muted.opacity(0.78)
        }
        return isSelected ? MiNeumorphismTokens.ink : MiNeumorphismTokens.muted
    }
}

struct MiNeumorphismDemoPanel<Content: View>: View {
    let cornerRadius: CGFloat
    let depth: MiNeumorphismSurfaceDepth
    let content: Content

    init(
        cornerRadius: CGFloat = 26,
        depth: MiNeumorphismSurfaceDepth = .raised,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.depth = depth
        self.content = content()
    }

    var body: some View {
        MiNeumorphismSoftSurface(
            cornerRadius: cornerRadius,
            depth: depth,
            fill: MiNeumorphismTokens.base,
            contentPadding: MiNeumorphismTokens.panelPadding
        ) {
            content
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct MiNeumorphismTokenSwatch: View {
    let titleKey: String
    let value: String
    let color: Color

    var body: some View {
        MiNeumorphismSoftSurface(cornerRadius: 22, contentPadding: 14) {
            HStack(spacing: 12) {
                MiNeumorphismSoftSurface(cornerRadius: 14, depth: .pressed, fill: MiNeumorphismTokens.basePressed, contentPadding: 0) {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(color)
                        .frame(width: 34, height: 34)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .strokeBorder(Color.white.opacity(0.72), lineWidth: 1)
                        }
                }
                .frame(width: 48, height: 48)

                VStack(alignment: .leading, spacing: 3) {
                    Text(MiL10n.text(titleKey))
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)

                    Text(value)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.quietText)
                }

                Spacer(minLength: 0)
            }
        }
        .frame(minHeight: 70)
    }
}
