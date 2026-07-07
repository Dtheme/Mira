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
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(MiNeoBrutalismTokens.ink.opacity(outerShadowOpacity))
                .frame(width: cardSize.width, height: cardSize.height)
                .offset(x: outerShadow.width, y: outerShadow.height)

            cardContent
                .offset(x: contentPressOffset.width, y: contentPressOffset.height)
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .animation(reduceMotion ? .easeOut(duration: 0.01) : MiNeoBrutalismTokens.motion, value: isPressed)
    }

    private var cardContent: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(MiNeoBrutalismTokens.yellow)

            arrowSlab
                .position(x: cardSize.width * 0.55, y: cardSize.height * 0.42)
        }
        .overlay(alignment: .topLeading) {
            stampPlate
                .padding(15 * metricScale)
        }
        .overlay(alignment: .bottomLeading) {
            titleBlock
                .padding(15 * metricScale)
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(MiNeoBrutalismTokens.ink, lineWidth: MiNeoBrutalismTokens.lineWidth)
        }
    }

    private var arrowSlab: some View {
        let side = cardSize.width * 0.56

        return MiNeoBrutalismSurface(
            shape: RoundedRectangle(cornerRadius: MiNeoBrutalismTokens.radiusSM, style: .continuous),
            fill: MiNeoBrutalismTokens.surface,
            shadow: slabShadow
        )
        .overlay {
            Image(systemName: "arrow.right")
                .font(.system(size: side * 0.42, weight: .black))
                .foregroundStyle(MiNeoBrutalismTokens.ink)
        }
        .frame(width: side, height: side)
        // Offset before rotation so the press translation follows the rotated shadow direction.
        .offset(x: slabPressOffset.width, y: slabPressOffset.height)
        .rotationEffect(.degrees(-4))
    }

    private var stampPlate: some View {
        Text(MiL10n.text("nb_card_monogram"))
            .font(.system(size: 12 * metricScale, weight: .black, design: .default))
            .foregroundStyle(MiNeoBrutalismTokens.yellow)
            .padding(.horizontal, 8 * metricScale)
            .frame(height: 24 * metricScale)
            .background {
                RoundedRectangle(cornerRadius: MiNeoBrutalismTokens.radiusXS, style: .continuous)
                    .fill(MiNeoBrutalismTokens.ink)
            }
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 4 * metricScale) {
            Text(MiL10n.text(style.name))
                .font(.system(size: 21 * metricScale, weight: .black, design: .default))
                .foregroundStyle(MiNeoBrutalismTokens.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .miStyleTitleTransition(style.id)

            Text(MiL10n.text("nb_card_shadow_spec"))
                .font(.system(size: 10.5 * metricScale, weight: .heavy, design: .default))
                .tracking(0.8)
                .foregroundStyle(MiNeoBrutalismTokens.ink.opacity(0.85))
                .lineLimit(1)
        }
    }

    private var metricScale: CGFloat {
        cardSize.width / 174
    }

    private var outerShadow: CGSize {
        let base = CGFloat(max(5.0, 5.0 + focus.shadowOpacity * 12.0))
        let dragScale: CGFloat = isDragging ? 0.55 : 1
        return CGSize(width: base * dragScale, height: base * dragScale)
    }

    private var outerShadowOpacity: Double {
        if isDragging {
            return 0.32
        }
        return isPressed ? 0.46 : 0.82
    }

    private var contentPressOffset: CGSize {
        guard isPressed, !reduceMotion else {
            return .zero
        }

        let distance = min(max(outerShadow.width - 1.5, 4), 7)
        return CGSize(width: distance, height: distance)
    }

    // Resting 7x7 must stay fixed so the printed "7x7 · NO BLUR" spec matches reality at every card size.
    private var slabShadow: CGSize {
        if isPressed {
            return .zero
        }
        return isDragging ? MiNeoBrutalismTokens.shadowSmall : MiNeoBrutalismTokens.homeSlabShadow
    }

    private var slabPressOffset: CGSize {
        guard isPressed, !reduceMotion else {
            return .zero
        }
        return MiNeoBrutalismTokens.homeSlabShadow
    }

    private var isPressed: Bool {
        pressedStyleID == style.id && !isDragging
    }
}
