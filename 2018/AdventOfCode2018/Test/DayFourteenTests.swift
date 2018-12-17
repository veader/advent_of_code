//
//  DayFourteenTests.swift
//  Test
//
//  Created by Shawn Veader on 12/17/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import XCTest

class DayFourteenTests: XCTestCase {

    func testOneGenerationCycle() {
        var scoreboard = DayFourteen.RecipesScoreboard()
        XCTAssertEqual(2, scoreboard.scores.count)

        scoreboard.generateRecipes()
        XCTAssertEqual(4, scoreboard.scores.count)
        XCTAssertEqual([3, 7, 1, 0], scoreboard.scores)
        XCTAssertEqual(0, scoreboard.firstIndex)
        XCTAssertEqual(1, scoreboard.secondIndex)
    }

    func testTwoGenerationCycle() {
        var scoreboard = DayFourteen.RecipesScoreboard()

        scoreboard.generateRecipes()
        scoreboard.generateRecipes()

        XCTAssertEqual(6, scoreboard.scores.count)
        XCTAssertEqual([3, 7, 1, 0, 1, 0], scoreboard.scores)
        XCTAssertEqual(4, scoreboard.firstIndex)
        XCTAssertEqual(3, scoreboard.secondIndex)
    }

    func testScoresAfterFive() {
        let count = 5
        var scoreboard = DayFourteen.RecipesScoreboard()
        scoreboard.generateRecipes(count: count + 10)
        guard let scores = scoreboard.scores(offset: count) else {
            XCTFail("Unable to get scores offset by \(count)")
            return
        }
        let scoreValues = scores.compactMap(String.init).joined()
        XCTAssertEqual("0124515891", scoreValues)
    }

    func testScoresAfterNine() {
        let count = 9
        var scoreboard = DayFourteen.RecipesScoreboard()
        scoreboard.generateRecipes(count: count + 10)
        guard let scores = scoreboard.scores(offset: count) else {
            XCTFail("Unable to get scores offset by \(count)")
            return
        }
        let scoreValues = scores.compactMap(String.init).joined()
        XCTAssertEqual("5158916779", scoreValues)
    }

    func testScoresAfterEighteen() {
        let count = 18
        var scoreboard = DayFourteen.RecipesScoreboard()
        scoreboard.generateRecipes(count: count + 10)
        guard let scores = scoreboard.scores(offset: count) else {
            XCTFail("Unable to get scores offset by \(count)")
            return
        }
        let scoreValues = scores.compactMap(String.init).joined()
        XCTAssertEqual("9251071085", scoreValues)
    }

    func testScoresAfterLots() {
        let count = 2018
        var scoreboard = DayFourteen.RecipesScoreboard()
        scoreboard.generateRecipes(count: count + 10)
        guard let scores = scoreboard.scores(offset: count) else {
            XCTFail("Unable to get scores offset by \(count)")
            return
        }
        let scoreValues = scores.compactMap(String.init).joined()
        XCTAssertEqual("5941429882", scoreValues)
    }

}
