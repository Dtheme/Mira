//
//  MiHanddrawnVlogModule.swift
//  Mira
//

import SwiftUI

enum MiHanddrawnVlogModule {
    static let styleID = "handdrawn-vlog"
    static let designDocumentPath = "docs/design-system/styles/handdrawn-vlog/Design.md"
    static let isImplemented = true

    static func canOpen(_ style: MiDesignStyle) -> Bool {
        style.id == styleID && style.isImplementationReady
    }

    static func detailView(
        for style: MiDesignStyle,
        onBack: (() -> Void)? = nil
    ) -> MiHanddrawnVlogDetailView {
        MiHanddrawnVlogDetailView(style: style, onBack: onBack)
    }
}
