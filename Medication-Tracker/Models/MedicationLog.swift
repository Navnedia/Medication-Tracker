//
//  MedicationLog.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 6/8/24.
//

import Foundation

@Observable
class MedicationLog: Identifiable, Codable, Comparable, CustomStringConvertible {
    public let id: UUID
    
    public weak var medication: Medication?
    public var scheduled: Date
    public var takenTimestamp: Date?
    public var isTaken: Bool
    
    public init(id: UUID = UUID(), medication: Medication? = nil, scheduled: Date = Date.now, taken: Bool = false, timestamp: Date? = nil) {
        self.id = id
        self.medication = medication
        self.scheduled = scheduled
        self.takenTimestamp = timestamp
        self.isTaken = taken
    }
    
    public func setMedication(_ medication: Medication? = nil) -> MedicationLog {
        self.medication = medication
        return self
    }
    
    static func < (lhs: MedicationLog, rhs: MedicationLog) -> Bool {
        return lhs.scheduled < rhs.scheduled
    }
    
    static func == (lhs: MedicationLog, rhs: MedicationLog) -> Bool {
        return lhs.scheduled == rhs.scheduled
    }
    
    var description: String {
        "MedicationLog(id: \(id), scheduled: \(scheduled), taken: \(isTaken), timestamp: \(String(describing: takenTimestamp))"
    }
    
    // MARK: Custom codable conformance to work with observer.
    enum CodingKeys: String, CodingKey {
        case id
        case _scheduled = "scheduled"
        case _takenTimestamp = "takenTimestamp"
        case _isTaken = "isTaken"
    }
}
