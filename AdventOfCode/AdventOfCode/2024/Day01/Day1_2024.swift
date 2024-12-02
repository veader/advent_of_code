//
//  Day1_2024.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/2/24.
//

import Foundation

import Foundation
import RegexBuilder

struct Day1_2024: AdventDay {
    var year = 2024
    var dayNumber = 1
    var dayTitle = "Historian Hysteria"
    var stars = 2

    enum Day1Error: Error {
        case invalidInput
    }

    func parse(_ input: String?) throws -> (left: [Int], right: [Int]) {
        var leftColumn = [Int]()
        var rightColumn = [Int]()

        try (input ?? "").split(separator: "\n").forEach { line in
            let nums = line.replacing(/\s+/, with: " ").split(separator: " ").map(String.init).compactMap(Int.init)
            guard nums.count == 2 else {
                throw Day1Error.invalidInput
            }

            leftColumn.append(nums[0])
            rightColumn.append(nums[1])
        }

        return (leftColumn.sorted(), rightColumn.sorted())
    }

    func partOne(input: String?) -> Any {
        let columns = try? parse(input)
        guard let columns, columns.left.count == columns.right.count else {
            print("Bad input")
            return -1
        }

        return (0..<columns.left.count).map { idx in
            abs(columns.left[idx] - columns.right[idx])
        }.reduce(0, +)
    }

    func partTwo(input: String?) -> Any {
        let columns = try? parse(input)
        guard let columns, columns.left.count == columns.right.count else {
            print("Bad input")
            return -1
        }

        return columns.left.map { left in
            let count = columns.right.count { $0 == left }
            return left * count
        }.reduce(0, +)
    }
}
