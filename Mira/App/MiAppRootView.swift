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
    @Namespace private var dummyNamespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            homeLayer
                .opacity(homeOpacity)
                .scaleEffect(homeScale)
                .blur(radius: homeBlur)
                .allowsHitTesting(selectedStyle == nil)

            if let selectedStyle {
                detailView(for: selectedStyle)
                    .transition(detailTransition)
                    .zIndex(10)
            }
        }
        .animation(dissolveAnimation, value: selectedStyle?.id)
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

    private var homeLayer: some View {
        MiHomeView(
            styles: MiStyleRepository.styles,
            isNavigationTransitionActive: selectedStyle != nil,
            activeTransitionSourceID: nil,
            activeTitleTransitionStyleID: nil,
            transitionNamespace: dummyNamespace
        ) { style, _ in
            if MiAppleLiquidGlassModule.canOpen(style) || MiNeumorphismModule.canOpen(style) || MiNeoBrutalismModule.canOpen(style) {
                openDetail(for: style)
            } else {
                unavailableStyle = style
                showsUnavailableToast = true
            }
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
    }

    private var homeOpacity: Double {
        selectedStyle == nil ? 1 : 0
    }

    private var homeScale: CGFloat {
        selectedStyle == nil ? 1 : 0.985
    }

    private var homeBlur: CGFloat {
        guard !reduceMotion else { return 0 }
        return selectedStyle == nil ? 0 : 4
    }

    private var detailTransition: AnyTransition {
        if reduceMotion {
            return .opacity
        }
        return .asymmetric(
            insertion: .opacity.combined(with: .scale(scale: 1.018)),
            removal: .opacity.combined(with: .scale(scale: 1.012))
        )
    }

    private var dissolveAnimation: Animation {
        reduceMotion ? .easeInOut(duration: 0.22) : .easeInOut(duration: 0.48)
    }

    private func openDetail(for style: MiDesignStyle) {
        selectedStyle = style
    }

    private func closeDetail() {
        selectedStyle = nil
    }
}

#Preview {
    MiAppRootView()
}
