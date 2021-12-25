//
//  DayTwentyOne2021Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/23/21.
//

import XCTest

class DayTwentyOne2021Tests: XCTestCase {

    let sampleInput = """
        Player 1 starting position: 4
        Player 2 starting position: 8
        """

    func testParsing() {
        let day = DayTwentyOne2021()
        let hash = day.parse(sampleInput)
        XCTAssertEqual(4, hash[1])
        XCTAssertEqual(8, hash[2])
    }

    func testDiceGameTurn() {
        let game = DiceGame(player1: 4, player2: 8)

        game.playPracticeGame(turns: 1)
        XCTAssertEqual(10, game.player1.score)
        XCTAssertEqual(3, game.player2.score)

        game.playPracticeGame(turns: 1)
        XCTAssertEqual(14, game.player1.score)
        XCTAssertEqual(9, game.player2.score)

        game.playPracticeGame(turns: 1)
        XCTAssertEqual(20, game.player1.score)
        XCTAssertEqual(16, game.player2.score)

        game.playPracticeGame(turns: 1)
        XCTAssertEqual(26, game.player1.score)
        XCTAssertEqual(22, game.player2.score)
    }

    func testDiceGamePractice() {
        let game = DiceGame(player1: 4, player2: 8)
        game.playPracticeGame()
        XCTAssertEqual(1000, game.player1.score)
        XCTAssertEqual(745, game.player2.score)
        XCTAssertEqual(993, game.dice)
        XCTAssertEqual(2, game.loser().num)
    }
}
