// File: CoWorkerAI/CoWorkerAI/ViewModels/PromptLibraryViewModel.swift
import Foundation
import Combine

final class PromptLibraryViewModel: ObservableObject {
    @Published var allPrompts: [Prompt] = []
    @Published var filteredPrompts: [Prompt] = []
    @Published var search: String = ""

    private let repo: PromptRepositoryProtocol
    private var bag = Set<AnyCancellable>()

    init(repository: PromptRepositoryProtocol) {
        self.repo = repository
        load()

        $search
            .removeDuplicates()
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .sink { [weak self] q in self?.applyFilter(q) }
            .store(in: &bag)
    }

    func load() {
        let items = repo.loadPrompts()
        allPrompts = items
        filteredPrompts = items
    }

    func addSample() {
        var items = repo.loadPrompts()
        items.append(Prompt(title: "New Prompt", body: "Describe the task...", tags: ["general"]))
        repo.savePrompts(items)
        load()
    }

    private func applyFilter(_ q: String) {
        guard !q.isEmpty else { filteredPrompts = allPrompts; return }
        filteredPrompts = allPrompts.filter {
            $0.title.localizedCaseInsensitiveContains(q) ||
            $0.body.localizedCaseInsensitiveContains(q) ||
            $0.tags.joined(separator: ",").localizedCaseInsensitiveContains(q)
        }
    }
}
