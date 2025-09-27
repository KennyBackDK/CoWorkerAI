// File: CoWorkerAI/CoWorkerAI/Features/PromptLibrary/Services/PromptRepository.swift
import Foundation

final class PromptRepository: PromptRepositoryProtocol {
    private let fm = FileManager.default
    private let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.outputFormatting = [.prettyPrinted, .sortedKeys]
        return e
    }()
    private let decoder = JSONDecoder()

    private var promptsCache: [Prompt] = []
    private var runsCache: [PromptRun] = []

    init() {
        // Ensure app support dir exists
        try? AppPaths.shared.ensureAppSupportDirectory()
        // Load on init
        promptsCache = (try? read([Prompt].self, from: promptsURL())) ?? seed()
        runsCache = (try? read([PromptRun].self, from: runsURL())) ?? []
    }

    // MARK: - PromptRepositoryProtocol

    func loadPrompts() -> [Prompt] {
        // reload from disk to keep in sync across app sessions
        if let loaded: [Prompt] = try? read([Prompt].self, from: promptsURL()) {
            promptsCache = loaded
        }
        return promptsCache
    }

    func savePrompts(_ prompts: [Prompt]) {
        promptsCache = prompts
        try? write(prompts, to: promptsURL())
    }

    func loadRuns() -> [PromptRun] {
        if let loaded: [PromptRun] = try? read([PromptRun].self, from: runsURL()) {
            runsCache = loaded
        }
        return runsCache
    }

    func appendRun(_ run: PromptRun) {
        runsCache.append(run)
        try? write(runsCache, to: runsURL())
    }

    // MARK: - URLs

    private func promptsURL() throws -> URL {
        let dir = try AppPaths.shared.appSupportDirectory()
        return dir.appendingPathComponent("Prompts.json", conformingTo: .json)
    }

    private func runsURL() throws -> URL {
        let dir = try AppPaths.shared.appSupportDirectory()
        return dir.appendingPathComponent("PromptRuns.json", conformingTo: .json)
    }

    // MARK: - IO helpers

    private func read<T: Decodable>(_ type: T.Type, from url: URL) throws -> T {
        let data = try Data(contentsOf: url)
        return try decoder.decode(T.self, from: data)
    }

    private func write<T: Encodable>(_ value: T, to url: URL) throws {
        let data = try encoder.encode(value)
        try data.write(to: url, options: .atomic)
    }

    private func seed() -> [Prompt] {
        [
            Prompt(
                name: "Programmer · Planner",
                version: "0.1.0",
                role: "planner",
                template: """
                You are a senior software planner. Given a SPEC, produce:
                - architecture plan
                - file list
                - risks
                - test strategy
                SPEC:
                {{spec}}
                """,
                inputs: ["spec"],
                tags: ["planning","software","architecture"]
            ),
            Prompt(
                name: "Programmer · Coder",
                version: "0.1.0",
                role: "coder",
                template: """
                You are a deterministic code generator.
                Input SPEC:
                {{spec}}
                Output ONLY complete files with:
// File: <path-from-root>
<full content>

                """,
                inputs: ["spec"],
                tags: ["codegen","swift","files"]
            )
        ]
    }
}

