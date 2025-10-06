// File: CoWorkerAI/CoWorkerAI/Features/Chat/Models/Chat.swift
import Foundation

/// En komplet chatmodel, klar til JSON-persistens og SwiftUI-visning.
struct Chat: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var createdAt: Date
    var updatedAt: Date
    var messages: [Message]

    init(
        id: UUID = UUID(),
        title: String = "Ny chat",
        createdAt: Date = .now,
        updatedAt: Date = .now,
        messages: [Message] = []
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.messages = messages
    }
}

/// En enkelt besked i chatten.
struct Message: Identifiable, Codable, Equatable {
    var id: UUID
    var role: Role
    var content: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        role: Role,
        content: String,
        createdAt: Date = .now
    ) {
        self.id = id
        self.role = role
        self.content = content
        self.createdAt = createdAt
    }
}

/// Angiver hvem der har skrevet beskeden.
enum Role: String, Codable, CaseIterable, Equatable {
    case user
    case assistant
    case system
}
