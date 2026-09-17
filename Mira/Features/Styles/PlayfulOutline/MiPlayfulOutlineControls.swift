import SwiftUI

struct MiPlayfulOutlineButtonStyle: ButtonStyle {
    var filled = false
    var destructive = false

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorSchemeContrast) private var contrast

    func makeBody(configuration: Configuration) -> some View {
        let ink = destructive ? MiPlayfulOutlineTokens.error : MiPlayfulOutlineTokens.ink
        let secondaryFill = destructive
            ? MiPlayfulOutlineTokens.errorSurface
            : configuration.isPressed || contrast == .increased ? MiPlayfulOutlineTokens.accent : MiPlayfulOutlineTokens.control

        configuration.label
            .font(.system(.subheadline, design: .rounded, weight: .semibold))
            .multilineTextAlignment(.center)
            .foregroundStyle(filled ? MiPlayfulOutlineTokens.paper : ink)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .frame(minHeight: 48)
            .background {
                Capsule()
                    .fill(filled ? ink : secondaryFill)
            }
            .contentShape(Capsule())
            .scaleEffect(
                x: configuration.isPressed && !reduceMotion ? 0.97 : 1,
                y: configuration.isPressed && !reduceMotion ? 0.94 : 1
            )
            .opacity(isEnabled ? configuration.isPressed && filled ? 0.84 : 1 : 0.42)
            .animation(reduceMotion ? .easeOut(duration: 0.12) : MiPlayfulOutlineTokens.response, value: configuration.isPressed)
    }
}

struct MiPlayfulOutlineCircleButtonStyle: ButtonStyle {
    var filled = false

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorSchemeContrast) private var contrast

    func makeBody(configuration: Configuration) -> some View {
        let ink = MiPlayfulOutlineTokens.ink
        let secondaryFill = configuration.isPressed || contrast == .increased
            ? MiPlayfulOutlineTokens.accent : MiPlayfulOutlineTokens.control

        configuration.label
            .font(.system(size: 18, weight: .semibold, design: .rounded))
            .foregroundStyle(filled ? MiPlayfulOutlineTokens.paper : ink)
            .frame(width: 52, height: 52)
            .background {
                Circle()
                    .fill(filled ? ink : secondaryFill)
            }
            .contentShape(Circle())
            .scaleEffect(
                x: configuration.isPressed && !reduceMotion ? 0.95 : 1,
                y: configuration.isPressed && !reduceMotion ? 0.90 : 1
            )
            .opacity(isEnabled ? configuration.isPressed && filled ? 0.84 : 1 : 0.42)
            .animation(reduceMotion ? .easeOut(duration: 0.12) : MiPlayfulOutlineTokens.response, value: configuration.isPressed)
    }
}

struct MiPlayfulOutlineToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        MiPlayfulOutlineToggleBody(configuration: configuration)
    }
}

private struct MiPlayfulOutlineToggleBody: View {
    let configuration: ToggleStyleConfiguration

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorSchemeContrast) private var contrast
    @Environment(\.layoutDirection) private var layoutDirection

    var body: some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack(spacing: 16) {
                configuration.label
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)

                ZStack {
                    Capsule()
                        .fill(configuration.isOn ? MiPlayfulOutlineTokens.ink : contrast == .increased ? MiPlayfulOutlineTokens.muted : MiPlayfulOutlineTokens.control)

                    Circle()
                        .fill(MiPlayfulOutlineTokens.surface)
                        .overlay {
                            Image(systemName: configuration.isOn ? "checkmark" : "minus")
                                .font(.system(size: 11, weight: .bold))
                                .contentTransition(.opacity)
                        }
                        .frame(width: 28, height: 28)
                        .phaseAnimator([false, true, false], trigger: configuration.isOn) { thumb, stretched in
                            thumb.scaleEffect(
                                x: stretched && !reduceMotion ? 1.16 : 1,
                                y: stretched && !reduceMotion ? 0.91 : 1
                            )
                        } animation: { stretched in
                            reduceMotion ? nil : stretched ? .easeOut(duration: 0.10) : MiPlayfulOutlineTokens.response
                        }
                        .offset(x: (configuration.isOn ? 14 : -14) * (layoutDirection == .rightToLeft ? -1 : 1))
                }
                .frame(width: 64, height: 36)
                .frame(minHeight: 44)
                .animation(reduceMotion ? nil : MiPlayfulOutlineTokens.response, value: configuration.isOn)
                .accessibilityHidden(true)
            }
            .foregroundStyle(MiPlayfulOutlineTokens.ink)
            .frame(minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .opacity(isEnabled ? 1 : 0.42)
        .accessibilityRepresentation {
            Toggle(isOn: configuration.$isOn) {
                configuration.label
            }
            .toggleStyle(.switch)
        }
    }
}
