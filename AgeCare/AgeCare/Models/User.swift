//
//  User.swift
//  AgeCare
//
//  Created by Simon on 22.11.25.
//

//
//  User.swift
//  AgeCare
//

import Foundation
import SwiftData

@Model
class User {
    var name: String
    var role: UserRole        // "senior" oder "relative"
    
    init(name: String, role: UserRole) {
        self.name = name
        self.role = role
    }
}

enum UserRole: String, Codable, CaseIterable {
    case senior = "senior"
    case relative = "relative"
    
    var displayName: String {
        switch self {
        case .senior:
            return "Senior"
        case .relative:
            return "Relative"
        }
    }
}
