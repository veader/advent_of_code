//
//  Day4_2023.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/4/23.
//

import Foundation
import RegexBuilder

struct Day4_2023: AdventDay {
    var year = 2023
    var dayNumber = 4
    var dayTitle = "Scratchcards"
    var stars = 1

    struct Scratchcard: Identifiable {
        let id: Int
        let winning: Set<Int>
        let numbers: Set<Int>

        var winningMatches: [Int] {
            winning.intersection(numbers).sorted()
        }

        static func parse(_ input: String) -> Scratchcard? {
            var input = input
            // Example: Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53

            guard
                let cardMatch = input.firstMatch(of: /Card\s+(\d+):\s+/),
                let cardNum = Int(cardMatch.output.1)
            else { return nil }

            input = String(input.suffix(from: cardMatch.range.upperBound))
            let chunks = input.split(separator: " | ").map(String.init)
            guard chunks.count == 2 else { return nil }

            let winning = chunks[0].split(separator: " ").map(String.init).compactMap(Int.init)
            let numbers = chunks[1].split(separator: " ").map(String.init).compactMap(Int.init)

            return Scratchcard(id: cardNum, winning: Set(winning), numbers: Set(numbers))
        }
    }

    func parse(_ input: String?, translate: Bool = false) -> [Scratchcard] {
        (input ?? "").split(separator: "\n").map(String.init).compactMap { Scratchcard.parse($0) }
    }

    func partOne(input: String?) -> Any {
        let cards = parse(input)
        let winning = cards.filter { !$0.winningMatches.isEmpty }
        let powers = winning.map { 2.power(of: $0.winningMatches.count - 1) }.map(Int.init)
        return powers.reduce(0, +)
    }

    func partTwo(input: String?) -> Any {
        0
    }
}
