//
//  MiRefinedDarkTokens.swift
//  Mira
//

import SwiftUI

enum MiRefinedDarkTokens {
    static let base = Color(hex: 0x0E0E11)
    static let surface = Color(hex: 0x161619)
    static let surfaceRaised = Color(hex: 0x1D1D22)
    static let ink = Color(hex: 0xF4F4F7)
    static let muted = Color(hex: 0x9A9AA6)
    static let accent = Color(hex: 0x7C8CFF)
    static let accentDeep = Color(hex: 0x5664E0)
    static let positive = Color(hex: 0x4ADE80)
    static let danger = Color(hex: 0xF36F6F)
    static let hairline = Color.white.opacity(0.08)
    static let hairlineStrong = Color.white.opacity(0.16)

    static let radius: CGFloat = 18
    static let smallRadius: CGFloat = 12
    static let sectionSpacing: CGFloat = 26

    static var pageBackground: some View {
        ZStack {
            base
            LinearGradient(
                colors: [Color.white.opacity(0.04), .clear],
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea()
            RadialGradient(
                colors: [accent.opacity(0.10), .clear],
                center: .init(x: 0.85, y: 0.0),
                startRadius: 0,
                endRadius: 320
            )
            .ignoresSafeArea()
        }
    }
}
