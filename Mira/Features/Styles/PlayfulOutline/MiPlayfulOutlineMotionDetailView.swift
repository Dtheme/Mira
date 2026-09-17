import SwiftUI

struct MiPlayfulOutlineMotionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var stage = 0

    private let stages = ["po_detail_gather", "po_detail_stretch", "po_detail_settle"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(MiL10n.text("po_detail_heading"))
                        .font(.system(.largeTitle, design: .rounded, weight: .black))
                        .fixedSize(horizontal: false, vertical: true)
                        .accessibilityAddTraits(.isHeader)
                    Text(MiL10n.text("po_detail_intro"))
                        .font(.body)
                        .foregroundStyle(MiPlayfulOutlineTokens.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }

                MiPlayfulOutlineSegment(titles: stages, selection: $stage)

                MiPlayfulOutlineMotionStage(stage: stage, reduceMotion: reduceMotion)

                VStack(alignment: .leading, spacing: 10) {
                    Text(MiL10n.text(stages[stage]))
                        .font(.system(.title2, design: .rounded, weight: .bold))
                    Text(MiL10n.text(["po_detail_gather_body", "po_detail_stretch_body", "po_detail_settle_body"][stage]))
                        .font(.body)
                        .foregroundStyle(MiPlayfulOutlineTokens.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .id(stage)
                .transition(reduceMotion ? .opacity.animation(.easeOut(duration: 0.16)) : .opacity.combined(with: .offset(y: 10)))
                .accessibilityElement(children: .combine)

                VStack(spacing: 12) {
                    Button {
                        changeStage(to: (stage + 1) % stages.count)
                    } label: {
                        Label(MiL10n.text(stage == 2 ? "po_detail_replay" : "po_detail_next"), systemImage: stage == 2 ? "arrow.counterclockwise" : "arrow.right")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(MiPlayfulOutlineButtonStyle(filled: true))

                    Button {
                        changeStage(to: 0)
                    } label: {
                        Text(MiL10n.text("po_detail_reset"))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(MiPlayfulOutlineButtonStyle())
                    .disabled(stage == 0)
                }

                Text(MiL10n.text(reduceMotion ? "po_detail_reduced_motion" : "po_detail_interrupt_hint"))
                    .font(.callout)
                    .foregroundStyle(MiPlayfulOutlineTokens.muted)
                    .fixedSize(horizontal: false, vertical: true)

                Button {
                    dismiss()
                } label: {
                    Label(MiL10n.text("po_detail_back"), systemImage: "arrow.left")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(MiPlayfulOutlineButtonStyle())
            }
            .frame(maxWidth: 600, alignment: .leading)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 32)
        }
        .background(MiPlayfulOutlineTokens.paper)
        .foregroundStyle(MiPlayfulOutlineTokens.ink)
        .tint(MiPlayfulOutlineTokens.ink)
        .navigationTitle(MiL10n.text("po_detail_title"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbarBackground(MiPlayfulOutlineTokens.paper, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }

    private func changeStage(to next: Int) {
        withAnimation(reduceMotion ? nil : MiPlayfulOutlineTokens.response) {
            stage = next
        }
    }
}

private struct MiPlayfulOutlineMotionStage: View {
    let stage: Int
    let reduceMotion: Bool

    var body: some View {
        GeometryReader { geometry in
            let width = min(geometry.size.width - 24, 264)

            ZStack {
                MiPlayfulOutlineWave(phase: reduceMotion ? 0 : CGFloat(stage) * 0.7, amplitude: 10)
                    .fill(MiPlayfulOutlineTokens.accent)
                    .frame(height: 76)
                    .frame(maxHeight: .infinity, alignment: .bottom)

                if reduceMotion {
                    MiPlayfulOutlineMorph(stage: stage, width: width)
                        .id(stage)
                        .transition(.opacity.animation(.easeOut(duration: 0.16)))
                } else {
                    MiPlayfulOutlineMorph(stage: stage, width: width)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
        }
        .frame(height: 240)
        .accessibilityHidden(true)
    }
}

private struct MiPlayfulOutlineMorph: View {
    let stage: Int
    let width: CGFloat

    private var bodyWidth: CGFloat { stage == 1 ? width : width * 0.65 }
    private var bodyHeight: CGFloat { stage == 1 ? 112 : width * 0.65 }
    private var radius: CGFloat { stage == 2 ? 36 : 120 }

    var body: some View {
        RoundedRectangle(cornerRadius: radius, style: .continuous)
            .fill(stage == 2 ? MiPlayfulOutlineTokens.ink : MiPlayfulOutlineTokens.accentStrong)
            .overlay {
                Image(systemName: ["circle.dotted", "arrow.left.and.right", "checkmark"][stage])
                    .font(.system(size: 44, weight: .medium))
                    .foregroundStyle(MiPlayfulOutlineTokens.surface)
                    .id(stage)
                    .transition(.opacity)
            }
            .frame(width: bodyWidth, height: bodyHeight)
    }
}
