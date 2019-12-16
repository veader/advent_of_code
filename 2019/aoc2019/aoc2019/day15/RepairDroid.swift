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

    enum MoveCommand: Int, Equatable {
        case north = 1
        case south = 2
        case west = 3
        case east = 4

        var opposite: MoveCommand {
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
    var attemptedDirection: MoveCommand? = nil

    init(input: String) {
        machine = IntCodeMachine(instructions: input)
        machine.silent = true
        map = [Coordinate: Tile]()
        map[currentLocation] = .empty // nothing at the start
    }

    /// Explore the map...
    func explore() {
        var finished = false

        // start the machine running
        machine.run()

        var waitCount = 1_000_000

        while !finished {
            if case .finished(output: _) = machine.state {
                processStatus()

                finished = true
            } else if case .awaitingInput = machine.state {
                processStatus()

                let next = nextDirection()
                attemptedDirection = next
                machine.set(input: next.rawValue)

                printMap()

                waitCount -= 1
                if waitCount == 0 {
                    exit(1)
                }
            } else {
                // print(".")
            }
        }
    }

    func location(for direction: MoveCommand) -> Coordinate {
        switch direction {
        case .north:
            return Coordinate(x: currentLocation.x, y: currentLocation.y + 1)
        case .south:
            return Coordinate(x: currentLocation.x, y: currentLocation.y - 1)
        case .east:
            return Coordinate(x: currentLocation.x + 1, y: currentLocation.y)
        case .west:
            return Coordinate(x: currentLocation.x - 1, y: currentLocation.y)
        }
    }

    func locationForLastDirection() -> Coordinate? {
        guard let direction = attemptedDirection else { return nil }
        return location(for: direction)
    }

    func nextDirection() -> MoveCommand {
        let neighborLocations: [MoveCommand] = [.north, .east, .south, .west]
        let neighbors: [(MoveCommand, Coordinate, Tile?)] = neighborLocations.map { cmd in
            (cmd, location(for: cmd), map[location(for: cmd)])
        }

        // first attempt to hit any unexplored neighbor
        if let neighbor = neighbors.first(where: { $0.2 == nil }) {
            return neighbor.0
        }

        // next attempt to backtrack to find unexplore blocks in our past
        let emptyBlocks = neighbors.filter({ $0.2 == .empty })
        if emptyBlocks.count == 1 {
            // no other choice but the way we came
            if let neighbor = emptyBlocks.first {
                return neighbor.0
            }
        } else {
            // we came one way to get here but there are other empty options.
            //  take those instead of the way we came...
            if let neighbor = emptyBlocks.first(where: { $0.0 != attemptedDirection?.opposite }) {
                return neighbor.0
            }
        }

        // we found nothing... go north?
        print("No unexplored neigbors")
        return .north

        /*
        guard let direction = attemptedDirection else { return .north } // default to trying north
        switch direction {
        case .north:
            let eastLocation = location(for: .east)
            let tile = map[eastLocation]
            if tile == nil {
                return .east
            } else {
                attemptedDirection = .east
                return nextDirection()
            }
        case .east:
            let southDirection = location(for: .south)
            let tile = map[southDirection]
            if tile == nil {
                return .south
            } else {
                attemptedDirection = .south
                return nextDirection()
            }
        case .south:
            let westDirection = location(for: .west)
            let tile = map[westDirection]
            if tile == nil {
                return .west
            } else {
                attemptedDirection = .west
                return nextDirection()
            }
        case .west:
            let northDirection = location(for: .north)
            let tile = map[northDirection]
            if tile == nil {
                return .north
            } else {
                attemptedDirection = .north
                return nextDirection()
            }
        }
 */
    }

    func processStatus() {
        guard let lastOutput = machine.outputs.popLast() else { return }

        if let status = MoveStatus(rawValue: lastOutput) {
            switch status {
            case .wall:
                // mark the wall and pick next direction
                if let location = locationForLastDirection() {
                    map[location] = .wall
                }
            case .success:
                // mark spot and move, pick next direction
                if let location = locationForLastDirection() {
                    map[location] = .empty
                    currentLocation = location
                }
                // attemptedDirection = nil // clear direction
            case .oxygen:
                // mark tank, save location, move, pick new direction
                if let location = locationForLastDirection() {
                    map[location] = .tank
                    currentLocation = location
                    oxygenTank = location
                }
                // attemptedDirection = nil // clear direction
                break
            }
        } else {
            print("Awaiting input but we have no status.")
        }
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
