//
//  MiNeoBrutalismTokens.swift
//  Mira
//
//  Created on 2026/5/22.
//

import SwiftUI

enum MiNeoBrutalismTokens {
    static let ink = Color(hex: 0x323232)
    static let paper = Color(hex: 0xFFFDF7)
    static let paperBlue = Color(hex: 0xDFF2FF)
    static let surface = Color(hex: 0xFFFFFF)
    static let blue = Color(hex: 0x2D8CF0)
    static let blueSoft = Color(hex: 0xBFE4FF)
    static let green = Color(hex: 0x4ECB71)
    static let greenSoft = Color(hex: 0xCCF7D9)
    static let orange = Color(hex: 0xFF9F3F)
    static let orangeSoft = Color(hex: 0xFFE1BD)
    static let yellow = Color(hex: 0xFFE66D)
    static let red = Color(hex: 0xFF6B6B)
    static let purple = Color(hex: 0x9F7AEA)
    static let muted = Color(hex: 0x666666)

    static let lineWidth: CGFloat = 3
    static let thinLineWidth: CGFloat = 2

    static let radiusXS: CGFloat = 8
    static let radiusSM: CGFloat = 12
    static let radiusMD: CGFloat = 18
    static let radiusLG: CGFloat = 24

    static let shadowSmall = CGSize(width: 4, height: 4)
    static let shadowMedium = CGSize(width: 6, height: 6)
    static let shadowLarge = CGSize(width: 10, height: 10)
    static let pressOffset = CGSize(width: 4, height: 4)

    static let motion: Animation = .spring(response: 0.18, dampingFraction: 0.72)

    static let headline = Font.system(size: 36, weight: .black, design: .default)
    static let title = Font.system(size: 26, weight: .black, design: .default)
    static let sectionTitle = Font.system(size: 23, weight: .black, design: .default)
    static let body = Font.system(size: 15, weight: .semibold, design: .default)
    static let label = Font.system(size: 12, weight: .black, design: .default)
    static let caption = Font.system(size: 11, weight: .bold, design: .default)
}
