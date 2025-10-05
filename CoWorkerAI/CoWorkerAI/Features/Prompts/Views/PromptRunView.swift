// File: CoWorkerAI/CoWorkerAI/Features/Prompts/Views/PromptRunView.swift
import SwiftUI

/// Din eksisterende model (forventes at findes i Contracts/Prompt.swift)
/// struct Prompt: Identifiable, Equatable, Codable { public var id: UUID; public var title, body: String; … }

@MainActor
final class PromptRunViewModel: ObservableObject {
    @Published var input: String
    @Published var system: String = ""
    @Published var output: String = ""
    @Published var isRunning = false
    @Published var errorMessage: String?
    
    private let ai: AIClientProtocol
    
    init(initialInput: String, ai: AIClientProtocol = AIRouter.shared.client) {
        self.input = initialInput
        self.ai = ai
    }
    
    func run() {
        errorMessage = nil
        output = ""
        isRunning = true
        
        Task {
            do {
                let text = try await ai.send(prompt: input, system: system)
                output = text
            } catch {
                errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            }
            isRunning = false
        }
    }
}

struct PromptRunView: View {
    let prompt: Prompt
    @StateObject private var vm: PromptRunViewModel
    
    init(prompt: Prompt) {
        self.prompt = prompt
        _vm = StateObject(wrappedValue: PromptRunViewModel(initialInput: prompt.body))
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(prompt.title)
                        .font(.title3).bold()
                    Text("Kør prompten og se AI-svaret herunder.")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
                Spacer()
                Button {
                    vm.run()
                } label: {
                    Label("Run", systemImage: "play.fill")
                }
                .keyboardShortcut(.return, modifiers: [.command])
                .disabled(vm.isRunning || vm.input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            
            // System instructions (valgfrit)
            DisclosureGroup("Systeminstruktion (valgfrit)") {
                TextField("Fx: Du er en hjælpsom programmørassistent…", text: $vm.system, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(1...3)
            }
            
            // Input prompt
            VStack(alignment: .leading, spacing: 6) {
                Text("Prompt")
                    .font(.caption).foregroundStyle(.secondary)
                TextEditor(text: $vm.input)
                    .font(.body.monospaced())
                    .frame(minHeight: 140)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(.quaternary))
            }
            
            // Status / fejl
            if vm.isRunning {
                HStack(spacing: 8) {
                    ProgressView()
                    Text("Genererer svar…")
                        .foregroundStyle(.secondary)
                }
            } else if let err = vm.errorMessage, !err.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.yellow)
                    Text(err).foregroundStyle(.secondary)
                }
            }
            
            // Output
            VStack(alignment: .leading, spacing: 6) {
                Text("AI-svar")
                    .font(.caption).foregroundStyle(.secondary)
                ScrollView {
                    Text(vm.output.isEmpty ? "—" : vm.output)
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                }
                .frame(minHeight: 160)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(16)
    }
}

// (Optional) lille preview hvis du bruger SwiftUI previews
#if DEBUG
struct PromptRunView_Previews: PreviewProvider {
    static var previews: some View {
        PromptRunView(prompt: Prompt(title: "Refactor helper", body: "Refactor this Swift function to be more testable…"))
            .frame(width: 640, height: 560)
    }
}
#endif
