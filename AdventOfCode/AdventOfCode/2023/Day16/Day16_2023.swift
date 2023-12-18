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
    var stars = 1

    func partOne(input: String?) async -> Any {
        let lightMap = LightMap(input ?? "")
        await lightMap.traceLight()
        return lightMap.energizedPoints.count
    }

    func partTwo(input: String?) async -> Any {
        return 0
    }
}
