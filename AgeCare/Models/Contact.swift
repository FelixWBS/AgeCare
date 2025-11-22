//
//  Contact.swift
//  AgeCare
//
//  Created by Simon on 22.11.25.
//

//
//  Contact.swift
//  AgeCare
//

import Foundation
import SwiftData

@Model
class Contact {
    var name: String
    var phone: String?
    var relation: String?   // z.B. "Arzt", "Tochter", "Nachbar"
    
    init(name: String, phone: String? = nil, relation: String? = nil) {
        self.name = name
        self.phone = phone
        self.relation = relation
    }
}
