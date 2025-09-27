import Foundation

enum AppPathsError: Error {
    case couldNotResolveBase
}

/// Centraliserede stier for app-data (virker på både macOS og iOS).
final class AppPaths {
    static let shared = AppPaths()
    private init() {}

    // Produktnavn bruges til mappen på macOS ~/Library/Application Support/<produkt>
    private var productName: String {
        // Brug Info.plist-navn hvis tilgængeligt, ellers fallback.
        if let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String, !name.isEmpty {
            return name
        }
        return "CoWorkerAI"
    }

    /// Base-mappe til vedvarende data.
    ///
    /// - macOS: `~/Library/Application Support/<produkt>`
    /// - iOS:   Appens Documents-mappe
    func baseDirectory() throws -> URL {
        #if os(macOS)
        guard let lib = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            throw AppPathsError.couldNotResolveBase
        }
        return lib.appendingPathComponent(productName, conformingTo: .directory)
        #else
        guard let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw AppPathsError.couldNotResolveBase
        }
        return docs
        #endif
    }

    /// Sørger for at base-mappen findes.
    func ensureBaseDirectoryExists() throws {
        let dir = try baseDirectory()
        var isDir: ObjCBool = false
        if !FileManager.default.fileExists(atPath: dir.path, isDirectory: &isDir) || !isDir.boolValue {
            try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
    }

    /// JSON-fil til noter.
    func notesFileURL() throws -> URL {
        try baseDirectory().appendingPathComponent("Notes.json", conformingTo: .json)
    }

    /// JSON-fil til prompt-bibliotek.
    func promptsFileURL() throws -> URL {
        try baseDirectory().appendingPathComponent("Prompts.json", conformingTo: .json)
    }
}
