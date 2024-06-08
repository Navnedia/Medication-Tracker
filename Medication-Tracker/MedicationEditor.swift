//
//  MedicationEditor.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 5/20/24.
//

import SwiftUI

struct MedicationEditor: View {
    /// The state model for the medication entry being edited or created.
    @State var medication: Medication
    /// The state model for the medication schedule config being edited or created.
    @State var schedule: ScheduleConfiguration
    /// A callback to handle the toolbar button save logic.
    var onSave: ((Medication, ScheduleConfiguration) -> Void)
    /// A callback to check if the state of the form models have changed. Returns true if the data has changed.
    var didChange: ((Medication, ScheduleConfiguration) -> Bool)
    /// A state environment callback to dismiss the current editor view.
    @Environment(\.dismiss) private var dismiss
    /// A flag state to control if the cancel confirmation alert messagel is being presented.
    @State private var cancelConfirmAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Name")) {
                    TextField("Required", text: $medication.name)
                        .accessibilityLabel("Medication name")
                        .onSubmit { closeKeyboard() }
                }
                
                Section(header: Text("Strength and Unit")) {
                    HStack {
                        TextField("Strength", value: $medication.strength, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .onTapGesture { closeKeyboard() }

                        Picker("Unit", selection: $medication.unit) {
                            ForEach(Unit.allCases, id: \.self) { unit in
                                Text(unit.rawValue).tag(unit)
                            }
                        }.labelsHidden()
                    }
                }
                
                Section(header: Text("Remaining Quantity")) {
                    Stepper(value: $medication.remainingQuantity, in: Medication.quantityRange) {
                        TextField("Quantity", value: $medication.remainingQuantity, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .onTapGesture { closeKeyboard() }
                    }
                    .accessibilityLabel("Remaining Medication Quantity")
                }
                
                Section(header: Text("Reminders")) {
                    Picker("Frequency", selection: $schedule.frequency) {
                        Text("As Needed").tag(ScheduledFrequency.asNeeded)
                        Text("Every Day").tag(ScheduledFrequency.everyDay)
                        Text("On Specific Days").tag(ScheduledFrequency.specificDays)
                    }
                    
                    if (schedule.frequency == .specificDays) {
                        DayPicker(selectedDays: $schedule.days)
                            .selectedTintColor(.darkTeal)
                            .font(.title)
                            .accessibilityLabel("Choose days")
                    }
                }
                
                if (schedule.frequency == .everyDay
                    || schedule.frequency == .specificDays) {
                    Section(header: Text("Times")) {
                        List {
                            ForEach(schedule.times.indices, id: \.self) { index in
                                HStack {
                                    Button(action: {
                                        schedule.times.remove(at: index)
                                    }, label: {
                                        Image(systemName: "minus.circle.fill")
                                            .imageScale(.large)
                                            .foregroundColor(.red)
                                    })
                                    
                                    DatePicker("Reminder Time",
                                               selection: $schedule.times[index],
                                               displayedComponents: [.hourAndMinute]
                                    )
                                }
                            }
                            .onDelete { index in
                                schedule.times.remove(atOffsets: index)
                            }
                            
                            HStack {
                                Button(action: {
                                    schedule.times.append(Date.now)
                                }, label: {
                                    Image(systemName: "plus.circle.fill")
                                        .imageScale(.large)
                                        .foregroundColor(.green)
                                })
                                Text("Add a time")
                            }
                        }
                    }
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $medication.note)
                        .accessibilityLabel("Medication Notes")
                        .frame(minHeight: 200, maxHeight: 350)
                        .onTapGesture { closeKeyboard() }
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        if (didChange(medication, schedule)) {
                            // Changes were made on the form: show alert to confirm discarding unsaved changes.
                            cancelConfirmAlert = true
                        } else {
                            // No changes made, so we can safely close the editor panel.
                             dismiss()
                        }
                    }
                    .alert("Unsaved Content",
                       isPresented: $cancelConfirmAlert,
                       actions: {
                            Button("Discard Changes", role: .destructive) {
                                // Confirmed discarding unsaved changes. Close editor panel.
                                dismiss()
                            }
                    
                            Button("Keep Editing", role: .cancel, action: {})
                        }, message: {
                            Text("You have unsaved changes. Are you sure you want to discard them?")
                        }
                    )
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        // Run the save callback action and close the editing panel.
                        onSave(medication, schedule)
                        dismiss()
                    }
                    .disabled(medication.name.isEmpty) // Don't allow save without the required medication name.
                }
            }
        }
    }
    
    func closeKeyboard() {
        UIApplication.shared
            .sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


#Preview {
    MedicationEditor(
        medication: MedicationStore.sampleData[0],
        schedule: MedicationStore.sampleData[0].schedule,
        onSave: { _, _ in },
        didChange: { _,_  in return false }
    )
}
