// File: Features/Chat/Services/ChatRepository.swift

import Foundation

// MARK: - Protocol
public protocol ChatRepositoryProtocol {
    func fetchChats() async throws -> [ChatItem]
    func saveChats(_ chats: [ChatItem]) async throws
    func deleteAllChats() async throws
}

// MARK: - Error
public enum ChatRepositoryError: LocalizedError {
    case io(Error)
    case decoding(Error)
    case encoding(Error)
    case cancelled

    public var errorDescription: String? {
        switch self {
        case .io(let e): return "I/O-fejl: \(e.localizedDescription)"
        case .decoding(let e): return "Kunne ikke læse chats.json (decode-fejl): \(e.localizedDescription)"
        case .encoding(let e): return "Kunne ikke gemme chats.json (encode-fejl): \(e.localizedDescription)"
        case .cancelled: return "Operationen blev annulleret."
        }
    }
}

// MARK: - Implementation
/// JSON-filbaseret lagring under Application Support
public actor ChatRepository: ChatRepositoryProtocol {
    private let productName = "CoWorkerAI"

    private var fileURL: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let folder = base.appendingPathComponent(productName, isDirectory: true)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        return folder.appendingPathComponent("Chats.json")
    }

    public init() {}

    public func fetchChats() async throws -> [ChatItem] {
        let url = fileURL
        guard FileManager.default.fileExists(atPath: url.path) else { return [] }
        let data = try Data(contentsOf: url)
        do {
            return try JSONDecoder().decode([ChatItem].self, from: data)
        } catch {
            throw ChatRepositoryError.decoding(error)
        }
    }

    public func saveChats(_ chats: [ChatItem]) async throws {
        do {
            let data = try JSONEncoder().encode(chats)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            throw ChatRepositoryError.encoding(error)
        }
    }

    public func deleteAllChats() async throws {
        try? FileManager.default.removeItem(at: fileURL)
    }
}
