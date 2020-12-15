//
//  MemoryGame.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/15/20.
//

import Foundation

class MemoryGame {
    var numbers: [Int]

    /// A number lookup dictionary. Key is the number, the value is a collection of indicies.
    var numberLookup: [Int: [Int]]

    init(initial: [Int]) {
        numbers = initial
        numberLookup = [Int: [Int]]()

        for (turn, num) in numbers.enumerated() {
            record(num: num, on: turn + 1)
        }
    }

    func play(turnCount: Int = 2020) {
        var turn = numbers.count + 1 // ie: if we start with 3 initial numbers, the first "turn" is 4th

        while turn <= turnCount {
            guard let value = numbers.last else { exit(-1) }
            let indices = numberLookup[value] ?? []

            var insertValue: Int

            if indices.count == 1 {
                // number has only been spoken once, we return 0
                insertValue = 0
            } else if indices.count == 0 {
                print("*** Huh? \(value) was never spoken before?")
                continue
            } else {
                // number has been spoken at least twice, subtract the last two
                let lastTwo = indices.suffix(2).reversed()
                insertValue = (lastTwo.first ?? 0) - (lastTwo.last ?? 0)
            }

            numbers.append(insertValue)
            record(num: insertValue, on: turn)

            turn += 1 // move to next turn
        }
    }

    /// Record the turn on which the number was spoken.
    ///
    /// - Note: turn is 1-based, *not* 0-based
    private func record(num: Int, on turn: Int) {
        var indices: [Int] = numberLookup[num] ?? []
        indices.append(turn)
        // print("Record: \(num) was spoken on turn \(turn): \(indices)")
        numberLookup[num] = indices.sorted()
    }
}
