//
//  ScheduledFrequency.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 5/28/24.
//

/// An enum type representing different levels of schedule frequencies for taking medications.
enum ScheduledFrequency: Codable, CaseIterable {
    case asNeeded
    case everyDay
    case specificDays
    
    var title: String {
        switch self {
            case .asNeeded: "As Needed"
            case .everyDay: "Every Day"
            case .specificDays: "On Specific Days"
        }
    }
}
