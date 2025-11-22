//
//  ContactListView.swift
//  AgeCare
//
//  Created by Felix Weißleder on 22.11.25.
//

import SwiftUI

struct AppointmentListView: View {
    @State var appointment: Appointment
    @Environment(\.openURL) private var openURL

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
                    if let location = appointment.location, !location.isEmpty {
                        Text(location)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    if let notes = appointment.notes, !notes.isEmpty {
                        Text(notes)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()

                // Quick actions
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
                    .tint(.green)
                    .accessibilityLabel("Call \(appointment.title)")
                    .disabled((appointment.phoneNumber?.isEmpty) ?? true)

                }
                
            }.padding()
            if !appointment.needRide{
                Button {
                    appointment.needRide.toggle()
                } label: {
                    Text("Request Ride")
                    Image(systemName: "car.fill")
                        .font(.title2)
                    
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .accessibilityLabel("Ride Requested")
                .padding()
            } else if let provider = appointment.rideProvider {
                Button {
                    
                } label: {
                    
                    Text(provider.name + " is taking you")
                    Image(systemName: "car.fill")
                        .font(.title2)
                    
                }
                .padding()
                .buttonStyle(.bordered)
                .tint(.green)
                .accessibilityLabel("Ride Provided")
            } else {
                Button {
                    appointment.needRide.toggle()
                } label: {
                    Text("Ride Requested")
                    Image(systemName: "car.fill")
                        .font(.title2)
                    
                }
                .buttonStyle(.bordered)
                .tint(.blue)
                .accessibilityLabel("Ride Requested")
                .padding()
            }

        }
        .background(Color("BWColor"))
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
    AppointmentListView(appointment: mock)
}



