//
//  MiSoftSkeuomorphismTokens.swift
//  Mira
//
//  Created on 2026/5/29.
//

import SwiftUI

enum MiSoftSkeuomorphismTokens {
    static let cream = Color(hex: 0xF8EAD8)
    static let creamLight = Color(hex: 0xFFF7EA)
    static let card = Color(hex: 0xFFF1DF)
    static let cardDeep = Color(hex: 0xF2DEC6)
    static let moss = Color(hex: 0x88A58E)
    static let mossDeep = Color(hex: 0x5D7F6B)
    static let teal = Color(hex: 0x6EAFA7)
    static let tealDeep = Color(hex: 0x446D74)
    static let peach = Color(hex: 0xF6B08A)
    static let coral = Color(hex: 0xEF998C)
    static let butter = Color(hex: 0xF5D38B)
    static let glow = Color(hex: 0xFFD59A)
    static let ink = Color(hex: 0x18202A)
    static let muted = Color(hex: 0x70675C)
    static let shadow = Color(hex: 0xCDBAA3)
    static let warmShadow = Color(hex: 0xC98E73)
    static let highlight = Color.white

    static let cardRadius: CGFloat = 34
    static let controlRadius: CGFloat = 26
    static let sectionSpacing: CGFloat = 28

    static var pageBackground: some View {
        LinearGradient(
            colors: [
                creamLight,
                cream,
                Color(hex: 0xF4D7C8),
                Color(hex: 0xEAF0DA)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
