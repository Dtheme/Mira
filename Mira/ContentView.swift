//
//  ContentView.swift
//  Mira
//
//  Created by dzw on 2026/5/22.
//

import SwiftUI

struct ContentView: View {
    @State private var isLaunching = true

    var body: some View {
        ZStack {
            if isLaunching {
                MiLaunchView {
                    withAnimation(.easeInOut(duration: 0.42)) {
                        isLaunching = false
                    }
                }
                .transition(.opacity)
                .zIndex(10)
            } else {
                MiAppRootView()
                    .transition(.opacity)
                    .zIndex(0)
            }
        }
    }
}

#Preview {
    ContentView()
}
