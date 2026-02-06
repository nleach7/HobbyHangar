//
//  HobbyHangarTests.swift
//  HobbyHangarTests
//
//  Created by Nick Leach on 1/15/26.
//

import Cuckoo
import Testing
@testable import HobbyHangar

struct HobbyHangarTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

}

// MARK: - Cuckoo Mock Tests

struct PilotServiceMockTests {

    @Test func testPilotServiceCanBeMocked() async throws {
        // Create the mock
        let mockService = MockPilotServiceable()

        // Stub the method to return a custom value
        stub(mockService) { stub in
            when(stub.loadWelcomeMessage()).thenReturn("Hello, Test Pilot!")
        }

        // Call the mocked method
        let result = await mockService.loadWelcomeMessage()

        // Verify the result
        #expect(result == "Hello, Test Pilot!")

        // Verify the method was called
        verify(mockService).loadWelcomeMessage()
    }
}

struct DBRepositoryMockTests {

    @Test func testDBRepositoryCanBeMocked() async throws {
        // Create the mock - DBRepository protocol is empty for now,
        // but you can add methods and they'll be mockable
        let mockRepo = MockDBRepository()

        // The mock exists and can be used
        #expect(mockRepo is DBRepository)
    }
}
