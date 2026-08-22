//
//  MiHoloEggShowcaseView.swift
//  Mira
//
//  Created on 2026/8/20.
//
//  Host page for the opal-egg COMPONENT: a quiet deep-violet backdrop with
//  `MiHoloEggCard` embedded as a rounded card, plus chrome (title, back,
//  caption). All effect logic and interaction live inside the card itself.
//

import SwiftUI

struct MiHoloEggShowcaseView: View {
    let onBack: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: 0x160D28), Color(hex: 0x241238), Color(hex: 0x120A20)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                topBar

                Spacer(minLength: MiSpacingTokens.sm)

                MiHoloEggCard()
                    .aspectRatio(
                        MiHoloEggView.stageSize.width / MiHoloEggView.stageSize.height,
                        contentMode: .fit
                    )
                    .padding(.horizontal, MiSpacingTokens.lg)
                    .shadow(color: Color(hex: 0x0A0514).opacity(0.5), radius: 24, y: 12)

                Spacer(minLength: MiSpacingTokens.sm)

                Text(MiL10n.text("demo_egg_caption"))
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.72))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, MiSpacingTokens.lg)

                Spacer(minLength: MiSpacingTokens.md)
            }
        }
    }

    private var topBar: some View {
        ZStack {
            Text(MiL10n.text("demo_egg_title"))
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
}
