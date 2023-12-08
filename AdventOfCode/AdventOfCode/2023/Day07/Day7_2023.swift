//
//  Day7_2023.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/7/23.
//

import Foundation

struct Day7_2023: AdventDay {
    var year = 2023
    var dayNumber = 7
    var dayTitle = "Camel Cards"
    var stars = 2

    func partOne(input: String?) -> Any {
        let cards = CamelCards.parse(input ?? "")
        let sorted = cards.sortedRounds
        let values = sorted.enumerated().map { $0.element.bid * ($0.offset + 1) }
        return values.reduce(0, +)
    }

    func partTwo(input: String?) -> Any {
        let cards = CamelCards.parse(input ?? "", useJokers: true)
        let sorted = cards.sortedRounds
        let values = sorted.enumerated().map { $0.element.bid * ($0.offset + 1) }
        return values.reduce(0, +)
    }

}
