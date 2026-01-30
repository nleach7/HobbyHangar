//
//  HangarViewModel.swift
//  HobbyHangar
//
//  Created by Nick Leach on 1/21/26.
//

import Foundation
import Observation
import FactoryKit

@Observable final class HangarViewModel {
    private let appState: AppState

    init() {
        self.appState = Container.shared.appState()
    }
}
