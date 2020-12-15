//
//  DayFifteen.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/15/20.
//

import Foundation

struct DayFifteen: AdventDay {
    var dayNumber: Int = 15

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

        return game.numbers.last ?? -1
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
