//
//  MiAppRootView.swift
//  Mira
//
//  Created on 2026/5/22.
//

import SwiftUI
import AlertToast

struct MiAppRootView: View {
    @State private var selectedStyle: MiDesignStyle?
    @State private var unavailableStyle: MiDesignStyle?
    @State private var showsUnavailableToast = false

    var body: some View {
        NavigationStack {
            MiHomeView(styles: MiStyleRepository.styles) { style in
                if MiAppleLiquidGlassModule.canOpen(style) || MiNeumorphismModule.canOpen(style) || MiNeoBrutalismModule.canOpen(style) {
                    selectedStyle = style
                } else {
                    unavailableStyle = style
                    showsUnavailableToast = true
                }
            }
            .navigationDestination(item: $selectedStyle) { style in
                if MiAppleLiquidGlassModule.canOpen(style) {
                    MiAppleLiquidGlassModule.detailView(for: style) {
                        selectedStyle = nil
                    }
                } else if MiNeumorphismModule.canOpen(style) {
                    MiNeumorphismModule.detailView(for: style) {
                        selectedStyle = nil
                    }
                } else if MiNeoBrutalismModule.canOpen(style) {
                    MiNeoBrutalismModule.detailView(for: style) {
                        selectedStyle = nil
                    }
                } else {
                    EmptyView()
                }
            }
        }
        .tint(MiColorTokens.appleBlue500)
        .toast(
            isPresenting: $showsUnavailableToast,
            duration: 1.8,
            tapToDismiss: true
        ) {
            AlertToast(
                displayMode: .hud,
                type: .regular,
                title: MiL10n.text("app_building"),
                subTitle: unavailableToastSubtitle,
                style: .style(
                    backgroundColor: Color.white.opacity(0.92),
                    titleColor: MiColorTokens.contentPrimary,
                    subTitleColor: MiColorTokens.contentSecondary,
                    titleFont: .system(size: 15, weight: .semibold, design: .rounded),
                    subTitleFont: .system(size: 12, weight: .medium, design: .rounded)
                )
            )
        }
    }

    private var unavailableToastSubtitle: String {
        guard let unavailableStyle else {
            return MiL10n.text("app_unready")
        }
        return MiL10n.format("app_unready_fmt", MiL10n.text(unavailableStyle.name))
    }
}

#Preview {
    MiAppRootView()
}
