//
//  Appointments.swift
//  AgeCare
//
//  Created by Felix Weißleder on 22.11.25.
//

import SwiftUI
import SwiftData

struct Summaries: View {
    @Environment(\.modelContext) private var modelContext
    @Query var appointments: [Appointment]
    
    var body: some View {
        ZStack{
            Color.colorRe
                .ignoresSafeArea()
            if !appointments.isEmpty{
                ScrollView(showsIndicators: false){
                    ForEach(appointments, id: \.self) { appointment in
                        if appointment.summary != nil {
                            AppointmentWithSummary(appointment: appointment);
                        }
                    }
                }
                .padding()
            } else {
                ContentUnavailableView("No upcoming appointments", systemImage: "calendar")
            }
        }
    }
}

#Preview {
    AppointmentsRelative()
}
