//
//  Day11_2024.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/11/24.
//

import Foundation

struct Day11_2024: AdventDay {
    var year = 2024
    var dayNumber = 11
    var dayTitle = "Plutonian Pebbles"
    var stars = 1

    func parse(_ input: String?) -> Pebbles {
        Pebbles(stones: (input ?? "").trimmingCharacters(in: .whitespacesAndNewlines).split(separator: " ").map(String.init).compactMap(Int.init))
    }

    func partOne(input: String?) async-> Any {
        let pebbles = parse(input)
        await pebbles.blink(iterations: 25)
        return pebbles.count
    }

    func partTwo(input: String?) async -> Any {
        return 0
//        let pebbles = parse(input)
//        return pebbles.stoneCount(after: 75)
    }
}
