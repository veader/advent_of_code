//
//  Day3_2024.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/3/24.
//

import Foundation
import RegexBuilder

struct Day3_2024: AdventDay {
    var year = 2024
    var dayNumber = 3
    var dayTitle = "Mull It Over"
    var stars = 1

    let mulInstructionRegex: Regex = /mul\((\d{1,3}),(\d{1,3})\)/

    typealias MultiplyInstruction = (x: Int, y: Int)

    func parse(_ input: String?) -> [[MultiplyInstruction]] {
        (input ?? "").split(separator: "\n").map(String.init).map { parse(line: $0) }
    }

    func parse(line: String) -> [MultiplyInstruction] {
        let matches = line.matches(of: mulInstructionRegex)
        guard matches.count > 0 else { return [] }
        return matches.compactMap { match -> MultiplyInstruction? in
            guard let x = Int(match.1), let y = Int(match.2) else { return nil }
            return MultiplyInstruction(x: x, y: y)
        }
    }

    func execute(instructions: [MultiplyInstruction]) -> Int {
        instructions.map { $0.x * $0.y }.reduce(0, +)
    }

    func partOne(input: String?) -> Any {
        let instructionSets = parse(input)
        return instructionSets.map { execute(instructions: $0) }.reduce(0, +)
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
