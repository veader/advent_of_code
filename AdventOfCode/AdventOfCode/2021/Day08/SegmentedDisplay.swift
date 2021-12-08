//
//  SegmentedDisplay.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/8/21.
//

import Foundation

struct SegmentedDisplay {
    static let originalPatterns = [
        "abcefg": 0,
        "cf": 1,
        "acdeg": 2,
        "acdfg": 3,
        "bcdf": 4,
        "abdfg": 5,
        "abdefg": 6,
        "acf": 7,
        "abcdefg": 8,
        "abcdfg": 9,
    ]


    let patterns: [String]      // should be 10
    let outputValues: [String]  // should be 4
    let map: [String: Int]

    init(patterns: [String], outputValues: [String]) {
        self.patterns = patterns
        self.outputValues = outputValues
        map = SegmentedDisplay.buildMap(patterns: patterns)
    }

    /// Final output by mapping outputValues to real 4 digit numbers
    var finalOutput: Int {
        [1000, 100, 10, 1].enumerated().reduce(0) { sum, iterator in
            let value = outputValues[iterator.offset].sortedString()
            return sum + (map[value] ?? 0) * iterator.element
        }
    }

    static func buildMap(patterns: [String]) -> [String: Int] {
        var segmentMap = [String: String]()     // key is new A -> G, value is original A -> G
        var lengthMap = [Int: [Set<String>]]()  // key is length of strings in values

        patterns.forEach { p in
            lengthMap[p.count] = (lengthMap[p.count] ?? []) + [Set<String>(p.map(String.init))]
        }

        let one = lengthMap[2]!.first!
        let seven = lengthMap[3]!.first!
        let four = lengthMap[4]!.first!
        let eight = lengthMap[7]!.first!

        let fivers = lengthMap[5]!
        let sixes = lengthMap[6]!

        // =======================

        let bdSegments = four.subtracting(one)
        let egSegments = eight.subtracting(seven.union(four))
        let horizontalSegments = fivers.reduce(Set<String>(eight)) { $0.intersection($1) }
        let commonSixes = sixes.reduce(Set<String>(eight)) { $0.intersection($1) }
        let agSegments = commonSixes.intersection(horizontalSegments)

        // =======================

        let aSegment = seven.subtracting(one)
        segmentMap[aSegment.first!] = "a"

        let gSegment = agSegments.subtracting(aSegment)
        segmentMap[gSegment.first!] = "g"

        let dSegment = horizontalSegments.subtracting(aSegment).subtracting(gSegment)
        segmentMap[dSegment.first!] = "d"

        let fSegment = commonSixes.intersection(one)
        segmentMap[fSegment.first!] = "f"

        let cSegment = one.subtracting(fSegment)
        segmentMap[cSegment.first!] = "c"

        let eSegment = egSegments.subtracting(gSegment)
        segmentMap[eSegment.first!] = "e"

        let bSegment = bdSegments.subtracting(dSegment)
        segmentMap[bSegment.first!] = "b"

//        print("==============")
//        print(segmentMap)

        // =======================

        var mapping = [String: Int]() // key is sorted version of a pattern
        patterns.forEach { pat in
            let sortedPattern = pat.sortedString()
            let segments = sortedPattern.compactMap(String.init).map({ segmentMap[$0]! }).sorted().joined()
            mapping[sortedPattern] = SegmentedDisplay.originalPatterns[segments]
        }

//        print("==============")
//        print(mapping)

        return mapping
    }

    static func parse(_ input: String) -> SegmentedDisplay? {
        let pieces = input.split(separator: " ").map(String.init)
        guard let pipeIdx = pieces.firstIndex(of: "|") else { return nil }
        let patterns = Array(pieces.prefix(upTo: pipeIdx))
        let values = Array(pieces.suffix(from: pipeIdx+1))
        guard values.count == 4 else { return nil }

        return SegmentedDisplay(patterns: patterns, outputValues: values)
    }
}
