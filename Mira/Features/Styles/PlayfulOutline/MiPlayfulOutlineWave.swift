import SwiftUI

struct MiPlayfulOutlineWave: Shape {
    var phase: CGFloat = 0
    var amplitude: CGFloat = 12

    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(phase, amplitude) }
        set {
            phase = newValue.first
            amplitude = max(0, newValue.second)
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let height = min(max(amplitude, 0), rect.height / 3)
        let bias = sin(phase) * 0.08
        let middle = CGPoint(x: rect.minX + rect.width * (0.56 + bias), y: rect.minY + height * 0.9)
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + height * 1.7))
        path.addCurve(
            to: middle,
            control1: CGPoint(x: rect.minX + rect.width * 0.19, y: rect.minY - height * 0.6),
            control2: CGPoint(x: middle.x - rect.width * 0.18, y: middle.y)
        )
        path.addCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY + height * 0.2),
            control1: CGPoint(x: middle.x + rect.width * 0.18, y: middle.y),
            control2: CGPoint(x: rect.minX + rect.width * 0.86, y: rect.minY + height * 1.9)
        )
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
