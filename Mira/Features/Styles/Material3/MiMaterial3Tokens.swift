//
//  MiMaterial3Tokens.swift
//  Mira
//
//  Created on 2026/5/25.
//

import SwiftUI

enum MiMaterial3Tokens {
    static let primary = Color(hex: 0x6750A4)
    static let onPrimary = Color.white
    static let primaryContainer = Color(hex: 0xEADDFF)
    static let onPrimaryContainer = Color(hex: 0x21005D)
    static let secondary = Color(hex: 0x625B71)
    static let secondaryContainer = Color(hex: 0xE8DEF8)
    static let onSecondaryContainer = Color(hex: 0x1D192B)
    static let tertiary = Color(hex: 0x7D5260)
    static let tertiaryContainer = Color(hex: 0xFFD8E4)
    static let onTertiaryContainer = Color(hex: 0x31111D)
    static let surface = Color(hex: 0xFFFBFE)
    static let surfaceContainerLowest = Color(hex: 0xFFFFFF)
    static let surfaceContainerLow = Color(hex: 0xF7F2FA)
    static let surfaceContainer = Color(hex: 0xF3EDF7)
    static let surfaceContainerHigh = Color(hex: 0xECE6F0)
    static let surfaceContainerHighest = Color(hex: 0xE6E0E9)
    static let outline = Color(hex: 0x79747E)
    static let outlineVariant = Color(hex: 0xCAC4D0)
    static let ink = Color(hex: 0x1D1B20)
    static let muted = Color(hex: 0x49454F)
    static let onSurfaceVariant = Color(hex: 0x49454F)
    static let error = Color(hex: 0xB3261E)
    static let errorContainer = Color(hex: 0xF9DEDC)
    static let radius: CGFloat = 24
    static let sectionSpacing: CGFloat = 28

    static var pageBackground: some View {
        LinearGradient(
            colors: [
                surface,
                surfaceContainer,
                Color(hex: 0xF8F3FF)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
