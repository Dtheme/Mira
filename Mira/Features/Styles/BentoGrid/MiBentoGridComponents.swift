//
//  MiBentoGridComponents.swift
//  Mira
//
//  Reusable Bento Grid primitives: modular rounded cells, sections, controls,
//  and per-cell state modules. Every cell shares one radius and one soft shadow.
//

import SwiftUI

// MARK: - Cell

/// The core Bento module: a rounded surface that sits subtly above the canvas
/// with one consistent radius and a soft neutral shadow.
struct MiBentoCell<Content: View>: View {
    var fill: Color
    var radius: CGFloat
    var padding: CGFloat
    var stroked: Bool
    @ViewBuilder var content: Content

    init(
        fill: Color = MiBentoGridTokens.surface,
        radius: CGFloat = MiBentoGridTokens.radius,
        padding: CGFloat = 16,
        stroked: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.fill = fill
        self.radius = radius
        self.padding = padding
        self.stroked = stroked
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
                    .overlay {
                        if stroked {
                            shape.strokeBorder(MiBentoGridTokens.stroke, lineWidth: 1)
                        }
                    }
            }
            .shadow(color: MiBentoGridTokens.ink.opacity(0.06), radius: 10, x: 0, y: 6)
    }
}

// MARK: - Section

struct MiBentoSection<Content: View>: View {
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
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(MiBentoGridTokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 13.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiBentoGridTokens.muted)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }

            content
        }
    }
}

// MARK: - Tag chip used inside cells

struct MiBentoTag: View {
    let titleKey: String
    let tint: Color

    var body: some View {
        Text(MiL10n.text(titleKey).uppercased())
            .font(.system(size: 10, weight: .black, design: .rounded))
            .tracking(0.5)
            .foregroundStyle(tint)
            .padding(.horizontal, 8)
            .frame(height: 22)
            .background {
                Capsule(style: .continuous).fill(tint.opacity(0.12))
            }
    }
}

// MARK: - Buttons

enum MiBentoButtonRole {
    case primary
    case tonal
    case outlined
    case disabled
}

struct MiBentoButton: View {
    let titleKey: String
    let systemImage: String
    let role: MiBentoButtonRole

    var body: some View {
        Button {} label: {
            Label(MiL10n.text(titleKey), systemImage: systemImage)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity)
                .frame(minHeight: 46)
        }
        .buttonStyle(MiBentoButtonStyle(role: role))
        .disabled(role == .disabled)
    }
}

struct MiBentoButtonStyle: ButtonStyle {
    let role: MiBentoButtonRole

    func makeBody(configuration: Configuration) -> some View {
        let shape = RoundedRectangle(cornerRadius: 14, style: .continuous)

        configuration.label
            .foregroundStyle(foreground)
            .padding(.horizontal, 14)
            .background {
                shape
                    .fill(background)
                    .overlay {
                        if role == .outlined {
                            shape.strokeBorder(MiBentoGridTokens.accent.opacity(0.55), lineWidth: 1.4)
                        }
                    }
            }
            .opacity(role == .disabled ? 0.6 : 1)
            .scaleEffect(configuration.isPressed && role != .disabled ? 0.97 : 1)
            .animation(.spring(response: 0.2, dampingFraction: 0.86), value: configuration.isPressed)
    }

    private var background: Color {
        switch role {
        case .primary: return MiBentoGridTokens.accent
        case .tonal: return MiBentoGridTokens.accent.opacity(0.14)
        case .outlined: return .clear
        case .disabled: return MiBentoGridTokens.surfaceAlt
        }
    }

    private var foreground: Color {
        switch role {
        case .primary: return .white
        case .tonal, .outlined: return MiBentoGridTokens.accent
        case .disabled: return MiBentoGridTokens.muted
        }
    }
}

// MARK: - Readout row

struct MiBentoMetricRow: View {
    let labelKey: String
    let value: String
    let tint: Color

    var body: some View {
        HStack {
            Text(MiL10n.text(labelKey).uppercased())
                .font(.system(size: 10.5, weight: .black, design: .rounded))
                .tracking(0.5)
                .foregroundStyle(MiBentoGridTokens.muted)
            Spacer(minLength: 8)
            Text(value)
                .font(.system(size: 12.5, weight: .heavy, design: .rounded))
                .foregroundStyle(MiBentoGridTokens.ink)
                .padding(.horizontal, 10)
                .frame(height: 26)
                .background {
                    Capsule(style: .continuous).fill(tint.opacity(0.16))
                }
        }
    }
}

// MARK: - Token swatch

struct MiBentoTokenSwatch: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        MiBentoCell(radius: MiBentoGridTokens.smallRadius, padding: 12) {
            VStack(alignment: .leading, spacing: 10) {
                RoundedRectangle(cornerRadius: MiBentoGridTokens.tinyRadius, style: .continuous)
                    .fill(color)
                    .frame(height: 40)
                    .overlay {
                        RoundedRectangle(cornerRadius: MiBentoGridTokens.tinyRadius, style: .continuous)
                            .strokeBorder(MiBentoGridTokens.stroke, lineWidth: 1)
                    }
                Text(title)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(MiBentoGridTokens.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                Text(value)
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                    .foregroundStyle(MiBentoGridTokens.muted)
            }
        }
    }
}

// MARK: - State modules

struct MiBentoStateCard: View {
    let titleKey: String
    let bodyKey: String
    let systemImage: String
    let tint: Color

    var body: some View {
        MiBentoCell(radius: MiBentoGridTokens.smallRadius, padding: 14) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: systemImage)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(tint)
                    .frame(width: 34, height: 34)
                    .background { RoundedRectangle(cornerRadius: 10, style: .continuous).fill(tint.opacity(0.14)) }
                Text(MiL10n.text(titleKey))
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(MiBentoGridTokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(MiBentoGridTokens.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(minHeight: 132)
    }
}

/// Loading state as per-cell skeleton blocks that match the tile shape.
struct MiBentoLoadingCard: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var shimmer = false

    var body: some View {
        MiBentoCell(radius: MiBentoGridTokens.smallRadius, padding: 14) {
            VStack(alignment: .leading, spacing: 10) {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(MiBentoGridTokens.surfaceAlt)
                    .frame(width: 34, height: 34)
                Text(MiL10n.text("bento_loading"))
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(MiBentoGridTokens.ink)

                VStack(alignment: .leading, spacing: 6) {
                    skeletonBar(width: nil)
                    skeletonBar(width: 70)
                }
                .opacity(reduceMotion ? 1 : (shimmer ? 0.5 : 1))
            }
        }
        .frame(minHeight: 132)
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                shimmer = true
            }
        }
    }

    private func skeletonBar(width: CGFloat?) -> some View {
        RoundedRectangle(cornerRadius: 4, style: .continuous)
            .fill(MiBentoGridTokens.surfaceAlt)
            .frame(width: width, height: 9)
    }
}

/// Error state with an in-cell recovery action.
struct MiBentoErrorCard: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var recovered = false

    var body: some View {
        MiBentoCell(fill: recovered ? MiBentoGridTokens.accent2.opacity(0.10) : Color(hex: 0xFDECEC), radius: MiBentoGridTokens.smallRadius, padding: 14) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: recovered ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(recovered ? MiBentoGridTokens.accent2 : Color(hex: 0xE5484D))
                    .frame(width: 34, height: 34)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill((recovered ? MiBentoGridTokens.accent2 : Color(hex: 0xE5484D)).opacity(0.14))
                    }
                Text(MiL10n.text(recovered ? "algc_recovered" : "bento_error"))
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(MiBentoGridTokens.ink)
                Text(MiL10n.text(recovered ? "bento_recovered_body" : "bento_error_body"))
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(MiBentoGridTokens.muted)
                    .fixedSize(horizontal: false, vertical: true)

                Button {
                    withAnimation(reduceMotion ? .easeOut(duration: 0.01) : .spring(response: 0.3, dampingFraction: 0.84)) {
                        recovered.toggle()
                    }
                } label: {
                    Label(
                        MiL10n.text(recovered ? "algc_recovered" : "algc_retry"),
                        systemImage: recovered ? "checkmark" : "arrow.clockwise"
                    )
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                }
                .buttonStyle(MiBentoButtonStyle(role: recovered ? .primary : .tonal))
            }
        }
        .frame(minHeight: 132)
    }
}
