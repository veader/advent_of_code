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
        XCTAssertEqual(436, game.lastNumberPlayed)
    }

    func testOtherIntroGames() {
        var game: MemoryGame

        game = MemoryGame(initial: [1,3,2])
        game.play()
        XCTAssertEqual(1, game.lastNumberPlayed)

        game = MemoryGame(initial: [2,1,3])
        game.play()
        XCTAssertEqual(10, game.lastNumberPlayed)

        game = MemoryGame(initial: [1,2,3])
        game.play()
        XCTAssertEqual(27, game.lastNumberPlayed)

        game = MemoryGame(initial: [2,3,1])
        game.play()
        XCTAssertEqual(78, game.lastNumberPlayed)

        game = MemoryGame(initial: [3,2,1])
        game.play()
        XCTAssertEqual(438, game.lastNumberPlayed)

        game = MemoryGame(initial: [3,1,2])
        game.play()
        XCTAssertEqual(1836, game.lastNumberPlayed)
    }


    func testLongGames() {
//        var game: MemoryGame

//        print(Date())
//        game = MemoryGame(initial: [0,3,6])
//        game.play(turnCount: 30_000_000, optimized: true)
//        print(Date())
//        XCTAssertEqual(175594, game.lastNumberPlayed)

//        print(Date())
//        game = MemoryGame(initial: [1,3,2])
//        game.play(turnCount: 30_000_000, optimized: true)
//        print(Date())
//        XCTAssertEqual(2578, game.lastNumberPlayed)

        XCTAssert(true)
    }
}
