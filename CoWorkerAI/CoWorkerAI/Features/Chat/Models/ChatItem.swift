// File: Features/Chat/Models/ChatItem.swift

import Foundation

// MARK: - ChatMessage

public struct ChatMessage: Codable, Identifiable, Hashable {
    public let id: UUID
    public var role: String      // "user" eller "assistant"
    public var content: String
    public var timestamp: Date

    public init(id: UUID = UUID(), role: String, content: String, timestamp: Date = .now) {
        self.id = id
        self.role = role
        self.content = content
        self.timestamp = timestamp
    }
}

// MARK: - ChatItem

public struct ChatItem: Codable, Identifiable, Hashable {
    public let id: UUID
    public var title: String
    public var messages: [ChatMessage]
    public var createdAt: Date

    public init(id: UUID = UUID(), title: String, messages: [ChatMessage] = [], createdAt: Date = .now) {
        self.id = id
        self.title = title
        self.messages = messages
        self.createdAt = createdAt
    }
}
