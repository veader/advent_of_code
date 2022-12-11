//
//  RoshamboRound.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/2/22.
//

import Foundation
import RegexBuilder

struct RoshamboRound {
    enum Hand: Int, Equatable, CaseIterable {
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

    enum RoundOutcome: Int {
        case lost = 0
        case draw = 3
        case win = 6
    }

    let player1Value: String
    let player2Value: String

    var player1Hand: Hand {
        switch player1Value {
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
        switch player2Value {
        case "X":
            return .rock
        case "Y":
            return .paper
        case "Z":
            return .scissor
        default:
            return .rock // shouldn't hit given our regex...
        }
    }

    var player2Outcome: RoundOutcome {
        switch player2Value {
        case "X":
            return .lost
        case "Y":
            return .draw
        case "Z":
            return .win
        default:
            return .lost // shouldn't hit given our regex...
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

        player1Value = String(match.1)
        player2Value = String(match.2)
    }

    func scoreRound() -> Int {
        let p1 = player1Hand
        let p2 = player2Hand

        if p1 == p2 {
            return RoundOutcome.draw.rawValue + p2.rawValue
        } else if p2.defeats(p1) {
            return RoundOutcome.win.rawValue + p2.rawValue
        } else {
            return RoundOutcome.lost.rawValue + p2.rawValue
        }
    }

    func scoreCalculatedRound() -> Int {
        let p1 = player1Hand
        let outcome = player2Outcome

        switch outcome {
        case .draw:
            // pick the same thing as player 1
            return outcome.rawValue + p1.rawValue
        case .win:
            // find our selection to win
            let p2: Hand! = Hand.allCases.first(where: { $0.defeats(p1) })
            return outcome.rawValue + p2.rawValue
        case .lost:
            // find our selection that lost
            let p2: Hand! = Hand.allCases.first(where: { p1.defeats($0) })
            return outcome.rawValue + p2.rawValue
        }
    }
}
