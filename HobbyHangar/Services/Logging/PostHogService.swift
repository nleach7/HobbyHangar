//
//  PostHog.swift
//  HobbyHangar
//
//  Created on 1/25/26.
//

import Foundation
import PostHog

/// Protocol defining the PostHog analytics service interface.
public protocol PostHogServiceable {
    /// Identify a user for analytics tracking
    func identify(userId: String, properties: [String: Any]?)

    /// Reset the current user (e.g., on logout)
    func reset()

    /// Flush any pending events
    func flush()

    /// Call when the app is about to terminate to ensure events are flushed
    func appWillTerminate()
}

extension PostHogServiceable {
    /// Identify a user without additional properties
    public func identify(userId: String) {
        identify(userId: userId, properties: nil)
    }
}

/// Manages PostHog SDK configuration and lifecycle.
public final class PostHogService: PostHogServiceable {

    private let postHog: PostHogSDK
    private let host = "https://us.i.posthog.com"

    private var apiKey: String {
        if let key = Bundle.main.object(forInfoDictionaryKey: "POSTHOG_API_KEY") as? String, !key.isEmpty {
            return key
        }
        return "debug-key"
    }

    public init(isDebug: Bool) {
        self.postHog = PostHogSDK.shared
        setupPostHog(isDebug: isDebug)
    }

    private func setupPostHog(isDebug: Bool) {
        let config = PostHogConfig(apiKey: apiKey, host: host)

        config.debug = isDebug
        config.optOut = isDebug

        config.captureApplicationLifecycleEvents = true
        config.captureScreenViews = false

        postHog.setup(config)
    }

    /// Identify a user for analytics tracking
    public func identify(userId: String, properties: [String: Any]?) {
        if let properties = properties {
            postHog.identify(userId, userProperties: properties)
        } else {
            postHog.identify(userId)
        }
    }

    /// Reset the current user (e.g., on logout)
    public func reset() {
        postHog.reset()
    }

    /// Flush any pending events
    public func flush() {
        postHog.flush()
    }

    /// Call when the app is about to terminate to ensure events are flushed
    public func appWillTerminate() {
        flush()
    }
}
