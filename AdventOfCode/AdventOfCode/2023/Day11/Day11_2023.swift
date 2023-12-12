//
//  Day11_2023.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/11/23.
//

import Foundation

struct Day11_2023: AdventDay {
    var year = 2023
    var dayNumber = 11
    var dayTitle = "Cosmic Expansion"
    var stars = 1

    enum SpaceData: String, CustomDebugStringConvertible {
        case space = "."
        case galaxy = "#"

        var debugDescription: String { rawValue }
    }

    func parse(_ input: String?) -> GridMap<SpaceData> {
        let data: [[SpaceData]] = (input ?? "").lines().map { line in
            line.charSplit().compactMap { SpaceData(rawValue: $0) }
        }

        return GridMap(items: data)
    }

    func expand(_ grid: GridMap<SpaceData>) {
        let emptyCols = grid.xBounds.compactMap { x -> Int? in
            guard let col = grid.column(x: x) else { return nil }
            let set = Set(col)
            if set.contains(.space) && set.count == 1 {
                return x
            } else {
                return nil
            }
        }

        let emptyRows = grid.yBounds.compactMap { y -> Int? in
            guard let row = grid.row(y: y) else { return nil }
            let set = Set(row)
            if set.contains(.space) && set.count == 1 {
                return y
            } else {
                return nil
            }
        }

//        print("Empty columns found at: \(emptyCols)")
//        print("Empty rows found at: \(emptyRows)")

        for (factor, x) in emptyCols.sorted().enumerated() {
            grid.insertColumn(at: x + factor, value: .space)
        }

        for (factor, y) in emptyRows.sorted().enumerated() {
            grid.insertRow(at: y + factor, value: .space)
        }
    }

    func findGalaxies(in grid: GridMap<SpaceData>) -> [Coordinate] {
        grid.filter(by: { $1 == .galaxy })
    }

    func calculateDistances(in grid: GridMap<SpaceData>) -> [Int] {
        let galaxies = findGalaxies(in: grid)

        let pairs: [[Coordinate]] = galaxies.enumerated().flatMap { idx, c -> [[Coordinate]] in
            guard galaxies.count > idx + 1 else { return [] }
            let theRest = galaxies.suffix(from: idx + 1)
            return theRest.map { [c, $0] }
        }

        return pairs.map { $0.first!.distance(to: $0.last!) }
    }

    func partOne(input: String?) -> Any {
        let grid = parse(input)
        expand(grid)
        let distances = calculateDistances(in: grid)
        return distances.reduce(0, +)
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
