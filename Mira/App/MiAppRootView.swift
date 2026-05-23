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
    @State private var selectedTransitionSourceID: String?
    @State private var unavailableStyle: MiDesignStyle?
    @State private var showsUnavailableToast = false
    @Namespace private var styleTransitionNamespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        NavigationStack {
            MiHomeView(
                styles: MiStyleRepository.styles,
                transitionNamespace: styleTransitionNamespace
            ) { style, transitionSourceID in
                if MiAppleLiquidGlassModule.canOpen(style) || MiNeumorphismModule.canOpen(style) || MiNeoBrutalismModule.canOpen(style) {
                    selectedTransitionSourceID = transitionSourceID
                    selectedStyle = style
                } else {
                    unavailableStyle = style
                    showsUnavailableToast = true
                }
            }
            .navigationDestination(item: $selectedStyle) { style in
                detailView(for: style)
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

    @ViewBuilder
    private func detailView(for style: MiDesignStyle) -> some View {
        let sourceID = selectedTransitionSourceID ?? style.id

        Group {
            if MiAppleLiquidGlassModule.canOpen(style) {
                MiAppleLiquidGlassModule.detailView(for: style) {
                    closeDetail()
                }
            } else if MiNeumorphismModule.canOpen(style) {
                MiNeumorphismModule.detailView(for: style) {
                    closeDetail()
                }
            } else if MiNeoBrutalismModule.canOpen(style) {
                MiNeoBrutalismModule.detailView(for: style) {
                    closeDetail()
                }
            } else {
                EmptyView()
            }
        }
        .modifier(
            MiStyleNavigationTransitionModifier(
                sourceID: sourceID,
                namespace: styleTransitionNamespace,
                reduceMotion: reduceMotion
            )
        )
    }

    private func closeDetail() {
        selectedStyle = nil
        selectedTransitionSourceID = nil
    }
}

#Preview {
    MiAppRootView()
}

private struct MiStyleNavigationTransitionModifier: ViewModifier {
    let sourceID: String
    let namespace: Namespace.ID
    let reduceMotion: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        if reduceMotion {
            content
        } else {
            content
                .navigationTransition(.zoom(sourceID: sourceID, in: namespace))
        }
    }
}
