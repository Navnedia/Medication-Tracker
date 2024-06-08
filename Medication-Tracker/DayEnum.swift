//
//  DayEnum.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 5/27/24.
//

/// An enum type representing the days in a week. The raw value represents the day index for date object creating.
enum Day: Int, CaseIterable, Codable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    
    /// Get the first letter of the day. Useful for showing the day as shorthand.
    var firstLetter: String {
        let name: String = "\(self)"
        return "\(name[name.startIndex])"
    }
    
    var shortName: String {
        let name: String = "\(self)"
        return "\(name[name.startIndex])".capitalized + "\(name.dropFirst().prefix(2))"
    }
}
