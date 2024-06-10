//
//  MedicationsListView.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 5/19/24.
//

import SwiftUI

struct MedicationsListView: View {
    /// The state model array of medication entries.
    @Binding var medications: [Medication]
    /// A flag state to control if the medication adding panel is being presented.
    @State private var AddPanelVisible: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach($medications) { $med in
                        NavigationLink(destination: MedicationDetailView(medication: $med)) {
                            MedicationListRow(medication: $med)
                        }
                    }
                    .onMove { from, to in
                        medications.move(fromOffsets: from, toOffset: to)
                    }
                    .onDelete { indexes in
                        for i in indexes {
                            NotificationsManager.shared.removeScheduledReminders(
                                for: medications[i].id.uuidString)
                        }
                        medications.remove(atOffsets: indexes)
                    }
                    
                }
                .navigationTitle("Medications")
                .toolbarBackground(Color(.blue).opacity(0.2), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .listStyle(.plain)
                .toolbar {
                    EditButton()
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            AddPanelVisible = true // Trigger presenting add menu.
                        }, label: {
                            Image(systemName: "plus")
                                .font(Font.title.weight(.semibold))
                                .frame(width: 40, height: 40)
                        })
                        .buttonStyle(.borderedProminent)
                        .tint(.darkTeal)
                        .clipShape(Circle())
                    }
                }.padding()
            }
        }
        
        .fullScreenCover(isPresented: $AddPanelVisible) {
            // Show editor using blank state models:
            MedicationEditor(medication: Medication(), schedule: ScheduleConfiguration(),
                onSave: { medication, schedule in
                    // Append the new medication into the list.
                    medication.schedule = schedule
                    medications.append(medication)
                
                    Task {
                        await NotificationsManager.shared.addScheduledReminders(for: medication)
                    }
                }, didChange: { medication, schedule in
                    // Determine if changes have been made from a blank medication object state.
                    return medication != Medication() || schedule != ScheduleConfiguration()
                }
            )
        }
    }
}


#Preview {
    MedicationsListView(medications: .constant(MedicationStore.sampleData))
}
