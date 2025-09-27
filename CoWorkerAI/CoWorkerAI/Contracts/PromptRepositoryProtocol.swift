// File: CoWorkerAI/CoWorkerAI/Contracts/PromptRepositoryProtocol.swift
import Foundation

public protocol PromptRepositoryProtocol {
    func fetchPrompts() -> [Prompt]
    func add(prompt: Prompt)
    func delete(prompt: Prompt)
}
