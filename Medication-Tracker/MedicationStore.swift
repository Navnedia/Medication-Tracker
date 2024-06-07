//
//  MedicationStore.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 6/6/24.
//

import Foundation

class MedicationStore: ObservableObject {
    public static let shared: MedicationStore = MedicationStore()
    
    @Published public var medications: [Medication] = [
        Medication(name: "ADHD Medication", strength: 54, quantity: 25),
        Medication(name: "Isotretinoin", strength: 40, quantity: 57, note: "To help acne. Take twice daily with meals (it binds to fat in foods)."),
        Medication(name: "Ibuprofen", strength: 25, note: "Oh no! I have a headace, lol.")
    ]
    
    private init() { }
    
//    func load() {
//        
//    }
    
//    func save() {
//
//    }
}
