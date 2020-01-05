//
//  DepthCoordinate.swift
//  aoc2019
//
//  Created by Shawn Veader on 1/4/20.
//  Copyright © 2020 Shawn Veader. All rights reserved.
//

import Foundation

struct DepthCoordinate: Equatable {
    let depth: Int
    let coordinate: Coordinate

    var x: Int { coordinate.x }
    var y: Int { coordinate.y }

    /// Return location in the given direction relative to this coordinate.
    ///
    /// Assumptions: Origin (0,0) is in upper left, directions taken accordingly.
    func locations(for direction: MoveDirection, size: Int) -> [DepthCoordinate] {
        let range = (0..<size)
        let mid = size / 2

        switch direction {
        case .north:
            if y - 1 < range.lowerBound {
                // go down a depth and look right above center
                return [DepthCoordinate(depth: depth - 1, coordinate: Coordinate(x: mid, y: mid - 1))]
            } else if y - 1 == mid && x == mid {
                // go up a depth and grab bottom row of inner grid
                return range.map { DepthCoordinate(depth: depth + 1, coordinate: Coordinate(x: $0, y: range.upperBound - 1)) }
            } else {
                return [DepthCoordinate(depth: depth, coordinate: Coordinate(x: x, y: y - 1))]
            }
        case .south:
            if y + 1 >= range.upperBound {
                // go down a depth and look right below center
                return [DepthCoordinate(depth: depth - 1, coordinate: Coordinate(x: mid, y: mid + 1))]
            } else if y + 1 == mid && x == mid {
                // go up a depth and grab top row of inner grid
                return range.map { DepthCoordinate(depth: depth + 1, coordinate: Coordinate(x: $0, y: range.lowerBound)) }
            } else {
                return [DepthCoordinate(depth: depth, coordinate: Coordinate(x: x, y: y + 1))]
            }
        case .east:
            if x + 1 >= range.upperBound {
                // go down a depth and look to the right of center
                return [DepthCoordinate(depth: depth - 1, coordinate: Coordinate(x: mid + 1, y: mid))]
            } else if x + 1 == mid && y == mid {
                // go up a depth and grab left column of inner grid
                return range.map { DepthCoordinate(depth: depth + 1, coordinate: Coordinate(x: range.lowerBound, y: $0)) }
            } else {
                return [DepthCoordinate(depth: depth, coordinate: Coordinate(x: x + 1, y: y))]
            }
        case .west:
            if x - 1 < range.lowerBound {
                // go down a depth and look to the left of center
                return [DepthCoordinate(depth: depth - 1, coordinate: Coordinate(x: mid - 1, y: mid))]
            } else if x - 1 == mid && y == mid {
                // go up a depth and grab right column of inner grid
                return range.map { DepthCoordinate(depth: depth + 1, coordinate: Coordinate(x: range.upperBound - 1, y: $0)) }
            } else {
                return [DepthCoordinate(depth: depth, coordinate: Coordinate(x: x - 1, y: y))]
            }
        }
    }

    /// Adjacent locations to this coordinate. (up, down, left, right)
    func adjacent(size: Int) -> [DepthCoordinate] {
        MoveDirection.allCases.flatMap { locations(for: $0, size: size) }
    }
}
