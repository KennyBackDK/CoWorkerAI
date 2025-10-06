// File: CoWorkerAI/CoWorkerAI/Features/Chat/ViewModels/ChatListViewModel.swift
import Foundation

@MainActor
final class ChatListViewModel: ObservableObject {

    // MARK: - State
    @Published var chats: [ChatItem] = []
    @Published var selection: UUID?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Dependencies
    private let repo: ChatRepositoryProtocol

    // MARK: - Init
    init(repo: ChatRepositoryProtocol = ChatRepository()) {
        self.repo = repo
    }

    // MARK: - Load
    func load() {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        Task { [weak self] in
            guard let self else { return }
            do {
                let loaded = try await repo.fetchChats()
                self.chats = loaded
                if self.selection == nil { self.selection = loaded.first?.id }
            } catch {
                self.errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            }
            self.isLoading = false
        }
    }

    // MARK: - Persist
    private func persist() {
        let snapshot = chats
        Task { [weak self] in
            do {
                try await repo.saveChats(snapshot)
            } catch {
                self?.errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            }
        }
    }

    // MARK: - CRUD
    func newChat(title: String = "Ny chat") {
        var chat = ChatItem(title: title)
        chat.messages = []
        chats.insert(chat, at: 0)
        selection = chat.id
        persist()
    }

    func delete(id: UUID) {
        chats.removeAll { $0.id == id }
        if selection == id { selection = chats.first?.id }
        persist()
    }

    func rename(id: UUID, to newTitle: String) {
        guard let idx = chats.firstIndex(where: { $0.id == id }) else { return }
        chats[idx].title = newTitle
        persist()
    }

    func appendMessage(to id: UUID, role: String, content: String) {
        guard let idx = chats.firstIndex(where: { $0.id == id }) else { return }
        let msg = ChatMessage(role: role, content: content)
        chats[idx].messages.append(msg)
        persist()
    }

    // MARK: - Derived
    var selectedChat: ChatItem? {
        guard let id = selection else { return nil }
        return chats.first { $0.id == id }
    }
}
