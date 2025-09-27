// File: CoWorkerAI/CoWorkerAI/Features/Prompts/Views/PromptLibraryView.swift
import SwiftUI

struct PromptLibraryView: View {
    @ObservedObject var viewModel: PromptLibraryViewModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.filteredPrompts) { (p: Prompt) in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(p.title).font(.headline)
                        Text(p.body).font(.subheadline).foregroundStyle(.secondary)
                    }
                }
                .onDelete(perform: viewModel.delete)
            }
            .navigationTitle("Prompts")
            .toolbar {
                Button { viewModel.addSamplePrompt() } label: {
                    Image(systemName: "plus")
                }
            }
            .searchable(text: Binding(
                get: { viewModel.searchText },
                set: { viewModel.searchText = $0 }
            ))
        }
    }
}
