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
    var role: String        // "senior" oder "relative"
    
    init(name: String, role: String) {
        self.name = name
        self.role = role
    }
}
