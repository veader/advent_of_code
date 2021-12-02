//
//  DayTwentyTwo.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/24/20.
//

import Foundation

struct DayTwentyTwo2020: AdventDay {
    var year = 2020
    var dayNumber = 22
    var dayTitle = "Crab Combat"
    var stars = 1

    func parse(_ input: String?) -> CombatGame {
        CombatGame(input ?? "")
    }

    func partOne(input: String?) -> Any {
        let game = parse(input)
        game.play()
        return game.finalScore()
    }

    func partTwo(input: String?) -> Any {
        // let game = parse(input)
        return -1
    }
}
