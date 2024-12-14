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
    var stars = 0

    func parse(_ input: String?) -> [ClawMachine] {
        (input ?? "").lines().chunks(ofCount: 3).compactMap { chunk in
            try? ClawMachine(input: chunk.map { String($0) })
        }
    }

    func partOne(input: String?) async-> Any {
        let machines = parse(input)
        return 0
    }

    func partTwo(input: String?) async -> Any {
        let machines = parse(input)
        return 0
    }

    /// Determine which machines are winnable and how many tokens are required to win at each.
    func play(machines: [ClawMachine]) async -> Int {
        var totals: Int = 0
        for machine in machines {
            if let tokens = await iteratePlay(machine: machine) {
                totals += tokens
            }
        }
        return totals
    }

    private func iteratePlay(machine: ClawMachine) async -> Int? {
        var machines = [machine]
        var minTokens: Int = .max
        var foundPrize: Bool = false

        while !machines.isEmpty {
            let m = machines.removeFirst()

            // did we find the prize?
            if m.position == m.prize {
                foundPrize = true

                // is this a "cheaper" winning game?
                if m.tokensUsed < minTokens {
                    print("cheapest winner")
                    minTokens = m.tokensUsed
                } else {
                    print("more expensive winner")
                }

            // is this game still valid? (ie: not past the prize or current minimum tokens used)
            } else if m.position.x <= m.prize.x && m.position.y <= m.prize.x && m.tokensUsed < minTokens {
                var ma = m
                ma.press(button: "A")

                var mb = m
                mb.press(button: "B")

                // check games by pressing either button for here....
                machines.append(ma)
                machines.append(mb)
            } else {
                print("Invalid...")
                print(m)
            }
        }

        guard foundPrize else { return nil }
        return minTokens
    }
}
