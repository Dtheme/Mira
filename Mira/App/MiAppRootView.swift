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
    @State private var showsDemoList = false
    @State private var selectedDemo: MiDemo?
    @Namespace private var dummyNamespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            homeLayer
                .opacity(isHomeCovered ? 0 : 1)
                .scaleEffect(isHomeCovered ? 0.96 : 1)
                .allowsHitTesting(!isHomeCovered)

            if let selectedStyle {
                detailView(for: selectedStyle)
                    .transition(detailTransition)
                    .zIndex(10)
            }

            if showsDemoList {
                MiDemoListView(
                    demos: MiDemoRepository.demos,
                    onSelect: { openDemo($0) },
                    onBack: { closeDemoList() }
                )
                .transition(detailTransition)
                .zIndex(20)
            }

            if let selectedDemo {
                MiHoloCardModule.showcaseView(for: selectedDemo) {
                    closeDemo()
                }
                .transition(detailTransition)
                .zIndex(30)
            }
        }
        .animation(dissolveAnimation, value: selectedStyle?.id)
        .animation(dissolveAnimation, value: showsDemoList)
        .animation(dissolveAnimation, value: selectedDemo?.id)
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
            if MiAppleLiquidGlassModule.canOpen(style)
                || MiGlassmorphismModule.canOpen(style)
                || MiNeumorphismModule.canOpen(style)
                || MiClaymorphismModule.canOpen(style)
                || MiSoftSkeuomorphismModule.canOpen(style)
                || MiNeoBrutalismModule.canOpen(style)
                || MiMinimalismModule.canOpen(style)
                || MiMaterial3Module.canOpen(style)
                || MiBentoGridModule.canOpen(style)
                || MiRefinedDarkModule.canOpen(style)
                || MiEditorialLuxeModule.canOpen(style)
                || MiHanddrawnVlogModule.canOpen(style) {
                openDetail(for: style)
            } else {
                unavailableStyle = style
                showsUnavailableToast = true
            }
        }
        .overlay(alignment: .bottom) {
            MiDemoEntryCard {
                openDemoList()
            }
            .padding(.horizontal, MiSpacingTokens.md)
            .padding(.bottom, MiSpacingTokens.sm)
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
            } else if MiGlassmorphismModule.canOpen(style) {
                MiGlassmorphismModule.detailView(for: style) {
                    closeDetail()
                }
            } else if MiNeumorphismModule.canOpen(style) {
                MiNeumorphismModule.detailView(for: style) {
                    closeDetail()
                }
            } else if MiClaymorphismModule.canOpen(style) {
                MiClaymorphismModule.detailView(for: style) {
                    closeDetail()
                }
            } else if MiSoftSkeuomorphismModule.canOpen(style) {
                MiSoftSkeuomorphismModule.detailView(for: style) {
                    closeDetail()
                }
            } else if MiNeoBrutalismModule.canOpen(style) {
                MiNeoBrutalismModule.detailView(for: style) {
                    closeDetail()
                }
            } else if MiMinimalismModule.canOpen(style) {
                MiMinimalismModule.detailView(for: style) {
                    closeDetail()
                }
            } else if MiMaterial3Module.canOpen(style) {
                MiMaterial3Module.detailView(for: style) {
                    closeDetail()
                }
            } else if MiBentoGridModule.canOpen(style) {
                MiBentoGridModule.detailView(for: style) {
                    closeDetail()
                }
            } else if MiRefinedDarkModule.canOpen(style) {
                MiRefinedDarkModule.detailView(for: style) {
                    closeDetail()
                }
            } else if MiEditorialLuxeModule.canOpen(style) {
                MiEditorialLuxeModule.detailView(for: style) {
                    closeDetail()
                }
            } else if MiHanddrawnVlogModule.canOpen(style) {
                MiHanddrawnVlogModule.detailView(for: style) {
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
        selectedStyle == nil ? 1 : 0.96
    }

    private var detailTransition: AnyTransition {
        if reduceMotion {
            return .opacity
        }
        return .opacity.combined(with: .scale(scale: 1.02, anchor: .center))
    }

    private var dissolveAnimation: Animation {
        reduceMotion
            ? .easeInOut(duration: 0.20)
            : .spring(response: 0.32, dampingFraction: 0.88, blendDuration: 0)
    }

    private func openDetail(for style: MiDesignStyle) {
        selectedStyle = style
    }

    private func closeDetail() {
        selectedStyle = nil
    }

    private func openDemoList() {
        showsDemoList = true
    }

    private func closeDemoList() {
        showsDemoList = false
    }

    private func openDemo(_ demo: MiDemo) {
        guard MiHoloCardModule.canOpen(demo) else { return }
        selectedDemo = demo
    }

    private func closeDemo() {
        selectedDemo = nil
    }

    private var isHomeCovered: Bool {
        selectedStyle != nil || showsDemoList
    }
}

#Preview {
    MiAppRootView()
}
