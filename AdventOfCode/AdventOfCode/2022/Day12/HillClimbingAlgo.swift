//
//  HillClimbingAlgo.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/12/22.
//

import Foundation
import OrderedCollections

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

    /// Find all of the lowest points on the map.
    func lowestPoints() -> [Coordinate] {
        map.filter(by: { $1 == Character("a") })
    }

    /// Find the shortest possible path from any of the lowest points to the end
    func shortestRoute() -> [Coordinate]? {
        let lowestPoints = self.lowestPoints()
        let bestRoutes = lowestPoints.map {
            climb(start: $0)
        }.filter { !$0.isEmpty }

        return bestRoutes.sorted(by: { $0.count < $1.count }).first
    }

    /// Climb the terrain starting at our start coordinate and finding the shortest path to the end coordinate.
    /// - Parameters:
    ///     - start: `Coordinate` to originate the search from. Defaults to `start`
    func climb(start startingCoordinate: Coordinate? = nil) -> [Coordinate] {
        ascentHistory = [:] // clear the history
        var coordinatesToCheck = OrderedSet<Coordinate>()

        // setup
        let coord = startingCoordinate ?? start
        coordinatesToCheck.append(coord)
        saveHistory(for: coord, path: [coord])

        while !coordinatesToCheck.isEmpty {
            // pull first one off the ordered set to process
            let coordinate = coordinatesToCheck.removeFirst()
            let adjacent = ascend(to: coordinate)

            // push valid adjacent coordinates into the set of ones to check
            coordinatesToCheck.append(contentsOf: adjacent)
        }

        let finalPath = ascentHistory[end]
        return finalPath ?? []
    }

    /// Ascend to the given coordinate and determine what possible options there are to go from here.
    /// - Note: Using a bit of BFS (breadth first search) tactics to scan
    private func ascend(to coordinate: Coordinate) -> [Coordinate] {
        let path = ascentHistory[coordinate] ?? []

        // see if we reached the end
        guard coordinate != end else { return [] }

        // determine the value at the current coordinate to help filter adjacent spaces
        let sourceValue = value(at: coordinate)
        let possibleRange = 0...(sourceValue + 1) // possible values are anything lower than +1 of the current pont

        // find adjacent spaces and filter based on points not traveled and proper values
        let adjacent = map.adjacentCoordinates(to: coordinate, allowDiagonals: false)
            .filter { !path.contains($0) } // filter any that are already in our path (no back-tracking)
            .filter { possibleRange.contains(value(at: $0)) } // filter based on height (+/- 1)
            .filter { point in
                let pointPath = path + [point]
                if historySize(at: point) > pointPath.count {
                    saveHistory(for: point, path: pointPath)
                    return true
                } else {
                    return false // shorter path already considered to this place
                }
            }
//            .sorted(by: { value(at: $0) > value(at: $1) }) // prioritize going up

        return adjacent
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
