#!/usr/bin/env swift

import Foundation

// MARK: - Direction
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

// MARK: - Coordinate
struct Coordinate {
   let x: Int
   let y: Int

   func incrementX(by amount: Int = 1) -> Coordinate {
      return Coordinate(x: self.x + amount, y: self.y)
   }

   func incrementY(by amount: Int = 1) -> Coordinate {
      return Coordinate(x: self.x, y: self.y + amount)
   }
}

extension Coordinate: Equatable {}
func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

extension Coordinate: Hashable {
    var hashValue: Int {
        return x.hashValue ^ y.hashValue
    }
}

// MARK: - Location
struct Location {
    var heading: Direction
    var coordinates: Coordinate

    var destinations: Set<Coordinate>
    var secondVisitedDestination: Coordinate?

    init() {
        heading = .North
        coordinates = Coordinate(x: 0, y: 0)

        destinations = Set()
        track()
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
            for _ in (1...distance) {
                coordinates = coordinates.incrementY()
                track()
            }
        case .South:
            for _ in (1...distance) {
                coordinates = coordinates.incrementY(by: -1)
                track()
            }
        case .East:
            for _ in (1...distance) {
                coordinates = coordinates.incrementX()
                track()
            }
        case .West:
            for _ in (1...distance) {
                coordinates = coordinates.incrementX(by: -1)
                track()
            }
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

    private mutating func track() {
        if destinations.contains(coordinates) {
            print("** Been here before!")
            if secondVisitedDestination == nil {
                secondVisitedDestination = coordinates
            }
        } else {
            destinations.insert(coordinates)
        }
    }
}

extension Location: CustomDebugStringConvertible {
    var debugDescription: String {
        return "Facing \(heading.description()) @ (\(coordinates.x), \(coordinates.y))"
    }
}

// ------------------------------------------------------------------
// MARK: - "MAIN()"
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
    print("Move: \(trimmedInstruction)")
    location.move(trimmedInstruction)
    print(location)
}

print("Final Location: \(location)")
print("Visted \(location.secondVisitedDestination) Twice")
