//
//  DayFive2021.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/5/21.
//

import Foundation

struct DayFive2021: AdventDay {
    var year = 2021
    var dayNumber = 5
    var dayTitle = "Hydrothermal Venture"
    var stars = 1

    func parse(_ input: String?) -> [Line] {
        (input ?? "").split(separator: "\n").map(String.init).compactMap { Line.parse($0) }
    }

    func partOne(input: String?) -> Any {
        let floor = OceanFloor(lines: parse(input))
        print(floor)
        return floor.overlapPoints().count
    }

    func partTwo(input: String?) -> Any {
        return Int.min
    }
}
