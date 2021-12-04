//
//  DayFour2021.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/4/21.
//

import Foundation

struct DayFour2021: AdventDay {
    var year = 2021
    var dayNumber = 4
    var dayTitle = "Giant Squid"
    var stars = 1

    func parse(_ input: String?) -> BingoGame? {
        guard let input = input else { return nil }
        return BingoGame.parse(input)
    }

    func partOne(input: String?) -> Any {
        guard let game = parse(input) else { return Int.min }
        game.play()
        return game.finalScore
    }

    func partTwo(input: String?) -> Any {
        guard let game = parse(input) else { return Int.min }
        game.play()
        return Int.min
    }
}
