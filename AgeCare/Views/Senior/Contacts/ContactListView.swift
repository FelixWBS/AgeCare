//
//  ContactListView.swift
//  AgeCare
//
//  Created by Felix Weißleder on 22.11.25.
//

import SwiftUI

struct ContactListView: View {
    @State var contact: Contact
    @Environment(\.openURL) private var openURL
    
    private var initials: String {
        let parts = contact.name.split(separator: " ")
        let first = parts.first?.first.map(String.init) ?? ""
        let second = parts.dropFirst().first?.first.map(String.init) ?? ""
        return (first + second).uppercased()
    }
    
    var body: some View {
        HStack{

            // Contact information
            VStack(alignment: .leading, spacing: 4) {
                Text(contact.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                if let relation = contact.relation, !relation.isEmpty {
                    Text(relation)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                if let phone = contact.phone, !phone.isEmpty {
                    Text(phone)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }.padding(.leading)

            Spacer()

            // Quick actions
            VStack(alignment: .trailing, spacing: 12) {
                Button {
                    if let raw = contact.phone, !raw.isEmpty {
                        let digits = raw.filter { "0123456789+".contains($0) }
                        if let url = URL(string: "tel://\(digits)") {
                            openURL(url)
                        }
                    }
                } label: {
                    Image(systemName: "phone.fill")
                        .font(.title2)
                }
                .buttonStyle(.bordered)
                .tint(.green)
                .accessibilityLabel("Call \(contact.name)")
                .disabled((contact.phone?.isEmpty) ?? true)

            }.padding(.trailing)
        }
        .frame(height:120)
        .glassEffect(in: .rect(cornerRadius: 10.0))
        .mask{
            RoundedRectangle(cornerRadius: 20, style: .continuous)
        }
    }
}

#Preview {
    var mock: Contact = Contact.init(name: "Max Muster", phone: "0176 82764264", relation: "Daughter")
    ContactListView(contact: mock)
}

