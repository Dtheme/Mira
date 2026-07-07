//
//  MiMotionTiltProvider.swift
//  Mira
//
//  Created on 2026/6/29.
//
//  CoreMotion gyroscope -> normalized tilt (-1...1), driven through a critically
//  damped spring so the card follows the device smoothly and settles naturally
//  (nicer than a one-pole low-pass). Gyro is primary; when unavailable
//  (Simulator / no-sensor) it falls back to a gentle auto-sway. Reduce Motion
//  eases the tilt to rest.
//
//  State lives behind an OSAllocatedUnfairLock so the (possibly off-main) motion
//  handler and the per-frame `advance` call never race.
//

import CoreMotion
import os

final class MiMotionTiltProvider {
    private struct TiltState {
        var target = SIMD2<Float>(0, 0)
        var current = SIMD2<Float>(0, 0)
        var velocity = SIMD2<Float>(0, 0)
        var isLive = false
        var lastTime: Float = -1
        // Pointer override: while the user drags the card, the finger position
        // drives the tilt/glare directly (snappy), overriding gyro / auto-sway.
        var manualActive = false
        var manual = SIMD2<Float>(0, 0)
        // Relative-tilt baseline: the device pose is treated as neutral when the
        // card appears, and the tilt slowly recenters, so there is no persistent
        // "falling" pull from holding the phone at a natural angle.
        var baseline = SIMD2<Float>(0, 0)
        var resetRef = true
    }

    private let motion = CMMotionManager()
    private let state = OSAllocatedUnfairLock(initialState: TiltState())
    private let maxTilt: Float = 0.5236   // ~30 degrees, in radians

    // Deliver the 60Hz motion callbacks off the main queue; the lock guards state.
    private let motionQueue: OperationQueue = {
        let q = OperationQueue()
        q.name = "com.mira.holo.motion"
        q.maxConcurrentOperationCount = 1
        q.qualityOfService = .userInteractive
        return q
    }()

    func start() {
        guard motion.isDeviceMotionAvailable, !motion.isDeviceMotionActive else { return }
        motion.deviceMotionUpdateInterval = 1.0 / 60.0
        let state = self.state
        let maxTilt = self.maxTilt
        state.withLock { $0.resetRef = true }
        motion.startDeviceMotionUpdates(to: motionQueue) { data, _ in
            guard let data else { return }
            // Relative tilt: measure deviation from a slowly-adapting baseline so
            // the card is neutral at the current holding pose and gently recenters
            // (no persistent gravity pull / "falling" feel).
            let gx = Float(data.gravity.x)
            let gy = Float(data.gravity.y)
            let span = sin(maxTilt)
            let raw = SIMD2<Float>(max(-1.6, min(1.6, gx / span)),
                                   max(-1.6, min(1.6, -gy / span)))
            let gain: Float = 1.25
            state.withLock { s in
                s.isLive = true
                if s.resetRef { s.resetRef = false; s.baseline = raw }
                s.baseline += (raw - s.baseline) * 0.01     // ~1.6s recenter
                let dev = raw - s.baseline
                s.target = SIMD2<Float>(max(-1, min(1, dev.x * gain)),
                                        max(-1, min(1, dev.y * gain)))
            }
        }
    }

    func stop() {
        if motion.isDeviceMotionActive {
            motion.stopDeviceMotionUpdates()
        }
    }

    /// Drive the tilt directly from a pointer (touch) in -1...1; overrides gyro.
    func setPointer(_ p: SIMD2<Float>) {
        let cp = SIMD2<Float>(max(-1, min(1, p.x)), max(-1, min(1, p.y)))
        state.withLock { s in
            s.manualActive = true
            s.manual = cp
        }
    }

    /// Release the pointer; the tilt springs back to gyro / auto-sway.
    func releasePointer() {
        state.withLock { s in s.manualActive = false }
    }

    /// Snap the tilt to neutral (used on card switch so the new card doesn't
    /// inherit and unwind the previous card's tilt).
    func resetToNeutral() {
        state.withLock { s in
            s.manualActive = false
            s.manual = SIMD2<Float>(0, 0)
            s.current = SIMD2<Float>(0, 0)
            s.velocity = SIMD2<Float>(0, 0)
            s.target = SIMD2<Float>(0, 0)
            s.resetRef = true
        }
    }

    /// Advances the spring one frame and returns the smoothed tilt in -1...1.
    func advance(time: Float, reduceMotion: Bool) -> SIMD2<Float> {
        // Precompute the auto-sway outside the critical section.
        let t = Double(time)
        let sway = SIMD2<Float>(Float(sin(t * 0.5)) * 0.32, Float(cos(t * 0.62)) * 0.24)

        return state.withLock { s in
            var dt: Float = 1.0 / 60.0
            if s.lastTime >= 0 {
                dt = max(0, min(1.0 / 30.0, time - s.lastTime))
            }
            s.lastTime = time

            // Pointer drag: follow the finger snappily (no springy lag).
            if s.manualActive && !reduceMotion {
                s.velocity = SIMD2<Float>(0, 0)
                s.current += (s.manual - s.current) * min(1.0, 26.0 * dt)
                return s.current
            }

            let goal: SIMD2<Float>
            if reduceMotion {
                goal = SIMD2<Float>(0, 0)
            } else if s.isLive {
                goal = s.target
            } else {
                goal = sway   // Simulator / no-gyro fallback
            }

            // critically-damped-ish spring (a touch of life, no harsh overshoot)
            let stiffness: Float = reduceMotion ? 90 : 175
            let damping: Float = reduceMotion ? 22 : 24
            let accel = (goal - s.current) * stiffness - s.velocity * damping
            s.velocity += accel * dt
            s.current += s.velocity * dt
            return s.current
        }
    }
}
