//
//  MiNeoBrutalismComponents.swift
//  Mira
//
//  Created on 2026/5/22.
//

import SwiftUI

struct MiNeoBrutalismGridBackground: View {
    var body: some View {
        MiNeoBrutalismTokens.paperBlue
            .overlay {
                Canvas { context, size in
                    var path = Path()
                    let step: CGFloat = 28

                    for x in stride(from: CGFloat.zero, through: size.width, by: step) {
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: size.height))
                    }

                    for y in stride(from: CGFloat.zero, through: size.height, by: step) {
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: size.width, y: y))
                    }

                    context.stroke(path, with: .color(MiNeoBrutalismTokens.ink.opacity(0.08)), lineWidth: 1)
                }
            }
            .ignoresSafeArea()
    }
}

struct MiNeoBrutalismSurface<S: InsettableShape>: View {
    let shape: S
    let fill: Color
    let lineWidth: CGFloat
    let shadow: CGSize
    let shadowOpacity: Double

    init(
        shape: S,
        fill: Color,
        lineWidth: CGFloat = MiNeoBrutalismTokens.lineWidth,
        shadow: CGSize = MiNeoBrutalismTokens.shadowMedium,
        shadowOpacity: Double = 1
    ) {
        self.shape = shape
        self.fill = fill
        self.lineWidth = lineWidth
        self.shadow = shadow
        self.shadowOpacity = shadowOpacity
    }

    var body: some View {
        ZStack {
            if shadow.width != 0 || shadow.height != 0 {
                shape
                    .fill(MiNeoBrutalismTokens.ink.opacity(shadowOpacity))
                    .offset(x: shadow.width, y: shadow.height)
            }

            shape
                .fill(fill)

            shape
                .strokeBorder(MiNeoBrutalismTokens.ink, lineWidth: lineWidth)
        }
    }
}

struct MiNeoBrutalismCard<Content: View>: View {
    let fill: Color
    let radius: CGFloat
    let shadow: CGSize
    let padding: CGFloat
    let content: Content

    init(
        fill: Color = MiNeoBrutalismTokens.surface,
        radius: CGFloat = MiNeoBrutalismTokens.radiusMD,
        shadow: CGSize = MiNeoBrutalismTokens.shadowMedium,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.fill = fill
        self.radius = radius
        self.shadow = shadow
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                MiNeoBrutalismSurface(
                    shape: RoundedRectangle(cornerRadius: radius, style: .continuous),
                    fill: fill,
                    shadow: shadow
                )
            }
    }
}

struct MiNeoBrutalismSection<Content: View>: View {
    let title: String
    let subtitle: String
    let fill: Color
    let content: Content

    init(
        title: String,
        subtitle: String,
        fill: Color = MiNeoBrutalismTokens.surface,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.fill = fill
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(MiL10n.text(title))
                    .font(MiNeoBrutalismTokens.sectionTitle)
                    .foregroundStyle(MiNeoBrutalismTokens.ink)
                    .fixedSize(horizontal: false, vertical: true)

                Text(MiL10n.text(subtitle))
                    .font(MiNeoBrutalismTokens.body)
                    .foregroundStyle(MiNeoBrutalismTokens.muted)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            content
        }
        .padding(.bottom, 10)
    }
}

enum MiNeoBrutalismButtonVariant {
    case primary
    case secondary
    case destructive
    case disabled
}

struct MiNeoBrutalismButton: View {
    let title: String
    let systemImage: String?
    let variant: MiNeoBrutalismButtonVariant
    let action: () -> Void

    init(
        _ title: String,
        systemImage: String? = nil,
        variant: MiNeoBrutalismButtonVariant = .secondary,
        action: @escaping () -> Void = {}
    ) {
        self.title = title
        self.systemImage = systemImage
        self.variant = variant
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 13, weight: .black))
                }

                Text(MiL10n.text(title))
                    .font(MiNeoBrutalismTokens.label)
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 44)
        }
        .buttonStyle(MiNeoBrutalismButtonStyle(variant: variant))
        .disabled(variant == .disabled)
        .accessibilityLabel(MiL10n.text(title))
    }
}

struct MiNeoBrutalismButtonStyle: ButtonStyle {
    let variant: MiNeoBrutalismButtonVariant
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed && variant != .disabled
        let offset = isPressed && !reduceMotion ? MiNeoBrutalismTokens.pressOffset : .zero
        let shadow = isPressed ? .zero : MiNeoBrutalismTokens.shadowSmall

        configuration.label
            .padding(.horizontal, 14)
            .foregroundStyle(foreground)
            .background {
                MiNeoBrutalismSurface(
                    shape: RoundedRectangle(cornerRadius: MiNeoBrutalismTokens.radiusSM, style: .continuous),
                    fill: fill,
                    shadow: shadow
                )
            }
            .offset(x: offset.width, y: offset.height)
            .opacity(variant == .disabled ? 0.56 : 1)
            .animation(reduceMotion ? .easeOut(duration: 0.01) : MiNeoBrutalismTokens.motion, value: configuration.isPressed)
    }

    private var fill: Color {
        switch variant {
        case .primary:
            return MiNeoBrutalismTokens.blue
        case .secondary:
            return MiNeoBrutalismTokens.yellow
        case .destructive:
            return MiNeoBrutalismTokens.red
        case .disabled:
            return Color(hex: 0xCCCCCC)
        }
    }

    private var foreground: Color {
        switch variant {
        case .primary, .destructive:
            return Color.white
        case .secondary, .disabled:
            return MiNeoBrutalismTokens.ink
        }
    }
}

struct MiNeoBrutalismPill: View {
    let title: String
    let fill: Color
    let isDisabled: Bool

    init(_ title: String, fill: Color = MiNeoBrutalismTokens.greenSoft, isDisabled: Bool = false) {
        self.title = title
        self.fill = fill
        self.isDisabled = isDisabled
    }

    var body: some View {
        Text(MiL10n.text(title))
            .font(MiNeoBrutalismTokens.label)
            .foregroundStyle(MiNeoBrutalismTokens.ink)
            .lineLimit(1)
            .minimumScaleFactor(0.78)
            .padding(.horizontal, 12)
            .frame(minHeight: 36)
            .background {
                MiNeoBrutalismSurface(
                    shape: Capsule(style: .continuous),
                    fill: fill,
                    lineWidth: MiNeoBrutalismTokens.thinLineWidth,
                    shadow: CGSize(width: 3, height: 3)
                )
            }
            .opacity(isDisabled ? 0.5 : 1)
    }
}

struct MiNeoBrutalismTokenSwatch: View {
    let title: String
    let value: String
    let detail: String
    let color: Color

    var body: some View {
        MiNeoBrutalismCard(fill: MiNeoBrutalismTokens.surface, radius: MiNeoBrutalismTokens.radiusSM, shadow: MiNeoBrutalismTokens.shadowSmall, padding: 12) {
            VStack(alignment: .leading, spacing: 10) {
                MiNeoBrutalismSurface(
                    shape: RoundedRectangle(cornerRadius: MiNeoBrutalismTokens.radiusXS, style: .continuous),
                    fill: color,
                    lineWidth: MiNeoBrutalismTokens.thinLineWidth,
                    shadow: CGSize(width: 3, height: 3)
                )
                .frame(height: 46)

                Text(MiL10n.text(title))
                    .font(MiNeoBrutalismTokens.label)
                    .foregroundStyle(MiNeoBrutalismTokens.ink)

                Text(value)
                    .font(.system(size: 11, weight: .black, design: .monospaced))
                    .foregroundStyle(MiNeoBrutalismTokens.muted)

                Text(MiL10n.text(detail))
                    .font(.system(size: 12, weight: .bold, design: .default))
                    .foregroundStyle(MiNeoBrutalismTokens.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct MiNeoBrutalismShadowSample: View {
    let title: String
    let value: String
    let shadow: CGSize
    let isPressed: Bool

    var body: some View {
        MiNeoBrutalismCard(fill: MiNeoBrutalismTokens.surface, radius: MiNeoBrutalismTokens.radiusSM, shadow: MiNeoBrutalismTokens.shadowSmall, padding: 12) {
            VStack(alignment: .leading, spacing: 12) {
                MiNeoBrutalismSurface(
                    shape: RoundedRectangle(cornerRadius: MiNeoBrutalismTokens.radiusSM, style: .continuous),
                    fill: isPressed ? MiNeoBrutalismTokens.orangeSoft : MiNeoBrutalismTokens.surface,
                    shadow: isPressed ? .zero : shadow
                )
                .frame(height: 76)
                .offset(x: isPressed ? MiNeoBrutalismTokens.pressOffset.width : 0, y: isPressed ? MiNeoBrutalismTokens.pressOffset.height : 0)

                Text(MiL10n.text(title))
                    .font(MiNeoBrutalismTokens.label)
                    .foregroundStyle(MiNeoBrutalismTokens.ink)

                Text(MiL10n.text(value))
                    .font(.system(size: 12, weight: .bold, design: .default))
                    .foregroundStyle(MiNeoBrutalismTokens.muted)
            }
        }
    }
}

struct MiNeoBrutalismBulletRow: View {
    let text: String
    let fill: Color

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            MiNeoBrutalismSurface(
                shape: RoundedRectangle(cornerRadius: 4, style: .continuous),
                fill: fill,
                lineWidth: 2,
                shadow: CGSize(width: 2, height: 2)
            )
            .frame(width: 18, height: 18)
                .padding(.top, 2)

            Text(MiL10n.text(text))
                .font(MiNeoBrutalismTokens.body)
                .foregroundStyle(MiNeoBrutalismTokens.muted)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
