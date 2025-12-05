//
//  Day21_2024.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/27/24.
//

import Foundation

struct Day21_2024: AdventDay {
    var year = 2024
    var dayNumber = 21
    var dayTitle = "Keypad Conundrum"
    var stars = 0

    func parse(_ input: String?) -> [String] {
        (input ?? "").lines()
    }

    func partOne(input: String?) async-> Any {
        let dPad = DPad()
        let lines = parse(input)

        var total = 0
        for line in lines {
            let moves = dPad.translate(line)
            let num = Int(line.dropLast())
            print(line)
            print(moves.map(\.rawValue).joined(separator: ""))
            print(moves.count)
            print("\(num ?? 0)\n\n")

            total += moves.count * (num ?? 0)
        }

        return total
    }

    func partTwo(input: String?) async -> Any {
        return 0
    }
}
