//
//  RepairDroid.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/15/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

class RepairDroid {
    enum Tile: String, Equatable {
        case wall = "▓"
        case empty = "."
        case robot = "◍"
        case tank = "O"
    }

    enum MoveDirection: Int, Equatable {
        case north = 1
        case south = 2
        case west = 3
        case east = 4

        var opposite: MoveDirection {
            switch self {
            case .north:
                return .south
            case .south:
                return .north
            case .east:
                return .west
            case .west:
                return .east
            }
        }
    }

    enum MoveStatus: Int, Equatable {
        case wall = 0
        case success = 1
        case oxygen = 2
    }

    var machine: IntCodeMachine

    var map: [Coordinate: Tile]
    var oxygenTank: Coordinate? = nil
    var currentLocation: Coordinate = Coordinate.origin
    var traveling: MoveDirection

    var distanceMap: [Coordinate: Int]

    let directions: [MoveDirection] = [.north, .east, .south, .west]

    init(input: String) {
        machine = IntCodeMachine(instructions: input)
        machine.silent = true
        map = [Coordinate: Tile]()
        map[currentLocation] = .empty // nothing at the start
        traveling = .north

        distanceMap = [Coordinate: Int]()
    }


    // MARK: - Main logic points

    /// Explore the map...
    func explore() {
        var finished = false

        // start the machine running
        machine.run()

        let maxLoops = 22_000
        var iteration = 0

        while !finished {
            if case .finished(output: _) = machine.state {
                processStatus()

                finished = true
            } else if case .awaitingInput = machine.state {
                processStatus()

                let next = nextDirection()
                traveling = next
                machine.set(input: next.rawValue)

                // printMap()

                iteration += 1
                if iteration > maxLoops {
                    // print("Exceeded max iteraion count.")
                    finished = true
                } else {
                    // print("Iteration: \(iteration)")
                }
            } else {
                // print(".")
            }
        }

        printMap()
    }

    func processStatus() {
        guard let lastOutput = machine.outputs.popLast() else { return }

        if let status = MoveStatus(rawValue: lastOutput) {
            switch status {
            case .wall:
                // mark the wall and pick next direction
                let location = locationForLastDirection()
                map[location] = .wall
            case .success, .oxygen:
                // mark spot and move, pick next direction
                let location = locationForLastDirection()

                if case .oxygen = status {
                    // if we found the oxygen tank, record it
                    oxygenTank = location
                    map[location] = .tank
                } else {
                    map[location] = .empty
                }

                currentLocation = location
            }
        } else {
            print("Awaiting input but we have no status.")
        }
    }

    func findShortestPath() -> Int {
        guard let goal = oxygenTank else { print("No goal..."); return Int.max }
        distanceMap.removeAll() // reset distance map

        let answer = bfSearch(location: Coordinate.origin, distance: 0, goal: goal)
        return answer
    }

    func bfSearch(location searchLocation: Coordinate, distance: Int, goal: Coordinate) -> Int {
        // if we've already seen this location and had a shorter or similar path, abort
        if let prevDistance = distanceMap[searchLocation], prevDistance <= distance {
            return Int.max
        }

        distanceMap[searchLocation] = distance // shortest path (yet) to this location

        if let tile = map[searchLocation], case .tank = tile {
            return distance // we hit the goal
        }

        // determine possible paths from our current location
        let pathLocations = directions.compactMap { direction -> Coordinate? in
            let stepLocation = searchLocation.location(for: direction)
            guard let tile = map[stepLocation] else { return nil }

            switch tile {
            case .empty, .tank:
                return stepLocation
            default:
                return nil
            }
        }

        // continue search
        let shortestPaths = pathLocations.map {
            bfSearch(location: $0, distance: distance + 1, goal: goal)
        }

        return shortestPaths.min() ??  Int.max
    }

    // MARK: - Helper Methods

    func locationForLastDirection() -> Coordinate {
        currentLocation.location(for: traveling)
    }

    func nextDirection() -> MoveDirection {
        var lookDirections: [MoveDirection]

        switch traveling {
        case .north:
            lookDirections = directions.rotate(by: -1)
        case .east:
            lookDirections = directions
        case .south:
            lookDirections = directions.rotate(by: 1)
        case .west:
            lookDirections = directions.rotate(by: 2)
        }

        for direction in lookDirections {
            let testLocation = currentLocation.location(for: direction)
            if let tile = map[testLocation] {
                switch tile {
                case .empty, .tank:
                    return direction
                default:
                    continue
                }
            } else {
                // we have no knowledge of this tile, go that direction
                return direction
            }
        }

        return .north // should never get here....
    }

    func printMap() {
        let usedCoordinates = map.keys
        let minX = usedCoordinates.min(by: { $0.x < $1.x })?.x ?? 0
        let maxX = usedCoordinates.max(by: { $0.x < $1.x })?.x ?? 0
        let minY = usedCoordinates.min(by: { $0.y < $1.y })?.y ?? 0
        let maxY = usedCoordinates.max(by: { $0.y < $1.y })?.y ?? 0

        let xRange = min(0, minX - 2)..<(maxX + 2)
        let yRange = min(0, minY - 2)..<(maxY + 2)

        var output = ""

        for y in yRange.reversed() {
            for x in xRange {
                let mapLocation = Coordinate(x: x, y: y)
                if mapLocation == currentLocation {
                    output += Tile.robot.rawValue
                } else if let tile = map[mapLocation] {
                    output += tile.rawValue
                } else {
                    output += " "
                }
            }
            output += "\n"
        }

        print(output)
    }
}

extension Coordinate {
    func location(for direction: RepairDroid.MoveDirection) -> Coordinate {
        switch direction {
        case .north:
            return Coordinate(x: self.x, y: self.y + 1)
        case .south:
            return Coordinate(x: self.x, y: self.y - 1)
        case .east:
            return Coordinate(x: self.x + 1, y: self.y)
        case .west:
            return Coordinate(x: self.x - 1, y: self.y)
        }
    }
}
