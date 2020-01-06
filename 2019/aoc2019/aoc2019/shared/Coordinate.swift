//
//  Coordinate.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/3/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

protocol CoordinateLike {
    var x: Int { get }
    var y: Int { get }
}

enum MoveDirection: Int, Equatable, CaseIterable {
    case north = 1
    case south = 2
    case west = 3
    case east = 4

    var opposite: MoveDirection {
        switch self {
        case .north:
            return .south
        case .south:
            return .north
        case .east:
            return .west
        case .west:
            return .east
        }
    }

    var stringValue: String {
        switch self {
        case .north:
            return "north"
        case .south:
            return "south"
        case .east:
            return "east"
        case .west:
            return "west"
        }
    }
}

public struct Coordinate: CoordinateLike, Hashable, Equatable, CustomDebugStringConvertible {
    let x: Int
    let y: Int
    let name: String?

    enum SlopeType: Equatable, CustomStringConvertible {
        case normal(slope: Float, direction: Int) /// normal slope (rise/run), direction +1 for up, -1 for down
        case vertical(direction: Int) /// vertical, direction +1 for up, -1 for down
        case horizontal(direction: Int) /// horizontal, direction +1 for right, -1 for left

        static func ==(lhs: SlopeType, rhs: SlopeType) -> Bool {
            switch (lhs, rhs) {
            case (.normal(slope: let slope1), .normal(slope: let slope2)):
                return slope1 == slope2
            case (.vertical(direction: let direction1), .vertical(direction: let direction2)):
                return direction1 == direction2
            case (.horizontal(direction: let direction1), .horizontal(direction: let direction2)):
                return direction1 == direction2
            default:
                return false
            }
        }

        var description: String {
            switch self {
            case .normal(slope: let slope, direction: let direction):
                return "Slope.Normal(slope: \(slope), direction: \(direction > 0 ? "up" : "down"))"
            case .vertical(direction: let direction):
                return "Slope.Vertical(direction: \(direction > 0 ? "up" : "down"))"
            case .horizontal(direction: let direction):
                return "Slope.Horizontal(direction: \(direction > 0 ? "right" : "left"))"
            }
        }
    }

    static var origin: Coordinate {
        return Coordinate(x: 0, y: 0)
    }

    public var debugDescription: String {
        if let name = name {
            return "Coordinate(\(x),\(y) '\(name)')"
        } else {
            return "Coordinate(\(x),\(y))"
        }
    }

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
        abs(x - coordB.x) + abs(y - coordB.y)
    }

    /// Returns the slope between two coordinats
    func slope(to coordB: Coordinate) -> SlopeType {
        let xDelta = coordB.x - self.x
        let yDelta = coordB.y - self.y

        if xDelta == 0 {
            return .vertical(direction: yDelta > 0 ? 1 : -1)
        } else if yDelta == 0 {
            return .horizontal(direction: xDelta > 0 ? 1 : -1)
        } else {
            return .normal(slope: Float(yDelta) / Float(xDelta),
                           direction: yDelta > 0 ? 1 : -1)
        }
    }

    /// Return the next coordinate on the given slope from this coordinate.
    func next(on slope: SlopeType) -> Coordinate {
        switch slope {
        case .horizontal(direction: let direction):
            return Coordinate(x: x + direction, y: y)
        case .vertical(direction: let direction):
            return Coordinate(x: x, y: y + direction)
        case .normal(slope: let slopeValue, direction: let direction):
            // y = mx + b -> b = y - mx or x = (y-b)/m
            let intercept = Float(y) - (slopeValue * Float(x))
            let newY = y + direction
            let newX = Int((Float(newY) - intercept) / Float(slopeValue))
            return Coordinate(x: newX, y: newY)
        }
    }

    /// Return location in the given direction relative to this coordinate.
    func location(for direction: MoveDirection) -> Coordinate {
        switch direction {
        case .north:
            return Coordinate(x: self.x, y: self.y + 1)
        case .south:
            return Coordinate(x: self.x, y: self.y - 1)
        case .east:
            return Coordinate(x: self.x + 1, y: self.y)
        case .west:
            return Coordinate(x: self.x - 1, y: self.y)
        }
    }

    /// Adjacent locations to this coordinate. (up, down, left, right)
    func adjacent() -> [Coordinate] {
        MoveDirection.allCases.map { location(for: $0) }
    }

    public static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        // don't check the name
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}
