//
//  HillClimbingAlgo.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/12/22.
//

import Foundation

class HillClimbingAlgo {
    let start: Coordinate
    let end: Coordinate
    let map: GridMap<Character>

    private var ascentHistory: [Coordinate: [Coordinate]]

    init(_ input: String) {
        var startCoordinate: Coordinate?
        var endCoordinate: Coordinate?

        let lines = input.split(separator: "\n").map(String.init)
        let mapData = lines.enumerated().map { y, line -> [Character] in
            line.enumerated().map { x, char -> Character in
                var c = char
                if char == "S" {
                    startCoordinate = Coordinate(x: x, y: y)
                    c = Character("a")
                } else if char == "E" {
                    endCoordinate = Coordinate(x: x, y: y)
                    c = Character("z")
                }

                return c // Int(c.asciiValue ?? 0)
            }
        }

        self.start = startCoordinate ?? Coordinate.origin
        self.end = endCoordinate ?? Coordinate.origin
        self.map = GridMap(items: mapData)
        self.ascentHistory = [:]
    }

    /// Climb the terrain starting at our start coordinate and finding the shortest path to the end coordinate.
    func climb() -> [Coordinate]? {
//        map.printGrid()
        ascentHistory = [:] // clear the history
        return ascend(from: start, to: end, path: [])
    }

    /// Recursively called method that will start at a source, consider possible adjacent coordinates,
    ///     and attempt to find the shortest path to the end coordinate.
    private func ascend(from source: Coordinate, to destination: Coordinate, path: [Coordinate]) -> [Coordinate]? {
        // check for being at the end
        if source == destination {
            print("Found the end! \(path)")
            return path // we made it to the end
        }

        var currentPath = path; currentPath.append(source) // why is this necessary?
//        let currentPath = path + [source]

        // check that history doesn't have a shorter path to this point
        guard historySize(at: source) > currentPath.count else {
            print("Found shorter path in history...")
            return nil
        }
        // if we have a shorter path, then proceed...

        // save current (shorter) path to the history
        saveHistory(for: source, path: currentPath)

        let sourceValue = value(at: source)
        let possibleRange = (sourceValue - 1)...(sourceValue + 1) // possible values are +/1 current value

//        print("Examining \(source) of value \(map.item(at: source)) \(sourceValue) : range \(possibleRange)")
        print("Examining \(source) of \(sourceValue) : range \(possibleRange)")
        print("\tPath (size): \(currentPath.count)")

        // find adjacent items (up/down/left/right - in bounds)
        let adjacent = map.adjacentCoordinates(to: source, allowDiagonals: false)
            .filter { !path.contains($0) } // filter any that are already in our path (no back-tracking)
            .filter { possibleRange.contains(value(at: $0)) } // filter based on height (+/- 1)
            .sorted(by: { value(at: $0) > value(at: $1) }) // prioritize going up

        print("\tPossible adjacent: \(adjacent)")

        // for each possible adjacent square, track it down...
        let possibilities = adjacent.compactMap { nextCoordinate in
            ascend(from: nextCoordinate, to: destination, path: currentPath)
        }

        return possibilities.sorted(by: { $0.count < $1.count }).first
    }

    private func historySize(at coordinate: Coordinate) -> Int {
        guard let path = ascentHistory[coordinate] else { return Int.max }
        return path.count
    }

    private func saveHistory(for coordinate: Coordinate, path: [Coordinate]) {
        ascentHistory[coordinate] = path
    }

    private func value(at coordinate: Coordinate) -> Int {
        Int(map.item(at: coordinate)?.asciiValue ?? 0)
    }
}
