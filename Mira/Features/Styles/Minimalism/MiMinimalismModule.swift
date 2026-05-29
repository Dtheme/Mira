//
//  MiMinimalismModule.swift
//  Mira
//
//  Created on 2026/5/25.
//

import SwiftUI

enum MiMinimalismModule {
    static let styleID = "minimalism"
    static let designDocumentPath = "docs/design-system/styles/minimalism/Design.md"
    static let isImplemented = true

    static func canOpen(_ style: MiDesignStyle) -> Bool {
        style.id == styleID && style.isImplementationReady
    }

    static func detailView(
        for style: MiDesignStyle,
        onBack: (() -> Void)? = nil
    ) -> MiMinimalismDetailView {
        MiMinimalismDetailView(style: style, onBack: onBack)
    }
}
