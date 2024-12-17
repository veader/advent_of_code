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
