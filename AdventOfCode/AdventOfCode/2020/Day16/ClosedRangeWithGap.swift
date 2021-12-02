//
//  File.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/17/20.
//

import Foundation

struct ClosedRangeWithGap {
    let range: ClosedRange<Int>
    let gapRange: ClosedRange<Int>

    init?(_ ranges: [ClosedRange<Int>]) {
        // find the edges of our range
        guard
            let min = ranges.map({ $0.lowerBound }).min(),
            let max = ranges.map({ $0.upperBound }).max()
            else { return nil }

        range = min...max

        // find the gap
        var totalSet = Set(range)
        for set in ranges.map(Set.init) {
            totalSet.subtract(set)
        }

        guard
            let gapMin = totalSet.min(),
            let gapMax = totalSet.max()
            else { return nil }

        gapRange = gapMin...gapMax
    }

    func contains(_ element: Int) -> Bool {
        range.contains(element) && !gapRange.contains(element)
    }

    func containsAll(_ elements: [Int]) -> Bool {
        let elementCount = Set(elements).count
        let allInCount = Set(range).intersection(Set(elements)).count
        let excludedCount = Set(gapRange).intersection(Set(elements)).count

        return allInCount == elementCount && excludedCount == 0
    }

    func excludedValues(_ elements: [Int]) -> [Int] {
        Array(Set(gapRange).intersection(Set(elements))).sorted()
    }
}

extension ClosedRangeWithGap: CustomDebugStringConvertible {
    var debugDescription: String {
        "<ClosedRangeWithGap: includes: \(range) excludes: \(gapRange)>"
    }
}
