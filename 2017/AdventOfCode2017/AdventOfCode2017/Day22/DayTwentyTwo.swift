//
//  DayTwentyTwo.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 1/1/18.
//  Copyright © 2018 v8logic. All rights reserved.
//

import Foundation

struct DayTwentyTwo: AdventDay {

    struct ComputingCluster {
        enum Direction {
            case up
            case down
            case left
            case right

            func rotateLeft() -> Direction {
                switch self {
                case .up:
                    return .right
                case .left:
                    return .up
                case .down:
                    return .left
                case .right:
                    return .down
                }
            }

            func rotateRight() -> Direction {
                switch self {
                case .up:
                    return .left
                case .left:
                    return .down
                case .down:
                    return .right
                case .right:
                    return .up
                }
            }
        }

        struct Location: Equatable {
            let x: Int
            let y: Int

            init(_ x: Int, _ y: Int) {
                self.x = x
                self.y = y
            }

            static func ==(lhs: Location, rhs: Location) -> Bool {
                return lhs.x == rhs.x && lhs.y == rhs.y
            }

            func move(_ direction: Direction) -> Location {
                switch direction {
                case .up:
                    return Location(x, y - 1)
                case .down:
                    return Location(x, y + 1)
                case .left:
                    return Location(x + 1, y)
                case .right:
                    return Location(x - 1, y)
                }
            }
        }

        struct Virus {
            var location: Location
            var direction: Direction
        }

        var infectedNodes: [Location] = [Location]()
        var cycleCount: Int = 0
        var infectingCycles: Int = 0
        var cleaningCycles: Int = 0
        var virus: Virus
        var gridSize: Int = 9 // odd size helps keep center easier

        // var grid: [[Int]]

        init(_ input: String) {
            let rows = input.split(separator: "\n").map { String($0).trimmed() }
            let inputGridMin = rows.count / 2

            for (yIdx, row) in rows.enumerated() {
                let y = yIdx - inputGridMin

                for (xIdx, char) in row.enumerated() {
                    let x = xIdx - inputGridMin

                    switch char {
                    case "#": // infected
                        let location = Location(x,y)
                        infectedNodes.append(location)
                    case ".": // clean
                        continue
                    default:
                        print("Unknown char \(char)")
                    }
                }
            }

            virus = Virus(location: Location(0,0), direction: .up)
        }

        mutating func run(cycles: Int = 10) {
            for _ in 0..<cycles {
                burst()
                cycleCount += 1
                // printGrid()
            }
        }

        mutating func burst() {
            var currentLocation = virus.location

            // expand our grid size if we are on the edge
            if  abs(currentLocation.x) == gridSize / 2 ||
                abs(currentLocation.y) == gridSize / 2 {
                gridSize += 2
            }

            if let infectedIndex = infectedNodes.index(of: currentLocation) {
                virus.direction = virus.direction.rotateRight()
                infectedNodes.remove(at: infectedIndex) // clean node
                cleaningCycles += 1
            } else {
                virus.direction = virus.direction.rotateLeft()
                infectedNodes.append(currentLocation) // infect node
                infectingCycles += 1
            }

            // move
            virus.location = virus.location.move(virus.direction)
        }

        func printGrid() {
            print("Cycles: \(cycleCount) \t Infecting: \(infectingCycles)")

            let halfGrid = gridSize / 2
            let gridRange = (0-halfGrid)...halfGrid
            for y in gridRange {
                var row = ""
                for x in gridRange {
                    let location = Location(x,y)
                    let previousLocation = Location(x-1,y)

                    var prefix = " "
                    if virus.location == location {
                        switch virus.direction {
                        case .up:
                            prefix = "🡑"
                        case .down:
                            prefix = "🡓"
                        case .left:
                            prefix = "<" // "🡐"
                        case .right:
                            prefix = ">" // "🡒"
                        }
                        // prefix = "["
                    } else if virus.location == previousLocation {
                        prefix = "]"
                    }

                    if infectedNodes.contains(location) {
                        row += "\(prefix)#"
                    } else {
                        row += "\(prefix)."
                    }
                }
                print(row)
            }

            print("---------------------------------")
        }
    }

    // MARK: -

    func defaultInput() -> String? {
        let path = "\(dataPath())/day22input.txt"
        return try? String(contentsOfFile: path, encoding: .utf8)
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 22: 💥 NO INPUT")
            exit(10)
        }

        let thing = partOne(input: runInput)
        guard let answer = thing else {
            print("Day 22: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 22: (Part 1) Answer ", answer)

        // ...
    }

    // MARK: -

    func partOne(input: String) -> Int? {
        var cluster = ComputingCluster(input)
        cluster.printGrid()
        cluster.run(cycles: 10_000)
        cluster.printGrid()
        return cluster.infectingCycles
    }

    func partTwo(input: String) -> Int? {
        return nil
    }
}

