//
//  Tabs.swift
//  AgeCare
//
//  Created by Felix Weißleder on 21.11.25.
//

import SwiftUI

enum Tabs:  Equatable, Hashable, Identifiable {
    case home
    case contacts
    case appointments
    case summaries
    
    var id: Int {
        switch self {
            case .home: 0
            case .contacts: 1
            case .appointments: 2
            case .summaries: 3
        }
    }
}
