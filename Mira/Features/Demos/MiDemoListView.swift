//
//  MiDemoListView.swift
//  Mira
//
//  Created on 2026/6/29.
//
//  Full-screen demo list. Flat iOS-system styling to match the home entry card.
//  Presented via the app's existing dissolve route (no NavigationStack).
//

import SwiftUI
import UIKit

struct MiDemoListView: View {
    let demos: [MiDemo]
    let onSelect: (MiDemo) -> Void
    let onBack: () -> Void

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollView {
                    LazyVStack(spacing: MiSpacingTokens.sm) {
                        ForEach(demos) { demo in
                            Button {
                                if demo.isReady { onSelect(demo) }
                            } label: {
                                MiDemoRow(demo: demo)
                            }
                            .buttonStyle(.plain)
                            .disabled(!demo.isReady)
                        }
                    }
                    .padding(.horizontal, MiSpacingTokens.md)
                    .padding(.top, MiSpacingTokens.md)
                }
            }
        }
    }

    private var header: some View {
        ZStack {
            Text(MiL10n.text("demo_list_title"))
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundStyle(MiColorTokens.contentPrimary)

            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(MiColorTokens.contentPrimary)
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(Color(.secondarySystemGroupedBackground)))
                }
                .accessibilityLabel(MiL10n.text("demo_back"))
                Spacer()
            }
        }
        .padding(.horizontal, MiSpacingTokens.md)
        .padding(.vertical, MiSpacingTokens.xs)
    }
}

private struct MiDemoRow: View {
    let demo: MiDemo

    var body: some View {
        HStack(spacing: MiSpacingTokens.sm) {
            Image(systemName: demo.systemImage)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(demo.accent)
                .frame(width: 48, height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(demo.accent.opacity(0.14))
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(MiL10n.text(demo.titleKey))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiColorTokens.contentPrimary)
                Text(MiL10n.text(demo.subtitleKey))
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(MiColorTokens.contentSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: MiSpacingTokens.xs)

            Image(systemName: demo.isReady ? "chevron.right" : "hammer.fill")
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
                .strokeBorder(Color.black.opacity(0.05), lineWidth: 1)
        )
        .opacity(demo.isReady ? 1 : 0.6)
    }
}
