// File: CoWorkerAI/CoWorkerAI/App/ContentView.swift
import SwiftUI

struct ContentView: View {
    @StateObject private var notesVM = NotesViewModel(repository: ServiceFactory.shared.makeNotesRepository())

    var body: some View {
        NavigationSplitView {
            List(selection: $notesVM.sidebarSelection) {
                Section("CoWorkerAI") {
                    NavigationLink(value: SidebarItem.notes) {
                        Label("Notes", systemImage: "note.text")
                    }
                }
                if !notesVM.allTags.isEmpty {
                    Section("Tags") {
                        ForEach(notesVM.allTags.sorted(), id: \.self) { tag in
                            Button {
                                notesVM.toggleTagFilter(tag)
                            } label: {
                                HStack {
                                    Image(systemName: notesVM.activeTags.contains(tag) ? "tag.fill" : "tag")
                                    Text(tag)
                                    Spacer()
                                    if notesVM.activeTags.contains(tag) {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        if !notesVM.activeTags.isEmpty {
                            Button {
                                notesVM.clearTagFilters()
                            } label: {
                                Label("Clear tag filters", systemImage: "xmark.circle")
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Features")
        } content: {
            switch notesVM.sidebarSelection {
            case .notes:
                NotesView(viewModel: notesVM)
                    .navigationTitle("Notes")
            case .none:
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome")
                        .font(.title2).fontWeight(.medium)
                    Text("Select a feature in the sidebar.")
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
        } detail: {
            if let editingNote = notesVM.editingNoteBinding {
                NoteEditorView(note: editingNote, onCommit: {
                    notesVM.saveEditingNote()
                }, onDelete: {
                    notesVM.deleteEditingNote()
                })
                .navigationTitle(editingNote.wrappedValue.title.isEmpty ? "New Note" : editingNote.wrappedValue.title)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("No Selection")
                        .font(.title2).fontWeight(.medium)
                    Text("Choose or create a note.")
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
        }
    }
}

enum SidebarItem: Hashable {
    case notes
}
