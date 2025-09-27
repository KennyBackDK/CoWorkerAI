// File: CoWorkerAI/CoWorkerAI/Contracts/PromptRepositoryProtocol.swift
import Foundation

protocol PromptRepositoryProtocol {
    func fetchPrompts() -> [Prompt]
    func add(prompt: Prompt)
    func delete(prompt: Prompt)
    func replaceAll(with prompts: [Prompt])
}
