//
//  CombatGame.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/24/20.
//

import Foundation

class CombatGame {
    var playerOneDeck: [Int]
    var playerTwoDeck: [Int]

    init(_ input: String) {
        let playerStrings = input.replacingOccurrences(of: "\n\n", with: "|").split(separator: "|").map(String.init)

        playerOneDeck = playerStrings[0].split(separator: "\n").map(String.init).dropFirst().compactMap(Int.init)
        playerTwoDeck = playerStrings[1].split(separator: "\n").map(String.init).dropFirst().compactMap(Int.init)
    }

    func play(rounds: Int = -1, print printDebug: Bool = false) {
        var round: Int = 0

        while !playerOneDeck.isEmpty && !playerTwoDeck.isEmpty {
            round += 1

            if rounds != -1 && rounds < round {
                break
            }

            if printDebug {
                print("\n-- Round \(round) --")
                print("Player 1's deck: \(playerOneDeck)")
                print("Player 2's deck: \(playerTwoDeck)")
            }

            let playerOneCard = playerOneDeck.removeFirst()
            let playerTwoCard = playerTwoDeck.removeFirst()

            if printDebug {
                print("Player 1 plays: \(playerOneCard)")
                print("Player 2 plays: \(playerTwoCard)")
            }

            if playerOneCard > playerTwoCard {
                if printDebug {
                    print("Player 1 wins the round!")
                }

                playerOneDeck.append(playerOneCard)
                playerOneDeck.append(playerTwoCard)
            } else {
                if printDebug {
                    print("Player 2 wins the round!")
                }

                playerTwoDeck.append(playerTwoCard)
                playerTwoDeck.append(playerOneCard)
            }
        }

        if round != -1 {
            if printDebug {
                print("\n== Post-game results ==")
                print("Player 1's deck: \(playerOneDeck)")
                print("Player 2's deck: \(playerTwoDeck)")
            }
        }
    }

    func finalScore() -> Int {
        var deckToScore: [Int]

        if !playerOneDeck.isEmpty {
            deckToScore = playerOneDeck
        } else {
            deckToScore = playerTwoDeck
        }

        return deckToScore.reversed().enumerated().reduce(0) { (result, card) in
            result + (card.element * (card.offset + 1))
        }
    }
}
