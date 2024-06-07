//
//  MedicationItem.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 5/19/24.
//

import Foundation

// TODO: I might need to write a custom encoder and decoder.

class Medication: Identifiable, ObservableObject, Equatable, CustomStringConvertible {
    public let id: UUID
    
    @Published public var name: String
    @Published public var strength: Int
    @Published public var unit: Unit
    @Published public var note: String
    @Published public var schedule: ScheduleConfiguration
    
    static let quantityRange = 0...1000
    @Published public var remainingQuantity: Int {
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
    
    var description: String {
        "Medication(id: \(id), name: \(name), dosage: \(strength) \(unit.rawValue), remaining quantity: \(remainingQuantity), note: \(note), schedule: \(schedule)"
    }
    
    static func == (lhs: Medication, rhs: Medication) -> Bool {
        return lhs.name == rhs.name &&
               lhs.strength == rhs.strength &&
               lhs.unit == rhs.unit &&
               lhs.remainingQuantity == rhs.remainingQuantity &&
               lhs.note == rhs.note &&
               lhs.schedule == rhs.schedule
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
}


extension Medication {
    static var sampleData: [Medication] = [
        Medication(name: "ADHD Medication", strength: 54, quantity: 25),
        Medication(name: "Isotretinoin", strength: 40, quantity: 57, note: "To help acne. Take twice daily with meals (it binds to fat in foods)."),
        Medication(name: "Ibuprofen", strength: 25, note: "Oh no! I have a headace, lol.")
    ]
}
