//
//  GridLine.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/17/24.
//

import Foundation

struct GridLine: Equatable {
    let start: Coordinate
    let end: Coordinate

    var points: [Coordinate] {
        [start, end]
    }

    var pointsAlongTheLine: [Coordinate] {
        let sorted = [start, end].sorted()
        let lineStart = sorted[0]
        let lineEnd = sorted[1]

        var linePoints: [Coordinate] = [lineStart]
        var point = lineStart

        if start.x == end.x {
            // vertical - x stays the same
            while point != lineEnd {
                point = point.moving(xOffset: 0, yOffset: 1)
                linePoints.append(point)
            }
        } else if start.y == end.y {
            // horizontal - y stays the same
            while point != lineEnd {
                point = point.moving(xOffset: 1, yOffset: 0)
                linePoints.append(point)
            }
        } else {
            // diagnoal
            // TODO: make this work
            linePoints.append(lineEnd)
        }

        return linePoints
    }

    init(start: Coordinate, end: Coordinate) {
        let coords = [start, end].sorted()
        self.start = coords[0]
        self.end = coords[1]
    }

    public static func == (lhs: GridLine, rhs: GridLine) -> Bool {
        // reversed shouldn't be needed now that we are sorting on init...
        return (lhs.points == rhs.points) // || (lhs.points == rhs.points.reversed())
    }
}
