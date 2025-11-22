//
//  ContactsView.swift
//  AgeCare
//
//  Created by Felix Weißleder on 22.11.25.
//

import SwiftUI
import Contacts

// MARK: - View
struct ContactsView: View {
    @Environment(\.modelContext) private var modelContext
    @State var contacts: [String] = []
    
    var body: some View {
        List{
            ForEach(contacts, id: \.self) { contact in
                Text("Test")
            }
        }
    }
}

#Preview {
    ContactsView()
}
