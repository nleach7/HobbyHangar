//
//  DIContainer.swift
//  HobbyHangar
//
//  Created by Nick Leach on 1/15/26.
//

import FactoryKit

// MARK: - Container Registrations
extension Container {

    var appLogger: Factory<AppLoggable> {
        self { @MainActor in
            #if DEBUG
            AppLogger(isDebug: true)
            #else
            AppLogger(isDebug: false)
            #endif
        }
        .scope(.singleton)
    }

    var postHogService: Factory<PostHogServiceable> {
        self { @MainActor in
            #if DEBUG
            PostHogService(isDebug: true)
            #else
            PostHogService(isDebug: false)
            #endif
        }
        .scope(.singleton)
    }

    var appState: Factory<AppState> {
        self { @MainActor in ApplicationState() }
            .scope(.singleton)
    }

    var databaseRepository: Factory<DBRepository> {
        self { DatabaseRepository() }
            .scope(.singleton)
    }

    var pilotService: Factory<PilotServiceable> {
        self { @MainActor in PilotService(
            databaseRepository: Container.shared.databaseRepository(),
            appState: Container.shared.appState()
        )}
        .scope(.unique)
    }

    // MARK: - Previews / Test Helpers
    func setupPreviewMocks() {
        self.databaseRepository.register { StubDBRepository() }
        self.pilotService.register { @MainActor in
            StubPilotService(databaseRepository: Container.shared.databaseRepository())
        }
        self.appState.register { @MainActor in ApplicationState() }
    }
}
