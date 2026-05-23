//
//  MiNeoBrutalismHomePreview.swift
//  Mira
//
//  Created on 2026/5/22.
//

import SwiftUI

struct MiNeoBrutalismHomePreview: View {
    let style: MiDesignStyle
    let focus: MiCardFocus
    let cardSize: CGSize
    let cornerRadius: CGFloat
    let isDragging: Bool

    @Environment(\.miHomePressedStyleID) private var pressedStyleID
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(MiNeoBrutalismTokens.ink.opacity(shadowOpacity))
                .frame(width: cardSize.width, height: cardSize.height)
                .offset(x: hardShadow.width, y: hardShadow.height)

            cardContent
                .offset(x: contentPressOffset.width, y: contentPressOffset.height)
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .animation(reduceMotion ? .easeOut(duration: 0.01) : MiNeoBrutalismTokens.motion, value: isPressed)
    }

    private var cardContent: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(MiNeoBrutalismTokens.paper)

            VStack(alignment: .leading, spacing: 13) {
                HStack(alignment: .center, spacing: 9) {
                    Text("NB")
                        .font(.system(size: 12, weight: .black, design: .default))
                        .foregroundStyle(MiNeoBrutalismTokens.ink)
                        .padding(.horizontal, 9)
                        .frame(height: 25)
                        .background {
                            MiNeoBrutalismSurface(
                                shape: RoundedRectangle(cornerRadius: 8, style: .continuous),
                                fill: MiNeoBrutalismTokens.yellow,
                                lineWidth: 2,
                                shadow: CGSize(width: 2, height: 2)
                            )
                        }

                    Text(MiL10n.text(style.name))
                        .font(.system(size: 20, weight: .black, design: .default))
                        .foregroundStyle(MiNeoBrutalismTokens.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.58)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Text(MiL10n.text("nb_card_summary"))
                    .font(.system(size: 14.5, weight: .black, design: .default))
                    .foregroundStyle(MiNeoBrutalismTokens.muted)
                    .lineSpacing(2.4)
                    .lineLimit(3)
                    .minimumScaleFactor(0.74)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)

                MiNeoBrutalismHomeActionStrip(isPressed: isPressed)
            }
            .padding(15)
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay(alignment: .bottomTrailing) {
            MiNeoBrutalismHomeTiltedTile()
                .frame(width: 56, height: 56)
                .rotationEffect(.degrees(-8))
                .padding(.trailing, 20)
                .padding(.bottom, 66)
        }
        .overlay(alignment: .bottomLeading) {
            MiNeoBrutalismHomeRail()
                .frame(width: cardSize.width * 0.58, height: 36)
                .padding(.leading, 14)
                .padding(.bottom, 58)
        }
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(MiNeoBrutalismTokens.ink, lineWidth: MiNeoBrutalismTokens.lineWidth)
        }
    }

    private var hardShadow: CGSize {
        let base = CGFloat(max(5.0, 5.0 + focus.shadowOpacity * 12.0))
        let dragScale: CGFloat = isDragging ? 0.55 : 1
        return CGSize(width: base * dragScale, height: base * dragScale)
    }

    private var contentPressOffset: CGSize {
        guard isPressed, !reduceMotion else {
            return .zero
        }

        let distance = min(max(hardShadow.width - 1.5, 4), 7)
        return CGSize(width: distance, height: distance)
    }

    private var shadowOpacity: Double {
        if isDragging {
            return 0.32
        }
        return isPressed ? 0.46 : 0.82
    }

    private var isPressed: Bool {
        pressedStyleID == style.id
    }
}

private struct MiNeoBrutalismHomeActionStrip: View {
    let isPressed: Bool

    var body: some View {
        HStack(spacing: 8) {
            Text(MiL10n.text("nb_open_style"))
                .font(.system(size: 12, weight: .black, design: .default))
                .foregroundStyle(Color.white)
                .lineLimit(1)

            Spacer(minLength: 0)

            Image(systemName: "arrow.right")
                .font(.system(size: 12, weight: .black))
                .foregroundStyle(Color.white)
        }
        .padding(.horizontal, 12)
        .frame(height: 34)
        .background {
            MiNeoBrutalismSurface(
                shape: RoundedRectangle(cornerRadius: 10, style: .continuous),
                fill: MiNeoBrutalismTokens.blue,
                lineWidth: 2,
                shadow: isPressed ? .zero : CGSize(width: 4, height: 4)
            )
        }
    }
}

private struct MiNeoBrutalismHomeRail: View {
    var body: some View {
        HStack(spacing: 7) {
            MiNeoBrutalismHomeDot(fill: MiNeoBrutalismTokens.blue)
            MiNeoBrutalismHomeDot(fill: MiNeoBrutalismTokens.green)
            MiNeoBrutalismHomeDot(fill: MiNeoBrutalismTokens.orange)
        }
        .padding(8)
        .background {
            MiNeoBrutalismSurface(
                shape: RoundedRectangle(cornerRadius: 14, style: .continuous),
                fill: MiNeoBrutalismTokens.greenSoft,
                lineWidth: 2,
                shadow: CGSize(width: 4, height: 4)
            )
        }
    }
}

private struct MiNeoBrutalismHomeColorBlock: View {
    let fill: Color

    var body: some View {
        MiNeoBrutalismSurface(
            shape: RoundedRectangle(cornerRadius: 13, style: .continuous),
            fill: fill,
            lineWidth: 2,
            shadow: CGSize(width: 4, height: 4)
        )
    }
}

private struct MiNeoBrutalismHomeTiltedTile: View {
    var body: some View {
        MiNeoBrutalismHomeColorBlock(fill: MiNeoBrutalismTokens.orangeSoft)
    }
}

private struct MiNeoBrutalismHomeDot: View {
    let fill: Color

    var body: some View {
        MiNeoBrutalismSurface(
            shape: RoundedRectangle(cornerRadius: 6, style: .continuous),
            fill: fill,
            lineWidth: 2,
            shadow: CGSize(width: 3, height: 3)
        )
        .frame(height: 14)
    }
}
