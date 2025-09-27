import Foundation
import Combine

final class NotesViewModel: ObservableObject {
    @Published var allNotes: [Note] = []
    @Published var filteredNotes: [Note] = []
    @Published var searchQuery: String = ""

    private let repository: NotesRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(repository: NotesRepositoryProtocol) {
        self.repository = repository
        load()

        $searchQuery
            .removeDuplicates()
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main)
            .sink { [weak self] q in self?.applyFilter(q) }
            .store(in: &cancellables)
    }

    // MARK: - Data
    func load() {
        let fetched = repository.fetchNotes()
        allNotes = fetched
        filteredNotes = fetched
    }

    private func applyFilter(_ q: String) {
        guard !q.isEmpty else { filteredNotes = allNotes; return }
        filteredNotes = allNotes.filter {
            $0.title.localizedCaseInsensitiveContains(q) ||
            $0.body.localizedCaseInsensitiveContains(q)
        }
    }

    // MARK: - Actions
    func addSampleNote() {
        let n = Note(title: "Ny note", body: "Oprettet via +")
        repository.add(note: n)
        load()
    }

    func save(_ updated: Note) {
        // simple replace-by-id
        if let idx = allNotes.firstIndex(where: { $0.id == updated.id }) {
            allNotes[idx] = updated
        }
        repository.replaceAll(with: allNotes)
        applyFilter(searchQuery)
    }

    func delete(at offsets: IndexSet) {
        for i in offsets {
            let n = filteredNotes[i]
            repository.delete(note: n)
        }
        load()
    }

    func delete(note: Note) {
        repository.delete(note: note)
        load()
    }
}
