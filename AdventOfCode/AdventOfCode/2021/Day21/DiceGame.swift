//
//  DiceGame.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/24/21.
//

import Foundation

class DiceGame {
    struct Player: CustomStringConvertible {
        let num: Int
        var location: Int
        var score: Int

        mutating func update(location: Int) {
            self.location = location
        }

        mutating func update(score: Int) {
            self.score += score
        }

        func winning(_ winningScore: Int) -> Bool {
            score >= winningScore
        }

        var description: String {
            return "<Player \(num): location:\(location+1) score:\(score)>"
        }
    }

    var player1: Player
    var player2: Player
    let winningScore: Int
    var dice: Int = 0

    init(player1 location1: Int, player2 location2: Int, winningScore: Int = 1000) {
        self.player1 = Player(num: 1, location: location1-1, score: 0)
        self.player2 = Player(num: 2, location: location2-1, score: 0)
        self.winningScore = winningScore
    }

    func playPracticeGame(turns: Int = Int.max) {
        let rolls = 3
        var turnsTaken = 0

        while !player1.winning(winningScore) && !player2.winning(winningScore) {
            takeTurn(&player1, dice: &dice, rolls: rolls)
            guard !player1.winning(winningScore) else { break }
            takeTurn(&player2, dice: &dice, rolls: rolls)

            turnsTaken += 1
            guard turnsTaken < turns else { break }
        }

        if player1.winning(winningScore) {
            print("Player 1 WINS!!!\nFinal Scores:")
            print(player1)
            print(player2)
        } else if player2.winning(winningScore) {
            print("Player 2 WINS!!!\nFinal Scores:")
            print(player1)
            print(player2)
        }
    }

    func takeTurn(_ player: inout Player, dice: inout Int, rolls: Int) {
        var spacesToMove = 0
        (0..<rolls).forEach { i in
            spacesToMove += (dice % 100) + 1
            dice += 1
        }

        let newLocation = (player.location + spacesToMove) % 10
        player.update(location: newLocation)
        player.update(score: newLocation+1)
    }

    func loser() -> Player {
        if player1.winning(winningScore) {
            return player2
        } else {
            return player1
        }
    }
}
