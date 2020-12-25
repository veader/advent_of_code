//
//  DayTwentyTwo.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/24/20.
//

import Foundation

struct DayTwentyTwo: AdventDay {
    var dayNumber: Int = 22

    func parse(_ input: String?) -> CombatGame {
        CombatGame(input ?? "")
    }

    func partOne(input: String?) -> Any {
        let game = parse(input)
        game.play()
        return game.finalScore()
    }

    func partTwo(input: String?) -> Any {
        let game = parse(input)
        return -1
    }
}
