//
//  BatteryTrackerViewModel.swift
//  HobbyHangar
//
//  Created by Nick Leach on 1/21/26.
//

import Foundation
import Observation

@Observable final class BatteryTrackerViewModel {
    private let appState: AppState

    init(container: DIContainer) {
        guard let appState = container.resolve(serviceType: (any ApplicationState).self) as? AppState else {
            fatalError("Failed to get an instance of AppState")
        }

        self.appState = appState
    }
}
