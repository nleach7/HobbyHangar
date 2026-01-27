//
//  PilotProfileViewModel.swift
//  HobbyHangar
//
//  Created by Nick Leach on 1/21/26.
//

import Foundation
import Observation

@Observable final class PilotProfileViewModel {
    private let appState: AppState
    private let pilotService: PilotServiceable
    private let logger: AppLogger

    var welcomeMessage: String?

    init(container: DIContainer) {
        guard let logger = container.resolve(serviceType: AppLogger.self) else {
            fatalError("Failed to get an instance of AppLogger")
        }

        self.logger = logger

        guard let appState = container.resolve(serviceType: (any ApplicationState).self) as? AppState else {
            logger.critical("Failed to get an instance of AppState")
            fatalError("Failed to get an instance of AppState")
        }

        self.appState = appState

        guard let pilotService = container.resolve(serviceType: PilotServiceable.self) else {
            logger.critical("Failed to get an instance of PilotServiceable")
            fatalError("Failed to get an instance of PilotServiceable")
        }

        self.pilotService = pilotService
    }

    func onAppear() {
        logger.screenView("PilotProfile")
        loadWelcomeMessage()
    }

    func loadWelcomeMessage() {
        logger.debug("Loading welcome message")
        Task {
            welcomeMessage = await pilotService.loadWelcomeMessage()
            logger.info("Welcome message loaded")
        }
    }
}
