//
//  MiStyleTitleTransition.swift
//  Mira
//

import SwiftUI

extension View {
    func miStyleTitleTransition(_ styleID: String) -> some View {
        self
    }

    func miStaggeredReveal(index: Int, isRevealed: Bool) -> some View {
        modifier(MiStaggeredRevealModifier(index: index, isRevealed: isRevealed))
    }
}

struct MiStaggeredRevealModifier: ViewModifier {
    let index: Int
    let isRevealed: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content
            .opacity(isRevealed ? 1 : 0)
            .offset(y: isRevealed ? 0 : 14)
            .animation(animation, value: isRevealed)
    }

    private var animation: Animation {
        if reduceMotion {
            return .easeOut(duration: 0.16).delay(Double(index) * 0.015)
        }
        return .spring(response: 0.42, dampingFraction: 0.88, blendDuration: 0)
            .delay(Double(index) * 0.045)
    }
}
