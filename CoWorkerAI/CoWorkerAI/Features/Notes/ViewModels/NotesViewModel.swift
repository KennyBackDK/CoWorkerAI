// File: CoWorkerAI/CoWorkerAI/Features/Notes/ViewModels/NotesViewModel.swift
import Foundation
import SwiftUI
import Combine

@MainActor
final class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var searchText: String = ""
    @Published var activeTags: Set<String> = []
    @Published var filteredNotes: [Note] = []
    @Published var selection: Note.ID?
    @Published var sidebarSelection: SidebarItem? = .notes

    private var searchTask: Task<Void, Never>?
    private let repository: NotesRepository

    private var cancellables: Set<AnyCancellable> = []

    init(repository: NotesRepository) {
        self.repository = repository
        Task {
            await load()
        }
        setupBindings()
    }

    var allTags: Set<String> {
        Set(notes.flatMap { $0.tags.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) } }.filter { !$0.isEmpty })
    }

    var editingNoteBinding: Binding<Note>? {
        guard let id = selection, let idx = filteredNotes.firstIndex(where: { $0.id == id }) else { return nil }
        return Binding<Note>(
            get: { self.filteredNotes[idx] },
            set: { newValue in
                self.update(note: newValue)
            }
        )
    }

    func setupBindings() {
        $searchText
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.debouncedFilter()
            }
            .store(in: &cancellables)

        $activeTags
            .sink { [weak self] _ in
                self?.applyFilters()
            }
            .store(in: &cancellables)

        $notes
            .sink { [weak self] _ in
                self?.applyFilters()
                Task { await self?.persist() }
            }
            .store(in: &cancellables)
    }

    func load() async {
        do {
            let loaded = try await repository.loadAll()
            await MainActor.run {
                self.notes = loaded.sorted(by: { $0.updatedAt > $1.updatedAt })
            }
        } catch {
            LoggerService.shared.error("Failed to load notes: \(String(describing: error))")
            await MainActor.run {
                self.notes = []
            }
        }
    }

    func persist() async {
        do {
            try await repository.saveAll(notes)
        } catch {
            LoggerService.shared.error("Failed to save notes: \(String(describing: error))")
        }
    }

    func debouncedFilter(delayMs: UInt64 = 250) {
        searchTask?.cancel()
        searchTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: delayMs * 1_000_000)
            await MainActor.run {
                self?.applyFilters()
            }
        }
    }

    func applyFilters() {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let tagFilters = activeTags

        var base = notes

        if !tagFilters.isEmpty {
            base = base.filter { !tagFilters.isDisjoint(with: Set($0.tags.map { $0.lowercased() })) }
        }

        if !q.isEmpty {
            base = base.filter { note in
                note.title.lowercased().contains(q) ||
                note.body.lowercased().contains(q) ||
                note.tags.contains(where: { $0.lowercased().contains(q) })
            }
        }

        filteredNotes = base.sorted(by: { $0.updatedAt > $1.updatedAt })

        if let sel = selection, !filteredNotes.contains(where: { $0.id == sel }) {
            selection = filteredNotes.first?.id
        }
    }

    func toggleTagFilter(_ tag: String) {
        if activeTags.contains(tag) {
            activeTags.remove(tag)
        } else {
            activeTags.insert(tag)
        }
    }

    func clearTagFilters() {
        activeTags.removeAll()
    }

    func createNote() {
        var new = Note()
        new.title = "Untitled"
        new.updatedAt = Date()
        notes.insert(new, at: 0)
        applyFilters()
        selection = new.id
    }

    func delete(at offsets: IndexSet) {
        let ids = offsets.compactMap { filteredNotes[$0].id }
        notes.removeAll { ids.contains($0.id) }
        applyFilters()
    }

    func deleteEditingNote() {
        guard let id = selection else { return }
        notes.removeAll { $0.id == id }
        selection = nil
        applyFilters()
    }

    func saveEditingNote() {
        guard let id = selection, let idx = notes.firstIndex(where: { $0.id == id }) else { return }
        notes[idx].updatedAt = Date()
        applyFilters()
        Task { await persist() }
    }

    func update(note: Note) {
        if let idx = notes.firstIndex(where: { $0.id == note.id }) {
            var updated = note
            updated.updatedAt = Date()
            notes[idx] = updated
        } else {
            notes.insert(note, at: 0)
        }
        applyFilters()
    }
}
