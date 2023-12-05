//
//  Day5_2023.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/5/23.
//

import Foundation

struct Day5_2023: AdventDay {
    var year = 2023
    var dayNumber = 5
    var dayTitle = "If You Give A Seed A Fertilizer"
    var stars = 1

    func partOne(input: String?) -> Any {
        let almanac = Almanac.parse(input ?? "")
        let finalLocations = almanac.seeds.compactMap { almanac.location(of:$0) }
        return finalLocations.sorted().first ?? -1
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
