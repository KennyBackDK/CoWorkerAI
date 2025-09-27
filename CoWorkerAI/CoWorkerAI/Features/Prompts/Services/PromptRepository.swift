// File: CoWorkerAI/CoWorkerAI/Features/Prompts/Services/PromptRepository.swift
import Foundation

final class PromptRepository: PromptRepositoryProtocol {
    private var storage: [Prompt] = [
        Prompt(title: "Eksempel", body: "Skriv en simpel SwiftUI view")
    ]

    func fetchPrompts() -> [Prompt] { storage }

    func add(prompt: Prompt) {
        storage.append(prompt)
    }

    func delete(prompt: Prompt) {
        storage.removeAll { $0.id == prompt.id }
    }

    func replaceAll(with prompts: [Prompt]) {
        storage = prompts
    }
}
