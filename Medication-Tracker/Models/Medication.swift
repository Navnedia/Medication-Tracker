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
    
    init(id: UUID = UUID(), name: String = "", strength: Int = 0, unit: Unit = .mg, quantity: Int = 1, note: String = "", schedule: ScheduleConfiguration = ScheduleConfiguration()) {
        self.id = id
        self.name = name
        self.strength = strength
        self.unit = unit
        self.remainingQuantity = quantity
        self.note = note
        self.schedule = schedule
    }
    
    /// Creates a deep copy of the medication object.
    func copy() -> Medication {
        return Medication(id: id,
                          name: name,
                          strength: strength,
                          unit: unit,
                          quantity: remainingQuantity,
                          note: note,
                          schedule: schedule
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
        "Medication(id: \(id), name: \(name), dosage: \(strength) \(unit.rawValue), remaining quantity: \(remainingQuantity), note: \(note), schedule: \(schedule)"
    }
    
    // MARK: Custom Codable Conformance.
    
    enum CodingKeys: String, CodingKey {
        case id, name, strength, unit, note, remainingQuantity, schedule
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        strength = try values.decode(Int.self, forKey: .strength)
        unit = try values.decode(Unit.self, forKey: .unit)
        note = try values.decode(String.self, forKey: .note)
        remainingQuantity = try values.decode(Int.self, forKey: .remainingQuantity)
        schedule = try values.decode(ScheduleConfiguration.self, forKey: .schedule)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(strength, forKey: .strength)
        try container.encode(unit, forKey: .unit)
        try container.encode(note, forKey: .note)
        try container.encode(remainingQuantity, forKey: .remainingQuantity)
        try container.encode(schedule, forKey: .schedule)
    }
}
