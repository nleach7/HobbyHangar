//
//  DatabaseRepository.swift
//  HobbyHangar
//
//  Created by Nick Leach on 1/15/26.
//

import Foundation

protocol DBRepository {
    // Protocol for database repository operations
}

final class DatabaseRepository: DBRepository {
    // Database repository implementation
}

#if DEBUG
final class StubDBRepository: DBRepository {
    // stub implementation
}
#endif
