//
//  MiMinimalismTokens.swift
//  Mira
//
//  Created on 2026/5/25.
//

import SwiftUI

enum MiMinimalismTokens {
    static let paper = Color(hex: 0xFCFCFA)
    static let ink = Color(hex: 0x111111)
    static let muted = Color(hex: 0x666B73)
    static let hairline = Color(hex: 0xD9D9D4)
    static let accent = Color(hex: 0x0A84FF)
    static let quiet = Color(hex: 0xF4F4F0)
    static let radius: CGFloat = 2
    static let sectionSpacing: CGFloat = 30

    static var pageBackground: some View {
        paper
            .overlay {
                MiMinimalismGrid(step: 24, color: hairline.opacity(0.38))
            }
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.90),
                                Color.white.opacity(0.58),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 180)
                    .allowsHitTesting(false)
            }
    }
}

struct MiMinimalismGrid: View {
    let step: CGFloat
    let color: Color

    var body: some View {
        Canvas { context, size in
            var x: CGFloat = 0
            while x <= size.width {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path, with: .color(color), lineWidth: 0.5)
                x += step
            }
            var y: CGFloat = 0
            while y <= size.height {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(color), lineWidth: 0.5)
                y += step
            }
        }
        .allowsHitTesting(false)
    }
}
