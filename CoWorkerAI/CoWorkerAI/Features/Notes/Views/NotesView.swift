// File: CoWorkerAI/CoWorkerAI/Features/Notes/Views/NotesView.swift
import SwiftUI

struct NotesView: View {
    @ObservedObject var viewModel: NotesViewModel

    var body: some View {
        VStack(spacing: 0) {
            toolbar
            Divider()
            content
        }
    }

    // MARK: - Toolbar
    private var toolbar: some View {
        HStack(spacing: 8) {
            Button {
                viewModel.addSampleNote()
            } label: {
                Label("New", systemImage: "plus")
            }
            .keyboardShortcut("n", modifiers: [.command])

            TextField("Search title or body…", text: $viewModel.searchQuery)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 400)

            Spacer()
        }
        .padding(8)
    }

    // MARK: - Content
    private var content: some View {
        List {
            ForEach(viewModel.filteredNotes) { note in
                VStack(alignment: .leading, spacing: 4) {
                    Text(note.title)
                        .font(.headline)
                    Text(note.body)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .onDelete(perform: viewModel.delete)
        }
    }
}
