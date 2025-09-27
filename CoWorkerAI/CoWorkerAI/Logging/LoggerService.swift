// File: CoWorkerAI/CoWorkerAI/Logging/LoggerService.swift
import Foundation
import os

public final class LoggerService {
    public static let shared = LoggerService()

    private let logger: os.Logger

    private init() {
        let subsystem = Bundle.main.bundleIdentifier ?? "com.kennyback.coworkerai"
        logger = Logger(subsystem: subsystem, category: "CoWorkerAI")
    }

    @inline(__always)
    public func debug(_ message: String) {
        logger.debug("\(message, privacy: .public)")
    }

    @inline(__always)
    public func info(_ message: String) {
        logger.info("\(message, privacy: .public)")
    }

    @inline(__always)
    public func error(_ message: String) {
        logger.error("\(message, privacy: .public)")
    }

    @inline(__always)
    public func fault(_ message: String) {
        logger.fault("\(message, privacy: .public)")
    }
}
