//
//  MedicationTrackerApp.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 5/24/24.
//

import SwiftUI

@main
struct MedicationTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                MedicationsListView(medications: MedicationStore.shared.medications)
                    .tabItem {
                        Label("Medications", systemImage: "pill.fill")
                    }
            }
        }
    }
}
