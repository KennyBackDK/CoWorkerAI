// File: CoWorkerAI/CoWorkerAI/Services/ServiceFactory.swift
import Foundation

final class ServiceFactory {
    static let shared = ServiceFactory()
    private init() {}

    func makeNotesRepository() -> NotesRepositoryProtocol { NotesRepository() }
    func makePromptRepository() -> PromptRepositoryProtocol { PromptRepository() }
}
