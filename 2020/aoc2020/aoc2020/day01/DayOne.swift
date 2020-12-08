//
//  DayOne.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/1/20.
//

import Foundation


struct DayOne: AdventDay {
    var dayNumber: Int = 1

    func parse(_ input: String?) -> [Int] {
        (input ?? "").split(separator: "\n").compactMap { Int($0) }
    }

    func partOne(input: String?) -> Any {
        var matches: [Int]?

        let expenses = parse(input)
        for idx in expenses.indices {
            let expense = expenses[idx]
            let startIdx = expenses.index(after: idx)
            if let otherExpense = expenses[startIdx...].first(where: { $0 + expense == 2020 }) {
                matches = [expense, otherExpense]
                break
            }
        }

        guard let matching = matches else { return 0 }
        print(matching)
        return matching.reduce(1) { $0 * $1 }
    }

    func partTwo(input: String?) -> Any {
        var matches: [Int]?

        let expenses = parse(input)
        for firstIdx in expenses.indices {
            let firstExpense = expenses[firstIdx]

            let possibleIndices = expenses.indices.filter {
                $0 != firstIdx &&
                firstExpense + expenses[$0] <= 2020
            }

            guard possibleIndices.count > 0 else { continue }
//            print("Found \(possibleIndices.count) second choices")
//            print(possibleIndices.map({ expenses[$0] }).map(String.init).joined(separator: ", "))

            for secondIdx in possibleIndices {
                let secondExpense = expenses[secondIdx]

                let finalIndices = expenses.indices.filter {
                    $0 != firstIdx &&
                    $0 != secondIdx &&
                    firstExpense + secondExpense + expenses[$0] == 2020
                }

                guard finalIndices.count > 0 else { continue }
//                print("**** Found \(finalIndices.count) third choices")
//                print(finalIndices.map({ expenses[$0] }).map(String.init).joined(separator: ", "))

                if let thirdIdx = finalIndices.first {
                    let thirdExpense = expenses[thirdIdx]
                    matches = [firstExpense, secondExpense, thirdExpense]
                    break
                }
            }

            guard matches == nil else { break }
        }

        guard let matching = matches else { return 0 }
        print(matching)
        return matching.reduce(1) { $0 * $1 }
    }
}
