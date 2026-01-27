//
//  AppLogger.swift
//  HobbyHangar
//
//  Created on 1/25/26.
//

import Foundation
import Logging

public typealias LogMetadata = [String: String]

/// Protocol defining the logging interface for the application.
public protocol AppLogger {
    func debug(_ message: String, metadata: LogMetadata?, file: String, function: String, line: UInt)
    func info(_ message: String, metadata: LogMetadata?, file: String, function: String, line: UInt)
    func warning(_ message: String, metadata: LogMetadata?, file: String, function: String, line: UInt)
    func error(_ message: String, metadata: LogMetadata?, file: String, function: String, line: UInt)
    func critical(_ message: String, metadata: LogMetadata?, file: String, function: String, line: UInt)
    func analytics(event: String, properties: [String: Any]?, file: String, function: String, line: UInt)
    func screenView(_ screenName: String, properties: [String: Any]?, file: String, function: String, line: UInt)
}

public extension AppLogger {
    func debug(
        _ message: String,
        metadata: LogMetadata? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        debug(message, metadata: metadata, file: file, function: function, line: line)
    }

    func info(
        _ message: String,
        metadata: LogMetadata? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        info(message, metadata: metadata, file: file, function: function, line: line)
    }

    func warning(
        _ message: String,
        metadata: LogMetadata? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        warning(message, metadata: metadata, file: file, function: function, line: line)
    }

    func error(
        _ message: String,
        metadata: LogMetadata? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        error(message, metadata: metadata, file: file, function: function, line: line)
    }

    func critical(
        _ message: String,
        metadata: LogMetadata? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        critical(message, metadata: metadata, file: file, function: function, line: line)
    }

    func analytics(
        event: String,
        properties: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        analytics(event: event, properties: properties, file: file, function: function, line: line)
    }

    func screenView(
        _ screenName: String,
        properties: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        screenView(screenName, properties: properties, file: file, function: function, line: line)
    }
}

/// Centralized logger for the application.
public final class ApplicationLogger: AppLogger {

    private let bundleId: String
    private var logger: Logger

    public init(isDebug: Bool) {

        let bundleId = Bundle.main.bundleIdentifier!
        self.bundleId = bundleId

        LoggingSystem.bootstrap { label in
            MultiplexLogHandler([
                ConsoleLogHandler(bundleId: bundleId, category: label),
                PostHogLogHandler()
            ])
        }

        logger = Logger(label: bundleId)
        logger.logLevel = isDebug ? .trace : .warning
    }

    /// Log a debug message
    public func debug(
        _ message: String,
        metadata: LogMetadata?,
        file: String,
        function: String,
        line: UInt
    ) {
        logger.debug("\(message)", metadata: convertMetadata(metadata), file: file, function: function, line: line)
    }

    /// Log an info message
    public func info(
        _ message: String,
        metadata: LogMetadata?,
        file: String,
        function: String,
        line: UInt
    ) {
        logger.info("\(message)", metadata: convertMetadata(metadata), file: file, function: function, line: line)
    }

    /// Log a warning message
    public func warning(
        _ message: String,
        metadata: LogMetadata?,
        file: String,
        function: String,
        line: UInt
    ) {
        logger.warning("\(message)", metadata: convertMetadata(metadata), file: file, function: function, line: line)
    }

    /// Log an error message
    public func error(
        _ message: String,
        metadata: LogMetadata?,
        file: String,
        function: String,
        line: UInt
    ) {
        logger.error("\(message)", metadata: convertMetadata(metadata), file: file, function: function, line: line)
    }

    /// Log a critical message
    public func critical(
        _ message: String,
        metadata: LogMetadata?,
        file: String,
        function: String,
        line: UInt
    ) {
        logger.critical("\(message)", metadata: convertMetadata(metadata), file: file, function: function, line: line)
    }

    private func convertMetadata(_ metadata: LogMetadata?) -> Logger.Metadata? {
        guard let metadata else { return nil }
        return metadata.mapValues { .string($0) }
    }

    // MARK: - Analytics

    /// Track an analytics event through PostHog
    public func analytics(
        event: String,
        properties: [String: Any]?,
        file: String,
        function: String,
        line: UInt
    ) {
        var metadata: Logger.Metadata = [
            "analytics_event": .string(event),
            "analytics_type": .string("event")
        ]

        if let properties {
            metadata.merge(properties.mapValues { .string("\($0)") }) { (_, new) in new }
        }

        logger.notice("\(event)", metadata: metadata, file: file, function: function, line: line)
    }

    /// Track a screen view through PostHog
    public func screenView(
        _ screenName: String,
        properties: [String: Any]?,
        file: String,
        function: String,
        line: UInt
    ) {
        var metadata: Logger.Metadata = [
            "analytics_event": .string(screenName),
            "analytics_type": .string("screen")
        ]

        if let properties {
            metadata.merge(properties.mapValues { .string("\($0)") }) { (_, new) in new }
        }

        logger.notice("Screen: \(screenName)", metadata: metadata, file: file, function: function, line: line)
    }
}
