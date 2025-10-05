// File: CoWorkerAI/CoWorkerAI/Services/AI/AIClient.swift
import Foundation

/// Abstraktion så vi senere kan bytte mellem OpenAI, Anthropic, Gemini, lokal LLM, osv.
public protocol AIClientProtocol {
    /// Sender en tekstprompt og returnerer modelsvar som ren tekst.
    func send(prompt: String, system: String?) async throws -> String
}

/// Simpel fejltype (kan udvides senere)
public enum AIClientError: Error, LocalizedError {
    case emptyPrompt
    case cancelled
    
    public var errorDescription: String? {
        switch self {
        case .emptyPrompt: return "Prompt is empty."
        case .cancelled:   return "The request was cancelled."
        }
    }
}

/// Dummy-implementation der “lader som om” vi spørger en AI.
/// Vi kan senere erstatte denne med rigtige API-kald (OpenAI, Anthropic, …)
public final class DummyAIClient: AIClientProtocol {
    public init() {}
    
    public func send(prompt: String, system: String? = nil) async throws -> String {
        guard !prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AIClientError.emptyPrompt
        }
        // Simuler netværk + genereringstid
        try await Task.sleep(nanoseconds: 900_000_000) // ~0.9s
        
        // Leg med systeminstruktion hvis givet
        let prefix: String
        if let sys = system, !sys.isEmpty {
            prefix = "【system】\(sys)\n\n"
        } else {
            prefix = ""
        }
        
        // Returnér et “AI-svar”
        return """
        \(prefix)【dummy-ai】Tak for din prompt. Her er et eksempel-svar.

        Prompt (kort): \(prompt.prefix(240))\(prompt.count > 240 ? "…" : "")
        
        • Dette er kun en stub – vi udskifter den med rigtige AI-kilder.
        • Struktur og protokol er klar til OpenAI/Anthropic/Gemini.
        """
    }
}

/// En lille router/factory så resten af appen kun kalder `AIRouter.shared.client`.
/// Senere kan du vælge mellem forskellige providere her.
public final class AIRouter {
    public static let shared = AIRouter()
    private init() {}
    
    /// Skift til en anden implementation når du vil (fx OpenAIClient).
    public var client: AIClientProtocol = DummyAIClient()
}
