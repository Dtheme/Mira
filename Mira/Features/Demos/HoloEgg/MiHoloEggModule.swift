//
//  MiHoloEggModule.swift
//  Mira
//
//  Created on 2026/8/20.
//
//  Mirrors the demo-module pattern (canOpen / showcaseView).
//

import SwiftUI

enum MiHoloEggModule {
    static let demoID = "holo-egg"

    static func canOpen(_ demo: MiDemo) -> Bool {
        demo.id == demoID && demo.isReady
    }

    @ViewBuilder
    static func showcaseView(for demo: MiDemo, onBack: @escaping () -> Void) -> some View {
        MiHoloEggShowcaseView(onBack: onBack)
    }
}
