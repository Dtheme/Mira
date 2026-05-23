//
//  MiNeoBrutalismDemoContent.swift
//  Mira
//
//  Created on 2026/5/22.
//

import SwiftUI

struct MiNeoBrutalismTokenItem: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let detail: String
    let color: Color
}

struct MiNeoBrutalismShadowItem: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let shadow: CGSize
    let isPressed: Bool
}

struct MiNeoBrutalismStateItem: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let systemImage: String
    let fill: Color
}

struct MiNeoBrutalismRuleItem: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let fill: Color
}

enum MiNeoBrutalismDemoContent {
    static let segments = ["slot_tokens", "ds_motion", "nbd_prompt"]
    static let specTabs = ["slot_tokens", "ds_components", "slot_states"]

    static let tokenItems: [MiNeoBrutalismTokenItem] = [
        MiNeoBrutalismTokenItem(title: "nbd_ink", value: "#323232", detail: "nbd_borders_text_hard", color: MiNeoBrutalismTokens.ink),
        MiNeoBrutalismTokenItem(title: "nbd_paper", value: "#FFFDF7", detail: "nbd_main_stage_content", color: MiNeoBrutalismTokens.paper),
        MiNeoBrutalismTokenItem(title: "nbd_blue", value: "#2D8CF0", detail: "nd_blue_role", color: MiNeoBrutalismTokens.blue),
        MiNeoBrutalismTokenItem(title: "nbd_green", value: "#4ECB71", detail: "nd_positive_state", color: MiNeoBrutalismTokens.green),
        MiNeoBrutalismTokenItem(title: "nbd_orange", value: "#FF9F3F", detail: "nbd_step_tab_progress", color: MiNeoBrutalismTokens.orange),
        MiNeoBrutalismTokenItem(title: "nbd_yellow", value: "#FFE66D", detail: "nd_highlight_action", color: MiNeoBrutalismTokens.yellow),
        MiNeoBrutalismTokenItem(title: "nbd_red", value: "#FF6B6B", detail: "nd_error_feedback", color: MiNeoBrutalismTokens.red),
        MiNeoBrutalismTokenItem(title: "nbd_purple", value: "#9F7AEA", detail: "nbd_ai_prompt_creative", color: MiNeoBrutalismTokens.purple)
    ]

    static let shadowItems: [MiNeoBrutalismShadowItem] = [
        MiNeoBrutalismShadowItem(title: "nbd_small", value: "nbd_4pt_x4pt_buttons", shadow: MiNeoBrutalismTokens.shadowSmall, isPressed: false),
        MiNeoBrutalismShadowItem(title: "nbd_medium", value: "nbd_6pt_x6pt_cards", shadow: MiNeoBrutalismTokens.shadowMedium, isPressed: false),
        MiNeoBrutalismShadowItem(title: "nbd_large", value: "nbd_10pt_x10pt_hero", shadow: MiNeoBrutalismTokens.shadowLarge, isPressed: false),
        MiNeoBrutalismShadowItem(title: "nbd_pressed", value: "nd_press_collapse", shadow: .zero, isPressed: true)
    ]

    static let states: [MiNeoBrutalismStateItem] = [
        MiNeoBrutalismStateItem(title: "algc_empty", detail: "nbd_no_match_show", systemImage: "doc.text.magnifyingglass", fill: MiNeoBrutalismTokens.surface),
        MiNeoBrutalismStateItem(title: "algc_loading", detail: "nbd_chunky_blocks_soft", systemImage: "arrow.triangle.2.circlepath", fill: MiNeoBrutalismTokens.blueSoft),
        MiNeoBrutalismStateItem(title: "c_selected", detail: "nbd_pressed_surface_plus", systemImage: "checkmark.seal.fill", fill: MiNeoBrutalismTokens.greenSoft),
        MiNeoBrutalismStateItem(title: "algc_error", detail: "nbd_red_fill_explicit", systemImage: "exclamationmark.triangle.fill", fill: Color(hex: 0xFFE0E0)),
        MiNeoBrutalismStateItem(title: "algc_disabled", detail: "nbd_grey_fill_lower", systemImage: "lock.fill", fill: Color(hex: 0xE0E0E0)),
        MiNeoBrutalismStateItem(title: "nbd_complete", detail: "nbd_green_status_short", systemImage: "flag.checkered", fill: MiNeoBrutalismTokens.greenSoft)
    ]

    static let rules: [MiNeoBrutalismRuleItem] = [
        MiNeoBrutalismRuleItem(title: "nbd_no_soft_glow", detail: "nbd_avoid_blur_shadows", fill: MiNeoBrutalismTokens.red),
        MiNeoBrutalismRuleItem(title: "nbd_press_move", detail: "nd_press_translate", fill: MiNeoBrutalismTokens.yellow),
        MiNeoBrutalismRuleItem(title: "nbd_less_copy_more", detail: "nbd_short_labels_strong", fill: MiNeoBrutalismTokens.green),
        MiNeoBrutalismRuleItem(title: "nbd_mobile_first", detail: "nd_mobile_stack", fill: MiNeoBrutalismTokens.blue)
    ]

    static let acceptance: [String] = [
        "nbd_cards_controls_thick",
        "nd_primary_visible",
        "nd_touch_44",
        "nd_state_controls",
        "nbd_large_dynamic_type",
        "nbd_mira_s_global"
    ]

    static let promptGuidance: [String] = [
        "nbd_neo_brutalism_raw",
        "nbd_specify3pt_black",
        "nbd_ask_press_offset",
        "nbd_avoid_soft_gradients"
    ]
}
