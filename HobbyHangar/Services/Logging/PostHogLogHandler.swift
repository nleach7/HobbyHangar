//
//  PostHogLogHandler.swift
//  HobbyHangar
//
//  Created on 1/25/26.
//

import Foundation
import Logging
import PostHog

/// A log handler that sends analytics events and errors to PostHog.
public struct PostHogLogHandler: LogHandler {

    public var logLevel: Logger.Level = .info
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
        let mergedMetadata = self.metadata.merging(metadata ?? [:]) { _, new in new }

        // Handle analytics events
        if let analyticsType = mergedMetadata["analytics_type"],
           let eventName = mergedMetadata["analytics_event"] {

            let eventNameString = String(describing: eventName)
            let properties = extractProperties(from: mergedMetadata)

            switch String(describing: analyticsType) {
            case "screen":
                PostHogSDK.shared.screen(eventNameString, properties: properties)
            case "event":
                PostHogSDK.shared.capture(eventNameString, properties: properties)
            default:
                break
            }
            return
        }

        // Log errors and critical issues to PostHog
        if level >= .error {
            let fileName = URL(fileURLWithPath: file).lastPathComponent
            var properties: [String: Any] = [
                "level": level.rawValue,
                "message": String(describing: message),
                "source": source,
                "file": fileName,
                "function": function,
                "line": Int(line)
            ]

            // Add any additional metadata
            for (key, value) in mergedMetadata {
                if !key.starts(with: "analytics_") && !key.starts(with: "prop_") {
                    properties[key] = String(describing: value)
                }
            }

            PostHogSDK.shared.capture(
                "app_error",
                properties: properties
            )
        }
    }

    // MARK: - Private

    /// Extract properties from metadata (keys starting with "prop_")
    private func extractProperties(from metadata: Logger.Metadata) -> [String: Any] {
        var properties: [String: Any] = [:]

        for (key, value) in metadata where key.starts(with: "prop_") {
            let propertyKey = String(key.dropFirst(5)) // Remove "prop_" prefix
            properties[propertyKey] = String(describing: value)
        }

        return properties
    }
}
