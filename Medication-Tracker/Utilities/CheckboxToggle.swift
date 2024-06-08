//
//  CheckboxToggle.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 5/19/24.
//

import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    /// The symbol to be displayed on the checkbox toggle.
    var symbol: String?
    
    // Tint color defaults:
    var tintColor: Color = .black
    var selectedTintColor: Color = .black
    
    func makeBody(configuration: Configuration) -> some View {
        // If no symbol name is provided, then we omit the period so it renders just a circle by default.
        let symbol: String = (symbol != nil) ? "\(symbol!)." : ""
        
        VStack {
            Image(systemName: configuration.isOn ? "\(symbol)circle.fill" : "\(symbol)circle")
                .foregroundStyle(configuration.isOn ? selectedTintColor : tintColor)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}


// Custom view modifiers for color.
extension CheckboxToggleStyle {
    /// Set the tint color for unchecked box.
    func tintColor(_ color: Color) -> CheckboxToggleStyle{
        var modified = self
        modified.tintColor = color
        return modified
    }
    
    /// Set the tint color for checked box.
    func selectedTintColor(_ color: Color) -> CheckboxToggleStyle {
        var modified = self
        modified.selectedTintColor = color
        return modified
    }
}
