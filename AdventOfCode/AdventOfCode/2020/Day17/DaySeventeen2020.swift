//
//  DaySeventeen.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/17/20.
//

import Foundation

struct DaySeventeen2020: AdventDay {
    var year = 2020
    var dayNumber = 17
    var dayTitle = "Conway Cubes"
    var stars = 2

    func partOne(input: String?) -> Any {
        let source = PowerSource(input ?? "")
        source.run(cycles: 6, shouldPrint: false)
        return source.activeCubes
    }

    func partTwo(input: String?) -> Any {
        let source = ExperimentalPowerSource(input ?? "")
        source.run(cycles: 6, shouldPrint: false)
        return source.activeCubes
    }
}
