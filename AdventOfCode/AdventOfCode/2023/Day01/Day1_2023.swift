//
//  Day1_2023.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/1/23.
//

import Foundation
import RegexBuilder

struct Day1_2023: AdventDay {
    var year = 2023
    var dayNumber = 1
    var dayTitle = "Trebuchet?!"
    var stars = 2

    enum Day1Error: Error {
        case invalidInput
    }

    func parse(_ input: String?, translate: Bool = false) -> [[Int]] {
        (input ?? "").split(separator: "\n").map { line in
            var inputString = String(line)
            var numbers: [Int] = []

            if translate {
                let mapping = [
                    "one": "1",
                    "two": "2",
                    "three": "3",
                    "four": "4",
                    "five": "5",
                    "six": "6",
                    "seven": "7",
                    "eight": "8",
                    "nine": "9",
                ]

                let regex = /(1|2|3|4|5|6|7|8|9|one|two|three|four|five|six|seven|eight|nine)/
                var matches: [String] = []
                // alternate approach (seen online) reverse string, have reverse spellings in regex, match first.
                while let match = inputString.firstMatch(of: regex) {
                    matches.append(String(match.output.1))

                    let nextIdx = inputString.index(after: match.range.lowerBound)
                    inputString = String(inputString.suffix(from: nextIdx))
                }

                numbers = matches.compactMap {
                    Int($0) ?? Int(mapping[$0] ?? "") ?? nil
                }
            } else {
                numbers = inputString.compactMap { Int(String($0)) }
            }

            return [numbers.first, numbers.last].compactMap { $0 }
        }
    }

    func partOne(input: String?) -> Any {
        parse(input).compactMap { line -> Int? in
            guard let first = line.first, let last = line.last else { return nil }
            return (first * 10) + last
        }.reduce(0, +)
    }

    func partTwo(input: String?) -> Any {
        parse(input, translate: true).enumerated().compactMap { (idx, line) -> Int? in
            guard let first = line.first, let last = line.last else { return nil }
            return (first * 10) + last
        }.reduce(0, +)
    }
}
