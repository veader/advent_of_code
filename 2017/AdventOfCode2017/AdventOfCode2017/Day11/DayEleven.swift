//
//  DayEleven.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/11/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

struct DayEleven: AdventDay {

    struct HexBoard {
        enum Direction: String {
            case north = "n"
            case northeast = "ne"
            case southeast = "se"
            case south = "s"
            case southwest = "sw"
            case northwest = "nw"
        }

        struct Coordinate: CustomDebugStringConvertible {
            let x: Int
            let y: Int

            var z: Int {
                // in the coordinate system x + y + z = 0
                return 0 - x - y
            }

            var debugDescription: String {
                return "<\(x), \(y), \(z)>"
            }


            init(_ x: Int, _ y: Int) {
                self.x = x
                self.y = y
            }

            func move(_ direction: Direction?) -> Coordinate {
                guard let direction = direction else { return self }

                switch direction {
                case .north:
                    return Coordinate(x, y + 1)
                case .northeast:
                    return Coordinate(x + 1, y)
                case .southeast:
                    return Coordinate(x + 1, y - 1)
                case .south:
                    return Coordinate(x, y - 1)
                case .southwest:
                    return Coordinate(x - 1, y)
                case .northwest:
                    return Coordinate(x - 1, y + 1)
                }
            }
        }

        /// Number of steps to get from origin (0,0) to current location
        var distance: Int {
            return max(abs(currentLocation.x),
                       abs(currentLocation.y),
                       abs(currentLocation.z))
        }

        /// Maximum distance achieved in during our travels.
        var maxDistance: Int = 0

        var currentLocation = Coordinate(0,0)

        mutating func follow(path: String) {
            let steps = path.split(separator: ",").map { String($0).trimmed() }

            for step in steps {
                let direction = Direction(rawValue: step)
                currentLocation = currentLocation.move(direction)

                maxDistance = max(maxDistance, distance)
            }
        }
    }

    // MARK: -

    func defaultInput() -> String? {
        let path = "\(dataPath())/day11input.txt"
        return try? String(contentsOfFile: path, encoding: .utf8)
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 11: 💥 NO INPUT")
            exit(10)
        }

        let thing = partOne(input: runInput)
        guard let answer = thing else {
            print("Day 11: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 11: (Part 1) Answer ", answer)

        let thing2 = partTwo(input: runInput)
        guard let answer2 = thing2 else {
            print("Day 11: (Part 2) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 11: (Part 2) Answer ", answer2)
    }

    // MARK: -

    func partOne(input: String) -> Int? {
        var board = HexBoard()
        board.follow(path: input)
        return board.distance
    }

    func partTwo(input: String) -> Int? {
        var board = HexBoard()
        board.follow(path: input)
        return board.maxDistance
    }
}
