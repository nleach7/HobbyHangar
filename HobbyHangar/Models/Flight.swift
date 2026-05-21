//
//  Flight.swift
//  HobbyHangar
//
//  Created by Nick Leach on 3/10/26.
//

import SwiftData

@Model
public final class Flight: Equatable {
    @Relationship(deleteRule: .nullify)
    var aircraft: Aircraft
    @Relationship(deleteRule: .nullify)
    var battery: Battery

    public init(aircraft: Aircraft, battery: Battery) {
        self.aircraft = aircraft
        self.battery = battery
    }
}
