//
//  Line.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/5/21.
//

import Foundation

struct Line {
    enum Direction {
        case left
        case right
        case up
        case down
        case upLeft
        case upRight
        case downLeft
        case downRight
    }

    let start: Coordinate
    let end: Coordinate

    var isVertical: Bool {
        start.x == end.x
    }

    var isHorizontal: Bool {
        start.y == end.y
    }

    var isDiagonal: Bool {
        !(isVertical || isHorizontal)
    }

    var direction: Direction {
        if start.x == end.x { // straight
            if start.y < end.y {
                return .down
            } else {
                return .up
            }
        } else if start.x < end.x { // right
            if start.y == end.y { // straight
                return .right
            } else if start.y < end.y { // down
                return .downRight
            } else { // up
                return .upRight
            }
        } else { // left
            if start.y == end.y { // straight
                return .left
            } else if start.y < end.y { // down
                return .downLeft
            } else { // up
                return .upLeft
            }
        }
    }

    /// Return all points along this line
    func points() -> [Coordinate] {
        var coordinates = [Coordinate]()

        var xOffset = 0
        var yOffset = 0
        switch direction {
        case .up:
            xOffset = 0
            yOffset = -1
        case .down:
            xOffset = 0
            yOffset = 1
        case .left:
            xOffset = -1
            yOffset = 0
        case .right:
            xOffset = 1
            yOffset = 0
        case .downLeft:
            xOffset = -1
            yOffset = 1
        case .downRight:
            xOffset = 1
            yOffset = 1
        case .upRight:
            xOffset = 1
            yOffset = -1
        case .upLeft:
            xOffset = -1
            yOffset = -1
        }

        var point = start
        while point != end {
            coordinates.append(point)
            point = point.moving(xOffset: xOffset, yOffset: yOffset)
        }
        coordinates.append(end)
        return coordinates
    }

    static func parse(_ input: String) -> Line? {
        // https://rubular.com/r/SRuMN9HLeltHaZ
        let lineRegEx = "(\\d+),(\\d+)\\s+->\\s+(\\d+),(\\d+)"
        guard
            let match = input.matching(regex: lineRegEx),
            match.captures.count == 4,
            let startX = Int(match.captures[0]),
            let startY = Int(match.captures[1]),
            let endX = Int(match.captures[2]),
            let endY = Int(match.captures[3])
        else { return nil }

        return Line(start: Coordinate(x: startX, y: startY), end: Coordinate(x: endX, y: endY))
    }
}

extension Line: CustomDebugStringConvertible {
    var debugDescription: String {
        return "Line(start:\(start), end:\(end))"
    }
}
