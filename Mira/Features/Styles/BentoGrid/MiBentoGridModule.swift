//
//  MiBentoGridModule.swift
//  Mira
//

import SwiftUI

enum MiBentoGridModule {
    static let styleID = "bento-grid"
    static let designDocumentPath = "docs/design-system/styles/bento-grid/Design.md"
    static let isImplemented = true

    static func canOpen(_ style: MiDesignStyle) -> Bool {
        style.id == styleID && style.isImplementationReady
    }

    static func detailView(
        for style: MiDesignStyle,
        onBack: (() -> Void)? = nil
    ) -> MiBentoGridDetailView {
        MiBentoGridDetailView(style: style, onBack: onBack)
    }
}
