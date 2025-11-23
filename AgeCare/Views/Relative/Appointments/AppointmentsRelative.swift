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
    @State private var sortedAppointments: [Appointment]? = nil
    
    var body: some View {
        ZStack{
            Color.colorRe
                .ignoresSafeArea()
            if let sAppointments = sortedAppointments{
                if !sAppointments.isEmpty{
                    ScrollView(showsIndicators: false){
                        VStack{
                            ForEach(sAppointments, id: \.self) { appointment in
                                if appointment.summary == nil {
                                    AppointmentListRelative(appointment: appointment);
                                }
                            }
                        }
                        .padding()
                    }
                } else {
                    ContentUnavailableView("No appointments", systemImage: "calendar")
                }
            }
        }
        .onAppear(){
            sortedAppointments = appointments.sorted { $0.date < $1.date }
        }
    }
}

#Preview {
    AppointmentsRelative()
}
