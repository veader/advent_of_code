//
//  day3.swift
//  CodeAdvent2015
//
//  Created by Shawn Veader on 12/18/15.
//  Copyright © 2015 V8 Logic. All rights reserved.
//

import Foundation

struct Coordinate {
    var x = 0
    var y = 0

    enum CoordDirection: Character {
        case Up = "^"
        case Down = "v"
        case Left = "<"
        case Right = ">"
    }

    mutating func move(direction: CoordDirection) {
        switch direction {
        case .Up:
            self.y = self.y + 1
        case .Down:
            self.y = self.y - 1
        case .Right:
            self.x = self.x + 1
        case .Left:
            self.x = self.x - 1
        }
    }

    mutating func reset() {
        self.x = 0
        self.y = 0
    }

    func location() -> String {
        return "\(self.x),\(self.y)"
    }
}

class SantaTracker {
    var currentLocation = Coordinate()
    var locationsVisited = [String: Int]()

    func navigate(instructions: String) {
        self.currentLocation.reset()
        updateLocationsVisited()

        for instruction in instructions.characters {
            guard let direction = Coordinate.CoordDirection(rawValue: instruction) else { continue }
            self.currentLocation.move(direction)
            updateLocationsVisited()
        }
    }

    func updateLocationsVisited() {
        self.locationsVisited[self.currentLocation.location()] = (self.locationsVisited[self.currentLocation.location()] ?? 0) + 1
    }

    func housesVisited() -> Int {
        return self.locationsVisited.keys.count
    }
}

func split_instructions(input: String) -> (santa: String, robot: String) {
    var santaInstructions = ""
    var robotInstructions = ""

    for (index, char) in input.characters.enumerate() {
        if (index % 2) == 0 {
            santaInstructions.append(char)
        } else {
            robotInstructions.append(char)
        }

    }
    return (santaInstructions, robotInstructions)
}

func trackWithRobot(input: String) -> Int {
    let (santa_instructions, robot_instructions) = split_instructions(input)

    let santa = SantaTracker()
    santa.navigate(santa_instructions)
    let robot = SantaTracker()
    robot.navigate(robot_instructions)

    let uniqueHouses = Set(santa.locationsVisited.keys).union(Set(robot.locationsVisited.keys))
    print("Santa visited \(santa.housesVisited())")
    print("Robot visited \(robot.housesVisited())")
    print("Both visited \(uniqueHouses.count) unique houses")
    return uniqueHouses.count
}

func advent_day3(input: String) {
    print("---- WITHOUT ROBOT")
    let tracker = SantaTracker()
    tracker.navigate(input)
    print("Santa visited \(tracker.housesVisited())")
    print("\n")

    print("---- WITH ROBOT")
    trackWithRobot(input)
}
