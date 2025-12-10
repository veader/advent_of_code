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

public struct Coordinate: CoordinateLike, Hashable {
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

    init?(_ input: String?) {
        guard let input, !input.isEmpty else { return nil }

        let nums = input.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ",").map(String.init).compactMap(Int.init)
        guard nums.count == 2, let x = nums.first, let y = nums.last else { return nil }

        self.x = x
        self.y = y
        self.name = nil
    }

    /// Return a `Coordinate` at the origin (ie: 0,0)
    static var origin: Coordinate {
        Coordinate(x: 0, y: 0)
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

    /// Find the relative direction of the given coordinate relative to ourself.
    func direction(to coordB: Coordinate, originTopLeft: Bool = false) -> RelativeDirection {
        guard self != coordB else { return .same }
        let dX = coordB.x - self.x
        let dY = coordB.y - self.y

        if dX == 0 { // moving north/south
            if dY >= 0 {
                return originTopLeft ? .south : .north
            } else {
                return originTopLeft ? .north : .south
            }
        } else if dY == 0 { // moving east/west
            if dX >= 0 {
                return .east
            } else {
                return .west
            }
        } else { // moving diagonally
            if dY >= 0 && dX >= 0 {
                return originTopLeft ? .southEast : .northEast
            } else if dY >= 0 && dX < 0 {
                return originTopLeft ? .southWest : .northWest
            } else if dY < 0 && dX >= 0 {
                return originTopLeft ? .northEast : .southEast
            } else {
                return originTopLeft ? .northWest : .southWest
            }
        }
    }

    /// Returns a new Coordinate created by following the given direction.
    func moving(direction: RelativeDirection, originTopLeft: Bool = false) -> Coordinate {
        var dX = 0
        switch direction {
        case .northEast, .east, .southEast:
            dX = 1
        case .northWest, .west, .southWest:
            dX = -1
        case .north, .south, .same:
            dX = 0
        }

        var dY = 0
        switch direction {
        case .northWest, .north, .northEast:
            dY = originTopLeft ? -1 : 1
        case .southWest, .south, .southEast:
            dY = originTopLeft ? 1 : -1
        case .east, .west, .same:
            dY = 0
        }

        return moving(xOffset: dX, yOffset: dY)
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
}

extension Coordinate {
    /// The delta between two points (x offset and y offset)
    struct GridDelta: Equatable, Hashable {
        let x: Int
        let y: Int

        /// What is the opposite delta of this delta.
        ///
        /// Example: (X, Y) -> (-X, -Y) or (X, -Y) -> (-X, Y)
        var opposite: GridDelta {
            GridDelta(x: -x, y: -y)
        }
    }

    /// The "delta" (meaning x offset and y offset) from this point to another.
    func delta(to c2: Coordinate, originTopLeft: Bool = false) -> GridDelta {
        if originTopLeft {
            GridDelta(x: c2.x - self.x, y: c2.y - self.y)
        } else {
            GridDelta(x: self.x - c2.x, y: self.y - c2.y)
        }
    }

    /// Apply the "delta" to the given coordinate to find the new coordinate.
    func applying(delta: GridDelta, originTopLeft: Bool = false) -> Coordinate {
        if originTopLeft {
            Coordinate(x: self.x + delta.x, y: self.y + delta.y)
        } else {
            Coordinate(x: self.x - delta.x, y: self.y - delta.y)
        }
    }
}

// MARK: - CustomDebugStringConvertible
extension Coordinate: CustomDebugStringConvertible {
    public var debugDescription: String {
        if let name = name {
            return "Coordinate(\(x)x\(y) '\(name)')"
        } else {
            return "Coordinate(\(x)x\(y))"
        }
    }
}

// MARK: - Equatable
extension Coordinate: Equatable {
    public static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        // don't check the name
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

// MARK: - Comparable
extension Coordinate: Comparable {
    public static func < (lhs: Coordinate, rhs: Coordinate) -> Bool {
        lhs.x < rhs.x && lhs.y < rhs.y
    }
}

