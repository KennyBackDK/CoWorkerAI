// File: CoWorkerAI/CoWorkerAI/Features/Prompts/Services/PromptRepository.swift
import Foundation

/// Simpel in-memory repo (stabilt at kompilere).
/// Du kan senere skifte til disk-persistens ligesom NotesRepository.
final class PromptRepository: PromptRepositoryProtocol {
    private var cache: [Prompt] = [
        Prompt(title: "Programmer-AI baseline",
               body: "Skriv kode slavisk. Vis hele filer. Forklar minimalt.")
    ]

    func fetchPrompts() -> [Prompt] { cache }

    func add(prompt: Prompt) {
        cache.append(prompt)
    }

    func delete(prompt: Prompt) {
        cache.removeAll { $0.id == prompt.id }
    }

    func replaceAll(with prompts: [Prompt]) {
        cache = prompts
    }
}
