//
//  DayEight2021.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/8/21.
//

import Foundation

struct DayEight2021: AdventDay {
    var year = 2021
    var dayNumber = 8
    var dayTitle = "Seven Segment Search"
    var stars = 2

    func parse(_ input: String?) -> [SegmentedDisplay] {
        (input ?? "").split(separator: "\n").map(String.init).compactMap { SegmentedDisplay.parse($0) }
    }

    func countEasyValues(displays: [SegmentedDisplay]) -> Int {
        let outputValues = displays.flatMap { $0.outputValues }
        let easyValues = outputValues.filter { [2,3,4,7].contains($0.count) }
        return easyValues.count
    }

    func partOne(input: String?) -> Any {
        let displays = parse(input)
        return countEasyValues(displays: displays)
    }

    func partTwo(input: String?) -> Any {
        let displays = parse(input)
        return displays.map(\.finalOutput).reduce(0, +)
    }
}
