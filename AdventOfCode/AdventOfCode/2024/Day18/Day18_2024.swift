//
//  Day18_2024.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/22/24.
//

import Foundation

struct Day18_2024: AdventDay {
    var year = 2024
    var dayNumber = 18
    var dayTitle = "RAM Run"
    var stars = 1

    func parse(_ input: String?) -> [Coordinate] {
        (input ?? "").lines().compactMap { Coordinate.parse($0) }
    }

    /// Make a square maze of the given size and filled with points specified by coordinates and count.
    ///
    /// The number of coordinates to use (count) must be less than total size of the coordinates.
    func createMaze(coordinates: [Coordinate], count: Int = .max, size: Int = 71) -> String? {
        guard count < coordinates.count else { return nil }

        let grid = GridMap<String>(width: size, height: size, initialValue: ".")

        let points = coordinates.prefix(count)
        for point in points {
            grid.update(at: point, with: "#")
        }

        // set start and end
        grid.update(at: .origin, with: "S")
        grid.update(at: Coordinate(x: size-1, y: size-1), with: "E")

        return grid.gridAsString()
    }

    func partOne(input: String?) async-> Any {
        let coordinates = parse(input) // 3450
        guard let mazeString = createMaze(coordinates: coordinates, count: 1024) else { return 0 }
        print(mazeString)
        if let maze = ReindeerMaze(input: mazeString, turnCost: 0) {
            guard let solution = maze.crawlMaze() else { return 0 }
            return solution.path.count - 1 // skip origin
        }
        return 0
    }

    func partTwo(input: String?) async -> Any {
//        let coordinates = parse(input)
//        let mazeString = createMaze(coordinates: coordinates)
        return 0
    }
}
