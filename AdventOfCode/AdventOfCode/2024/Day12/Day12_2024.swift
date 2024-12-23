//
//  Day12_2024.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/12/24.
//

import Foundation

struct Day12_2024: AdventDay {
    var year = 2024
    var dayNumber = 12
    var dayTitle = "Garden Groups"
    var stars = 1

    func parse(_ input: String?) -> GardenPlots {
        let data: [[String]] = (input ?? "").lines().map { $0.charSplit()}
        return GardenPlots(map: GridMap(items: data))
    }

    func partOne(input: String?) -> Any {
        let gardens = parse(input)
        return gardens.calculateCosts()
    }

    func partTwo(input: String?) -> Any {
//        let gardens = parse(input)
        return 0
    }
}
