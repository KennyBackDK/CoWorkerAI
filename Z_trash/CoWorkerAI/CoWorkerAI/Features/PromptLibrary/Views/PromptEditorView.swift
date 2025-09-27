// File: CoWorkerAI/CoWorkerAI/Features/PromptLibrary/Views/PromptEditorView.swift
import SwiftUI

struct PromptEditorView: View {
    @State var draft: Prompt
    var onSave: (Prompt) -> Void
    var onCancel: () -> Void

    @State private var inputsText: String = ""
    @State private var tagsText: String = ""

    var body: some View {
        Form {
            Section("Meta") {
                TextField("Name", text: $draft.name)
                TextField("Version (semver)", text: $draft.version)
                TextField("Role", text: $draft.role)
            }
            Section("Template") {
                TextEditor(text: $draft.template)
                    .frame(minHeight: 220)
                    .monospaced()
            }
            Section("Inputs (comma separated)") {
                TextField("e.g. spec, repo, constraints", text: $inputsText)
                    .onAppear { inputsText = draft.inputs.joined(separator: ", ") }
                    .onChange(of: inputsText) { _, val in
                        draft.inputs = val
                            .split(separator: ",")
                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                            .filter { !$0.isEmpty }
                    }
            }
            Section("Tags (comma separated)") {
                TextField("e.g. swift, bluetooth, ios", text: $tagsText)
                    .onAppear { tagsText = draft.tags.joined(separator: ", ") }
                    .onChange(of: tagsText) { _, val in
                        draft.tags = val
                            .split(separator: ",")
                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                            .filter { !$0.isEmpty }
                    }
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", action: onCancel)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { onSave(draft) }.keyboardShortcut("s", modifiers: [.command])
            }
        }
        .navigationTitle("Edit Prompt")
        .frame(minWidth: 640, minHeight: 520)
    }
}

