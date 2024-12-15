//
//  Day13_2024.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/13/24.
//

import Foundation
import RegexBuilder
import Algorithms

struct Day13_2024: AdventDay {
    var year = 2024
    var dayNumber = 13
    var dayTitle = "Claw Contraption"
    var stars = 1

    func parse(_ input: String?, extra: Int = 0) -> [ClawMachine] {
        (input ?? "").lines().chunks(ofCount: 3).compactMap { chunk in
            try? ClawMachine(input: chunk.map { String($0) }, extra: extra)
        }
    }

    func partOne(input: String?) -> Any {
        let machines = parse(input)
        let tokens = play(machines: machines)
        return tokens
    }

    func partTwo(input: String?) -> Any {
        return 0
//        let machines = parse(input, extra: 10_000_000_000_000)
//        let tokens = play(machines: machines)
//        return tokens
    }

    /// Determine which machines are winnable and how many tokens are required to win at each.
    func play(machines: [ClawMachine]) -> Int {
        var totals: Int = 0
        for machine in machines {
            let winners = ClawGameWinners(machine: machine)
            let tokens = searchDeep(machine: machine, winners: winners)
            if tokens != .max {
                totals += tokens
            }
        }
        return totals
    }

    func searchDeep(machine: ClawMachine, winners: ClawGameWinners, a: Int = 0, b: Int = 0) -> Int {
        // confirm we haven't considered this combination before...
        guard !winners.hasConsidered(buttonPushes: ClawGameWinners.ButtonPushes(x: a, y: b)) else { return .max }

        // mark that we've considered this
        winners.consider(buttonPushes: ClawGameWinners.ButtonPushes(x: a, y: b))

        let position = calcPosition(machine: machine, a: a, b: b)
        let tokens = a * 3 + b

        if position == machine.prize {
            // we have a winner!
            winners.add(winner: ClawGameWinners.Winner(x: a, y: b))

            if winners.fewestTokens > tokens {
                winners.fewestTokens = tokens
            }

            return tokens
        } else if position.x > machine.prize.x || position.y > machine.prize.y {
            // we've gone too far, this isn't a winner
            return .max
        } else if tokens > winners.fewestTokens {
            // this route is too expensive, abort... (does avoid finding a potential route)
            return .max
        } else {
            let aTokens = searchDeep(machine: machine, winners: winners, a: a + 1, b: b)
            let bTokens = searchDeep(machine: machine, winners: winners, a: a, b: b + 1)

            return min(aTokens, bTokens)
        }
    }

    private func calcPosition(machine: ClawMachine, a:Int , b: Int) -> Coordinate {
        return Coordinate(x: machine.buttonA.x * a + machine.buttonB.x * b,
                          y: machine.buttonA.y * a + machine.buttonB.y * b)
    }
}

class ClawGameWinners {
    // co-opting Coordinate to store our A/B values...
    typealias Winner = Coordinate
    typealias ButtonPushes = Coordinate

    let machine: ClawMachine
    var winners: Set<Winner> = []
    var considered: Set<ButtonPushes> = []
    var fewestTokens: Int = .max

    init(machine: ClawMachine) {
        self.machine = machine
    }

    func consider(buttonPushes: ButtonPushes) {
        considered.insert(buttonPushes)
    }

    func hasConsidered(buttonPushes: ButtonPushes) -> Bool {
        considered.contains(buttonPushes)
    }

    func add(winner: Winner) {
        winners.insert(winner)
    }
}
