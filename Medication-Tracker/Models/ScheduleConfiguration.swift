//
//  ScheduleConfiguration.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 5/28/24.
//

import Foundation

struct ScheduleConfiguration: Identifiable, Codable, Equatable, CustomStringConvertible {
    public let id: UUID
    public var frequency: ScheduledFrequency
    public var days: [Day]
    public var times: [Date]
    
    public var dateComponents: [DateComponents] {
        var days: [Day] = []
        switch frequency {
            case .asNeeded:
                return []
            case .everyDay:
                days = Day.allCases // Ignore selected days and just use all days.
            case .specificDays:
                days = self.days
        }
        
        
        return days.map { day in
            // Map every selected day to date components for every selected time:
            times.map { time in
                let calender = Calendar.current
                
                return DateComponents(
                    calendar: calender,
                    hour: calender.component(.hour, from: time),
                    minute: calender.component(.minute, from: time),
                    weekday: day.rawValue
                )
            }
        }.flatMap {$0} // Reduce the nested array.
    }
    
    init(id: UUID = UUID(), frequency: ScheduledFrequency = .asNeeded, days: [Day] = [], times: [Date] = []) {
        self.id = id
        self.frequency = frequency
        self.days = days
        self.times = times
    }
    
    static func == (lhs: ScheduleConfiguration, rhs: ScheduleConfiguration) -> Bool {
        return lhs.frequency == rhs.frequency &&
               lhs.days == rhs.days &&
               lhs.times == rhs.times
    }
    
    var description: String {
        "ScheduleConfiguration(id: \(id), frequency: \(frequency), days: \(String(describing: days)), times: \(String(describing: times)))"
    }
}
