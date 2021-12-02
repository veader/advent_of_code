//
//  DayFifteen.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/15/20.
//

import Foundation

struct DayFifteen2020: AdventDay {
    var year = 2020
    var dayNumber = 15
    var dayTitle = "Rambunctious Recitation"
    var stars = 2

    func parse(_ input: String?) -> [Int] {
        (input ?? "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            .split(separator: ",")
            .map(String.init)
            .compactMap(Int.init)
    }

    func partOne(input: String?) -> Any {
        let initialNumbers = parse(input)
        let game = MemoryGame(initial: initialNumbers)
        game.play()

        return game.lastNumberPlayed
    }

    func partTwo(input: String?) -> Any {
        let initialNumbers = parse(input)
        let game = MemoryGame(initial: initialNumbers)
        game.play(turnCount: 30_000_000, optimized: true)

        return game.lastNumberPlayed
    }
}
