//
//  DayNine.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/9/20.
//

import Foundation

struct DayNine2020: AdventDay {
    var year = 2020
    var dayNumber = 9
    var dayTitle = "Encoding Error"
    var stars = 2

    func parse(_ input: String?) -> [Int] {
        (input ?? "").split(separator: "\n").map(String.init).compactMap(Int.init)
    }

    func partOne(input: String?) -> Any {
        let data = parse(input)
        let cypher = XMASCypher(preamble: 25, data: data)
        return cypher.findWeakness()
    }

    func partTwo(input: String?) -> Any {
        let data = parse(input)
        let cypher = XMASCypher(preamble: 25, data: data)
        let weaknessTarget = cypher.findWeakness()
        let weakness = cypher.findWeaknessRange(target: weaknessTarget)

        if let min = weakness?.min(), let max = weakness?.max() {
            return min + max
        } else {
            return -1
        }
    }
}
