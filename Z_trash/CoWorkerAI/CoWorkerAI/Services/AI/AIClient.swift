// File: CoWorkerAI/CoWorkerAI/Services/AI/AIClient.swift
import Foundation

/// Abstract AI client – implementations can call OpenAI/Anthropic/local models later.
protocol AIClient {
    func complete(prompt: String) async throws -> String
}

/// Dummy client used until real APIs are wired.
final class DummyAIClient: AIClient {
    func complete(prompt: String) async throws -> String {
        // Echo back for now
        return "DUMMY RESPONSE:\n" + prompt
    }
}

