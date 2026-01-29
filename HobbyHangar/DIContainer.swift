//
//  DIContainer.swift
//  HobbyHangar
//
//  Created by Nick Leach on 1/15/26.
//

import Swinject

struct DIContainer {

    private let container: Container
    private let synchronizedResolver: Resolver

    init(useStubs: Bool = false) {
        container = Container()
        synchronizedResolver = container.synchronize()

        if useStubs {
            bootstrapStubs()
        } else {
            bootstrap()
        }
    }

    func bootstrap() {
        #if DEBUG
        let logger = ApplicationLogger(isDebug: true)
        #else
        let logger = ApplicationLogger(isDebug: false)
        #endif

        let appState = AppState()
        let dbRepository = DatabaseRepository()
        let postHogConfig = PostHog()

        container.register(AppLogger.self) { _ in
            logger
        }.inObjectScope(.transient)

        container.register(PostHogService.self) { _ in
            postHogConfig
        }.inObjectScope(.container)

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

extension DIContainer {
    static var preview: Self {
        .init(useStubs: true)
    }

    func bootstrapStubs() {
        let appState = AppState()
        let dbRepository = StubDBRepository()

        container.register((any ApplicationState).self) { _ in
            appState
        }.inObjectScope(.container)

        container.register(DBRepository.self) { _ in
            dbRepository
        }.inObjectScope(.transient)

        container.register(PilotServiceable.self) { _ in
            StubPilotService(databaseRepository: dbRepository)
        }
    }
}
