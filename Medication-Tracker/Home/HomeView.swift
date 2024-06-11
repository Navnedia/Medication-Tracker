//
//  HomeView.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 6/8/24.
//

import SwiftUI

struct HomeView: View {
    @Binding var logsForDay: [MedicationLog]
    
    @State var date: Date = Date.now
    let dateRange: ClosedRange<Date> = {
        let start = Calendar.current.date(byAdding: .day, value: -31, to: Date.now)
        return start! ... Date.now
    }()
    
    @State private var logConfirmAlert: Bool = false
    @State private var selectedLog: MedicationLog?
    
    var body: some View {
        VStack {
            Group {
                DatePicker("Medications for", selection: $date, in: dateRange, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .bold()
                    .id(date)
                
                    .onChange(of: date) {
                        triggerFilterUpdate()
                    }
            }
            .padding()
            .background(Color.blue.opacity(0.2).ignoresSafeArea(edges: .all))
            
            if (!$logsForDay.isEmpty) {
                List {
                    ForEach($logsForDay) { $log in
                        MedicationLogRow(log: $log)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                selectedLog = log
                                logConfirmAlert = true
                            }
                    }
                }
                .listStyle(.plain)
            } else {
                Spacer()
                Text("Nothing here to see")
                    .bold()
            }
            
            Spacer()
        }
        
        .confirmationDialog("Update Log", isPresented: $logConfirmAlert, presenting: selectedLog) { log in
            if (log.isTaken == false) {
                Button("Mark as Taken") {
                    log.takenTimestamp = Date.now
                    log.isTaken = true
                    
                    if let medication = log.medication {
                        medication.remainingQuantity = medication.remainingQuantity - 1
                    }
                }
            } else {
                Button("Mark not Taken") {
                    log.takenTimestamp = nil
                    log.isTaken = false
                    
                    if let medication = log.medication {
                        medication.remainingQuantity = medication.remainingQuantity + 1
                    }
                }
            }
        
            Button("Cancel", role: .cancel, action: {})
        }
        .sensoryFeedback(.success, trigger: logConfirmAlert)
        
        .task {
            triggerFilterUpdate()
        }
    }
    
    func triggerFilterUpdate() {
        Task {
            await MedicationStore.shared.filterLogs(by: date)
        }
    }
    
    func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
}

#Preview {
    HomeView(logsForDay: .constant(MedicationStore.sampleData[0].logs))
}
