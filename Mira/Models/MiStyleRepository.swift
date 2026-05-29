//
//  MiStyleRepository.swift
//  Mira
//
//  Created on 2026/5/22.
//

import Foundation

enum MiStyleRepository {
    static let styles: [MiDesignStyle] = [
        appleLiquidGlass,
        glassmorphism,
        neumorphism,
        claymorphism,
        neoBrutalism,
        minimalism,
        material3
    ]

    static func style(id: String) -> MiDesignStyle? {
        styles.first { $0.id == id }
    }
}

private extension MiStyleRepository {
    static let appleLiquidGlass = MiDesignStyle(
        id: "apple-liquid-glass",
        name: "style_alg",
        localizedName: "style_alg_native",
        slug: "apple-liquid-glass",
        category: .materialSurface,
        summary: "st_alg_float",
        description: "st_alg_shell",
        designDocumentPath: "docs/design-system/styles/apple-liquid-glass/Design.md",
        screenshotAssetName: nil,
        accentHex: 0x0A84FF,
        visualTokens: [
            MiTokenSpec(name: "mi-obsidian-950", value: "#05070D", role: "algt_primary_dark_app"),
            MiTokenSpec(name: "mi-frost-050", value: "#F7FBFF", role: "at_glass_readable"),
            MiTokenSpec(name: "mi-apple-blue-500", value: "#0A84FF", role: "at_primary_selected"),
            MiTokenSpec(name: "mi-aqua-400", value: "#00C7BE", role: "at_liquid_accent"),
            MiTokenSpec(name: "mi-iris-500", value: "#7C3AED", role: "algt_ai_creative_accent")
        ],
        sections: [
            MiStyleDetailSection(
                title: "ds_identity",
                summary: "ds_liquid_glass_creates",
                bullets: [
                    "ds_liquid_glass_shell",
                    "ds_keep_content",
                    "ds_style_feel_apple"
                ]
            ),
            MiStyleDetailSection(
                title: "ds_layout",
                summary: "ds_shell_content",
                bullets: [
                    "ds_let_style_content",
                    "ds_avoid_applying_glass",
                    "ds_center_focus_scale"
                ]
            ),
            MiStyleDetailSection(
                title: "ds_components",
                summary: "ds_glass_emphasizes",
                bullets: [
                    "ds_glass_capsules_search",
                    "ds_round_cards",
                    "ds_scrims_readable_glass"
                ]
            ),
            MiStyleDetailSection(
                title: "ds_motion",
                summary: "ds_motion_make_spatial",
                bullets: [
                    "ds_short_motion",
                    "ds_avoid_animating_large",
                    "ds_reduce_motion"
                ]
            ),
            MiStyleDetailSection(
                title: "ds_accessibility",
                summary: "ds_glass_never_replaces",
                bullets: [
                    "ds_voice_reads_style",
                    "ds_glass_touch",
                    "ds_text_glass_contrast"
                ]
            ),
            MiStyleDetailSection(
                title: "ds_prompt",
                summary: "ds_style_mira_shell",
                bullets: [
                    "ds_mention_shell_layer",
                    "ds_include_token_layout",
                    "ds_call_out_anti"
                ]
            ),
            MiStyleDetailSection(
                title: "ds_acceptance",
                summary: "ds_ready_checks",
                bullets: [
                    "ds_home_shell_visibly",
                    "ds_content_read",
                    "ds_style_expr",
                    "ds_reduced_motion_voice"
                ]
            )
        ],
        demoSlots: MiStyleRepository.standardDemoSlots,
        isImplementationReady: true
    )

    static let glassmorphism = MiDesignStyle(
        id: MiGlassmorphismModule.styleID,
        name: "style_glass",
        localizedName: "style_glass_native",
        slug: "glassmorphism",
        category: .materialSurface,
        summary: "st_glass_layers",
        description: "st_glass_desc",
        designDocumentPath: MiGlassmorphismModule.designDocumentPath,
        screenshotAssetName: nil,
        accentHex: 0x00C7BE,
        visualTokens: [
            MiTokenSpec(name: "mi-glass-cyan", value: "#62E6F2", role: "glass_token_cyan"),
            MiTokenSpec(name: "mi-glass-blue", value: "#6EA8FF", role: "glass_token_blue"),
            MiTokenSpec(name: "mi-glass-violet", value: "#B8A2FF", role: "glass_token_violet"),
            MiTokenSpec(name: "mi-glass-surface", value: "white 54%", role: "glass_token_surface")
        ],
        sections: [
            MiStyleDetailSection(title: "ds_identity", summary: "st_glass_desc", bullets: ["glass_prompt_1", "glass_prompt_2", "glass_prompt_3"]),
            MiStyleDetailSection(title: "ds_components", summary: "glass_components_body", bullets: ["glass_check_1", "glass_check_2"])
        ],
        demoSlots: standardDemoSlots,
        isImplementationReady: MiGlassmorphismModule.isImplemented
    )

    static let neumorphism = MiDesignStyle(
        id: MiNeumorphismModule.styleID,
        name: "style_neu",
        localizedName: "style_neu_native",
        slug: "neumorphism",
        category: .materialSurface,
        summary: "st_neu_soft",
        description: "st_neu_desc",
        designDocumentPath: MiNeumorphismModule.designDocumentPath,
        screenshotAssetName: nil,
        accentHex: 0x8FA6C8,
        visualTokens: [
            MiTokenSpec(name: "mi-neu-base", value: "#E8E8E8", role: "neu_base_surface"),
            MiTokenSpec(name: "mi-neu-shadow-dark", value: "#C5C5C5", role: "neu_shadow_dark"),
            MiTokenSpec(name: "mi-neu-shadow-light", value: "#FFFFFF", role: "neu_shadow_light"),
            MiTokenSpec(name: "mi-neu-ink", value: "#343A40", role: "neu_ink_text")
        ],
        sections: [
            MiStyleDetailSection(
                title: "ds_identity",
                summary: "st_neu_desc",
                bullets: [
                    "neu_surface_body",
                    "neu_component_body",
                    "neu_form_body"
                ]
            ),
            MiStyleDetailSection(
                title: "ds_components",
                summary: "neu_component_body",
                bullets: [
                    "neu_prompt_1",
                    "neu_prompt_2",
                    "neu_prompt_3"
                ]
            ),
            MiStyleDetailSection(
                title: "ds_acceptance",
                summary: "neu_prompt_body",
                bullets: [
                    "neu_check_1",
                    "neu_check_2",
                    "neu_check_3",
                    "neu_check_4"
                ]
            )
        ],
        demoSlots: standardDemoSlots,
        isImplementationReady: MiNeumorphismModule.isImplemented
    )

    static let claymorphism = MiDesignStyle(
        id: MiClaymorphismModule.styleID,
        name: "style_clay",
        localizedName: "style_clay_native",
        slug: "claymorphism",
        category: .materialSurface,
        summary: "st_clay_summary",
        description: "st_clay_desc",
        designDocumentPath: MiClaymorphismModule.designDocumentPath,
        screenshotAssetName: nil,
        accentHex: 0xFFB08A,
        visualTokens: [
            MiTokenSpec(name: "mi-clay-peach", value: "#FFB08A", role: "clay_token_peach"),
            MiTokenSpec(name: "mi-clay-lilac", value: "#C9B7FF", role: "clay_token_lilac"),
            MiTokenSpec(name: "mi-clay-mint", value: "#A9E8D0", role: "clay_token_mint"),
            MiTokenSpec(name: "mi-clay-sky", value: "#A8D8FF", role: "clay_token_sky"),
            MiTokenSpec(name: "mi-clay-butter", value: "#FFE29A", role: "clay_token_butter"),
            MiTokenSpec(name: "mi-clay-shadow", value: "#D09C8D", role: "clay_token_shadow")
        ],
        sections: [
            MiStyleDetailSection(title: "ds_identity", summary: "st_clay_desc", bullets: ["clay_prompt_1", "clay_prompt_2", "clay_prompt_3"]),
            MiStyleDetailSection(title: "ds_components", summary: "clay_components_body", bullets: ["clay_card_rule_one_body", "clay_card_rule_two_body"]),
            MiStyleDetailSection(title: "ds_acceptance", summary: "clay_token_prompt_body", bullets: ["clay_check_1", "clay_check_2"])
        ],
        demoSlots: standardDemoSlots,
        isImplementationReady: MiClaymorphismModule.isImplemented
    )

    static let neoBrutalism = MiDesignStyle(
        id: "neo-brutalism",
        name: "style_nb",
        localizedName: "style_nb_native",
        slug: "neo-brutalism",
        category: .antiDesignStructural,
        summary: "st_nb_borders",
        description: "st_ready_ios",
        designDocumentPath: "docs/design-system/styles/neo-brutalism/Design.md",
        screenshotAssetName: nil,
        accentHex: 0xFFE66D,
        visualTokens: [
            MiTokenSpec(name: "mi-nb-ink", value: "#323232", role: "nbd_text_border_hard"),
            MiTokenSpec(name: "mi-nb-paper", value: "#FFFDF7", role: "nbd_main_detail_page"),
            MiTokenSpec(name: "mi-nb-paper-blue", value: "#DFF2FF", role: "nd_grid_background"),
            MiTokenSpec(name: "mi-nb-blue", value: "#2D8CF0", role: "nd_primary_selected"),
            MiTokenSpec(name: "mi-nb-green", value: "#4ECB71", role: "nd_success_state"),
            MiTokenSpec(name: "mi-nb-orange", value: "#FF9F3F", role: "nd_orange_role"),
            MiTokenSpec(name: "mi-nb-yellow", value: "#FFE66D", role: "nd_highlight_action"),
            MiTokenSpec(name: "mi-nb-red", value: "#FF6B6B", role: "nd_error_action")
        ],
        sections: [
            MiStyleDetailSection(
                title: "ds_identity",
                summary: "ds_neo_brutalism_makes",
                bullets: [
                    "ds_thick_black_borders",
                    "ds_flat_saturated_fills",
                    "ds_keep_labels_short"
                ]
            ),
            MiStyleDetailSection(
                title: "ds_layout",
                summary: "ds_favor_chunky_modular",
                bullets: [
                    "ds_stack_dense_three",
                    "ds_make_central_task",
                    "ds_leave_enough_spacing"
                ]
            ),
            MiStyleDetailSection(
                title: "ds_components",
                summary: "ds_controls_touch",
                bullets: [
                    "ds_buttons_cards_tags",
                    "ds_pressed_controls_move",
                    "ds_states_explicit"
                ]
            ),
            MiStyleDetailSection(
                title: "ds_motion",
                summary: "ds_motion_physical",
                bullets: [
                    "ds_short_press_offsets",
                    "ds_avoid_elastic_glass",
                    "ds_reduce_shadow"
                ]
            ),
            MiStyleDetailSection(
                title: "ds_accessibility",
                summary: "ds_high_contrast_does",
                bullets: [
                    "ds_touch_targets_at",
                    "ds_large_dynamic_type",
                    "ds_voice_labels_describe"
                ]
            ),
            MiStyleDetailSection(
                title: "ds_acceptance",
                summary: "ds_module_ready_feels",
                bullets: [
                    "ds_no_liquid_glass",
                    "ds_hard_shadows_thick",
                    "ds_core_components_form"
                ]
            )
        ],
        demoSlots: standardDemoSlots,
        isImplementationReady: true
    )

    static let minimalism = MiDesignStyle(
        id: MiMinimalismModule.styleID,
        name: "style_min",
        localizedName: "style_min_native",
        slug: "minimalism",
        category: .minimalSystematic,
        summary: "st_min_summary",
        description: "st_min_desc",
        designDocumentPath: MiMinimalismModule.designDocumentPath,
        screenshotAssetName: nil,
        accentHex: 0x111111,
        visualTokens: [
            MiTokenSpec(name: "mi-min-paper", value: "#FCFCFA", role: "min_token_paper"),
            MiTokenSpec(name: "mi-min-ink", value: "#111111", role: "min_token_ink"),
            MiTokenSpec(name: "mi-min-hairline", value: "#D9D9D4", role: "min_token_hairline"),
            MiTokenSpec(name: "mi-min-accent", value: "#0A84FF", role: "min_token_accent")
        ],
        sections: [
            MiStyleDetailSection(title: "ds_identity", summary: "st_min_desc", bullets: ["min_prompt_1", "min_prompt_2", "min_prompt_3"]),
            MiStyleDetailSection(title: "ds_acceptance", summary: "min_prompt_body", bullets: ["min_check_1", "min_check_2"])
        ],
        demoSlots: standardDemoSlots,
        isImplementationReady: MiMinimalismModule.isImplemented
    )

    static let material3 = MiDesignStyle(
        id: MiMaterial3Module.styleID,
        name: "style_m3",
        localizedName: "style_m3_native",
        slug: "material-3",
        category: .systemFramework,
        summary: "st_m3_summary",
        description: "st_m3_desc",
        designDocumentPath: MiMaterial3Module.designDocumentPath,
        screenshotAssetName: nil,
        accentHex: 0x6750A4,
        visualTokens: [
            MiTokenSpec(name: "mi-m3-primary", value: "#6750A4", role: "m3_token_primary"),
            MiTokenSpec(name: "mi-m3-primary-container", value: "#EADDFF", role: "m3_token_primary_container"),
            MiTokenSpec(name: "mi-m3-secondary-container", value: "#E8DEF8", role: "m3_token_secondary_container"),
            MiTokenSpec(name: "mi-m3-tertiary-container", value: "#FFD8E4", role: "m3_token_tertiary_container"),
            MiTokenSpec(name: "mi-m3-surface-container", value: "#F3EDF7", role: "m3_token_surface_container"),
            MiTokenSpec(name: "mi-m3-outline-variant", value: "#CAC4D0", role: "m3_token_outline_variant")
        ],
        sections: [
            MiStyleDetailSection(title: "ds_identity", summary: "st_m3_desc", bullets: ["m3_prompt_1", "m3_prompt_2", "m3_prompt_3"]),
            MiStyleDetailSection(title: "ds_acceptance", summary: "m3_prompt_body", bullets: ["m3_check_1", "m3_check_2"])
        ],
        demoSlots: standardDemoSlots,
        isImplementationReady: MiMaterial3Module.isImplemented
    )

    static let standardDemoSlots: [MiDemoSlot] = [
        MiDemoSlot(title: "slot_hero", description: "sl_hero_sig", systemImage: "sparkles"),
        MiDemoSlot(title: "slot_card", description: "sl_home_card", systemImage: "rectangle.roundedtop"),
        MiDemoSlot(title: "slot_surface", description: "sl_surface_depth", systemImage: "square.stack.3d.up"),
        MiDemoSlot(title: "slot_button", description: "slot_primary_secondary", systemImage: "button.programmable"),
        MiDemoSlot(title: "slot_search", description: "slot_text_entry_search", systemImage: "magnifyingglass"),
        MiDemoSlot(title: "slot_filter", description: "sl_filter_chips", systemImage: "line.3.horizontal.decrease.circle"),
        MiDemoSlot(title: "slot_nav", description: "sl_tabs_segments", systemImage: "rectangle.split.3x1"),
        MiDemoSlot(title: "slot_sheet", description: "sl_sheet_prompt", systemImage: "sidebar.trailing"),
        MiDemoSlot(title: "slot_states", description: "slot_empty_loading_error", systemImage: "exclamationmark.triangle"),
        MiDemoSlot(title: "ds_motion", description: "sl_press_motion", systemImage: "waveform.path"),
        MiDemoSlot(title: "ds_accessibility", description: "slot_voice_dynamic_type", systemImage: "accessibility"),
        MiDemoSlot(title: "slot_tokens", description: "sl_token_system", systemImage: "swatchpalette"),
        MiDemoSlot(title: "ds_prompt", description: "slot_ai_usage_phrases", systemImage: "text.bubble")
    ]

    static func placeholderSection(for styleName: String) -> MiStyleDetailSection {
        MiStyleDetailSection(
            title: "ph_design_md",
            summary: MiL10n.format("ph_registered_fmt", MiL10n.text(styleName)),
            bullets: [
                "ph_create_design",
                "ph_future_doc",
                "ph_mira_display_entry"
            ]
        )
    }
}
