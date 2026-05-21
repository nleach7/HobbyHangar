//
//  Aircraft.swift
//  HobbyHangar
//
//  Created by Nick Leach on 2/20/26.
//

import Foundation
import SwiftData

// swiftlint:disable identifier_name
@Model
public final class Aircraft: Equatable {
    var name: String
    @Attribute(.externalStorage)
    var imageData: Data?
    var propSize: String?
    var flightController: String?
    var esc: String?
    var vtx: VTXType?
    var motors: [Motor]
    var receiver: ReceiverType?
    var gps: String?

    public init(
        name: String,
        imageData: Data? = nil,
        propSize: String? = nil,
        flightController: String? = nil,
        esc: String? = nil,
        vtx: VTXType? = nil,
        motors: [Motor] = [],
        receiver: ReceiverType? = nil,
        gps: String? = nil
    ) {
        self.name = name
        self.imageData = imageData
        self.propSize = propSize
        self.flightController = flightController
        self.esc = esc
        self.vtx = vtx
        self.motors = motors
        self.receiver = receiver
        self.gps = gps
    }
}

public enum VTXType: Codable, Equatable {
    case analog
    case hdZero(firmwareVersion: String)
    case dji(type: DjiVtxType, firmwareVersion: String)
    case walkSnail(firmwareVersion: String)
    case artosyn(firmwareVersion: String)
}

public enum DjiVtxType: String, Codable, Equatable {
    case vista = "Vista"
    case o3 = "O3"
    case o4Pro = "O4 Pro"
    case o4 = "O4"
}

public enum ReceiverType: Codable, Equatable {
    case elrs(version: String)
    case crossfire
    case tracer
    case ghost
    case frSky
    case flySky
}

public struct Motor: Codable, Equatable {
    public var statorSize: Int
    public var kv: Int
}
// swiftlint:enable identifier_name
