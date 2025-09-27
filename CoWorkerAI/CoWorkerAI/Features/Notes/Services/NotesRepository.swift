// File: CoWorkerAI/CoWorkerAI/Features/Notes/Services/NotesRepository.swift
import Foundation

enum NotesRepositoryError: Error {
    case notFound
    case ioError(Error)
    case decodeError(Error)
    case encodeError(Error)
}

protocol NotesRepository {
    func loadAll() async throws -> [Note]
    func saveAll(_ notes: [Note]) async throws
}

actor JSONFileStore<T: Codable> {
    private let url: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(url: URL) {
        self.url = url
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
        self.encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        self.encoder.dateEncodingStrategy = .iso8601
        self.decoder.dateDecodingStrategy = .iso8601
    }

    func load(default defaultValue: T) async throws -> T {
        do {
            let data = try Data(contentsOf: url)
            return try decoder.decode(T.self, from: data)
        } catch let error as CocoaError where error.code == .fileReadNoSuchFile {
            try await save(defaultValue)
            return defaultValue
        } catch {
            throw NotesRepositoryError.decodeError(error)
        }
    }

    func save(_ value: T) async throws {
        do {
            let data = try encoder.encode(value)
            let dir = url.deletingLastPathComponent()
            try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
            try data.write(to: url, options: [.atomic])
        } catch {
            throw NotesRepositoryError.ioError(error)
        }
    }
}

final class FileNotesRepository: NotesRepository {
    private let store: JSONFileStore<[Note]>

    init(fileURL: URL) {
        self.store = JSONFileStore<[Note]>(url: fileURL)
    }

    func loadAll() async throws -> [Note] {
        let notes = try await store.load(default: [])
        return notes
    }

    func saveAll(_ notes: [Note]) async throws {
        try await store.save(notes)
    }
}
