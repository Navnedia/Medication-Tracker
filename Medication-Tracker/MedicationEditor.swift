//
//  MedicationEditor.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 5/20/24.
//

import SwiftUI

struct MedicationEditor: View {
    /// The state model for the medication entry being edited.
    @Binding var medication: Medication
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Required", text: $medication.name)
                    .accessibilityLabel("Medication name")
                    .onSubmit { closeKeyboard() }
            }
            
            Section(header: Text("Remaining Quantity")) {
                Stepper(value: $medication.remainingQuantity, in: Medication.quantityRange) {
                    TextField("Quantity", value: $medication.remainingQuantity, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .onTapGesture { closeKeyboard() }
                }
                .accessibilityLabel("Remaining Medication Quantity")
            }
            
            Section(header: Text("Notes")) {
                TextEditor(text: $medication.note)
                    .accessibilityLabel("Medication Notes")
                    .frame(minHeight: 200, maxHeight: 350)
                    .onTapGesture { closeKeyboard() }
            }
        }
    }
    
    func closeKeyboard() {
        UIApplication.shared
            .sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


#Preview {
    MedicationEditor(medication: .constant(Medication.sampleData[0]))
}
