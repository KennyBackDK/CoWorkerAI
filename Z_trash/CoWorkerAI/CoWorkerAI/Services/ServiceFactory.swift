// File: CoWorkerAI/CoWorkerAI/Services/ServiceFactory.swift
import Foundation

final class ServiceFactory {
    static let shared = ServiceFactory()
    private init() {}

    // NOTES
    func makeNotesRepository() -> NotesRepositoryProtocol { NotesRepository() }

    // PROMPTS
    func makePromptRepository() -> PromptRepositoryProtocol { PromptRepository() }
}
