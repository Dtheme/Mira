//
//  MiDemoEntryCard.swift
//  Mira
//
//  Created on 2026/6/29.
//
//  Home entry to the Demo area. Intentionally an iOS system flat-style card
//  (not a Liquid-Glass capsule) so it reads as a native "system entry".
//

import SwiftUI
import UIKit

struct MiDemoEntryCard: View {
    let action: () -> Void

    private let accent = Color(hex: 0x6C5CE7)

    var body: some View {
        Button(action: action) {
            HStack(spacing: MiSpacingTokens.sm) {
                Image(systemName: "sparkles")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(accent)
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(accent.opacity(0.14))
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(MiL10n.text("demo_area_title"))
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiColorTokens.contentPrimary)
                    Text(MiL10n.text("demo_area_subtitle"))
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(MiColorTokens.contentSecondary)
                        .lineLimit(1)
                }

                Spacer(minLength: MiSpacingTokens.xs)

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(MiColorTokens.contentMuted)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.07), radius: 12, x: 0, y: 5)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(MiL10n.text("demo_area_title"))
        .accessibilityHint(MiL10n.text("demo_area_subtitle"))
    }
}
