//
//  TopoMap.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/10/24.
//

import Foundation

class TopoMap {
    let grid: GridMap<String>

    var startingPoints: [Coordinate] = []

    init(grid: GridMap<String>) {
        self.grid = grid

        findStartingPoints()
    }

    /// Find the starting points within the grid.
    ///
    /// A starting point should start at `0` but also contain at least one route. A
    /// route from the start is defined as being +1 (ie: `== 1`) in the topo map...
    func findStartingPoints() {
        let zeros = grid.filter { $1 == "0" }
        startingPoints = zeros.filter { coordinate in
            return !(adjacent(to: coordinate, matching: "1").isEmpty)
//            let neighbors = grid.adjacentCoordinates(to: coordinate, allowDiagonals: false)
//            return neighbors.first(where: { grid.item(at: $0) == "1" }) != nil
        }
    }

    func adjacent(to coordinate: Coordinate, matching: String) -> [Coordinate] {
        let neighbors = grid.adjacentCoordinates(to: coordinate, allowDiagonals: false)
        return neighbors.filter { grid.item(at: $0) == matching }
    }

    func scoreTrailheads() async -> [Coordinate: Int] {
        let routes = await findRoutes()

        // hash from origin to all final points
        var finalPoints: [Coordinate: Set<Coordinate>] = [:]

        for route in routes {
            guard let first = route.first, let last = route.last else { continue }
            var final = finalPoints[first] ?? Set()
            final.insert(last)
            finalPoints[first] = final
        }

        var scores: [Coordinate: Int] = [:]
        finalPoints.forEach { scores[$0.key] = $0.value.count }
        return scores
    }

    /// Find all possible paths
    func findRoutes() async -> [[Coordinate]] {
        var possiblePaths: [[Coordinate]] = []

        for origin in startingPoints {
            possiblePaths += await hikePaths(from: origin)
        }

        return possiblePaths
    }

    /// Follow the paths leading away from the current position. (Uses async and recursion)
    ///
    /// Use the previously traveled path to ensure no looping.
    ///
    /// - Returns: Complete paths (if any) from current position to end.
    func hikePaths(from current: Coordinate, path: [Coordinate] = []) async -> [[Coordinate]] {
        var updatedPath = path + [current]

        guard let currentItem = grid.item(at: current), let currentNum = Int(currentItem), currentNum != 9 else {
            // we've reached the end...
            return [updatedPath]
        }

        let nextPoints = adjacent(to: current, matching: "\(currentNum + 1)")

        var possiblePaths: [[Coordinate]] = []

        for point in nextPoints {
            guard !updatedPath.contains(point) else { continue } // skip loops

            possiblePaths += await hikePaths(from: point, path: updatedPath)
        }

        return possiblePaths
    }
}
