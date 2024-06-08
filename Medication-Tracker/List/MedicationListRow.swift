//
//  MedicationListRow.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 5/19/24.
//

import SwiftUI

struct MedicationListRow: View {
    @Binding var medication: Medication
    
    var body: some View {
        HStack {
            Image(systemName: "pills")
                .font(.title)
                .padding(.leading, -10)
            VStack(alignment: .leading) {
                Text("\(medication.name)")
                    .bold()
                    .lineLimit(1)
                
                Text("\(medication.strength) \(medication.unit.rawValue)")
                    .foregroundColor(Color.gray)
            }
            Spacer()
            
            Text("\(medication.remainingQuantity)")
                .padding(.trailing, 8)
        }
    }
}


#Preview {
    MedicationListRow(medication: .constant(MedicationStore.sampleData[0]))
}
