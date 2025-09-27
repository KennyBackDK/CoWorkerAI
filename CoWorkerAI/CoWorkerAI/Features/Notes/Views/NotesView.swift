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

    private var toolbar: some View {
        HStack(spacing: 8) {
            Button {
                viewModel.createNote()
            } label: {
                Label("New", systemImage: "plus")
            }
            .keyboardShortcut("n", modifiers: [.command])

            TextField("Search title, body, tags…", text: $viewModel.searchText)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 400)

            if !viewModel.activeTags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(Array(viewModel.activeTags).sorted(), id: \.self) { tag in
                            HStack(spacing: 4) {
                                Image(systemName: "tag.fill")
                                Text(tag)
                                Button {
                                    viewModel.toggleTagFilter(tag)
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                }
                                .buttonStyle(.borderless)
                            }
                            .padding(.vertical, 4).padding(.horizontal, 8)
                            .background(.quaternary, in: Capsule())
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Spacer()
            }
        }
        .padding(8)
    }

    private var content: some View {
        Table(viewModel.filteredNotes, selection: $viewModel.selection) {
            TableColumn("Title", value: \.title)
            TableColumn("Tags") { note in
                Text(note.tags.joined(separator: ", "))
                    .foregroundStyle(.secondary)
            }
            TableColumn("Updated") { note in
                Text(note.updatedAt, style: .date)
                    .foregroundStyle(.secondary)
            }
        }
        .tableStyle(.inset)
    }
}

