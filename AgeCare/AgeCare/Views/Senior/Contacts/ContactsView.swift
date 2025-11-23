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
        ZStack{
            Color.color
                .ignoresSafeArea()
            if !contacts.isEmpty{
                ScrollView(showsIndicators: false) {
                    VStack{
                        ForEach(contacts, id: \.self) { contact in
                            ContactListView(contact: contact);
                        }
                    }.padding()
                }
                
            } else {
                ContentUnavailableView("No Contacts", systemImage: "person")
            }
        }
    }
}

#Preview {
    ContactsView()
}
