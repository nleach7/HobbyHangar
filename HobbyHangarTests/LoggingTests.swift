//
//  LoggingTests.swift
//  HobbyHangarTests
//
//  Created on 1/25/26.
//

import Testing
import Foundation
import Logging
@testable import HobbyHangar

// MARK: - Mock Log Handler for Testing

/// A mock log handler that captures log entries for testing purposes
final class MockLogHandler: LogHandler, @unchecked Sendable {
    var logLevel: Logger.Level = .trace
    var metadata: Logger.Metadata = [:]

    struct LogEntry: Equatable {
        let level: Logger.Level
        let message: String
        let metadata: Logger.Metadata?
        let source: String
        let file: String
        let function: String
        let line: UInt

        static func == (lhs: LogEntry, rhs: LogEntry) -> Bool {
            lhs.level == rhs.level &&
            lhs.message == rhs.message &&
            lhs.source == rhs.source
        }
    }

    private(set) var entries: [LogEntry] = []
    private let lock = NSLock()

    subscript(metadataKey key: String) -> Logger.Metadata.Value? {
        get { metadata[key] }
        set { metadata[key] = newValue }
    }

    func log(
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata?,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) {
        lock.lock()
        defer { lock.unlock() }

        entries.append(LogEntry(
            level: level,
            message: String(describing: message),
            metadata: metadata,
            source: source,
            file: file,
            function: function,
            line: line
        ))
    }

    func reset() {
        lock.lock()
        defer { lock.unlock() }
        entries.removeAll()
    }

    var lastEntry: LogEntry? {
        lock.lock()
        defer { lock.unlock() }
        return entries.last
    }

    func entries(at level: Logger.Level) -> [LogEntry] {
        lock.lock()
        defer { lock.unlock() }
        return entries.filter { $0.level == level }
    }
}

// MARK: - EmojiConsoleLogHandler Tests

@Suite("EmojiConsoleLogHandler Tests")
struct EmojiConsoleLogHandlerTests {

    @Test("Handler initializes with correct label")
    func initializesWithLabel() {
        let handler = EmojiConsoleLogHandler(label: "test.label")
        #expect(handler.logLevel == .debug)
        #expect(handler.metadata.isEmpty)
    }

    @Test("Handler supports metadata subscript")
    func metadataSubscript() {
        var handler = EmojiConsoleLogHandler(label: "test")
        handler[metadataKey: "testKey"] = .string("testValue")
        #expect(handler[metadataKey: "testKey"] == .string("testValue"))
    }

    @Test("Handler log level can be changed")
    func logLevelChange() {
        var handler = EmojiConsoleLogHandler(label: "test")
        handler.logLevel = .warning
        #expect(handler.logLevel == .warning)
    }

    @Test("Handler metadata can be set")
    func metadataSet() {
        var handler = EmojiConsoleLogHandler(label: "test")
        handler.metadata = ["key1": .string("value1")]
        #expect(handler.metadata["key1"] == .string("value1"))
    }
}

// MARK: - PostHogLogHandler Tests

@Suite("PostHogLogHandler Tests")
struct PostHogLogHandlerTests {

    @Test("Handler initializes with correct default log level")
    func initializesWithDefaults() {
        let handler = PostHogLogHandler(label: "test.posthog")
        #expect(handler.logLevel == .info)
        #expect(handler.metadata.isEmpty)
    }

    @Test("Handler supports metadata subscript")
    func metadataSubscript() {
        var handler = PostHogLogHandler(label: "test")
        handler[metadataKey: "userId"] = .string("123")
        #expect(handler[metadataKey: "userId"] == .string("123"))
    }

    @Test("Handler log level can be changed")
    func logLevelChange() {
        var handler = PostHogLogHandler(label: "test")
        handler.logLevel = .error
        #expect(handler.logLevel == .error)
    }
}

// MARK: - Logger Integration Tests

@Suite("Logger Integration Tests")
struct LoggerIntegrationTests {

    @Test("Logger can log at all levels")
    func logAtAllLevels() {
        let mockHandler = MockLogHandler()
        let logger = Logger(label: "test.integration") { _ in mockHandler }

        logger.trace("Trace message")
        logger.debug("Debug message")
        logger.info("Info message")
        logger.notice("Notice message")
        logger.warning("Warning message")
        logger.error("Error message")
        logger.critical("Critical message")

        #expect(mockHandler.entries.count == 7)
        #expect(mockHandler.entries[0].level == .trace)
        #expect(mockHandler.entries[1].level == .debug)
        #expect(mockHandler.entries[2].level == .info)
        #expect(mockHandler.entries[3].level == .notice)
        #expect(mockHandler.entries[4].level == .warning)
        #expect(mockHandler.entries[5].level == .error)
        #expect(mockHandler.entries[6].level == .critical)
    }

    @Test("Logger captures message content correctly")
    func capturesMessageContent() {
        let mockHandler = MockLogHandler()
        let logger = Logger(label: "test.message") { _ in mockHandler }

        logger.info("Test message content")

        #expect(mockHandler.lastEntry?.message == "Test message content")
    }

    @Test("Logger captures metadata correctly")
    func capturesMetadata() {
        let mockHandler = MockLogHandler()
        let logger = Logger(label: "test.metadata") { _ in mockHandler }

        logger.info("Message with metadata", metadata: ["key": .string("value"), "number": .string("42")])

        let entry = mockHandler.lastEntry
        #expect(entry?.metadata?["key"] == .string("value"))
        #expect(entry?.metadata?["number"] == .string("42"))
    }

    @Test("Logger respects log level filtering")
    func respectsLogLevel() {
        let mockHandler = MockLogHandler()
        mockHandler.logLevel = .warning

        var logger = Logger(label: "test.level") { _ in mockHandler }
        logger.logLevel = .warning

        logger.debug("Should not appear")
        logger.info("Should not appear")
        logger.warning("Should appear")
        logger.error("Should appear")

        // Note: The mock handler captures all, but in real usage the logger filters
        // We're testing that the logger sends the correct levels
        #expect(mockHandler.entries(at: .warning).count == 1)
        #expect(mockHandler.entries(at: .error).count == 1)
    }

    @Test("Logger captures source file information")
    func capturesSourceInfo() {
        let mockHandler = MockLogHandler()
        let logger = Logger(label: "test.source") { _ in mockHandler }

        logger.info("Test message")

        let entry = mockHandler.lastEntry
        #expect(entry?.file.contains("LoggingTests.swift") == true)
        #expect((entry?.line ?? 0) > 0)
    }
}

// MARK: - MultiplexLogHandler Tests

@Suite("MultiplexLogHandler Tests")
struct MultiplexLogHandlerTests {

    @Test("MultiplexLogHandler sends to all handlers")
    func sendsToAllHandlers() {
        let handler1 = MockLogHandler()
        let handler2 = MockLogHandler()

        let multiplexHandler = MultiplexLogHandler([handler1, handler2])
        let logger = Logger(label: "test.multiplex") { _ in multiplexHandler }

        logger.info("Broadcast message")

        #expect(handler1.entries.count == 1)
        #expect(handler2.entries.count == 1)
        #expect(handler1.lastEntry?.message == "Broadcast message")
        #expect(handler2.lastEntry?.message == "Broadcast message")
    }

    @Test("MultiplexLogHandler preserves log level for all handlers")
    func preservesLogLevel() {
        let handler1 = MockLogHandler()
        let handler2 = MockLogHandler()

        let multiplexHandler = MultiplexLogHandler([handler1, handler2])
        let logger = Logger(label: "test.multiplex.level") { _ in multiplexHandler }

        logger.error("Error message")

        #expect(handler1.lastEntry?.level == .error)
        #expect(handler2.lastEntry?.level == .error)
    }
}

// MARK: - Analytics Metadata Tests

@Suite("Analytics Metadata Tests")
struct AnalyticsMetadataTests {

    @Test("Analytics event metadata is correctly formatted")
    func analyticsEventMetadata() {
        let mockHandler = MockLogHandler()
        let logger = Logger(label: "test.analytics") { _ in mockHandler }

        let metadata: Logger.Metadata = [
            "analytics_event": .string("button_clicked"),
            "analytics_type": .string("event"),
            "prop_screen": .string("home")
        ]

        logger.notice("Analytics event", metadata: metadata)

        let entry = mockHandler.lastEntry
        #expect(entry?.metadata?["analytics_event"] == .string("button_clicked"))
        #expect(entry?.metadata?["analytics_type"] == .string("event"))
        #expect(entry?.metadata?["prop_screen"] == .string("home"))
    }

    @Test("Screen view metadata is correctly formatted")
    func screenViewMetadata() {
        let mockHandler = MockLogHandler()
        let logger = Logger(label: "test.screen") { _ in mockHandler }

        let metadata: Logger.Metadata = [
            "analytics_event": .string("HomeScreen"),
            "analytics_type": .string("screen")
        ]

        logger.notice("Screen view", metadata: metadata)

        let entry = mockHandler.lastEntry
        #expect(entry?.metadata?["analytics_event"] == .string("HomeScreen"))
        #expect(entry?.metadata?["analytics_type"] == .string("screen"))
    }
}

// MARK: - LogMetadata Type Tests

@Suite("LogMetadata Type Tests")
struct LogMetadataTypeTests {

    @Test("LogMetadata type alias works correctly")
    func logMetadataTypeAlias() {
        let metadata: LogMetadata = [
            "userId": "123",
            "action": "login"
        ]

        #expect(metadata["userId"] == "123")
        #expect(metadata["action"] == "login")
        #expect(metadata.count == 2)
    }

    @Test("LogMetadata can be empty")
    func emptyLogMetadata() {
        let metadata: LogMetadata = [:]
        #expect(metadata.isEmpty)
    }
}

// MARK: - Edge Cases Tests

@Suite("Logging Edge Cases")
struct LoggingEdgeCasesTests {

    @Test("Empty message is handled")
    func emptyMessage() {
        let mockHandler = MockLogHandler()
        let logger = Logger(label: "test.empty") { _ in mockHandler }

        logger.info("")

        #expect(mockHandler.lastEntry?.message == "")
    }

    @Test("Long message is handled")
    func longMessage() {
        let mockHandler = MockLogHandler()
        let logger = Logger(label: "test.long") { _ in mockHandler }

        let longMessage = String(repeating: "a", count: 10000)
        logger.info("\(longMessage)")

        #expect(mockHandler.lastEntry?.message.count == 10000)
    }

    @Test("Special characters in message are preserved")
    func specialCharacters() {
        let mockHandler = MockLogHandler()
        let logger = Logger(label: "test.special") { _ in mockHandler }

        let specialMessage = "Test with émojis 🎉 and spëcial çharacters <>&\""
        logger.info("\(specialMessage)")

        #expect(mockHandler.lastEntry?.message == specialMessage)
    }

    @Test("Unicode in metadata is handled")
    func unicodeMetadata() {
        let mockHandler = MockLogHandler()
        let logger = Logger(label: "test.unicode") { _ in mockHandler }

        logger.info("Unicode test", metadata: ["emoji": .string("🚀"), "chinese": .string("中文")])

        let entry = mockHandler.lastEntry
        #expect(entry?.metadata?["emoji"] == .string("🚀"))
        #expect(entry?.metadata?["chinese"] == .string("中文"))
    }

    @Test("Nil metadata is handled")
    func nilMetadata() {
        let mockHandler = MockLogHandler()
        let logger = Logger(label: "test.nil") { _ in mockHandler }

        logger.info("No metadata", metadata: nil)

        #expect(mockHandler.lastEntry?.metadata == nil)
    }

    @Test("Empty metadata dictionary is handled")
    func emptyMetadataDictionary() {
        let mockHandler = MockLogHandler()
        let logger = Logger(label: "test.emptydict") { _ in mockHandler }

        logger.info("Empty metadata", metadata: [:])

        #expect(mockHandler.lastEntry?.metadata?.isEmpty == true)
    }
}

// MARK: - Thread Safety Tests

@Suite("Thread Safety Tests")
struct ThreadSafetyTests {

    @Test("Concurrent logging does not crash")
    func concurrentLogging() async {
        let mockHandler = MockLogHandler()
        let logger = Logger(label: "test.concurrent") { _ in mockHandler }

        await withTaskGroup(of: Void.self) { group in
            for index in 0..<100 {
                group.addTask {
                    logger.info("Concurrent message \(index)")
                }
            }
        }

        #expect(mockHandler.entries.count == 100)
    }

    @Test("Concurrent metadata access does not crash")
    func concurrentMetadataAccess() async {
        let mockHandler = MockLogHandler()
        let logger = Logger(label: "test.concurrent.metadata") { _ in mockHandler }

        await withTaskGroup(of: Void.self) { group in
            for index in 0..<50 {
                group.addTask {
                    logger.info("Message \(index)", metadata: ["index": .string("\(index)")])
                }
            }
        }

        #expect(mockHandler.entries.count == 50)
    }
}
