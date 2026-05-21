//
//  Battery.swift
//  HobbyHangar
//
//  Created by Nick Leach on 2/20/26.
//

import SwiftData

@Model
public final class Battery: Equatable {
    public var id: Int
    var name: String
    var chemestry: Chemistry
    var brand: String?
    var cells: Cells
    var capacity: Int
    var connector: Connector

    init(
        name: String,
        id: Int,
        chemestry: Chemistry,
        brand: String? = nil,
        cells: Cells,
        capacity: Int,
        connector: Connector
    ) {
        self.name = name
        self.id = id
        self.chemestry = chemestry
        self.brand = brand
        self.cells = cells
        self.capacity = capacity
        self.connector = connector
    }
}

public enum Connector: String, Codable, Equatable {
    case ph2 = "PH 2.0"
    case gnb27 = "GNB27"
    case a30 = "A30"
    case bt2 = "BT 2.0"
    case bt3 = "BT 3.0"
    case xt30 = "XT30"
    case xt60 = "XT60"
    case xt90 = "XT90"
    case deans = "Deans"
    case other = "Other"
}

public enum Chemistry: String, Codable, Equatable {
    case liFePo4 = "LiFePo4"
    case liIon = "Li-ion"
    case liPo = "LiPo"
    case niMH  = "NiMH"
    case niCad = "NiCad"
}

public nonisolated enum Cells: Codable, Equatable {
    case oneS(internalResistance: Int)
    case twoS(internalResistance: [Int])
    case threeS(internalResistance: [Int])
    case fourS(internalResistance: [Int])
    case fiveS(internalResistance: [Int])
    case sixS(internalResistance: [Int])
    case sevenS(internalResistance: [Int])
    case eightS(internalResistance: [Int])

    public var cellCount: Int {
        switch self {
        case .oneS:
            return 1

        case .twoS:
            return 2

        case .threeS:
            return 3

        case .fourS:
            return 4

        case .fiveS:
            return 5

        case .sixS:
            return 6

        case .sevenS:
            return 7

        case .eightS:
            return 8
        }
    }
}
