//
//  Appointment.swift
//  AgeCare
//
//  Created by Simon on 22.11.25.
//

//
//  Appointment.swift
//  AgeCare
//

import Foundation
import SwiftData

@Model
class Appointment {
    var title: String           // Arztname / Terminbeschreibung
    var date: Date             // Datum + Uhrzeit
    var location: String?      // z.B. Praxisadresse
    var notes: String?
    var phone: String?// optional
    
    init(title: String, date: Date, location: String? = nil, notes: String? = nil, phone: String? = nil) {
        self.title = title
        self.date = date
        self.location = location
        self.notes = notes
        self.phone = phone
    }
}
