//
//  MiNeumorphismModule.swift
//  Mira
//
//  Created on 2026/5/23.
//

import SwiftUI

enum MiNeumorphismModule {
    static let styleID = "neumorphism"
    static let designDocumentPath = "docs/design-system/styles/neumorphism/Design.md"
    static let isImplemented = true

    static func canOpen(_ style: MiDesignStyle) -> Bool {
        style.id == styleID && style.isImplementationReady
    }

    static func detailView(
        for style: MiDesignStyle,
        onBack: (() -> Void)? = nil
    ) -> MiNeumorphismDetailView {
        MiNeumorphismDetailView(style: style, onBack: onBack)
    }
}
