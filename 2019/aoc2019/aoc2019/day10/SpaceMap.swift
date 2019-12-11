//
//  SpaceMap.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/10/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

typealias AsteroidMap = [Coordinate: Int]

class SpaceLaser {
    var width: Int
    var height: Int
    var location: Coordinate

    var direction: Coordinate.SlopeType? {
        directionSteps[directionIndex]
    }

    var directionIndex: Int
    var directionSteps: [Coordinate.SlopeType]

    init(width: Int, height: Int, location: Coordinate) {
        self.width = width
        self.height = height
        self.location = location

        // defaults till we can really set them below
        directionIndex = 0
        directionSteps = [Coordinate.SlopeType]()

        createDirectionSteps()
    }

    /// Rotate the laser to the next laser path in the loop
    func rotate() {
        if directionIndex < directionSteps.count - 1 {
            directionIndex += 1 // move to the next one
        } else { // we hit the end, loop
            directionIndex = 0
        }
    }

    func createDirectionSteps() {
        // laser initially pointed up

        // direction = Coordinate.SlopeType.vertical(direction: 1)
        directionIndex = 0
        var steps = [Coordinate.SlopeType]()

        var perimeterLocation: Coordinate
        var slope: Coordinate.SlopeType

        // sweep from "12 o'clock" along the top edge to top right corner
        for x in (location.x..<width) {
            perimeterLocation = Coordinate(x: x, y: 0)
            slope = location.slope(to: perimeterLocation)
            steps.append(slope)
        }

        // sweep down right edge
        for y in (1..<height) {
            perimeterLocation = Coordinate(x: width - 1, y: y)
            slope = location.slope(to: perimeterLocation)
            steps.append(slope)
        }

        // sweep across bottom edge
        for x in (0..<width-1).reversed() {
            perimeterLocation = Coordinate(x: x, y: height - 1)
            slope = location.slope(to: perimeterLocation)
            steps.append(slope)
        }

        // sweep up left edge
        for y in (0..<height-1).reversed() {
            perimeterLocation = Coordinate(x: 0, y: y)
            slope = location.slope(to: perimeterLocation)
            steps.append(slope)
        }

        // sweep from origin to "12 o'clock" along the top edge
        for x in (1..<location.x) {
            perimeterLocation = Coordinate(x: x, y: 0)
            slope = location.slope(to: perimeterLocation)
            steps.append(slope)
        }

        // remove any duplicates
        steps = steps.unique()

        // find index of "up"
        let up = Coordinate.SlopeType.vertical(direction: -1) // with origin in top left, up/down are inverted :/ 
        directionIndex = steps.firstIndex(of: up) ?? -1
        directionSteps = steps
    }
}

class SpaceMap {
    var width: Int
    var height: Int
    var asteroids: AsteroidMap

    var laserStation: SpaceLaser? = nil

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

    func addStation(at location: Coordinate) {
        laserStation = SpaceLaser(width: width, height: height, location: location)
    }

    // TODO: Should we move this logic to having a "laser" swing around and count the ones it can see?
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

    func fireTheFreakingLaser() -> [Coordinate] {
        guard let laser = laserStation else { return [] }

        var destroyedAsteroidLocations = [Coordinate]()

        var asteroidMatrix = [Coordinate: Coordinate.SlopeType]()
        asteroids.forEach { location, _ in
            let slope = laser.location.slope(to: location)
            asteroidMatrix[location] = slope
        }
        // print(asteroidMatrix)

        // loop until we've shot everything
        while !asteroidMatrix.isEmpty {
            // print(laser.direction)

            let hittableAsteroids = asteroidMatrix.filter { location, slope -> Bool in
                slope == laser.direction && location != laser.location
            }
            // print(hittableAsteroids)

            // find the closest one to destroy
            if hittableAsteroids.count > 0,
                let target = hittableAsteroids.sorted(by: { laser.location.distance(to: $0.key) < laser.location.distance(to: $1.key) }).first
            {
                print("DESTROY \(target.key)")
                // destroy it!
                asteroidMatrix.removeValue(forKey: target.key)
                destroyedAsteroidLocations.append(target.key)
                asteroids.removeValue(forKey: target.key)
            }

            laser.rotate() // move to the next laser

            printMap()
            // print("\n")
        }


        return destroyedAsteroidLocations
    }

    @discardableResult
    func printMap(showCounts: Bool = false) -> String {
        var output = ""
        for y in (0..<height) {
            for x in (0..<width) {
                let location = Coordinate(x: x, y: y)
                if let station = laserStation, station.location == location {
                    output += "X"
                } else if let count = asteroids[location] {
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

extension SpaceMap {
    convenience init(input: String) {
        var maxX: Int = 0
        var maxY: Int = 0
        var asteroidMap = AsteroidMap()

        let lines = input
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

        self.init(width: maxX + 1, height: maxY + 1, asteroids: asteroidMap)
    }
}
