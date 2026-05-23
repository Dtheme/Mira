# Mira Project Standards / 项目标准

## Purpose

This folder defines Mira's project-level standards for future vibe coding. It is separate from `docs/design-system/`:

- `docs/design-system/` explains design knowledge and style guidance.
- `project-standards/` explains how this specific iOS project should be changed by humans or AI agents.

When implementation starts later, AI agents should read this folder before modifying SwiftUI code, data models, assets, or project settings.

## Standards Index

- `vibe-coding.md`: AI collaboration workflow and implementation discipline.
- `ios-swiftui-baseline.md`: iOS / SwiftUI quality baseline.
- `repository-structure.md`: expected folder boundaries and naming rules.
- `design-demo-standard.md`: required component slots, states, and spatial surfaces for each design style demo.

## Current Project State

Mira has moved beyond the initial SwiftUI + Core Data template for the first app UI pass. Current app work keeps Core Data available but routes the template `ContentView` into the Mira shell:

- `Mira/ContentView.swift` wraps `MiAppRootView`.
- `Mira/App/` contains app shell entry points.
- `Mira/DesignSystem/` contains reusable tokens and modifiers.
- `Mira/Features/` contains screen-level SwiftUI views.
- `Mira/Models/` contains static design style data for the first phase.

Future app work should keep mapping design-system knowledge into product screens through the standards in this folder.

## Project Principles

- Keep app implementation iOS-first and SwiftUI-native.
- Keep AI knowledge docs and app runtime code decoupled.
- Prefer small, reviewable changes with explicit acceptance checks.
- Do not add decorative visual effects unless they improve the selected design style and preserve usability.
- Treat accessibility, Dynamic Type, safe areas, and touch targets as baseline requirements.
- Every implementation-ready style demo must satisfy `design-demo-standard.md`.
