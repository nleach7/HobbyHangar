//
//  PilotProfileViewModel.swift
//  HobbyHangar
//
//  Created by Nick Leach on 1/21/26.
//

import Foundation
import Observation
import FactoryKit

@Observable final class PilotProfileViewModel {

    private let appState: AppState
    private let logger: AppLoggable
    private let pilotService: PilotServiceable

    var welcomeMessage: String?

    init() {
        self.appState = Container.shared.appState()
        self.pilotService = Container.shared.pilotService()
        self.logger = Container.shared.appLogger()
    }

    func loadWelcomeMessage() {
        Task {
            welcomeMessage = await pilotService.loadWelcomeMessage()
        }
    }
}
