// File: CoWorkerAI/CoWorkerAI/Services/ServiceFactory.swift
import Foundation

protocol ServiceFactoryProtocol {
    func makeNotesRepository() -> NotesRepository
}

final class ServiceFactory: ServiceFactoryProtocol {
    static let shared = ServiceFactory()
    private init() {}

    func makeNotesRepository() -> NotesRepository {
        do {
            let url = try AppPaths.shared.notesFileURL()
            return FileNotesRepository(fileURL: url)
        } catch {
            LoggerService.shared.error("Falling back to temp notes store due to error: \(String(describing: error))")
            let tmp = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("Notes.json")
            return FileNotesRepository(fileURL: tmp)
        }
    }
}
