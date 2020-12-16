//
//  Ferry.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/13/20.
//

import Foundation

enum NavInstruction: Equatable {
    case moveNorth(distance: Int)
    case moveSouth(distance: Int)
    case moveEast(distance: Int)
    case moveWest(distance: Int)
    case turnLeft(degrees: Int)
    case turnRight(degrees: Int)
    case moveForward(distance: Int)

    init?(_ input: String) {
        let letter = String(input.prefix(1))
        let value = Int(String(input.dropFirst())) ?? 0

        switch letter {
        case "N":
            self = .moveNorth(distance: value)
        case "S":
            self = .moveSouth(distance: value)
        case "E":
            self = .moveEast(distance: value)
        case "W":
            self = .moveWest(distance: value)
        case "L":
            self = .turnLeft(degrees: value)
        case "R":
            self = .turnRight(degrees: value)
        case "F":
            self = .moveForward(distance: value)
        default:
            return nil
        }
    }
}

enum CompassDirection: String {
    case north
    case east
    case south
    case west
}

class Ferry {
    /// Set of instructions used in navigation
    let navigationInstructions: [NavInstruction]

    /// Current orientation of the ship
    var facing: CompassDirection = .east

    /// Current location of the ship
    var location: Coordinate = Coordinate(x: 0, y: 0)

    /// Current waypoint (relative to ship)
    var waypoint: Coordinate = Coordinate(x: 10, y: 1) // waypoint starts 10 units east and 1 unit north relative to the ship


    init(instructions: [NavInstruction]) {
        navigationInstructions = instructions
    }


    /// What is ship's the Manhattan Distance to the point of origin?
    func distanceToOrigin() -> Int {
        abs(location.x) + abs(location.y)
    }


    // MARK: - Part  One

    /// Use navigation instructions to move ship (part 1)
    func navigate() {
        // print("-: Facing: \(facing.rawValue) @ \(location)")

        for nav in navigationInstructions {
            switch nav {
            case .moveNorth(distance: let distance):
                move(direction: .north, distance: distance)
            case .moveEast(distance: let distance):
                move(direction: .east, distance: distance)
            case .moveSouth(distance: let distance):
                move(direction: .south, distance: distance)
            case .moveWest(distance: let distance):
                move(direction: .west, distance: distance)
            case .moveForward(distance: let distance):
                move(direction: facing, distance: distance)
            case .turnLeft(degrees: let degrees):
                turn(degrees: -degrees)
            case .turnRight(degrees: let degrees):
                turn(degrees: degrees)
            }
        }
    }

    /// Move the ship a given direction a certain distance
    func move(direction: CompassDirection, distance: Int) {
        switch direction {
        case .north:
            location = location.moving(xOffset: 0, yOffset: distance)
        case .south:
            location = location.moving(xOffset: 0, yOffset: -distance)
        case .east:
            location = location.moving(xOffset: distance, yOffset: 0)
        case .west:
            location = location.moving(xOffset: -distance, yOffset: 0)
        }
    }

    /// Turn the ship a given set of degrees.
    ///
    /// Considered in terms of 90º rotations left/right. Right degrees are negative.
    func turn(degrees: Int) {
        let turns = abs(degrees / 90) // how many 90º turns are we making?
        let clockwise = degrees > 0 // are we going clockwise or not?
        (0..<turns).forEach { _ in turn(clockwise: clockwise) }
    }

    /// Turn the ship's orientation based on current facing orientation
    private func turn(clockwise: Bool) {
        switch facing {
        case .north:
            if clockwise {
                facing = .east
            } else {
                facing = .west
            }
        case .east:
            if clockwise {
                facing = .south
            } else {
                facing = .north
            }
        case .south:
            if clockwise {
                facing = .west
            } else {
                facing = .east
            }
        case .west:
            if clockwise {
                facing = .north
            } else {
                facing = .south
            }
        }
    }


    // MARK: - Part Two

    /// Use navigation instructions to move ship and waypoint (part 2)
    func followWaypoint() {
        // print("-: Ship: \(location) == Waypoint: \(waypoint)")

        for nav in navigationInstructions {
            switch nav {
            case .moveNorth(distance: let distance):
                moveWaypoint(direction: .north, distance: distance)
            case .moveEast(distance: let distance):
                moveWaypoint(direction: .east, distance: distance)
            case .moveSouth(distance: let distance):
                moveWaypoint(direction: .south, distance: distance)
            case .moveWest(distance: let distance):
                moveWaypoint(direction: .west, distance: distance)

            case .moveForward(distance: let distance):
                moveShip(amount: distance)

            case .turnLeft(degrees: let degrees):
                rotateWaypoint(degrees: -degrees)
            case .turnRight(degrees: let degrees):
                rotateWaypoint(degrees: degrees)
            }
        }
    }

    /// Move the waypoint a direction and distance
    func moveWaypoint(direction: CompassDirection, distance: Int) {
        switch direction {
        case .north:
            waypoint = waypoint.moving(xOffset: 0, yOffset: distance)
        case .south:
            waypoint = waypoint.moving(xOffset: 0, yOffset: -distance)
        case .east:
            waypoint = waypoint.moving(xOffset: distance, yOffset: 0)
        case .west:
            waypoint = waypoint.moving(xOffset: -distance, yOffset: 0)
        }
    }

    /// Rotate the waypoint a given number of degrees
    func rotateWaypoint(degrees: Int) {
        let turns = abs(degrees / 90) // how many 90º turns are we making?
        let clockwise = degrees > 0 // are we going clockwise or not?
        (0..<turns).forEach { _ in rotateWaypoint90Degrees(clockwise: clockwise) }
    }

    private func rotateWaypoint90Degrees(clockwise: Bool) {
        if clockwise {
            waypoint = Coordinate(x: waypoint.y, y: -waypoint.x)
        } else {
            waypoint = Coordinate(x: -waypoint.y, y: waypoint.x)
        }
    }

    /// Move the ship towards the waypoint a given number of times.
    func moveShip(amount: Int) {
        location = location.moving(xOffset: waypoint.x * amount, yOffset: waypoint.y * amount)
    }

}
