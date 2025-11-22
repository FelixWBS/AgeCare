//
//  OnboardingView.swift
//  AgeCare
//
//  Created by Felix Weißleder on 22.11.25.
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var user: [User]
    @State var showSenior: Bool = false
    @State var showRelative: Bool = false
    private var userController: UserController {
        UserController(modelContext: modelContext)
    }
    private var contactController: ContactController {
        ContactController(modelContext: modelContext)
    }
    private var appointmentController: AppointmentController {
        AppointmentController(modelContext: modelContext)
    }
    var body: some View {
        VStack{
            if user.isEmpty{
                Button(action: {
                    print("Test")
                    userController.add(name: "Hildegart", role: UserRole.senior)
                    userController.add(name: "Tatiana", role: UserRole.relative)
                    contactController.add(name: "Tatiana", phone: "0152 24608530", relation: "Daughter")
                    contactController.add(name: "Dr.Fantasic", phone: "01512 9709955", relation: "Family Doctor")
                    appointmentController.add(title: "Checkup Appointment",nameOfDoctor: "Dr. Fantasic",
                                              date: Date.now,
                                              location: "Boltzmanstraße 1",
                                              phoneNumber: "0176 82764264",
                                              notes: "Regular chekup appointment with Dr. Fantasic")
                    appointmentController.add(title: "Checkup Appointment 2",nameOfDoctor: "Dr. Fantasic",
                                              date: Calendar.current.date(byAdding: .day, value: 1, to: Date.now)!,
                                              location: "Boltzmanstraße 1",
                                              phoneNumber: "0176 82764264",
                                              notes: "Regular chekup appointment with Dr. Fantasic")
                    
                }){
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 80, height: 80)
                            .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                        Text("Start")
                        
                    }
                }
                .buttonStyle(.plain)
            } else {
                if showSenior {
                    TopTabView()
                } else if showRelative{
                    TopTabRelative()
                } else {
                    Spacer()
                    Button(action: {
                        showSenior = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 80, height: 80)
                                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                            Text("🧓")
                            
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Senior")
                    Text("Senior")
                        .bold()
                    Spacer()
                    Button(action: {
                        showRelative = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 80, height: 80)
                                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                            Text("🤝")
                            
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("relative")
                    Text("Relative")
                        .bold()
                    Spacer()
                    
                }
            }
        }
        .onAppear(){
            NotificationController().requestAuthorization()
        }
    }
}
    

#Preview {
    OnboardingView()
        .modelContainer(for: [User.self, Contact.self, Appointment.self], inMemory: true)
}
