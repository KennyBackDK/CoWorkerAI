// File: CoWorkerAI/CoWorkerAI/Contracts/Prompt.swift
import Foundation

public struct Prompt: Identifiable, Equatable, Codable {
    public let id: UUID
    public var title: String
    public var body: String

    public init(id: UUID = UUID(), title: String, body: String) {
        self.id = id
        self.title = title
        self.body = body
    }
}
