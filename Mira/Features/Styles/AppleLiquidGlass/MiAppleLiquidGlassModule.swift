//
//  MiAppleLiquidGlassModule.swift
//  Mira
//
//  Created on 2026/5/22.
//

import SwiftUI

enum MiAppleLiquidGlassModule {
    static let styleID = "apple-liquid-glass"
    static let designDocumentPath = "docs/design-system/styles/apple-liquid-glass/Design.md"

    static func canOpen(_ style: MiDesignStyle) -> Bool {
        style.id == styleID && style.isImplementationReady
    }

    static func detailView(
        for style: MiDesignStyle,
        onBack: (() -> Void)? = nil
    ) -> MiAppleLiquidGlassDetailView {
        MiAppleLiquidGlassDetailView(style: style, onBack: onBack)
    }
}
