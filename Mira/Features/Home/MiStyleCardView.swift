//
//  MiStyleCardView.swift
//  Mira
//
//  Created on 2026/5/22.
//

import SwiftUI

struct MiStyleCardView: View {
    let style: MiDesignStyle
    let focus: MiCardFocus
    let cardSize: CGSize
    let cornerRadius: CGFloat
    let isDragging: Bool

    init(
        style: MiDesignStyle,
        focus: MiCardFocus,
        cardSize: CGSize,
        cornerRadius: CGFloat,
        isDragging: Bool = false
    ) {
        self.style = style
        self.focus = focus
        self.cardSize = cardSize
        self.cornerRadius = cornerRadius
        self.isDragging = isDragging
    }

    var body: some View {
        Group {
            if style.id == MiNeoBrutalismModule.styleID {
                MiNeoBrutalismHomePreview(
                    style: style,
                    focus: focus,
                    cardSize: cardSize,
                    cornerRadius: cornerRadius,
                    isDragging: isDragging
                )
            } else if style.id == MiNeumorphismModule.styleID {
                MiNeumorphismHomePreview(
                    style: style,
                    focus: focus,
                    cardSize: cardSize,
                    cornerRadius: cornerRadius,
                    isDragging: isDragging
                )
            } else if style.id == MiClaymorphismModule.styleID {
                MiClaymorphismHomePreview(
                    style: style,
                    focus: focus,
                    cardSize: cardSize,
                    cornerRadius: cornerRadius,
                    isDragging: isDragging
                )
            } else if style.id == MiSoftSkeuomorphismModule.styleID {
                MiSoftSkeuomorphismHomePreview(
                    style: style,
                    focus: focus,
                    cardSize: cardSize,
                    cornerRadius: cornerRadius,
                    isDragging: isDragging
                )
            } else if style.id == MiGlassmorphismModule.styleID {
                MiGlassmorphismHomePreview(
                    style: style,
                    focus: focus,
                    cardSize: cardSize,
                    cornerRadius: cornerRadius,
                    isDragging: isDragging
                )
            } else if style.id == MiMinimalismModule.styleID {
                MiMinimalismHomePreview(
                    style: style,
                    focus: focus,
                    cardSize: cardSize,
                    cornerRadius: cornerRadius,
                    isDragging: isDragging
                )
            } else if style.id == MiMaterial3Module.styleID {
                MiMaterial3HomePreview(
                    style: style,
                    focus: focus,
                    cardSize: cardSize,
                    cornerRadius: cornerRadius,
                    isDragging: isDragging
                )
            } else if style.id == MiBentoGridModule.styleID {
                MiBentoGridHomePreview(
                    style: style,
                    focus: focus,
                    cardSize: cardSize,
                    cornerRadius: cornerRadius,
                    isDragging: isDragging
                )
            } else if style.id == MiRefinedDarkModule.styleID {
                MiRefinedDarkHomePreview(
                    style: style,
                    focus: focus,
                    cardSize: cardSize,
                    cornerRadius: cornerRadius,
                    isDragging: isDragging
                )
            } else if style.id == MiEditorialLuxeModule.styleID {
                MiEditorialLuxeHomePreview(
                    style: style,
                    focus: focus,
                    cardSize: cardSize,
                    cornerRadius: cornerRadius,
                    isDragging: isDragging
                )
            } else if style.id == MiHanddrawnVlogModule.styleID {
                MiHanddrawnVlogHomePreview(
                    style: style,
                    focus: focus,
                    cardSize: cardSize,
                    cornerRadius: cornerRadius,
                    isDragging: isDragging
                )
            } else {
                standardCard
            }
        }
        .scaleEffect(focus.scale)
        .opacity(focus.opacity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText)
        .accessibilityAddTraits(.isButton)
    }

    private var standardCard: some View {
        let isLiquidGlassCard = style.id == MiAppleLiquidGlassModule.styleID

        return ZStack(alignment: .bottomLeading) {
            MiHomeCardPreviewSurface(
                style: style,
                focus: focus,
                cornerRadius: cornerRadius,
                isDragging: isDragging
            )

            if let screenshotAssetName = style.screenshotAssetName {
                Image(screenshotAssetName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: cardSize.width, height: cardSize.height)
                    .clipped()
                    .overlay(MiColorTokens.screenshotScrim)

                MiScreenshotCardLabel(style: style, isLiquidGlassCard: isLiquidGlassCard)
                    .padding(MiSpacingTokens.sm)
            } else {
                MiPlaceholderCardContent(style: style, isLiquidGlassCard: isLiquidGlassCard)
                    .padding(MiSpacingTokens.md)
            }
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(isLiquidGlassCard ? min(1.0, focus.borderOpacity + 0.52) : min(0.98, focus.borderOpacity + 0.28)),
                            style.accent.opacity(isLiquidGlassCard ? focus.borderOpacity * 0.74 + 0.10 : focus.borderOpacity * 0.58),
                            Color.white.opacity(isLiquidGlassCard ? 0.30 : 0),
                            Color(hex: 0x8FA5C1).opacity(isLiquidGlassCard ? focus.borderOpacity * 0.20 : focus.borderOpacity * 0.30)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: isLiquidGlassCard ? 1.45 : 1.15
                )
        }
        .modifier(MiHomeCardShadowModifier(style: style, focus: focus, isDragging: isDragging))
    }

    private var accessibilityText: String {
        "\(MiL10n.text(style.name)). \(style.category.title). \(style.screenshotStatus). \(MiL10n.text(style.summary))"
    }
}

private struct MiHomeCardShadowModifier: ViewModifier {
    let style: MiDesignStyle
    let focus: MiCardFocus
    let isDragging: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        let dragMultiplier = isDragging ? 0.42 : 1.0
        let isLiquidGlassCard = style.id == MiAppleLiquidGlassModule.styleID

        content
            .shadow(
                color: style.accent.opacity(focus.shadowOpacity * (isLiquidGlassCard ? 0.60 : 0.48) * dragMultiplier),
                radius: isDragging ? 12 : (isLiquidGlassCard ? 26 : 22),
                x: 0,
                y: isDragging ? 6 : 10
            )
            .shadow(
                color: MiColorTokens.appleBlue500.opacity(focus.shadowOpacity * (isLiquidGlassCard ? 0.34 : 0.22) * dragMultiplier),
                radius: isDragging ? 14 : (isLiquidGlassCard ? 34 : 28),
                x: 0,
                y: isDragging ? 8 : 16
            )
            .shadow(
                color: Color(hex: 0x6C7A90).opacity(focus.shadowOpacity * (isLiquidGlassCard ? 0.34 : 0.58) * dragMultiplier),
                radius: isDragging ? 18 : 32,
                x: 0,
                y: isDragging ? 10 : 20
            )
    }
}

private struct MiHomeCardPreviewSurface: View {
    let style: MiDesignStyle
    let focus: MiCardFocus
    let cornerRadius: CGFloat
    let isDragging: Bool

    @ViewBuilder
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        if style.id == MiAppleLiquidGlassModule.styleID {
            liquidGlassSurface(shape: shape)
        } else {
            standardSurface(shape: shape)
        }
    }

    private func standardSurface(shape: RoundedRectangle) -> some View {
        shape
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.98),
                        MiColorTokens.frost100.opacity(0.90),
                        style.accent.opacity(0.120 + focus.borderOpacity * 0.14)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                shape
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.56 + focus.borderOpacity * 0.13),
                                .clear,
                                style.accent.opacity(0.070)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .overlay(alignment: .top) {
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.94),
                        Color.white.opacity(0.24),
                        .clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 92)
                .allowsHitTesting(false)
            }
            .overlay(alignment: .bottom) {
                LinearGradient(
                    colors: [
                        .clear,
                        style.accent.opacity(0.040),
                        Color.white.opacity(0.56)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .clipShape(shape)
                .allowsHitTesting(false)
            }
    }

    @ViewBuilder
    private func liquidGlassSurface(shape: RoundedRectangle) -> some View {
        let baseGradient = LinearGradient(
            colors: [
                Color.white.opacity(isDragging ? 0.54 : 0.36),
                MiColorTokens.frost050.opacity(isDragging ? 0.44 : 0.22),
                style.accent.opacity(0.11 + focus.borderOpacity * 0.16),
                MiColorTokens.aqua400.opacity(0.08)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        Group {
            if isDragging {
                shape.fill(baseGradient)
            } else {
                shape
                    .fill(.ultraThinMaterial)
                    .overlay {
                        shape.fill(baseGradient)
                    }
            }
        }
        .overlay {
            shape
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.62 + focus.borderOpacity * 0.18),
                            Color.white.opacity(0.18),
                            .clear,
                            style.accent.opacity(0.09)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .overlay(alignment: .top) {
            LinearGradient(
                colors: [
                    Color.white.opacity(0.82),
                    Color.white.opacity(0.22),
                    .clear
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 102)
            .allowsHitTesting(false)
        }
        .overlay(alignment: .bottom) {
            LinearGradient(
                colors: [
                    .clear,
                    Color.white.opacity(0.22),
                    MiColorTokens.frost050.opacity(0.44)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(shape)
            .allowsHitTesting(false)
        }
    }
}

private struct MiPlaceholderCardContent: View {
    let style: MiDesignStyle
    let isLiquidGlassCard: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: MiSpacingTokens.sm) {
            MiCardTitleRow(style: style, isLiquidGlassCard: isLiquidGlassCard)

            Text(MiL10n.text(style.summary))
                .font(.system(size: 11.5, weight: .medium, design: .rounded))
                .lineSpacing(1.6)
                .foregroundStyle(isLiquidGlassCard ? Color(hex: 0x243145).opacity(0.86) : MiColorTokens.contentSecondary)
                .fixedSize(horizontal: false, vertical: true)
                .minimumScaleFactor(0.82)
                .layoutPriority(1)

            Spacer(minLength: 0)
        }
        .overlay(alignment: .bottomLeading) {
            Capsule(style: .continuous)
                .fill(isLiquidGlassCard ? style.accent.opacity(0.72) : style.accent.opacity(0.88))
                .frame(width: 36, height: 4)
                .opacity(isLiquidGlassCard ? 0.88 : 0.72)
        }
    }
}

private struct MiCardTitleRow: View {
    let style: MiDesignStyle
    let isLiquidGlassCard: Bool

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: MiSpacingTokens.xs) {
            Text(shortCode)
                .font(.system(size: 11.5, weight: .black, design: .rounded))
                .foregroundStyle(isLiquidGlassCard ? style.accent : MiColorTokens.obsidian950)
                .padding(.horizontal, 7)
                .frame(height: 22)
                .background {
                    Capsule(style: .continuous)
                        .fill(isLiquidGlassCard ? Color.white.opacity(0.62) : style.accent)
                        .overlay {
                            Capsule(style: .continuous)
                                .strokeBorder(
                                    isLiquidGlassCard ? style.accent.opacity(0.34) : Color.clear,
                                    lineWidth: 1
                                )
                        }
                }

            Text(MiL10n.text(style.name))
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(isLiquidGlassCard ? Color(hex: 0x121A27).opacity(0.96) : MiColorTokens.contentPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.56)
                .miStyleTitleTransition(style.id)
        }
    }

    private var shortCode: String {
        let words = style.name
            .split(separator: " ")
            .prefix(2)
            .compactMap(\.first)
        let code = String(words).uppercased()
        return code.isEmpty ? "MI" : code
    }
}

private struct MiScreenshotCardLabel: View {
    let style: MiDesignStyle
    let isLiquidGlassCard: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: MiSpacingTokens.xs) {
            MiCardTitleRow(style: style, isLiquidGlassCard: isLiquidGlassCard)

            Text(MiL10n.text(style.summary))
                .font(.system(size: 11.5, weight: .medium, design: .rounded))
                .lineSpacing(1.6)
                .foregroundStyle(isLiquidGlassCard ? Color(hex: 0x243145).opacity(0.86) : MiColorTokens.contentSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, MiSpacingTokens.sm)
        .padding(.vertical, MiSpacingTokens.xs)
        .background {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(isLiquidGlassCard ? 0.58 : 0.76))
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(style.accent.opacity(isLiquidGlassCard ? 0.12 : 0.08))
                }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.white.opacity(0.72), lineWidth: 1)
        }
    }
}

#Preview {
    MiStyleCardView(
        style: MiStyleRepository.styles[0],
        focus: MiCardFocus(scale: 1.08, opacity: 1, shadowOpacity: 0.32, borderOpacity: 0.58, zIndex: 10),
        cardSize: MiSpacingTokens.homeCardRegular,
        cornerRadius: MiSpacingTokens.homeCardRadiusRegular
    )
    .padding(80)
    .background(MiColorTokens.appBackground)
}
