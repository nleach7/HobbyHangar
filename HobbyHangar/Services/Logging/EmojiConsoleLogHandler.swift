//
//  EmojiConsoleLogHandler.swift
//  HobbyHangar
//
//  Created on 1/25/26.
//

import Foundation
import Logging

/// A log handler that outputs to the console with emoji prefixes for better visibility.
public struct EmojiConsoleLogHandler: LogHandler {

    public var logLevel: Logger.Level = .debug
    public var metadata: Logger.Metadata = [:]

    private let label: String

    public init(label: String) {
        self.label = label
    }

    public subscript(metadataKey key: String) -> Logger.Metadata.Value? {
        get { metadata[key] }
        set { metadata[key] = newValue }
    }

    // swiftlint:disable:next function_parameter_count
    public func log(
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata?,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) {
        // Skip analytics events in console (they go to PostHog)
        let mergedMetadata = self.metadata.merging(metadata ?? [:]) { _, new in new }
        if mergedMetadata["analytics_type"] != nil {
            // Still print a simplified version for analytics in debug
            #if DEBUG
            let emoji = emoji(for: level)
            let timestamp = Self.timestampFormatter.string(from: Date())
            print("\(timestamp) \(emoji) [\(label)] \(message)")
            #endif
            return
        }

        let emoji = emoji(for: level)
        let timestamp = Self.timestampFormatter.string(from: Date())
        let fileName = URL(fileURLWithPath: file).lastPathComponent

        var output = "\(timestamp) \(emoji) [\(label)] \(message)"

        #if DEBUG
        output += " 📍 \(fileName):\(line)"
        #endif

        if let metadata = metadata, !metadata.isEmpty {
            let metadataString = metadata
                .filter { !$0.key.starts(with: "analytics_") && !$0.key.starts(with: "prop_") }
                .map { "\($0.key): \($0.value)" }
                .joined(separator: ", ")

            if !metadataString.isEmpty {
                output += " 📎 {\(metadataString)}"
            }
        }

        print(output)
    }

    // MARK: - Private

    private static let timestampFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()

    private func emoji(for level: Logger.Level) -> String {
        switch level {
        case .trace:
            return "🔬"
        case .debug:
            return "🐛"
        case .info:
            return "ℹ️"
        case .notice:
            return "📢"
        case .warning:
            return "⚠️"
        case .error:
            return "❌"
        case .critical:
            return "🔥"
        }
    }
}
