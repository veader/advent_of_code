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
    var stars = 2

    /// Matches `mul(1,3)`, `mul(1,23)`, `mul(12,345)` (with 1-3 digit numbers, no spaces)
    let mulInstructionRegex: Regex = /mul\((\d{1,3}),(\d{1,3})\)/

    /// Matches `do()`
    let doInstructionRegex: Regex = /do\(\)/

    /// Matches `don't()`
    let dontInstructionRegex: Regex = /don\'t\(\)/

    typealias MultiplyInstruction = (x: Int, y: Int)

    func parse(_ input: String?) -> [String] {
        (input ?? "").lines()
    }

    /// Parse the given line just looking for `mul` instructions.
    func parse(line: String) -> [MultiplyInstruction] {
        let matches = line.matches(of: mulInstructionRegex)
        guard matches.count > 0 else { return [] }
        return matches.compactMap { match -> MultiplyInstruction? in
            guard let x = Int(match.1), let y = Int(match.2) else { return nil }
            return MultiplyInstruction(x: x, y: y)
        }
    }

    /// Parse the given line looking for all instructions and enable/disable `mul`
    /// instructions based on previous `do` and `don't` instructions.
    ///
    /// - Note: We need all lines because the enabled state should be tracked across
    /// line boundaries.
    func parseTrackingEnabledState(lines: [String]) -> [MultiplyInstruction] {
        let allRegex = ChoiceOf {
            mulInstructionRegex
            doInstructionRegex
            dontInstructionRegex
        }

        var instructions = [MultiplyInstruction]()
        var enabled = true // default to enabled

        for line in lines {
            let matches = line.matches(of: allRegex)
            guard matches.count > 0 else { return [] }

            for fullMatch in matches {
                if let match = fullMatch.0.firstMatch(of: mulInstructionRegex) {
                    guard enabled else { continue } // skip instructions when disabled
                    guard let x = Int(match.1), let y = Int(match.2) else { continue }
                    instructions.append(MultiplyInstruction(x: x, y: y))
                } else if let _ = fullMatch.0.firstMatch(of: doInstructionRegex) {
                    enabled = true
                } else if let _ = fullMatch.0.firstMatch(of: dontInstructionRegex) {
                    enabled = false
                }
            }
        }

        return instructions
    }

    func execute(instructions: [MultiplyInstruction]) -> Int {
        instructions.map { $0.x * $0.y }.reduce(0, +)
    }

    func partOne(input: String?) -> Any {
        let instructionSets = parse(input).map { parse(line: $0) }
        return instructionSets.map { execute(instructions: $0) }.reduce(0, +)
    }

    func partTwo(input: String?) -> Any {
        let instructions = parseTrackingEnabledState(lines: parse(input))
        return execute(instructions: instructions)
    }
}
