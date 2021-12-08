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
    var stars = 1

    struct SegmentedDisplay {
        let signalPatterns: [String]    // should be 10
        let outputValues: [String]      // should be 4

        static func parse(_ input: String) -> SegmentedDisplay? {
            let pieces = input.split(separator: " ").map(String.init)
            guard let pipeIdx = pieces.firstIndex(of: "|") else { return nil }
            let patterns = Array(pieces.prefix(upTo: pipeIdx))
            let values = Array(pieces.suffix(from: pipeIdx+1))
            guard values.count == 4 else { return nil }

            return SegmentedDisplay(signalPatterns: patterns, outputValues: values)
        }
    }

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
        Int.min
    }
}
