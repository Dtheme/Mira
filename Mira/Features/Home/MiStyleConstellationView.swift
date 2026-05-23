//
//  MiStyleConstellationView.swift
//  Mira
//
//  Created on 2026/5/22.
//

import SwiftUI

struct MiStyleConstellationView: View {
    let styles: [MiDesignStyle]
    let highlightedStyleIDs: Set<String>
    let focusedStyleID: String?
    let focusSignal: Int
    let resetSignal: Int
    let onSelectStyle: (MiDesignStyle) -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var offset: CGSize = .zero
    @State private var gestureStartOffset: CGSize = .zero
    @State private var isDragging = false
    @State private var activeGestureStartOffset: CGSize?
    @State private var pressedStyleID: String?

    var body: some View {
        GeometryReader { proxy in
            let canvas = MiWatchAppCanvas(size: proxy.size, styleCount: styles.count)

            ZStack {
                ForEach(canvas.visibleSlots(for: offset)) { slot in
                    MiWatchAppCardReplicaView(
                        slot: slot,
                        style: styles[slot.styleIndex],
                        isHighlighted: highlightedStyleIDs.contains(styles[slot.styleIndex].id),
                        offset: offset,
                        canvas: canvas,
                        isDragging: isDragging,
                        pressedStyleID: pressedStyleID,
                        onSelectStyle: onSelectStyle
                    )
                }
            }
            .transaction { transaction in
                if isDragging {
                    transaction.animation = nil
                }
            }
            .contentShape(Rectangle())
            .gesture(canvasGesture(canvas: canvas))
            .onChange(of: resetSignal) {
                withAnimation(reduceMotion ? .easeOut(duration: 0.16) : .spring(response: 0.55, dampingFraction: 0.78)) {
                    offset = .zero
                    gestureStartOffset = .zero
                    isDragging = false
                    activeGestureStartOffset = nil
                    pressedStyleID = nil
                }
            }
            .onChange(of: focusSignal) {
                guard
                    let focusedStyleID,
                    let styleIndex = styles.firstIndex(where: { $0.id == focusedStyleID }),
                    let targetSlot = canvas.nearestSlot(for: styleIndex, offset: offset)
                else {
                    return
                }

                let nextOffset = CGSize(
                    width: -targetSlot.position.x,
                    height: -targetSlot.position.y
                )

                withAnimation(reduceMotion ? .easeOut(duration: 0.18) : .spring(response: 0.52, dampingFraction: 0.84)) {
                    offset = nextOffset
                    gestureStartOffset = nextOffset
                    isDragging = false
                    activeGestureStartOffset = nil
                    pressedStyleID = nil
                }
            }
            .accessibilityElement(children: .contain)
        }
    }

    private func canvasGesture(canvas: MiWatchAppCanvas) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                if activeGestureStartOffset == nil {
                    activeGestureStartOffset = offset
                    gestureStartOffset = offset
                }

                let gestureOriginOffset = activeGestureStartOffset ?? offset

                if isTapCandidate(value.translation) {
                    pressedStyleID = canvas.hitTestStyleID(
                        at: value.startLocation,
                        offset: gestureOriginOffset,
                        styles: styles,
                        highlightedStyleIDs: highlightedStyleIDs,
                        reduceMotion: reduceMotion
                    )
                    return
                }

                pressedStyleID = nil
                isDragging = true

                var transaction = Transaction()
                transaction.animation = nil
                withTransaction(transaction) {
                    offset = CGSize(
                        width: gestureOriginOffset.width + value.translation.width,
                        height: gestureOriginOffset.height + value.translation.height
                    )
                }
            }
            .onEnded { value in
                let gestureOriginOffset = activeGestureStartOffset ?? offset

                defer {
                    activeGestureStartOffset = nil
                    pressedStyleID = nil
                }

                if isTapCandidate(value.translation) {
                    guard
                        let styleID = canvas.hitTestStyleID(
                            at: value.startLocation,
                            offset: gestureOriginOffset,
                            styles: styles,
                            highlightedStyleIDs: highlightedStyleIDs,
                            reduceMotion: reduceMotion
                        ),
                        let style = styles.first(where: { $0.id == styleID })
                    else {
                        isDragging = false
                        return
                    }

                    isDragging = false
                    onSelectStyle(style)
                    return
                }

                let momentum = reduceMotion
                    ? .zero
                    : CGSize(
                        width: (value.predictedEndTranslation.width - value.translation.width) * 0.14,
                        height: (value.predictedEndTranslation.height - value.translation.height) * 0.14
                    )
                let proposedOffset = CGSize(
                    width: gestureOriginOffset.width + value.translation.width + momentum.width,
                    height: gestureOriginOffset.height + value.translation.height + momentum.height
                )
                let nextOffset = reduceMotion
                    ? proposedOffset
                    : canvas.snappedOffsetIfNeeded(from: proposedOffset)
                let animation: Animation = reduceMotion
                    ? .easeOut(duration: 0.14)
                    : .interactiveSpring(response: 0.36, dampingFraction: 0.86)

                withAnimation(animation) {
                    offset = nextOffset
                    isDragging = false
                }
                self.gestureStartOffset = nextOffset
            }
    }

    private func isTapCandidate(_ translation: CGSize) -> Bool {
        hypot(translation.width, translation.height) <= MiWatchAppGestureMetrics.tapTolerance
    }
}

private struct MiWatchAppCardReplicaView: View {
    let slot: MiWatchAppSlot
    let style: MiDesignStyle
    let isHighlighted: Bool
    let offset: CGSize
    let canvas: MiWatchAppCanvas
    let isDragging: Bool
    let pressedStyleID: String?
    let onSelectStyle: (MiDesignStyle) -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var center: CGPoint {
        return CGPoint(
            x: canvas.size.width / 2 + slot.position.x + offset.width,
            y: canvas.size.height / 2 + slot.position.y + offset.height
        )
    }

    private var focus: MiCardFocus {
        let focus = canvas.focus(for: center)
        return reduceMotion ? focus.reducedMotion() : focus
    }

    var body: some View {
        MiStyleCardView(
            style: style,
            focus: isHighlighted ? focus : focus.dimmed(),
            cardSize: canvas.cardSize,
            cornerRadius: canvas.cardRadius,
            isDragging: isDragging
        )
        .environment(\.miHomePressedStyleID, isPressed ? style.id : nil)
        .scaleEffect(isPressed && style.id == MiNeoBrutalismModule.styleID ? 0.985 : 1)
        .brightness(isPressed && style.id == MiNeoBrutalismModule.styleID ? -0.025 : 0)
        .animation(reduceMotion ? .easeOut(duration: 0.01) : .spring(response: 0.18, dampingFraction: 0.74), value: isPressed)
        .disabled(!isHighlighted)
        .position(center)
        .zIndex(focus.zIndex)
        .allowsHitTesting(isHighlighted)
        .accessibilityAction {
            onSelectStyle(style)
        }
    }

    private var isPressed: Bool {
        pressedStyleID == style.id && !isDragging
    }
}

private enum MiWatchAppGestureMetrics {
    static let tapTolerance: CGFloat = 8
    static let cardHitSlop: CGFloat = 6
}

private struct MiHomePressedStyleIDEnvironmentKey: EnvironmentKey {
    static let defaultValue: String? = nil
}

extension EnvironmentValues {
    var miHomePressedStyleID: String? {
        get { self[MiHomePressedStyleIDEnvironmentKey.self] }
        set { self[MiHomePressedStyleIDEnvironmentKey.self] = newValue }
    }
}

private struct MiWatchAppSlot: Identifiable, Hashable {
    let row: Int
    let column: Int
    let position: CGPoint
    let styleIndex: Int

    var id: String {
        "\(row)-\(column)"
    }
}

private struct MiWatchAppCanvas {
    let size: CGSize
    let styleCount: Int

    private var safeStyleCount: Int {
        max(styleCount, 1)
    }

    var cardSize: CGSize {
        if size.width >= 760 {
            return MiSpacingTokens.homeCardPad
        }
        if size.width >= 430 {
            return MiSpacingTokens.homeCardLarge
        }
        if size.width >= 390 {
            return MiSpacingTokens.homeCardRegular
        }
        return MiSpacingTokens.homeCardCompact
    }

    var cardRadius: CGFloat {
        if size.width >= 760 {
            return MiSpacingTokens.homeCardRadiusPad
        }
        if size.width >= 430 {
            return MiSpacingTokens.homeCardRadiusLarge
        }
        if size.width >= 390 {
            return MiSpacingTokens.homeCardRadiusRegular
        }
        return MiSpacingTokens.homeCardRadiusCompact
    }

    var stepX: CGFloat {
        cardSize.width * 1.18
    }

    var stepY: CGFloat {
        cardSize.height * 0.96
    }

    func visibleSlots(for offset: CGSize) -> [MiWatchAppSlot] {
        let anchor = anchorSlotCoordinate(for: offset)
        return stableSlotPattern.map { relative in
            makeSlot(row: anchor.row + relative.row, column: anchor.column + relative.column)
        }
    }

    func nearestSlot(for styleIndex: Int, offset: CGSize) -> MiWatchAppSlot? {
        let margin = max(size.width, size.height) + max(cardSize.width, cardSize.height) * 2
        return candidateSlots(for: offset, margin: margin)
            .filter { $0.styleIndex == styleIndex }
            .min { lhs, rhs in
                screenDistanceSquared(for: lhs, offset: offset) < screenDistanceSquared(for: rhs, offset: offset)
            }
    }

    func snappedOffsetIfNeeded(from offset: CGSize) -> CGSize {
        guard let nearestSlot = visibleSlots(for: offset).min(by: { lhs, rhs in
            screenDistanceSquared(for: lhs, offset: offset) < screenDistanceSquared(for: rhs, offset: offset)
        }) else {
            return offset
        }

        let distance = sqrt(screenDistanceSquared(for: nearestSlot, offset: offset))
        guard distance <= snapRadius else {
            return offset
        }

        return CGSize(width: -nearestSlot.position.x, height: -nearestSlot.position.y)
    }

    func hitTestStyleID(
        at point: CGPoint,
        offset: CGSize,
        styles: [MiDesignStyle],
        highlightedStyleIDs: Set<String>,
        reduceMotion: Bool
    ) -> String? {
        visibleSlots(for: offset)
            .compactMap { slot -> (styleID: String, zIndex: Double)? in
                let style = styles[slot.styleIndex]
                guard highlightedStyleIDs.contains(style.id) else {
                    return nil
                }

                let center = CGPoint(
                    x: size.width / 2 + slot.position.x + offset.width,
                    y: size.height / 2 + slot.position.y + offset.height
                )
                let focus = reduceMotion ? self.focus(for: center).reducedMotion() : self.focus(for: center)
                let hitSize = CGSize(
                    width: cardSize.width * focus.scale + MiWatchAppGestureMetrics.cardHitSlop * 2,
                    height: cardSize.height * focus.scale + MiWatchAppGestureMetrics.cardHitSlop * 2
                )
                let hitRect = CGRect(
                    x: center.x - hitSize.width / 2,
                    y: center.y - hitSize.height / 2,
                    width: hitSize.width,
                    height: hitSize.height
                )

                guard hitRect.contains(point) else {
                    return nil
                }

                return (style.id, focus.zIndex)
            }
            .max { lhs, rhs in lhs.zIndex < rhs.zIndex }?
            .styleID
    }

    private func candidateSlots(for offset: CGSize, margin: CGFloat) -> [MiWatchAppSlot] {
        let lowerY = -size.height / 2 - offset.height - margin
        let upperY = size.height / 2 - offset.height + margin
        let lowerRow = Int(floor(lowerY / stepY)) - 1
        let upperRow = Int(ceil(upperY / stepY)) + 1

        return (lowerRow...upperRow).flatMap { row in
            let stagger = row.isMultiple(of: 2) ? CGFloat.zero : stepX / 2
            let lowerX = -size.width / 2 - offset.width - margin
            let upperX = size.width / 2 - offset.width + margin
            let lowerColumn = Int(floor((lowerX - stagger) / stepX)) - 1
            let upperColumn = Int(ceil((upperX - stagger) / stepX)) + 1

            return (lowerColumn...upperColumn).map { column in
                makeSlot(row: row, column: column)
            }
        }
    }

    private func anchorSlotCoordinate(for offset: CGSize) -> (row: Int, column: Int) {
        let row = Int(round(-offset.height / stepY))
        let stagger = row.isMultiple(of: 2) ? CGFloat.zero : stepX / 2
        let column = Int(round((-offset.width - stagger) / stepX))
        return (row, column)
    }

    private func makeSlot(row: Int, column: Int) -> MiWatchAppSlot {
        let stagger = row.isMultiple(of: 2) ? CGFloat.zero : stepX / 2
        let styleIndex = positiveModulo(row * safeStyleCount + column, safeStyleCount)
        return MiWatchAppSlot(
            row: row,
            column: column,
            position: CGPoint(
                x: CGFloat(column) * stepX + stagger,
                y: CGFloat(row) * stepY
            ),
            styleIndex: styleIndex
        )
    }

    func focus(for center: CGPoint) -> MiCardFocus {
        let viewportCenter = CGPoint(x: size.width / 2, y: size.height / 2)
        let distance = hypot(center.x - viewportCenter.x, center.y - viewportCenter.y)
        let maxDistance = min(size.width, size.height) * 0.70
        let normalized = min(max(distance / maxDistance, 0), 1)
        let prominence = 1 - normalized

        return MiCardFocus(
            scale: 0.60 + prominence * 0.66,
            opacity: 0.20 + prominence * 0.80,
            shadowOpacity: 0.03 + prominence * 0.31,
            borderOpacity: 0.12 + prominence * 0.50,
            zIndex: Double(prominence * 100)
        )
    }

    private func positiveModulo(_ value: Int, _ divisor: Int) -> Int {
        let result = value % divisor
        return result >= 0 ? result : result + divisor
    }

    private var maxRenderedSlots: Int {
        size.width >= 760 ? 14 : 12
    }

    private var stableSlotPattern: [(row: Int, column: Int)] {
        let base = [
            (0, 0),
            (0, 1),
            (0, -1),
            (1, 0),
            (-1, 0),
            (1, -1),
            (-1, 1),
            (1, 1),
            (-1, -1),
            (2, 0),
            (-2, 0),
            (0, 2),
            (0, -2),
            (2, -1),
            (-2, 1)
        ]

        if maxRenderedSlots <= base.count {
            return Array(base.prefix(maxRenderedSlots))
        }

        let extended = base + [
            (2, 1),
            (-2, -1)
        ]
        return Array(extended.prefix(maxRenderedSlots))
    }

    private var snapRadius: CGFloat {
        min(max(cardSize.width * 0.34, 56), 82)
    }

    private func screenDistanceSquared(for slot: MiWatchAppSlot, offset: CGSize) -> CGFloat {
        let x = slot.position.x + offset.width
        let y = slot.position.y + offset.height
        return x * x + y * y
    }
}

struct MiCardFocus: Hashable {
    let scale: CGFloat
    let opacity: Double
    let shadowOpacity: Double
    let borderOpacity: Double
    let zIndex: Double

    func dimmed() -> MiCardFocus {
        MiCardFocus(
            scale: scale * 0.94,
            opacity: min(opacity, 0.28),
            shadowOpacity: 0.02,
            borderOpacity: 0.08,
            zIndex: zIndex
        )
    }

    func reducedMotion() -> MiCardFocus {
        MiCardFocus(
            scale: min(max(scale, 0.90), 1.08),
            opacity: opacity,
            shadowOpacity: shadowOpacity * 0.72,
            borderOpacity: borderOpacity,
            zIndex: zIndex
        )
    }
}
