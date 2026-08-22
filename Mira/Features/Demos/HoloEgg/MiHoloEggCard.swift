//
//  MiHoloEggCard.swift
//  Mira
//
//  Created on 2026/8/20.
//
//  The opal egg as ONE self-contained, embeddable component: a rounded card
//  carrying the violet star-dust stage (`miSparkleField`) with the layered
//  egg floating at its center. Drop it into any layout at any size — it
//  drives its own animation clock, scales its content to fit, handles the
//  tap-zoom, and carries its own accessibility. The host page provides
//  nothing but a frame.
//

import SwiftUI

struct MiHoloEggCard: View {
    var cornerRadius: CGFloat = 28

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.colorSchemeContrast) private var contrast

    @State private var isZoomed = false

    private var strength: Float {
        (reduceTransparency || contrast == .increased) ? 0.45 : 1.0
    }

    var body: some View {
        GeometryReader { proxy in
            let fit = min(proxy.size.width / MiHoloEggView.stageSize.width,
                          proxy.size.height / MiHoloEggView.stageSize.height)

            TimelineView(.animation(paused: reduceMotion)) { context in
                let time = Float(context.date.timeIntervalSinceReferenceDate
                    .truncatingRemainder(dividingBy: 3600))

                ZStack {
                    stage(time: time, size: proxy.size)

                    MiHoloEggView(
                        time: time,
                        strength: strength,
                        zoomed: isZoomed,
                        reduceMotion: reduceMotion
                    )
                    // breathing room around the egg, like the reference
                    .scaleEffect(fit * 0.78)
                    .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
                    .contentShape(Ellipse())
                    .onTapGesture { toggleZoom() }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(Color.white.opacity(0.16), lineWidth: 1)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(MiL10n.text("demo_egg_a11y"))
        .accessibilityHint(MiL10n.text("demo_egg_a11y_hint"))
        .accessibilityAddTraits(.isButton)
    }

    private func toggleZoom() {
        let animation: Animation = reduceMotion
            ? .easeInOut(duration: 0.2)
            : .spring(response: 0.45, dampingFraction: 0.62)
        withAnimation(animation) {
            isZoomed.toggle()
        }
    }

    // Violet stage: layered gradients carrying the sparkle-field shader,
    // whitish at the top and bottom edges like the reference.
    private func stage(time: Float, size: CGSize) -> some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: Color(hex: 0xC9A4F0), location: 0.0),
                    .init(color: Color(hex: 0x9B2BD6), location: 0.28),
                    .init(color: Color(hex: 0x8A1EC8), location: 0.55),
                    .init(color: Color(hex: 0xB44FD6), location: 0.82),
                    .init(color: Color(hex: 0xE3A6EC), location: 1.0)
                ],
                startPoint: .top, endPoint: .bottom
            )
            RadialGradient(
                colors: [Color(hex: 0xC46BEF).opacity(0.35), .clear],
                center: UnitPoint(x: 0.5, y: 0.45),
                startRadius: 10,
                endRadius: max(size.width, size.height) * 0.75
            )
        }
        .compositingGroup()
        .colorEffect(
            ShaderLibrary.miSparkleField(
                .float2(size),
                .float(time),
                .float(strength)
            )
        )
    }
}
