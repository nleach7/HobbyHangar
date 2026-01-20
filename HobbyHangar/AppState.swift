//
//  AppState.swift
//  HobbyHangar
//
//  Created by Nick Leach on 1/15/26.
//

import Foundation

// MARK: - Protocol
protocol ApplicationState: Equatable {
    var system: System { get set }
}

struct System: Equatable {
    var isActive: Bool = false
}

// MARK: - AppState
@MainActor
struct AppState: @MainActor ApplicationState, Equatable {
    var system: System

    init() {
        self.system = System()
    }
}

#if DEBUG
extension AppState {
    static var preview: AppState {
        var state = AppState()
        state.system.isActive = true
        return state
    }
}
#endif
