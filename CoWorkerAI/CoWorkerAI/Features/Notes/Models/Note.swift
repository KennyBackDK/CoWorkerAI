// File: CoWorkerAI/CoWorkerAI/Features/Notes/Models/Note.swift
import Foundation

struct Note: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var body: String
    var tags: [String]
    var createdAt: Date
    var updatedAt: Date

    init(id: UUID = UUID(), title: String = "", body: String = "", tags: [String] = [], createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id
        self.title = title
        self.body = body
        self.tags = tags
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
