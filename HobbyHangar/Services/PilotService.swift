//
//  PilotService.swift
//  HobbyHangar
//
//  Created by Nick Leach on 1/15/26.
//

import Foundation

protocol PilotServiceable: AnyObject {
    func loadWelcomeMessage() async -> String
}

final class PilotService: PilotServiceable {
    private let databaseRepository: DBRepository
    private let appState: AppState

    init(databaseRepository: DBRepository, appState: AppState) {
        self.databaseRepository = databaseRepository
        self.appState = appState
    }

    func loadWelcomeMessage() async -> String {
        // swiftlint:disable:next force_try
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        return "Pilot Profile"
    }
}

final class StubPilotService: PilotServiceable {
    private let databaseRepository: DBRepository

    init(databaseRepository: DBRepository) {
        self.databaseRepository = databaseRepository
    }

    func loadWelcomeMessage() async -> String {
        return "Pilot Profile"
    }
}
