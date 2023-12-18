//
//  Day16_2023.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/18/23.
//

import Foundation

struct Day16_2023: AdventDay {
    var year = 2023
    var dayNumber = 16
    var dayTitle = "The Floor Will Be Lava"
    var stars = 2

    func partOne(input: String?) async -> Any {
        let lightMap = LightMap(input ?? "")
        return await lightMap.traceLight()
    }

    func partTwo(input: String?) async -> Any {
        let lightMap = LightMap(input ?? "")
        return await lightMap.findBestTrace()
    }
}
