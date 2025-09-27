// File: CoWorkerAI/CoWorkerAI/Contracts/PromptRepositoryProtocol.swift
import Foundation

struct Prompt: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var version: String            // semver e.g. "0.1.0"
    var role: String               // e.g. "programmer", "planner", "critic"
    var template: String           // the actual prompt template
    var inputs: [String]           // placeholder keys the template expects
    var tags: [String]             // e.g. ["swift", "bluetooth", "ios"]
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        version: String = "0.1.0",
        role: String = "programmer",
        template: String,
        inputs: [String] = [],
        tags: [String] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.version = version
        self.role = role
        self.template = template
        self.inputs = inputs
        self.tags = tags
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

enum PromptRunStatus: String, Codable {
    case success, failure
}

struct PromptRun: Identifiable, Codable, Equatable {
    var id: UUID
    var promptId: UUID
    var timestamp: Date
    var model: String          // which model was used (router result)
    var tokens: Int
    var latencyMs: Int
    var status: PromptRunStatus
    var notes: String?

    init(
        id: UUID = UUID(),
        promptId: UUID,
        timestamp: Date = Date(),
        model: String,
        tokens: Int = 0,
        latencyMs: Int = 0,
        status: PromptRunStatus = .success,
        notes: String? = nil
    ) {
        self.id = id
        self.promptId = promptId
        self.timestamp = timestamp
        self.model = model
        self.tokens = tokens
        self.latencyMs = latencyMs
        self.status = status
        self.notes = notes
    }
}

protocol PromptRepositoryProtocol {
    func loadPrompts() -> [Prompt]
    func savePrompts(_ prompts: [Prompt])
    func loadRuns() -> [PromptRun]
    func appendRun(_ run: PromptRun)
}

