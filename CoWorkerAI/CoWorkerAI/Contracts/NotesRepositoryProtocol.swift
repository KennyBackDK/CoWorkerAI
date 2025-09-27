import Foundation

protocol NotesRepositoryProtocol {
    func fetchNotes() -> [Note]
    func add(note: Note)
    func delete(note: Note)
    func replaceAll(with notes: [Note])
}
