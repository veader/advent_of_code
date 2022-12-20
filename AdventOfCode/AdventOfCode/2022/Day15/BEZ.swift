//
//  BEZ.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/18/22.
//

import Foundation
import RegexBuilder

class BEZ {
    class SensorBeacon {
        let sensor: Coordinate
        let beacon: Coordinate
        let distance: Int

        /// A range of all possible y values this sensor can see.
        let yValues: ClosedRange<Int>

        /// A mapping of y values to the ranges of x values the sensor can see.
        ///
        /// With of x values is based on the Manhattan Distance from the sensor.
        var xValues: [Int: ClosedRange<Int>]

        init(sx: Int, sy: Int, bx: Int, by: Int) {
            sensor = Coordinate(x: sx, y: sy)
            beacon = Coordinate(x: bx, y: by)
            distance = sensor.distance(to: beacon)
            yValues = ((sensor.y - distance)...(sensor.y + distance))
            xValues = [:]

            calculateXRanges()
        }

        private func calculateXRanges() {
            for y in yValues {
                if let xs = points(on: y) {
                    xValues[y] = xs
                }
            }
        }

        func points(on y: Int) -> ClosedRange<Int>? {
            guard yValues.contains(y) else { return nil }

            let delta = abs(y - sensor.y)
            let modDistance = abs(distance - delta)
            guard modDistance > 0 else { return nil }

            return ((sensor.x - modDistance)...(sensor.x + modDistance))
        }
    }

    var pairs: [SensorBeacon]

    init(_ input: String) {
        pairs = BEZ.parse(input)
    }

    func occupied(on y: Int, subtract: Bool = true) -> Set<Int> {
        var points = Set<Int>()

        for pair in pairs {
            if let pts = pair.xValues[y] {
                points = points.union(Set(pts))
            }
        }

        if subtract {
            let sensors = pairs.map(\.sensor).filter({ $0.y == y }).map(\.x)
            let beacons = pairs.map(\.beacon).filter({ $0.y == y }).map(\.x)

            points = points.subtracting(sensors).subtracting(beacons)
        }

        return points
    }

    /// Find and return the gaps on a given `y` value for the sensors.
    func findGapsInSensors(on y: Int) -> [Int] {
        var ranges = [ClosedRange<Int>]()

        for pair in pairs {
            if let range = pair.xValues[y] {
                ranges.append(range)
            }
        }

        // now determine how many overlaps we have and where they don't touch
        var sortedRanges = ranges.sorted(by: { $0.lowerBound < $1.lowerBound })
//        print("Found ranges at \(y): \(sortedRanges.map({ "\($0)" }).joined(separator: ", "))")
        guard sortedRanges.count > 0 else { return [] }

        var largerRanges = [ClosedRange<Int>]()
        var gaps = [Int]()

        var range: ClosedRange<Int> = sortedRanges.removeFirst()
        repeat {
            let r = sortedRanges.removeFirst()
            if range.overlaps(r) {
                range = (min(range.lowerBound, r.lowerBound))...(max(range.upperBound, r.upperBound))
            } else {
                // gap!
                // save off this range
                largerRanges.append(range)
                // measure and save the gap
                let gap = (range.upperBound+1)..<r.lowerBound
                gaps.append(contentsOf: Array(gap))
                // move to this as the start of the next larger rage
                range = r
            }
        } while sortedRanges.count > 0
        largerRanges.append(range)

//        print("Found ranges: \(largerRanges.map({ "\($0)" }).joined(separator: ", "))")

        return gaps
    }

    func search(limit: Int = 4_000_000) -> Coordinate? {
        print("\(#function) \t \(Date.now)")
        var minSensorY = pairs.map({ $0.sensor.y - $0.distance }).min() ?? 0
        var maxSensorY = pairs.map({ $0.sensor.y + $0.distance }).max() ?? 0

        minSensorY -= 1
        maxSensorY += 1

        // enforcing limits
        if minSensorY < 0 {
            minSensorY = 0
        }
        if maxSensorY > limit {
            maxSensorY = limit
        }

        let searchSpace = (minSensorY...maxSensorY)

        for y in searchSpace {
//            print("Searching y=\(y)... \t\(Date.now)")
            let gaps = findGapsInSensors(on: y)
            if let gap = gaps.first {
                return Coordinate(x: gap, y: y)
            }
        }

        print("Must have not found an empty spot...")
        return nil
    }

    
    // MARK: - Parsing

    static func parse(_ input: String) -> [SensorBeacon] {
        input.split(separator: "\n").map(String.init).compactMap { line in
            guard
                let match = line.firstMatch(of: lineRegex),
                let sensorX = Int(match.1),
                let sensorY = Int(match.2),
                let beaconX = Int(match.3),
                let beaconY = Int(match.4)
            else { return nil }

            return SensorBeacon(sx: sensorX, sy: sensorY, bx: beaconX, by: beaconY)
        }
    }

    // Sensor at x=407069, y=1770807: closest beacon is at x=105942, y=2000000
    static let lineRegex = Regex {
        "Sensor at x="
        Capture {
            Optionally { "-" }
            OneOrMore(.digit) }
        ", y="
        Capture {
            Optionally { "-" }
            OneOrMore(.digit)
        }
        ": closest beacon is at x="
        Capture {
            Optionally { "-" }
            OneOrMore(.digit)
        }
        ", y="
        Capture {
            Optionally { "-" }
            OneOrMore(.digit)
        }
    }
}
