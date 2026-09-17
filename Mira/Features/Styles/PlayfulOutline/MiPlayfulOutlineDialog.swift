import SwiftUI

struct MiPlayfulOutlineDialog: View {
    let onDismiss: () -> Void
    let onConfirm: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isPresented = false
    @State private var isConfirmed = false
    @State private var isClosing = false
    @AccessibilityFocusState private var titleIsFocused: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                MiPlayfulOutlineTokens.ink.opacity(isPresented ? 0.28 : 0)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture(perform: dismiss)
                    .accessibilityHidden(true)

                ScrollView {
                    VStack(spacing: 0) {
                        Spacer(minLength: 0)

                        MiPlayfulOutlineDialogPanel(
                            isConfirmed: isConfirmed,
                            titleIsFocused: $titleIsFocused,
                            onCancel: dismiss,
                            onConfirm: confirm
                        )
                        .frame(maxWidth: 420)
                        .contentShape(RoundedRectangle(cornerRadius: 32))
                        .onTapGesture { }
                        .opacity(isPresented ? 1 : 0)
                        .scaleEffect(reduceMotion || isPresented ? 1 : 0.96)
                        .offset(y: reduceMotion || isPresented ? 0 : 24)

                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: max(0, geometry.size.height - 48))
                    .padding(24)
                    .contentShape(Rectangle())
                    .onTapGesture(perform: dismiss)
                }
                .scrollBounceBehavior(.basedOnSize)
                .scrollIndicators(.hidden)
                .allowsHitTesting(!isClosing)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
        .accessibilityAction(.escape, dismiss)
        .task {
            withAnimation(reduceMotion ? .easeOut(duration: 0.12) : .spring(response: 0.40, dampingFraction: 0.86)) {
                isPresented = true
            }
        }
        .task(id: isConfirmed) {
            titleIsFocused = false
            do {
                try await Task.sleep(for: .milliseconds(160))
            } catch {
                return
            }
            guard !Task.isCancelled, !isClosing else { return }
            titleIsFocused = true
        }
        .task(id: isClosing) {
            guard isClosing else { return }
            withAnimation(.easeOut(duration: reduceMotion ? 0.12 : 0.20)) {
                isPresented = false
            }
            do {
                try await Task.sleep(for: .milliseconds(reduceMotion ? 120 : 200))
            } catch {
                return
            }
            guard !Task.isCancelled else { return }
            onDismiss()
        }
    }

    private func confirm() {
        guard !isConfirmed, !isClosing else { return }
        withAnimation(reduceMotion ? nil : MiPlayfulOutlineTokens.response) {
            isConfirmed = true
        }
        onConfirm()
    }

    private func dismiss() {
        guard !isClosing else { return }
        titleIsFocused = false
        isClosing = true
    }
}

private struct MiPlayfulOutlineDialogPanel: View {
    let isConfirmed: Bool
    var titleIsFocused: AccessibilityFocusState<Bool>.Binding
    let onCancel: () -> Void
    let onConfirm: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                MiPlayfulOutlineTokens.accent
                MiPlayfulOutlineDialogSymbol(isConfirmed: isConfirmed)
                    .frame(maxHeight: .infinity)
                    .padding(.bottom, 12)
                MiPlayfulOutlineWave(phase: isConfirmed && !reduceMotion ? 0.7 : 0, amplitude: 10)
                    .fill(MiPlayfulOutlineTokens.surface)
                    .frame(height: 28)
            }
            .frame(height: 148)
            .accessibilityHidden(true)

            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text(MiL10n.text(isConfirmed ? "po_dialog_success_title" : "po_dialog_title"))
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundStyle(MiPlayfulOutlineTokens.ink)
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityFocused(titleIsFocused)

                    Text(MiL10n.text(isConfirmed ? "po_dialog_success_body" : "po_dialog_body"))
                        .font(.body)
                        .foregroundStyle(MiPlayfulOutlineTokens.muted)
                }
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .contentTransition(.opacity)

                VStack(spacing: 12) {
                    if isConfirmed {
                        Button(action: onCancel) {
                            Text(MiL10n.text("po_dialog_done"))
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(MiPlayfulOutlineButtonStyle(filled: true))
                        .transition(.opacity)
                    } else {
                        Button(role: .destructive, action: onConfirm) {
                            Text(MiL10n.text("po_dialog_confirm"))
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(MiPlayfulOutlineButtonStyle(filled: true, destructive: true))

                        Button(role: .cancel, action: onCancel) {
                            Text(MiL10n.text("po_dialog_cancel"))
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(MiPlayfulOutlineButtonStyle())
                    }
                }
            }
            .padding(24)
        }
        .background(MiPlayfulOutlineTokens.surface)
        .clipShape(RoundedRectangle(cornerRadius: 32))
        .transaction { transaction in
            if reduceMotion {
                transaction.animation = nil
            }
        }
    }
}

private struct MiPlayfulOutlineDialogSymbol: View {
    let isConfirmed: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var checkProgress: CGFloat = 0

    var body: some View {
        ZStack {
            Circle()
                .fill(MiPlayfulOutlineTokens.surface)

            Image(systemName: "trash")
                .font(.system(size: 30, weight: .regular))
                .opacity(isConfirmed ? 0 : 1)
                .scaleEffect(reduceMotion || !isConfirmed ? 1 : 0.75)

            MiPlayfulOutlineCheckmark()
                .trim(from: 0, to: checkProgress)
                .stroke(MiPlayfulOutlineTokens.ink, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .frame(width: 34, height: 26)
        }
        .foregroundStyle(MiPlayfulOutlineTokens.ink)
        .frame(width: 88, height: 88)
        .accessibilityHidden(true)
        .task(id: isConfirmed) {
            guard isConfirmed else { return }
            withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.32)) {
                checkProgress = 1
            }
        }
    }
}

private struct MiPlayfulOutlineCheckmark: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.width * 0.36, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        }
    }
}
