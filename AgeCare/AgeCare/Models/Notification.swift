//
//  Notification.swift
//  AgeCare
//
//  Created by Simon on 22.11.25.
//

//
//  Notification.swift
//  AgeCare
//

import Foundation
import SwiftData

@Model
class Notification {
    var title: String
    var message: String
    var timestamp: Date
    
    // WICHTIG: direkte SwiftData-Relation
    @Relationship
    var appointment: Appointment
    
    // Namen oder IDs der benachrichtigten Contacts
    var contactNames: [String]

    init(
        title: String,
        message: String,
        appointment: Appointment,
        contactNames: [String]
    ) {
        self.title = title
        self.message = message
        self.appointment = appointment
        self.contactNames = contactNames
        self.timestamp = Date()
    }
}

