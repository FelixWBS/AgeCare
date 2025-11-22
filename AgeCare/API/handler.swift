//
//  SwiftUIView.swift
//  AgeCare
//
//  Created by Timur Hegwein on 22.11.25.
//
import SwiftUI
import SwiftData


struct handler: View {
    
    @State private var responseText: String = "Waiting for response..."
    
    @Environment(\.modelContext) private var modelContext
    @Query var contacts: [Contact]
        
    var body: some View {
        Button(action: {
            Task {
                await callServer(message: "Create a short docter appointment next week for me")
            }
        }){
            Text(responseText)
        }
    }
    
    
    func callServer(message: String? = nil) async {
        // Replace with your FastAPI backend URL
        guard let url = URL(string: "http://127.0.0.1:8000/prompt") else {
            responseText = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Sending empty JSON since backend is hardcoded for now
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["text": message])

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: String],
               let serverResponse = json["response"] {
                responseText = serverResponse
            } else {
                responseText = "Invalid response from server"
            }
        } catch {
            responseText = "Error: \(error.localizedDescription)"
        }
    }
}




#Preview {
    handler()
}
