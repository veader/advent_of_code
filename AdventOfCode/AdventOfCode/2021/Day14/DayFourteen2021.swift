//
//  DayFourteen2021.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/14/21.
//

import Foundation

struct DayFourteen2021: AdventDay {
    var year = 2021
    var dayNumber = 14
    var dayTitle = "Extended Polymerization"
    var stars = 1

    func partOne(input: String?) -> Any {
        let polymer = Polymer.parse(input ?? "")
        polymer.run(steps: 10)
        let histogram = polymer.histogram()
        print(histogram)

        let values = histogram.values.sorted()
        let max = values.max() ?? 0
        let min = values.min() ?? 0
        print("Max: \(max) | Min: \(min)")
        return max - min
    }

    func partTwo(input: String?) -> Any {
        let polymer = Polymer.parse(input ?? "")
        polymer.run(steps: 40)
        let histogram = polymer.histogram()
        print(histogram)

        let values = histogram.values.sorted()
        let max = values.max() ?? 0
        let min = values.min() ?? 0
        print("Max: \(max) | Min: \(min)")
        print(Int.max)
        return max - min
    }
}
