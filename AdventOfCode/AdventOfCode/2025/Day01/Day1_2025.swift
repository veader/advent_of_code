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
            let startValue = value
            value = step.result(from: value)

            // before counting one of the zeros we "pass", see if we were already sitting there...

            // adjust for going around the dial
            if value < 0 {
                let delta = abs(100 + value)
                value = delta % 100

                // count how many times we passed 0 while spinning
                var passCount = Int(step.amount / 100) + 1
                if value == 0 || startValue == 0 { passCount -= 1 }
                zeroPassCount += passCount

//                var passCount = Int(delta / 100) + 1
//                if startValue == 0 { passCount -= 1 }
//                if value == 0 { passCount -= 1 }
//                zeroPassCount += passCount

                print("\(delta) \(passCount) \(value) - under")
            } else if value > 99 {
                let delta = abs(value - 100)
                value = delta % 100

                // count how many times we passed 0 while spinning
                var passCount = Int(step.amount / 100) + 1
                if value == 0 || startValue == 0 { passCount -= 1 }
                zeroPassCount += passCount

//                var passCount = Int(step.amount / 100) + 1
//                if startValue == 0 { passCount -= 1 }
//                if value == 0 { passCount -= 1 }
//                zeroPassCount += passCount

                print("\(delta) \(passCount) \(value) - over")
            }

            print("After \(step) -> \(value)")
            if value == 0 {
                zeroCount += 1
            }
        }

        return (zeroCount, zeroPassCount)
    }
}
