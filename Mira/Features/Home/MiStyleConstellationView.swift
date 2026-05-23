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
    let isNavigationTransitionActive: Bool
    let activeTransitionSourceID: String?
    let activeTitleTransitionStyleID: String?
    let transitionNamespace: Namespace.ID
    let onSelectStyle: (MiDesignStyle, MiStyleTransitionContext) -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var offset: CGSize = .zero
    @State private var gestureStartOffset: CGSize = .zero
    @State private var isDragging = false
    @State private var isPreparingNavigation = false
    @State private var activeGestureStartOffset: CGSize?
    @State private var pressedSourceID: String?
    @State private var pendingSelectionToken = 0

    var body: some View {
        GeometryReader { proxy in
            let canvas = MiWatchAppCanvas(size: proxy.size, styleCount: styles.count)
            let isTransitioning = isPreparingNavigation || isNavigationTransitionActive

            ZStack {
                ForEach(canvas.visibleSlots(for: offset)) { slot in
                    let style = styles[slot.styleIndex]
                    let sourceID = slot.transitionSourceID(styleID: style.id)
                    let isTransitionSource = sourceID == pressedSourceID || sourceID == activeTransitionSourceID
                    let shouldReduceCardEffects = isDragging || (isTransitioning && !isTransitionSource)

                    MiWatchAppCardReplicaView(
                        slot: slot,
                        style: style,
                        isHighlighted: highlightedStyleIDs.contains(style.id),
                        offset: offset,
                        canvas: canvas,
                        isDragging: shouldReduceCardEffects,
                        isTransitioning: isTransitioning,
                        isTitleTransitionSource: isTransitionSource,
                        activeTitleTransitionStyleID: activeTitleTransitionStyleID,
                        pressedSourceID: pressedSourceID,
                        transitionNamespace: transitionNamespace,
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
                    isPreparingNavigation = false
                    activeGestureStartOffset = nil
                    pressedSourceID = nil
                    pendingSelectionToken += 1
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
                    isPreparingNavigation = false
                    activeGestureStartOffset = nil
                    pressedSourceID = nil
                    pendingSelectionToken += 1
                }
            }
            .accessibilityElement(children: .contain)
        }
    }

    private func canvasGesture(canvas: MiWatchAppCanvas) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                guard !isNavigationTransitionActive else {
                    return
                }

                if activeGestureStartOffset == nil {
                    activeGestureStartOffset = offset
                    gestureStartOffset = offset
                    isPreparingNavigation = false
                    pendingSelectionToken += 1
                }

                let gestureOriginOffset = activeGestureStartOffset ?? offset

                if isTapCandidate(value.translation) {
                    pressedSourceID = canvas.hitTest(
                        at: value.startLocation,
                        offset: gestureOriginOffset,
                        styles: styles,
                        highlightedStyleIDs: highlightedStyleIDs,
                        reduceMotion: reduceMotion
                    )?.context.sourceID
                    return
                }

                pressedSourceID = nil
                isDragging = true
                isPreparingNavigation = false
                pendingSelectionToken += 1

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
                guard !isNavigationTransitionActive else {
                    isDragging = false
                    isPreparingNavigation = false
                    pressedSourceID = nil
                    activeGestureStartOffset = nil
                    return
                }

                let gestureOriginOffset = activeGestureStartOffset ?? offset

                defer {
                    activeGestureStartOffset = nil
                }

                if isTapCandidate(value.translation) {
                    guard
                        let hit = canvas.hitTest(
                            at: value.startLocation,
                            offset: gestureOriginOffset,
                            styles: styles,
                            highlightedStyleIDs: highlightedStyleIDs,
                            reduceMotion: reduceMotion
                        ),
                        let style = styles.first(where: { $0.id == hit.styleID })
                    else {
                        isDragging = false
                        pressedSourceID = nil
                        return
                    }

                    isDragging = false
                    isPreparingNavigation = !reduceMotion
                    pressedSourceID = hit.context.sourceID
                    if reduceMotion {
                        onSelectStyle(style, hit.context)
                        pressedSourceID = nil
                        isPreparingNavigation = false
                    } else {
                        pendingSelectionToken += 1
                        let token = pendingSelectionToken
                        let handoffDelay = 0.075

                        DispatchQueue.main.asyncAfter(deadline: .now() + handoffDelay) {
                            guard token == pendingSelectionToken else {
                                return
                            }

                            onSelectStyle(style, hit.context)
                            pressedSourceID = nil
                            isPreparingNavigation = false
                        }
                    }
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
                    isPreparingNavigation = false
                }
                pressedSourceID = nil
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
    let isTransitioning: Bool
    let isTitleTransitionSource: Bool
    let activeTitleTransitionStyleID: String?
    let pressedSourceID: String?
    let transitionNamespace: Namespace.ID
    let onSelectStyle: (MiDesignStyle, MiStyleTransitionContext) -> Void

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
        .scaleEffect(pressScale)
        .brightness(pressBrightness)
        .animation(reduceMotion ? .easeOut(duration: 0.01) : .spring(response: 0.18, dampingFraction: 0.74), value: isPressed)
        .disabled(!isHighlighted || isTransitioning)
        .position(center)
        .zIndex(focus.zIndex)
        .allowsHitTesting(isHighlighted && !isTransitioning)
        .accessibilityAction {
            onSelectStyle(style, transitionContext)
        }
    }

    private var isPressed: Bool {
        pressedSourceID == transitionSourceID && !isDragging
    }

    private var transitionSourceID: String {
        slot.transitionSourceID(styleID: style.id)
    }

    private var transitionContext: MiStyleTransitionContext {
        let renderedSize = CGSize(
            width: canvas.cardSize.width * focus.scale,
            height: canvas.cardSize.height * focus.scale
        )
        return MiStyleTransitionContext(
            sourceID: transitionSourceID,
            styleID: style.id,
            sourceFrame: CGRect(
                x: center.x - renderedSize.width / 2,
                y: center.y - renderedSize.height / 2,
                width: renderedSize.width,
                height: renderedSize.height
            ),
            cardSize: canvas.cardSize,
            sourceScale: focus.scale,
            cornerRadius: canvas.cardRadius * focus.scale
        )
    }

    private var pressScale: CGFloat {
        guard isPressed else {
            return 1
        }
        if style.id == MiNeoBrutalismModule.styleID {
            return 0.985
        }
        return 0.978
    }

    private var pressBrightness: Double {
        guard isPressed else {
            return 0
        }
        if style.id == MiNeoBrutalismModule.styleID {
            return -0.025
        }
        return 0.015
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

    func transitionSourceID(styleID: String) -> String {
        "\(styleID)-\(id)"
    }
}

struct MiStyleTransitionContext {
    let sourceID: String
    let styleID: String
    let sourceFrame: CGRect
    let cardSize: CGSize
    let sourceScale: CGFloat
    let cornerRadius: CGFloat
}

private struct MiWatchAppHitResult {
    let styleID: String
    let context: MiStyleTransitionContext
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

    func hitTest(
        at point: CGPoint,
        offset: CGSize,
        styles: [MiDesignStyle],
        highlightedStyleIDs: Set<String>,
        reduceMotion: Bool
    ) -> MiWatchAppHitResult? {
        visibleSlots(for: offset)
            .compactMap { slot -> (result: MiWatchAppHitResult, zIndex: Double)? in
                let style = styles[slot.styleIndex]
                guard highlightedStyleIDs.contains(style.id) else {
                    return nil
                }

                let center = CGPoint(
                    x: size.width / 2 + slot.position.x + offset.width,
                    y: size.height / 2 + slot.position.y + offset.height
                )
                let focus = reduceMotion ? self.focus(for: center).reducedMotion() : self.focus(for: center)
                let renderedSize = CGSize(
                    width: cardSize.width * focus.scale,
                    height: cardSize.height * focus.scale
                )
                let sourceFrame = CGRect(
                    x: center.x - renderedSize.width / 2,
                    y: center.y - renderedSize.height / 2,
                    width: renderedSize.width,
                    height: renderedSize.height
                )
                let hitRect = sourceFrame.insetBy(
                    dx: -MiWatchAppGestureMetrics.cardHitSlop,
                    dy: -MiWatchAppGestureMetrics.cardHitSlop
                )

                guard hitRect.contains(point) else {
                    return nil
                }

                return (
                    MiWatchAppHitResult(
                        styleID: style.id,
                        context: MiStyleTransitionContext(
                            sourceID: slot.transitionSourceID(styleID: style.id),
                            styleID: style.id,
                            sourceFrame: sourceFrame,
                            cardSize: cardSize,
                            sourceScale: focus.scale,
                            cornerRadius: cardRadius * focus.scale
                        )
                    ),
                    focus.zIndex
                )
            }
            .max { lhs, rhs in lhs.zIndex < rhs.zIndex }?
            .result
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
            scale: 0.66 + prominence * 0.52,
            opacity: 0.24 + prominence * 0.76,
            shadowOpacity: 0.03 + prominence * 0.25,
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
