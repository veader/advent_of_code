//
//  DayThree.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/3/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct DayThree: AdventDay {
    var dayNumber: Int = 3

    func parse(_ input: String?) -> [Wire] {
        // each line describes a wire's path
        let wireDescriptions = (input ?? "").split(separator: "\n")

        // turn the wire descriptions into Wire structures
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
        }.filter { $0 != Coordinate.origin }

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
        let wires = parse(input)

        guard let wireA = wires.first, let wireB = wires.last else {
            return Int.max
        }

        var distanceHash = [Coordinate: Int]()

        wireA.segments.forEach { segA in
            wireB.segments.forEach { segB in
                if let intersection = segB.intersection(segA), intersection != Coordinate.origin {
                    // at a point of intersection, calculate distance to start of each wire
                    let distanceA = segA.intersectionDistance(segB)
                    let distanceB = segB.intersectionDistance(segA)
                    // print("Intersection: \(intersection) A:\(distanceA) B:\(distanceB)")
                    distanceHash[intersection] = distanceA + distanceB
                }
            }
        }

        return distanceHash.min { $0.value < $1.value }?.value ?? Int.max
    }
}
