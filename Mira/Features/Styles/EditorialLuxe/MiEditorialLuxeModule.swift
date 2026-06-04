//
//  MiEditorialLuxeModule.swift
//  Mira
//

import SwiftUI

enum MiEditorialLuxeModule {
    static let styleID = "editorial-luxe"
    static let designDocumentPath = "docs/design-system/styles/editorial-luxe/Design.md"
    static let isImplemented = true

    static func canOpen(_ style: MiDesignStyle) -> Bool {
        style.id == styleID && style.isImplementationReady
    }

    static func detailView(
        for style: MiDesignStyle,
        onBack: (() -> Void)? = nil
    ) -> MiEditorialLuxeDetailView {
        MiEditorialLuxeDetailView(style: style, onBack: onBack)
    }
}
