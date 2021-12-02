//
//  DayThree.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/3/20.
//

import Foundation

struct DayThree2020: AdventDay {
    var year = 2020
    var dayNumber = 3
    var dayTitle = "Toboggan Trajectory"
    var stars = 2

    func parse(_ input: String?) -> Forest? {
        Forest(input)
    }

    func partOne(input: String?) -> Any {
        guard let forest = parse(input) else { return 0 }

        let slope = Forest.Slope(rise: 1, run: 3)
        return forest.impacts(traveling: slope)
    }

    func partTwo(input: String?) -> Any {
        guard let forest = parse(input) else { return 0 }

        let slopes = [
            Forest.Slope(rise: 1, run: 1),
            Forest.Slope(rise: 1, run: 3),
            Forest.Slope(rise: 1, run: 5),
            Forest.Slope(rise: 1, run: 7),
            Forest.Slope(rise: 2, run: 1),
        ]

        let impacts = slopes.map { forest.impacts(traveling: $0) }
        return impacts.reduce(1, { $0 * $1 })
    }
}
