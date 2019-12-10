//
//  DayTen.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/10/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

typealias AsteroidMap = [Coordinate: Int]

class SpaceMap {
    var width: Int
    var height: Int
    var asteroids: AsteroidMap

    init(width: Int, height: Int, asteroids: AsteroidMap) {
        self.width = width
        self.height = height
        self.asteroids = asteroids
    }

    func visibility(at location: Coordinate) -> Int {
        asteroids[location] ?? 0
    }

    func maxVisibilityLocation() -> Coordinate? {
        calculateVisibilityCounts()
        return asteroids.max { leftAsteroid, rightAsteroid -> Bool in
            leftAsteroid.value < rightAsteroid.value
        }?.key
    }

    func calculateVisibilityCounts() {
        asteroids.keys.forEach { asteroidLocation in
            // map with a seen asteroid's location and slope
            var seenAsteroids: [Coordinate: Coordinate.SlopeType] = [Coordinate: Coordinate.SlopeType]()

            // look for other asteroids
            asteroids.keys.forEach { otherAsteroid in
                guard asteroidLocation != otherAsteroid else { return }

                // we can't see an asteroid if:
                //  - it's slope is the same as another seen asteroid
                //  - there isn't a closer one with the same slope
                let slope = asteroidLocation.slope(to: otherAsteroid)
                var slopeBuddies = seenAsteroids.filter { $1 == slope }

                if slopeBuddies.isEmpty {
                    seenAsteroids[otherAsteroid] = slope
                } else {
                    slopeBuddies.forEach { (location: Coordinate, slope: Coordinate.SlopeType) in
                        if asteroidLocation.distance(to: otherAsteroid) <
                            asteroidLocation.distance(to: location) {
                            // if this asteroid is closer to the currently "seen" slope buddy,
                            //   remove that one and add this asteroid
                            slopeBuddies.removeValue(forKey: location)
                            slopeBuddies[otherAsteroid] = slope
                        // else -> we are further away and can't be seen, move along
                        }
                    }
                }
            }

            // print("Asteroids seen from \(asteroidLocation):")
            // print(seenAsteroids)

            asteroids[asteroidLocation] = seenAsteroids.count
        }
    }

    @discardableResult
    func printMap(showCounts: Bool = false) -> String {
        var output = ""
        for y in (0..<height) {
            for x in (0..<width) {
                let location = Coordinate(x: x, y: y)
                if let count = asteroids[location] {
                    if showCounts {
                        output += "\(count)"
                    } else {
                        output += "#"
                    }
                } else {
                    output += "."
                }
            }
            output += "\n"
        }

        print(output)
        return output
    }
}

struct DayTen: AdventDay {
    var dayNumber: Int = 10

    func parse(_ input: String?) -> SpaceMap {
        var maxX: Int = 0
        var maxY: Int = 0
        var asteroidMap = AsteroidMap()

        let lines = (input ?? "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .split(separator: "\n")
                    .compactMap(String.init)

        lines.enumerated().forEach { (lineCount: Int, line: String) in
            line.indices.forEach { idx in
                if line[idx] == "#" {
                    let x = line.distance(from: line.startIndex, to: idx)

                    let coord = Coordinate(x: x, y: lineCount)
                    asteroidMap[coord] = 0

                    if maxX < x { maxX = x }
                }
            }

            if maxY < lineCount { maxY = lineCount }
        }

        return SpaceMap(width: maxX+1, height: maxY+1, asteroids: asteroidMap)
    }

    func partOne(input: String?) -> Any {
        let map = parse(input)
        guard let location = map.maxVisibilityLocation() else { return 0 }
        return map.visibility(at: location)
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
