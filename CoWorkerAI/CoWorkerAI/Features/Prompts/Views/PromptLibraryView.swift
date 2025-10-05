// PromptLibraryView.swift
import SwiftUI

struct PromptLibraryView: View {
    private let repo = PromptRepository()
    @State private var prompts: [Prompt] = []
    @State private var search: String = ""
    @State private var selectionId: UUID?

    var body: some View {
        NavigationSplitView {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Søg i titel eller tekst", text: $search)
                        .textFieldStyle(.plain)
                }
                .padding(8)
                .background(.bar)

                List(selection: $selectionId) {
                    ForEach(filteredPrompts, id: \.id) { p in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(p.title.isEmpty ? "Unavngivet" : p.title)
                                .font(.body.weight(.semibold))
                                .lineLimit(1)
                            if !p.body.isEmpty {
                                Text(p.body)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                        }
                        .padding(.vertical, 4)
                        .tag(p.id) // UUID selection → kræver ikke Hashable på Prompt
                        .contextMenu {
                            Button { duplicate(p) } label: { Label("Duplikér", systemImage: "plus.square.on.square") }
                            Button(role: .destructive) { delete(p) } label: { Label("Slet", systemImage: "trash") }
                        }
                    }
                }
            }
            .navigationTitle("Prompts")
            .toolbar {
                ToolbarItemGroup {
                    Button { addPrompt() } label: { Label("Ny", systemImage: "plus") }
                    Button { if let s = selectedPrompt { duplicate(s) } } label: { Label("Duplikér", systemImage: "plus.square.on.square") }
                        .disabled(selectionId == nil)
                    Button(role: .destructive) { if let s = selectedPrompt { delete(s) } } label: { Label("Slet", systemImage: "trash") }
                        .disabled(selectionId == nil)
                }
            }
        } detail: {
            if let sel = selectedPrompt {
                PromptRunView(prompt: sel).navigationTitle(sel.title.isEmpty ? "Prompt" : sel.title)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "text.badge.plus").font(.system(size: 48, weight: .light))
                    Text("Vælg eller opret en prompt").font(.title3)
                    Text("Klik på en prompt i venstre side for at køre den.").foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear { if prompts.isEmpty { load() } }
    }

    private var selectedPrompt: Prompt? { selectionId.flatMap { id in prompts.first { $0.id == id } } }

    private var filteredPrompts: [Prompt] {
        let q = search.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return prompts }
        return prompts.filter { $0.title.lowercased().contains(q) || $0.body.lowercased().contains(q) }
    }

    private func load() {
        prompts = repo.fetchPrompts()
        if selectionId == nil { selectionId = prompts.first?.id }
    }

    private func addPrompt() {
        let p = Prompt(title: "Ny prompt", body: "")
        repo.add(prompt: p)
        prompts.insert(p, at: 0)
        selectionId = p.id
    }

    private func duplicate(_ p: Prompt) {
        let copy = Prompt(title: p.title + " (kopi)", body: p.body)
        repo.add(prompt: copy)
        prompts.insert(copy, at: 0)
        selectionId = copy.id
    }

    private func delete(_ p: Prompt) {
        repo.delete(prompt: p)
        prompts.removeAll { $0.id == p.id }
        if selectionId == p.id { selectionId = prompts.first?.id }
    }
}

#Preview { PromptLibraryView().frame(width: 960, height: 600) }
