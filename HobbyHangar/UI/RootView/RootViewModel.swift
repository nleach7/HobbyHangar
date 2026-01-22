//
//  RootViewModel.swift
//  HobbyHangar
//
//  Created by Nick Leach on 1/15/26.
//

import Foundation
import SwiftUI
import Observation

@Observable final class RootViewModel {
    private let container: DIContainer
    let appState: AppState

    init(container: DIContainer) {
        self.container = container

        guard let appState = container.resolve(serviceType: (any ApplicationState).self) as? AppState else {
            fatalError("Failed to get an instance of AppState")
        }

        self.appState = appState
    }

    var selectedTab: Tab {
        get { appState.navigation.selectedTab }
        set { appState.navigation.selectedTab = newValue }
    }
}

// MARK: - Child ViewModels
extension RootViewModel {
    func makeLogbookViewModel() -> LogbookViewModel {
        .init(container: container)
    }

    func makeHangarViewModel() -> HangarViewModel {
        .init(container: container)
    }

    func makeBatteryTrackerViewModel() -> BatteryTrackerViewModel {
        .init(container: container)
    }

    func makePilotProfileViewModel() -> PilotProfileViewModel {
        .init(container: container)
    }
}
