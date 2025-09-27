import Foundation
import os

/// Enkel, platform-neutral logger baseret på `os.Logger`.
final class LoggerService {
    static let shared = LoggerService()

    private let logger: Logger

    private init() {
        // Justér subsystem hvis du vil — det bruges til filtrering i Console.app
        self.logger = Logger(subsystem: "com.kennyback.coworkerai", category: "app")
    }

    func info(_ message: String) {
        logger.info("\(message, privacy: .public)")
    }

    func debug(_ message: String) {
        logger.debug("\(message, privacy: .public)")
    }

    func error(_ message: String) {
        logger.error("\(message, privacy: .public)")
    }
}

// (Valgfrit) cross-platform “reveal in Finder” helper — no-op på iOS.
#if canImport(AppKit)
import AppKit
func revealInFinder(url: URL) {
    NSWorkspace.shared.activateFileViewerSelecting([url])
}
#elseif canImport(UIKit)
import UIKit
func revealInFinder(url: URL) {
    // Ikke relevant på iOS – bevar signatur hvis den kaldes conditionelt.
}
#endif
