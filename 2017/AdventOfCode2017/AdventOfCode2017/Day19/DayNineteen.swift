//
//  DayNineteen.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/22/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

struct DayNineteen: AdventDay {

    struct Maze {
        enum Direction {
            case north
            case south
            case east
            case west
        }

        typealias Location = (x: Int, y: Int)

        let map: [String]
        var currentDirection: Direction = .north
        var currentLocation: Location = (0,0)
        var foundLetters: [String] = [String]()
        var printing: Bool = false

        init(_ input: String) {
            map = input.split(separator: "\n").map(String.init)
        }

        mutating func navigate() -> String? {
            guard let location = startingLocation() else { return nil }

            // start our adventure
            currentLocation = location
            currentDirection = .south

            // move until we hit the end of the line
            while move() { }

            return foundLetters.joined().trimmed()
        }

        mutating func move() -> Bool {
            // if we don't get back content, we've hit the end of the line (location out of bounds)
            guard
                let locationContent = contents(at: currentLocation),
                locationContent != " "
                else { return false }

            switch locationContent {
            case "|":
                if [.east, .west].contains(currentDirection) {
                    if printing { print("Crossing | when moving E/W") }
                }
            case "-":
                if [.north, .south].contains(currentDirection) {
                    if printing { print("Crossing - when moving N/S") }
                }
            case "+":
                // we've hit a turn, find next direction
                if [.north, .south].contains(currentDirection) {
                    // should be either east/west
                    if let that = contents(at: location(.east, of: currentLocation)), that != " " {
                        currentDirection = .east
                    } else if let that = contents(at: location(.west, of: currentLocation)), that != " " {
                        currentDirection = .west
                    } else {
                        print("🤔 found '+' going \(currentDirection) but could not find anything east/west of it.")
                    }
                } else {
                    // should be either north/south
                    if let that = contents(at: location(.north, of: currentLocation)), that != " " {
                        currentDirection = .north
                    } else if let that = contents(at: location(.south, of: currentLocation)), that != " " {
                        currentDirection = .south
                    } else {
                        print("🤔 found '+' going \(currentDirection) but could not find anything north/south of it.")
                    }
                }
                if printing { print("Found turn") }
            default:
                // this should be a letter...
                if printing { print("Found \(locationContent)") }
                foundLetters.append(String(locationContent))
            }

            // move to the next location
            currentLocation = nextLocation()
            return true
        }

        func nextLocation() -> Location {
            // determine next location based on current direction
            return location(currentDirection, of: currentLocation)
        }

        func location(_ direction: Direction, of location: Location) -> Location {
            switch direction {
            case .north:
                return (location.x, location.y - 1)
            case .south:
                return (location.x, location.y + 1)
            case .west:
                return (location.x - 1, location.y)
            case .east:
                return (location.x + 1, location.y)
            }
        }

        func contents(at location: Location) -> Character? {
            guard (0..<map.count).contains(location.y) else { return nil }
            let line = map[location.y]

            guard (0..<line.count).contains(location.x) else { return nil }
            let index = line.index(line.startIndex, offsetBy: location.x)
            return line[index]
        }

        func startingLocation() -> Location? {
            guard let topLine = map.first,
                let startIndex = topLine.index(of: "|")
                else { return nil }

            return (startIndex.encodedOffset, 0)
        }
    }

    // MARK: -

    func defaultInput() -> String? {
        let path = "\(dataPath())/day19input.txt"
        return try? String(contentsOfFile: path, encoding: .utf8)
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 19: 💥 NO INPUT")
            exit(10)
        }

        let thing = partOne(input: runInput)
        guard let answer = thing else {
            print("Day 19: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 19: (Part 1) Answer ", answer)

        // ...
    }

    // MARK: -

    func partOne(input: String) -> String? {
        var maze = Maze(input)
        return maze.navigate()
    }

    func partTwo(input: String) -> String? {
        return nil
    }
}

