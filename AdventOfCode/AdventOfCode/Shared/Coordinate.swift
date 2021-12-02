//
//  Coordinate.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/3/20.
//

import Foundation

protocol CoordinateLike {
    var x: Int { get }
    var y: Int { get }
}

public struct Coordinate: CoordinateLike, Hashable, Equatable, CustomDebugStringConvertible {
    let x: Int
    let y: Int
    let name: String?

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        self.name = nil
    }

    init(coordinate: Coordinate, name: String) {
        self.x = coordinate.x
        self.y = coordinate.y
        self.name = name
    }

    /// Returns the Manhattan distance between two coordinates.
    func distance(to coordB: Coordinate) -> Int {
        return abs(x - coordB.x) + abs(y - coordB.y)
    }

    /// Returns a new Coordinate adjusted by the given offsets
    func moving(xOffset: Int, yOffset: Int) -> Coordinate {
        Coordinate(x: x + xOffset, y: y + yOffset)
    }

    // MARK: - CustomDebugStringConvertable

    public var debugDescription: String {
        if let name = name {
            return "Coordinate(\(x)x\(y) '\(name)')"
        } else {
            return "Coordinate(\(x)x\(y))"
        }
    }

    // MARK: - Equatable

    public static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        // don't check the name
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
