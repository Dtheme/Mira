import SwiftUI

enum MiMaterial3ButtonRole {
    case filled
    case tonal
    case outlined
    case text
}

struct MiMaterial3ButtonStyle: ButtonStyle {
    var role: MiMaterial3ButtonRole = .filled

    @Environment(\.miMaterial3Palette) private var palette
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @ScaledMetric(relativeTo: .subheadline) private var labelSize = 14

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: labelSize, weight: .medium))
            .imageScale(.large)
            .multilineTextAlignment(.center)
            .foregroundStyle(isEnabled ? foreground : palette.onSurface.opacity(0.38))
            .padding(.horizontal, role == .text ? 12 : 24)
            .padding(.vertical, 10)
            .frame(minHeight: 40)
            .background {
                Capsule()
                    .fill(background)
                    .overlay {
                        Capsule()
                            .fill(foreground.opacity(configuration.isPressed && isEnabled ? MiMaterial3Tokens.pressedOpacity : 0))
                    }
                    .overlay {
                        if role == .outlined {
                            Capsule()
                                .strokeBorder(isEnabled ? palette.outline : palette.onSurface.opacity(0.12), lineWidth: 1)
                        }
                    }
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
            .animation(reduceMotion ? nil : MiMaterial3Tokens.stateAnimation, value: configuration.isPressed)
    }

    private var foreground: Color {
        switch role {
        case .filled: palette.onPrimary
        case .tonal: palette.onSecondaryContainer
        case .outlined, .text: palette.primary
        }
    }

    private var background: Color {
        switch role {
        case .filled: isEnabled ? palette.primary : palette.onSurface.opacity(0.12)
        case .tonal: isEnabled ? palette.secondaryContainer : palette.onSurface.opacity(0.12)
        case .outlined, .text: .clear
        }
    }
}

struct MiMaterial3IconButtonStyle: ButtonStyle {
    var filled = false

    @Environment(\.miMaterial3Palette) private var palette
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        let foreground = filled ? palette.onPrimary : palette.onSurfaceVariant
        configuration.label
            .font(.system(size: 24, weight: .regular))
            .foregroundStyle(isEnabled ? foreground : palette.onSurface.opacity(0.38))
            .frame(width: 40, height: 40)
            .background {
                Circle()
                    .fill(filled ? isEnabled ? palette.primary : palette.onSurface.opacity(0.12) : .clear)
                    .overlay {
                        Circle().fill(foreground.opacity(configuration.isPressed && isEnabled ? MiMaterial3Tokens.pressedOpacity : 0))
                    }
            }
            .padding(4)
            .contentShape(Rectangle())
            .animation(reduceMotion ? nil : MiMaterial3Tokens.stateAnimation, value: configuration.isPressed)
    }
}

struct MiMaterial3FABStyle: ButtonStyle {
    @Environment(\.miMaterial3Palette) private var palette
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 24, weight: .regular))
            .foregroundStyle(isEnabled ? palette.onPrimaryContainer : palette.onSurface.opacity(0.38))
            .frame(width: 56, height: 56)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(isEnabled ? palette.primaryContainer : palette.onSurface.opacity(0.12))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(palette.onPrimaryContainer.opacity(configuration.isPressed && isEnabled ? MiMaterial3Tokens.pressedOpacity : 0))
                    }
            }
            .contentShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(isEnabled ? 0.15 : 0), radius: 3, x: 0, y: 3)
            .animation(reduceMotion ? nil : MiMaterial3Tokens.stateAnimation, value: configuration.isPressed)
    }
}

struct MiMaterial3Chip: View {
    let titleKey: String
    var systemImage: String? = nil
    var isSelected = false
    let action: () -> Void

    @ScaledMetric(relativeTo: .subheadline) private var labelSize = 14

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let symbol = isSelected ? "checkmark" : systemImage {
                    Image(systemName: symbol)
                        .font(.system(size: 18, weight: .medium))
                        .accessibilityHidden(true)
                }
                Text(MiL10n.text(titleKey))
                    .font(.system(size: labelSize, weight: .medium))
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
        .buttonStyle(MiMaterial3ChipButtonStyle(isSelected: isSelected))
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

private struct MiMaterial3ChipButtonStyle: ButtonStyle {
    let isSelected: Bool

    @Environment(\.miMaterial3Palette) private var palette
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        let foreground = isSelected ? palette.onSecondaryContainer : palette.onSurfaceVariant
        configuration.label
            .foregroundStyle(isEnabled ? foreground : palette.onSurface.opacity(0.38))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .frame(minHeight: 32)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? isEnabled ? palette.secondaryContainer : palette.onSurface.opacity(0.12) : .clear)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(foreground.opacity(configuration.isPressed && isEnabled ? MiMaterial3Tokens.pressedOpacity : 0))
                    }
                    .overlay {
                        if !isSelected {
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(isEnabled ? palette.outline : palette.onSurface.opacity(0.12), lineWidth: 1)
                        }
                    }
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
            .animation(reduceMotion ? nil : MiMaterial3Tokens.stateAnimation, value: configuration.isPressed)
    }
}

struct MiMaterial3Segment: View {
    let titles: [String]
    @Binding var selection: Int

    @Environment(\.miMaterial3Palette) private var palette
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @ScaledMetric(relativeTo: .subheadline) private var labelSize = 14

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach(titles.indices, id: \.self) { index in
                    Button {
                        withAnimation(reduceMotion ? nil : MiMaterial3Tokens.stateAnimation) {
                            selection = index
                        }
                    } label: {
                        HStack(spacing: 8) {
                            if selection == index {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 18, weight: .medium))
                                    .accessibilityHidden(true)
                            }
                            Text(MiL10n.text(titles[index]))
                                .font(.system(size: labelSize, weight: .medium))
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .frame(minWidth: 60)
                    }
                    .buttonStyle(MiMaterial3SegmentButtonStyle(
                        isSelected: selection == index,
                        isFirst: index == titles.startIndex,
                        isLast: index == titles.index(before: titles.endIndex)
                    ))
                    .overlay(alignment: .leading) {
                        if index != titles.startIndex {
                            Rectangle()
                                .fill(isEnabled ? palette.outline : palette.onSurface.opacity(0.12))
                                .frame(width: 1)
                                .padding(.vertical, 4)
                                .allowsHitTesting(false)
                        }
                    }
                    .accessibilityAddTraits(selection == index ? .isSelected : [])
                }
            }
            .overlay {
                Capsule()
                    .strokeBorder(isEnabled ? palette.outline : palette.onSurface.opacity(0.12), lineWidth: 1)
                    .padding(.vertical, 4)
                    .allowsHitTesting(false)
            }
        }
        .scrollIndicators(.hidden)
        .accessibilityElement(children: .contain)
    }
}

private struct MiMaterial3SegmentButtonStyle: ButtonStyle {
    let isSelected: Bool
    let isFirst: Bool
    let isLast: Bool

    @Environment(\.miMaterial3Palette) private var palette
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        let foreground = isSelected ? palette.onSecondaryContainer : palette.onSurface
        let shape = UnevenRoundedRectangle(
            topLeadingRadius: isFirst ? 1000 : 0,
            bottomLeadingRadius: isFirst ? 1000 : 0,
            bottomTrailingRadius: isLast ? 1000 : 0,
            topTrailingRadius: isLast ? 1000 : 0
        )
        configuration.label
            .foregroundStyle(isEnabled ? foreground : palette.onSurface.opacity(0.38))
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
            .frame(minHeight: 48)
            .background {
                shape
                    .fill(isSelected ? palette.secondaryContainer : .clear)
                    .overlay {
                        shape.fill(foreground.opacity(configuration.isPressed && isEnabled ? MiMaterial3Tokens.pressedOpacity : 0))
                    }
                    .padding(.vertical, 4)
            }
            .contentShape(Rectangle())
    }
}

struct MiMaterial3ToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        MiMaterial3ToggleBody(configuration: configuration)
    }
}

private struct MiMaterial3ToggleBody: View {
    let configuration: ToggleStyleConfiguration

    @Environment(\.miMaterial3Palette) private var palette
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.layoutDirection) private var layoutDirection

    var body: some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack(spacing: 16) {
                configuration.label
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundStyle(palette.onSurface.opacity(isEnabled ? 1 : 0.38))
                Spacer(minLength: 0)
                ZStack {
                    Capsule()
                        .fill(trackColor)
                        .overlay {
                            if !configuration.isOn {
                                Capsule().strokeBorder(isEnabled ? palette.outline : palette.onSurface.opacity(0.12), lineWidth: 2)
                            }
                        }
                    Circle()
                        .fill(handleColor)
                        .frame(width: configuration.isOn ? 24 : 16, height: configuration.isOn ? 24 : 16)
                        .overlay {
                            if configuration.isOn {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(isEnabled ? palette.onPrimaryContainer : palette.onSurface.opacity(0.38))
                            }
                        }
                        .offset(x: (configuration.isOn ? 10 : -10) * (layoutDirection == .rightToLeft ? -1 : 1))
                }
                .frame(width: 52, height: 32)
                .frame(minHeight: 48)
                .animation(reduceMotion ? nil : MiMaterial3Tokens.stateAnimation, value: configuration.isOn)
                .accessibilityHidden(true)
            }
            .frame(minHeight: 48)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityRepresentation {
            Toggle(isOn: configuration.$isOn) {
                configuration.label
            }
            .toggleStyle(.switch)
        }
    }

    private var trackColor: Color {
        if isEnabled {
            return configuration.isOn ? palette.primary : palette.surfaceContainerHighest
        }
        return configuration.isOn ? palette.onSurface.opacity(0.12) : palette.surfaceContainerHighest.opacity(0.12)
    }

    private var handleColor: Color {
        if isEnabled {
            return configuration.isOn ? palette.onPrimary : palette.outline
        }
        return configuration.isOn ? palette.surface : palette.onSurface.opacity(0.38)
    }
}

struct MiMaterial3TextField: View {
    let titleKey: String
    @Binding var text: String
    var errorKey: String? = nil

    @Environment(\.miMaterial3Palette) private var palette
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @FocusState private var isFocused: Bool
    @AccessibilityFocusState private var errorFocused: Bool
    @ScaledMetric(relativeTo: .body) private var inputSize = 16
    @ScaledMetric(relativeTo: .caption) private var labelSize = 12
    @ScaledMetric(relativeTo: .body) private var fieldHeight = 56

    private var isFloating: Bool { isFocused || !text.isEmpty }
    private var indicator: Color { errorKey != nil ? palette.error : isFocused ? palette.primary : palette.onSurfaceVariant }
    private var errorHint: String {
        guard let errorKey else { return "" }
        return MiL10n.text(errorKey)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 0) {
                ZStack(alignment: .leading) {
                    Text(MiL10n.text(titleKey))
                        .font(.system(size: isFloating ? labelSize : inputSize))
                        .foregroundStyle(isEnabled ? isFloating ? indicator : palette.onSurfaceVariant : palette.onSurface.opacity(0.38))
                        .offset(y: isFloating ? -inputSize * 0.65 : 0)
                        .allowsHitTesting(false)
                        .accessibilityHidden(true)
                    TextField("", text: $text)
                        .font(.system(size: inputSize))
                        .foregroundStyle(palette.onSurface.opacity(isEnabled ? 1 : 0.38))
                        .tint(indicator)
                        .focused($isFocused)
                        .padding(.top, isFloating ? labelSize + 4 : 0)
                        .accessibilityLabel(MiL10n.text(titleKey))
                        .accessibilityHint(errorHint)
                }
                if !text.isEmpty && isEnabled {
                    Button {
                        text = ""
                        isFocused = true
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(palette.onSurfaceVariant)
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(MiL10n.text("m3_clear_input"))
                }
            }
            .padding(.leading, 16)
            .padding(.trailing, text.isEmpty ? 16 : 4)
            .frame(minHeight: fieldHeight)
            .background {
                UnevenRoundedRectangle(topLeadingRadius: 4, topTrailingRadius: 4)
                    .fill(isEnabled ? palette.surfaceContainerHighest : palette.onSurface.opacity(0.04))
            }
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(isEnabled ? indicator : palette.onSurface.opacity(0.38))
                    .frame(height: isFocused ? 2 : 1)
            }
            .contentShape(Rectangle())
            .onTapGesture { if isEnabled { isFocused = true } }
            .animation(reduceMotion ? nil : MiMaterial3Tokens.stateAnimation, value: isFloating)

            if let errorKey {
                Label(MiL10n.text(errorKey), systemImage: "exclamationmark.circle.fill")
                    .font(.system(size: labelSize))
                    .foregroundStyle(isEnabled ? palette.error : palette.onSurface.opacity(0.38))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 16)
                    .accessibilityFocused($errorFocused)
                    .onAppear { errorFocused = true }
            }
        }
        .onChange(of: isEnabled) { _, enabled in
            if !enabled { isFocused = false }
        }
    }
}
