//
//  AgeCareApp.swift
//  AgeCare
//
//  Created by Felix Weißleder on 21.11.25.
//

import SwiftUI
import SwiftData

@main
struct AgeCareApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            Contact.self,
            Appointment.self
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
            OnboardingView()
        }
        .modelContainer(sharedModelContainer)
    }
}
