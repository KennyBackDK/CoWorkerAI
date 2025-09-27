import Foundation

final class NotesRepository: NotesRepositoryProtocol {
    private let fm = FileManager.default
    private let fileURL: URL
    private var cache: [Note] = []

    init() {
        let base = try? AppPaths.shared.appSupportDirectory()
        self.fileURL = (try? AppPaths.shared.notesFileURL())
            ?? (base ?? URL(fileURLWithPath: "/tmp")).appendingPathComponent("Notes.json")

        cache = read()
    }

    func fetchNotes() -> [Note] { cache }

    func add(note: Note) {
        cache.append(note)
        write(cache)
    }

    func delete(note: Note) {
        cache.removeAll { $0.id == note.id }
        write(cache)
    }

    func replaceAll(with notes: [Note]) {
        cache = notes
        write(cache)
    }

    // MARK: - IO
    private func read() -> [Note] {
        guard let data = try? Data(contentsOf: fileURL) else { return defaultSeed() }
        return (try? JSONDecoder().decode([Note].self, from: data)) ?? defaultSeed()
    }

    private func write(_ notes: [Note]) {
        try? AppPaths.shared.ensureAppSupportDirectory()
        if let data = try? JSONEncoder().encode(notes) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }

    private func defaultSeed() -> [Note] {
        [Note(title: "Welcome", body: "Edit or add notes")]
    }
}
