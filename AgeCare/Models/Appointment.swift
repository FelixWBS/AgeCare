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
    var title: String           // Terminbeschreibung
    var nameOfDoctor: String
    var date: Date             // Datum + Uhrzeit
    var location: String?      // z.B. Praxisadresse
    var phoneNumber: String?   // optionale Telefonnummer
    var notes: String?
    var needRide: Bool = true
    var rideProvider: String? = nil
    var summary:String? = nil

    init(title: String, nameOfDoctor: String, date: Date, location: String? = nil, phoneNumber: String? = nil, notes: String? = nil) {
        self.title = title
        self.nameOfDoctor = nameOfDoctor
        self.date = date
        self.location = location
        self.phoneNumber = phoneNumber
        self.notes = notes
    }
}
