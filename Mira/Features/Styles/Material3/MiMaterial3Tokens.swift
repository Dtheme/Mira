import SwiftUI
import UIKit

enum MiMaterial3Palette: String, CaseIterable, Sendable {
    case violet
    case sage

    var primary: Color { color(0x6750A4, 0xD0BCFF, sage: 0x386A20, 0x9CD67D) }
    var onPrimary: Color { color(0xFFFFFF, 0x381E72, sage: 0xFFFFFF, 0x0C3900) }
    var primaryContainer: Color { color(0xEADDFF, 0x4F378B, sage: 0xB8F397, 0x205107) }
    var onPrimaryContainer: Color { color(0x21005D, 0xEADDFF, sage: 0x062100, 0xB8F397) }
    var secondary: Color { color(0x625B71, 0xCCC2DC, sage: 0x55624C, 0xBDCBAF) }
    var secondaryContainer: Color { color(0xE8DEF8, 0x4A4458, sage: 0xD9E7CA, 0x3E4A36) }
    var onSecondaryContainer: Color { color(0x1D192B, 0xE8DEF8, sage: 0x131F0D, 0xD9E7CA) }
    var tertiaryContainer: Color { color(0xFFD8E4, 0x633B48, sage: 0xBCEBEF, 0x1F4D51) }
    var onTertiaryContainer: Color { color(0x31111D, 0xFFD8E4, sage: 0x002023, 0xBCEBEF) }
    var surface: Color { color(0xFEF7FF, 0x141218, sage: 0xF8FAF0, 0x12150E) }
    var surfaceContainerLowest: Color { color(0xFFFFFF, 0x0F0D13, sage: 0xFFFFFF, 0x0D1009) }
    var surfaceContainerLow: Color { color(0xF7F2FA, 0x1D1B20, sage: 0xF2F4EA, 0x1A1D16) }
    var surfaceContainer: Color { color(0xF3EDF7, 0x211F26, sage: 0xECEEE4, 0x1E211A) }
    var surfaceContainerHigh: Color { color(0xECE6F0, 0x2B2930, sage: 0xE6E8DE, 0x282B24) }
    var surfaceContainerHighest: Color { color(0xE6E0E9, 0x36343B, sage: 0xE0E2D8, 0x33362E) }
    var onSurface: Color { color(0x1D1B20, 0xE6E0E9, sage: 0x1A1C16, 0xE0E2D8) }
    var onSurfaceVariant: Color { color(0x49454F, 0xCAC4D0, sage: 0x43483E, 0xC3C8BA) }
    var outline: Color { color(0x79747E, 0x938F99, sage: 0x73796C, 0x8D9386) }
    var outlineVariant: Color { color(0xCAC4D0, 0x49454F, sage: 0xC3C8BA, 0x43483E) }
    var error: Color { Self.adaptive(0xB3261E, 0xF2B8B5) }
    var errorContainer: Color { Self.adaptive(0xF9DEDC, 0x8C1D18) }
    var onErrorContainer: Color { Self.adaptive(0x410E0B, 0xF9DEDC) }
    var inverseSurface: Color { color(0x322F35, 0xE6E0E9, sage: 0x2F322A, 0xE0E2D8) }
    var inverseOnSurface: Color { color(0xF5EFF7, 0x322F35, sage: 0xF0F2E8, 0x2F322A) }
    var inversePrimary: Color { color(0xD0BCFF, 0x6750A4, sage: 0x9CD67D, 0x386A20) }

    private func color(_ light: UInt32, _ dark: UInt32, sage sageLight: UInt32, _ sageDark: UInt32) -> Color {
        Self.adaptive(self == .violet ? light : sageLight, self == .violet ? dark : sageDark)
    }

    private static func adaptive(_ light: UInt32, _ dark: UInt32) -> Color {
        Color(uiColor: UIColor { traits in
            let hex = traits.userInterfaceStyle == .dark ? dark : light
            return UIColor(
                red: CGFloat((hex >> 16) & 0xFF) / 255,
                green: CGFloat((hex >> 8) & 0xFF) / 255,
                blue: CGFloat(hex & 0xFF) / 255,
                alpha: 1
            )
        })
    }
}

extension EnvironmentValues {
    @Entry var miMaterial3Palette: MiMaterial3Palette = .violet
}

enum MiMaterial3Tokens {
    static let stateAnimation = Animation.timingCurve(0.2, 0, 0, 1, duration: 0.18)
    static let transitionAnimation = Animation.timingCurve(0.2, 0, 0, 1, duration: 0.30)
    static let pressedOpacity = 0.12
}
