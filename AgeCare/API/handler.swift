//
//  SwiftUIView.swift
//  AgeCare
//
//  Created by Timur Hegwein on 22.11.25.
//
import SwiftUI
import SwiftData
import Foundation



        
func callServer(message: String? = nil) async {
    // Replace with your FastAPI backend URL
    
    var responseText: String = "NO TEXT"
    
    guard let url = URL(string: "http://127.0.0.1:8000/prompt") else {
        responseText = "Invalid URL"
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: ["text": message ?? ""])

    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Decode as generic dictionary
        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
            // Convert the dictionary back to pretty JSON string for display
            let prettyData = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
            if let prettyString = String(data: prettyData, encoding: .utf8) {
                responseText = prettyString
            } else {
                responseText = "Unable to convert response to string."
            }
        } else {
            responseText = "Invalid response from server"
        }
    } catch {
        responseText = "Error: \(error.localizedDescription)"
    }
}




