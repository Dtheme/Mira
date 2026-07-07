//
//  MiAppleLiquidGlassHomePreview.swift
//  Mira
//

import SwiftUI

struct MiAppleLiquidGlassHomePreview: View {
    let style: MiDesignStyle
    let focus: MiCardFocus
    let cardSize: CGSize
    let cornerRadius: CGFloat
    let isDragging: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.miHomePressedStyleID) private var pressedStyleID

    private var isPressed: Bool { pressedStyleID == style.id && !isDragging }

    // Concept geometry is authored for the 174x222 compact card; scale from cardSize.
    private var sw: CGFloat { cardSize.width / 174 }
    private var sh: CGFloat { cardSize.height / 222 }

    private var capsuleWidth: CGFloat { cardSize.width - 28 * sw }
    private var capsuleHeight: CGFloat { 54 * sh }
    private var capsuleOrigin: CGPoint { CGPoint(x: 14 * sw, y: 132 * sh) }
    private var photoSize: CGSize { CGSize(width: 82 * sw, height: 60 * sh) }
    private var photoOrigin: CGPoint { CGPoint(x: cardSize.width - (16 + 82) * sw, y: 76 * sh) }

    private let titleInk = Color(hex: 0x121A27)
    private let hookInk = Color(hex: 0x354154)
    private let shadowSlate = Color(hex: 0x6C7A90)

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        ZStack(alignment: .topLeading) {
            frostPage(shape)
            ghostContent
            refractionCue
            dockCapsule
                .offset(x: capsuleOrigin.x, y: capsuleOrigin.y)
        }
        .frame(width: cardSize.width, height: cardSize.height, alignment: .topLeading)
        .clipShape(shape)
        .overlay {
            shape.strokeBorder(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.85 + focus.borderOpacity * 0.15),
                        MiColorTokens.appleBlue500.opacity(0.10 + focus.borderOpacity * 0.30),
                        Color.white.opacity(0.24)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1.2
            )
        }
        .shadow(
            color: shadowSlate.opacity(focus.shadowOpacity * (isDragging ? 0.40 : 0.50)),
            radius: isDragging ? 10 : 24,
            x: 0,
            y: isDragging ? 6 : 14
        )
        .shadow(
            color: MiColorTokens.appleBlue500.opacity(isDragging ? 0 : focus.shadowOpacity * 0.18),
            radius: 30,
            x: 0,
            y: 18
        )
    }

    // Opaque frost paper: this card is the content layer, deliberately not glass.
    private func frostPage(_ shape: RoundedRectangle) -> some View {
        shape
            .fill(Color.white)
            .overlay {
                shape.fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.99),
                            MiColorTokens.frost050,
                            MiColorTokens.frost100.opacity(0.92)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .overlay(alignment: .top) {
                LinearGradient(
                    colors: [Color.white.opacity(0.80), Color.white.opacity(0.16), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 72 * sh)
            }
            .allowsHitTesting(false)
    }

    private var ghostContent: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 5) {
                Text(MiL10n.text(style.name))
                    .font(.system(size: 18 * sw, weight: .semibold))
                    .foregroundStyle(titleInk.opacity(0.95))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .miStyleTitleTransition(style.id)

                Text(MiL10n.text("home_alg_short"))
                    .font(.system(size: 11 * sw, weight: .medium))
                    .foregroundStyle(hookInk.opacity(0.72))
                    .lineSpacing(2)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 18 * sh)
            .padding(.horizontal, MiSpacingTokens.md * sw)

            photoBlock(bright: false)
                .offset(x: photoOrigin.x, y: photoOrigin.y)

            ghostBar(width: 46 * sw, y: 84 * sh, bright: false)
            ghostBar(width: 38 * sw, y: 97 * sh, bright: false)
            ghostBar(width: 30 * sw, y: 110 * sh, bright: false)
            ghostBar(width: cardSize.width * 0.72, y: 158 * sh, bright: false)
        }
    }

    // Static refraction: page content re-appears through the capsule, shifted up
    // 1.5 pt and brightened. Duplicates clipped to the capsule shape, no blur.
    private var refractionCue: some View {
        ZStack(alignment: .topLeading) {
            photoBlock(bright: true)
                .offset(x: photoOrigin.x, y: photoOrigin.y - 1.5)

            ghostBar(width: cardSize.width * 0.72, y: 158 * sh - 1.5, bright: true)
        }
        .frame(width: cardSize.width, height: cardSize.height, alignment: .topLeading)
        .mask(alignment: .topLeading) {
            Capsule(style: .continuous)
                .frame(width: capsuleWidth, height: capsuleHeight)
                .offset(x: capsuleOrigin.x, y: capsuleOrigin.y)
        }
        .allowsHitTesting(false)
    }

    private func photoBlock(bright: Bool) -> some View {
        let shape = RoundedRectangle(cornerRadius: 14 * sw, style: .continuous)

        return shape
            .fill(Color.white)
            .overlay {
                shape.fill(
                    LinearGradient(
                        colors: [
                            MiColorTokens.appleBlue500.opacity(0.14),
                            MiColorTokens.appleBlue500.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            }
            .overlay {
                if bright {
                    shape.fill(Color.white.opacity(0.35))
                    shape.fill(MiColorTokens.appleBlue500.opacity(0.10))
                }
            }
            .overlay {
                shape.strokeBorder(Color.white.opacity(0.6), lineWidth: 1)
            }
            .frame(width: photoSize.width, height: photoSize.height)
    }

    private func ghostBar(width: CGFloat, y: CGFloat, bright: Bool) -> some View {
        let shape = RoundedRectangle(cornerRadius: 3, style: .continuous)

        return shape
            .fill(MiColorTokens.graphite900.opacity(0.12))
            .overlay {
                if bright {
                    shape.fill(Color.white.opacity(0.35))
                    shape.fill(MiColorTokens.appleBlue500.opacity(0.10))
                }
            }
            .frame(width: width, height: 6 * sh)
            .offset(x: 16 * sw, y: y)
    }

    // Signature: the one glass object on the card, a floating shell dock capsule.
    private var dockCapsule: some View {
        let capShape = Capsule(style: .continuous)

        return HStack(spacing: 0) {
            browseLens

            Image(systemName: "slider.horizontal.3")
                .font(.system(size: 14 * sw, weight: .medium))
                .foregroundStyle(hookInk.opacity(0.45))
                .padding(.leading, 14 * sw)

            Image(systemName: "ellipsis")
                .font(.system(size: 14 * sw, weight: .medium))
                .foregroundStyle(hookInk.opacity(0.45))
                .padding(.leading, 20 * sw)

            Spacer(minLength: 0)
        }
        .padding(.leading, 12 * sw)
        .frame(width: capsuleWidth, height: capsuleHeight)
        .background {
            ZStack {
                capsuleSurface(capShape)
                capShape.fill(MiColorTokens.appleBlue500.opacity(isPressed ? 0.16 : 0.08))
            }
        }
        .overlay(alignment: .top) {
            Capsule(style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.9), Color.white.opacity(0.12)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: capsuleWidth * 0.6, height: 5 * sh)
                .padding(.top, 3)
                .opacity(isDragging ? 0.4 : 1)
                .blur(radius: isDragging ? 0 : 2)
        }
        .overlay {
            capShape.strokeBorder(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.95),
                        MiColorTokens.appleBlue500.opacity(0.35),
                        Color.white.opacity(0.25)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1.2
            )
        }
        .shadow(
            color: shadowSlate.opacity(focus.shadowOpacity * (isDragging ? 0.30 : 0.45)),
            radius: isDragging ? 8 : (isPressed && !reduceMotion ? 12 : 16),
            x: 0,
            y: isDragging ? 5 : (isPressed && !reduceMotion ? 6 : 9)
        )
        .shadow(
            color: MiColorTokens.appleBlue500.opacity(isDragging ? 0 : focus.shadowOpacity * 0.22),
            radius: 26,
            x: 0,
            y: 14
        )
        .scaleEffect(isPressed && !reduceMotion ? 0.97 : 1)
        .animation(reduceMotion ? .easeOut(duration: 0.01) : .easeOut(duration: 0.16), value: isPressed)
    }

    // Capsule fill is the only expensive pass, double-gated per the perf plan:
    // iOS 26 glass when idle, material fallback below 26, flat gradient while dragging.
    @ViewBuilder
    private func capsuleSurface(_ capShape: Capsule) -> some View {
        if isDragging {
            capShape.fill(
                LinearGradient(
                    colors: [Color.white.opacity(0.78), MiColorTokens.frost050.opacity(0.60)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        } else if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            Color.clear
                .glassEffect(
                    .regular.tint(MiColorTokens.appleBlue500.opacity(0.10)),
                    in: capShape
                )
        } else {
            capShape
                .fill(.ultraThinMaterial)
                .overlay {
                    capShape.fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.55), MiColorTokens.frost050.opacity(0.30)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
        }
    }

    // Active control: a browse lens (grid glyph), deliberately not a search field.
    private var browseLens: some View {
        let diameter = 38 * sw

        return ZStack {
            Circle().fill(
                RadialGradient(
                    colors: [Color.white.opacity(0.92), MiColorTokens.appleBlue500.opacity(0.16)],
                    center: .center,
                    startRadius: 0,
                    endRadius: diameter / 2
                )
            )

            Circle().strokeBorder(
                LinearGradient(
                    colors: [Color.white.opacity(0.95), MiColorTokens.appleBlue500.opacity(0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1
            )

            // Trim 0.55-0.80 places the static specular arc over the top-left rim.
            Circle()
                .trim(from: 0.55, to: 0.80)
                .stroke(Color.white.opacity(0.9), lineWidth: 1.5)
                .padding(2.5)
                .opacity(isPressed ? 1.0 : 0.7)

            Image(systemName: "square.grid.2x2")
                .font(.system(size: 15 * sw, weight: .semibold))
                .foregroundStyle(MiColorTokens.appleBlue500)
        }
        .frame(width: diameter, height: diameter)
    }
}
