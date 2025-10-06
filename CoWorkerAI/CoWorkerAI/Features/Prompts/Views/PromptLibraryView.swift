// File: CoWorkerAI/CoWorkerAI/Features/Prompts/Views/PromptLibraryView.swift
import SwiftUI
import Foundation

struct PromptLibraryView: View {

    // MARK: - Dependencies
    private let repo = PromptRepository()

    // MARK: - State
    @State private var prompts: [Prompt] = []
    @State private var search: String = ""
    @State private var selectionId: UUID?

    // MARK: - Body
    var body: some View {
        NavigationSplitView {
            VStack(spacing: 8) {

                // Søgefelt
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Søg i titel eller tekst …", text: $search)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal)

                // Liste
                List(selection: $selectionId) {
                    ForEach(filteredPrompts, id: \.id) { p in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(p.title.isEmpty ? "Unavngivet" : p.title)
                                .font(.headline)
                                .lineLimit(1)

                            if !p.body.isEmpty {
                                Text(p.body)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                        }
                        .padding(.vertical, 4)
                        .tag(p.id)
                        .contextMenu {
                            Button(action: { duplicate(p) }) {
                                Label("Duplikér", systemImage: "plus.square.on.square")
                            }
                            Button(role: .destructive, action: { delete(p) }) {
                                Label("Slet", systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(.inset)
                .navigationTitle("Prompt Library")
                .toolbar {
                    ToolbarItemGroup {
                        Button(action: addPrompt) {
                            Label("Ny", systemImage: "plus")
                        }
                        .help("Opret ny prompt")
                    }
                }
            }
        } detail: {
            if let p = selectedPrompt {
                PromptRunView(prompt: p)
                    .navigationTitle(p.title.isEmpty ? "Prompt" : p.title)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "text.badge.plus")
                        .font(.system(size: 48, weight: .light))
                    Text("Vælg eller opret en prompt.")
                        .font(.title3)
                    Text("Klik på + i venstre side for at lave den.")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear(perform: load)
    }

    // MARK: - Computed
    private var filteredPrompts: [Prompt] {
        let q = search.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return prompts }
        return prompts.filter { $0.title.lowercased().contains(q) || $0.body.lowercased().contains(q) }
    }

    private var selectedPrompt: Prompt? {
        prompts.first { $0.id == selectionId }
    }

    // MARK: - Actions
    private func load() {
        prompts = repo.fetchPrompts()
        if selectionId == nil { selectionId = prompts.first?.id }
    }

    private func addPrompt() {
        let p = Prompt(title: "Ny prompt", body: "")
        prompts.insert(p, at: 0)
        selectionId = p.id
    }

    private func duplicate(_ p: Prompt) {
        let copy = Prompt(title: p.title + " (kopi)", body: p.body)
        prompts.insert(copy, at: 0)
        selectionId = copy.id
    }

    private func delete(_ p: Prompt) {
        prompts.removeAll { $0.id == p.id }
        if selectionId == p.id { selectionId = prompts.first?.id }
    }
}
