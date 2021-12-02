//
//  ConwayCube.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/17/20.
//

import Foundation

struct ConwayCube<CoordinateType> {
    let coordinate: CoordinateType
    let isActive: Bool

    /// Return a new Conway Cube that has the active status flipped
    var flipped: ConwayCube {
        ConwayCube(coordinate: coordinate, isActive: !isActive)
    }
}

extension ConwayCube: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {
        (isActive ? "#" : ".")
    }

    var debugDescription: String {
        "<ConwayCube: @\(coordinate) active:\(isActive ? "yes" : "no") >"
    }
}
