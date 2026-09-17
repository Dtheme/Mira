import SwiftUI

enum MiPlayfulOutlineModule {
    static let styleID = "playful-outline"
    static let designDocumentPath = "docs/design-system/styles/playful-outline/Design.md"
    static let isImplemented = true

    static func canOpen(_ style: MiDesignStyle) -> Bool {
        style.id == styleID && style.isImplementationReady
    }

    static func detailView(
        for style: MiDesignStyle,
        onBack: (() -> Void)? = nil
    ) -> MiPlayfulOutlineDetailView {
        MiPlayfulOutlineDetailView(style: style, onBack: onBack)
    }
}
