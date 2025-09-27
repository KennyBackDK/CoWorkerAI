// File: CoWorkerAI/CoWorkerAI/Features/Prompts/Views/PromptLibraryView.swift
import SwiftUI

struct PromptLibraryView: View {
    @ObservedObject var viewModel: PromptLibraryViewModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.filteredPrompts) { prompt in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(prompt.title)
                            .font(.headline)
                        Text(prompt.body)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .onDelete(perform: viewModel.delete)
            }
            .navigationTitle("Prompts")
            .toolbar {
                Button {
                    viewModel.addPrompt(title: "New Prompt", body: "Oprettet via +")
                } label: {
                    Image(systemName: "plus")
                }
            }
            .searchable(text: $viewModel.searchText)
        }
    }
}
