// File: CoWorkerAI/CoWorkerAI/Persistence/AppPaths.swift
import Foundation

enum AppPathsError: Error {
    case couldNotResolveAppSupport
}

final class AppPaths {
    static let shared = AppPaths()
    private init() {}

    private var productName: String {
        if let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String, !name.isEmpty {
            return name
        }
        return "CoWorkerAI"
    }

    func appSupportDirectory() throws -> URL {
        let fm = FileManager.default
        guard let base = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            throw AppPathsError.couldNotResolveAppSupport
        }
        return base.appendingPathComponent(productName, conformingTo: .directory)
    }

    func ensureAppSupportDirectory() throws {
        let url = try appSupportDirectory()
        let fm = FileManager.default
        var isDir: ObjCBool = false
        if !fm.fileExists(atPath: url.path, isDirectory: &isDir) || !isDir.boolValue {
            try fm.createDirectory(at: url, withIntermediateDirectories: true)
        }
    }

    func notesFileURL() throws -> URL {
        try appSupportDirectory().appendingPathComponent("Notes.json", conformingTo: .json)
    }
}
