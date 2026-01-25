//
//  PostHogConfiguration.swift
//  HobbyHangar
//
//  Created on 1/25/26.
//

import Foundation
import PostHog

/// Configuration and initialization for PostHog analytics.
public enum PostHogConfiguration {

    /// Initialize PostHog with the app's configuration.
    /// Call this before AppLogger.bootstrap() at app startup.
    public static func configure() {
        // TODO: Replace with your actual PostHog API key and host
        // For production, these should come from environment config or xcconfig
        let apiKey = ProcessInfo.processInfo.environment["POSTHOG_API_KEY"] ?? "your-api-key-here"
        let host = ProcessInfo.processInfo.environment["POSTHOG_HOST"] ?? "https://us.i.posthog.com"

        let config = PostHogConfig(apiKey: apiKey, host: host)

        // Configure PostHog settings
        config.captureApplicationLifecycleEvents = true
        config.captureScreenViews = false // We'll handle this manually via AppLogger

        #if DEBUG
        config.debug = true
        config.optOut = true // Opt out in debug builds to avoid polluting data
        #else
        config.debug = false
        config.optOut = false
        #endif

        PostHogSDK.shared.setup(config)
    }

    /// Identify a user for analytics tracking
    public static func identify(userId: String, properties: [String: Any]? = nil) {
        if let properties = properties {
            PostHogSDK.shared.identify(userId, userProperties: properties)
        } else {
            PostHogSDK.shared.identify(userId)
        }
        AppLogger.debug("User identified: \(userId)")
    }

    /// Reset the current user (e.g., on logout)
    public static func reset() {
        PostHogSDK.shared.reset()
        AppLogger.debug("PostHog user reset")
    }

    /// Flush any pending events
    public static func flush() {
        PostHogSDK.shared.flush()
    }
}
