import SwiftUI

struct NotesView: View {
    @ObservedObject var viewModel: NotesViewModel

    var body: some View {
        List(viewModel.filteredNotes, id: \.id) { note in
            VStack(alignment: .leading) {
                Text(note.title).font(.headline)
                Text(note.body).font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .toolbar {
            Button { viewModel.addSampleNote() } label: { Image(systemName: "plus") }
        }
        .searchable(text: Binding(
            get: { viewModel.searchQuery },
            set: { viewModel.searchQuery = $0 }
        ))
        .navigationTitle("Notes")
    }
}
