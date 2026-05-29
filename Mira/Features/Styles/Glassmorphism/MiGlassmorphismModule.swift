//
//  MiGlassmorphismModule.swift
//  Mira
//
//  Created on 2026/5/22.
//

import SwiftUI

enum MiGlassmorphismModule {
    static let styleID = "glassmorphism"
    static let designDocumentPath = "docs/design-system/styles/glassmorphism/Design.md"
    static let isImplemented = true

    static func canOpen(_ style: MiDesignStyle) -> Bool {
        style.id == styleID && style.isImplementationReady
    }

    static func detailView(
        for style: MiDesignStyle,
        onBack: (() -> Void)? = nil
    ) -> MiGlassmorphismDetailView {
        MiGlassmorphismDetailView(style: style, onBack: onBack)
    }
}
