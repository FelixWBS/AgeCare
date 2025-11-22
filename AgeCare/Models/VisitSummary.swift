//
//  Untitled.swift
//  AgeCare
//
//  Created by Simon on 22.11.25.
//

import Foundation
import SwiftData

@Model
class VisitSummary {
    /// Voller Roh-Text (vom Speech-to-Text)
    var rawTranscript: String

    /// Von der AI aufbereitete, strukturierte Zusammenfassung
    var aiSummary: String

    /// Zugehöriger Termin (optional)
    @Relationship
    var appointment: Appointment?

    /// Zeitstempel, wann diese Zusammenfassung erstellt wurde
    var createdAt: Date

    init(rawTranscript: String,
         aiSummary: String,
         appointment: Appointment? = nil,
         createdAt: Date = .now) {
        self.rawTranscript = rawTranscript
        self.aiSummary = aiSummary
        self.appointment = appointment
        self.createdAt = createdAt
    }
}

