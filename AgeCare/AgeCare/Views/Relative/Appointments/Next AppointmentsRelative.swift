//
//  Next Appointments.swift
//  AgeCare
//
//  Created by Felix Weißleder on 21.11.25.
//

import SwiftUI
import SwiftData

struct Next_AppointmentsRelative: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query var appointments: [Appointment]
    private var nextAppointment: Appointment? {
        let sortedAppointments = appointments.sorted { $0.date < $1.date }
        let startOfToday = Calendar.current.startOfDay(for: Date())
        return sortedAppointments.first { $0.date >= startOfToday && $0.summary == nil }
    }
    
    var body: some View {
        VStack() {
            if let next = nextAppointment {
                Text("Next Appointment:")
                    .font(.title2).bold()
                    .foregroundStyle(.primary)
                AppointmentListRelative(appointment: next)
            } else {
                ContentUnavailableView("No upcoming appointments", systemImage: "calendar")
            }
        }
        .frame(height: 200)
        .padding()
    }
}

#Preview {
    Next_AppointmentsRelative()
        .modelContainer(for: [User.self, Contact.self, Appointment.self], inMemory: true)
}
