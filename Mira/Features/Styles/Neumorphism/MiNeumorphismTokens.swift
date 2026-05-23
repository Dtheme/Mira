//
//  MiNeumorphismTokens.swift
//  Mira
//
//  Created on 2026/5/23.
//

import SwiftUI

enum MiNeumorphismTokens {
    static let base = Color(hex: 0xE8E8E8)
    static let page = Color(hex: 0xEEEEEE)
    static let baseLight = Color(hex: 0xF4F4F4)
    static let basePressed = Color(hex: 0xDDDDDD)
    static let shadowDark = Color(hex: 0xC5C5C5)
    static let shadowLight = Color.white
    static let ink = Color(hex: 0x343A40)
    static let muted = Color(hex: 0x6F747A)
    static let accent = Color(hex: 0x7B8EA4)
    static let focusAccent = Color(hex: 0x8FA6C8)
    static let accentDeep = Color(hex: 0x5E738E)
    static let success = Color(hex: 0x7FA58A)
    static let error = Color(hex: 0xB97878)
    static let stroke = Color(hex: 0xD9DDE1)

    static let radius: CGFloat = 24
    static let smallRadius: CGFloat = 15
    static let outerShadow: CGFloat = 16
    static let dragShadowScale: CGFloat = 0.58

    static var pageBackground: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: 0xF6F6F6),
                page,
                Color(hex: 0xE7E9EC)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
