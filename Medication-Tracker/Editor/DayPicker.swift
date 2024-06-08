//
//  DayPicker.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 5/27/24.
//

import SwiftUI

struct DayPicker: View {
    @Binding var selectedDays: [Day]
    
    // Tint color defaults:
    var tintColor: Color = .gray
    var selectedTintColor: Color = .blue
    
    var body: some View {
        HStack {
            ForEach(Day.allCases, id: \.self) { day in
                var dayIsSelected: Bool { selectedDays.contains(day) }
                
                Image(systemName: dayIsSelected ? "\(day.firstLetter).circle.fill" : "\(day.firstLetter).circle")
                    .foregroundStyle(dayIsSelected ? selectedTintColor : tintColor)
                    .accessibilityLabel("\(String(describing: day)) toggle \(dayIsSelected ? "selected" : "not selected")")
                    .onTapGesture {
                        if (dayIsSelected) {
                            selectedDays.removeAll(where: { $0 == day })
                        } else {
                            selectedDays.append(day)
                        }
                    }
                
                Spacer()
            }
        }
    }
}


// Custom view modifiers for color.
extension DayPicker {
    /// Set the tint color for an unselected day.
    func tintColor(_ color: Color) -> DayPicker {
        var modified = self
        modified.tintColor = color
        return modified
    }
    
    /// Set the tint color for a selected day.
    func selectedTintColor(_ color: Color) -> DayPicker {
        var modified = self
        modified.selectedTintColor = color
        return modified
    }
}
