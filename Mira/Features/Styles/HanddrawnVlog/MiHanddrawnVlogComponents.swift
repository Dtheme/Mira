//
//  MiHanddrawnVlogComponents.swift
//  Mira
//
//  Reusable primitives for the Hand-drawn Vlog detail page, in the style's own
//  idiom: warm paper cards, washi-tape kickers, polaroids, hand-drawn doodles,
//  a squishy pill button, sticker chips, and a little paper-bun mascot.
//  Doodle Shapes (MiHVWave/Star/Sun/Heart) live in MiHanddrawnVlogHomePreview.swift.
//

import SwiftUI

private typealias HV = MiHanddrawnVlogTokens

// MARK: - Paper card

struct MiHVCard<Content: View>: View {
    private let fill: Color
    private let radius: CGFloat
    private let padding: CGFloat
    private let content: Content

    init(
        fill: Color = HV.paper,
        radius: CGFloat = HV.cardRadius,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.fill = fill
        self.radius = radius
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: radius, style: .continuous).fill(fill))
            .overlay {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(HV.shadow.opacity(0.5), lineWidth: 1)
            }
            .shadow(color: HV.clay.opacity(0.14), radius: 10, x: 0, y: 6)
    }
}

// MARK: - Washi-tape kicker + section

struct MiHVKicker: View {
    let titleKey: String
    var body: some View {
        Text(MiL10n.text(titleKey))
            .font(HV.hand(11, .semibold))
            .italic()
            .foregroundStyle(HV.ink.opacity(0.82))
            .padding(.horizontal, 10)
            .padding(.vertical, 3)
            .background(Capsule(style: .continuous).fill(HV.butter.opacity(0.72)))
            .rotationEffect(.degrees(-2))
    }
}

struct MiHVSection<Content: View>: View {
    private let kickerKey: String
    private let titleKey: String
    private let bodyKey: String
    private let content: Content

    init(kickerKey: String, titleKey: String, bodyKey: String, @ViewBuilder content: () -> Content) {
        self.kickerKey = kickerKey
        self.titleKey = titleKey
        self.bodyKey = bodyKey
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                MiHVKicker(titleKey: kickerKey)
                Text(MiL10n.text(titleKey))
                    .font(HV.rounded(22, .semibold))
                    .foregroundStyle(HV.ink)
                    .fixedSize(horizontal: false, vertical: true)
                Text(MiL10n.text(bodyKey))
                    .font(HV.rounded(13, .regular))
                    .foregroundStyle(HV.pencil)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            content
        }
    }
}

// MARK: - Doodle

struct MiHVDoodle: View {
    enum Kind { case sun, star, heart, wave }
    let kind: Kind
    var size: CGFloat = 24
    var color: Color = HV.ink

    var body: some View {
        Group {
            switch kind {
            case .sun:
                MiHVSun().stroke(color, style: StrokeStyle(lineWidth: 1.8, lineCap: .round, lineJoin: .round))
            case .star:
                MiHVStar().fill(color)
            case .heart:
                MiHVHeart().fill(color)
            case .wave:
                MiHVWave().stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Polaroid (shared)

struct MiHVPolaroid: View {
    let photoIndex: Int
    let date: String
    let caption: String
    var width: CGFloat = 196
    var tilt: Double = HV.photoTilt

    var body: some View {
        VStack(spacing: 7) {
            RoundedRectangle(cornerRadius: HV.photoRadius, style: .continuous)
                .fill(HV.photoGradient(photoIndex))
                .frame(width: width, height: width * 0.78)
                .overlay(alignment: .topLeading) {
                    MiHVSun()
                        .stroke(HV.ink.opacity(0.78), style: StrokeStyle(lineWidth: 1.8, lineCap: .round, lineJoin: .round))
                        .frame(width: 26, height: 26)
                        .padding(.leading, 13)
                        .padding(.top, 12)
                }
                .overlay(alignment: .bottomTrailing) {
                    MiHVStar()
                        .fill(HV.paper.opacity(0.95))
                        .overlay { MiHVStar().stroke(HV.ink.opacity(0.6), lineWidth: 1.1) }
                        .frame(width: 16, height: 16)
                        .padding([.trailing, .bottom], 12)
                }
                .clipShape(RoundedRectangle(cornerRadius: HV.photoRadius, style: .continuous))

            HStack(spacing: 6) {
                Text(date)
                    .font(HV.hand(12, .semibold)).italic()
                    .foregroundStyle(HV.pencil)
                Spacer(minLength: 0)
                Text(caption)
                    .font(HV.hand(13, .semibold)).italic()
                    .foregroundStyle(HV.ink.opacity(0.85))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                MiHVHeart().fill(HV.rose).frame(width: 11, height: 11)
            }
            .frame(width: width)
        }
        .padding(.horizontal, 9)
        .padding(.top, 9)
        .padding(.bottom, 12)
        .background(RoundedRectangle(cornerRadius: HV.photoRadius + 4, style: .continuous).fill(HV.paper))
        .overlay {
            RoundedRectangle(cornerRadius: HV.photoRadius + 4, style: .continuous)
                .strokeBorder(HV.shadow.opacity(0.55), lineWidth: 1)
        }
        .shadow(color: HV.clay.opacity(0.22), radius: 9, x: 0, y: 6)
        .rotationEffect(.degrees(tilt))
    }
}

// MARK: - Pill button (squish)

enum MiHVButtonRole { case primary, secondary, disabled, link }

struct MiHVButton: View {
    private let titleKey: String
    private let role: MiHVButtonRole
    private let action: () -> Void

    init(titleKey: String, role: MiHVButtonRole, action: @escaping () -> Void = {}) {
        self.titleKey = titleKey
        self.role = role
        self.action = action
    }

    var body: some View {
        Button(action: action) { label }
            .buttonStyle(MiHVSquishStyle())
            .disabled(role == .disabled)
    }

    @ViewBuilder private var label: some View {
        let text = Text(MiL10n.text(titleKey)).font(HV.rounded(14, .semibold))
        switch role {
        case .primary:
            text.foregroundStyle(HV.paper)
                .padding(.horizontal, 20).frame(height: 44)
                .background(Capsule(style: .continuous).fill(HV.rose))
        case .secondary:
            text.foregroundStyle(HV.ink)
                .padding(.horizontal, 20).frame(height: 44)
                .background(Capsule(style: .continuous).fill(HV.paper))
                .overlay { Capsule(style: .continuous).strokeBorder(HV.ink.opacity(0.5), lineWidth: 1.5) }
        case .disabled:
            text.foregroundStyle(HV.pencil.opacity(0.7))
                .padding(.horizontal, 20).frame(height: 44)
                .background(Capsule(style: .continuous).fill(HV.cream))
                .overlay { Capsule(style: .continuous).strokeBorder(HV.shadow.opacity(0.6), lineWidth: 1.5) }
        case .link:
            text.foregroundStyle(HV.clay).underline()
                .frame(height: 44)
        }
    }
}

struct MiHVSquishStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        MiHVSquishBody(configuration: configuration)
    }

    private struct MiHVSquishBody: View {
        let configuration: ButtonStyleConfiguration
        @Environment(\.accessibilityReduceMotion) private var reduceMotion
        var body: some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.95 : 1)
                .animation(reduceMotion ? .easeOut(duration: 0.01) : .spring(response: 0.28, dampingFraction: 0.6), value: configuration.isPressed)
        }
    }
}

// MARK: - Sticker chip

struct MiHVChip: View {
    let titleKey: String
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 5) {
            if isSelected {
                MiHVStar().fill(HV.paper).frame(width: 9, height: 9)
            }
            Text(MiL10n.text(titleKey))
                .font(HV.rounded(12.5, .semibold))
        }
        .foregroundStyle(isSelected ? HV.paper : HV.ink.opacity(0.8))
        .padding(.horizontal, 13)
        .frame(height: 34)
        .background(Capsule(style: .continuous).fill(isSelected ? HV.rose : HV.paper))
        .overlay {
            Capsule(style: .continuous)
                .strokeBorder(isSelected ? Color.clear : HV.shadow.opacity(0.6), lineWidth: 1.4)
        }
        .rotationEffect(.degrees(isSelected ? -2 : 0))
    }
}

// MARK: - Note / state cards

struct MiHVNoteCard: View {
    let doodle: MiHVDoodle.Kind
    let doodleColor: Color
    let titleKey: String
    let bodyKey: String

    var body: some View {
        MiHVCard(padding: 14) {
            VStack(alignment: .leading, spacing: 8) {
                MiHVDoodle(kind: doodle, size: 22, color: doodleColor)
                Text(MiL10n.text(titleKey))
                    .font(HV.rounded(14.5, .semibold))
                    .foregroundStyle(HV.ink)
                Text(MiL10n.text(bodyKey))
                    .font(HV.rounded(12, .regular))
                    .foregroundStyle(HV.pencil)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct MiHVLoadingNote: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var developing = false

    var body: some View {
        MiHVCard(padding: 14) {
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: HV.photoRadius, style: .continuous)
                    .fill(HV.photoGradient(1))
                    .frame(height: 52)
                    .opacity(reduceMotion ? 0.7 : (developing ? 0.88 : 0.38))
                    .overlay {
                        RoundedRectangle(cornerRadius: HV.photoRadius, style: .continuous)
                            .strokeBorder(HV.ink.opacity(0.4), style: StrokeStyle(lineWidth: 1.4, dash: [4, 4]))
                    }
                Text(MiL10n.text("hv_loading"))
                    .font(HV.rounded(14.5, .semibold))
                    .foregroundStyle(HV.ink)
                Text(MiL10n.text("hv_loading_body"))
                    .font(HV.rounded(12, .regular))
                    .foregroundStyle(HV.pencil)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) { developing = true }
        }
    }
}

struct MiHVErrorNote: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var recovered = false

    var body: some View {
        MiHVCard(padding: 14) {
            VStack(alignment: .leading, spacing: 8) {
                MiHVDoodle(kind: recovered ? .heart : .wave, size: 22, color: recovered ? HV.matcha : HV.clay)
                Text(MiL10n.text(recovered ? "algc_recovered" : "hv_error"))
                    .font(HV.rounded(14.5, .semibold))
                    .foregroundStyle(HV.ink)
                Text(MiL10n.text(recovered ? "hv_recovered_body" : "hv_error_body"))
                    .font(HV.rounded(12, .regular))
                    .foregroundStyle(HV.pencil)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
                MiHVButton(titleKey: "algc_retry", role: .secondary) {
                    if reduceMotion {
                        recovered.toggle()
                    } else {
                        withAnimation(.spring(response: 0.32, dampingFraction: 0.74)) { recovered.toggle() }
                    }
                }
            }
        }
    }
}

// MARK: - Color swatch (paint chip)

struct MiHVSwatch: View {
    let name: String
    let hex: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(color)
                .frame(height: 40)
                .overlay {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(HV.shadow.opacity(0.5), lineWidth: 1)
                }
            Text(name)
                .font(HV.rounded(11, .semibold))
                .foregroundStyle(HV.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(hex)
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundStyle(HV.pencil)
        }
    }
}

// MARK: - Mascot (paper bun face)

struct MiHVMascot: View {
    var size: CGFloat = 58

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.42, style: .continuous)
                .fill(HV.paper)
                .overlay {
                    RoundedRectangle(cornerRadius: size * 0.42, style: .continuous)
                        .strokeBorder(HV.ink.opacity(0.55), lineWidth: 1.6)
                }

            HStack(spacing: size * 0.36) {
                cheek
                cheek
            }
            .offset(y: size * 0.10)

            HStack(spacing: size * 0.30) {
                eye
                eye
            }
            .offset(y: -size * 0.02)

            MiHVSmile()
                .stroke(HV.ink.opacity(0.72), style: StrokeStyle(lineWidth: 1.6, lineCap: .round))
                .frame(width: size * 0.24, height: size * 0.12)
                .offset(y: size * 0.13)
        }
        .frame(width: size, height: size)
    }

    private var eye: some View {
        Circle().fill(HV.ink.opacity(0.8)).frame(width: size * 0.08, height: size * 0.08)
    }

    private var cheek: some View {
        Circle().fill(HV.rose.opacity(0.55)).frame(width: size * 0.15, height: size * 0.15)
    }
}

struct MiHVSmile: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY),
            control: CGPoint(x: rect.midX, y: rect.maxY * 1.4)
        )
        return path
    }
}

// MARK: - Top bar

struct MiHVTopBar: View {
    let style: MiDesignStyle
    let onBack: () -> Void

    var body: some View {
        MiHVCard(fill: HV.paper, radius: 16, padding: 8) {
            HStack(spacing: 12) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(HV.ink)
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(MiL10n.text("c_back"))

                VStack(alignment: .leading, spacing: 1) {
                    Text(MiL10n.text(style.name))
                        .font(HV.rounded(15, .semibold))
                        .foregroundStyle(HV.ink)
                        .lineLimit(1)
                    Text(MiL10n.text(style.localizedName))
                        .font(HV.rounded(11, .regular))
                        .foregroundStyle(HV.pencil)
                        .lineLimit(1)
                }

                Spacer(minLength: 0)

                MiHVStar().fill(HV.rose).frame(width: 15, height: 15)
            }
        }
        .frame(maxWidth: 780)
    }
}
