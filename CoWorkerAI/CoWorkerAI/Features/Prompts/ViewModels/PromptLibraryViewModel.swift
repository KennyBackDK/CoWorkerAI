// File: CoWorkerAI/CoWorkerAI/Features/Prompts/ViewModels/PromptLibraryViewModel.swift
import Foundation
import Combine

@MainActor
final class PromptLibraryViewModel: ObservableObject {
    @Published var allPrompts: [Prompt] = []
    @Published var searchText: String = ""
    @Published var filteredPrompts: [Prompt] = []

    private let repository: PromptRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(repository: PromptRepositoryProtocol) {
        self.repository = repository
        load()

        $searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main)
            .sink { [weak self] q in self?.applyFilter(q) }
            .store(in: &cancellables)
    }

    func load() {
        let fetched = repository.fetchPrompts()
        allPrompts = fetched
        filteredPrompts = fetched
    }

    func addPrompt(title: String, body: String) {
        let new = Prompt(title: title, body: body)
        repository.add(prompt: new)
        load()
    }

    func delete(at offsets: IndexSet) {
        for i in offsets {
            let p = filteredPrompts[i]
            repository.delete(prompt: p)
        }
        load()
    }

    private func applyFilter(_ q: String) {
        guard !q.isEmpty else { filteredPrompts = allPrompts; return }
        filteredPrompts = allPrompts.filter {
            $0.title.localizedCaseInsensitiveContains(q) ||
            $0.body.localizedCaseInsensitiveContains(q)
        }
    }
}
