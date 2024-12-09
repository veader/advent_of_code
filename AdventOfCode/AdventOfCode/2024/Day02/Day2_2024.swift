//
//  Day2_2024.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/2/24.
//

import Foundation

struct Day2_2024: AdventDay {
    var year = 2024
    var dayNumber = 2
    var dayTitle = "Red-Nosed Reports"
    var stars = 2

    enum Day1Error: Error {
        case invalidInput
    }

    func parse(_ input: String?) -> [[Int]] {
        (input ?? "").lines().map { line -> [Int] in
            line.split(separator: " ").map(String.init).compactMap(Int.init)
        }
    }

    enum LevelDirection {
        case unknown
        case increasing
        case decreasing
    }

    /// Determine the safety of a level given our rule set...
    func safetyCheck(level: [Int]) -> Bool {
        guard level.count > 1, let firstValue = level.first else { return true } // must be safe it it only has 1 value
        var previousValue = firstValue
        var idx = 1 // start on second value...
        var direction: LevelDirection = .unknown

        while idx < level.count {
            let value = level[idx]

            if value == previousValue {
                return false // neither increasing or decreasing
            } else if value > previousValue {
                let delta = value - previousValue
                // increasing value when previously decreasing
                guard direction != .decreasing else { return false }
                guard (1...3).contains(delta) else { return false }

                if case .unknown = direction {
                    direction = .increasing
                }
                previousValue = value
            } else {
                let delta = previousValue - value
                // decreasing value when previously increasing
                guard direction != .increasing else { return false }
                guard (1...3).contains(delta) else { return false }

                if case .unknown = direction {
                    direction = .decreasing
                }
                previousValue = value
            }

            idx += 1
        }

        return true // safety conditions met
    }

    /// Determine the safety of a level given our rule set... by using deltas
    func safetyCheckDeltas(level: [Int]) -> Bool {
        // calculate the deltas between each value...
        let deltas = level.enumerated().compactMap { idx, value -> Int? in
            guard idx > 0 else { return nil } // skip first one
            let previous = level[level.index(before: idx)]
            return previous - value
        }

        guard deltas.count == level.count - 1 else { print("error calculating deltas..."); return false }

        if deltas.contains(where: { !(1...3).contains(abs($0)) }) {
            // confirm no delta is out of the 1-3 range
            print("delta out of bounds: \(deltas)")
            return false
        } else if let first = deltas.first, first > 0, deltas.contains(where: { $0 < 0 }) {
            // confirm positive deltas stay positive
            print("direction change (+ to -): \(deltas)")
            return false
        } else if let first = deltas.first, first < 0, deltas.contains(where: { $0 > 0 }) {
            // confirm negative deltas stay negative
            print("direction change (- to +): \(deltas)")
            return false
        }

        return true
    }

    /// Given an unsafe level, determine if removing one of the values can make it safe...
    func possiblySafe(level: [Int]) -> Bool {
        // if we're safe already, no need to check further...
        guard !safetyCheck(level: level) else { return true }

        for idx in level.indices {
            // create new level removing element at the given index
            let newLevel = level.enumerated().filter({ $0.offset != idx }).map({ $0.element })
//            let newLevel = level.prefix(upTo: idx) + (level.count > idx ? level.suffix(from: level.index(after: idx)) : [])
            if safetyCheck(level: newLevel) {
                return true
            }
        }
        return false
    }

    func partOne(input: String?) -> Any {
        let levels = parse(input)
        return levels.count(where: safetyCheck)
        // return levels.count(where: safetyCheckDeltas)
    }

    func partTwo(input: String?) -> Any {
        let levels = parse(input)
        return levels.count(where: possiblySafe)
    }
}
