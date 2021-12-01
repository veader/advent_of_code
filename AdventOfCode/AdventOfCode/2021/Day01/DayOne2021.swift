//
//  DayOne2021.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/1/21.
//

import Foundation

struct DayOne2021: AdventDay {
    var year = 2021
    var dayNumber = 1
    var dayTitle = "Sonar Sweep"
    var stars = 1

    func parse(_ input: String?) -> [Int] {
        (input ?? "").split(separator: "\n").compactMap { Int($0) }
    }

    func partOne(input: String?) -> Any {
        let depths = parse(input)

        var depthIncreases = 0
        var lastDepth: Int?
        depths.forEach { depth in
            if let lastDepth = lastDepth, depth > lastDepth {
                depthIncreases += 1
            }

            lastDepth = depth
        }

        return depthIncreases
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
