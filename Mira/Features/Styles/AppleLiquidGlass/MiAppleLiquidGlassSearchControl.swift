//
//  MiAppleLiquidGlassSearchControl.swift
//  Mira
//
//  Created on 2026/5/22.
//

import SwiftUI

enum MiAppleLiquidGlassSearchRole {
    case home
    case detail

    var height: CGFloat {
        switch self {
        case .home:
            return 52
        case .detail:
            return 48
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .home:
            return 34
        case .detail:
            return 30
        }
    }

    var fontSize: CGFloat {
        switch self {
        case .home:
            return 16
        case .detail:
            return 15
        }
    }
}

struct MiAppleLiquidGlassSearchControl: View {
    @Binding var text: String

    let placeholder: String
    let role: MiAppleLiquidGlassSearchRole
    let showsResetAction: Bool
    let supportText: String?
    let onSubmit: () -> Void
    let onReset: () -> Void

    @FocusState private var isFocused: Bool

    init(
        text: Binding<String>,
        placeholder: String = "app_search_styles",
        role: MiAppleLiquidGlassSearchRole = .home,
        showsResetAction: Bool = true,
        supportText: String? = nil,
        onSubmit: @escaping () -> Void = {},
        onReset: @escaping () -> Void = {}
    ) {
        self._text = text
        self.placeholder = placeholder
        self.role = role
        self.showsResetAction = showsResetAction
        self.supportText = supportText
        self.onSubmit = onSubmit
        self.onReset = onReset
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            controlBody

            if let supportText {
                Text(MiL10n.text(supportText))
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(MiColorTokens.contentMuted)
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)
                    .padding(.horizontal, 10)
            }
        }
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder
    private var controlBody: some View {
        let shape = Capsule(style: .continuous)

        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            GlassEffectContainer(spacing: 8) {
                searchContent
                    .glassEffect(
                        .regular
                            .tint(MiColorTokens.appleBlue500.opacity(isActive ? 0.16 : 0.075))
                            .interactive(true),
                        in: shape
                    )
                    .overlay {
                        MiAppleLiquidGlassSearchStroke(isActive: isActive)
                    }
            }
        } else {
            searchContent
                .background {
                    MiAppleLiquidGlassSearchFallback(isActive: isActive)
                }
                .overlay {
                    MiAppleLiquidGlassSearchStroke(isActive: isActive)
                }
        }
    }

    private var searchContent: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(isActive ? MiColorTokens.appleBlue500 : MiColorTokens.contentMuted)
                .frame(width: role.iconSize, height: role.iconSize)
                .background {
                    Circle()
                        .fill(Color.white.opacity(isActive ? 0.82 : 0.56))
                }

            VStack(alignment: .leading, spacing: 1) {
                if role == .home && isFocused {
                    Text(MiL10n.text("c_search"))
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundStyle(MiColorTokens.contentMuted)
                        .lineLimit(1)
                }

                TextField(MiL10n.text(placeholder), text: $text)
                    .focused($isFocused)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textFieldStyle(.plain)
                    .submitLabel(.search)
                    .onSubmit(onSubmit)
                    .font(.system(size: role.fontSize, weight: .regular, design: .rounded))
                    .foregroundStyle(MiColorTokens.contentPrimary)
                    .tint(MiColorTokens.appleBlue500)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if !text.isEmpty {
                MiAppleLiquidGlassSearchButton(systemImage: "xmark.circle.fill", label: "app_clear_search") {
                    withAnimation(.easeOut(duration: 0.14)) {
                        text = ""
                    }
                }
            }

            if showsResetAction {
                MiAppleLiquidGlassSearchButton(systemImage: "scope", label: "app_center") {
                    withAnimation(.spring(response: 0.42, dampingFraction: 0.84)) {
                        onReset()
                    }
                }
            }
        }
        .padding(.leading, role == .home ? 10 : 9)
        .padding(.trailing, showsResetAction ? 7 : 12)
        .frame(height: role.height)
        .shadow(color: MiColorTokens.appleBlue500.opacity(role == .home ? 0.10 : 0.035), radius: role == .home ? 18 : 7, x: 0, y: role == .home ? 10 : 4)
        .shadow(color: Color(hex: 0x738197).opacity(role == .home ? 0.16 : 0.045), radius: role == .home ? 20 : 8, x: 0, y: role == .home ? 12 : 5)
        .animation(.easeOut(duration: 0.16), value: isActive)
    }

    private var isActive: Bool {
        isFocused || !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

private struct MiAppleLiquidGlassSearchButton: View {
    let systemImage: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            let shape = Circle()

            Image(systemName: systemImage)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(MiColorTokens.contentSecondary)
                .frame(width: 32, height: 32)
                .modifier(MiAppleLiquidGlassIconButtonChrome(shape: shape))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(MiL10n.text(label))
    }
}

private struct MiAppleLiquidGlassIconButtonChrome<S: InsettableShape>: ViewModifier {
    let shape: S

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            content
                .glassEffect(
                    .regular
                        .tint(MiColorTokens.appleBlue500.opacity(0.08))
                        .interactive(true),
                    in: shape
                )
                .overlay {
                    shape
                        .strokeBorder(Color.white.opacity(0.72), lineWidth: 0.8)
                }
        } else {
            content
                .background {
                    shape
                        .fill(Color.white.opacity(0.58))
                }
                .overlay {
                    shape
                        .strokeBorder(Color.white.opacity(0.76), lineWidth: 1)
                }
        }
    }
}

private struct MiAppleLiquidGlassSearchStroke: View {
    let isActive: Bool

    var body: some View {
        Capsule(style: .continuous)
            .strokeBorder(
                LinearGradient(
                    colors: [
                        MiColorTokens.frost050.opacity(isActive ? 0.34 : 0.20),
                        MiColorTokens.appleBlue500.opacity(isActive ? 0.28 : 0.10),
                        Color.white.opacity(0.70)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 0.9
            )
    }
}

private struct MiAppleLiquidGlassSearchFallback: View {
    let isActive: Bool

    var body: some View {
        Capsule(style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(isActive ? 0.90 : 0.78),
                        MiColorTokens.frost100.opacity(isActive ? 0.72 : 0.62),
                        MiColorTokens.appleBlue500.opacity(isActive ? 0.12 : 0.075)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                Capsule(style: .continuous)
                    .fill(Color.white.opacity(isActive ? 0.18 : 0.12))
            }
    }
}

#Preview {
    ZStack {
        MiColorTokens.appBackground
            .ignoresSafeArea()

        VStack(spacing: 24) {
            MiAppleLiquidGlassSearchControl(text: .constant("Liquid"), role: .home)
            MiAppleLiquidGlassSearchControl(text: .constant(""), role: .detail, showsResetAction: false, supportText: "Detail variant")
        }
        .padding()
    }
}
