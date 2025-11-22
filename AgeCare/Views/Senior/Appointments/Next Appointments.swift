//
//  Next Appointments.swift
//  AgeCare
//
//  Created by Felix Weißleder on 21.11.25.
//

import SwiftUI
import SwiftData

struct Next_Appointments: View {
    @Environment(\.modelContext) private var modelContext
    @Query var appointments: [Appointment]
    
    private var nextAppointment: Appointment? {
        appointments.first { $0.date >= Date() }
    }
    
    var body: some View {
        VStack() {
            if let next = nextAppointment {
                Text("Next Appointment:")
                    .font(.title2).bold()
                    .foregroundStyle(.primary)
                AppointmentListView(appointment: next)
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
}
