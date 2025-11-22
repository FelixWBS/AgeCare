//
//  RecordSummary.swift
//  AgeCare
//
//  Created by Felix Weißleder on 22.11.25.
//

import SwiftUI
import SwiftData

struct RecordSummary: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isRecording: Bool = false
    @State var transcriptController: TranscriptController
    @Binding var atDoctor: Bool
    @Query var user: [User]
    
    var body: some View {
        ZStack{
            Color("record")
                .ignoresSafeArea()
            VStack{
                Text("Welcome " + user.first!.name + "!")
                    .padding()
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .bold()
                Text("You should be at an appointment at the Moment. Record it!")
                    .padding()
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .bold()
                    .multilineTextAlignment(.center)
                Spacer()
                Button(action: {
                    if isRecording {
                        transcriptController.stopRecording()
                    } else {
                        transcriptController.startRecording()
                    }
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isRecording.toggle()
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
            
        }
        
    }
}
/*
 #Preview {
 RecordSummary()
 .modelContainer(for: [User.self, Contact.self, Appointment.self], inMemory: true)
 }
 */
