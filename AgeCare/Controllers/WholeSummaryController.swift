//
//  WholeSummaryController.swift
//  AgeCare
//
//  Created by Simon on 22.11.25.
//

import Foundation
import SwiftData

final class WholeSummaryController {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Snapshot aus VisitSummaries bauen

    /// Baut einen konsolidierten Text-Snapshot aus den gegebenen VisitSummaries,
    /// den du 1:1 an die AI schicken kannst.
    func buildSourceSnapshot(from summaries: [VisitSummary]) -> String {
        var lines: [String] = []
        lines.append("PATIENT HISTORY SNAPSHOT")
        lines.append("------------------------")
        lines.append("All visit summaries based on recorded doctor conversations.\n")

        if summaries.isEmpty {
            lines.append("(No visit summaries stored yet.)")
            return lines.joined(separator: "\n")
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short

        // Sortieren, falls noch nicht sortiert
        let sorted = summaries.sorted { $0.createdAt < $1.createdAt }

        for summary in sorted {
            let created = dateFormatter.string(from: summary.createdAt)

            let appt = summary.appointment
            let apptDate = appt.map { dateFormatter.string(from: $0.date) } ?? "Unknown date"
            let apptTitle = appt?.title ?? "Unknown appointment"
            let apptDoctor = appt?.nameOfDoctor ?? "Unknown doctor"
            let apptLocation = appt?.location ?? "Unknown location"

            lines.append("""
            ----------------------------------------
            VISIT SUMMARY
            Created at: \(created)
            Appointment: \(apptTitle)
            Doctor: \(apptDoctor)
            Appointment date: \(apptDate)
            Location: \(apptLocation)

            AI SUMMARY:
            \(summary.aiSummary)

            RAW TRANSCRIPT:
            \(summary.rawTranscript)
            """)
        }

        return lines.joined(separator: "\n\n")
    }

    // MARK: - Create

    @discardableResult
    func add(aiSummary: String,
             sourceSnapshot: String) -> WholeSummary {
        let whole = WholeSummary(
            aiSummary: aiSummary,
            sourceSnapshot: sourceSnapshot,
            createdAt: .now
        )
        modelContext.insert(whole)
        do {
            try modelContext.save()
            print("✅ WholeSummary gespeichert (createdAt: \(whole.createdAt))")
        } catch {
            print("❌ Fehler beim Speichern der WholeSummary: \(error)")
        }
        return whole
    }

    // MARK: - Read

    func fetchAll(sortedByDateAscending: Bool = false) throws -> [WholeSummary] {
        let order: SortOrder = sortedByDateAscending ? .forward : .reverse
        let descriptor = FetchDescriptor<WholeSummary>(
            sortBy: [SortDescriptor(\WholeSummary.createdAt, order: order)]
        )
        return try modelContext.fetch(descriptor)
    }

    func fetchLatest() throws -> WholeSummary? {
        var descriptor = FetchDescriptor<WholeSummary>(
            sortBy: [SortDescriptor(\WholeSummary.createdAt, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    // MARK: - Update

    func update(_ whole: WholeSummary,
                aiSummary: String? = nil,
                sourceSnapshot: String? = nil,
                createdAt: Date? = nil) {
        if let aiSummary { whole.aiSummary = aiSummary }
        if let sourceSnapshot { whole.sourceSnapshot = sourceSnapshot }
        if let createdAt { whole.createdAt = createdAt }

        do {
            try modelContext.save()
            print("✅ WholeSummary aktualisiert (createdAt: \(whole.createdAt))")
        } catch {
            print("❌ Fehler beim Aktualisieren der WholeSummary: \(error)")
        }
    }

    // MARK: - Delete

    func delete(_ whole: WholeSummary) {
        modelContext.delete(whole)
        do {
            try modelContext.save()
            print("🗑️ WholeSummary gelöscht")
        } catch {
            print("❌ Fehler beim Löschen der WholeSummary: \(error)")        }
    }
}
