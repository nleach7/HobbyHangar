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
        diContainer = DIContainer()

        guard let appState = diContainer.resolve(serviceType: (any ApplicationState).self) else {
            fatalError("Failed to get an instance ApplicationState")
        }

        self.appState = appState
    }

    var body: some Scene {
        WindowGroup {
            RootView(viewModel: RootViewModel(container: diContainer))
        }
        .onChange(of: scenePhase) {

            var appState = appState

            switch scenePhase {
            case .active:
                appState.system.isActive = true

            case .background:
                appState.system.isActive = false

            case .inactive:
                appState.system.isActive = false

            @unknown default:
                appState.system.isActive = false
            }
        }
    }
}
