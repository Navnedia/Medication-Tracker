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
    @State private var notificationsManager = NotificationsManager.shared
    /// An envirornment state to monitor application scene phase.
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var selectedTab = 0
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                HomeView(logsForDay: $store.filteredLogs)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(0)
                
                MedicationsListView(medications: $store.medications)
                    .tabItem {
                        Label("Medications", systemImage: "pill.fill")
                    }
                    .tag(1)
            }
            
            .task {
                // On application load: run an async task to load in data from file.
                await store.load()
                // Change to the medications tab if there is no medication data on launch.
                if (store.medications.isEmpty) {
                    selectedTab = 1
                }
                // Request permission from the user to send reminder notifications for scheduled medications.
                await notificationsManager.requestAuth()
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
