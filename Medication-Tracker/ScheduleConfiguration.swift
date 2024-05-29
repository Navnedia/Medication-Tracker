//
//  ScheduleConfiguration.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 5/28/24.
//

import Foundation

struct ScheduleConfiguration: Identifiable, Codable, CustomStringConvertible {
    public let id: UUID
    public var frequency: ScheduledFrequency
    public var days: [Day]
    public var times: [Date]
    
    init(id: UUID = UUID(), frequency: ScheduledFrequency = .asNeeded, days: [Day] = [], times: [Date] = []) {
        self.id = id
        self.frequency = frequency
        self.days = days
        self.times = times
    }
    
    var description: String {
        "ScheduleConfiguration(id: \(id), frequency: \(frequency), days: \(String(describing: days)), times: \(String(describing: times)))"
    }
}
