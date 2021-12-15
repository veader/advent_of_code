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

    /// Parse a given line of input to create a `Coordinate`.
    ///
    /// - note: Format of line should be `x,y`
    static func parse(_ input: String) -> Coordinate? {
        let pieces = input.split(separator: ",").map(String.init)
        guard
            pieces.count == 2,
            let xStr = pieces.first, let x = Int(xStr),
            let yStr = pieces.last, let y = Int(yStr)
        else { return nil }

        return Coordinate(x: x, y: y)
    }

    /// Returns the Manhattan distance between two coordinates.
    func distance(to coordB: Coordinate) -> Int {
        return abs(x - coordB.x) + abs(y - coordB.y)
    }

    /// Returns a new Coordinate adjusted by the given offsets
    func moving(xOffset: Int, yOffset: Int) -> Coordinate {
        Coordinate(x: x + xOffset, y: y + yOffset)
    }

    /// Return adjacent coordinates to this coordinate (without allowing diagonals). Bounds are considered.
    func adjacentWithoutDiagonals(xBounds: ClosedRange<Int>?, yBounds: ClosedRange<Int>?) -> [Coordinate] {
        let theXBounds = xBounds ?? (0...Int.max)
        let theYBounds = yBounds ?? (0...Int.max)

        var adj = [Coordinate]()
        if theYBounds.contains(y - 1) { // up
            adj.append(Coordinate(x: x, y: y - 1))
        }
        if theYBounds.contains(y + 1) { // down
            adj.append(Coordinate(x: x, y: y + 1))
        }
        if theXBounds.contains(x - 1) { // left
            adj.append(Coordinate(x: x - 1, y: y))
        }
        if theXBounds.contains(x + 1) { // right
            adj.append(Coordinate(x: x + 1, y: y))
        }
        return adj
    }

    /// Return all adjacent coordinates to this coordinate taking bounds into account
    func adjacent(xBounds: ClosedRange<Int>?, yBounds: ClosedRange<Int>?) -> [Coordinate] {
        let theXBounds = xBounds ?? (0...Int.max)
        let theYBounds = yBounds ?? (0...Int.max)
        return adjacent(minX: theXBounds.lowerBound, maxX: theXBounds.upperBound, minY: theYBounds.lowerBound, maxY: theYBounds.upperBound)
    }

    /// Return all adjacent coordinates to this coordinate
    func adjacent(minX: Int = 0, maxX: Int? = nil, minY: Int = 0, maxY: Int? = nil) -> [Coordinate] {
        guard
            let lowerY = [minY, y - 1].max(),
            let upperY = [maxY ?? Int.max, y + 1].min(),
            lowerY < upperY,
            let lowerX = [minX, x - 1].max(),
            let upperX = [maxX ?? Int.max, x + 1].min(),
            lowerX < upperX
        else { return [] }

        return (lowerY...upperY).flatMap { dY in
            (lowerX...upperX).compactMap { dX in
                let c = Coordinate(x: dX, y: dY)
                guard c != self else { return nil }
                return c
            }
        }
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
