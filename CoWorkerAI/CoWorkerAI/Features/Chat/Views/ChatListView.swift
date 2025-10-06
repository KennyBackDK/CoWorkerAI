// File: CoWorkerAI/CoWorkerAI/Features/Chat/Views/ChatListView.swift
import SwiftUI

struct ChatListView: View {
    // ViewModel
    @StateObject private var vm = ChatListViewModel()

    // Lokal UI-state
    @State private var isRenaming = false
    @State private var renameTitle = ""

    var body: some View {
        NavigationSplitView {
            // SIDEBAR
            List(selection: $vm.selection) {
                ForEach(vm.chats) { chat in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(chat.title.isEmpty ? "Unavngivet" : chat.title)
                            .font(.headline)
                            .lineLimit(1)

                        if let last = chat.messages.last {
                            Text(last.content)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        } else {
                            Text("Ingen beskeder endnu")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .tag(chat.id)
                    .contextMenu {
                        Button("Omdøb") {
                            vm.selection = chat.id
                            renameTitle = chat.title
                            isRenaming = true
                        }
                        Button("Slet", role: .destructive) {
                            vm.delete(id: chat.id)
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Chats")

        } detail: {
            // DETAIL
            if let id = vm.selection,
               let index = vm.chats.firstIndex(where: { $0.id == id }) {

                ChatEditorView(
                    title: vm.chats[index].title,
                    messages: $vm.chats[index].messages,   // <-- Binding her
                    onSend: { text in
                        vm.appendMessage(to: id, role: "user", content: text)
                        // Placeholder for AI-svar:
                        vm.appendMessage(to: id, role: "assistant", content: "Svar genereret af CoWorkerAI …")
                    }
                )
                .navigationTitle(vm.chats[index].title.isEmpty ? "Chat" : vm.chats[index].title)

            } else {
                Text("Vælg eller opret en chat")
                    .foregroundStyle(.secondary)
            }
        }
        // Toolbar på NavigationSplitView (ikke på List)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    vm.newChat(title: "Ny chat")
                } label: {
                    Label("Ny chat", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $isRenaming) { renameSheet }
        .onAppear { vm.load() }
        .alert("Fejl", isPresented: .constant(vm.errorMessage != nil), actions: {
            Button("OK", role: .cancel) { vm.errorMessage = nil }
        }, message: {
            Text(vm.errorMessage ?? "")
        })
        .navigationSplitViewStyle(.balanced)
    }

    // MARK: - Rename-sheet
    private var renameSheet: some View {
        VStack(spacing: 12) {
            Text("Omdøb chat").font(.headline)
            TextField("Nyt navn", text: $renameTitle)
                .textFieldStyle(.roundedBorder)
                .frame(width: 320)

            HStack {
                Button("Annuller") { isRenaming = false }
                Spacer()
                Button("Gem") {
                    if let id = vm.selection {
                        vm.rename(id: id, to: renameTitle.trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                    isRenaming = false
                }
                .keyboardShortcut(.return, modifiers: [])
                .disabled(renameTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .frame(width: 320)
        }
        .padding(20)
    }
}

