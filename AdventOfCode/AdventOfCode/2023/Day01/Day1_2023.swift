//
//  Day1_2023.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/1/23.
//

import Foundation

struct Day1_2023: AdventDay {
    var year = 2023
    var dayNumber = 1
    var dayTitle = "Trebuchet?!"
    var stars = 1

    func parse(_ input: String?) -> [[Int]] {
        (input ?? "").split(separator: "\n").map { line in
            String(line).unicodeScalars.compactMap { char in
                CharacterSet.decimalDigits.contains(char) ? Int(String(char)) : nil
            }
        } 
    }

    func partOne(input: String?) -> Any {
        let numbers = parse(input)
        return numbers.compactMap { line -> Int? in
            guard let first = line.first, let last = line.last else { return nil }
            return (first * 10) + last
        }.reduce(0, +)
    }

    func partTwo(input: String?) -> Any {
        0
    }
}
