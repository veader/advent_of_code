//
//  Day2_2025.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/3/25.
//

import Foundation

struct Day2_2025: AdventDay {
    var year = 2025
    var dayNumber = 2
    var dayTitle = "Gift Shop"
    var stars = 1

    enum Day2Error: Error {
        case invalidInput
    }

    func parse(_ input: String?) -> [ClosedRange<Int>] {
        (input ?? "").split(separator: ",").compactMap { rangeStr in
            let numbers = rangeStr.split(separator: "-").map(String.init).compactMap(Int.init)
            guard numbers.count == 2, let first = numbers.first, let last = numbers.last else { return nil }
            return first...last
        }
    }

    func partOne(input: String?) -> Any {
        let ranges = parse(input)
        var result = 0
        for range in ranges {
            let invalid = scanForInvalidIDs(range)
            result = invalid.reduce(result, +)
        }
        return result
    }

    func partTwo(input: String?) -> Any {
        let ranges = parse(input)
        return 0
    }

    /// Scan a given closed range for invalid IDs.
    ///
    /// Invalid IDs are defined as numbers which are a number (of any length) repeated twice.
    /// Examples: `55`, `6464`, `123123`, etc
    func scanForInvalidIDs(_ range: ClosedRange<Int>) -> [Int] {
        range.compactMap { i in
            let str = String(i)
            guard str.count % 2 == 0 else { return nil }
            let halfSize = str.count / 2
            let front = str.prefix(halfSize)
            let end = str.suffix(halfSize)
            guard front == end else { return nil }
            return i
        }
    }
}

