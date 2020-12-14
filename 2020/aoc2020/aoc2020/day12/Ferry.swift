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
    let navigationInstructions: [NavInstruction]
    var facing: CompassDirection = .east
    var location: Coordinate = Coordinate(x: 0, y: 0)

    init(instructions: [NavInstruction]) {
        navigationInstructions = instructions
    }

    func navigate() {
        print("-: Facing: \(facing.rawValue) @ \(location)")

        for (idx, nav) in navigationInstructions.enumerated() {

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
                turn(degrees: degrees)
            case .turnRight(degrees: let degrees):
                turn(degrees: -degrees)
            }

            print("\(idx): Facing: \(facing.rawValue) @ \(location)")
        }
    }

    func distanceToOrigin() -> Int {
        abs(location.x) + abs(location.y)
    }

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

    func turn(degrees: Int) {
        let turns = abs(degrees / 90) // how many 90º turns are we making?
        let makingALeft = degrees > 0 // are we going left (clock-wise) or not?
        (0..<turns).forEach { _ in turn(left: makingALeft) }
    }

    private func turn(left: Bool) {
        switch facing {
        case .north:
            if left {
                facing = .west
            } else {
                facing = .east
            }
        case .east:
            if left {
                facing = .north
            } else {
                facing = .south
            }
        case .south:
            if left {
                facing = .east
            } else {
                facing = .west
            }
        case .west:
            if left {
                facing = .south
            } else {
                facing = .north
            }
        }
    }
}
