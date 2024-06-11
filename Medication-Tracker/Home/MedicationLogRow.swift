//
//  MedicationLogRow.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 6/10/24.
//

import SwiftUI

struct MedicationLogRow: View {
    @Binding var log: MedicationLog
    
    var body: some View {
        let medication = log.medication ?? Medication()
        
        GroupBox {
            VStack(alignment: .leading, spacing: 6) {
                Text(timeString(log.scheduled))
                    .font(.title2)
                    .bold()

                HStack {
                    Image(systemName: (log.isTaken) ? "checkmark.circle.fill" : "pill.circle.fill")
                        .foregroundStyle((log.isTaken) ? Color.green : Color.black)
                        .font(.largeTitle)
                        .bold()
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(log.medication?.name ?? "Name")
                            Text("(\(medication.strength) \(medication.unit.rawValue))")
                                .foregroundStyle(Color.gray)
                        }
                        
                        Text("Dose 1 pill")
                            .foregroundStyle(Color.gray)
                    }
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            
            Text((log.isTaken) ? "Taken \(dateString(log.takenTimestamp))" : " ")
                .foregroundStyle(.green)
        }
    }
    
    func timeString(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    
    func dateString(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
}

#Preview {
    MedicationLogRow(log: .constant(MedicationLog(taken: true, timestamp: Date.now)))
}
