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
        let height = min(amplitude, rect.height / 3)
        for index in 0...72 {
            let fraction = CGFloat(index) / 72
            let y = height * (1.2 + sin(fraction * .pi * 4 + phase) * 0.65
                + sin(fraction * .pi * 6 - phase) * 0.25)
            let point = CGPoint(x: rect.minX + rect.width * fraction, y: rect.minY + y)
            if index == 0 { path.move(to: point) } else { path.addLine(to: point) }
        }
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct MiPlayfulOutlineBeatMark: Shape {
    var phase: CGFloat = 0
    var intensity: CGFloat = 0

    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(phase, intensity) }
        set {
            phase = newValue.first
            intensity = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        let levels: [CGFloat] = [0.25, 0.46, 0.72, 0.94, 0.58, 0.82, 0.52, 0.34, 0.18]
        let step = rect.width / CGFloat(levels.count)
        var path = Path()
        for (index, level) in levels.enumerated() {
            let movement = (sin(phase + CGFloat(index) * 0.85) + 1) / 2
            let height = max(3, rect.height * level * (1 - intensity * 0.65 + movement * intensity * 0.65))
            let bar = CGRect(x: rect.minX + CGFloat(index) * step, y: rect.midY - height / 2, width: step * 0.42, height: height)
            path.addRoundedRect(in: bar, cornerSize: CGSize(width: step * 0.21, height: step * 0.21))
        }
        return path
    }
}
