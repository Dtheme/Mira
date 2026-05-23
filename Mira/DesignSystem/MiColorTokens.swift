//
//  MiColorTokens.swift
//  Mira
//
//  Created on 2026/5/22.
//

import SwiftUI

enum MiColorTokens {
    static let obsidian950 = Color(hex: 0x05070D)
    static let graphite900 = Color(hex: 0x111827)
    static let frost050 = Color(hex: 0xF7FBFF)
    static let frost100 = Color(hex: 0xEAF2FF)
    static let appleBlue500 = Color(hex: 0x0A84FF)
    static let aqua400 = Color(hex: 0x00C7BE)
    static let iris500 = Color(hex: 0x7C3AED)
    static let lime400 = Color(hex: 0xC7F464)
    static let rose500 = Color(hex: 0xFF375F)
    static let amber400 = Color(hex: 0xFFD60A)

    static let contentPrimary = Color(hex: 0x162033)
    static let contentSecondary = Color(hex: 0x354154).opacity(0.74)
    static let contentMuted = Color(hex: 0x586579).opacity(0.62)
    static let glassBorder = Color.white.opacity(0.72)
    static let glassFill = Color.white.opacity(0.54)

    static var appBackground: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: 0xFBFDFF),
                Color(hex: 0xF2F7FF),
                Color(hex: 0xEEF8FA),
                Color(hex: 0xF9FBFF)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var cardPlaceholderGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(0.92),
                frost100.opacity(0.84),
                appleBlue500.opacity(0.12),
                aqua400.opacity(0.10)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var screenshotScrim: LinearGradient {
        LinearGradient(
            colors: [
                .clear,
                obsidian950.opacity(0.18),
                obsidian950.opacity(0.78)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}
