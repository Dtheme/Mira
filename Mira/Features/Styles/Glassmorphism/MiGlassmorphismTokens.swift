//
//  MiGlassmorphismTokens.swift
//  Mira
//
//  Created on 2026/5/25.
//

import SwiftUI

enum MiGlassmorphismTokens {
    static let ink = Color(hex: 0x132033)
    static let muted = Color(hex: 0x536173)
    static let cyan = Color(hex: 0x62E6F2)
    static let blue = Color(hex: 0x6EA8FF)
    static let violet = Color(hex: 0xB8A2FF)
    static let mint = Color(hex: 0xB9F6D3)
    // Home card aurora field: cyan/blue/violet deepened to mid-saturation.
    static let fieldCyan = Color(hex: 0x9BE2F2)
    static let fieldBlue = Color(hex: 0x8CB4FD)
    static let fieldViolet = Color(hex: 0xBBA4FF)
    static let poolViolet = Color(hex: 0x9E82FF)
    static let surface = Color.white.opacity(0.54)
    static let border = Color.white.opacity(0.82)
    static let radius: CGFloat = 28
    static let sectionSpacing: CGFloat = 28

    static var pageBackground: some View {
        LinearGradient(
            colors: [
                Color(hex: 0xF8FCFF),
                Color(hex: 0xEEF7FF),
                Color(hex: 0xF7F4FF),
                Color(hex: 0xF9FEFF)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay(alignment: .topTrailing) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            cyan.opacity(0.36),
                            violet.opacity(0.24),
                            .clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 260)
                .blur(radius: 34)
                .offset(y: -70)
        }
        .overlay(alignment: .bottomLeading) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            blue.opacity(0.22),
                            mint.opacity(0.22),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 220)
                .blur(radius: 30)
                .offset(y: 70)
        }
    }
}
