//
//  DayTwentyTwoTests.swift
//  Test
//
//  Created by Shawn Veader on 12/24/20.
//

import XCTest

class DayTwentyTwoTests: XCTestCase {

    func testCombatGameParser() {
        let game = CombatGame(testInput)
        XCTAssertEqual(5, game.playerOneDeck.count)
        XCTAssert(game.playerOneDeck.contains(9))
        XCTAssertEqual(5, game.playerTwoDeck.count)
        XCTAssert(game.playerTwoDeck.contains(5))
    }

    func testCombatGameRoundOne() {
        let game = CombatGame(testInput)
        game.play(rounds: 1, print: false)
        XCTAssertEqual(6, game.playerOneDeck.count)
        XCTAssertEqual(4, game.playerTwoDeck.count)
    }

    func testCombatGameRoundTwo() {
        let game = CombatGame(testInput)
        game.play(rounds: 2, print: false)
        XCTAssertEqual(5, game.playerOneDeck.count)
        XCTAssertEqual(5, game.playerTwoDeck.count)
    }

    func testCombatGamePlay() {
        let game = CombatGame(testInput)
        game.play(rounds: -1, print: true)
    }

    func testCombatGameScore() {
        let game = CombatGame(testInput)
        game.play()
        let score = game.finalScore()
        XCTAssertEqual(306, score)
    }

    let testInput = """
        Player 1:
        9
        2
        6
        3
        1

        Player 2:
        5
        8
        4
        7
        10
        """

}
