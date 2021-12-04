//
//  BingoGame.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/4/21.
//

import Foundation

class BingoGame {
    var draws: [Int] = [Int]()
    var boards: [BingoBoard] = [BingoBoard]()
    var finalScore: Int = 0

    func play() {
        for draw in draws {
            print("Drew \(draw)...")
            boards.forEach { $0.mark(draw) }

            print("Current state:")
            for board in boards {
                print(board)

                // if any board has BINGO, the game is over
                if board.hasBingo() {
                    print("WINNER!")
                    // calculate score
                    finalScore = board.sum() * draw
                    return
                }
                print("----------")
            }
        }
    }

    static func parse(_ input: String) -> BingoGame {
        let game = BingoGame()

        var boardRows: [String] = [String]()
        var lines = input.split(separator: "\n").map(String.init)

        let drawsLine = lines.removeFirst()
        game.draws = drawsLine.split(separator: ",").map(String.init).compactMap(Int.init)

        lines.forEach { line in
            guard !line.isEmpty else { return }

            if boardRows.count == 5 {
                if let board = add(board: boardRows) {
                    game.boards.append(board)
                }

                // reset row collector
                boardRows.removeAll()
            }

            boardRows.append(line)
        }

        if let board = add(board: boardRows) {
            game.boards.append(board)
        }
        
        return game
    }

    static private func add(board: [String]) -> BingoBoard? {
        guard board.count == 5 else { return nil }
        return BingoBoard.parse(board)
    }
}
