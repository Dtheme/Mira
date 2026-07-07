//
//  MiHoloCardModule.swift
//  Mira
//
//  Created on 2026/6/29.
//
//  Mirrors the style-module pattern (canOpen / detailView) for the Demo area.
//

import SwiftUI

enum MiHoloCardModule {
    static let demoID = "holo-card"

    static func canOpen(_ demo: MiDemo) -> Bool {
        demo.id == demoID && demo.isReady
    }

    @ViewBuilder
    static func showcaseView(for demo: MiDemo, onBack: @escaping () -> Void) -> some View {
        MiHoloCardShowcaseView(onBack: onBack)
    }
}
