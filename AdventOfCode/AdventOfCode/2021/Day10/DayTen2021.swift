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
    var stars = 2

    func parse(_ input: String?) -> [NavSysCmd] {
        (input ?? "").split(separator: "\n").map { NavSysCmd(command: String($0)) }
    }

    /// Score the given corrupt command based on rules given for part 1.
    func score(corruptCommand: NavSysCmd) -> Int {
        switch corruptCommand.parseResult.corruptValue {
        case ")":
            return 3
        case "]":
            return 57
        case "}":
            return 1197
        case ">":
            return 25137
        default:
            print("HUH? \(corruptCommand.parseResult.corruptValue ?? "")")
            return 0
        }
    }

    func score(openCommand: NavSysCmd) -> Int {
        let closingSequence = openCommand.closingString().map(String.init)
        return closingSequence.reduce(0) { sum, closer -> Int in
            var value = 0

            switch closer {
            case ")":
                value = 1
            case "]":
                value = 2
            case "}":
                value = 3
            case ">":
                value = 4
            default:
                value = 0
            }

            return (sum * 5) + value
        }
    }

    func partOne(input: String?) -> Any {
        let commands = parse(input)
        let corruptedCommands = commands.filter { $0.isCorrupted }
        print("Found \(corruptedCommands.count) corrupted commands out of \(commands.count)")

        return corruptedCommands.reduce(0) { sum, cmd -> Int in
            sum + score(corruptCommand: cmd)
        }
    }

    func partTwo(input: String?) -> Any {
        let commands = parse(input)
        let openCommands = commands.filter { $0.isOpen }
        print("Found \(openCommands.count) open commands out of \(commands.count)")

        let commandScores = openCommands.map({ score(openCommand: $0) }).sorted()
        return commandScores[commandScores.middleIndex]
    }

}
