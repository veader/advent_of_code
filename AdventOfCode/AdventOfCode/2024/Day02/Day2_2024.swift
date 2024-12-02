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
    var stars = 1

    enum Day1Error: Error {
        case invalidInput
    }

    func parse(_ input: String?) -> [[Int]] {
        (input ?? "").split(separator: "\n").map { line -> [Int] in
            line.split(separator: " ").map(String.init).compactMap(Int.init)
        }
    }

    enum LevelDirection {
        case unknown
        case increasing
        case decreasing
    }

    func safetyCheck(level: [Int]) -> Bool {
        guard level.count > 1, let firstValue = level.first else { return true } // must be safe it it only has 1 value
        var previousValue = firstValue
        var idx = 1 // start on second value...
        var direction: LevelDirection = .unknown

        while idx < level.count {
            let value = level[idx]

            if value == previousValue {
                //print("\(value) == \(previousValue) @ \(idx)")
                return false // neither increasing or decreasing
            } else if value > previousValue {
                let delta = value - previousValue
                //print("\(value) > \(previousValue) : \(delta) @ \(idx)")
                // increasing value when previously decreasing
                guard direction != .decreasing else { print("direction change"); return false }
                guard (1...3).contains(delta) else { print("increase too big"); return false }

                if case .unknown = direction {
                    direction = .increasing
                }
                previousValue = value
            } else {
                let delta = previousValue - value
                //print("\(value) < \(previousValue) : \(delta) @ \(idx)")
                // decreasing value when previously increasing
                guard direction != .increasing else { print("direction change"); return false }
                guard (1...3).contains(delta) else { print("decrease too big"); return false }

                if case .unknown = direction {
                    direction = .decreasing
                }
                previousValue = value
            }

            idx += 1
        }

        return true // safety conditions met
    }

    func partOne(input: String?) -> Any {
        let levels = parse(input)
        return levels.count(where: safetyCheck)
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
