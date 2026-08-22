//
//  MiDemoRepository.swift
//  Mira
//
//  Created on 2026/6/29.
//

import Foundation

enum MiDemoRepository {
    static let demos: [MiDemo] = [
        MiDemo(
            id: "holo-card",
            titleKey: "demo_holo_title",
            subtitleKey: "demo_holo_subtitle",
            systemImage: "sparkles",
            accentHex: 0x6C5CE7,
            isReady: true
        ),
        MiDemo(
            id: "holo-egg",
            titleKey: "demo_egg_title",
            subtitleKey: "demo_egg_subtitle",
            systemImage: "oval.portrait.fill",
            accentHex: 0xA556E8,
            isReady: true
        )
    ]
}
