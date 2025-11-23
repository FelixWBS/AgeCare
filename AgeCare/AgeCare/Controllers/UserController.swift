//
//  UserController.swift
//  AgeCare
//
//  Created by Simon on 22.11.25.
//

import Foundation
import SwiftData

@MainActor
final class UserController {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Create
    @discardableResult
    func add(name: String, role: UserRole) -> User {
        let user = User(name: name, role: role)
        modelContext.insert(user)
        do {
            try modelContext.save()
            print("✅ User gespeichert: \(user.name) – Rolle: \(user.role)")
        } catch {
            print("❌ Fehler beim Speichern des Users: \(error)")
        }
        return user
    }
    
    @discardableResult
    func add(name: String, roleString: String) -> User? {
        if let parsed = UserRole(rawValue: roleString) {
            return add(name: name, role: parsed)
        } else {
            print("❌ Ungültige Rolle übergeben: \(roleString). User wurde nicht angelegt.")
            return nil
        }
    }
    
    // MARK: - Read
    func fetchAll(sortedByName: Bool = true) throws -> [User] {
        if sortedByName {
            let descriptor = FetchDescriptor<User>(
                sortBy: [SortDescriptor(\User.name, order: .forward)]
            )
            return try modelContext.fetch(descriptor)
        } else {
            let descriptor = FetchDescriptor<User>()
            return try modelContext.fetch(descriptor)
        }
    }
    
    func fetch(nameContains query: String) throws -> [User] {
        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.name.localizedStandardContains(query) },
            sortBy: [SortDescriptor(\User.name, order: .forward)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    // MARK: - Update
    func update(_ user: User, name: String? = nil, role: UserRole? = nil) {
        if let name { user.name = name }
        if let role { user.role = role }
        do {
            try modelContext.save()
            print("✅ User aktualisiert: \(user.name)")
        } catch {
            print("❌ Fehler beim Aktualisieren des Users: \(error)")
        }
    }
    
    func update(_ user: User, name: String? = nil, roleString: String? = nil) {
        if let name { user.name = name }
        if let roleString, let parsed = UserRole(rawValue: roleString) {
            user.role = parsed
        }
        do {
            try modelContext.save()
            print("✅ User aktualisiert: \(user.name)")
        } catch {
            print("❌ Fehler beim Aktualisieren des Users: \(error)")
        }
    }
    
    // MARK: - Delete
    func delete(_ user: User) {
        modelContext.delete(user)
        do {
            try modelContext.save()
            print("🗑️ User gelöscht")
        } catch {
            print("❌ Fehler beim Löschen des Users: \(error)")
        }
    }
}
