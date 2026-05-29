//
//  MiClaymorphismTokens.swift
//  Mira
//
//  Created on 2026/5/29.
//

import SwiftUI

enum MiClaymorphismTokens {
    static let background = Color(hex: 0xFFF4F2)
    static let backgroundWarm = Color(hex: 0xFFE8D8)
    static let surface = Color(hex: 0xFFE2CD)
    static let surfaceLight = Color(hex: 0xFFF1E7)
    static let peach = Color(hex: 0xFFB08A)
    static let coral = Color(hex: 0xFF7E8A)
    static let lilac = Color(hex: 0xC9B7FF)
    static let mint = Color(hex: 0xA9E8D0)
    static let sky = Color(hex: 0xA8D8FF)
    static let butter = Color(hex: 0xFFE29A)
    static let ink = Color(hex: 0x46334A)
    static let muted = Color(hex: 0x7B6476)
    static let shadowDark = Color(hex: 0xD09C8D)
    static let shadowCool = Color(hex: 0xBCA8D8)
    static let shadowLight = Color.white
    static let line = Color(hex: 0xF0C3B5)

    static let cardRadius: CGFloat = 34
    static let controlRadius: CGFloat = 28
    static let sectionSpacing: CGFloat = 28

    static var pageBackground: some View {
        LinearGradient(
            colors: [
                background,
                backgroundWarm,
                Color(hex: 0xF3EAFF),
                Color(hex: 0xEAF9F4)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
