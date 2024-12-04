//
//  Day4_2024.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/4/24.
//

import Foundation

struct Day4_2024: AdventDay {
    var year = 2024
    var dayNumber = 4
    var dayTitle = "Mull It Over"
    var stars = 1

    func parse(_ input: String?) -> GridMap<String> {
        let lines: [String] = (input ?? "").split(separator: "\n").map(String.init)
        let mapData: [[String]] = lines.map { $0.map(String.init) }
        return GridMap(items: mapData)
    }

    func findXMAS(in grid: GridMap<String>) -> [[Coordinate]] {
        var xmasEntries = [[Coordinate]]()

        // find all X's
        let xCoordinates = grid.filter { $1 == "X" }

        let directions = Coordinate.RelativeDirection.allCases.filter { $0 != .same }

        // for each X determine how many XMASs extend from it (could be multiple)
        for x in xCoordinates {
            let valid = directions.compactMap { direction in
                isXMAS(in: grid, starting: x, traveling: direction)
            }
            xmasEntries += valid
        }

        return xmasEntries
    }

    func isXMAS(in grid: GridMap<String>, starting origin: Coordinate, traveling direction: Coordinate.RelativeDirection) -> [Coordinate]? {
        var point = origin
        var coordinates = [Coordinate]()
        var values = [String]()

        for _ in (0...3) {
            guard let item = grid.item(at: point) else { return nil }
            coordinates.append(point)
            values.append(item)

            point = point.moving(direction: direction, originTopLeft: true)
        }

        guard values.joined() == "XMAS" else { return nil }
        return coordinates
    }

    func partOne(input: String?) -> Any {
        let grid = parse(input)
        return findXMAS(in: grid).count
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
