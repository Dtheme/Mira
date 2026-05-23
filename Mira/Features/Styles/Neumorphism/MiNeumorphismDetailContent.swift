//
//  MiNeumorphismDetailContent.swift
//  Mira
//
//  Created on 2026/5/23.
//

import SwiftUI

struct MiNeumorphismPromptItem: Identifiable {
    let key: String

    var id: String {
        key
    }
}

enum MiNeumorphismDetailContent {
    static let segmentKeys = [
        "neu_seg_raised",
        "neu_seg_inset",
        "neu_seg_focus"
    ]

    static let promptItems = [
        MiNeumorphismPromptItem(key: "neu_prompt_1"),
        MiNeumorphismPromptItem(key: "neu_prompt_2"),
        MiNeumorphismPromptItem(key: "neu_prompt_3")
    ]

    static let checklistItems = [
        MiNeumorphismPromptItem(key: "neu_check_1"),
        MiNeumorphismPromptItem(key: "neu_check_2"),
        MiNeumorphismPromptItem(key: "neu_check_3"),
        MiNeumorphismPromptItem(key: "neu_check_4")
    ]

    static let tokenSwatches: [(titleKey: String, value: String, color: Color)] = [
        ("neu_base_surface", "#E8E8E8", MiNeumorphismTokens.base),
        ("neu_shadow_light", "#FFFFFF", MiNeumorphismTokens.shadowLight),
        ("neu_shadow_dark", "#C5C5C5", MiNeumorphismTokens.shadowDark),
        ("neu_ink_text", "#343A40", MiNeumorphismTokens.ink),
        ("neu_accent_surface", "#8FA6C8", MiNeumorphismTokens.focusAccent)
    ]
}
