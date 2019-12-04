//
//  Wire.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/4/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct Wire {
    struct WireSegment {
        let start: Coordinate
        let end: Coordinate
        let distanceFromOrigin: Int

        var xRange: ClosedRange<Int> {
            min(start.x, end.x)...max(start.x, end.x)
        }

        var yRange: ClosedRange<Int> {
            min(start.y, end.y)...max(start.y, end.y)
        }

        var length: Int {
            start.distance(to: end)
        }

        var vertical: Bool {
            start.x == end.x // x is constant
        }

        var horizontal: Bool {
            start.y == end.y // y is constant
        }

        /// - Note: Assumes both lines are either horizontal or vertical
        func intersection(_ segment: WireSegment) -> Coordinate? {
            if vertical && segment.horizontal {
                // my x is in their range
                // their y is in my range
                if segment.xRange.contains(self.start.x) &&
                    self.yRange.contains(segment.start.y)
                {
                    return Coordinate(x: self.start.x, y: segment.start.y)
                }
            } else if horizontal && segment.vertical {
                // my y is in their range
                // their x is in my range
                if segment.yRange.contains(self.start.y) &&
                    self.xRange.contains(segment.start.x)
                {
                    return Coordinate(x: segment.start.x, y: self.start.y)
                }
            }

            // y = mx + b && y in start.y...end.y && x in start.x...end.x

            return nil
        }

        /// Total distance from origin of wire to the intersection point
        func intersectionDistance(_ segment: WireSegment) -> Int {
            guard let intersectionCoordinate = intersection(segment) else { return Int.max }
            return start.distance(to: intersectionCoordinate) + distanceFromOrigin
        }

        /// - Note: Assumes both lines are either horizontal or vertical
        func intersects(_ segment: WireSegment) -> Bool {
            intersection(segment) != nil
        }

//        var slope: Float {
//            // y = mx + b, find m
//            let xDelta = Float(start.x - end.x)
//            guard xDelta != 0 else { return Float.greatestFiniteMagnitude }
//            return Float(start.y - end.y) / xDelta
//        }
//
//        var yIntercept: Int {
//            // y = mx + b, find b
//            return 0
//        }
    }

    var segments = [WireSegment]()
    var selfIntersectCount: Int = 0

    mutating func addSegment(start: Coordinate, description: String) -> WireSegment? {
        guard
            let direction = description.first,
            let distance = Int(String(description.dropFirst()))
            else { return nil }

        var newSegment: WireSegment?

        let distanceFromOrigin = segments.map { $0.length }.reduce(0, +)

        switch direction {
        case "U":
            newSegment = WireSegment(start: start, end: Coordinate(x: start.x, y: start.y + distance), distanceFromOrigin: distanceFromOrigin)
        case "D":
            newSegment = WireSegment(start: start, end: Coordinate(x: start.x, y: start.y - distance), distanceFromOrigin: distanceFromOrigin)
        case "L":
            newSegment = WireSegment(start: start, end: Coordinate(x: start.x + distance, y: start.y), distanceFromOrigin: distanceFromOrigin)
        case "R":
            newSegment = WireSegment(start: start, end: Coordinate(x: start.x - distance, y: start.y), distanceFromOrigin: distanceFromOrigin)
        default:
            break
        }

        if let segment = newSegment {
            // print("Segment: \(segment.start)-\(segment.end) \"\(description)\"")
            let intersectCount = segments.filter { $0.intersects(segment) }.count
            selfIntersectCount += intersectCount
            segments.append(segment)
        } else {
            print("Problem with adding segment: \(description) from: \(start)")
        }

        return newSegment
    }
}
