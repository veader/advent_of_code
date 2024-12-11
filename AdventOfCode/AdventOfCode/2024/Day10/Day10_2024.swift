//
//  Day10_2024.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/10/24.
//

import Foundation

struct Day10_2024: AdventDay {
    var year = 2024
    var dayNumber = 10
    var dayTitle = "Hoof It"
    var stars = 1

    func parse(_ input: String?) -> TopoMap {
        let data: [[String]] = (input ?? "").lines().map { $0.charSplit()}
        return TopoMap(grid: GridMap(items: data))
    }

    func partOne(input: String?) async-> Any {
        let map = parse(input)
        let scores = await map.scoreTrailheads()
        return scores.values.reduce(0, +)
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
