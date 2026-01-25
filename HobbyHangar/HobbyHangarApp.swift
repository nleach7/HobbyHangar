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

    init() {
        // Initialize logging system first
        PostHogConfiguration.configure()
        AppLogger.bootstrap()

        AppLogger.info("App initializing...")

        diContainer = DIContainer()

        guard let appState = diContainer.resolve(serviceType: (any ApplicationState).self) else {
            AppLogger.critical("Failed to get an instance ApplicationState")
            fatalError("Failed to get an instance ApplicationState")
        }

        self.appState = appState
        AppLogger.info("App initialization complete")
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
                AppLogger.debug("App became active")

            case .background:
                appState.system.isActive = false
                AppLogger.debug("App entered background")

            case .inactive:
                appState.system.isActive = false
                AppLogger.debug("App became inactive")

            @unknown default:
                appState.system.isActive = false
                AppLogger.warning("Unknown scene phase")
            }
        }
    }
}
