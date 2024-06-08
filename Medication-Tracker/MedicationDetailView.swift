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
    
    var body: some View {
//        ScrollView {
            VStack {
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
                
                VStack {
                    Text("Notes")
                        .bold()
                        .padding(.bottom, 6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(medication.note)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.padding()
                
                Spacer()
            }
            .toolbar {
                Button("Edit") {
                    editPanelVisible = true // Trigger presenting edit panel.
                }
            }
//        }
        
        .fullScreenCover(isPresented: $editPanelVisible) {
            // Show editor with using copies of current state:
            MedicationEditor(medication: medication.copy(), schedule: medication.schedule,
                onSave: { editedMedication, editedSchedule in
                    // Copy over saved changes to the stored medication entry.
                    editedMedication.schedule = editedSchedule
                    medication = editedMedication
                }, didChange: { editingMedication, editingSchedule in
                    // Determine if changes have been made from the original medication object state.
                    return editingMedication != medication || editingSchedule != medication.schedule
                }
            )
        }
    }
}


#Preview {
    MedicationDetailView(medication: .constant(MedicationStore.sampleData[0]))
}
