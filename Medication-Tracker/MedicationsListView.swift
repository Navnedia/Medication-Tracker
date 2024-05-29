//
//  MedicationsListView.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 5/19/24.
//

import SwiftUI

struct MedicationsListView: View {
    /// The state model array of medication entries.
    @State var medications: [Medication]
    
    /// A flag state to control if the list table should filter out completed entries.
//    @State private var hideCompleted: Bool = false
    
    /// A seperate blank medication object for storing the new medication entry state until it's been saved.
    @State private var newMedication: Medication = Medication()
    /// A flag state to control if the medication adding panel is being presented.
    @State private var AddPanelVisible: Bool = false
    /// A flag state to control if the medication cancel adding alert is being presented.
    @State private var cancelAddAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach($medications) { $med in
//                        if (!hideCompleted || !med.completed) {
                            NavigationLink(destination: MedicationDetailView(medication: $med)) {
                                MedicationListRow(medication: $med)
                            }
//                        }
                    }
                    .onMove { from, to in
                        medications.move(fromOffsets: from, toOffset: to)
                    }
                    .onDelete { index in
                        medications.remove(atOffsets: index)
                    }
                    
                }
                .navigationTitle("Medications")
                .toolbarBackground(Color(.blue).opacity(0.2), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .listStyle(.plain)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        EditButton()
                    }
//                    ToolbarItem(placement: .bottomBar) {
//                        Toggle("Hide completed", isOn: $hideCompleted)
//                            .toggleStyle(.switch)
//                            .tint(.text)
//                            .frame(width: 200)
//                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            // Trigger presenting add menu.
                            newMedication = Medication()
                            AddPanelVisible = true
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
            NavigationStack {
                MedicationEditor(medication: $newMedication)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Cancel") {
                                if (newMedication != Medication()) {
                                    // Changes were made in form: show alert to confirm discarding entry.
                                    cancelAddAlert = true
                                } else {
                                    // No changes made, so we can safely close the adding panel.
                                    AddPanelVisible = false
                                }
                            }
                            .alert("Unsaved Content",
                                   isPresented: $cancelAddAlert,
                                   actions: {
                                        Button("Discard", role: .destructive) {
                                            // Confirmed discarding unsaved medication entry. Close adding panel.
                                            AddPanelVisible = false
                                        }
                                
                                        Button("Keep Editing", role: .cancel, action: {})
                                    }, message: {
                                        Text("You have unsaved content. Are you sure you want to discard this medication entry?")
                                    }
                            )
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Save") {
                                // Close the adding panel and append the new medication into the list.
                                AddPanelVisible = false
                                medications.append(newMedication)
                            }
                            .disabled(newMedication.name.isEmpty) // Don't allow save without the required medication name.
                        }
                    }
            }
        }
    }
}


#Preview {
    MedicationsListView(medications: Medication.sampleData)
}
