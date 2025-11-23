//
//  ContentView.swift
//  AgeCare
//
//  Created by Felix Weißleder on 21.11.25.
//




import SwiftUI
import SwiftData

struct HomeRelative: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isRecording: Bool = false
    @State private var transcriptController: TranscriptController? = nil
    @Query var user: [User]
    @Query var appointments: [Appointment]
    
    private var newestAppointmentWithSummary: Appointment? {
        let startOfToday = Calendar.current.startOfDay(for: Date())
        // Filter appointments with date >= startOfToday and summary not nil
        let filtered = appointments.filter { $0.date >= startOfToday && $0.summary != nil }
        // Return the appointment with the latest date (newest)
        return filtered.sorted(by: { $0.date > $1.date }).first
    }

    var body: some View {
        NavigationStack{
            ZStack{
                Color.colorRe
                    .ignoresSafeArea()
                VStack {
                    Text("Welcome " + user.first!.name + "!")
                        .padding()
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .bold()
                    Next_AppointmentsRelative()
                        .padding(.bottom)
                    HStack{
                        Spacer()
                        Text("Last Appointment:")
                            .font(.title2).bold()
                            .foregroundStyle(.primary)
                        Spacer()
                    }
                    .padding(.top)
                    if let display = newestAppointmentWithSummary{
                        AppointmentWithSummary(appointment: display)
                            .padding(.horizontal)
                    } else {
                        ContentUnavailableView("No Last Appointments", systemImage: "calendar")
                    }
                    Spacer()
                }
            }
        }
        .onAppear() {
            transcriptController = TranscriptController(appointmentController: AppointmentController(modelContext: modelContext))
        }
    }

}

#Preview {
    TopTabRelative()
}
