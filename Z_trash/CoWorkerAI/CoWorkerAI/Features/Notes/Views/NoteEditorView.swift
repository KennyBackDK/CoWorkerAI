import SwiftUI

struct NoteEditorView: View {
    @State var draft: Note
    var onSave: (Note) -> Void
    var onDelete: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Form {
                TextField("Title", text: $draft.title)
                    .font(.title2)

                TextEditor(text: $draft.body)
                    .frame(minHeight: 240)
                    .overlay(alignment: .topLeading) {
                        if draft.body.isEmpty {
                            Text("Body")
                                .foregroundStyle(.secondary)
                                .padding(.top, 8)
                                .padding(.leading, 5)
                        }
                    }
            }

            Divider()

            HStack {
                Button(role: .destructive) {
                    onDelete()
                } label: { Label("Delete", systemImage: "trash") }

                Spacer()

                Button { onCancel() } label: { Text("Cancel") }

                Button {
                    onSave(draft)
                } label: {
                    Label("Save", systemImage: "square.and.arrow.down")
                }
                .keyboardShortcut("s", modifiers: [.command])
            }
            .padding(10)
        }
    }
}
