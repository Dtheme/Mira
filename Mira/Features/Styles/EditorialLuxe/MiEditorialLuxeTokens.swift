//
//  MiEditorialLuxeTokens.swift
//  Mira
//

import SwiftUI

enum MiEditorialLuxeTokens {
    static let paper = Color(hex: 0xF6F1E9)
    static let surface = Color(hex: 0xFFFFFF)
    static let cardWarm = Color(hex: 0xFCF9F2)
    static let ink = Color(hex: 0x211C16)
    static let muted = Color(hex: 0x756B5E)
    static let gold = Color(hex: 0xAD8A52)
    static let goldSoft = Color(hex: 0xCBB07E)
    static let hairline = Color(hex: 0xE5DDCF)
    static let coverInk = Color(hex: 0x2A241C)

    static let radius: CGFloat = 12
    static let smallRadius: CGFloat = 8
    static let sectionSpacing: CGFloat = 30

    static var pageBackground: some View {
        LinearGradient(
            colors: [Color(hex: 0xF8F4EC), paper, Color(hex: 0xF1EADD)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static func serif(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }
}
