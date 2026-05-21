//
//  Pilot.swift
//  HobbyHangar
//
//  Created by Nick Leach on 2/20/26.
//

import Foundation
import SwiftData

@Model
public final class Pilot: Equatable {
    var firstName: String?
    var lastName: String?
    var callsign: String
    @Attribute(.externalStorage)
    var profilePicture: Data?

    init(firstName: String? = nil, lastName: String? = nil, callsign: String, profilePicture: Data? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.callsign = callsign
        self.profilePicture = profilePicture
    }
}
