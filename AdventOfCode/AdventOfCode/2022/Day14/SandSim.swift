//
//  SandSim.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/16/22.
//

import Foundation
import RegexBuilder

enum SandSimError: Error {
    case aboveNothing
}

class SandSim {
    // parse lines into coordinate pieces (each pair makes a line)
    // make map from lines
    //   - take lines and create list of coordinates that are rock
    // printing
    // simulate sand falling

    let paths: [[Coordinate]]
    let lines: [[Coordinate]]
    let sandStart = Coordinate(x: 500, y: 0)

    var rocks: Set<Coordinate>
    var sand: Set<Coordinate>

    init(paths: [[Coordinate]]) {
        self.paths = paths
        self.lines = [] // TODO
        self.rocks = []
        self.sand = []

        findRocks()
    }

    /// Run the simulation. Each round is a single grain of sand dropping...
    func run(rounds: Int = Int.max) -> Int {
        var round = 0
        while round < rounds {
            do {
                try dropSand()
            } catch {
                print("Sand into the void... \(round)")
                return round
            }
            round += 1
        }

        return -1 // can take more sand
    }

    func dropSand() throws {
        var sandPosition = sandStart
        var canMove = true

        while canMove {
            // check that there is *anything* below us
            if !isSomethingBelow(coordinate: sandPosition) {
                throw SandSimError.aboveNothing
            }

            // look straight down
            let downOne = sandPosition.moving(xOffset: 0, yOffset: 1)
            if isEmpty(coordinate: downOne) {
                sandPosition = downOne
            } else {
                // look down, left
                let downLeft = sandPosition.moving(xOffset: -1, yOffset: 1)
                if isEmpty(coordinate: downLeft) {
                    sandPosition = downLeft
                } else {
                    let downRight = sandPosition.moving(xOffset: 1, yOffset: 1)
                    if isEmpty(coordinate: downRight) {
                        sandPosition = downRight
                    } else {
                        canMove = false // sand "stuck"
                    }
                }
            }
        }

        // add resting place to sand collection
        sand.insert(sandPosition)
    }

    /// Check that somewhere below this point *something* (either sand or rock) exists...
    private func isSomethingBelow(coordinate: Coordinate) -> Bool {
        let rocks = rocks.filter { $0.y > coordinate.y } // any rock(s) below the point
        let sand = sand.filter { $0.y > coordinate.y }   // any sand below the point
        return !rocks.isEmpty || !sand.isEmpty
    }

    /// Check that the given coordinate is empty. (Checking both sand and rocks)
    private func isEmpty(coordinate: Coordinate) -> Bool {
        !rocks.contains(coordinate) && !sand.contains(coordinate)
    }

    func findRocks() {
        for path in paths {
            for idx in (1..<path.count) {
                let start = path[path.index(before: idx)]
                let end = path[idx]
                let points = pointsInLine(start: start, end: end)
                points.forEach { rocks.insert($0) }
//                rocks.append(contentsOf: points)
                // Optimization? Ignore any rock over 500?
            }
        }
    }

    func pointsInLine(start: Coordinate, end: Coordinate) -> [Coordinate] {
        // lines (for now) are only straight horizontal or vertical
        if start.x == end.x { // vertical line
            let minY = min(start.y, end.y)
            let maxY = max(start.y, end.y)

            return (minY...maxY).map { Coordinate(x: start.x, y: $0) }
        } else if start.y == end.y { // horizontal line
            let minX = min(start.x, end.x)
            let maxX = max(start.x, end.x)

            return (minX...maxX).map { Coordinate(x: $0, y: start.y) }
        }

        print("Points not in a line: \(start) - \(end)")
        return [] // diagonal line
    }

    func printScan() {
        let rockXs = rocks.map(\.x).sorted().unique()
        let rockYs = rocks.map(\.y).sorted().unique()
//        let sandXs = sand.map(\.x).sorted()
//        let sandYs = sand.map(\.y).sorted()
//
//        let minX = min(rockXs.min() ?? 0, sandXs.min() ?? 0, sandStart.x) - 10
//        let maxX = max(rockXs.max() ?? 0, sandXs.max() ?? 0, sandStart.x) + 10
//        let minY = min(rockYs.min() ?? 0, sandYs.min() ?? 0, sandStart.y) - 10
//        let maxY = min(rockYs.max() ?? 0, sandYs.max() ?? 0, sandStart.y) + 10

        let minX = min(rockXs.min() ?? 0, sandStart.x) - 5
        let maxX = max(rockXs.max() ?? 0, sandStart.x) + 5
        let minY = min(rockYs.min() ?? 0, sandStart.y) - 2
        let maxY = min(rockYs.max() ?? 0, sandStart.y) + 12

        print(rockXs)
        print(rockYs)
        print(sandStart)
        print("\(minX)...\(maxX)")
        print("\(minY)...\(maxY)")

        var output: [String] = []
        for y in minY...maxY {
            var line = ""
            for x in minX...maxX {
                let pt = Coordinate(x: x, y: y)
                if rocks.contains(pt) {
                    line += "#"
                } else if sand.contains(pt) {
                    line += "o"
                } else if pt == sandStart {
                    line += "+"
                } else {
                    line += "."
                }
            }
            output.append(line)
        }

        print(output.joined(separator: "\n"))
    }


    // MARK: - Parsing

    static func parse(_ input: String) -> [[Coordinate]] {
        input.split(separator: "\n").map(String.init).map { line in
            line.matches(of: rockRegex).compactMap { match in
                guard let x = Int(match.1), let y = Int(match.2) else { print("😬"); return nil }
                return Coordinate(x: x, y: y)
            }
        }
    }

    static let rockRegex = Regex {
        Capture {
            OneOrMore(.digit)
        }
        ","
        Capture {
            OneOrMore(.digit)
        }
        Optionally {
            OneOrMore(.whitespace)
            "->"
            OneOrMore(.whitespace)
        }
    }
}
