import SwiftUI

struct MiPlayfulOutlineRhythmDemo: View {
    @Binding var isPlaying: Bool
    let elastic: Bool
    let isSuspended: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var scenePhase
    @State private var isVisible = false
    private typealias T = MiPlayfulOutlineTokens

    private var animates: Bool {
        isPlaying && elastic && isVisible && scenePhase == .active && !reduceMotion && !isSuspended
    }

    private var curveStateKey: String {
        if reduceMotion { return "po_curve_reduced" }
        if !elastic { return "po_curve_disabled" }
        if !isPlaying { return "po_curve_ready" }
        return animates ? "po_curve_flowing" : "po_curve_suspended"
    }

    var body: some View {
        VStack(spacing: 0) {
            TimelineView(.animation(minimumInterval: 1.0 / 24, paused: !animates)) { context in
                let phase = animates ? CGFloat(context.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 24)) * .pi : 0
                ZStack(alignment: .bottom) {
                    T.paper.accessibilityHidden(true)
                    MiPlayfulOutlineWave(phase: phase * 0.25, amplitude: 14)
                        .fill(T.accent)
                        .frame(height: 110)
                        .accessibilityHidden(true)
                    Button { isPlaying.toggle() } label: {
                        ZStack {
                            Circle().fill(isPlaying ? T.accentStrong : T.ink)
                            MiPlayfulOutlineBeatMark(phase: phase, intensity: animates ? 1 : 0)
                                .fill(T.surface)
                                .frame(width: 94, height: 64)
                                .offset(y: -15)
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(T.surface)
                                .contentTransition(reduceMotion ? .opacity : .symbolEffect(.replace.offUp, options: .nonRepeating))
                                .offset(y: 46)
                        }
                        .frame(width: 182, height: 182)
                        .contentShape(Circle())
                    }
                    .buttonStyle(MiPlayfulOutlineRhythmButtonStyle())
                    .accessibilityLabel(MiL10n.text(isPlaying ? "po_pause" : "po_play"))
                    .accessibilityValue(MiL10n.text(isPlaying ? "po_state_on" : "po_state_off"))
                    .accessibilityHint(MiL10n.text("po_signature_hint"))
                    .rotationEffect(.degrees(animates ? sin(Double(phase) * 0.5) * 4 : -8))
                    .offset(y: -34)
                }
                .frame(height: 252)
            }

            VStack(alignment: .leading, spacing: 16) {
                Text(MiL10n.text("po_motion_label"))
                    .font(.system(.title3, design: .rounded, weight: .bold))
                ViewThatFits(in: .horizontal) {
                    HStack(alignment: .top, spacing: 28) {
                        MiPlayfulOutlineReadout(titleKey: "po_readout_motion", valueKey: isPlaying ? "po_state_on" : "po_state_off")
                        MiPlayfulOutlineReadout(titleKey: "po_readout_curves", valueKey: curveStateKey)
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        MiPlayfulOutlineReadout(titleKey: "po_readout_motion", valueKey: isPlaying ? "po_state_on" : "po_state_off")
                        MiPlayfulOutlineReadout(titleKey: "po_readout_curves", valueKey: curveStateKey)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .padding(.bottom, 28)
            .background(T.accent)
        }
        .onScrollVisibilityChange(threshold: 0.1) { isVisible = $0 }
    }
}

private struct MiPlayfulOutlineRhythmButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(
                x: configuration.isPressed && !reduceMotion ? 0.97 : 1,
                y: configuration.isPressed && !reduceMotion ? 0.93 : 1
            )
            .opacity(configuration.isPressed ? 0.78 : 1)
            .animation(reduceMotion ? .easeOut(duration: 0.12) : MiPlayfulOutlineTokens.response, value: configuration.isPressed)
    }
}

private struct MiPlayfulOutlineReadout: View {
    let titleKey: String
    let valueKey: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(MiL10n.text(titleKey))
                .font(.caption)
                .foregroundStyle(MiPlayfulOutlineTokens.muted)
            Text(MiL10n.text(valueKey))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(MiPlayfulOutlineTokens.ink)
        }
        .fixedSize(horizontal: false, vertical: true)
        .accessibilityElement(children: .combine)
    }
}
