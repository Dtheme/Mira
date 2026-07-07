//
//  MiHoloCardShowcaseView.swift
//  Mira
//
//  Created on 2026/6/29.
//
//  Hero holographic-card showcase. Drag across the card to drive the pointer
//  (tilt + glare + foil sweep follow the finger, like the reference web effect);
//  release and it eases back to the gyroscope ambient. Prev / next switch the
//  rarity (rainbow rare / cosmos / regular holo). A dark backdrop lets the foil
//  pop.
//

import SwiftUI

struct MiHoloCardShowcaseView: View {
    let onBack: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.colorSchemeContrast) private var contrast

    @State private var index = 0
    @State private var isDragging = false
    @State private var motion = MiMotionTiltProvider()

    private let cards = MiHoloCard.deck

    private var intensity: Float {
        (reduceTransparency || contrast == .increased) ? 0.32 : 0.72
    }

    var body: some View {
        let stageW = MiHoloCardView.cardSize.width + 90
        let stageH = MiHoloCardView.cardSize.height + 120

        ZStack {
            LinearGradient(
                colors: [Color(hex: 0x14121C), Color(hex: 0x211B30), Color(hex: 0x100E18)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                topBar

                Spacer(minLength: MiSpacingTokens.xs)

                TimelineView(.animation(paused: reduceMotion)) { context in
                    let time = Float(context.date.timeIntervalSinceReferenceDate
                        .truncatingRemainder(dividingBy: 3600))
                    let pointer = motion.advance(time: time, reduceMotion: reduceMotion)
                    MiHoloCardView(
                        card: cards[index],
                        pointer: pointer,
                        time: time,
                        strength: intensity,
                        engaged: isDragging,
                        reduceMotion: reduceMotion
                    )
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(
                        MiL10n.format("card_a11y_fmt",
                                      MiL10n.text(cards[index].nameKey),
                                      MiL10n.text(cards[index].rarityKey))
                    )
                    .id(index)   // one card per page: tear down the old shader raster on switch
                }
                .frame(width: stageW, height: stageH)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            isDragging = true
                            motion.setPointer(pointer(from: value.location, stage: CGSize(width: stageW, height: stageH)))
                        }
                        .onEnded { _ in
                            isDragging = false
                            motion.releasePointer()
                        }
                )

                Spacer(minLength: MiSpacingTokens.xs)

                controls

                Spacer(minLength: MiSpacingTokens.sm)

                Text(MiL10n.text(cards[index].poemKey))
                    .font(.system(size: 15, weight: .regular, design: .serif))
                    .foregroundStyle(.white.opacity(0.8))
                    .tracking(1)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, MiSpacingTokens.lg)
                    .id(index)
                    .transition(.opacity)

                Spacer(minLength: MiSpacingTokens.md)
            }
        }
        .onAppear { motion.start() }
        .onDisappear { motion.stop() }
    }

    private func pointer(from location: CGPoint, stage: CGSize) -> SIMD2<Float> {
        let halfW = MiHoloCardView.cardSize.width / 2
        let halfH = MiHoloCardView.cardSize.height / 2
        let nx = Float((location.x - stage.width / 2) / halfW)
        let ny = Float((location.y - stage.height / 2) / halfH)
        return SIMD2<Float>(max(-1, min(1, nx)), max(-1, min(1, ny)))
    }

    private func go(_ delta: Int) {
        isDragging = false
        motion.resetToNeutral()
        withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
            index = (index + delta + cards.count) % cards.count
        }
    }

    private var topBar: some View {
        ZStack {
            Text(MiL10n.text("demo_holo_title"))
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)

            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(Color.white.opacity(0.14)))
                }
                .accessibilityLabel(MiL10n.text("demo_back"))
                Spacer()
            }
        }
        .padding(.horizontal, MiSpacingTokens.md)
        .padding(.top, MiSpacingTokens.xs)
    }

    private var controls: some View {
        HStack(spacing: MiSpacingTokens.lg) {
            navButton("chevron.left") { go(-1) }
                .accessibilityLabel(MiL10n.text("demo_prev"))

            HStack(spacing: 7) {
                ForEach(cards.indices, id: \.self) { i in
                    Capsule()
                        .fill(Color.white.opacity(i == index ? 0.92 : 0.28))
                        .frame(width: i == index ? 18 : 7, height: 7)
                }
            }
            .accessibilityHidden(true)

            navButton("chevron.right") { go(1) }
                .accessibilityLabel(MiL10n.text("demo_next"))
        }
    }

    private func navButton(_ symbol: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(.white.opacity(0.85))
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
