//
//  MedicationDetailView.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 5/20/24.
//

import SwiftUI

struct MedicationDetailView: View {
    /// The state model for the selected medication entry.
    @Binding var medication: Medication
    /// A flag state to control if the medication editing panel is being presented.
    @State private var editPanelVisible: Bool = false
    
    @State private var logConfirmAlert: Bool = false
    
    var body: some View {
        VStack {
            Text(medication.name)
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 6)
            
            Text("\(medication.strength) \(medication.unit.rawValue)")
            HStack {
                Text("Remaining Quantity: ")
                    .bold()
                Text("\(medication.remainingQuantity)")
            }

            Divider()
                .frame(height: 2)
                .overlay(.text)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            
            Spacer()
        }
        .frame(height: 108)
        .background(Color(.blue).opacity(0.2))
        
        ScrollView {
//            VStack {
                VStack(spacing: 6) {
                    GroupBox {
                        VStack(spacing: 6) {
                            Text("Schedule")
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            if (medication.schedule.frequency == .specificDays) {
                                HStack {
                                    ForEach(medication.schedule.days, id: \.self) { day in
                                        Text(day.shortName)
                                    }
                                    Spacer()
                                }
                            } else {
                                Text(medication.schedule.frequency.title)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            if (medication.schedule.frequency != .asNeeded) {
                                HStack {
                                    ForEach(medication.schedule.times, id: \.self) { date in
                                        Text(date, format: .dateTime.hour().minute())
                                    }
                                    Spacer()
                                }
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    GroupBox {
                        Text("Notes")
                            .bold()
                            .padding(.bottom, 6)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(medication.note)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }.padding()
                
                Spacer()
//            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        editPanelVisible = true // Trigger presenting edit panel.
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        logConfirmAlert = true
                    }, label: {
                        Image(systemName: "pill.circle.fill")
                        Text("Log Dose")
                    })
                    .buttonStyle(.bordered)
                    .font(.title2)
                }
            }
            .toolbar(.hidden, for: .tabBar)
        }
        
        .fullScreenCover(isPresented: $editPanelVisible) {
            // Show editor with using copies of current state:
            MedicationEditor(medication: medication.copy(), schedule: medication.schedule,
                onSave: { editedMedication, editedSchedule in
                    // Copy over saved changes to the stored medication entry.
                    editedMedication.schedule = editedSchedule
                    medication = editedMedication
                    medication.schedule.updated = Date.now
                
                    Task {
                        await NotificationsManager.shared.refreshScheduledReminders(for: medication)
                    }
                }, didChange: { editingMedication, editingSchedule in
                    // Determine if changes have been made from the original medication object state.
                    return editingMedication != medication || editingSchedule != medication.schedule
                }
            )
        }
        
        .confirmationDialog("Add Dose", isPresented: $logConfirmAlert,
            actions: {
                Button("Log Dose Taken") {
                    let log = MedicationLog(
                        medication: medication,
                        scheduled: Date.now,
                        taken: true,
                        timestamp: Date.now
                    )
                    
                    medication.logs.append(log)
                    medication.remainingQuantity = medication.remainingQuantity - 1
                }
            
                Button("Cancel", role: .cancel, action: {})
            }, message: {
                Text("Would you like to log a dose of \(medication.name) (\(medication.strength) \(medication.unit.rawValue)) for right now?")
            }
        )
    }
}


#Preview {
    MedicationDetailView(medication: .constant(MedicationStore.sampleData[0]))
}
