//
//  MiDesignStyle.swift
//  Mira
//
//  Created on 2026/5/22.
//

import SwiftUI

enum MiStyleCategory: String, CaseIterable, Identifiable {
    case materialSurface = "cat_material"
    case experimentalVisual = "cat_experimental"
    case antiDesignStructural = "cat_antidesign"

    var id: String { rawValue }

    var title: String {
        MiL10n.text(rawValue)
    }
}

struct MiTokenSpec: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let value: String
    let role: String
}

struct MiStyleDetailSection: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let summary: String
    let bullets: [String]
}

struct MiDemoSlot: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let systemImage: String
}

struct MiDesignStyle: Identifiable, Hashable {
    let id: String
    let name: String
    let localizedName: String
    let slug: String
    let category: MiStyleCategory
    let summary: String
    let description: String
    let designDocumentPath: String
    let screenshotAssetName: String?
    let accentHex: UInt
    let visualTokens: [MiTokenSpec]
    let sections: [MiStyleDetailSection]
    let demoSlots: [MiDemoSlot]
    let isImplementationReady: Bool

    var accent: Color {
        Color(hex: accentHex)
    }

    var screenshotStatus: String {
        MiL10n.text(screenshotAssetName == nil ? "c_no_screenshot" : "c_has_screenshot")
    }
}
