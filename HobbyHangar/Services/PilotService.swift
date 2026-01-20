//
//  PilotService.swift
//  HobbyHangar
//
//  Created by Nick Leach on 1/15/26.
//

import Foundation

protocol PilotServiceable: AnyObject {
    func getText() async -> String
}

final class PilotService: PilotServiceable {
    private let databaseRepository: DBRepository
    private let appState: any ApplicationState

    init(databaseRepository: DBRepository, appState: any ApplicationState) {
        self.databaseRepository = databaseRepository
        self.appState = appState
    }

    func getText() async -> String {
        // swiftlint:disable:next force_try
        try! await Task.sleep(nanoseconds: 2_000_000_000)
        return "Welcome to HobbyHangar"
    }
}

#if DEBUG
final class StubPilotService: PilotServiceable {

    private let databaseRepository: DBRepository

    init(databaseRepository: DBRepository) {
        self.databaseRepository = databaseRepository
    }

    func getText() async -> String {
        "Stub"
    }
}
#endif
