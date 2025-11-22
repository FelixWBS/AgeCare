//
//  NotificationController.swift
//  AgeCare
//
//  Created by Simon on 22.11.25.
//

//
//  NotificationController.swift
//  AgeCare
//

import Foundation
import UserNotifications
import SwiftData

@MainActor
final class NotificationController {

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            if let error = error {
                print("❌ Notification permission error: \(error)")
            } else {
                print("🔔 Notification permission granted: \(granted)")
            }
        }
    }

    func notifyRelatives(
        appointment: Appointment,
        contacts: [Contact],
        context: ModelContext
    ) {
        let names = contacts.map { $0.name }
        let joinedNames = names.joined(separator: ", ")

        let message =
        """
        A new appointment was created:
        \(appointment.title)
        Doctor: \(appointment.nameOfDoctor)
        Date: \(appointment.date.formatted())
        
        Relatives notified: \(joinedNames)
        """

        // SwiftData object speichern
        let notif = Notification(
            title: "New Appointment Created",
            message: message,
            appointment: appointment,
            contactNames: names
        )
        
        context.insert(notif)
        print("📦 Saved notification for appointment: \(appointment.title)")

        // iOS Local Notification (for hackathon demo)
        let content = UNMutableNotificationContent()
        content.title = "New Appointment for your relative"
        content.body = "Appointment \"\(appointment.title)\" created. Relatives: \(joinedNames)"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        |> { request in
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Failed to schedule notification: \(error)")
                } else {
                    print("📨 Local iOS notification sent.")
                }
            }
        }
    }
}

// kleiner Func-Helper (optional)
infix operator |> : AdditionPrecedence
func |> <T>(value: T, apply: (T) -> Void) {
    apply(value)
}
