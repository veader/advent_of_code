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
    var stars = 2

    func partOne(input: String?) -> Any {
        let system = SolarSystem(input ?? "")
        // system.simpleExpand()
        system.expand()
        let distances = system.calculateDistances()
        return distances.reduce(0, +)
    }

    func partTwo(input: String?) -> Any {
        let system = SolarSystem(input ?? "")
        system.expand(by: 1_000_000)
        let distances = system.calculateDistances()
        return distances.reduce(0, +)
    }
}
