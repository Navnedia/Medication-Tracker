//
//  UnitEnum.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 6/6/24.
//

/// An enum type representing the days in a week. The raw value represents the day index for date object creating.
enum Unit: String, CaseIterable, Codable {
    case mg
    case mcg
    case g
    case ml
    case percent = "%"
}
