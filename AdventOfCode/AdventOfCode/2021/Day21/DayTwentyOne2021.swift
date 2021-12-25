//
//  DayTwentyOne2021.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/23/21.
//

import Foundation

struct DayTwentyOne2021: AdventDay {
    var year = 2021
    var dayNumber = 21
    var dayTitle = "Dirac Dice"
    var stars = 1

    func parse(_ input: String?) -> [Int: Int] {
        // https://rubular.com/r/IAx1x9YxqUE1la
        let regex = "Player (\\d+) starting position: (\\d+)"
        var hash = [Int: Int]()

        (input ?? "").split(separator: "\n").map(String.init).forEach { line in
            guard
                let match = line.matching(regex: regex),
                match.captures.count == 2,
                let playerNum = Int(match.captures.first ?? ""),
                let playerPos = Int(match.captures.last ?? "")
            else { return }

            hash[playerNum] = playerPos
        }

        return hash
    }
    
    func partOne(input: String?) -> Any {
        let hash = parse(input)
        let player1Location = hash[1] ?? 1
        let player2Location = hash[2] ?? 1
        let game = DiceGame(player1: player1Location, player2: player2Location, winningScore: 1000)
        game.playPracticeGame()

        let loser = game.loser()
        return loser.score * game.dice
    }

    func partTwo(input: String?) -> Any {
        return Int.min
    }
}
