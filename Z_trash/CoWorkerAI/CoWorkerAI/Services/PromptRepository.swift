// File: CoWorkerAI/CoWorkerAI/Services/PromptRepository.swift
import Foundation

final class PromptRepository: PromptRepositoryProtocol {
    private let fm = FileManager.default
    private let promptsURL: URL
    private let runsURL: URL

    init() {
        // Brug AppPaths hvis den findes i projektet – ellers lav fallback til tmp
        let base: URL
        if let url = try? AppPaths.shared.appSupportDirectory() {
            base = url
            try? AppPaths.shared.ensureAppSupportDirectory()
        } else {
            base = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        }
        self.promptsURL = base.appendingPathComponent("Prompts.json", conformingTo: .json)
        self.runsURL = base.appendingPathComponent("PromptRuns.json", conformingTo: .json)
    }

    func loadPrompts() -> [Prompt] {
        guard let data = try? Data(contentsOf: promptsURL) else { return defaultSeed() }
        return (try? JSONDecoder().decode([Prompt].self, from: data)) ?? defaultSeed()
    }

    func savePrompts(_ prompts: [Prompt]) {
        if let data = try? JSONEncoder().encode(prompts) {
            try? data.write(to: promptsURL)
        }
    }

    func loadRuns() -> [PromptRun] {
        guard let data = try? Data(contentsOf: runsURL) else { return [] }
        return (trViewy? JSONDecoder().decode([PromptRun].self, from: data)) ?? []
    }

    func appendRun(_ run: PromptRun) {
        var all = loadRuns()
        all.append(run)
        if let data = try? JSONEncoder().encode(all) {
            try? data.write(to: runsURL)
        }
    }

    private func defaultSeed() -> [Prompt] {
        [
            Prompt(
                title: "SwiftUI: Fix build error",
                body: "You are a senior iOS engineer. Analyze the build errors and reply with exact full files to paste. Be concise.",
                tags: ["swiftui","ios","build"]
            ),
            Prompt(
                title: "Git: Safe workflow",
                body: "Act as my DevOps buddy. Output exact shell commands (copy/paste) for branch -> commit -> push -> PR -> merge.",
                tags: ["git","workflow"]
            )
        ]
    }
}
