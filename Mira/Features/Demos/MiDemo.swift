//
//  MiDemo.swift
//  Mira
//
//  Created on 2026/6/29.
//

import SwiftUI

/// A lightweight interactive demo entry. Deliberately separate from `MiDesignStyle`:
/// a demo has no design tokens, category, slug, or Design.md.
struct MiDemo: Identifiable, Hashable {
    let id: String
    let titleKey: String
    let subtitleKey: String
    let systemImage: String
    let accentHex: UInt
    let isReady: Bool

    var accent: Color { Color(hex: accentHex) }
}
