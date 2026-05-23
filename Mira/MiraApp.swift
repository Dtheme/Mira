//
//  MiraApp.swift
//  Mira
//
//  Created by dzw on 2026/5/22.
//

import SwiftUI
import CoreData

@main
struct MiraApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
