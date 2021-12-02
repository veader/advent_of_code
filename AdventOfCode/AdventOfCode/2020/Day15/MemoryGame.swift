//
//  MemoryGame.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/15/20.
//

import Foundation

class MemoryGame {
    /// Numbers that have been played in order of play
    var numbers: [Int]

    /// Last number played
    var lastNumberPlayed: Int

    /// A number lookup dictionary. Key is the number, the value is a collection of indicies.
    var numberLookup: [Int: [Int]]

    init(initial: [Int]) {
        numbers = initial
        numberLookup = [Int: [Int]]()
        lastNumberPlayed = numbers.last ?? 0

        for (turn, num) in numbers.enumerated() {
            record(num: num, on: turn + 1)
        }
    }

    func play(turnCount: Int = 2020, optimized: Bool = false) {
        var turn = numbers.count + 1 // ie: if we start with 3 initial numbers, the first "turn" is 4th

        while turn <= turnCount {
            let value = lastNumberPlayed
            let indices = numberLookup[value] ?? []

            var insertValue: Int

            switch indices.count {
            case 0:
                print("*** Huh? \(value) was never spoken before?")
                continue
            case 1:
                // number has only been spoken once, we return 0
                insertValue = 0
            case 2:
                // number has been spoken at least twice, subtract the last two
                let lastTwo = indices.suffix(2).reversed()
                insertValue = (lastTwo.first ?? 0) - (lastTwo.last ?? 0)
            default:
                print("** Huh? We have \(indices.count) indices for \(value)")
                continue
            }

            if !optimized {
                numbers.append(insertValue)
            }
            lastNumberPlayed = insertValue
            record(num: insertValue, on: turn)

            turn += 1 // move to next turn
        }
    }

    /// Record the turn on which the number was spoken.
    ///
    /// - Note: turn is 1-based, *not* 0-based
    private func record(num: Int, on turn: Int) {
        let previousIndicies: [Int] = numberLookup[num] ?? []

        // we only need the last two possible indicies/turns
        let indicies = [previousIndicies.last, turn].compactMap({$0}).sorted()

        // print("Record: \(num) was spoken on turn \(turn): \(indices)")
        numberLookup[num] = indicies
    }
}
