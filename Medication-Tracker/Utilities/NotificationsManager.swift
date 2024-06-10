//
//  NotificationsManager.swift
//  Medication-Tracker
//
//  Created by Aiden Vandekerckhove on 6/9/24.
//

import Foundation
import UserNotifications
import SwiftUI

/// A singleton class for managing the scheduling of medication reminder notifications.
class NotificationsManager: NSObject {
    /// Shared singleton instance.
    public static let shared: NotificationsManager = NotificationsManager()
    
    private let notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()
    
    // Hidden constructor for singleton pattern.
    private override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    public func requestAuth() async {
        do {
            try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            print("Issue requesting notification authorization:\n\(error)")
        }
    }
    
    public func addScheduledReminders(for medication: Medication) async {
        let content = UNMutableNotificationContent()
        content.title = "Mecation Reminder"
        content.interruptionLevel = .timeSensitive
        content.userInfo = ["medicationId" : medication.id.uuidString]
        
        let componetFormatter = DateComponentsFormatter()
        componetFormatter.unitsStyle = .positional
        componetFormatter.allowedUnits = [.day, .minute, .hour]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        let scheduledDatePatterns = medication.schedule.dateComponents
        for datePattern in scheduledDatePatterns {
            var time = ""
            if let date = datePattern.date {
                content.userInfo.updateValue(date.ISO8601Format(), forKey: "date")
                time = " " + dateFormatter.string(from: date)
            }
            
            content.body = "Time to take your\(time) medication!"
            
            let dateTrigger = UNCalendarNotificationTrigger(dateMatching: datePattern, repeats: true)
            // Generate notification request id from the medication id and the date pattern information.
            let requestId = "\(medication.id) \(componetFormatter.string(from: datePattern) ?? "")"
            
            let request = UNNotificationRequest(identifier: requestId, content: content, trigger: dateTrigger)
            
            do {
                try await notificationCenter.add(request)
            } catch {
                print("Failed to add scheduled notification for id: \(requestId)\n\n\(error)")
            }
        }
        
        let pending = await notificationCenter.pendingNotificationRequests()
        print(pending)
    }
    
    public func removeScheduledReminders(for idPrefix: String) {
        Task {
            let pending = await notificationCenter.pendingNotificationRequests()
            // Extract ids of only the request with the prefix matching the medication id.
            let matchingRequestIds = pending.compactMap { request in
                request.identifier.hasPrefix(idPrefix) ? request.identifier : nil
            }
            notificationCenter.removePendingNotificationRequests(withIdentifiers: matchingRequestIds)
        }
    }
    
    public func refreshScheduledReminders(for medication: Medication) async {
        removeScheduledReminders(for: medication.id.uuidString)
        await addScheduledReminders(for: medication)
    }
}


extension NotificationsManager: UNUserNotificationCenterDelegate {
//    @MainActor
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
//        // Pass medication and date component then find the first matching on the day that is untaken, scheduled or not.
//        // Launch the correct view or use action buttons to mark item.
//        Task {
//            let store = MedicationStore.shared
//            if (UIApplication.shared.applicationState == .background) {
//                await store.load()
//            }
//            
//            let userInfo = response.notification.request.content.userInfo
//            
//            if let medication = await store.getMedication(forId: userInfo["medicationId"] as! String) {
//                let date = ISO8601DateFormatter().date(from: userInfo["date"] as! String)
//                medication.note = "Modified from notification responder"
//                print("\(medication) \(String(describing: date))")
//            } else {
//                print("Not found:\n\(store.medications)")
//            }
//        }
//    }
}
