// File: CoWorkerAI/CoWorkerAI/Features/Notes/Views/NoteEditorView.swift
import SwiftUI

struct NoteEditorView: View {
    @Binding var note: Note
    var onCommit: () -> Void
    var onDelete: () -> Void

    @State private var tagsText: String = ""

    var body: some View {
        VStack(spacing: 0) {
            Form {
                TextField("Title", text: $note.title)
                    .font(.title2)

                TextEditor(text: $note.body)
                    .frame(minHeight: 220)
                    .overlay(alignment: .topLeading) {
                        if note.body.isEmpty {
                            Text("Body")
                                .foregroundStyle(.secondary)
                                .padding(.top, 8)
                                .padding(.leading, 5)
                        }
                    }

                LabeledContent("Tags (comma-separated)") {
                    TextField("e.g. work, idea", text: $tagsText)
                        .onAppear {
                            tagsText = note.tags.joined(separator: ", ")
                        }
                        .onChange(of: tagsText) { _, newValue in
                            note.tags = newValue
                                .split(separator: ",")
                                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                                .filter { !$0.isEmpty }
                        }
                }

                LabeledContent("Created") {
                    Text(note.createdAt.formatted(date: .abbreviated, time: .shortened))
                        .foregroundStyle(.secondary)
                }
                LabeledContent("Updated") {
                    Text(note.updatedAt.formatted(date: .abbreviated, time: .shortened))
                        .foregroundStyle(.secondary)
                }
            }

            Divider()

            HStack {
                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Label("Delete", systemImage: "trash")
                }

                Spacer()

                Button {
                    onCommit()
                } label: {
                    Label("Save", systemImage: "square.and.arrow.down")
                }
                .keyboardShortcut("s", modifiers: [.command])
            }
            .padding(8)
        }
        .padding(.top, 8)
    }
}
