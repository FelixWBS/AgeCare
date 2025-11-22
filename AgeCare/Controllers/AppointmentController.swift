//
//  AppointmentController.swift
//  AgeCare
//
//  Created by Simon on 22.11.25.
//

//
//  AppointmentController.swift
//  AgeCare
//

import Foundation
import SwiftData

final class AppointmentController {
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Create (simple)
    @discardableResult
    func add(title: String,nameOfDoctor: String, date: Date, location: String? = nil, phoneNumber: String? = nil, notes: String? = nil) -> Appointment {
        let appointment = Appointment(title: title, nameOfDoctor: nameOfDoctor, date: date, location: location, phoneNumber: phoneNumber, notes: notes)
        modelContext.insert(appointment)
        do { try modelContext.save(); print("✅ Termin gespeichert: \(appointment.title)") } catch { print("❌ Fehler beim Speichern des Termins: \(error)") }
        return appointment
    }

    // MARK: - Read (all)
    func fetchAll(sortedByDate: Bool = true) throws -> [Appointment] {
        if sortedByDate {
            let descriptor = FetchDescriptor<Appointment>(
                sortBy: [SortDescriptor(\Appointment.date, order: .forward)]
            )
            return try modelContext.fetch(descriptor)
        } else {
            return try modelContext.fetch(FetchDescriptor<Appointment>())
        }
    }

    // MARK: - Update
    func update(_ appointment: Appointment, title: String? = nil, date: Date? = nil, location: String? = nil, phoneNumber: String? = nil, notes: String? = nil) {
        if let title { appointment.title = title }
        if let date { appointment.date = date }
        if let location { appointment.location = location }
        if let phoneNumber { appointment.phoneNumber = phoneNumber }
        if let notes { appointment.notes = notes }
        do { try modelContext.save(); print("✅ Termin aktualisiert: \(appointment.title)") } catch { print("❌ Fehler beim Aktualisieren des Termins: \(error)") }
    }

    // MARK: - Delete
    func delete(_ appointment: Appointment) {
        modelContext.delete(appointment)
        do { try modelContext.save(); print("🗑️ Termin gelöscht") } catch { print("❌ Fehler beim Löschen des Termins: \(error)") }
    }
    
    /// Erzeugt aus einem (Sprach-)Text einen Appointment und speichert ihn.
    func createAppointment(from text: String) {
        let date = Calendar.current.date(byAdding: .hour, value: 1, to: .now) ?? .now
        
        let appointment = Appointment(
            title: text, nameOfDoctor: "unknown",
            date: date,
            location: nil,
            phoneNumber: nil,
            notes: nil
        )
        
        modelContext.insert(appointment)
        
        do {
            try modelContext.save()
            print("✅ Termin gespeichert: \(appointment.title) – \(appointment.date)")
        } catch {
            print("❌ Fehler beim Speichern des Termins: \(error)")
        }
    }
    
    /// Liefert kommende Termine, nach Datum sortiert.
    func fetchUpcomingAppointments(limit: Int = 5) throws -> [Appointment] {
        let now = Date()
        
        let descriptor = FetchDescriptor<Appointment>(
            predicate: #Predicate { $0.date >= now },
            sortBy: [SortDescriptor(\Appointment.date, order: .forward)]
        )
        
        var results = try modelContext.fetch(descriptor)
        if limit > 0 && results.count > limit {
            results = Array(results.prefix(limit))
        }
        return results
    }
}
