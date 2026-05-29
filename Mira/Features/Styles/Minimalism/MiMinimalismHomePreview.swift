//
//  MiMinimalismHomePreview.swift
//  Mira
//
//  Created on 2026/5/25.
//

import SwiftUI

struct MiMinimalismHomePreview: View {
    let style: MiDesignStyle
    let focus: MiCardFocus
    let cardSize: CGSize
    let cornerRadius: CGFloat
    let isDragging: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(MiMinimalismTokens.paper)
                .overlay {
                    MiMinimalismGrid(step: 18, color: MiMinimalismTokens.hairline.opacity(0.50))
                }

            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .firstTextBaseline) {
                    Text("01")
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .foregroundStyle(MiMinimalismTokens.muted)
                    Spacer()
                    Rectangle()
                        .fill(MiMinimalismTokens.ink)
                        .frame(width: 28, height: 2)
                }

                Text(MiL10n.text(style.name))
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(MiMinimalismTokens.ink)
                    .lineLimit(2)
                    .minimumScaleFactor(0.64)
                    .miStyleTitleTransition(style.id)

                Text(MiL10n.text(style.summary))
                    .font(.system(size: 11.5, weight: .regular))
                    .foregroundStyle(MiMinimalismTokens.muted)
                    .lineSpacing(2.5)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)

                HStack(spacing: 8) {
                    Rectangle().fill(MiMinimalismTokens.ink).frame(width: 34, height: 6)
                    Rectangle().fill(MiMinimalismTokens.hairline).frame(width: 42, height: 6)
                    Rectangle().fill(MiMinimalismTokens.accent).frame(width: 18, height: 6)
                }
            }
            .padding(20)
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(MiMinimalismTokens.ink.opacity(0.90), lineWidth: focus.borderOpacity > 0.4 ? 1.4 : 1)
        }
        .shadow(color: MiMinimalismTokens.ink.opacity(focus.shadowOpacity * (isDragging ? 0.12 : 0.22)), radius: isDragging ? 4 : 13, x: 0, y: isDragging ? 3 : 10)
    }
}
