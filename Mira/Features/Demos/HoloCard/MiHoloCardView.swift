//
//  MiHoloCardView.swift
//  Mira
//
//  Created on 2026/6/29.
//
//  A complete holographic trading-card. An original (non-IP) card face carries a
//  full holographic foil (the `miHoloFoil` Metal `colorEffect`) driven by a
//  pointer (touch drag) or the gyroscope, plus a perspective 3D tilt that mirrors
//  the reference web effect (pointer -> rotateY/rotateX, translate, scale).
//
//  Performance: one card-sized face raster + one `colorEffect` pass per active
//  card; glow and contact shadow are pre-blurred `.drawingGroup()` layers that
//  only translate. Inactive cards render flat (shader disabled).
//

import SwiftUI

/// One original full-art holographic card: a procedural atmospheric scene under a
/// metal frame, carrying the holo foil. No real trading-card IP.
struct MiHoloCard: Identifiable, Hashable {
    let id: String
    let nameKey: String
    let subtitleKey: String
    let rarityKey: String
    let poemKey: String       // a matching classical-poem line shown under the card
    let sealChar: String      // a single character for the vermilion seal (落款)
    /// 0 rainbow rare / 1 cosmos / 2 regular holo — selects the foil character.
    let foilStyle: Int
    let scene: MiArtScene
    let frameHex: UInt        // metallic frame + title accents
    let glowHex: UInt         // also the scene's ambient-light tint for the foil
    let isDark: Bool

    var frame: Color { Color(hex: frameHex) }
    var glow: Color { Color(hex: glowHex) }
    var tintR: Float { Float((glowHex >> 16) & 0xFF) / 255 }
    var tintG: Float { Float((glowHex >> 8) & 0xFF) / 255 }
    var tintB: Float { Float(glowHex & 0xFF) / 255 }

    static let deck: [MiHoloCard] = [
        MiHoloCard(id: "aurora", nameKey: "card_aurora2_name", subtitleKey: "card_aurora2_sub",
                   rarityKey: "rarity_art", poemKey: "card_aurora2_poem", sealChar: "光", foilStyle: 0,
                   scene: MiArtScene(kind: .aurora, skyTop: 0x0B1026, skyMid: 0x161A3A,
                                     skyBottom: 0x26305A, orb: 0xEAF2FF, aurora: 0x5FE6B4,
                                     ridge: 0x05060F, star: 0xDCE6FF),
                   frameHex: 0xC3D6E8, glowHex: 0x6FE6D0, isDark: true),
        MiHoloCard(id: "cloud", nameKey: "card_cloud_name", subtitleKey: "card_cloud_sub",
                   rarityKey: "rarity_art", poemKey: "card_cloud_poem", sealChar: "云", foilStyle: 2,
                   scene: MiArtScene(kind: .clouds, skyTop: 0xF6CBA4, skyMid: 0xE9B3C2,
                                     skyBottom: 0xC7B6E2, orb: 0xFFF1D6, aurora: 0xFBE6CC,
                                     ridge: 0x2A2748, star: 0xFFFFFF),
                   frameHex: 0xE7C97E, glowHex: 0xFFD9A0, isDark: false),
        MiHoloCard(id: "tide", nameKey: "card_tide_name", subtitleKey: "card_tide_sub",
                   rarityKey: "rarity_art", poemKey: "card_tide_poem", sealChar: "潮", foilStyle: 1,
                   scene: MiArtScene(kind: .tide, skyTop: 0x1A1136, skyMid: 0x3A1E54,
                                     skyBottom: 0x5C2C6A, orb: 0xFBE9F2, aurora: 0x7A3E8E,
                                     ridge: 0x080510, star: 0xF2D9FF),
                   frameHex: 0xE9D7A8, glowHex: 0x9D6FE6, isDark: true),
        MiHoloCard(id: "snow", nameKey: "card_snow_name", subtitleKey: "card_snow_sub",
                   rarityKey: "rarity_art", poemKey: "card_snow_poem", sealChar: "雪", foilStyle: 2,
                   scene: MiArtScene(kind: .snow, skyTop: 0xCFD9E4, skyMid: 0xE2E9F0,
                                     skyBottom: 0xEFF3F7, orb: 0xF6F8FB, aurora: 0xB4C6D8,
                                     ridge: 0x2E343C, star: 0xFFFFFF),
                   frameHex: 0xCBD6E2, glowHex: 0xCFE0F0, isDark: false),
        MiHoloCard(id: "waterfall", nameKey: "card_waterfall_name", subtitleKey: "card_waterfall_sub",
                   rarityKey: "rarity_art", poemKey: "card_waterfall_poem", sealChar: "虹", foilStyle: 0,
                   scene: MiArtScene(kind: .waterfall, skyTop: 0xBFD0CE, skyMid: 0xCEDAD6,
                                     skyBottom: 0xDBE3DD, orb: 0xFCFEFB, aurora: 0xCFE0D8,
                                     ridge: 0x1E2A23, star: 0xFFFFFF),
                   frameHex: 0xC6D6BE, glowHex: 0xEDE6D2, isDark: false)
    ]
}

struct MiHoloCardView: View {
    static let cardSize = CGSize(width: 300, height: 418)   // aspect ~0.718
    private static let radius: CGFloat = 14

    let card: MiHoloCard
    /// Pointer / tilt in -1...1 (from touch drag or gyroscope).
    let pointer: SIMD2<Float>
    let time: Float
    /// Shader intensity (the fractional part; 0 disables the shader).
    let strength: Float
    /// True while the user is dragging — lifts and scales the card a touch.
    var engaged: Bool = false
    var reduceMotion: Bool = false

    private var px: CGFloat { CGFloat(pointer.x) }
    private var py: CGFloat { CGFloat(pointer.y) }
    private var isActive: Bool { strength > 0.001 }

    var body: some View {
        let w = Self.cardSize.width
        let h = Self.cardSize.height
        let bob: CGFloat = (reduceMotion || !isActive || engaged) ? 0 : CGFloat(sin(time * 1.1)) * 2.5

        ZStack {
            // Floating contact shadow (cached; translates with tilt).
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [Color.black.opacity(0.34), .clear],
                        center: .center, startRadius: 2, endRadius: w * 0.5
                    )
                )
                .frame(width: w * 0.92, height: h * 0.3)
                .blur(radius: 12)
                .drawingGroup()
                .offset(x: -px * 18, y: h * 0.42)

            // The card.
            MiHoloCardFace(card: card)
                .frame(width: w, height: h)
                .compositingGroup()
                .colorEffect(
                    ShaderLibrary.miHoloFoil(
                        .float2(Self.cardSize),
                        .float(pointer.x),
                        .float(pointer.y),
                        .float(time),
                        .float(Float(card.foilStyle) + strength),
                        .float3(card.tintR, card.tintG, card.tintB)
                    ),
                    isEnabled: isActive
                )
                .overlay(rimLight)
                .clipShape(RoundedRectangle(cornerRadius: Self.radius, style: .continuous))
                .rotation3DEffect(.degrees(Double(-px) * 15),
                                  axis: (x: 0, y: 1, z: 0), perspective: 0.5)
                .rotation3DEffect(.degrees(Double(py) * 20),
                                  axis: (x: 1, y: 0, z: 0), perspective: 0.5)
                .offset(x: px * 8, y: py * 8 + bob)
                .scaleEffect(engaged ? 1.15 : 1.0)
                .animation(
                    reduceMotion
                        ? .easeOut(duration: 0.2)
                        : (engaged
                            ? .spring(response: 0.42, dampingFraction: 0.55)
                            : .spring(response: 0.34, dampingFraction: 0.82)),
                    value: engaged
                )
        }
        .frame(width: w + 90, height: h + 120)
    }

    // Edge highlight that brightens on the side facing the pointer.
    private var rimLight: some View {
        RoundedRectangle(cornerRadius: Self.radius, style: .continuous)
            .strokeBorder(
                LinearGradient(
                    colors: [Color.white.opacity(0.95), Color.white.opacity(0.12), .clear],
                    startPoint: UnitPoint(x: 0.5 - px * 0.55, y: 0.5 - py * 0.55),
                    endPoint: UnitPoint(x: 0.5 + px * 0.55, y: 0.5 + py * 0.55)
                ),
                lineWidth: 1.4
            )
    }
}

/// Full-art card face: a procedural atmospheric scene under a metal frame with an
/// elegant title plate. Authored in SwiftUI (no IP assets).
private struct MiHoloCardFace: View {
    let card: MiHoloCard

    private var frameGradient: LinearGradient {
        LinearGradient(
            colors: [card.frame, card.frame.opacity(0.5), Color.white.opacity(0.7), card.frame.opacity(0.6)],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
    }

    var body: some View {
        ZStack {
            MiArtSceneView(scene: card.scene)

            // bottom scrim so the title plate stays legible over the art
            LinearGradient(
                colors: [.clear, .clear, .black.opacity(0.5), .black.opacity(0.66)],
                startPoint: .top, endPoint: .bottom
            )

            VStack(spacing: 0) {
                Spacer(minLength: 0)
                titlePlate
            }
            .padding(13)
        }
        .frame(width: MiHoloCardView.cardSize.width, height: MiHoloCardView.cardSize.height)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(frameGradient, lineWidth: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 11, style: .continuous)
                .inset(by: 3.5)
                .strokeBorder(Color.white.opacity(0.22), lineWidth: 0.8)
        )
    }

    private var titlePlate: some View {
        HStack(alignment: .bottom, spacing: 10) {
            VStack(alignment: .leading, spacing: 5) {
                rarityTag

                Text(MiL10n.text(card.nameKey))
                    .font(.system(size: 23, weight: .bold, design: .serif))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.55), radius: 4, y: 1)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                Rectangle()
                    .fill(LinearGradient(colors: [card.frame.opacity(0.95), card.frame.opacity(0.0)],
                                         startPoint: .leading, endPoint: .trailing))
                    .frame(height: 1)
                    .padding(.vertical, 1)

                Text(MiL10n.text(card.subtitleKey))
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))
                    .shadow(color: .black.opacity(0.5), radius: 3, y: 1)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }

            Spacer(minLength: 4)

            seal
        }
    }

    // a small vermilion seal (落款) — a classic ink-painting finishing touch
    private var seal: some View {
        Text(card.sealChar)
            .font(.system(size: 14, weight: .bold, design: .serif))
            .foregroundStyle(.white)
            .frame(width: 26, height: 26)
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(Color(hex: 0xB23A33))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.3), lineWidth: 0.6)
            )
            .rotationEffect(.degrees(-3))
            .shadow(color: .black.opacity(0.35), radius: 2, y: 1)
            .padding(.bottom, 1)
    }

    private var rarityTag: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(AngularGradient(
                    colors: [.red, .yellow, .green, .cyan, .blue, .purple, .red],
                    center: .center))
                .frame(width: 9, height: 9)
                .overlay(Circle().strokeBorder(Color.white.opacity(0.7), lineWidth: 0.6))
            Text(MiL10n.text(card.rarityKey))
                .font(.system(size: 9.5, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .tracking(0.5)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3.5)
        .background(Capsule().fill(Color.black.opacity(0.32)))
        .overlay(Capsule().strokeBorder(card.frame.opacity(0.7), lineWidth: 0.8))
    }
}
