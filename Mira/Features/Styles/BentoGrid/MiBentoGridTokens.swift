//
//  MiBentoGridTokens.swift
//  Mira
//

import SwiftUI

enum MiBentoGridTokens {
    static let canvas = Color(hex: 0xEEF0F4)
    static let surface = Color(hex: 0xFFFFFF)
    static let surfaceAlt = Color(hex: 0xF6F7F9)
    static let ink = Color(hex: 0x1A1D24)
    static let muted = Color(hex: 0x6B7280)
    static let accent = Color(hex: 0x5B6CFF)
    static let accent2 = Color(hex: 0x15C39A)
    static let stroke = Color(hex: 0xE3E6EC)

    static let radius: CGFloat = 24
    static let smallRadius: CGFloat = 16
    static let tinyRadius: CGFloat = 10
    static let gutter: CGFloat = 12
    static let sectionSpacing: CGFloat = 26

    static var pageBackground: some View {
        LinearGradient(
            colors: [
                Color(hex: 0xF3F5F9),
                canvas,
                Color(hex: 0xE8EBF1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
