//
//  MiClaymorphismModule.swift
//  Mira
//
//  Created on 2026/5/29.
//

import SwiftUI

enum MiClaymorphismModule {
    static let styleID = "claymorphism"
    static let designDocumentPath = "docs/design-system/styles/claymorphism/Design.md"
    static let isImplemented = true

    static func canOpen(_ style: MiDesignStyle) -> Bool {
        style.id == styleID && style.isImplementationReady
    }

    static func detailView(
        for style: MiDesignStyle,
        onBack: (() -> Void)? = nil
    ) -> MiClaymorphismDetailView {
        MiClaymorphismDetailView(style: style, onBack: onBack)
    }
}
