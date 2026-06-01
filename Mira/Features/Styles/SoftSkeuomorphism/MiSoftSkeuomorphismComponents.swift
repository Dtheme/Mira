//
//  MiSoftSkeuomorphismComponents.swift
//  Mira
//
//  Reusable Soft Skeuomorphism primitives: warm cream panels, organic controls,
//  soft gauges, carved inset troughs, and wellness state cards. Extracted from the
//  detail view so the page file owns only composition and the signature object.
//

import SwiftUI

// MARK: - Containers

struct MiSoftSkeuomorphismPanel<Content: View>: View {
    let radius: CGFloat
    let padding: CGFloat
    let content: Content

    init(radius: CGFloat = MiSoftSkeuomorphismTokens.cardRadius, padding: CGFloat = 18, @ViewBuilder content: () -> Content) {
        self.radius = radius
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)

        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                shape
                    .fill(
                        LinearGradient(
                            colors: [
                                MiSoftSkeuomorphismTokens.creamLight,
                                MiSoftSkeuomorphismTokens.card,
                                MiSoftSkeuomorphismTokens.moss.opacity(0.07)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay {
                        shape
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        MiSoftSkeuomorphismTokens.highlight.opacity(0.84),
                                        MiSoftSkeuomorphismTokens.moss.opacity(0.16),
                                        MiSoftSkeuomorphismTokens.warmShadow.opacity(0.18)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    }
            }
            // Top-left highlight + a broad, warm low-opacity bottom shadow.
            .shadow(color: MiSoftSkeuomorphismTokens.highlight.opacity(0.64), radius: 12, x: -6, y: -6)
            .shadow(color: MiSoftSkeuomorphismTokens.warmShadow.opacity(0.20), radius: 20, x: 0, y: 12)
    }
}

struct MiSoftSkeuomorphismSection<Content: View>: View {
    let titleKey: String
    let bodyKey: String
    let content: Content

    init(titleKey: String, bodyKey: String, @ViewBuilder content: () -> Content) {
        self.titleKey = titleKey
        self.bodyKey = bodyKey
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(MiL10n.text(titleKey))
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 13.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }

            content
        }
    }
}

// MARK: - Soft Gauges

struct MiSoftSkeuomorphismGauge: View {
    let progress: Double
    let titleKey: String
    let captionKey: String
    let tint: Color

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(MiSoftSkeuomorphismTokens.cardDeep.opacity(0.55), lineWidth: 12)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(
                            colors: [MiSoftSkeuomorphismTokens.peach, MiSoftSkeuomorphismTokens.butter, tint],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                Text(MiL10n.text(titleKey))
                    .font(.system(size: 21, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                    .minimumScaleFactor(0.70)
            }
            .frame(width: 112, height: 112)

            Text(MiL10n.text(captionKey))
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
        }
        .frame(maxWidth: .infinity)
    }
}

struct MiSoftSkeuomorphismScoreRing: View {
    let isBlooming: Bool

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(MiSoftSkeuomorphismTokens.cardDeep.opacity(0.55), lineWidth: 12)
                Circle()
                    .trim(from: 0, to: isBlooming ? 0.78 : 0.62)
                    .stroke(MiSoftSkeuomorphismTokens.moss, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 0) {
                    Text(isBlooming ? "7.8" : "6.4")
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                    Text(MiL10n.text("softsk_days"))
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                }
            }
            .frame(width: 112, height: 112)

            Text(MiL10n.text("softsk_sleep_score"))
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
        }
        .frame(maxWidth: .infinity)
    }
}

struct MiSoftSkeuomorphismNotificationPanel: View {
    let isBlooming: Bool

    var body: some View {
        MiSoftSkeuomorphismPanel(radius: 28, padding: 16) {
            VStack(spacing: 12) {
                Text(MiL10n.text("softsk_notification"))
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(MiL10n.text(isBlooming ? "softsk_bloom_on" : "softsk_bloom_idle"))
                    .font(.system(size: 15, weight: .black, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                    .padding(.horizontal, 20)
                    .frame(height: 44)
                    .background {
                        Capsule(style: .continuous)
                            .fill(MiSoftSkeuomorphismTokens.creamLight)
                            .shadow(color: MiSoftSkeuomorphismTokens.shadow.opacity(0.22), radius: 12, x: 0, y: 8)
                    }

                Text(MiL10n.text("softsk_notification_body"))
                    .font(.system(size: 12.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Buttons

enum MiSoftSkeuomorphismButtonRole {
    case primary
    case secondary
    case disabled
}

struct MiSoftSkeuomorphismButton: View {
    let titleKey: String
    let systemImage: String
    let role: MiSoftSkeuomorphismButtonRole

    var body: some View {
        Button {} label: {
            Label(MiL10n.text(titleKey), systemImage: systemImage)
                .font(.system(size: 13.5, weight: .black, design: .rounded))
                .frame(maxWidth: .infinity)
                .frame(minHeight: 48)
        }
        .buttonStyle(MiSoftSkeuomorphismButtonStyle(role: role))
        .disabled(role == .disabled)
    }
}

struct MiSoftSkeuomorphismButtonStyle: ButtonStyle {
    let role: MiSoftSkeuomorphismButtonRole

    func makeBody(configuration: Configuration) -> some View {
        let pressed = configuration.isPressed && role != .disabled

        configuration.label
            .foregroundStyle(role == .primary ? MiSoftSkeuomorphismTokens.ink : MiSoftSkeuomorphismTokens.mossDeep.opacity(role == .disabled ? 0.48 : 1))
            .padding(.horizontal, 14)
            .background {
                Capsule(style: .continuous)
                    .fill(background.opacity(configuration.isPressed ? 0.86 : 1))
                    .overlay {
                        // Warm inner glow grows on press for primary actions.
                        if role == .primary {
                            Capsule(style: .continuous)
                                .fill(MiSoftSkeuomorphismTokens.glow.opacity(pressed ? 0.34 : 0.0))
                        }
                    }
                    .overlay {
                        Capsule(style: .continuous)
                            .strokeBorder(MiSoftSkeuomorphismTokens.highlight.opacity(0.62), lineWidth: 1)
                    }
            }
            .shadow(color: MiSoftSkeuomorphismTokens.warmShadow.opacity(role == .disabled ? 0.08 : 0.22), radius: pressed ? 5 : 12, x: 0, y: pressed ? 3 : 8)
            .scaleEffect(pressed ? 0.97 : 1)
            .animation(.spring(response: 0.20, dampingFraction: 0.82), value: configuration.isPressed)
    }

    private var background: Color {
        switch role {
        case .primary:
            return MiSoftSkeuomorphismTokens.butter.opacity(0.76)
        case .secondary:
            return MiSoftSkeuomorphismTokens.creamLight
        case .disabled:
            return MiSoftSkeuomorphismTokens.cardDeep.opacity(0.42)
        }
    }
}

struct MiSoftSkeuomorphismTopButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
            .background {
                Circle()
                    .fill(MiSoftSkeuomorphismTokens.creamLight)
                    .shadow(color: MiSoftSkeuomorphismTokens.shadow.opacity(configuration.isPressed ? 0.12 : 0.22), radius: configuration.isPressed ? 4 : 9, x: 0, y: configuration.isPressed ? 2 : 6)
            }
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
    }
}

struct MiSoftSkeuomorphismSegmentStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isSelected ? MiSoftSkeuomorphismTokens.ink : MiSoftSkeuomorphismTokens.muted)
            .background {
                Capsule(style: .continuous)
                    .fill(isSelected ? MiSoftSkeuomorphismTokens.moss.opacity(0.26) : MiSoftSkeuomorphismTokens.creamLight.opacity(0.78))
                    .overlay {
                        Capsule(style: .continuous)
                            .strokeBorder(isSelected ? MiSoftSkeuomorphismTokens.moss.opacity(0.46) : MiSoftSkeuomorphismTokens.highlight.opacity(0.58), lineWidth: 1)
                    }
            }
            .opacity(configuration.isPressed ? 0.78 : 1)
    }
}

// MARK: - Carved Inset Field

/// A carved cream trough: inner warm shadow at the top edge, inner highlight at
/// the bottom edge, so the field reads as pressed into the surface (Design.md asks
/// for inset cream troughs, not a raised field). Focus adds a moss stroke.
struct MiSoftSkeuomorphismTrough: View {
    let radius: CGFloat
    let focused: Bool

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)

        shape
            .fill(MiSoftSkeuomorphismTokens.card.opacity(0.9))
            .overlay {
                shape
                    .stroke(MiSoftSkeuomorphismTokens.warmShadow.opacity(0.5), lineWidth: 5)
                    .blur(radius: 4)
                    .offset(y: 3)
                    .mask(shape)
            }
            .overlay {
                shape
                    .stroke(MiSoftSkeuomorphismTokens.highlight.opacity(0.7), lineWidth: 4)
                    .blur(radius: 4)
                    .offset(y: -3)
                    .mask(shape)
            }
            .overlay {
                shape
                    .strokeBorder(MiSoftSkeuomorphismTokens.moss.opacity(focused ? 0.7 : 0), lineWidth: 1.5)
            }
    }
}

struct MiSoftSkeuomorphismInsetField: View {
    @State private var text = ""
    @FocusState private var focused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(MiL10n.text("softsk_input_label").uppercased())
                .font(.system(size: 10.5, weight: .black, design: .rounded))
                .foregroundStyle(focused ? MiSoftSkeuomorphismTokens.mossDeep : MiSoftSkeuomorphismTokens.muted)
                .tracking(0.6)

            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.mossDeep)

                TextField(MiL10n.text("softsk_input_placeholder"), text: $text)
                    .focused($focused)
                    .font(.system(size: 13.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.ink)

                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(MiSoftSkeuomorphismTokens.shadow)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 14)
            .frame(height: 48)
            .background {
                MiSoftSkeuomorphismTrough(radius: 20, focused: focused)
            }
        }
        .animation(.easeOut(duration: 0.18), value: focused)
    }
}

// MARK: - Capsules & Readouts

struct MiSoftSkeuomorphismCapsule: View {
    let titleKey: String
    let fill: Color

    var body: some View {
        Text(MiL10n.text(titleKey))
            .font(.system(size: 11.5, weight: .black, design: .rounded))
            .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
            .padding(.horizontal, 12)
            .frame(height: 34)
            .background {
                Capsule(style: .continuous)
                    .fill(fill)
                    .overlay {
                        Capsule(style: .continuous)
                            .strokeBorder(MiSoftSkeuomorphismTokens.highlight.opacity(0.62), lineWidth: 1)
                    }
            }
    }
}

struct MiSoftSkeuomorphismMetricRow: View {
    let labelKey: String
    let valueKey: String
    let fill: Color

    var body: some View {
        HStack(spacing: 10) {
            Text(MiL10n.text(labelKey).uppercased())
                .font(.system(size: 10.5, weight: .black, design: .rounded))
                .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                .tracking(0.6)

            Spacer(minLength: 8)

            Text(MiL10n.text(valueKey))
                .font(.system(size: 12, weight: .black, design: .rounded))
                .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                .padding(.horizontal, 10)
                .frame(height: 28)
                .background {
                    Capsule(style: .continuous)
                        .fill(fill)
                        .overlay {
                            Capsule(style: .continuous)
                                .strokeBorder(MiSoftSkeuomorphismTokens.highlight.opacity(0.58), lineWidth: 1)
                        }
                }
        }
    }
}

// MARK: - State Cards

struct MiSoftSkeuomorphismStateCard: View {
    let titleKey: String
    let bodyKey: String
    let systemImage: String
    let tint: Color

    var body: some View {
        MiSoftSkeuomorphismPanel(radius: 24, padding: 14) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: systemImage)
                    .font(.system(size: 18, weight: .black))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                    .frame(width: 36, height: 36)
                    .background {
                        Circle()
                            .fill(tint.opacity(0.26))
                    }
                Text(MiL10n.text(titleKey))
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(minHeight: 152)
    }
}

/// Loading state as a calm ring progress (Design.md: calm staged bars or ring
/// progress, never aggressive shimmer). Reduce Motion shows a steady ring.
struct MiSoftSkeuomorphismLoadingCard: View {
    let tint: Color

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var progress: Double = 0.15

    var body: some View {
        MiSoftSkeuomorphismPanel(radius: 24, padding: 14) {
            VStack(alignment: .leading, spacing: 10) {
                ZStack {
                    Circle()
                        .stroke(MiSoftSkeuomorphismTokens.cardDeep.opacity(0.55), lineWidth: 6)
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            LinearGradient(
                                colors: [MiSoftSkeuomorphismTokens.peach, MiSoftSkeuomorphismTokens.butter, tint],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                }
                .frame(width: 36, height: 36)

                Text(MiL10n.text("softsk_loading"))
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                Text(MiL10n.text("softsk_loading_body"))
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(minHeight: 152)
        .onAppear {
            if reduceMotion {
                progress = 0.7
            } else {
                withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                    progress = 0.85
                }
            }
        }
    }
}

/// Error state with an in-style recovery action: a retry pill warms the object
/// glow and eases the card back to a recovered state.
struct MiSoftSkeuomorphismErrorCard: View {
    let tint: Color

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var recovered = false

    var body: some View {
        MiSoftSkeuomorphismPanel(radius: 24, padding: 14) {
            VStack(alignment: .leading, spacing: 10) {
                ZStack {
                    Circle()
                        .fill((recovered ? MiSoftSkeuomorphismTokens.moss : tint).opacity(0.26))
                        .overlay {
                            if recovered {
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [MiSoftSkeuomorphismTokens.glow.opacity(0.6), .clear],
                                            center: .center,
                                            startRadius: 2,
                                            endRadius: 22
                                        )
                                    )
                            }
                        }
                    Image(systemName: recovered ? "checkmark.circle" : "exclamationmark.triangle")
                        .font(.system(size: 18, weight: .black))
                        .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                }
                .frame(width: 36, height: 36)

                Text(MiL10n.text(recovered ? "softsk_recovered" : "softsk_error"))
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                Text(MiL10n.text(recovered ? "softsk_recovered_body" : "softsk_error_body"))
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                    .fixedSize(horizontal: false, vertical: true)

                Button {
                    withAnimation(reduceMotion ? .easeOut(duration: 0.01) : .spring(response: 0.34, dampingFraction: 0.78)) {
                        recovered.toggle()
                    }
                } label: {
                    Label(
                        MiL10n.text(recovered ? "softsk_recovered" : "softsk_retry"),
                        systemImage: recovered ? "checkmark" : "arrow.clockwise"
                    )
                    .font(.system(size: 12, weight: .black, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                }
                .buttonStyle(MiSoftSkeuomorphismSegmentStyle(isSelected: recovered))
            }
        }
        .frame(minHeight: 152)
    }
}

// MARK: - Tokens & Bullets

struct MiSoftSkeuomorphismTokenSwatch: View {
    let title: String
    let value: String
    let roleKey: String
    let color: Color

    var body: some View {
        MiSoftSkeuomorphismPanel(radius: 22, padding: 12) {
            VStack(alignment: .leading, spacing: 10) {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(color)
                    .frame(height: 42)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(MiSoftSkeuomorphismTokens.highlight.opacity(0.72), lineWidth: 1)
                    }
                Text(title)
                    .font(.system(size: 12, weight: .black, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.ink)
                    .lineLimit(1)
                Text(value)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.mossDeep)
                Text(MiL10n.text(roleKey))
                    .font(.system(size: 11.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(minHeight: 158)
    }
}

struct MiSoftSkeuomorphismBullet: View {
    let key: String

    init(_ key: String) {
        self.key = key
    }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(MiSoftSkeuomorphismTokens.moss)
                .frame(width: 7, height: 7)
                .padding(.top, 7)
            Text(MiL10n.text(key))
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(MiSoftSkeuomorphismTokens.muted)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
