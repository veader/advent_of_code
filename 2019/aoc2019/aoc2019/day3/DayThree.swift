//
//  DayThree.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/3/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct Wire {
    struct WireSegment {
        let start: Coordinate
        let end: Coordinate

        var xRange: ClosedRange<Int> {
            let minX = min(start.x, end.x)
            let maxX = max(start.x, end.x)
            return minX...maxX
        }

        var yRange: ClosedRange<Int> {
            let minY = min(start.y, end.y)
            let maxY = max(start.y, end.y)
            return minY...maxY
        }

        var vertical: Bool {
            return start.x == end.x // x is constant
        }

        var horizontal: Bool {
            return start.y == end.y // y is constant
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

        /// - Note: Assumes both lines are either horizontal or vertical
        func intersects(_ segment: WireSegment) -> Bool {
            return intersection(segment) != nil
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

        switch direction {
        case "U":
            newSegment = WireSegment(start: start, end: Coordinate(x: start.x, y: start.y + distance))
        case "D":
            newSegment = WireSegment(start: start, end: Coordinate(x: start.x, y: start.y - distance))
        case "L":
            newSegment = WireSegment(start: start, end: Coordinate(x: start.x + distance, y: start.y))
        case "R":
            newSegment = WireSegment(start: start, end: Coordinate(x: start.x - distance, y: start.y))
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

struct DayThree: AdventDay {

    var dayNumber: Int = 3

    func parse(_ input: String?) -> [Wire] {
        let wireDescriptions = (input ?? "").split(separator: "\n")
        return wireDescriptions.map { line -> Wire in
            var wire = Wire()

            var location = Coordinate.origin // 0,0

            let segmentDescriptions = line.split(separator: ",").map { String($0) }
            for description in segmentDescriptions {
                if let segment = wire.addSegment(start: location, description: description) {
                    location = segment.end
                } else {
                    print("Problem adding segment: \(description) from: \(location)")
                }
            }

            // print("Wire: segments:\(wire.segments.count), intersects:\(wire.selfIntersectCount) -------------")

            return wire
        }
    }

    func partOne(input: String?) -> Any {
        let wires = parse(input)

        guard let wireA = wires.first, let wireB = wires.last else {
            return Int.max
        }

        // find where each segment of wireA might cross wireB
        let intersections = wireA.segments.flatMap { segment -> [Coordinate] in
            return wireB.segments.compactMap { $0.intersection(segment) }
        }

        // find shortest distance between origin and intersection points
        var distanceHash = [Coordinate: Int]()
        intersections.forEach { coord in
            distanceHash[coord] = Coordinate.origin.distance(to: coord)
        }

//        print(intersections)
//        print(distanceHash)

        return distanceHash.min { $0.value < $1.value }?.value ?? Int.max
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
