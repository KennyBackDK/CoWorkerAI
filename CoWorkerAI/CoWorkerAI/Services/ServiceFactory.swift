// File: CoWorkerAI/CoWorkerAI/Services/ServiceFactory.swift
import Foundation

/// Central fabrik for appens services/repositories.
/// Bruges fra UI (ContentView) til at få konkrete implementationer.
final class ServiceFactory {
    static let shared = ServiceFactory()
    private init() {}

    // MARK: - Notes

    /// Returnér en konkret notes-repository.
    /// Skift implementation her, hvis du senere vil bruge en anden kilde.
    func makeNotesRepository() -> NotesRepositoryProtocol {
        NotesRepository()
    }

    // MARK: - Prompts

    /// Returnér en konkret prompts-repository.
    func makePromptRepository() -> PromptRepositoryProtocol {
        PromptRepository()
    }
}
