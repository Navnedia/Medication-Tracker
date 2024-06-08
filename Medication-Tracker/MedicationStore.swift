//
//  MedicationStore.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 6/6/24.
//

import Foundation

/// A singleton class for managing persistent medication data storage. This class conforms to the observable protocol so we can treat the data as our source of truth.
@MainActor
@Observable
class MedicationStore {
    /// Shared singleton instance.
    public static let shared: MedicationStore = MedicationStore()
    /// The file name for the data save file.
    private static let fileName: String = "medications.json"
    /// The medication objects loaded into the data store.
    public var medications: [Medication] = []
    
    // Hidden constructor for singleton pattern.
    private init() { }
    
    /// Generate the file path URL for the medications daat save file.
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(fileName)
    }
    
    /// Asynchronously load in medications data from the store save file.
    func load() async {
        let loadTask = Task<[Medication], Error> {
            do {
                guard let inputFileURL = try? Self.fileURL() else {
                    print("Unable to find medication file URL.")
                    return []
                }
                
                // Create data stream from file.
                guard let data = try? Data(contentsOf: inputFileURL) else {
                    print("Unable to build data object from medication input file.")
                    return []
                }
                // Parse in the JSON data to an array of medication objects.
                let jsonDecoder = JSONDecoder()
                return try jsonDecoder.decode([Medication].self, from: data)
            } catch {
                print("Load failed to decode medication data file: \n\(error)")
                return []
            }
        }
        
        if let medications = try? await loadTask.value {
            self.medications = medications
        }
    }
    
    /// Asynchronously save medications data from the store into the saved data file. If no argument is specified it will save the instance medications array by default.
    func save(_ medications: [Medication]? = nil) async {
        Task {
            do {
                guard let outputFileURL = try? Self.fileURL() else {
                    print("Unable to find medication file URL.")
                    return
                }
                
                // Encode medication array to JSON data.
                let jsonEncoder = JSONEncoder()
                let jsonData = try jsonEncoder.encode(medications ?? self.medications) // If the argument was left default, then use the instance medications array.
                // Write data to save file.
                try jsonData.write(to: outputFileURL)
            } catch {
                print("Save failed to encode and write medication data to file: \(error)")
            }
        }
    }
}


extension MedicationStore {
    /// A sample medications data set mainly used for view previews.
    static var sampleData: [Medication] = [
        Medication(name: "ADHD Medication", strength: 54, quantity: 25),
        Medication(name: "Isotretinoin", strength: 40, quantity: 57, note: "To help acne. Take twice daily with meals (it binds to fat in foods)."),
        Medication(name: "Ibuprofen", strength: 25, note: "Oh no! I have a headace, lol.")
    ]
}
