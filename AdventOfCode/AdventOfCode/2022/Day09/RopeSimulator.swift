//
//  RopeSimulator.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/9/22.
//

import Foundation
import RegexBuilder

class RopeSimulator {
    enum SimInstruction {
        case up(Int)
        case down(Int)
        case left(Int)
        case right(Int)

        static let instructionRegex = Regex {
            Capture {
                ChoiceOf {
                    "U"
                    "D"
                    "L"
                    "R"
                }
            }
            OneOrMore(.whitespace)
            Capture {
                OneOrMore(.digit)
            }
        }

        static func parse(_ line: String) -> SimInstruction? {
            guard let match = line.firstMatch(of: instructionRegex), let amount = Int(match.2) else { return nil }

            switch match.1 {
            case "U":
                return .up(amount)
            case "D":
                return .down(amount)
            case "L":
                return .left(amount)
            case "R":
                return .right(amount)
            default:
                return nil
            }
        }
    }

    let instructions: [SimInstruction]

    /// Knots that make up the rope. Index 0 (first) is the "head". The last knot is the "tail".
    var knots: [Coordinate]

    /// Coordinates that the tail
    var visitedCoordinates: Set<Coordinate>

    init(_ input: String, length: Int = 2) {
        self.instructions = input.split(separator: "\n").map(String.init).compactMap { line in
            SimInstruction.parse(line)
        }

        self.knots = Array(repeating: Coordinate.origin, count: length)
        self.visitedCoordinates = Set<Coordinate>([Coordinate.origin])
    }

    func run() {
        for instruction in instructions {
            process(instruction)
        }
    }

    private func process(_ instruction: SimInstruction) {
        var amount: Int = 0
        var movementOffset: (Int, Int) = (0,0)

        switch instruction {
        case .up(let y):
            amount = y
            movementOffset = (0, 1)
        case .down(let y):
            amount = y
            movementOffset = (0, -1)
        case .left(let x):
            amount = x
            movementOffset = (-1, 0)
        case .right(let x):
            amount = x
            movementOffset = (1, 0)
        }

        (0..<amount).forEach { i in
            for (idx, knot) in knots.enumerated() {
                if idx == 0 { // deal with the "head"
                    let head = knot.moving(xOffset: movementOffset.0, yOffset: movementOffset.1)
                    knots[idx] = head
                } else {
                    let newCoord = destination(of: idx, following: knots.index(before: idx))
                    knots[idx] = newCoord

                    // record where the "tail" visits
                    if idx == knots.count - 1 {
                        visitedCoordinates.insert(knots[idx])
                    }
                }
            }
        }
    }

    func destination(of idx: Int, following followIdx: Int) -> Coordinate {
        let aheadKnot = knots[followIdx]
        let behindKnot = knots[idx]


        let distance = behindKnot.distance(to: aheadKnot)
        let direction = behindKnot.direction(to: aheadKnot)

        if [.north, .east, .south, .west].contains(direction) && distance < 2 {
            // only move if we're 2 or more away for non-diagonals
            return behindKnot
        } else if [.northEast, .southEast, .southWest, .northWest].contains(direction) && distance <= 2 {
            // only move if we're more than 2 away for diagonals
            return behindKnot
        }

        switch direction {
        case .north:
            return behindKnot.moving(xOffset: 0, yOffset: 1)
        case .northEast:
            return behindKnot.moving(xOffset: 1, yOffset: 1)
        case .east:
            return behindKnot.moving(xOffset: 1, yOffset: 0)
        case .southEast:
            return behindKnot.moving(xOffset: 1, yOffset: -1)
        case .south:
            return behindKnot.moving(xOffset: 0, yOffset: -1)
        case .southWest:
            return behindKnot.moving(xOffset: -1, yOffset: -1)
        case .west:
            return behindKnot.moving(xOffset: -1, yOffset: 0)
        case .northWest:
            return behindKnot.moving(xOffset: -1, yOffset: 1)
        case .same:
            return behindKnot // don't move
        }
    }

    func printIteration(showingVisited: Bool = false) {
        let start = Coordinate.origin

        // TODO: may need to pull min/max out of the visited if we're showing visited
        var coordinates = knots
        coordinates.append(start)

        let xs = coordinates.map { $0.x }
        let minX = (xs.min() ?? 0) - 2
        let maxX = (xs.max() ?? 0) + 2

        let ys = coordinates.map { $0.y }
        let minY = (ys.min() ?? 0) - 2
        let maxY = (ys.max() ?? 0) + 2

        let output = (minY...maxY).reversed().map { y in
            (minX...maxX).map { x in
                let c = Coordinate(x: x, y: y)

                if showingVisited {
                    return visitedCoordinates.contains(c) ? "#" : "."
                } else {
                    if let idx = knots.firstIndex(of: c) {
                        if idx == 0 {
                            return "H"
                        } else if idx == knots.count - 1 {
                            return "T"
                        } else {
                            return "\(idx)"
                        }
                    } else if c == start {
                        return "s"
                    } else {
                        return "."
                    }
                }
            }.joined()
        }
        print(output.joined(separator: "\n") + "\n")
    }
}
