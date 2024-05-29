//
//  ScheduledFrequency.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 5/28/24.
//

/// An enum type representing different levels of schedule frequencies for taking medications.
enum ScheduledFrequency: Codable {
    case asNeeded
    case everyDay
    case specificDays
}
