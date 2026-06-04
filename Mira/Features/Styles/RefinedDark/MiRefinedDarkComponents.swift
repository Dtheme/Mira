//
//  MiRefinedDarkComponents.swift
//  Mira
//
//  Reusable Refined Dark primitives: hairline-bordered dark cards, a gradient
//  primary with soft glow, hairline secondary/ghost controls, and per-cell states.
//

import SwiftUI

// MARK: - Card

struct MiRDCard<Content: View>: View {
    var fill: Color
    var radius: CGFloat
    var padding: CGFloat
    var activeAccent: Bool
    @ViewBuilder var content: Content

    init(
        fill: Color = MiRefinedDarkTokens.surface,
        radius: CGFloat = MiRefinedDarkTokens.radius,
        padding: CGFloat = 16,
        activeAccent: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.fill = fill
        self.radius = radius
        self.padding = padding
        self.activeAccent = activeAccent
        self.content = content()
    }

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)

        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                shape
                    .fill(fill)
                    // Top highlight line for a crisp edge.
                    .overlay(alignment: .top) {
                        LinearGradient(colors: [Color.white.opacity(0.10), .clear], startPoint: .top, endPoint: .center)
                            .frame(height: 1.2)
                            .clipShape(shape)
                    }
                    .overlay {
                        shape.strokeBorder(activeAccent ? MiRefinedDarkTokens.accent.opacity(0.55) : MiRefinedDarkTokens.hairline, lineWidth: 1)
                    }
            }
    }
}

struct MiRDSection<Content: View>: View {
    let titleKey: String
    let bodyKey: String
    @ViewBuilder let content: Content

    init(titleKey: String, bodyKey: String, @ViewBuilder content: () -> Content) {
        self.titleKey = titleKey
        self.bodyKey = bodyKey
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(MiL10n.text(titleKey))
                    .font(.system(size: 21, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiRefinedDarkTokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 13.5, weight: .regular, design: .rounded))
                    .foregroundStyle(MiRefinedDarkTokens.muted)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }

            content
        }
    }
}

// MARK: - Buttons

enum MiRDButtonRole {
    case primary
    case secondary
    case ghost
    case disabled
}

struct MiRDButton: View {
    let titleKey: String
    let systemImage: String
    let role: MiRDButtonRole

    var body: some View {
        Button {} label: {
            Label(MiL10n.text(titleKey), systemImage: systemImage)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .frame(maxWidth: .infinity)
                .frame(minHeight: 46)
        }
        .buttonStyle(MiRDButtonStyle(role: role))
        .disabled(role == .disabled)
    }
}

struct MiRDButtonStyle: ButtonStyle {
    let role: MiRDButtonRole
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        let pressed = configuration.isPressed && role != .disabled
        let shape = RoundedRectangle(cornerRadius: MiRefinedDarkTokens.smallRadius, style: .continuous)

        configuration.label
            .foregroundStyle(foreground)
            .padding(.horizontal, 14)
            .background {
                shape
                    .fill(backgroundStyle)
                    .overlay {
                        if role == .secondary || role == .ghost {
                            shape.strokeBorder(MiRefinedDarkTokens.hairlineStrong, lineWidth: 1)
                        }
                    }
            }
            .shadow(color: MiRefinedDarkTokens.accent.opacity(role == .primary ? (pressed ? 0.45 : 0.3) : 0), radius: pressed ? 6 : 12, x: 0, y: 4)
            .brightness(pressed ? 0.04 : 0)
            .scaleEffect(pressed && !reduceMotion ? 0.98 : 1)
            .opacity(role == .disabled ? 0.5 : 1)
            .animation(reduceMotion ? .easeOut(duration: 0.01) : .easeOut(duration: 0.16), value: configuration.isPressed)
    }

    private var backgroundStyle: AnyShapeStyle {
        switch role {
        case .primary:
            return AnyShapeStyle(LinearGradient(colors: [MiRefinedDarkTokens.accent, MiRefinedDarkTokens.accentDeep], startPoint: .topLeading, endPoint: .bottomTrailing))
        case .secondary:
            return AnyShapeStyle(MiRefinedDarkTokens.surfaceRaised)
        case .ghost:
            return AnyShapeStyle(Color.clear)
        case .disabled:
            return AnyShapeStyle(MiRefinedDarkTokens.surface)
        }
    }

    private var foreground: Color {
        switch role {
        case .primary: return .white
        case .secondary: return MiRefinedDarkTokens.ink
        case .ghost: return MiRefinedDarkTokens.muted
        case .disabled: return MiRefinedDarkTokens.muted
        }
    }
}

struct MiRDSegmentStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        let shape = RoundedRectangle(cornerRadius: 9, style: .continuous)

        configuration.label
            .foregroundStyle(isSelected ? MiRefinedDarkTokens.ink : MiRefinedDarkTokens.muted)
            .background {
                if isSelected {
                    shape
                        .fill(MiRefinedDarkTokens.surfaceRaised)
                        .overlay { shape.strokeBorder(MiRefinedDarkTokens.accent.opacity(0.4), lineWidth: 1) }
                        .shadow(color: MiRefinedDarkTokens.accent.opacity(0.22), radius: 8, x: 0, y: 2)
                }
            }
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

// MARK: - Chip & readout

struct MiRDChip: View {
    let titleKey: String
    let tint: Color

    var body: some View {
        Text(MiL10n.text(titleKey))
            .font(.system(size: 11.5, weight: .semibold, design: .rounded))
            .foregroundStyle(MiRefinedDarkTokens.ink)
            .padding(.horizontal, 11)
            .frame(height: 30)
            .background {
                Capsule(style: .continuous)
                    .fill(MiRefinedDarkTokens.surfaceRaised)
                    .overlay { Capsule(style: .continuous).strokeBorder(tint.opacity(0.45), lineWidth: 1) }
            }
    }
}

struct MiRDMetricRow: View {
    let labelKey: String
    let value: String
    let tint: Color

    var body: some View {
        HStack {
            Text(MiL10n.text(labelKey).uppercased())
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .tracking(0.6)
                .foregroundStyle(MiRefinedDarkTokens.muted)
            Spacer(minLength: 8)
            Text(value)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(MiRefinedDarkTokens.ink)
                .padding(.horizontal, 10)
                .frame(height: 26)
                .background {
                    Capsule(style: .continuous)
                        .fill(MiRefinedDarkTokens.surfaceRaised)
                        .overlay { Capsule(style: .continuous).strokeBorder(tint.opacity(0.4), lineWidth: 1) }
                }
        }
    }
}

struct MiRDTokenSwatch: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        MiRDCard(radius: MiRefinedDarkTokens.smallRadius, padding: 12) {
            VStack(alignment: .leading, spacing: 10) {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(color)
                    .frame(height: 38)
                    .overlay { RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(MiRefinedDarkTokens.hairlineStrong, lineWidth: 1) }
                Text(title)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiRefinedDarkTokens.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                Text(value)
                    .font(.system(size: 11, weight: .regular, design: .monospaced))
                    .foregroundStyle(MiRefinedDarkTokens.muted)
            }
        }
    }
}

// MARK: - State modules

struct MiRDStateCard: View {
    let titleKey: String
    let bodyKey: String
    let systemImage: String
    let tint: Color

    var body: some View {
        MiRDCard(radius: MiRefinedDarkTokens.smallRadius, padding: 14) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: systemImage)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(tint)
                    .frame(width: 32, height: 32)
                    .background { RoundedRectangle(cornerRadius: 9, style: .continuous).fill(tint.opacity(0.14)) }
                Text(MiL10n.text(titleKey))
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiRefinedDarkTokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundStyle(MiRefinedDarkTokens.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(minHeight: 132)
    }
}

/// Loading state as a subtle skeleton shimmer on dark surfaces.
struct MiRDLoadingCard: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var shimmer = false

    var body: some View {
        MiRDCard(radius: MiRefinedDarkTokens.smallRadius, padding: 14) {
            VStack(alignment: .leading, spacing: 10) {
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(MiRefinedDarkTokens.surfaceRaised)
                    .frame(width: 32, height: 32)
                Text(MiL10n.text("rd_loading"))
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiRefinedDarkTokens.ink)
                VStack(alignment: .leading, spacing: 6) {
                    bar(width: nil)
                    bar(width: 72)
                }
                .opacity(reduceMotion ? 1 : (shimmer ? 0.45 : 1))
            }
        }
        .frame(minHeight: 132)
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) { shimmer = true }
        }
    }

    private func bar(width: CGFloat?) -> some View {
        RoundedRectangle(cornerRadius: 4, style: .continuous)
            .fill(MiRefinedDarkTokens.surfaceRaised)
            .frame(width: width, height: 9)
    }
}

/// Error state with an in-card recovery action.
struct MiRDErrorCard: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var recovered = false

    var body: some View {
        MiRDCard(radius: MiRefinedDarkTokens.smallRadius, padding: 14) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: recovered ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(recovered ? MiRefinedDarkTokens.positive : MiRefinedDarkTokens.danger)
                    .frame(width: 32, height: 32)
                    .background { RoundedRectangle(cornerRadius: 9, style: .continuous).fill((recovered ? MiRefinedDarkTokens.positive : MiRefinedDarkTokens.danger).opacity(0.14)) }
                Text(MiL10n.text(recovered ? "algc_recovered" : "rd_error"))
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiRefinedDarkTokens.ink)
                Text(MiL10n.text(recovered ? "rd_recovered_body" : "rd_error_body"))
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundStyle(MiRefinedDarkTokens.muted)
                    .fixedSize(horizontal: false, vertical: true)

                Button {
                    withAnimation(reduceMotion ? .easeOut(duration: 0.01) : .easeOut(duration: 0.18)) {
                        recovered.toggle()
                    }
                } label: {
                    Label(
                        MiL10n.text(recovered ? "algc_recovered" : "algc_retry"),
                        systemImage: recovered ? "checkmark" : "arrow.clockwise"
                    )
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .frame(height: 38)
                }
                .buttonStyle(MiRDButtonStyle(role: recovered ? .secondary : .primary))
            }
        }
        .frame(minHeight: 132)
    }
}
