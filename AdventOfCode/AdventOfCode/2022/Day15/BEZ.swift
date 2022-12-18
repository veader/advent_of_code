//
//  BEZ.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/18/22.
//

import Foundation
import RegexBuilder

class BEZ {
    struct SensorBeacon {
        let sensor: Coordinate
        let beacon: Coordinate
        let distance: Int

        init(sx: Int, sy: Int, bx: Int, by: Int) {
            sensor = Coordinate(x: sx, y: sy)
            beacon = Coordinate(x: bx, y: by)
            distance = sensor.distance(to: beacon)
        }

        var possibleYValues: ClosedRange<Int> {
            ((sensor.y - distance)...(sensor.y + distance))
        }

        func points(on y: Int) -> [Coordinate] {
            guard possibleYValues.contains(y) else { return [] }
            let delta = abs(y - sensor.y)
            let modDistance = abs(distance - delta)
            guard modDistance > 0 else { print("\t* No points...");return [] }

            return ((sensor.x - modDistance)...(sensor.x + modDistance)).map { x in
                Coordinate(x: x, y: y)
            }
        }
    }

    var pairs: [SensorBeacon]

    init(_ input: String) {
        pairs = BEZ.parse(input)
    }

    func occupied(on y: Int) -> [Coordinate] {
        var points = Set<Coordinate>()

        for pair in pairs {
            let pts = pair.points(on: y)
            points = points.union(Set(pts))
        }

        let sensors = pairs.map(\.sensor)
        let beacons = pairs.map(\.beacon)

        points = points.subtracting(sensors).subtracting(beacons)

        return Array(points)
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
