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

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        ZStack {
            MiMaterial3HomeSurface(shape: shape, focus: focus)

            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    MiMaterial3HomeBadge()

                    Text(MiL10n.text(style.name))
                        .font(.system(size: 19, weight: .bold, design: .rounded))
                        .foregroundStyle(MiMaterial3Tokens.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.66)
                        .miStyleTitleTransition(style.id)
                }

                Text(MiL10n.text("home_m3_short"))
                    .font(.system(size: 11.7, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiMaterial3Tokens.muted)
                    .lineSpacing(2.4)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)

                MiMaterial3HomeSwitchPreview(
                    focus: focus,
                    width: min(cardSize.width - 44, 140),
                    isDragging: isDragging
                )
                .frame(maxWidth: .infinity, alignment: .center)

                HStack(spacing: 7) {
                    MiMaterial3HomeRoleDot(label: "P", color: MiMaterial3Tokens.primary, foreground: Color.white)
                    MiMaterial3HomeRoleDot(label: "S", color: MiMaterial3Tokens.secondaryContainer, foreground: MiMaterial3Tokens.onSecondaryContainer)
                    MiMaterial3HomeRoleDot(label: "T", color: MiMaterial3Tokens.tertiaryContainer, foreground: MiMaterial3Tokens.onTertiaryContainer)

                    Spacer(minLength: 0)

                    Text(MiL10n.text("home_m3_state"))
                        .font(.system(size: 9.6, weight: .black, design: .rounded))
                        .foregroundStyle(MiMaterial3Tokens.primary)
                        .padding(.horizontal, 9)
                        .frame(height: 24)
                        .background {
                            Capsule(style: .continuous)
                                .fill(MiMaterial3Tokens.primaryContainer)
                        }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 21)
            .padding(.bottom, 18)
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .clipShape(shape)
        .overlay {
            shape
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.70),
                            MiMaterial3Tokens.primary.opacity(0.12 + focus.borderOpacity * 0.28),
                            MiMaterial3Tokens.outline.opacity(0.13)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.05
                )
        }
        .shadow(color: MiMaterial3Tokens.primary.opacity(focus.shadowOpacity * 0.28), radius: isDragging ? 8 : 22, x: 0, y: isDragging ? 5 : 12)
        .shadow(color: Color(hex: 0x6C6470).opacity(focus.shadowOpacity * 0.18), radius: isDragging ? 10 : 26, x: 0, y: isDragging ? 7 : 18)
    }
}

private struct MiMaterial3HomeSurface: View {
    let shape: RoundedRectangle
    let focus: MiCardFocus

    var body: some View {
        shape
            .fill(
                LinearGradient(
                    colors: [
                        MiMaterial3Tokens.surface,
                        MiMaterial3Tokens.surfaceContainer,
                        Color(hex: 0xF8F1FF)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 42, style: .continuous)
                    .fill(MiMaterial3Tokens.primaryContainer.opacity(0.72 + focus.borderOpacity * 0.12))
                    .frame(width: 118, height: 96)
                    .rotationEffect(.degrees(8))
                    .offset(x: 42, y: -42)
            }
            .overlay(alignment: .bottomLeading) {
                Circle()
                    .fill(MiMaterial3Tokens.tertiaryContainer.opacity(0.62))
                    .frame(width: 120, height: 120)
                    .offset(x: -50, y: 52)
            }
            .overlay(alignment: .center) {
                Circle()
                    .stroke(MiMaterial3Tokens.primary.opacity(0.04 + focus.borderOpacity * 0.06), lineWidth: 28)
                    .frame(width: 132, height: 132)
                    .offset(x: 52, y: 40)
            }
    }
}

private struct MiMaterial3HomeBadge: View {
    var body: some View {
        Text("M3")
            .font(.system(size: 11, weight: .black, design: .rounded))
            .foregroundStyle(MiMaterial3Tokens.primary)
            .frame(width: 38, height: 28)
            .background {
                Capsule(style: .continuous)
                    .fill(MiMaterial3Tokens.primaryContainer)
                    .overlay {
                        Capsule(style: .continuous)
                            .strokeBorder(Color.white.opacity(0.58), lineWidth: 1)
                    }
            }
    }
}

private struct MiMaterial3HomeSwitchPreview: View {
    let focus: MiCardFocus
    let width: CGFloat
    let isDragging: Bool

    var body: some View {
        ZStack(alignment: .trailing) {
            Capsule(style: .continuous)
                .fill(MiMaterial3Tokens.primaryContainer)
                .frame(width: width, height: 72)
                .overlay(alignment: .leading) {
                    Circle()
                        .fill(MiMaterial3Tokens.primary.opacity(0.12 + focus.borderOpacity * 0.08))
                        .frame(width: 60, height: 60)
                        .padding(.leading, 9)
                }
                .overlay {
                    Capsule(style: .continuous)
                        .strokeBorder(MiMaterial3Tokens.outlineVariant.opacity(0.48), lineWidth: 1)
                }
                .shadow(
                    color: MiMaterial3Tokens.primary.opacity(isDragging ? 0.06 : 0.18),
                    radius: isDragging ? 6 : 15,
                    x: 0,
                    y: isDragging ? 4 : 9
                )

            Circle()
                .fill(MiMaterial3Tokens.primary)
                .frame(width: 58, height: 58)
                .overlay {
                    Image(systemName: "checkmark")
                        .font(.system(size: 17, weight: .black))
                        .foregroundStyle(Color.white)
                }
                .overlay {
                    Circle()
                        .strokeBorder(Color.white.opacity(0.42), lineWidth: 1.2)
                        .padding(1)
                }
                .shadow(
                    color: MiMaterial3Tokens.primary.opacity(isDragging ? 0.10 : 0.26),
                    radius: isDragging ? 7 : 14,
                    x: 0,
                    y: isDragging ? 4 : 8
                )
                .padding(.trailing, 8)
        }
        .frame(width: width, height: 78)
    }
}

private struct MiMaterial3HomeRoleDot: View {
    let label: String
    let color: Color
    let foreground: Color

    var body: some View {
        Text(label)
            .font(.system(size: 9, weight: .black, design: .rounded))
            .foregroundStyle(foreground)
            .frame(width: 26, height: 22)
            .background {
                Capsule(style: .continuous)
                    .fill(color)
                    .overlay {
                        Capsule(style: .continuous)
                            .strokeBorder(Color.white.opacity(0.34), lineWidth: 0.8)
                    }
            }
    }
}
