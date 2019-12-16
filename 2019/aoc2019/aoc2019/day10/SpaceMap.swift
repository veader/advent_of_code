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

        // var slope: Coordinate.SlopeType

        // start with vertical ("up")
        steps.append(location.slope(to: Coordinate(x: location.x, y: 0)))

        // work in quadrents
        var quadrent = [Coordinate.SlopeType]()


        // ==========================================================
        // sweep from "12 o'clock" to "3 o'clock"
        quadrent = slopesInQuadrent(xs: (location.x..<width), ys: (0..<location.y))
        steps.append(contentsOf: quadrent)

        // had in horizontal (right)
        steps.append(location.slope(to: Coordinate(x: location.x + 1, y: location.y)))


        // ==========================================================
        // sweep from "3 o'clock" to "6 o'clock"
        quadrent = slopesInQuadrent(xs: (location.x..<width), ys: (location.y..<height))
        steps.append(contentsOf: quadrent)

        // had in vertical ("down")
        steps.append(location.slope(to: Coordinate(x: location.x, y: height)))


        // ==========================================================
        // sweep from "6 o'clock" to "9 o'clock"
        quadrent = slopesInQuadrent(xs: (0..<location.x), ys: (location.y..<height))
        steps.append(contentsOf: quadrent)

        // had in horizontal (left)
        steps.append(location.slope(to: Coordinate(x: location.x - 1, y: location.y)))


        // ==========================================================
        // sweep from "9 o'clock" to "12 o'clock"
        quadrent = slopesInQuadrent(xs: (0..<location.x), ys: (0..<location.y))
        steps.append(contentsOf: quadrent)


        // remove any duplicates
        steps = steps.unique()

        // find index of "up"
        let up = Coordinate.SlopeType.vertical(direction: -1) // with origin in top left, up/down are inverted :/ 
        directionIndex = steps.firstIndex(of: up) ?? -1
        directionSteps = steps
    }

    func slopesInQuadrent(xs: Range<Int>, ys: Range<Int>) -> [Coordinate.SlopeType] {
        var quadrent = [Coordinate.SlopeType]()

        for x in xs {
            for y in ys {
                let slope = location.slope(to: Coordinate(x: x, y: y))
                quadrent.append(slope)
            }
        }

        return quadrent.filter { s -> Bool in
            // filter out the horizontal/vertical ones
            guard case .normal(slope: _) = s else { return false }
            return true
        }.sorted { lhs, rhs -> Bool in
            // sort by slope amount
            if  case .normal(slope: let slopeA) = lhs,
                case .normal(slope: let slopeB) = rhs {
                return slopeA < slopeB
            } else {
                return false
            }
        }.unique()
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

        // loop until we've shot everything
        while asteroidMatrix.count > 1 {
            let hittableAsteroids = asteroidMatrix.filter { location, slope -> Bool in
                slope == laser.direction && location != laser.location
            }

            // find the closest one to destroy
            if hittableAsteroids.count > 0,
                let target = hittableAsteroids.sorted(by: { laser.location.distance(to: $0.key) < laser.location.distance(to: $1.key) }).first
            {
                // destroy it!
                asteroidMatrix.removeValue(forKey: target.key)
                destroyedAsteroidLocations.append(target.key)
                asteroids.removeValue(forKey: target.key)

                // print("DESTROY \(target.key)")
                // printMap()
            }

            laser.rotate() // move to the next laser
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
