//
//  DIContainer.swift
//  HobbyHangar
//
//  Created by Nick Leach on 1/15/26.
//

import SwiftUI
import Swinject
import Combine

struct DIContainer {

    private let container: Container
    private let synchronizedResolver: Resolver

    init(useStubs: Bool = false) {
        container = Container()
        synchronizedResolver = container.synchronize()

        if useStubs {
#if DEBUG
            bootstrapStubs()
#endif
        } else {
            bootstrap()
        }
    }

    func bootstrap() {
        let appState = AppState()
        let dbRepository = DatabaseRepository()

        container.register((any ApplicationState).self) { _ in
            appState
        }.inObjectScope(.container)

        container.register(DBRepository.self) { _ in
            dbRepository
        }.inObjectScope(.transient)

        container.register(PilotServiceable.self) { _ in
            PilotService(databaseRepository: dbRepository, appState: appState)
        }.inObjectScope(.transient)
    }

    func resolve<P>(serviceType: P.Type) -> P? {
        return synchronizedResolver.resolve(serviceType.self)
    }
}

#if DEBUG
extension DIContainer {
    static var preview: Self {
        .init(useStubs: true)
    }

    func bootstrapStubs() {
        let dbRepository = StubDBRepository()

        container.register((any ApplicationState).self) { _ in
            AppState()
        }.inObjectScope(.container)

        container.register(DBRepository.self) { _ in
            dbRepository
        }.inObjectScope(.transient)

        container.register(PilotServiceable.self) { _ in
            StubPilotService(databaseRepository: dbRepository)
        }
    }
}
#endif
