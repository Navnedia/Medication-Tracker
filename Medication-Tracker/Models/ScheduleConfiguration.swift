//
//  ScheduleConfiguration.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 5/28/24.
//

import Foundation

struct ScheduleConfiguration: Identifiable, Codable, Equatable, CustomStringConvertible {
    public let id: UUID
    
    public var updated: Date
    public var frequency: ScheduledFrequency
    public var days: [Day]
    public var times: [Date]
    
    /// Determine the source of truth for days based on what frequency is selected.
    private var validDays: [Day] {
        switch frequency {
            case .asNeeded: []
            case .everyDay: Day.allCases // Ignore selected days and just use all days.
            case .specificDays: self.days
        }
    }
    
    public var dateComponents: [DateComponents] {
        return validDays.map { day in
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
    
    init(id: UUID = UUID(), frequency: ScheduledFrequency = .asNeeded, days: [Day] = [], times: [Date] = [], updated: Date = Date.now) {
        self.id = id
        self.frequency = frequency
        self.days = days
        self.times = times
        self.updated = updated
    }
    
    func matchingScheduleTimes(for date: Date) -> [Date] {
        let calender = Calendar.current
        // Extract components from the desired date:
        var components = calender.dateComponents([.calendar, .year, .month, .weekday, .day], from: date)
        
        // If the date day of the week matches the schdule then build dates for each scheduled time.
        if (validDays.contains { $0.rawValue == components.weekday}) {
            return times.compactMap { time in
                components.hour = calender.component(.hour, from: time)
                components.minute = calender.component(.minute, from: time)
                
                return components.date
            }
        }
        
        return []
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
