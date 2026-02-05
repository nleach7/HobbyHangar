//
//  RootViewModel.swift
//  HobbyHangar
//
//  Created by Nick Leach on 1/15/26.
//

import Foundation
import SwiftUI
import Observation
import FactoryKit

@Observable final class RootViewModel {

    private let appState: AppState
    private let logger: AppLoggable

    init() {
        appState = Container.shared.appState()
        logger = Container.shared.appLogger()
    }

    var selectedTab: Tab {
        get { appState.navigation.selectedTab }
        set { appState.navigation.selectedTab = newValue }
    }
}

// MARK: - Child ViewModels
extension RootViewModel {
    func makeLogbookViewModel() -> LogbookViewModel {
        .init()
    }

    func makeHangarViewModel() -> HangarViewModel {
        .init()
    }

    func makeBatteryTrackerViewModel() -> BatteryTrackerViewModel {
        .init()
    }

    func makePilotProfileViewModel() -> PilotProfileViewModel {
        .init()
    }
}
