//
//  WholeSummary.swift
//  AgeCare
//
//  Created by Simon on 22.11.25.
//

import Foundation
import SwiftData

@Model
class WholeSummary {
    /// Gesamtzusammenfassung des Gesundheitszustands (von der AI)
    var aiSummary: String

    /// Text-Snapshot der Datenbasis (alle VisitSummaries inkl. relevanter Appointment-Daten),
    /// die der AI gegeben wurde – wichtig für Transparenz / Debugging.
    var sourceSnapshot: String

    /// Zeitpunkt, wann diese Gesamtzusammenfassung erzeugt wurde
    var createdAt: Date

    init(aiSummary: String,
         sourceSnapshot: String,
         createdAt: Date = .now) {
        self.aiSummary = aiSummary
        self.sourceSnapshot = sourceSnapshot
        self.createdAt = createdAt
    }
}
