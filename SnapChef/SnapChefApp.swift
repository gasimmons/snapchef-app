//
//  SnapChefApp.swift
//  SnapChef
//
//  Created by Gavin Simmons on 8/17/24.
//

import SwiftUI
import SwiftData

@main
struct SnapChefApp: App {
    @State private var userId: Int? = nil
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            AuthView()
        }
    }
}
