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
    var stars = 2

    enum Day1Error: Error {
        case invalidInput
    }

    func parse(_ input: String?) -> [CombinationStep] {
        (input ?? "").lines().compactMap { line in
            CombinationStep.parse(line)
        }
    }

    func partOne(input: String?) -> Any {
        let steps = parse(input)
        let answer = rotate(steps: steps)
        return answer.0
    }

    func partTwo(input: String?) -> Any {
        let steps = parse(input)
        let answer = rotate(steps: steps)
        return answer.0 + answer.1
    }

    private func rotate(steps: [CombinationStep]) -> (Int, Int) {
        var zeroCount = 0 // number of times we see 0
        var zeroPassCount = 0 // number of times we pass 0 along the way
        var value = 50 // starting value

        for step in steps {
            let amount = step.amount % 100

            var newValue = 0
            switch step {
            case .left(_):
                newValue = value - amount
            case .right(_):
                newValue = value + amount
            }

            if newValue < 0 {
                if value != 0 { // starting at 0
                    zeroPassCount += 1 // passed the boundary at least once
                }

                value = 100 + newValue
            } else if newValue > 99 {
                value = newValue - 100

                if value != 0 { // ending at 0
                    zeroPassCount += 1 // passed the boundary at least once
                }
            } else {
                value = newValue
            }

            // Other passes may have occured if the step amount exceeded the 0-99 range
            zeroPassCount += Int(step.amount / 100)

            // did we end on zero?
            if value == 0 {
                zeroCount += 1
            }

//            print("After \(step) -> \(value) | \(zeroCount) \(zeroPassCount)")
        }

        return (zeroCount, zeroPassCount)
    }
}

