//
//  Day1_2025.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/2/25.
//

import Foundation

struct Day1_2025: AdventDay {
    var year = 2025
    var dayNumber = 1
    var dayTitle = "Secret Entrance"
    var stars = 1

    enum Day1Error: Error {
        case invalidInput
    }

    func parse(_ input: String?) -> [CombinationStep] {
        (input ?? "").lines().compactMap { line in
            CombinationStep.parse(line)
        }
    }

    func partOne(input: String?) -> Any {
        var zeroCount = 0 // number of times we see 0
        let steps = parse(input)
        print("Steps: \(steps.count)")

        var value = 50 // starting value
        for step in steps {
            value = step.result(from: value)

            // adjust for going around the dial
            if value < 0 {
                value = (100 + value) % 100
            } else if value > 99 {
                value = (value - 100) % 100
            }

            print("After \(step) -> \(value)")
            if value == 0 {
                zeroCount += 1
            }
        }

        return zeroCount
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
