import Foundation

enum AppPathsError: Error { case couldNotResolveAppSupport }

final class AppPaths {
    static let shared = AppPaths(); private init() {}

    private var productName: String {
        (Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String).flatMap { $0.isEmpty ? nil : $0 } ?? "CoWorkerAI"
    }

    func appSupportDirectory() throws -> URL {
        guard let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        else { throw AppPathsError.couldNotResolveAppSupport }
        return base.appendingPathComponent(productName, conformingTo: .directory)
    }

    func ensureAppSupportDirectory() throws {
        let url = try appSupportDirectory()
        var isDir: ObjCBool = false
        if !FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir) || !isDir.boolValue {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }
    }

    func notesFileURL() throws -> URL {
        try appSupportDirectory().appendingPathComponent("Notes.json", conformingTo: .json)
    }
}
