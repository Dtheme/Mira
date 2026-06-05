//
//  MiHanddrawnVlogTokens.swift
//  Mira
//
//  Hand-drawn Vlog / Vlog 手绘风 — Korean film-diary cute.
//  Muted faded-film palette, NOT bright candy pastels. Warm paper, no pure white/black.
//

import SwiftUI

enum MiHanddrawnVlogTokens {
    // MARK: Paper & ink (warm, faded-film — never pure white/black)
    static let cream = Color(hex: 0xF6EFE1)   // warm milky page
    static let paper = Color(hex: 0xFBF6EC)   // polaroid mat / brighter card
    static let ink = Color(hex: 0x4B4138)     // warm brown-black text + hand-drawn line
    static let pencil = Color(hex: 0x9C8E7C)  // pencil-grey secondary / handwriting

    // MARK: Dusty faded accents (saturation < 80%, max 2 on screen)
    static let rose = Color(hex: 0xE0A79C)    // dried-rose — the single locked accent
    static let butter = Color(hex: 0xEAD6A0)  // faded butter — washi tape / highlight
    static let matcha = Color(hex: 0xA9B795)  // dusty sage-green — secondary doodle
    static let sky = Color(hex: 0xA6BFC9)     // faded sky — film-photo placeholder
    static let clay = Color(hex: 0xC7896B)    // terracotta — stamp / deeper accent

    static let shadow = Color(hex: 0xD9C9AE)  // warm-tinted shadow (never grey/black)

    // MARK: Shape — documented dual-radius rule
    // Card surface is soft (pillowy); the polaroid photo is near-square like a real instant print.
    static let cardRadius: CGFloat = 22
    static let photoRadius: CGFloat = 6
    static let photoTilt: Double = -3         // gentle hand-placed tilt (degrees)
    static let stickerTilt: Double = 8
    static let sectionSpacing: CGFloat = 26

    /// Faded-film photo gradients for the polaroid slot (placeholder for real photos).
    static func photoGradient(_ index: Int) -> LinearGradient {
        let palettes: [[Color]] = [
            [sky.opacity(0.85), butter.opacity(0.78), rose.opacity(0.5)],
            [rose.opacity(0.7), butter.opacity(0.7), matcha.opacity(0.55)],
            [matcha.opacity(0.7), sky.opacity(0.7), butter.opacity(0.6)]
        ]
        return LinearGradient(
            colors: palettes[((index % palettes.count) + palettes.count) % palettes.count],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var pageBackground: some View {
        LinearGradient(
            colors: [Color(hex: 0xF8F2E6), cream, Color(hex: 0xF1E8D7)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    /// Friendly rounded display/body face.
    static func rounded(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }

    /// Handwriting accent. No custom font is bundled yet, so fall back to rounded
    /// and apply `.italic()` at the call site for a handwritten feel. The real
    /// `mi-hv-hand` handwriting font drops in here later.
    static func hand(_ size: CGFloat, _ weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}
