// File: CoWorkerAI/CoWorkerAI/Services/NotesRepository.swift
import Foundation

final class NotesRepository: NotesRepositoryProtocol {
    private var cache: [Note] = [
        Note(title: "Welcome", body: "Edit or add notes")
    ]

    func fetchNotes() -> [Note] { cache }

    func add(note: Note) {
        cache.append(note)
    }

    func delete(note: Note) {
        cache.removeAll { $0.id == note.id }
    }

    func replaceAll(with notes: [Note]) {
        cache = notes
    }
}
