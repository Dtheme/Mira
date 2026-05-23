//
//  MiNeumorphismTokens.swift
//  Mira
//
//  Created on 2026/5/23.
//

import SwiftUI

enum MiNeumorphismTokens {
    static let base = Color(hex: 0xE8E8E8)
    static let page = Color(hex: 0xECEDEF)
    static let baseLight = Color(hex: 0xF7F7F7)
    static let baseInset = Color(hex: 0xE1E3E6)
    static let basePressed = Color(hex: 0xDADDE1)
    static let shadowDark = Color(hex: 0xBFC4CA)
    static let shadowLight = Color.white
    static let ink = Color(hex: 0x343A40)
    static let muted = Color(hex: 0x626A73)
    static let quietText = Color(hex: 0x7A828A)
    static let accent = Color(hex: 0x7B8EA4)
    static let focusAccent = Color(hex: 0x8FA6C8)
    static let focusSoft = Color(hex: 0xDDE7F3)
    static let accentDeep = Color(hex: 0x5E738E)
    static let success = Color(hex: 0x7FA58A)
    static let error = Color(hex: 0xB97878)
    static let stroke = Color(hex: 0xD3D8DE)
    static let hairline = Color(hex: 0xF8FAFC)

    static let radius: CGFloat = 24
    static let smallRadius: CGFloat = 15
    static let outerShadow: CGFloat = 18
    static let compactShadow: CGFloat = 10
    static let pressedShadow: CGFloat = 5
    static let dragShadowScale: CGFloat = 0.58
    static let sectionSpacing: CGFloat = 30
    static let groupSpacing: CGFloat = 16
    static let panelPadding: CGFloat = 18

    static var pageBackground: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: 0xF7F8FA),
                page,
                Color(hex: 0xE2E5E9)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
