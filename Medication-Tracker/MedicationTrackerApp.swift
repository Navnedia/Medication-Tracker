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
            MedicationsListView(medications: Medication.sampleData)
        }
    }
}
