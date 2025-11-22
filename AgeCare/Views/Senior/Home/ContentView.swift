//
//  ContentView.swift
//  AgeCare
//
//  Created by Felix Weißleder on 21.11.25.
//




import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isRecording: Bool = false
    @State private var atDoctor: Bool = true
    @State private var transcriptController: TranscriptController? = nil
    @Query var user: [User]
    @Query var appointments: [Appointment]
    
    private var nextAppointment: Appointment? {
        let startOfToday = Calendar.current.startOfDay(for: Date())
        return appointments.first { $0.date >= startOfToday }
    }
    
    var body: some View {
        NavigationStack{
            if atDoctor {
                RecordSummary(transcriptController: transcriptController ?? TranscriptController(appointmentController: AppointmentController(modelContext: modelContext)), appointment: nextAppointment!, atDoctor: $atDoctor )
            } else {
                VStack {
                    Text("Welcome " + user.first!.name + "!")
                        .padding()
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .bold()
                    Next_Appointments()
                        .padding(.top)
                    Spacer()
                    Button(action: {
                        if let controller = transcriptController{
                            if isRecording {
                                controller.stopRecording()
                            } else {
                                controller.startRecording()
                            }
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isRecording.toggle()
                            }
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(isRecording ? Color.red : Color("BWColor"))
                                .frame(width: 150, height: 150)
                                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                            Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                                .font(.system(size: 50, weight: .bold))
                                .foregroundStyle(isRecording ? Color("BWColor"): Color.primary)
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(isRecording ? "Aufnahme stoppen" : "Aufnahme starten")
                    Spacer()
                }
                .background(Color("Color"))
            }
        }
        .onAppear() {
            if let appointment = nextAppointment {
                print(appointment.date.distance(to: Date.now))
                if appointment.date.distance(to: Date.now) < 300 {
                    atDoctor = true
                } else if appointment.date.distance(to: Date.now) > 3600 && !isRecording{
                    atDoctor = false
                }
            }
            transcriptController = TranscriptController(appointmentController: AppointmentController(modelContext: modelContext))
        }
    }

}

#Preview {
    TopTabView()
        .modelContainer(for: [User.self, Contact.self, Appointment.self], inMemory: true)
}
