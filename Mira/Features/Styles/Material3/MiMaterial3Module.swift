//
//  MiMaterial3Module.swift
//  Mira
//
//  Created on 2026/5/25.
//

import SwiftUI

enum MiMaterial3Module {
    static let styleID = "material-3"
    static let designDocumentPath = "docs/design-system/styles/material-3/Design.md"
    static let isImplemented = true

    static func canOpen(_ style: MiDesignStyle) -> Bool {
        style.id == styleID && style.isImplementationReady
    }

    static func detailView(
        for style: MiDesignStyle,
        onBack: (() -> Void)? = nil
    ) -> MiMaterial3DetailView {
        MiMaterial3DetailView(style: style, onBack: onBack)
    }
}
