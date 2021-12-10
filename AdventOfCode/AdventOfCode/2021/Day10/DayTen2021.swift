//
//  DayTen2021.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/10/21.
//

import Foundation

struct DayTen2021: AdventDay {
    var year = 2021
    var dayNumber = 10
    var dayTitle = "Syntax Scoring"
    var stars = 1

    func parse(_ input: String?) -> [NavSysCmd] {
        (input ?? "").split(separator: "\n").map { NavSysCmd(command: String($0)) }
    }

    func partOne(input: String?) -> Any {
        let commands = parse(input)
        let corruptCommands = commands.compactMap { cmd -> (Bool, String?)? in
            let result = cmd.isCorrupted()
            guard result.0 == true else { return nil } // ignore non-corrupted commands
            return result
        }

        let score = corruptCommands.reduce(0) { sum, result in
            switch result.1 {
            case ")":
                return sum + 3
            case "]":
                return sum + 57
            case "}":
                return sum + 1197
            case ">":
                return sum + 25137
            default:
                print("HUH? \(result.1)")
                return sum
            }
        }

        return score
    }

    func partTwo(input: String?) -> Any {
        Int.min
    }

}
