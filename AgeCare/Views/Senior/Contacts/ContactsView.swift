//
//  ContactsView.swift
//  AgeCare
//
//  Created by Felix Weißleder on 22.11.25.
//

import SwiftUI
import SwiftData

// MARK: - View
struct ContactsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var contacts: [Contact]
    
    var body: some View {
        if !contacts.isEmpty{
            List{
                ForEach(contacts, id: \.self) { contact in
                    ContactListView(contact: contact);
                }
            }
        } else {
            ContentUnavailableView("No Contacts", systemImage: "person")
        }
    }
}

#Preview {
    ContactsView()
}
