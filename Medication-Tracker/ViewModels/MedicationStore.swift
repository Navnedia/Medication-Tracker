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
    
    public var filteredLogs: [MedicationLog] = []
    
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
    
    func getMedication(forId id: String) async -> Medication? {
        let medicationId = UUID(uuidString: id)
        return MedicationStore.shared.medications.first { med in
            med.id == medicationId
        }
    }
    
    /// Asynchronously update the filteredLogs view model property to reflect only the scheduled logs for the specified date.
    func filterLogs(by date: Date) async {
        let filterTask = Task<[MedicationLog], Error> {
            let filtered = medications.map { med in
                let calender = Calendar.current
                
                // Filter logs for the current medication to only those on the selected day.
                var matchingLogsForMedication = med.logs.filter { log in
                    calender.compare(date, to: log.scheduled, toGranularity: .day) == .orderedSame
                }.map { log in
                    log.setMedication(med) // Add medication reference to the log because this value is not encoded/decoded.
                }
                
                // If the selected filter date is before when the medication schedule was last updated, then we won't modify the logs.
                if (calender.compare(date, to: med.schedule.updated, toGranularity: .day) == .orderedAscending) {
                    return matchingLogsForMedication
                }
                // Get a list of matching scheduled time data objects for the selected date.
                let scheduledTimes = med.schedule.matchingScheduleTimes(for: date)
                // Add missing schedule log entries on demand:
                for time in scheduledTimes {
                    let containsLog = matchingLogsForMedication.contains { log in
                        log.scheduled == time
                    }
                    // Create and add missing logs
                    if (!containsLog) {
                        let missingLog = MedicationLog(medication: med, scheduled: time)
                        med.logs.append(missingLog)
                        matchingLogsForMedication.append(missingLog)
                    }
                }
                
                return matchingLogsForMedication
            }.flatMap {$0} // Merge all the log lists for each medication.
            
            return filtered.sorted(by: <) // Sort the full day logs list in ascending order.
        }
        
        if let filtered = try? await filterTask.value {
            self.filteredLogs = filtered
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
