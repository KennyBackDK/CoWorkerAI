import Foundation
import os

final class LoggerService {
    static let shared = LoggerService()
    private let logger = Logger(subsystem: "com.kenny.CoWorkerAI", category: "app")
    private init() {}
    func info(_ msg: String)  { logger.info("\(msg, privacy: .public)") }
    func debug(_ msg: String) { logger.debug("\(msg, privacy: .public)") }
    func error(_ msg: String) { logger.error("\(msg, privacy: .public)") }
}
