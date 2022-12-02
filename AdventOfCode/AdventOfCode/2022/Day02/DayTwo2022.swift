//
//  DayTwo2022.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/2/22.
//

import Foundation
import RegexBuilder

struct DayTwo2022: AdventDay {
    var year = 2022
    var dayNumber = 2
    var dayTitle = "Rock Paper Scissors"
    var stars = 1

    struct RoshamboRound {
        enum Hand: Int, Equatable {
            case rock = 1
            case paper = 2
            case scissor = 3

            func defeats(_ hand: Hand) -> Bool {
                switch self {
                case .rock:
                    return hand == .scissor
                case .paper:
                    return hand == .rock
                case .scissor:
                    return hand == .paper
                }
            }
        }

        let player1Selection: String
        let player2Selection: String

        var player1Hand: Hand {
            switch player1Selection {
            case "A":
                return .rock
            case "B":
                return .paper
            case "C":
                return .scissor
            default:
                return .rock // shouldn't hit given our regex...
            }
        }

        var player2Hand: Hand {
            switch player2Selection {
            case "X":
                return .rock
            case "Y":
                return .paper
            case "Z":
                return .scissor
            default:
                return .rock
            }
        }

        static let parsingRegex = Regex {
            Capture {
                ChoiceOf {
                    "A"
                    "B"
                    "C"
                }
            }

            OneOrMore(.whitespace) // could just be One(.whitespace)

            Capture {
                ChoiceOf {
                    "X"
                    "Y"
                    "Z"
                }
            }
        }

        init?(_ input: String) {
            guard let match = input.firstMatch(of: RoshamboRound.parsingRegex) else { return nil }

            player1Selection = String(match.1)
            player2Selection = String(match.2)
        }

        func scoreRound() -> Int {
            let p1 = player1Hand
            let p2 = player2Hand

            if p1 == p2 {               // draw
                return 3 + p2.rawValue
            } else if p2.defeats(p1) {  // win
                return 6 + p2.rawValue
            } else {                    // lost
                return 0 + p2.rawValue
            }
        }
    }

    func parse(_ input: String?) -> [RoshamboRound] {
        (input ?? "").split(separator: "\n").map(String.init).compactMap { RoshamboRound($0) }
    }

    func partOne(input: String?) -> Any {
        let rounds = parse(input)
        return rounds.reduce(0) { $0 + $1.scoreRound() }
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
