import SwiftUI

struct MiPlayfulOutlineFlowShape: Shape {
    var position: CGFloat
    var depth: CGFloat = 44
    var baseline: CGFloat = 18

    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(position, depth) }
        set {
            position = newValue.first
            depth = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        let center = rect.minX + rect.width * min(max(position, 0), 1)
        let spread = max(rect.width * 0.29, 1)
        let top = rect.minY + baseline
        let drop = min(max(depth, 0), max(rect.maxY - top, 0))
        let step = rect.width / 8

        func edge(at x: CGFloat) -> (point: CGPoint, slope: CGFloat) {
            let distance = (x - center) / spread
            let lift = drop * exp(-distance * distance)
            return (CGPoint(x: x, y: top + lift), -2 * distance * lift / spread)
        }

        var path = Path()
        path.move(to: edge(at: rect.minX).point)
        for index in 0..<8 {
            let start = edge(at: rect.minX + CGFloat(index) * step)
            let end = edge(at: rect.minX + CGFloat(index + 1) * step)
            path.addCurve(
                to: end.point,
                control1: CGPoint(x: start.point.x + step / 3, y: start.point.y + start.slope * step / 3),
                control2: CGPoint(x: end.point.x - step / 3, y: end.point.y - end.slope * step / 3)
            )
        }
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct MiPlayfulOutlineFlowTabBar: View {
    @Binding var selection: Int
    var isElastic = true

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.layoutDirection) private var layoutDirection
    @ScaledMetric(relativeTo: .body) private var metricScale: CGFloat = 1.0

    private typealias T = MiPlayfulOutlineTokens
    private let titles = ["po_nav_inspiration", "po_nav_components", "po_nav_reference"]
    private let symbols = ["sparkles", "slider.horizontal.3", "book.closed"]
    private var scale: CGFloat { min(metricScale, 1.5) }
    private var selectedIndex: Int { min(max(selection, 0), 2) }
    private var depth: CGFloat { [42.0, 48.0, 40.0][selectedIndex] * scale }
    private var position: CGFloat {
        let index = layoutDirection == .rightToLeft ? 2 - selectedIndex : selectedIndex
        return (CGFloat(index) + 0.5) / 3
    }
    private var motion: Animation? { reduceMotion || !isElastic ? nil : .spring(response: 0.52, dampingFraction: 0.86) }

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(titles.indices, id: \.self) { index in
                tab(at: index)
            }
        }
        .padding(.top, 18)
        .overlay {
            ZStack(alignment: .top) {
                symbolRow
                    .foregroundStyle(T.ink)
                symbolRow
                    .foregroundStyle(T.paper)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .mask {
                        flowBoundary
                            .animation(motion, value: selectedIndex)
                    }
            }
            .allowsHitTesting(false)
            .accessibilityHidden(true)
        }
        .background {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    T.paper
                    flowBoundary
                        .fill(T.ink)
                        .frame(height: geometry.size.height)
                        .animation(motion, value: selectedIndex)
                }
            }
            .accessibilityHidden(true)
        }
        .background(T.ink.ignoresSafeArea(.container, edges: .bottom))
        .accessibilityElement(children: .contain)
    }

    private var flowBoundary: some Shape {
        MiPlayfulOutlineFlowShape(position: position, depth: depth)
    }

    private var symbolRow: some View {
        HStack(spacing: 0) {
            ForEach(symbols.indices, id: \.self) { index in
                Image(systemName: symbols[index])
                    .symbolVariant(selection == index ? .fill : .none)
                    .font(.system(size: 23 * scale, weight: selection == index ? .bold : .medium))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44 * scale)
            }
        }
        .padding(.top, 18)
    }

    private func tab(at index: Int) -> some View {
        let isSelected = selection == index
        return Button {
            withAnimation(motion) {
                selection = index
            }
        } label: {
            VStack(spacing: 20 * scale) {
                Color.clear
                    .frame(height: 44 * scale)

                Text(MiL10n.text(titles[index]))
                    .font(.caption.weight(isSelected ? .bold : .medium))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundStyle(isSelected ? T.accent : T.paper)
                    .frame(maxWidth: .infinity, minHeight: 24 * scale, alignment: .top)
                    .padding(.horizontal, 6)
            }
            .padding(.bottom, 12)
            .frame(maxWidth: .infinity, minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(MiL10n.text(titles[index]))
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
