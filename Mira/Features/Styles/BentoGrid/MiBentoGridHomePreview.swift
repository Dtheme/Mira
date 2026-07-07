//
//  MiBentoGridHomePreview.swift
//  Mira
//

import SwiftUI

struct MiBentoGridHomePreview: View {
    let style: MiDesignStyle
    let focus: MiCardFocus
    let cardSize: CGSize
    let cornerRadius: CGFloat
    let isDragging: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.miHomePressedStyleID) private var pressedStyleID

    private var isPressed: Bool { pressedStyleID == style.id && !isDragging }

    private var m: MiBentoBoardMetrics { MiBentoBoardMetrics(cardSize: cardSize) }

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        ZStack {
            shape.fill(MiBentoGridTokens.canvas)
            board
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .clipShape(shape)
        .overlay {
            shape.strokeBorder(
                MiBentoGridTokens.stroke.opacity(0.55 + 0.35 * focus.borderOpacity),
                lineWidth: 1
            )
        }
        .shadow(
            color: MiBentoGridTokens.ink.opacity((isDragging ? 0.05 : 0.09) * focus.shadowOpacity),
            radius: isDragging ? 7 : 16,
            x: 0,
            y: isPressed ? 6 : 10
        )
        .animation(
            reduceMotion ? .easeOut(duration: 0.12) : .spring(response: 0.26, dampingFraction: 0.85),
            value: isPressed
        )
    }

    private var board: some View {
        Grid(horizontalSpacing: m.gutter, verticalSpacing: m.gutter) {
            GridRow {
                heroTile
                    .gridCellColumns(2)
                rightColumn
            }
            GridRow {
                dotCell
                skeletonCell
                    .gridCellColumns(2)
            }
            GridRow {
                titleTile
                    .gridCellColumns(3)
            }
        }
        .padding(m.inset)
    }

    private var heroTile: some View {
        let cellShape = RoundedRectangle(cornerRadius: m.cellRadius, style: .continuous)
        return cellShape
            .fill(MiBentoGridTokens.accent)
            .overlay {
                cellShape.fill(MiBentoGridTokens.ink.opacity(isPressed ? 0.06 : 0))
            }
            .overlay {
                VStack(alignment: .leading, spacing: 0) {
                    Text(MiL10n.text("bento_cell_hero"))
                        .font(.system(size: 9 * m.scale, weight: .heavy, design: .rounded))
                        .tracking(1.3)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.white.opacity(0.72))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer(minLength: 0)

                    HStack(alignment: .bottom, spacing: 0) {
                        Text("128")
                            .font(.system(size: m.heroNumeralSize, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        Spacer(minLength: 4 * m.scale)
                        sparkBars
                    }
                }
                .padding(11 * m.scale)
            }
            .frame(width: m.heroW, height: m.heroH)
            .scaleEffect(isPressed && !reduceMotion ? 0.965 : 1)
            .shadow(
                color: MiBentoGridTokens.accent.opacity(isDragging ? 0 : (isPressed ? 0.24 : 0.30)),
                radius: isPressed ? 5 : 9,
                x: 0,
                y: isPressed ? 2 : 5
            )
    }

    private var sparkBars: some View {
        let heights: [CGFloat] = [10, 17, 13, 21]
        return HStack(alignment: .bottom, spacing: 3.5 * m.scale) {
            ForEach(Array(heights.enumerated()), id: \.offset) { _, height in
                RoundedRectangle(cornerRadius: 2 * m.scale, style: .continuous)
                    .fill(Color.white.opacity(0.78))
                    .frame(width: 4.5 * m.scale, height: height * m.scale)
            }
        }
    }

    private var rightColumn: some View {
        VStack(spacing: m.gutter) {
            cell(MiBentoGridTokens.surface, stroked: true)
                .overlay {
                    Circle()
                        .stroke(MiBentoGridTokens.accent2, lineWidth: 3.5 * m.scale)
                        .frame(width: 17 * m.scale, height: 17 * m.scale)
                }
            cell(MiBentoGridTokens.surfaceAlt)
                .overlay {
                    RoundedRectangle(cornerRadius: 2 * m.scale, style: .continuous)
                        .fill(MiBentoGridTokens.muted.opacity(0.35))
                        .frame(width: 20 * m.scale, height: 3.5 * m.scale)
                }
        }
        .frame(width: m.colW, height: m.heroH)
    }

    private var dotCell: some View {
        cell(MiBentoGridTokens.surfaceAlt)
            .overlay {
                RoundedRectangle(cornerRadius: 3 * m.scale, style: .continuous)
                    .fill(MiBentoGridTokens.ink.opacity(0.12))
                    .frame(width: 10 * m.scale, height: 10 * m.scale)
            }
            .frame(width: m.colW, height: m.midH)
    }

    private var skeletonCell: some View {
        cell(MiBentoGridTokens.surface, stroked: true)
            .overlay(alignment: .leading) {
                VStack(alignment: .leading, spacing: 5 * m.scale) {
                    skeletonLine(width: 56 * m.scale, opacity: 0.30)
                    skeletonLine(width: 36 * m.scale, opacity: 0.18)
                }
                .padding(.leading, 12 * m.scale)
            }
            .frame(width: m.heroW, height: m.midH)
    }

    private var titleTile: some View {
        cell(MiBentoGridTokens.surface, stroked: true)
            .overlay {
                HStack(spacing: 0) {
                    Text(MiL10n.text(style.name))
                        .font(.system(size: m.titleSize, weight: .bold, design: .rounded))
                        .foregroundStyle(MiBentoGridTokens.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .miStyleTitleTransition(style.id)

                    Spacer(minLength: 6 * m.scale)

                    microGrid
                }
                .padding(.horizontal, 12 * m.scale)
            }
            .frame(width: m.boardW, height: m.titleH)
    }

    private var microGrid: some View {
        VStack(spacing: 2.5 * m.scale) {
            ForEach(0..<2, id: \.self) { _ in
                HStack(spacing: 2.5 * m.scale) {
                    ForEach(0..<2, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 1.5 * m.scale, style: .continuous)
                            .fill(MiBentoGridTokens.ink.opacity(0.16))
                            .frame(width: 4 * m.scale, height: 4 * m.scale)
                    }
                }
            }
        }
    }

    private func skeletonLine(width: CGFloat, opacity: Double) -> some View {
        RoundedRectangle(cornerRadius: 2 * m.scale, style: .continuous)
            .fill(MiBentoGridTokens.muted.opacity(opacity))
            .frame(width: width, height: 3.5 * m.scale)
    }

    private func cell(_ fill: Color, stroked: Bool = false) -> some View {
        RoundedRectangle(cornerRadius: m.cellRadius, style: .continuous)
            .fill(fill)
            .overlay {
                if stroked {
                    RoundedRectangle(cornerRadius: m.cellRadius, style: .continuous)
                        .strokeBorder(MiBentoGridTokens.stroke, lineWidth: 1)
                }
            }
    }
}

// Board geometry derived from cardSize; base values are for the 174x222 compact card.
private struct MiBentoBoardMetrics {
    let scale: CGFloat
    let inset: CGFloat
    let gutter: CGFloat
    let cellRadius: CGFloat
    let boardW: CGFloat
    let boardH: CGFloat
    let colW: CGFloat
    let heroW: CGFloat
    let heroH: CGFloat
    let midH: CGFloat
    let titleH: CGFloat
    let heroNumeralSize: CGFloat
    let titleSize: CGFloat

    init(cardSize: CGSize) {
        scale = cardSize.width / 174
        inset = 10 * scale
        gutter = 7 * scale
        cellRadius = 12 * scale
        boardW = cardSize.width - inset * 2
        boardH = cardSize.height - inset * 2
        colW = (boardW - gutter * 2) / 3
        heroW = colW * 2 + gutter
        heroH = boardH * 0.425
        midH = boardH * 0.225
        titleH = boardH - heroH - midH - gutter * 2
        heroNumeralSize = min(max(cardSize.width * 0.165, 28), 34)
        titleSize = min(max(cardSize.width * 0.10, 17), 21)
    }
}
