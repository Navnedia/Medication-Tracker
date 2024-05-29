//
//  MedicationItem.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 5/19/24.
//

import Foundation

struct Medication: Identifiable, Codable, CustomStringConvertible, Equatable {
    public let id: UUID
    public var name: String
    public var note: String
    
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
    
    init(id: UUID = UUID(), name: String = "", quantity: Int = 1, note: String = "") {
        self.id = id
        self.name = name
        self.remainingQuantity = quantity
        self.note = note
    }
    
    var description: String {
        "id: \(id), name: \(name), remaining quantity: \(remainingQuantity), note: \(note)"
    }
    
    static func == (lhs: Medication, rhs: Medication) -> Bool {
        return lhs.name == rhs.name &&
               lhs.remainingQuantity == rhs.remainingQuantity &&
               lhs.note == rhs.note
    }
}


extension Medication {
    static var sampleData: [Medication] = [
        Medication(name: "ADHD Medication", quantity: 25),
        Medication(name: "Isotretinoin", quantity: 57, note: "To help acne. Take twice daily with meals (it binds to fat in foods)."),
        Medication(name: "Ibuprofen", note: "Oh no! I have a headace, lol.")
    ]
}
