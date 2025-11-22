//
//  VisitSummaryController.swift
//  AgeCare
//
//  Created by Simon on 22.11.25.
//

import Foundation
import SwiftData

final class VisitSummaryController {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Create

    /// Legt eine neue VisitSummary an und speichert sie.
    @discardableResult
    func add(rawTranscript: String,
             aiSummary: String,
             appointment: Appointment? = nil,
             createdAt: Date = .now) -> VisitSummary {

        let summary = VisitSummary(
            rawTranscript: rawTranscript,
            aiSummary: aiSummary,
            appointment: appointment,
            createdAt: createdAt
        )

        modelContext.insert(summary)

        do {
            try modelContext.save()
            print("✅ VisitSummary gespeichert (createdAt: \(summary.createdAt))")
        } catch {
            print("❌ Fehler beim Speichern der VisitSummary: \(error)")
        }

        return summary
    }

    /// Convenience: erzeugt eine VisitSummary direkt aus Text + AI-Antwort.
    @discardableResult
    func addFromAI(rawTranscript: String,
                   aiSummary: String,
                   for appointment: Appointment? = nil) -> VisitSummary {
        add(
            rawTranscript: rawTranscript,
            aiSummary: aiSummary,
            appointment: appointment,
            createdAt: .now
        )
    }

    // MARK: - Read

    /// Alle VisitSummary-Einträge, optional nach Datum sortiert (neueste zuerst).
    func fetchAll(sortedByDateAscending: Bool = false) throws -> [VisitSummary] {
        let order: SortOrder = sortedByDateAscending ? .forward : .reverse
        let descriptor = FetchDescriptor<VisitSummary>(
            sortBy: [SortDescriptor(\VisitSummary.createdAt, order: order)]
        )
        return try modelContext.fetch(descriptor)
    }

    /// Alle Zusammenfassungen zu einem bestimmten Appointment.
    func fetch(for appointment: Appointment,
               sortedByDateAscending: Bool = false) throws -> [VisitSummary] {
        let order: SortOrder = sortedByDateAscending ? .forward : .reverse

        let descriptor = FetchDescriptor<VisitSummary>(
            predicate: #Predicate { summary in
                summary.appointment == appointment
            },
            sortBy: [SortDescriptor(\VisitSummary.createdAt, order: order)]
        )

        return try modelContext.fetch(descriptor)
    }

    /// Neueste Zusammenfassung zu einem bestimmten Appointment.
    func fetchLatest(for appointment: Appointment) throws -> VisitSummary? {
        var descriptor = FetchDescriptor<VisitSummary>(
            predicate: #Predicate { summary in
                summary.appointment == appointment
            },
            sortBy: [SortDescriptor(\VisitSummary.createdAt, order: .reverse)]
        )
        descriptor.fetchLimit = 1

        return try modelContext.fetch(descriptor).first
    }

    // MARK: - Update

    func update(_ summary: VisitSummary,
                rawTranscript: String? = nil,
                aiSummary: String? = nil,
                appointment: Appointment? = nil,
                createdAt: Date? = nil) {

        if let rawTranscript { summary.rawTranscript = rawTranscript }
        if let aiSummary { summary.aiSummary = aiSummary }
        if let appointment { summary.appointment = appointment }
        if let createdAt { summary.createdAt = createdAt }

        do {
            try modelContext.save()
            print("✅ VisitSummary aktualisiert (createdAt: \(summary.createdAt))")
        } catch {
            print("❌ Fehler beim Aktualisieren der VisitSummary: \(error)")
        }
    }

    // MARK: - Delete

    func delete(_ summary: VisitSummary) {
        modelContext.delete(summary)

        do {
            try modelContext.save()
            print("🗑️ VisitSummary gelöscht")
        } catch {
            print("❌ Fehler beim Löschen der VisitSummary: \(error)")
        }
    }

    /// Löscht alle VisitSummaries zu einem Appointment (falls nötig).
    func deleteAll(for appointment: Appointment) {
        do {
            let all = try fetch(for: appointment)
            for s in all {
                modelContext.delete(s)
            }
            try modelContext.save()
            print("🗑️ Alle VisitSummaries für Appointment gelöscht")
        } catch {
            print("❌ Fehler beim Löschen der VisitSummaries: \(error)")
        }
    }
}

