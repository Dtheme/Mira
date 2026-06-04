//
//  MiEditorialLuxeComponents.swift
//  Mira
//
//  Reusable Editorial Luxe primitives: clean paper cards with thin rules, serif
//  sections, ink/outline/link buttons, and quiet editorial state modules.
//

import SwiftUI

private typealias EdT = MiEditorialLuxeTokens

// MARK: - Card

struct MiEdCard<Content: View>: View {
    var fill: Color
    var radius: CGFloat
    var padding: CGFloat
    @ViewBuilder var content: Content

    init(
        fill: Color = EdT.surface,
        radius: CGFloat = EdT.radius,
        padding: CGFloat = 18,
        @ViewBuilder content: () -> Content
    ) {
        self.fill = fill
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
                    .fill(fill)
                    .overlay { shape.strokeBorder(EdT.hairline, lineWidth: 1) }
            }
            .shadow(color: EdT.ink.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

/// A small uppercase gold kicker label used above serif titles.
struct MiEdKicker: View {
    let titleKey: String

    var body: some View {
        HStack(spacing: 8) {
            Rectangle().fill(EdT.gold).frame(width: 16, height: 1.5)
            Text(MiL10n.text(titleKey).uppercased())
                .font(.system(size: 10.5, weight: .semibold, design: .default))
                .tracking(1.4)
                .foregroundStyle(EdT.gold)
        }
    }
}

struct MiEdSection<Content: View>: View {
    let kickerKey: String
    let titleKey: String
    let bodyKey: String
    @ViewBuilder let content: Content

    init(kickerKey: String, titleKey: String, bodyKey: String, @ViewBuilder content: () -> Content) {
        self.kickerKey = kickerKey
        self.titleKey = titleKey
        self.bodyKey = bodyKey
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            MiEdKicker(titleKey: kickerKey)
            Text(MiL10n.text(titleKey))
                .font(EdT.serif(25, .regular))
                .foregroundStyle(EdT.ink)
                .fixedSize(horizontal: false, vertical: true)
            Text(MiL10n.text(bodyKey))
                .font(.system(size: 13.5, weight: .regular, design: .default))
                .foregroundStyle(EdT.muted)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)

            content
                .padding(.top, 2)
        }
    }
}

// MARK: - Buttons

enum MiEdButtonRole {
    case primary
    case secondary
    case link
    case disabled
}

struct MiEdButton: View {
    let titleKey: String
    let role: MiEdButtonRole

    var body: some View {
        Button {} label: {
            Text(MiL10n.text(titleKey))
                .font(.system(size: 13, weight: .semibold, design: .default))
                .frame(maxWidth: role == .link ? nil : .infinity)
                .frame(minHeight: role == .link ? 44 : 46)
        }
        .buttonStyle(MiEdButtonStyle(role: role))
        .disabled(role == .disabled)
    }
}

struct MiEdButtonStyle: ButtonStyle {
    let role: MiEdButtonRole

    func makeBody(configuration: Configuration) -> some View {
        let pressed = configuration.isPressed && role != .disabled
        let shape = Capsule(style: .continuous)

        Group {
            switch role {
            case .primary:
                configuration.label
                    .foregroundStyle(EdT.paper)
                    .padding(.horizontal, 18)
                    .background { shape.fill(EdT.ink) }
            case .secondary:
                configuration.label
                    .foregroundStyle(EdT.ink)
                    .padding(.horizontal, 18)
                    .background { shape.strokeBorder(EdT.ink.opacity(0.5), lineWidth: 1) }
            case .link:
                configuration.label
                    .foregroundStyle(EdT.gold)
                    .overlay(alignment: .bottom) {
                        Rectangle().fill(EdT.gold).frame(height: 1).padding(.horizontal, 2)
                    }
            case .disabled:
                configuration.label
                    .foregroundStyle(EdT.muted)
                    .padding(.horizontal, 18)
                    .background { shape.strokeBorder(EdT.hairline, lineWidth: 1) }
            }
        }
        .opacity(role == .disabled ? 0.55 : (pressed ? 0.7 : 1))
        .animation(.easeOut(duration: 0.16), value: configuration.isPressed)
    }
}

// MARK: - Chip & readout

struct MiEdChip: View {
    let titleKey: String
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 4) {
            Text(MiL10n.text(titleKey))
                .font(.system(size: 12.5, weight: isSelected ? .semibold : .regular, design: .default))
                .foregroundStyle(isSelected ? EdT.ink : EdT.muted)
            Rectangle()
                .fill(isSelected ? EdT.gold : Color.clear)
                .frame(width: 18, height: 1.5)
        }
    }
}

struct MiEdMetricRow: View {
    let labelKey: String
    let value: String

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(MiL10n.text(labelKey).uppercased())
                .font(.system(size: 10, weight: .semibold, design: .default))
                .tracking(1.0)
                .foregroundStyle(EdT.muted)
            Spacer(minLength: 8)
            Text(value)
                .font(EdT.serif(15, .regular))
                .foregroundStyle(EdT.ink)
        }
        .overlay(alignment: .bottom) {
            Rectangle().fill(EdT.hairline).frame(height: 1).offset(y: 8)
        }
        .padding(.bottom, 8)
    }
}

struct MiEdTokenSwatch: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        MiEdCard(radius: EdT.smallRadius, padding: 12) {
            VStack(alignment: .leading, spacing: 10) {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(color)
                    .frame(height: 40)
                    .overlay { RoundedRectangle(cornerRadius: 6, style: .continuous).strokeBorder(EdT.hairline, lineWidth: 1) }
                Text(title)
                    .font(.system(size: 12, weight: .semibold, design: .default))
                    .foregroundStyle(EdT.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                Text(value)
                    .font(.system(size: 11, weight: .regular, design: .monospaced))
                    .foregroundStyle(EdT.muted)
            }
        }
    }
}

// MARK: - State modules

struct MiEdStateCard: View {
    let titleKey: String
    let bodyKey: String
    let systemImage: String

    var body: some View {
        MiEdCard(radius: EdT.smallRadius, padding: 14) {
            VStack(alignment: .leading, spacing: 9) {
                Image(systemName: systemImage)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(EdT.gold)
                Text(MiL10n.text(titleKey))
                    .font(EdT.serif(17, .regular))
                    .foregroundStyle(EdT.ink)
                Text(MiL10n.text(bodyKey))
                    .font(.system(size: 12, weight: .regular, design: .default))
                    .foregroundStyle(EdT.muted)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(minHeight: 132)
    }
}

/// Loading state as elegant skeleton rules.
struct MiEdLoadingCard: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var shimmer = false

    var body: some View {
        MiEdCard(radius: EdT.smallRadius, padding: 14) {
            VStack(alignment: .leading, spacing: 9) {
                Text(MiL10n.text("ed_loading"))
                    .font(EdT.serif(17, .regular))
                    .foregroundStyle(EdT.ink)
                VStack(alignment: .leading, spacing: 9) {
                    rule(width: nil)
                    rule(width: 120)
                    rule(width: 84)
                }
                .opacity(reduceMotion ? 1 : (shimmer ? 0.4 : 1))
            }
        }
        .frame(minHeight: 132)
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) { shimmer = true }
        }
    }

    private func rule(width: CGFloat?) -> some View {
        Rectangle()
            .fill(EdT.hairline)
            .frame(width: width, height: 7)
    }
}

/// Error state with a refined recovery action.
struct MiEdErrorCard: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var recovered = false

    var body: some View {
        MiEdCard(radius: EdT.smallRadius, padding: 14) {
            VStack(alignment: .leading, spacing: 9) {
                Image(systemName: recovered ? "checkmark.seal" : "exclamationmark.circle")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(recovered ? EdT.gold : EdT.ink)
                Text(MiL10n.text(recovered ? "algc_recovered" : "ed_error"))
                    .font(EdT.serif(17, .regular))
                    .foregroundStyle(EdT.ink)
                Text(MiL10n.text(recovered ? "ed_recovered_body" : "ed_error_body"))
                    .font(.system(size: 12, weight: .regular, design: .default))
                    .foregroundStyle(EdT.muted)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)

                Button {
                    withAnimation(reduceMotion ? .easeOut(duration: 0.01) : .easeOut(duration: 0.22)) {
                        recovered.toggle()
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: recovered ? "checkmark" : "arrow.clockwise")
                            .font(.system(size: 11, weight: .semibold))
                        Text(MiL10n.text(recovered ? "algc_recovered" : "algc_retry"))
                            .font(.system(size: 12, weight: .semibold, design: .default))
                    }
                    .foregroundStyle(EdT.gold)
                    .overlay(alignment: .bottom) {
                        Rectangle().fill(EdT.gold).frame(height: 1)
                    }
                }
                .buttonStyle(.plain)
                .padding(.top, 2)
            }
        }
        .frame(minHeight: 132)
    }
}
