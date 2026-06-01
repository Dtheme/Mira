//
//  MiClaymorphismComponents.swift
//  Mira
//
//  Reusable Claymorphism primitives: puffy matte clay surfaces, panels,
//  sections, and pastel controls. Extracted from the detail view so the
//  page file only owns composition and the signature interaction.
//

import SwiftUI

// MARK: - Clay Surface

/// The core Claymorphism surface: a puffy matte rounded rectangle with dual
/// outer shadows and masked inner edges.
///
/// Light is treated as coming from the top-left:
/// - `raised`/`pressed` objects float above the surface (outer drop shadows) and
///   carry a white highlight on the top-left inner edge plus a warm occlusion on
///   the bottom-right inner edge.
/// - `inset` objects are carved into the surface: the inner-edge polarity is
///   inverted (warm occlusion top-left, light highlight bottom-right) and the
///   outer drop shadows are removed so the shape reads as a hole, not a button.
struct MiClaymorphismClayShape: View {
    let fill: Color
    let radius: CGFloat
    let isPressed: Bool
    let isInset: Bool
    /// Soft matte top highlight. Disable for swatches that must show a true color.
    var sheen: Bool = true

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)

        shape
            .fill(fill)
            // Matte top sheen: a gentle "lit from above" puff, never a glossy specular.
            .overlay {
                if sheen && !isInset {
                    shape
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(isPressed ? 0.07 : 0.16), .clear],
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                        .mask(shape)
                        .allowsHitTesting(false)
                }
            }
            // Outer dual shadows — only floating (raised/pressed) clay casts them.
            .shadow(
                color: isInset ? .clear : MiClaymorphismTokens.shadowLight.opacity(isPressed ? 0.34 : 0.82),
                radius: isPressed ? 5 : 14,
                x: isPressed ? -3 : -9,
                y: isPressed ? -3 : -9
            )
            .shadow(
                color: isInset ? .clear : MiClaymorphismTokens.shadowDark.opacity(isPressed ? 0.22 : 0.46),
                radius: isPressed ? 6 : 18,
                x: isPressed ? 4 : 10,
                y: isPressed ? 5 : 13
            )
            // Top-left inner edge.
            .overlay {
                shape
                    .stroke(topLeftEdge, lineWidth: isInset ? 6 : 5)
                    .blur(radius: isInset ? 6 : 4)
                    .offset(x: -4, y: -5)
                    .mask(shape)
            }
            // Bottom-right inner edge.
            .overlay {
                shape
                    .stroke(bottomRightEdge, lineWidth: isInset ? 6 : 4)
                    .blur(radius: isInset ? 6 : 5)
                    .offset(x: 4, y: 5)
                    .mask(shape)
            }
    }

    private var topLeftEdge: Color {
        if isInset {
            // Carved hole: top-left inner wall is in shadow.
            return MiClaymorphismTokens.shadowDark.opacity(isPressed ? 0.42 : 0.34)
        }
        // Raised: top-left catches the light.
        return Color.white.opacity(isPressed ? 0.22 : 0.50)
    }

    private var bottomRightEdge: Color {
        if isInset {
            // Carved hole: bottom-right inner wall catches the light.
            return Color.white.opacity(0.55)
        }
        // Raised: warm occlusion deepens when pressed for a pushed-in feel.
        return MiClaymorphismTokens.shadowDark.opacity(isPressed ? 0.26 : 0.14)
    }
}

// MARK: - Containers

struct MiClaymorphismPanel<MiClaymorphismContent: View>: View {
    let fill: Color
    let radius: CGFloat
    let padding: CGFloat
    @ViewBuilder let content: MiClaymorphismContent

    init(
        fill: Color = MiClaymorphismTokens.surfaceLight.opacity(0.82),
        radius: CGFloat = MiClaymorphismTokens.cardRadius,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> MiClaymorphismContent
    ) {
        self.fill = fill
        self.radius = radius
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background {
                MiClaymorphismClayShape(fill: fill, radius: radius, isPressed: false, isInset: false)
            }
    }
}

struct MiClaymorphismSection<MiClaymorphismContent: View>: View {
    let titleKey: String
    let bodyKey: String
    @ViewBuilder let content: MiClaymorphismContent

    init(titleKey: String, bodyKey: String, @ViewBuilder content: () -> MiClaymorphismContent) {
        self.titleKey = titleKey
        self.bodyKey = bodyKey
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(MiL10n.text(titleKey))
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 14.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.muted)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }

            content
        }
    }
}

// MARK: - Readouts

struct MiClaymorphismMetricRow: View {
    let labelKey: String
    let valueKey: String
    let fill: Color

    var body: some View {
        HStack(spacing: 9) {
            Text(MiL10n.text(labelKey).uppercased())
                .font(.system(size: 10.5, weight: .black, design: .rounded))
                .foregroundStyle(MiClaymorphismTokens.muted)
                .frame(width: 68, alignment: .leading)

            Text(MiL10n.text(valueKey))
                .font(.system(size: 12.2, weight: .black, design: .rounded))
                .foregroundStyle(MiClaymorphismTokens.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.66)
                .padding(.horizontal, 10)
                .frame(height: 30)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background {
                    Capsule(style: .continuous)
                        .fill(fill)
                        .overlay {
                            Capsule(style: .continuous)
                                .strokeBorder(Color.white.opacity(0.46), lineWidth: 0.9)
                        }
                }
        }
    }
}

struct MiClaymorphismChip: View {
    let titleKey: String
    let fill: Color

    var body: some View {
        Text(MiL10n.text(titleKey))
            .font(.system(size: 11.5, weight: .black, design: .rounded))
            .foregroundStyle(MiClaymorphismTokens.ink)
            .padding(.horizontal, 11)
            .frame(height: 32)
            .background {
                Capsule(style: .continuous)
                    .fill(fill.opacity(0.82))
                    .overlay {
                        Capsule(style: .continuous)
                            .strokeBorder(Color.white.opacity(0.54), lineWidth: 1)
                    }
            }
    }
}

// MARK: - Depth Cards

enum MiClaymorphismDepthKind {
    case raised
    case inset
    case pressed
}

struct MiClaymorphismDepthCard: View {
    let titleKey: String
    let bodyKey: String
    let kind: MiClaymorphismDepthKind

    var body: some View {
        MiClaymorphismPanel(fill: fill, radius: 24) {
            VStack(alignment: .leading, spacing: 12) {
                MiClaymorphismClayShape(fill: fill, radius: 22, isPressed: kind == .pressed, isInset: kind == .inset)
                    .frame(height: 62)
                    .overlay {
                        Image(systemName: icon)
                            .font(.system(size: 19, weight: .black))
                            .foregroundStyle(MiClaymorphismTokens.ink.opacity(0.82))
                    }

                Text(MiL10n.text(titleKey))
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 12.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.muted)
                    .lineSpacing(2.5)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var fill: Color {
        switch kind {
        case .raised:
            return MiClaymorphismTokens.peach.opacity(0.72)
        case .inset:
            return MiClaymorphismTokens.background
        case .pressed:
            return MiClaymorphismTokens.lilac.opacity(0.68)
        }
    }

    private var icon: String {
        switch kind {
        case .raised:
            return "arrow.up.left.and.arrow.down.right"
        case .inset:
            return "tray"
        case .pressed:
            return "hand.tap.fill"
        }
    }
}

struct MiClaymorphismRolePill: View {
    let titleKey: String
    let fill: Color

    var body: some View {
        Text(MiL10n.text(titleKey))
            .font(.system(size: 11.5, weight: .black, design: .rounded))
            .foregroundStyle(MiClaymorphismTokens.ink)
            .padding(.horizontal, 12)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background {
                MiClaymorphismClayShape(fill: fill, radius: 20, isPressed: false, isInset: false)
            }
    }
}

// MARK: - Buttons

enum MiClaymorphismButtonRole {
    case primary
    case secondary
    case destructive
    case disabled
}

struct MiClaymorphismButton: View {
    let titleKey: String
    let systemImage: String
    let role: MiClaymorphismButtonRole

    var body: some View {
        Button {} label: {
            Label(MiL10n.text(titleKey), systemImage: systemImage)
                .font(.system(size: 13.5, weight: .black, design: .rounded))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
        }
        .buttonStyle(MiClaymorphismFilledButtonStyle(role: role))
        .disabled(role == .disabled)
    }
}

struct MiClaymorphismFilledButtonStyle: ButtonStyle {
    let role: MiClaymorphismButtonRole

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(role == .disabled ? MiClaymorphismTokens.muted.opacity(0.58) : MiClaymorphismTokens.ink)
            .background {
                MiClaymorphismClayShape(fill: fill.opacity(role == .disabled ? 0.46 : 0.86), radius: 23, isPressed: configuration.isPressed, isInset: false)
            }
            .scaleEffect(configuration.isPressed && role != .disabled ? 0.97 : 1)
            .opacity(role == .disabled ? 0.68 : 1)
            .animation(.spring(response: 0.18, dampingFraction: 0.68), value: configuration.isPressed)
    }

    private var fill: Color {
        switch role {
        case .primary:
            return MiClaymorphismTokens.peach
        case .secondary:
            return MiClaymorphismTokens.sky
        case .destructive:
            return MiClaymorphismTokens.coral
        case .disabled:
            return MiClaymorphismTokens.surface
        }
    }
}

struct MiClaymorphismPressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
            .animation(.spring(response: 0.16, dampingFraction: 0.68), value: configuration.isPressed)
    }
}

struct MiClaymorphismTopButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(MiClaymorphismTokens.ink)
            .background {
                MiClaymorphismClayShape(fill: MiClaymorphismTokens.surface, radius: 22, isPressed: configuration.isPressed, isInset: false)
            }
    }
}

struct MiClaymorphismSegmentButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(MiClaymorphismTokens.ink)
            .background {
                MiClaymorphismClayShape(
                    fill: isSelected ? MiClaymorphismTokens.mint.opacity(0.82) : MiClaymorphismTokens.surfaceLight.opacity(0.76),
                    radius: 23,
                    isPressed: configuration.isPressed || isSelected,
                    isInset: isSelected
                )
            }
    }
}

struct MiClaymorphismToggleBlob: View {
    let isOn: Bool

    var body: some View {
        ZStack {
            MiClaymorphismClayShape(fill: isOn ? MiClaymorphismTokens.mint : MiClaymorphismTokens.surface, radius: 26, isPressed: isOn, isInset: false)
            Image(systemName: isOn ? "checkmark" : "sparkle")
                .font(.system(size: 17, weight: .black))
                .foregroundStyle(MiClaymorphismTokens.ink)
        }
        .frame(width: 54, height: 54)
    }
}

// MARK: - Content Cards

struct MiClaymorphismGuidanceCard: View {
    let titleKey: String
    let bodyKey: String
    let systemImage: String
    let fill: Color

    var body: some View {
        MiClaymorphismPanel(fill: fill, radius: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: systemImage)
                    .font(.system(size: 20, weight: .black))
                    .foregroundStyle(MiClaymorphismTokens.ink)
                    .frame(width: 42, height: 42)
                    .background {
                        MiClaymorphismClayShape(fill: Color.white.opacity(0.42), radius: 20, isPressed: false, isInset: false)
                    }

                Text(MiL10n.text(titleKey))
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 12.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.muted)
                    .lineSpacing(2.5)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct MiClaymorphismStateCard: View {
    let titleKey: String
    let bodyKey: String
    let systemImage: String
    let fill: Color

    var body: some View {
        MiClaymorphismPanel(fill: fill, radius: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: systemImage)
                    .font(.system(size: 22, weight: .black))
                    .foregroundStyle(MiClaymorphismTokens.ink)
                Text(MiL10n.text(titleKey))
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 12.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.muted)
                    .lineSpacing(2.5)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

/// Loading state as a soft "waiting object": a puffy clay blob that gently
/// breathes (Design.md asks for a soft waiting object, never a sharp skeleton).
struct MiClaymorphismLoadingCard: View {
    let fill: Color

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var breathing = false

    var body: some View {
        MiClaymorphismPanel(fill: fill, radius: 24) {
            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    MiClaymorphismClayShape(fill: MiClaymorphismTokens.butter, radius: 26, isPressed: false, isInset: false)
                        .frame(width: 54, height: 54)
                        .scaleEffect(reduceMotion ? 1 : (breathing ? 1.06 : 0.94))
                        .opacity(reduceMotion ? 1 : (breathing ? 1 : 0.82))
                    Image(systemName: "hourglass")
                        .font(.system(size: 20, weight: .black))
                        .foregroundStyle(MiClaymorphismTokens.ink.opacity(0.82))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Text(MiL10n.text("clay_loading"))
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.ink)
                Text(MiL10n.text("clay_loading_body"))
                    .font(.system(size: 12.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.muted)
                    .lineSpacing(2.5)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) {
                breathing = true
            }
        }
    }
}

/// Error state with a real recovery affordance: a clay retry button that springs
/// the card to a recovered state, demonstrating an in-style error → recovery flow.
struct MiClaymorphismErrorCard: View {
    let fill: Color

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var recovered = false

    var body: some View {
        MiClaymorphismPanel(fill: recovered ? MiClaymorphismTokens.mint.opacity(0.62) : fill, radius: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: recovered ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .font(.system(size: 22, weight: .black))
                    .foregroundStyle(MiClaymorphismTokens.ink)
                Text(MiL10n.text(recovered ? "clay_recovered" : "clay_error"))
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.ink)
                Text(MiL10n.text(recovered ? "clay_recovered_body" : "clay_error_body"))
                    .font(.system(size: 12.5, weight: .medium, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.muted)
                    .lineSpacing(2.5)
                    .fixedSize(horizontal: false, vertical: true)

                Button {
                    withAnimation(reduceMotion ? .easeOut(duration: 0.01) : .spring(response: 0.34, dampingFraction: 0.6)) {
                        recovered.toggle()
                    }
                } label: {
                    Label(
                        MiL10n.text(recovered ? "clay_recovered" : "clay_retry"),
                        systemImage: recovered ? "checkmark" : "arrow.clockwise"
                    )
                    .font(.system(size: 12.5, weight: .black, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                }
                .buttonStyle(MiClaymorphismSegmentButtonStyle(isSelected: recovered))
            }
        }
    }
}

struct MiClaymorphismTokenSwatch: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        MiClaymorphismPanel(radius: 24) {
            VStack(alignment: .leading, spacing: 11) {
                MiClaymorphismClayShape(fill: color, radius: 18, isPressed: false, isInset: false, sheen: false)
                    .frame(height: 52)

                Text(title)
                    .font(.system(size: 13, weight: .black, design: .rounded))
                    .foregroundStyle(MiClaymorphismTokens.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
                Text(value)
                    .font(.system(size: 11.5, weight: .semibold, design: .monospaced))
                    .foregroundStyle(MiClaymorphismTokens.muted)
            }
        }
    }
}
