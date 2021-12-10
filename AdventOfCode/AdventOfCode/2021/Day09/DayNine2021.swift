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

    func partOne(input: String?) -> Any {
        let grid = GridMap<Int>(items: parse(input))
        let lowPointCoordinates = grid.filter { c, i in
            let adj = grid.adjacentItems(to: c)
            return adj.filter({ $0 < i }).count == 0
        }
        //print(lowPointCoordinates)
        let riskLevel = lowPointCoordinates
            .compactMap({ grid.item(at: $0) })
            .map({ $0 + 1 })
            .reduce(0, +)

        return riskLevel
    }

    func partTwo(input: String?) -> Any {
        Int.min
    }
}
