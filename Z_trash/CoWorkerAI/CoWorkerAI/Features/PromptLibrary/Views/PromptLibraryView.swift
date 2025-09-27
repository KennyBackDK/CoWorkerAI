// File: CoWorkerAI/CoWorkerAI/Features/PromptLibrary/Views/PromptLibraryView.swift
import SwiftUI

struct PromptLibraryView: View {
    @ObservedObject var viewModel: PromptLibraryViewModel
    @State private var editing: Prompt?

    var body: some View {
        VStack(spacing: 0) {
            toolbar
            Divider()
            content
        }
        .sheet(item: $editing) { prompt in
            NavigationStack {
                PromptEditorView(draft: prompt) { updated in
                    viewModel.update(updated)
                    editing = nil
                } onCancel: {
                    editing = nil
                }
            }
        }
    }

    private var toolbar: some View {
        HStack(spacing: 8) {
            Button {
                viewModel.create()
            } label: {
                Label("New", systemImage: "plus")
            }
            .keyboardShortcut("n", modifiers: [.command])

            TextField("Search prompts…", text: $viewModel.search)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 360)

            Spacer()
        }
        .padding(8)
    }

    private var content: some View {
        Table(viewModel.filtered, selection: $viewModel.selection) {
            TableColumn("Name") { p in Text(p.name) }
            TableColumn("Role") { p in Text(p.role).foregroundStyle(.secondary) }
            TableColumn("Version") { p in Text(p.version).foregroundStyle(.secondary) }
            TableColumn("Tags") { p in Text(p.tags.joined(separator: ", ")).foregroundStyle(.secondary) }
            TableColumn("Updated") { p in Text(p.updatedAt, style: .date).foregroundStyle(.secondary) }
        }
        .contextMenu(forSelectionType: Prompt.ID.self) { items in
            if let id = items.first, let prompt = viewModel.filtered.first(where: { $0.id == id }) {
                Button("Edit") { editing = prompt }
                Button("Duplicate") {
                    var copy = prompt
                    copy.id = UUID()
                    copy.name += " (copy)"
                    copy.createdAt = Date()
                    copy.updatedAt = Date()
                    viewModel.update(copy) // insert via update flow after user edits
                }
            }
        } primaryAction: { items in
            if let id = items.first, let prompt = viewModel.filtered.first(where: { $0.id == id }) {
                editing = prompt
            }
        }
        .onDeleteCommand {
            if let selection = viewModel.selection,
               let idx = viewModel.filtered.firstIndex(where: { $0.id == selection }) {
                viewModel.delete(at: IndexSet(integer: idx))
            }
        }
    }
}

