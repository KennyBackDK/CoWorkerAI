// File: CoWorkerAI/CoWorkerAI/App/ContentView.swift
import SwiftUI

struct ContentView: View {
    @StateObject private var notesVM: NotesViewModel
    @StateObject private var promptsVM: PromptLibraryViewModel

    init() {
        // Repos
        let repoNotes: NotesRepositoryProtocol = ServiceFactory.shared.makeNotesRepository()
        let repoPrompts: PromptRepositoryProtocol = ServiceFactory.shared.makePromptRepository()

        // StateObjects
        _notesVM = StateObject(wrappedValue: NotesViewModel(repository: repoNotes))
        _promptsVM = StateObject(wrappedValue: PromptLibraryViewModel(repository: repoPrompts))
    }

    var body: some View {
        TabView {
            // NOTES
            NavigationStack {
                List {
                    ForEach(notesVM.filteredNotes) { (note: Note) in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(note.title).font(.headline)
                            Text(note.body).font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: notesVM.delete)
                }
                .navigationTitle("Notes")
                .toolbar {
                    Button { notesVM.addSampleNote() } label: {
                        Image(systemName: "plus")
                    }
                }
                .searchable(text: Binding(
                    get: { notesVM.searchQuery },
                    set: { notesVM.searchQuery = $0 }
                ))
            }
            .tabItem { Label("Notes", systemImage: "note.text") }

            // PROMPTS
            PromptLibraryView(viewModel: promptsVM)
                .tabItem { Label("Prompts", systemImage: "text.alignleft") }
        }
    }
}
