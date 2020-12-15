//
//  DayFifteenTests.swift
//  Test
//
//  Created by Shawn Veader on 12/15/20.
//

import XCTest

class DayFifteenTests: XCTestCase {

    func testBasicMemoryGamePlay() {
        var game: MemoryGame

        game = MemoryGame(initial: [0,3,6])
        game.play(turnCount: 10)
        XCTAssertEqual([0,3,6,0,3,3,1,0,4,0], game.numbers)

        game.play() // go to the 2020th turn
        XCTAssertEqual(436, game.numbers.last)
    }

    func testOtherIntroGames() {
        var game: MemoryGame

        game = MemoryGame(initial: [1,3,2])
        game.play()
        XCTAssertEqual(1, game.numbers.last)

        game = MemoryGame(initial: [2,1,3])
        game.play()
        XCTAssertEqual(10, game.numbers.last)

        game = MemoryGame(initial: [1,2,3])
        game.play()
        XCTAssertEqual(27, game.numbers.last)

        game = MemoryGame(initial: [2,3,1])
        game.play()
        XCTAssertEqual(78, game.numbers.last)

        game = MemoryGame(initial: [3,2,1])
        game.play()
        XCTAssertEqual(438, game.numbers.last)

        game = MemoryGame(initial: [3,1,2])
        game.play()
        XCTAssertEqual(1836, game.numbers.last)
    }

}
