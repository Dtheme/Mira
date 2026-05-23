//
//  MiGlassSurfaceModifier.swift
//  Mira
//
//  Created on 2026/5/22.
//

import SwiftUI

struct MiGlassSurfaceModifier: ViewModifier {
    let cornerRadius: CGFloat
    let tint: Color?
    let interactive: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            content
                .glassEffect(.regular.tint(tint).interactive(interactive), in: shape)
                .overlay {
                    shape
                        .strokeBorder(MiColorTokens.glassBorder, lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.22), radius: 24, x: 0, y: 14)
        } else {
            content
                .background {
                    shape
                        .fill(.ultraThinMaterial)
                        .overlay {
                            shape
                                .fill((tint ?? MiColorTokens.appleBlue500).opacity(0.12))
                        }
                }
                .overlay {
                    shape
                        .strokeBorder(MiColorTokens.glassBorder, lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.22), radius: 24, x: 0, y: 14)
        }
    }
}

extension View {
    func miGlassSurface(
        cornerRadius: CGFloat = 28,
        tint: Color? = MiColorTokens.appleBlue500.opacity(0.18),
        interactive: Bool = false
    ) -> some View {
        modifier(
            MiGlassSurfaceModifier(
                cornerRadius: cornerRadius,
                tint: tint,
                interactive: interactive
            )
        )
    }
}
