//
//  ContactListView.swift
//  AgeCare
//
//  Created by Felix Weißleder on 22.11.25.
//

import SwiftUI
import SwiftData

struct AppointmentWithSummary: View {
    @State var appointment: Appointment
    @Environment(\.openURL) private var openURL
    @Query var user: [User]
    @State private var string: String = ""

    var body: some View {
        VStack {
            
            HStack {
                
                // Contact information
                VStack(alignment: .leading, spacing: 4) {
                    Text(appointment.title)
                        .font(.title)
                        .foregroundStyle(.primary)
                        .bold()
                    HStack{
                        Text(appointment.date, format: .dateTime.weekday(.wide))
                        Text(appointment.date, format: .dateTime.day().month().year())
                        
                        Text(appointment.date, format: .dateTime.hour().minute())
                    }
                    .font(.headline)
                    .foregroundStyle(.primary)
                    
                    Text(appointment.nameOfDoctor)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    if let summary = appointment.summary, !summary.isEmpty {
                        Text(summary)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                            .onAppear(){
                                string = summary
                            }
                    }
                }.padding(.top)
                Spacer()

                // Quick actions
                
            }.padding()
                
            HStack{
                Spacer()
                VStack(alignment: .trailing, spacing: 12) {
                    Button {
                        if let raw = appointment.phoneNumber, !raw.isEmpty {
                            let digits = raw.filter {
                                "0123456789+".contains($0)
                            }
                            if let url = URL(string: "tel://\(digits)") {
                                openURL(url)
                            }
                        }
                    } label: {
                        Image(systemName: "phone.fill")
                            .font(.title2)
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                    .accessibilityLabel("Call \(appointment.title)")
                    .disabled((appointment.phoneNumber?.isEmpty) ?? true)

                }.padding(.trailing)
                Spacer()
            }.padding()
            
            

        }
        .onAppear(){
            print(user.first!.name)
        }
        .glassEffect(in: .rect(cornerRadius: 10.0))
        .mask {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
        }
    }
}

#Preview {
    var mock: Appointment = Appointment.init(
        title: "Checkup Appointment",
        nameOfDoctor: "Dr. Fantasic",
        date: Date.now,
        location: "Boltzmanstraße 1",
        phoneNumber: "0176 82764264",
        notes: "Regular chekup appointment with Dr. Fantasic"
    )
    
    AppointmentWithSummary(appointment: mock)
}
