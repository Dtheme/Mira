//
//  MiNeoBrutalismModule.swift
//  Mira
//
//  Created on 2026/5/22.
//

import SwiftUI

enum MiNeoBrutalismModule {
    static let styleID = "neo-brutalism"
    static let designDocumentPath = "docs/design-system/styles/neo-brutalism/Design.md"
    static let isImplemented = true

    static func canOpen(_ style: MiDesignStyle) -> Bool {
        style.id == styleID && style.isImplementationReady
    }

    static func detailView(
        for style: MiDesignStyle,
        onBack: (() -> Void)? = nil
    ) -> MiNeoBrutalismDetailView {
        MiNeoBrutalismDetailView(style: style, onBack: onBack)
    }
}
