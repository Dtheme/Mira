//
//  MiSoftSkeuomorphismModule.swift
//  Mira
//
//  Created on 2026/5/29.
//

import SwiftUI

enum MiSoftSkeuomorphismModule {
    static let styleID = "soft-skeuomorphism"
    static let designDocumentPath = "docs/design-system/styles/soft-skeuomorphism/Design.md"
    static let isImplemented = true

    static func canOpen(_ style: MiDesignStyle) -> Bool {
        style.id == styleID && style.isImplementationReady
    }

    static func detailView(
        for style: MiDesignStyle,
        onBack: (() -> Void)? = nil
    ) -> MiSoftSkeuomorphismDetailView {
        MiSoftSkeuomorphismDetailView(style: style, onBack: onBack)
    }
}
