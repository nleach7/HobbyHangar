//
//  HobbyHangarApp.swift
//  HobbyHangar
//
//  Created by Nick Leach on 1/15/26.
//

import SwiftUI
import FactoryKit

@main
struct HobbyHangarApp: App {
    @Environment(\.scenePhase) private var scenePhase

    private var appState: AppState
    private let logger: AppLoggable
    private let postHogConfig: PostHogServiceable

    init() {
        appState = Container.shared.appState()
        logger = Container.shared.appLogger()
        postHogConfig = Container.shared.postHogService()

        logger.info("App initialization complete")
    }

    var body: some Scene {
        WindowGroup {
            RootView(viewModel: RootViewModel())
        }
        .onChange(of: scenePhase) {
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
