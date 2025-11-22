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

    var body: some View {
        NavigationStack{
            ZStack{
                Color.colorRe
                    .ignoresSafeArea()
                VStack {
                    Next_AppointmentsRelative()
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
                                .frame(width: 80, height: 80)
                                .glassEffect(isRecording ? .regular.tint(.red).interactive(): .regular.interactive())
                                
                            Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundStyle(isRecording ? Color.white : Color.black)
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(isRecording ? "Aufnahme stoppen" : "Aufnahme starten")
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
