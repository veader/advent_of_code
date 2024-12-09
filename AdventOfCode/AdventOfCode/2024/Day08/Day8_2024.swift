//
//  Day8_2024.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/8/24.
//

import Foundation

struct Day8_2024: AdventDay {
    var year = 2024
    var dayNumber = 8
    var dayTitle = "Resonant Collinearity"
    var stars = 1

    func parse(_ input: String?) -> AntennaMap {
        let mapData: [[String]] = (input ?? "").lines().map { $0.map(String.init) }
        let map = GridMap(items: mapData)
        return AntennaMap(map: map)
    }

    func partOne(input: String?) -> Any {
        let map = parse(input)
        return map.findAntinodes().count
    }

    func partTwo(input: String?) -> Any {
        let map = parse(input)
        return 0
    }
}
