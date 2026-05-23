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
                depth == .pressed ? MiNeumorphismTokens.basePressed : fill
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var strokeGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(depth == .pressed ? 0.70 : 0.54),
                MiNeumorphismTokens.stroke.opacity(0.74),
                MiNeumorphismTokens.shadowDark.opacity(depth == .pressed ? 0.36 : 0.16)
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
                .shadow(color: MiNeumorphismTokens.shadowDark.opacity(0.70), radius: 16, x: 10, y: 10)
                .shadow(color: MiNeumorphismTokens.shadowLight.opacity(0.88), radius: 16, x: -10, y: -10)
        case .pressed:
            content
                .shadow(color: MiNeumorphismTokens.shadowDark.opacity(0.34), radius: 6, x: 3, y: 3)
                .shadow(color: MiNeumorphismTokens.shadowLight.opacity(0.52), radius: 6, x: -3, y: -3)
        case .inset:
            content
        }
    }
}

struct MiNeumorphismInsetOverlay: View {
    let cornerRadius: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(MiNeumorphismTokens.shadowDark.opacity(0.54), lineWidth: 2)
            .blur(radius: 4)
            .offset(x: 4, y: 4)
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
                    .stroke(MiNeumorphismTokens.shadowLight.opacity(0.90), lineWidth: 2)
                    .blur(radius: 4)
                    .offset(x: -4, y: -4)
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
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(MiL10n.text(titleKey))
                    .font(.system(size: 23, weight: .bold, design: .rounded))
                    .foregroundStyle(MiNeumorphismTokens.ink)

                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(MiNeumorphismTokens.muted)
                    .lineSpacing(2)
            }

            content
        }
    }
}

struct MiNeumorphismButtonStyle: ButtonStyle {
    let isPrimary: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .semibold, design: .rounded))
            .foregroundStyle(isPrimary ? MiNeumorphismTokens.ink : MiNeumorphismTokens.accentDeep)
            .frame(minHeight: 44)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .background {
                MiNeumorphismSoftSurface(
                    cornerRadius: 18,
                    depth: configuration.isPressed ? .pressed : .raised,
                    fill: isPrimary ? MiNeumorphismTokens.focusAccent.opacity(0.44) : MiNeumorphismTokens.base,
                    contentPadding: 0
                ) {
                    EmptyView()
                }
            }
            .offset(x: configuration.isPressed ? 1 : 0, y: configuration.isPressed ? 1 : 0)
    }
}

struct MiNeumorphismPill: View {
    let titleKey: String
    let isSelected: Bool

    var body: some View {
        Text(MiL10n.text(titleKey))
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundStyle(isSelected ? MiNeumorphismTokens.ink : MiNeumorphismTokens.muted)
            .frame(minHeight: 34)
            .padding(.horizontal, 14)
            .background {
                MiNeumorphismSoftSurface(
                    cornerRadius: 17,
                    depth: isSelected ? .inset : .raised,
                    fill: isSelected ? MiNeumorphismTokens.basePressed : MiNeumorphismTokens.base,
                    contentPadding: 0
                ) {
                    EmptyView()
                }
            }
    }
}

struct MiNeumorphismTokenSwatch: View {
    let titleKey: String
    let value: String
    let color: Color

    var body: some View {
        MiNeumorphismSoftSurface(cornerRadius: 20, contentPadding: 14) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(color)
                    .frame(width: 42, height: 42)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.68), lineWidth: 1)
                    }

                VStack(alignment: .leading, spacing: 3) {
                    Text(MiL10n.text(titleKey))
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)

                    Text(value)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(MiNeumorphismTokens.muted)
                }

                Spacer(minLength: 0)
            }
        }
        .frame(minHeight: 70)
    }
}
