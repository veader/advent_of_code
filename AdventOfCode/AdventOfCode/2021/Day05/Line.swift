//
//  Line.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/5/21.
//

import Foundation

struct Line {
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

    /// Return all points along this line
    func points() -> [Coordinate] {
        var coordinates = [Coordinate]()
        // TODO: handle diagnoals
        if isDiagonal {
            return []
        } else {
            let xs = [start.x, end.x]
            let ys = [start.y, end.y]
            (xs.min()!...xs.max()!).forEach { x in
                (ys.min()!...ys.max()!).forEach { y in
                    coordinates.append(Coordinate(x: x, y: y))
                }
            }
        }
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
