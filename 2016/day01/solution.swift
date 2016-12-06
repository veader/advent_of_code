#!/usr/bin/env swift

import Foundation

enum Direction: Int {
    case North = 0
    case East
    case South
    case West

    func description() -> String {
        switch(self) {
        case .North:
            return "North"
        case .East:
            return "East"
        case .South:
            return "South"
        case .West:
            return "West"
        }
    }
}

struct Location {
    var heading: Direction
    var x: Int
    var y: Int

    init() {
        heading = .North
        x = 0
        y = 0
    }

    mutating func move(_ instruction: String) {
        guard let direction = instruction.characters.first else {
            print("No direction found: '\(instruction)'")
            return
        }

        switch(direction) {
        case "R":
            turnRight()
        case "L":
            turnLeft()
        default:
            print("Unknown direction: '\(direction)'")
            return
        }

        let distanceIndex = instruction.index(after: instruction.startIndex)
        guard let distance = Int(instruction.substring(from: distanceIndex)) else {
            print("No distance found: '\(instruction)'")
            return
        }

        move(distance: distance)
    }

    private mutating func move(distance: Int = 0) {
        switch(heading) {
        case .North:
            y = y + distance
        case .East:
            x = x + distance
        case .South:
            y = y - distance
        case .West:
            x = x - distance
        }
    }

    private mutating func turnLeft() {
        switch(heading) {
        case .North:
            heading = .West
        case .East:
            heading = .North
        case .South:
            heading = .East
        case .West:
            heading = .South
        }
    }

    private mutating func turnRight() {
        switch(heading) {
        case .North:
            heading = .East
        case .East:
            heading = .South
        case .South:
            heading = .West
        case .West:
            heading = .North
        }
    }
}

extension Location: CustomDebugStringConvertible {
    var debugDescription: String {
        return "\(heading.description()) (\(x), \(y))"
    }
}

// ------------------------------------------------------------------
guard let currentDir = ProcessInfo.processInfo.environment["PWD"] else {
    print("No current directory.")
    exit(1)
}

let inputPath: String = "\(currentDir)/input.txt"
let data = try String(contentsOfFile: inputPath, encoding: .utf8)

let instructions = data.components(separatedBy: ", ")

// ------------------------------------------------------------------
var location = Location()

for instruction in instructions {
    let trimmedInstruction = instruction.trimmingCharacters(in: .whitespacesAndNewlines)
    location.move(trimmedInstruction)
    print(location)
}

print("Final Location: \(location)")
