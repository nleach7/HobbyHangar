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
    private let pilotService: PilotServiceable

    var displayText: String?

    init(container: DIContainer) {

        self.container = container

        guard let pilotService = container.resolve(serviceType: (any PilotServiceable).self) else {
            fatalError("Failed to get an instance of PilotServiceable")
        }

        self.pilotService = pilotService

        Task {
            displayText = await pilotService.getText()
        }
    }
}
