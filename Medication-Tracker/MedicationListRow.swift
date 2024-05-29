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
                Text("\(medication.name)") // Maybe include setrength and unit
                    .bold()
                    .lineLimit(1)
                
                Text("Additional Details") // Mention last taken, or next time scheduled time. Or the mount of pills remaining.
                    .foregroundColor(Color.gray)
            }
            Spacer()
            
//            if (medication.remainingQuantity > 1) { // Don't display a remainingQuantity of 1.
                Text("\(medication.remainingQuantity)") // Clarify the meaning here.
                    .padding(.trailing, 8)
//            }
        }
    }
}


#Preview {
    MedicationListRow(medication: .constant(Medication.sampleData[0]))
}
