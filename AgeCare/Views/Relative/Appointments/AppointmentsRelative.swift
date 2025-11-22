//
//  Appointments.swift
//  AgeCare
//
//  Created by Felix Weißleder on 22.11.25.
//

import SwiftUI
import SwiftData

struct AppointmentsRelative: View {
    @Environment(\.modelContext) private var modelContext
    @Query var appointments: [Appointment]
    
    var body: some View {
        if !appointments.isEmpty{
            List{
                ForEach(appointments, id: \.self) { appointment in
                    AppointmentListView(appointment: appointment);
                }
            }
        } else {
            ContentUnavailableView("No upcoming appointments", systemImage: "calendar")
        }
    }
}

#Preview {
    AppointmentsRelative()
}
