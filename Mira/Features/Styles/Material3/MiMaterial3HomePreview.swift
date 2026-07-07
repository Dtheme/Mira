//
//  MiMaterial3HomePreview.swift
//  Mira
//
//  Created on 2026/5/25.
//

import SwiftUI

struct MiMaterial3HomePreview: View {
    let style: MiDesignStyle
    let focus: MiCardFocus
    let cardSize: CGSize
    let cornerRadius: CGFloat
    let isDragging: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.miHomePressedStyleID) private var pressedStyleID

    private var isPressed: Bool { pressedStyleID == style.id && !isDragging }

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        let k = cardSize.width / 174

        ZStack {
            shape.fill(
                LinearGradient(
                    colors: [MiMaterial3Tokens.surface, MiMaterial3Tokens.surfaceContainerLow],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            VStack(alignment: .leading, spacing: 0) {
                MiMaterial3ShapeQuad(scale: k, pressed: isPressed, reduceMotion: reduceMotion)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 26 * k)

                Spacer(minLength: 0)

                VStack(alignment: .leading, spacing: 6 * k) {
                    Text(MiL10n.text(style.name))
                        .font(.system(size: cardSize.width >= 200 ? 22 : 20, weight: .semibold))
                        .foregroundStyle(MiMaterial3Tokens.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .miStyleTitleTransition(style.id)

                    HStack(spacing: 5) {
                        Circle()
                            .fill(MiMaterial3Tokens.primary)
                            .overlay {
                                Circle()
                                    .strokeBorder(Color.white.opacity(0.7), lineWidth: 1)
                            }
                            .frame(width: 10 * k, height: 10 * k)

                        Text(MiL10n.text("home_m3_seed"))
                            .font(.system(size: 9.5, weight: .medium, design: .monospaced))
                            .tracking(0.5)
                            .foregroundStyle(MiMaterial3Tokens.muted)
                    }
                }
                .padding(.leading, 20 * k)
                .padding(.bottom, 16 * k)
            }
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .clipShape(shape)
        .overlay {
            shape.strokeBorder(
                MiMaterial3Tokens.outlineVariant.opacity(0.55 + focus.borderOpacity * 0.25),
                lineWidth: 1
            )
        }
        .shadow(
            color: MiMaterial3Tokens.primary.opacity(focus.shadowOpacity * (isDragging ? 0.12 : 0.20)),
            radius: isDragging ? 7 : 20,
            x: 0,
            y: isDragging ? 4 : 10
        )
        .shadow(
            color: MiMaterial3Tokens.shadowPlum.opacity(isDragging ? 0 : focus.shadowOpacity * 0.13),
            radius: 26,
            x: 0,
            y: 16
        )
    }
}

// Tonal shape quad: four M3 family shapes, each wearing one semantic color role.
private struct MiMaterial3ShapeQuad: View {
    let scale: CGFloat
    let pressed: Bool
    let reduceMotion: Bool

    // Reduced motion keeps only the state-layer fade; no geometry changes.
    private var morph: Bool { pressed && !reduceMotion }
    private var layerOpacity: Double { pressed ? 0.10 : 0 }

    var body: some View {
        let cell = 56 * scale
        let gutter = 6 * scale

        VStack(spacing: gutter) {
            HStack(spacing: gutter) {
                petal(cell: cell)
                circleCell(cell: cell)
            }
            HStack(spacing: gutter) {
                scallop(cell: cell)
                squircle(cell: cell)
            }
        }
        .scaleEffect(morph ? 0.97 : 1)
        .animation(
            reduceMotion ? .easeOut(duration: 0.12) : .spring(response: 0.32, dampingFraction: 0.72),
            value: pressed
        )
    }

    private func petal(cell: CGFloat) -> some View {
        let big = (morph ? 26 : 46) * scale
        let small = (morph ? 20 : 8) * scale
        let radii = RectangleCornerRadii(
            topLeading: big,
            bottomLeading: small,
            bottomTrailing: big,
            topTrailing: small
        )
        return UnevenRoundedRectangle(cornerRadii: radii, style: .continuous)
            .fill(MiMaterial3Tokens.primary)
            .overlay {
                UnevenRoundedRectangle(cornerRadii: radii, style: .continuous)
                    .fill(MiMaterial3Tokens.onPrimary.opacity(layerOpacity))
            }
            .frame(width: cell, height: cell)
    }

    private func circleCell(cell: CGFloat) -> some View {
        let dot = (morph ? 26 : 18) * scale
        return Circle()
            .fill(MiMaterial3Tokens.tertiaryContainer)
            .overlay {
                Circle()
                    .fill(MiMaterial3Tokens.tertiary)
                    .frame(width: dot, height: dot)
            }
            .overlay {
                Circle()
                    .fill(MiMaterial3Tokens.onTertiaryContainer.opacity(layerOpacity))
            }
            .frame(width: cell, height: cell)
    }

    private func scallop(cell: CGFloat) -> some View {
        MiM3ScallopShape()
            .fill(MiMaterial3Tokens.secondaryContainer)
            .overlay {
                MiM3ScallopShape()
                    .fill(MiMaterial3Tokens.onSecondaryContainer.opacity(layerOpacity))
            }
            .rotationEffect(.degrees(morph ? 22.5 : 0))
            .frame(width: cell, height: cell)
    }

    private func squircle(cell: CGFloat) -> some View {
        let radius = (morph ? 26 : 18) * scale
        return RoundedRectangle(cornerRadius: radius, style: .continuous)
            .fill(MiMaterial3Tokens.secondary)
            .overlay {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(Color.white.opacity(layerOpacity))
            }
            .frame(width: cell, height: cell)
    }
}

// Eight-lobe cookie: r(theta) = R * (0.84 + 0.16 * cos(8 * theta)).
private struct MiM3ScallopShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = Double(min(rect.width, rect.height)) / 2
        let samples = 96
        var path = Path()
        for i in 0...samples {
            let theta = Double(i) / Double(samples) * 2 * .pi
            let r = radius * (0.84 + 0.16 * cos(8 * theta))
            let point = CGPoint(x: center.x + r * cos(theta), y: center.y + r * sin(theta))
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}
