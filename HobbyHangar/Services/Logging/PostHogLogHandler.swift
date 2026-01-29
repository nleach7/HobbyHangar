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

    private var postHog: PostHogSDK {
        PostHogSDK.shared
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

            switch String(describing: analyticsType) {
            case "screen":
                postHog.screen(eventNameString, properties: mergedMetadata)
            case "event":
                postHog.capture(eventNameString, properties: mergedMetadata)
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

            for (key, value) in mergedMetadata {
                properties[key] = String(describing: value)
            }

            PostHogSDK.shared.capture(
                "app_error",
                properties: properties
            )
        }
    }
}
