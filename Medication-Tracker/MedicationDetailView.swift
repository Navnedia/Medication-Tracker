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
    
    /// A seperate blank medication object for storing editing state until changes have been saved.
    @State private var editingMed: Medication = Medication()
    /// A flag state to control if the medication editing panel is being presented.
    @State private var editPanelVisible: Bool = false
    /// A flag state to control if the medication cancel editing alert is being presented.
    @State private var cancelEditAlert: Bool = false
    
    var body: some View {
//        ScrollView {
            VStack {
                VStack {
                    Text(medication.name)
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 6)
                    HStack {
                        Text("Remaining Quantity: ")
                            .bold()
                        Text("\(medication.remainingQuantity)")
                    }
                    Divider()
                        .frame(height: 2)
                        .overlay(.text)
                        .padding()
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
                    editingMed = medication
                    editPanelVisible = true
                }
            }
//        }
        
        .fullScreenCover(isPresented: $editPanelVisible) {
            NavigationStack {
                MedicationEditor(medication: $editingMed)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Cancel") {
                                if (editingMed != medication) {
                                    // Changes were made: show alert to confirm discarding changes.
                                    cancelEditAlert = true
                                } else {
                                    // No changes made, so we can safely close the editor panel.
                                    editPanelVisible = false
                                }
                            }
                            .alert("Unsaved Changes",
                                   isPresented: $cancelEditAlert,
                                   actions: {
                                        Button("Discard Changes", role: .destructive) {
                                            // Confirmed discarding unsaved changes. Close editing panel.
                                            editPanelVisible = false
                                        }
                                
                                        Button("Keep Editing", role: .cancel, action: {})
                                    }, message: {
                                        Text("You have unsaved changes. Are you sure you want to discard them?")
                                    }
                            )
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Save") {
                                // Close the editor panel and copy over saved changes to the stored medication entry.
                                editPanelVisible = false
                                medication = editingMed
                            }
                            .disabled(editingMed.name.isEmpty) // Don't allow save without the required medication name.
                        }
                    }
            }
        }
    }
}


#Preview {
    MedicationDetailView(medication: .constant(Medication.sampleData[0]))
}
