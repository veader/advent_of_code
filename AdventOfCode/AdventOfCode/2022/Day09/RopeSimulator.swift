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

    var head: Coordinate
    var tail: Coordinate
    var visitedCoordinates: Set<Coordinate>

    init(_ input: String) {
        self.instructions = input.split(separator: "\n").map(String.init).compactMap { line in
            SimInstruction.parse(line)
        }
        self.head = Coordinate.origin
        self.tail = Coordinate.origin
        self.visitedCoordinates = Set<Coordinate>([Coordinate.origin])
    }

    func run() {
//        print("== Initial State ==")
//        printIteration()

        for instruction in instructions {
            process(instruction)
        }
    }

    private func process(_ instruction: SimInstruction) {
        var letter: String = "*"
        var amount: Int = 0
        var movementOffset: (Int, Int) = (0,0)

        switch instruction {
        case .up(let y):
            letter = "U"
            amount = y
            movementOffset = (0, 1)
        case .down(let y):
            letter = "D"
            amount = y
            movementOffset = (0, -1)
        case .left(let x):
            letter = "L"
            amount = x
            movementOffset = (-1, 0)
        case .right(let x):
            letter = "R"
            amount = x
            movementOffset = (1, 0)
        }

//        print("== \(letter) \(amount) ==")

        (0..<amount).forEach { i in
//            print("\tIteration \(i+1)")

            // move head
            let currentHead = head
            head = head.moving(xOffset: movementOffset.0, yOffset: movementOffset.1)
//            print("\tMoving head... from \(currentHead) to \(head)")

            // follow tail (if not under/near head)
            let adjacent = head.adjacent(minX: Int.min, minY: Int.min)
            if tail != head && !adjacent.contains(tail) {
//                print("\tMoving tail...")
                tail = currentHead // to follow, the tail ends up where head used to be
                visitedCoordinates.insert(tail) // keep track of where the tail has been
            }

//            printIteration()
        }
    }

    func printIteration(showingVisited: Bool = false) {
        let start = Coordinate.origin

        // TODO: may need to pull min/max out of the visited if we're showing visited

        let xs = [start.x, head.x, tail.x]
        let minX = (xs.min() ?? 0) - 2
        let maxX = (xs.max() ?? 0) + 2

        let ys = [start.y, head.y, tail.y]
        let minY = (ys.min() ?? 0) - 2
        let maxY = (ys.max() ?? 0) + 2

        let output = (minY...maxY).reversed().map { y in
            (minX...maxX).map { x in
                let c = Coordinate(x: x, y: y)
                if showingVisited {
                    return visitedCoordinates.contains(c) ? "#" : "."
                } else {
                    switch c {
                    case head:
                        return "H"
                    case tail:
                        return "T"
                    case start:
                        return "s"
                    default:
                        return "."
                    }
                }
            }.joined()
        }
        print(output.joined(separator: "\n") + "\n")
    }
}
