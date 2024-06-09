//
//  MedicationItem.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 5/19/24.
//

import Foundation

@Observable
class Medication: Identifiable, Codable, Equatable, CustomStringConvertible {
    public let id: UUID
    
    public var name: String
    public var strength: Int
    public var unit: Unit
    public var note: String
    public var schedule: ScheduleConfiguration
    public var logs: [MedicationLog]
    
    static let quantityRange = 0...1000
    public var remainingQuantity: Int {
        didSet(value) {
            if value < Medication.quantityRange.lowerBound {
                remainingQuantity = Medication.quantityRange.lowerBound
            } else if  value > Medication.quantityRange.upperBound {
                remainingQuantity = Medication.quantityRange.upperBound
            }
        }
    }
    
    init(id: UUID = UUID(), name: String = "", strength: Int = 0, unit: Unit = .mg, quantity: Int = 1, note: String = "", schedule: ScheduleConfiguration = ScheduleConfiguration(), logs: [MedicationLog] = []) {
        self.id = id
        self.name = name
        self.strength = strength
        self.unit = unit
        self.remainingQuantity = quantity
        self.note = note
        self.schedule = schedule
        self.logs = logs
    }
    
    /// Creates a deep copy of the medication object.
    func copy() -> Medication {
        return Medication(id: id,
                          name: name,
                          strength: strength,
                          unit: unit,
                          quantity: remainingQuantity,
                          note: note,
                          schedule: schedule,
                          logs: logs
        )
    }
    
    static func == (lhs: Medication, rhs: Medication) -> Bool {
        return lhs.name == rhs.name &&
               lhs.strength == rhs.strength &&
               lhs.unit == rhs.unit &&
               lhs.remainingQuantity == rhs.remainingQuantity &&
               lhs.note == rhs.note &&
               lhs.schedule == rhs.schedule
    }
    
    var description: String {
        "Medication(id: \(id), name: \(name), dosage: \(strength) \(unit.rawValue), remaining quantity: \(remainingQuantity), note: \(note), schedule: \(schedule), logs: \(logs)"
    }
    
    // MARK: Custom codable conformance to work with observer.
    enum CodingKeys: String, CodingKey {
        case id
        case _name = "name"
        case _strength = "strength"
        case _unit = "unit"
        case _note = "note"
        case _schedule = "schedule"
        case _logs = "logs"
        case _remainingQuantity = "remainingQuantity"
    }
}
