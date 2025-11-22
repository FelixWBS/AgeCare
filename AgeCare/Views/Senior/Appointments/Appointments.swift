//
//  Appointments.swift
//  AgeCare
//
//  Created by Felix Weißleder on 22.11.25.
//

import SwiftData
import SwiftUI

struct Appointments: View {
    @Environment(\.modelContext) private var modelContext
    @Query var appointments: [Appointment]
    
    var body: some View {
        ZStack {
            Color("Color")
                .ignoresSafeArea()
            if !appointments.isEmpty {
                ScrollView(showsIndicators: false) {
                    ForEach(appointments, id: \.self) { appointment in
                        AppointmentListView(appointment: appointment)
                    }
                }
                .padding()
                
            } else {
                ContentUnavailableView(
                    "No upcoming appointments",
                    systemImage: "calendar"
                )
            }
            
        }
        
    }
    
}

#Preview {
    Appointments()
}
