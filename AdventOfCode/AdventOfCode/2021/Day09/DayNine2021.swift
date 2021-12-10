//
//  DayNine2021.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/9/21.
//

import Foundation

struct DayNine2021: AdventDay {
    var year = 2021
    var dayNumber = 9
    var dayTitle = "Smoke Basin"
    var stars = 1

    func parse(_ input: String?) -> [[Int]] {
        (input ?? "")
            .split(separator: "\n")
            .map { $0.map(String.init).compactMap(Int.init) }
    }

    func findLowPoints(grid: GridMap<Int>) -> [Coordinate] {
        return grid.filter { c, i in
            let adj = grid.adjacentItems(to: c)
            return adj.filter({ $0 < i }).count == 0
        }
    }

    func findBasin(grid: GridMap<Int>, consider: [Coordinate], matches: Set<Coordinate> = [], debugPrint: Bool = false) -> [Coordinate] {
        if debugPrint {
            print("\(#function): consider:[\(consider)], matches:[\(matches)]")
        }

        guard let current = consider.first, let item = grid.item(at: current) else {
            if debugPrint {
                print("\tNo more coordinates to consider. Returning matches...")
            }
            return Array(matches)
        }

        if debugPrint {
            print("\tConsidering \(current) -> \(item)")
        }

        let plusOnes = grid.adjacentCoordinates(to: current).filter { c in
            guard let v = grid.item(at: c), v != 9 else { return false }
            return v == item + 1
        }
        if debugPrint {
            print("\tNew coordinates to consider \(plusOnes)")
        }

        let currentSet = Set([current])
        // add on new points to consider, removing the one we just did, and any we've done before
        let newConsider = Set(consider + plusOnes).subtracting(currentSet).subtracting(matches)

        return findBasin(grid: grid, consider: Array(newConsider), matches: matches.union(currentSet), debugPrint: debugPrint)
    }

    func partOne(input: String?) -> Any {
        let grid = GridMap<Int>(items: parse(input))
        let lowPoints = findLowPoints(grid: grid)

        let riskLevel = lowPoints
            .compactMap({ grid.item(at: $0) })
            .map({ $0 + 1 })
            .reduce(0, +)
        return riskLevel
    }

    func partTwo(input: String?) -> Any {
        let grid = GridMap<Int>(items: parse(input))
        grid.printSize()
        let lowPoints = findLowPoints(grid: grid)

        let basins = lowPoints.map { c -> Int in
            print("===============================================")
            let b = findBasin(grid: grid, consider: [c], debugPrint: true)
            print("Found basin of size \(b.count) at \(c)")
            return b.count
        }.sorted()
        print(basins)

        return basins.suffix(3).reduce(1, *)
    }
}
