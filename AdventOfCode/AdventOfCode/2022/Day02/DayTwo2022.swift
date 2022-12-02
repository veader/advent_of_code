//
//  DayTwo2022.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/2/22.
//

import Foundation

struct DayTwo2022: AdventDay {
    var year = 2022
    var dayNumber = 2
    var dayTitle = "Rock Paper Scissors"
    var stars = 2

    func parse(_ input: String?) -> [RoshamboRound] {
        (input ?? "").split(separator: "\n").map(String.init).compactMap { RoshamboRound($0) }
    }

    func partOne(input: String?) -> Any {
        let rounds = parse(input)
        return rounds.reduce(0) { $0 + $1.scoreRound() }
    }

    func partTwo(input: String?) -> Any {
        let rounds = parse(input)
        return rounds.reduce(0) { $0 + $1.scoreCalculatedRound() }
    }
}
