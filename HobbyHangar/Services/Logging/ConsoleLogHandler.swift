//
//  ConsoleLogHandler.swift
//  HobbyHangar
//
//  Created on 1/25/26.
//

import Foundation
import Logging
import OSLog

/// A log handler that outputs to the console with emoji prefixes for better visibility.
public struct ConsoleLogHandler: LogHandler {

    public var metadata: Logging.Logger.Metadata = [:]
    public var logLevel: Logging.Logger.Level = .trace

    private let logger: os.Logger
    private let timestampFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()

    init(bundleId: String, category: String) {
        logger = os.Logger(subsystem: bundleId, category: category)
    }

    public subscript(metadataKey key: String) -> Logging.Logger.Metadata.Value? {
        get { metadata[key] }
        set { metadata[key] = newValue }
    }

    // swiftlint:disable:next function_parameter_count
    public func log(
        level: Logging.Logger.Level,
        message: Logging.Logger.Message,
        metadata: Logging.Logger.Metadata?,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) {

        let formattedMessage = formatMessage(message: message, metadata: metadata, file: file, line: line)

        switch level {
        case .trace:
            logger.trace("🔎 \(formattedMessage)")

        case .debug:
            logger.debug("🐛 \(formattedMessage)")

        case .info:
            logger.info("🧠 \(formattedMessage)")

        case .notice:
            logger.notice("💬 \(formattedMessage)")

        case .warning:
            logger.warning("⚠️ \(formattedMessage)")

        case .error:
            logger.error("‼️ \(formattedMessage)")

        case .critical:
            logger.critical("🚨 \(formattedMessage)")
        }
    }

    // MARK: - Private

    private func formatMessage(
        message: Logging.Logger.Message,
        metadata: Logging.Logger.Metadata?,
        file: String,
        line: UInt
    ) -> String {

        let timestamp = timestampFormatter.string(from: Date())
        let location = "[\(file):\(line)]"
        let mergedMetadata = self.metadata.merging(metadata ?? [:]) { _, new in new }
        let metadataString = mergedMetadata.isEmpty ? nil : String(describing: mergedMetadata)

        let formattedMessage = [timestamp, location, "\(message)", metadataString]
            .compactMap { $0 }
            .joined(separator: "\n")

        return formattedMessage
    }
}
