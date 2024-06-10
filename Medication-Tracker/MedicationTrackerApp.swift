//
//  MedicationTrackerApp.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 5/24/24.
//

import SwiftUI

@main
struct MedicationTrackerApp: App {
    @State private var store = MedicationStore.shared
    /// An envirornment state to monitor application scene phase.
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView(logsForDay: $store.filteredLogs)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                
                MedicationsListView(medications: $store.medications)
                    .tabItem {
                        Label("Medications", systemImage: "pill.fill")
                    }
            }
            
            .task {
                // On application load: run an async task to load in data from file.
                await store.load()
            }
        }
        
        .onChange(of: scenePhase) {
            // When the application becomes inactive/closes: run an async task to save data to file.
            if scenePhase == .inactive {
                Task {
                    await store.save()
                }
            }
        }
    }
}
