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
    @State private var transcriptController = TranscriptController()

    var body: some View {
        NavigationStack{
            VStack {
                Next_Appointments()
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
                            .frame(width: 80, height: 80)
                            .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                        Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(isRecording ? Color("BWColor"): Color.primary)
                    }
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isRecording ? "Aufnahme stoppen" : "Aufnahme starten")
                Spacer()
            }
            .background(Color("Color"))
        }
        .onAppear() {
            transcriptController = TranscriptController(appointmentController: AppointmentController(modelContext: modelContext))
        }
    }

}

#Preview {
    TopTabView()
}
