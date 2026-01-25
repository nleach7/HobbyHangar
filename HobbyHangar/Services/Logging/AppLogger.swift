//
//  AppLogger.swift
//  HobbyHangar
//
//  Created on 1/25/26.
//

import Foundation
import Logging

/// Log metadata type alias for convenience
public typealias LogMetadata = [String: String]

/// Centralized logger for the application.
/// Uses swift-log for multi-platform compatibility with custom handlers
/// for console output (with emoji) and PostHog analytics.
public enum AppLogger {

    /// The shared logger instance
    public private(set) static var logger: Logger = {
        var log = Logger(label: "com.hobbyhangar.app")
        log.logLevel = .debug
        return log
    }()

    /// Initialize the logging system with custom handlers.
    /// Call this once at app startup before any logging occurs.
    public static func bootstrap() {
        LoggingSystem.bootstrap { label in
            MultiplexLogHandler([
                EmojiConsoleLogHandler(label: label),
                PostHogLogHandler(label: label)
            ])
        }

        // Recreate the logger after bootstrap
        logger = Logger(label: "com.hobbyhangar.app")

        #if DEBUG
        logger.logLevel = .debug
        #else
        logger.logLevel = .info
        #endif

        logger.info("Logging system initialized")
    }

    // MARK: - Convenience Methods

    /// Log a debug message
    public static func debug(
        _ message: String,
        metadata: LogMetadata? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        logger.debug("\(message)", metadata: convertMetadata(metadata), file: file, function: function, line: line)
    }

    /// Log an info message
    public static func info(
        _ message: String,
        metadata: LogMetadata? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        logger.info("\(message)", metadata: convertMetadata(metadata), file: file, function: function, line: line)
    }

    /// Log a warning message
    public static func warning(
        _ message: String,
        metadata: LogMetadata? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        logger.warning("\(message)", metadata: convertMetadata(metadata), file: file, function: function, line: line)
    }

    /// Log an error message
    public static func error(
        _ message: String,
        metadata: LogMetadata? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        logger.error("\(message)", metadata: convertMetadata(metadata), file: file, function: function, line: line)
    }

    /// Log a critical message
    public static func critical(
        _ message: String,
        metadata: LogMetadata? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        logger.critical("\(message)", metadata: convertMetadata(metadata), file: file, function: function, line: line)
    }

    // MARK: - Private Helpers

    private static func convertMetadata(_ metadata: LogMetadata?) -> Logger.Metadata? {
        guard let metadata = metadata else { return nil }
        return metadata.mapValues { .string($0) }
    }

    // MARK: - Analytics

    /// Track an analytics event through PostHog
    public static func analytics(
        event: String,
        properties: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        var metadata: Logger.Metadata = [
            "analytics_event": .string(event),
            "analytics_type": .string("event")
        ]

        if let properties = properties {
            for (key, value) in properties {
                metadata["prop_\(key)"] = .string(String(describing: value))
            }
        }

        logger.notice("📊 \(event)", metadata: metadata, file: file, function: function, line: line)
    }

    /// Track a screen view through PostHog
    public static func screenView(
        _ screenName: String,
        properties: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        var metadata: Logger.Metadata = [
            "analytics_event": .string(screenName),
            "analytics_type": .string("screen")
        ]

        if let properties = properties {
            for (key, value) in properties {
                metadata["prop_\(key)"] = .string(String(describing: value))
            }
        }

        logger.notice("📱 Screen: \(screenName)", metadata: metadata, file: file, function: function, line: line)
    }
}
