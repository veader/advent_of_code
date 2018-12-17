//
//  DayFourteen.swift
//  AdventOfCode2018
//
//  Created by Shawn Veader on 12/17/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import Foundation

struct DayFourteen: AdventDay {
    var dayNumber: Int = 14

    struct RecipesScoreboard {
        var scores: [Int]
        var firstIndex: Int
        var secondIndex: Int
        var iterations: Int

        init() {
            scores = [3, 7]
            firstIndex = 0
            secondIndex = 1
            iterations = 0
        }

        mutating func generateRecipes(count: Int) {
            while scores.count < count + 1 {
                generateRecipes()
            }
        }

        mutating func generateRecipes() {
            let firstValue = scores[firstIndex]
            let secondValue = scores[secondIndex]
            let newScore = firstValue + secondValue

            if newScore > 9 {
                scores.append(newScore / 10) // first digit
                scores.append(newScore % 10) // second digit
            } else {
                scores.append(newScore)
            }

            moveIndex(first: true, offset: firstValue + 1)
            moveIndex(first: false, offset: secondValue + 1)
        }

        mutating func moveIndex(first: Bool, offset: Int) {
            let index = first ? firstIndex : secondIndex
            let adjustedIndex = index + offset
            var newIndex = adjustedIndex

            if adjustedIndex >= scores.count { // too big, wrap around
                newIndex = adjustedIndex % scores.count
            }

            if first {
                firstIndex = newIndex
            } else {
                secondIndex = newIndex
            }
        }

        func scores(offset: Int, count: Int = 10) -> [Int]? {
            guard offset + count < scores.count else { return nil }
            return Array(scores[offset ..< (offset+count)])
        }
    }

    @discardableResult func run(_ input: String? = nil, _ part: Int? = 1) -> Any {
        if part == 1 {
            let answer = partOne()
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        } else {
            return 0
//            let answer = partTwo()
//            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
//            return answer
        }
    }

    func partOne() -> String {
        let count = 607331
        var scoreboard = RecipesScoreboard()
        scoreboard.generateRecipes(count: count + 10)

        guard let scores = scoreboard.scores(offset: count) else {
            print("Unable to get scores offset by \(count)")
            return ""
        }

        return scores.compactMap(String.init).joined()
    }
}
