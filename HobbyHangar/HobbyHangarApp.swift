//
//  HobbyHangarApp.swift
//  HobbyHangar
//
//  Created by Nick Leach on 1/15/26.
//

import SwiftUI

@main
struct HobbyHangarApp: App {

    @Environment(\.scenePhase) private var scenePhase

    private let diContainer: DIContainer
    private var appState: any ApplicationState
    private let logger: AppLogger
    private let postHogConfig: PostHogService

    init() {
        diContainer = DIContainer()

        guard let logger = diContainer.resolve(serviceType: AppLogger.self) else {
            fatalError("Failed to get an instance of AppLogger")
        }

        guard let appState = diContainer.resolve(serviceType: (any ApplicationState).self) else {
            logger.critical("Failed to get an instance ApplicationState")
            fatalError("Failed to get an instance ApplicationState")
        }

        guard let postHogConfig = diContainer.resolve(serviceType: PostHogService.self) else {
            logger.critical("Failed to get an instance of PostHogService")
            fatalError("Failed to get an instance of PostHogService")
        }

        self.logger = logger
        self.appState = appState
        self.postHogConfig = postHogConfig

        logger.info("App initialization complete")
    }

    var body: some Scene {
        WindowGroup {
            RootView(viewModel: RootViewModel(container: diContainer))
        }
        .onChange(of: scenePhase) {
            guard let appState = appState as? AppState else {
                return
            }

            switch scenePhase {
            case .active:
                appState.system.isActive = true
                logger.debug("App became active")

            case .background:
                appState.system.isActive = false
                postHogConfig.flush()
                logger.debug("App entered background")

            case .inactive:
                appState.system.isActive = false
                logger.debug("App became inactive")

            @unknown default:
                appState.system.isActive = false
                logger.warning("Unknown scene phase")
            }
        }
    }
}
