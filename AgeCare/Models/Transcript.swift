//
//  Transcript.swift
//  AgeCare
//
//  Created by Simon on 22.11.25.
//

import Foundation

/// Simple value model for a speech transcript.
/// Conforms to Codable for easy JSON encoding/decoding and Identifiable for SwiftUI.
public struct Transcript: Identifiable, Codable, Sendable {
    public let id: UUID
    public let text: String
    public let createdAt: Date

    public init(id: UUID = UUID(), text: String, createdAt: Date = Date()) {
        self.id = id
        self.text = text
        self.createdAt = createdAt
    }
}
