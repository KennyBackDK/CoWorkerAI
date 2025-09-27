// File: CoWorkerAI/CoWorkerAI/Features/Prompts/ViewModels/PromptLibraryViewModel.swift
import Foundation
import Combine

final class PromptLibraryViewModel: ObservableObject {
    @Published var allPrompts: [Prompt] = []
    @Published var filteredPrompts: [Prompt] = []
    @Published var searchText: String = ""

    private let repository: PromptRepositoryProtocol
    private var bags = Set<AnyCancellable>()

    init(repository: PromptRepositoryProtocol) {
        self.repository = repository
        load()

        $searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main)
            .sink { [weak self] q in self?.applyFilter(q) }
            .store(in: &bags)
    }

    func load() {
        let items = repository.fetchPrompts()
        allPrompts = items
        filteredPrompts = items
    }

    private func applyFilter(_ q: String) {
        guard !q.isEmpty else { filteredPrompts = allPrompts; return }
        filteredPrompts = allPrompts.filter {
            $0.title.localizedCaseInsensitiveContains(q) ||
            $0.body.localizedCaseInsensitiveContains(q)
        }
    }

    func addSamplePrompt() {
        let p = Prompt(title: "Ny prompt", body: "Forklar præcist hvad du vil have. Hele filer.")
        repository.add(prompt: p)
        load()
    }

    func delete(at offsets: IndexSet) {
        for i in offsets {
            let p = filteredPrompts[i]
            repository.delete(prompt: p)
        }
        load()
    }
}
