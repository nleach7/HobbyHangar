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

    var welcomeMessage: String?

    init(container: DIContainer) {
        guard let appState = container.resolve(serviceType: (any ApplicationState).self) as? AppState else {
            AppLogger.critical("Failed to get an instance of AppState")
            fatalError("Failed to get an instance of AppState")
        }

        self.appState = appState

        guard let pilotService = container.resolve(serviceType: PilotServiceable.self) else {
            AppLogger.critical("Failed to get an instance of PilotServiceable")
            fatalError("Failed to get an instance of PilotServiceable")
        }

        self.pilotService = pilotService
    }

    func onAppear() {
        AppLogger.screenView("PilotProfile")
        loadWelcomeMessage()
    }

    func loadWelcomeMessage() {
        AppLogger.debug("Loading welcome message")
        Task {
            welcomeMessage = await pilotService.loadWelcomeMessage()
            AppLogger.info("Welcome message loaded")
        }
    }
}
