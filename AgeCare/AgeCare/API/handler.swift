//
//  SwiftUIView.swift
//  AgeCare
//
//  Created by Timur Hegwein on 22.11.25.
//
import SwiftUI
import SwiftData
import Foundation





func callServer_summary(text: String, appointment: Appointment) async {
    guard let url = URL(string: "https://ada2cb9a48ed.ngrok-free.app/summary") else { return }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body: [String: Any] = ["text": text]
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Decode JSON as dictionary
        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
           let response = json["response"] as? String {
            print("Summary: \(response)")
            
            appointment.summary = response
        } else {
            print("Invalid JSON format")
        }
    } catch {
        print("Fehler beim Zusammenfassen: \(error)")
    }
}



func callServer(message: String? = nil, appointmentController: AppointmentController) async {
    // Replace with your FastAPI backend URL
    
    
    var responseText: String = "NO TEXT"
    
    guard let url = URL(string: "https://ada2cb9a48ed.ngrok-free.app/appointment") else {
        responseText = "Invalid URL"
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: ["text": message ?? ""])
    
    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // 1️⃣ Top-Level JSON
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let response = json["response"] as? [String: Any] else {
            print("❌ Ungültige Serverantwort")
            return
        }
        
        // 2️⃣ Appointment-String extrahieren
        if var appointmentString = response["appointment"] as? String {
            // Backticks und ```json entfernen
            appointmentString = appointmentString
                .replacingOccurrences(of: "```json", with: "")
                .replacingOccurrences(of: "```", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            // 3️⃣ String in Data umwandeln
            if let appointmentData = appointmentString.data(using: .utf8),
               let appointmentDict = try JSONSerialization.jsonObject(with: appointmentData) as? [String: Any] {
                
                let title = appointmentDict["title"] as? String ?? "Termin"
                let nameOfDoctor = appointmentDict["nameOfDoctor"] as? String ?? "Unbekannt"
                let dateString = appointmentDict["date"] as? String ?? ""
                let location = appointmentDict["location"] as? String
                let phoneNumber = appointmentDict["phoneNumber"] as? String
                let notes = appointmentDict["notes"] as? String
                
                // Datum konvertieren
                if let date = ISO8601DateFormatter().date(from: dateString) {
                    
                    
                    let _ = appointmentController.add(
                        title: title,
                        nameOfDoctor: nameOfDoctor,
                        date: date,
                        location: location,
                        phoneNumber: phoneNumber,
                        notes: notes
                    )
                    print("✅ Termin erstellt")
                    
                    
                    
                } else {
                    print("❌ Ungültiges Datum")
                }
                
            } else {
                print("❌ Konnte appointment JSON nicht parsen")
            }
        }
        
        // 4️⃣ Notification extrahieren
        if let notification = response["notification"] as? String {
            print("Notification: \(notification)")
        }
        
    } catch {
        print("❌ Fehler beim Parsen: \(error.localizedDescription)")
    }
    
}




