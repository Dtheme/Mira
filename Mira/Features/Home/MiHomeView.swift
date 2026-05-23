//
//  MiHomeView.swift
//  Mira
//
//  Created on 2026/5/22.
//

import SwiftUI

struct MiHomeView: View {
    let styles: [MiDesignStyle]
    let onSelectStyle: (MiDesignStyle) -> Void

    @State private var searchText = ""
    @State private var selectedCategory: MiStyleCategory?
    @State private var resetSignal = 0
    @State private var focusedSearchStyleID: String?
    @State private var searchFocusSignal = 0

    private var filteredStyleIDs: Set<String> {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return Set(
            styles
                .filter { style in
                    let matchesQuery = query.isEmpty
                        || MiL10n.text(style.name).lowercased().contains(query)
                        || MiL10n.text(style.localizedName).lowercased().contains(query)
                        || MiL10n.text(style.summary).lowercased().contains(query)
                    let matchesCategory = selectedCategory == nil || style.category == selectedCategory
                    return matchesQuery && matchesCategory
                }
                .map(\.id)
        )
    }

    private var bestMatchingStyleID: String? {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !query.isEmpty else {
            return nil
        }

        return styles
            .filter { selectedCategory == nil || $0.category == selectedCategory }
            .map { style in
                (style: style, score: matchScore(for: style, query: query))
            }
            .filter { $0.score > 0 }
            .max { lhs, rhs in lhs.score < rhs.score }?
            .style
            .id
    }

    var body: some View {
        GeometryReader { _ in
            ZStack {
                MiColorTokens.appBackground
                    .ignoresSafeArea()

                MiSystemLiquidBackdrop()

                MiStyleConstellationView(
                    styles: styles,
                    highlightedStyleIDs: filteredStyleIDs,
                    focusedStyleID: focusedSearchStyleID,
                    focusSignal: searchFocusSignal,
                    resetSignal: resetSignal,
                    onSelectStyle: onSelectStyle
                )
                .ignoresSafeArea()

                VStack(spacing: MiSpacingTokens.md) {
                    MiHomeHeaderView(
                        searchText: $searchText,
                        selectedCategory: $selectedCategory,
                        resetSignal: $resetSignal
                    )
                    .padding(.horizontal, MiSpacingTokens.md)
                    .padding(.top, 4)

                    Spacer()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: searchText) {
            updateSearchFocus()
        }
        .onChange(of: selectedCategory) {
            updateSearchFocus()
        }
    }

    private func updateSearchFocus() {
        focusedSearchStyleID = bestMatchingStyleID
        if focusedSearchStyleID != nil {
            searchFocusSignal += 1
        }
    }

    private func matchScore(for style: MiDesignStyle, query: String) -> Int {
        let name = MiL10n.text(style.name).lowercased()
        let localizedName = MiL10n.text(style.localizedName).lowercased()
        let slug = style.slug.lowercased()
        let summary = MiL10n.text(style.summary).lowercased()
        let category = style.category.title.lowercased()

        if name == query || localizedName == query || slug == query {
            return 1000
        }
        if name.hasPrefix(query) || localizedName.hasPrefix(query) || slug.hasPrefix(query) {
            return 820
        }
        if name.contains(query) || localizedName.contains(query) || slug.contains(query) {
            return 640
        }
        if summary.contains(query) {
            return 360
        }
        if category.contains(query) {
            return 220
        }
        return 0
    }
}

private struct MiSystemLiquidBackdrop: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(hex: 0xF2F7FF))

            LinearGradient(
                colors: [
                    Color.white.opacity(0.74),
                    MiColorTokens.frost100.opacity(0.78),
                    MiColorTokens.appleBlue500.opacity(0.090),
                    MiColorTokens.aqua400.opacity(0.060)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            LinearGradient(
                colors: [
                    Color.white.opacity(0.64),
                    .clear,
                    MiColorTokens.frost100.opacity(0.58)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            LinearGradient(
                colors: [
                    MiColorTokens.iris500.opacity(0.045),
                    .clear,
                    MiColorTokens.aqua400.opacity(0.048)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
        .overlay(alignment: .top) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.72),
                            MiColorTokens.appleBlue500.opacity(0.066),
                            .clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 180)
            }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            .clear,
                            MiColorTokens.frost100.opacity(0.64)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 220)
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
    }
}

private struct MiHomeHeaderView: View {
    @Binding var searchText: String
    @Binding var selectedCategory: MiStyleCategory?
    @Binding var resetSignal: Int

    var body: some View {
        MiAppleLiquidGlassSearchControl(text: $searchText, role: .home) {
            searchText = ""
            selectedCategory = nil
            resetSignal += 1
        }
    }
}

private struct MiCategoryChipView: View {
    let title: String
    let isSelected: Bool
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(MiL10n.text(title))
                .font(MiTypographyTokens.label)
                .foregroundStyle(isSelected ? MiColorTokens.obsidian950 : MiColorTokens.contentPrimary)
                .lineLimit(1)
                .padding(.horizontal, MiSpacingTokens.md)
                .frame(height: 36)
        }
        .buttonStyle(.plain)
        .background {
            Capsule(style: .continuous)
                .fill(isSelected ? tint : MiColorTokens.frost050.opacity(0.08))
        }
        .overlay {
            Capsule(style: .continuous)
                .strokeBorder(tint.opacity(isSelected ? 0.65 : 0.28), lineWidth: 1)
        }
        .accessibilityValue(MiL10n.text(isSelected ? "c_selected" : "c_not_selected"))
    }
}

#Preview {
    MiHomeView(styles: MiStyleRepository.styles) { _ in }
}
