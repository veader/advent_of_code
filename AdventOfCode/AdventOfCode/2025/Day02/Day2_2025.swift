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
    var stars = 2

    func parse(_ input: String?) -> [ClosedRange<Int>] {
        (input ?? "").split(separator: ",").compactMap { rangeStr in
            let numbers = rangeStr.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "-").map(String.init).compactMap(Int.init)
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
        var result = 0
        for range in ranges {
            let invalid = complexScan(range: range)
            result = invalid.reduce(result, +)
        }
        return result
    }

    /// Scan a given closed range for invalid IDs.
    ///
    /// Invalid IDs are defined as numbers which are a number (of any length) repeated twice.
    /// Examples: `55`, `6464`, `123123`, etc
    func scanForInvalidIDs(_ range: ClosedRange<Int>) -> [Int] {
        range.compactMap { i in
            guard isInvalidHalving(i) else { return nil }
            return i
        }
    }

    /// Simple case for invalid ID where splitting an `Int` (as `String`) in half matches
    func isInvalidHalving(_ input: Int) -> Bool {
        let str = String(input)
        guard str.count % 2 == 0 else { return false }
        let halfSize = str.count / 2
        let front = str.prefix(halfSize)
        let end = str.suffix(halfSize)
        guard front == end else { return false }
        return true
    }

    /// Scan a given closed range for invalid IDs.
    ///
    /// Invalid IDs are defined as numbers which are a number (of any length) repeated for the duration of the string.
    /// Examples: `12341234`, `123123123`, `1212121212`
    func complexScan(range: ClosedRange<Int>) -> [Int] {
        range.compactMap { i in
            guard isInvalidSubSequence(i) else { return nil }
            return i
        }
    }

    /// Determine if `Int` (as `String`) is an invalid ID made up of a repeating sub-sequence
    func isInvalidSubSequence(_ input: Int) -> Bool {
        let str = String(input)

        var subLen = 1
        while subLen < str.count {
            // <= (str.count / 2) { // anything over half the length won't work
            // we should be able to cleanly subdivide str into substrings of this length
            if str.count % subLen == 0 {
                // more efficient way?
                let prefix = str.prefix(subLen)
                let multiplesToFill = str.count / subLen
                if multiplesToFill > 1 {
                    let match = Array(repeating: prefix, count: multiplesToFill).joined()
                    if str == match {
                        return true
                    }
                }
                // more clever way?
                // let subs = str.subStrings(length: subLen)
                // if subs.unique().count == 1 {
                //     return true
                // }
            }
            subLen += 1
        }

        return false
    }
}

extension String {
    func subStrings(length: Int) -> [String] {
        indices.striding(by: length).compactMap { idx -> String? in
            guard let idxEnd = index(idx, offsetBy: length, limitedBy: endIndex) else { return nil }
            return String(self[idx..<idxEnd])
        }
    }
}
//
//import Playgrounds
//
//#Playground {
//    let str = "123412341234"
//    let strideIndices = str.indices.striding(by: 2)
//    let substrings = strideIndices.map { idx in
//        str[idx..<str.index(idx, offsetBy: 2)]
//    }
//
//    str.subStrings(length: 2)
//}
