//
//  Day7_2025.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/7/25.
//

import Foundation

struct Day7_2025: AdventDay {
    var year = 2025
    var dayNumber = 7
    var dayTitle = "Laboratories"
    var stars = 1

    func partOne(input: String?) -> Any {
        guard let map = TeleportMap.parse(input: input) else { return 0 }
        return map.traceTachyons()
    }

    func partTwo(input: String?) async -> Any {
        guard let map = TeleportMap.parse(input: input) else { return 0 }
        return await map.findPathCount()
    }
}
