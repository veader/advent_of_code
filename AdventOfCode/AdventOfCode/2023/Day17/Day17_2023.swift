//
//  Day17_2023.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/19/23.
//

import Foundation

struct Day17_2023: AdventDay {
    var year = 2023
    var dayNumber = 17
    var dayTitle = "Clumsy Crucible"
    var stars = 0

    func parse(_ input: String?) -> GridMap<Int> {
        let nums = (input ?? "").lines().map { $0.charSplit().compactMap(Int.init) }
        return GridMap(items: nums)
    }

    func partOne(input: String?) async -> Any {
        return 0
    }

    func partTwo(input: String?) async -> Any {
        return 0
    }
}
