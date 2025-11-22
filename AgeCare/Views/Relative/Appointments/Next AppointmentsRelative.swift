//
//  Next Appointments.swift
//  AgeCare
//
//  Created by Felix Weißleder on 21.11.25.
//

import SwiftUI
import SwiftData

struct Next_AppointmentsRealtive: View {
    @Environment(\.modelContext) private var modelContext
    @Query var appointments: [Appointment]
    
    
    var body: some View {
        VStack() {
            if !appointments.isEmpty {
                Text("Next Appointment:")
                    .font(.title2).bold()
                    .foregroundStyle(.primary)
               AppointmentListRelative(appointment: appointments.first!)
            } else {
                ContentUnavailableView("No upcoming appointments", systemImage: "calendar")
            }
        }
        .frame(height: 200)
        .padding()
    }
}

#Preview {
    Next_Appointments()
        .modelContainer(for: [User.self, Contact.self, Appointment.self], inMemory: true)
}
