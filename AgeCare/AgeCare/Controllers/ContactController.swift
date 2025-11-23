//
//  ContactController.swift
//  AgeCare
//
//  Created by Simon on 22.11.25.
//

import Foundation
import SwiftData

@MainActor
final class ContactController {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Create
    @discardableResult
    func add(name: String, phone: String? = nil, relation: String? = nil) -> Contact {
        let contact = Contact(name: name, phone: phone, relation: relation)
        modelContext.insert(contact)
        do {
            try modelContext.save()
            print("✅ Kontakt gespeichert: \(contact.name)")
        } catch {
            print("❌ Fehler beim Speichern des Kontakts: \(error)")
        }
        return contact
    }
    
    // MARK: - Read
    func fetchAll(sortedByName: Bool = true) throws -> [Contact] {
        if sortedByName {
            let descriptor = FetchDescriptor<Contact>(
                sortBy: [SortDescriptor(\Contact.name, order: .forward)]
            )
            return try modelContext.fetch(descriptor)
        } else {
            let descriptor = FetchDescriptor<Contact>()
            return try modelContext.fetch(descriptor)
        }
    }
    
    func fetch(nameContains query: String) throws -> [Contact] {
        let descriptor = FetchDescriptor<Contact>(
            predicate: #Predicate { $0.name.localizedStandardContains(query) },
            sortBy: [SortDescriptor(\Contact.name, order: .forward)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    // MARK: - Update
    func update(_ contact: Contact, name: String? = nil, phone: String? = nil, relation: String? = nil) {
        if let name { contact.name = name }
        if let phone { contact.phone = phone }
        if let relation { contact.relation = relation }
        do {
            try modelContext.save()
            print("✅ Kontakt aktualisiert: \(contact.name)")
        } catch {
            print("❌ Fehler beim Aktualisieren des Kontakts: \(error)")
        }
    }
    
    // MARK: - Delete
    func delete(_ contact: Contact) {
        modelContext.delete(contact)
        do {
            try modelContext.save()
            print("🗑️ Kontakt gelöscht")
        } catch {
            print("❌ Fehler beim Löschen des Kontakts: \(error)")
        }
    }
}
