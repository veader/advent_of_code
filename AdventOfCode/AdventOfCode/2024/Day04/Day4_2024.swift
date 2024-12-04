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
    var dayTitle = "Ceres Search"
    var stars = 2

    func parse(_ input: String?) -> GridMap<String> {
        let lines: [String] = (input ?? "").split(separator: "\n").map(String.init)
        let mapData: [[String]] = lines.map { $0.map(String.init) }
        return GridMap(items: mapData)
    }

    /// Find all `XMAS` records within the grid.
    ///
    /// They may be vertical, horizontal, diagonal, backwards, etc.
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

    /// Find `XMAS` in our grid starting with the `X` at the origin moving in the given directon.
    func isXMAS(in grid: GridMap<String>, starting origin: Coordinate, traveling direction: Coordinate.RelativeDirection) -> [Coordinate]? {
        var point = origin
        var coordinates = [Coordinate]()
        var values = [String]()

        /// Gather up the 4 values in the given direction. Stop if we go out of bounds.
        for _ in (0...3) {
            guard let item = grid.item(at: point) else { return nil }
            coordinates.append(point)
            values.append(item)

            point = point.moving(direction: direction, originTopLeft: true)
        }

        /// Confirm we found `XMAS`
        guard values.joined() == "XMAS" else { return nil }
        return coordinates
    }

    /// Find all records of `MAS` in an `X` pattern within the grid.
    func findMASinX(in grid: GridMap<String>) -> [[Coordinate]] {
        var xmasEntries = [[Coordinate]]()

        // find all A's
        let aCoordinates = grid.filter { $1 == "A" }

        for a in aCoordinates {
            if let coords = isMASX(in: grid, centeredOn: a) {
                xmasEntries.append(coords)
            }
        }

        return xmasEntries
    }

    /// Find an instance of `MAS` in an `X` pattern centered on the `A` at origin.
    func isMASX(in grid: GridMap<String>, centeredOn origin: Coordinate) -> [Coordinate]? {
        let backSlash: [Coordinate] = [
            origin.moving(direction: .northWest, originTopLeft: true),
            origin,
            origin.moving(direction: .southEast, originTopLeft: true),
        ]
        let backValue = backSlash.compactMap { grid.item(at: $0) }.joined()
        guard backValue == "MAS" || backValue == "SAM" else { return nil }

        let forwardSlash: [Coordinate] = [
            origin.moving(direction: .northEast, originTopLeft: true),
            origin,
            origin.moving(direction: .southWest, originTopLeft: true),
        ]
        let forwardValue = forwardSlash.compactMap { grid.item(at: $0) }.joined()
        guard forwardValue == "MAS" || forwardValue == "SAM" else { return nil }

        return (backSlash + forwardSlash).unique()
    }

    func partOne(input: String?) -> Any {
        let grid = parse(input)
        return findXMAS(in: grid).count
    }

    func partTwo(input: String?) -> Any {
        let grid = parse(input)
        return findMASinX(in: grid).count
    }
}
