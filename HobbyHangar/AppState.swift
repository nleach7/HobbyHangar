//
//  AppState.swift
//  HobbyHangar
//
//  Created by Nick Leach on 1/15/26.
//

import Foundation
import Observation

// MARK: - Tab
enum Tab: Hashable {
    case logbook
    case hangar
    case batteryTracker
    case pilotProfile
}

// MARK: - Navigation
struct Navigation: Equatable {
    var selectedTab: Tab = .logbook
}

// MARK: - System
struct System: Equatable {
    var isActive: Bool = false
}

// MARK: - Protocol
protocol AppState: AnyObject {
    var system: System { get set }
    var navigation: Navigation { get set }
}

// MARK: - AppState
@MainActor
@Observable final class ApplicationState: AppState {
    var system: System
    var navigation: Navigation

    init() {
        self.system = System()
        self.navigation = Navigation()
    }
}

extension ApplicationState {
    static var preview: ApplicationState {
        let state = ApplicationState()
        state.system.isActive = true
        return state
    }
}
