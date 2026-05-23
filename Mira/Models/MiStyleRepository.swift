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
        acidGraphic,
        glassmorphism,
        neumorphism,
        neoBrutalism
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

    static let acidGraphic = MiDesignStyle(
        id: "acid-graphic",
        name: "style_acid",
        localizedName: "style_acid_native",
        slug: "acid-graphic",
        category: .experimentalVisual,
        summary: "st_high_expr",
        description: "st_backlog",
        designDocumentPath: "docs/design-system/styles/acid-graphic/Design.md",
        screenshotAssetName: nil,
        accentHex: 0xC7F464,
        visualTokens: [],
        sections: [placeholderSection(for: "style_acid")],
        demoSlots: standardDemoSlots,
        isImplementationReady: false
    )

    static let glassmorphism = MiDesignStyle(
        id: "glassmorphism",
        name: "style_glass",
        localizedName: "style_glass_native",
        slug: "glassmorphism",
        category: .materialSurface,
        summary: "st_glass_layers",
        description: "st_glass_backlog",
        designDocumentPath: "docs/design-system/styles/glassmorphism/Design.md",
        screenshotAssetName: nil,
        accentHex: 0x00C7BE,
        visualTokens: [],
        sections: [placeholderSection(for: "style_glass")],
        demoSlots: standardDemoSlots,
        isImplementationReady: false
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
