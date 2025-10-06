// LINJE-START
// File: CoWorkerAI/CoWorkerAI/Features/Chat/Views/ChatEditorView.swift
import SwiftUI

struct ChatEditorView: View {
    let title: String
    @Binding var messages: [ChatMessage]
    var onSend: (String) -> Void

    @State private var draft: String = ""
    @Namespace private var bottomID
    @FocusState private var inputFocused: Bool

    var body: some View {
        VStack(spacing: 8) {
            // MESSAGES
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(messages) { msg in
                            messageRow(for: msg)
                                .id(msg.id)
                        }
                        Color.clear.frame(height: 1).id(bottomID)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                .onChange(of: messages.count) { _ in
                    withAnimation(.easeOut(duration: 0.2)) {
                        proxy.scrollTo(bottomID, anchor: .bottom)
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        proxy.scrollTo(bottomID, anchor: .bottom)
                    }
                }
            }

            Divider()

            // COMPOSER
            HStack(alignment: .bottom, spacing: 10) {
                TextField("Skriv en besked…", text: $draft, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(1...6)
                    .focused($inputFocused)
                    .submitLabel(.send)
                    .onSubmit { send() }

                Button(action: send) {
                    Image(systemName: "paperplane.fill")
                        .imageScale(.large)
                }
                .keyboardShortcut(.return, modifiers: [])
                .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .navigationTitle(title.isEmpty ? "Chat" : title)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                inputFocused = true
            }
        }
        .onChange(of: messages.count) { _ in
            inputFocused = true
        }
    }

    // MARK: - Helpers

    private func send() {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        onSend(text)
        draft = ""
    }

    @ViewBuilder
    private func messageRow(for msg: ChatMessage) -> some View {
        HStack(alignment: .top) {
            if msg.role == "assistant" {
                bubble(text: msg.content, isUser: false)
                Spacer(minLength: 60)
            } else {
                Spacer(minLength: 60)
                bubble(text: msg.content, isUser: true)
            }
        }
        .transition(.opacity.combined(with: .move(edge: msg.role == "user" ? .trailing : .leading)))
    }

    private func bubble(text: String, isUser: Bool) -> some View {
        Text(text)
            .textSelection(.enabled)
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isUser ? Color.accentColor.opacity(0.18) : Color.secondary.opacity(0.15))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(isUser ? Color.accentColor.opacity(0.35) : Color.secondary.opacity(0.25), lineWidth: 0.5)
            )
            .frame(maxWidth: 520, alignment: isUser ? .trailing : .leading)
            .multilineTextAlignment(isUser ? .trailing : .leading)
    }
}
// LINJE-SLUT
