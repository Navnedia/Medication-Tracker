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
    
    var body: some View {
        VStack {
            DatePicker("Date", selection: $date, in: dateRange, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .id(date)
            
                .onChange(of: date) {
                    triggerFilterUpdate()
                }
            
            List {
                ForEach($logsForDay) { $log in
                    VStack {
                        Text($log.wrappedValue.medication?.name ?? "Name")
                        Text(dateFormatted($log.wrappedValue.scheduled))
                        
                        Toggle(isOn: $log.isTaken) {
                            Text("")
                        }
                    }
                }
            }
            .listStyle(.plain)
            
            Spacer()
        }
        .padding()
//        .frame(maxHeight: .infinity, alignment: .top)
        
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
