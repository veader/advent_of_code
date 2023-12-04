//
//  Day2_2023Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/2/23.
//

import XCTest

final class Day2_2023Tests: XCTestCase {
    let sampleInput = """
        Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
        """

    let gameInput = "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue"
    let invalidGameInput = "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red"

    func testParsingGame() throws {
        let game = CubeGame.parse(gameInput)
        XCTAssertNotNil(game)
        XCTAssertEqual(2, game?.id)
        XCTAssertEqual(3, game?.turns.count)

        var turn = try XCTUnwrap(game?.turns.first)
        XCTAssertNil(turn[CubeGame.CubeColor.red])
        XCTAssertEqual(2, turn[CubeGame.CubeColor.green])
        XCTAssertEqual(1, turn[CubeGame.CubeColor.blue])

        turn = try XCTUnwrap(game?.turns[1])
        XCTAssertEqual(1, turn[CubeGame.CubeColor.red])
        XCTAssertEqual(3, turn[CubeGame.CubeColor.green])
        XCTAssertEqual(4, turn[CubeGame.CubeColor.blue])

        turn = try XCTUnwrap(game?.turns[2])
        XCTAssertNil(turn[CubeGame.CubeColor.red])
        XCTAssertEqual(1, turn[CubeGame.CubeColor.green])
        XCTAssertEqual(1, turn[CubeGame.CubeColor.blue])
    }

    func testParsing() throws {
        let games = Day2_2023().parse(sampleInput)
        XCTAssertEqual(5, games.count)
    }

    func testGameValidation() throws {
        let maxes: CubeGame.Turn = [
            .red: 12,
            .green: 13,
            .blue: 14,
        ]

        let validGame = try XCTUnwrap(CubeGame.parse(gameInput))
        XCTAssertTrue(validGame.valid(maxes: maxes))

        let invalidGame = try XCTUnwrap(CubeGame.parse(invalidGameInput))
        XCTAssertFalse(invalidGame.valid(maxes: maxes))

        let games = Day2_2023().parse(sampleInput)
        let validGames = games.filter { $0.valid(maxes: maxes) }
        XCTAssertEqual(3, validGames.count)
    }

    func testPart1() throws {
        let answer = Day2_2023().run(part: 1, sampleInput)
        XCTAssertEqual(8, answer as? Int)
    }

    func testPart1Answer() throws {
        let answer = Day2_2023().run(part: 1)
        XCTAssertEqual(2505, answer as? Int)
    }

    func testGameMins() throws {
        let game = try XCTUnwrap(CubeGame.parse("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"))
        let mins = game.minimumCubes()
        XCTAssertEqual(4, mins[.red])
        XCTAssertEqual(2, mins[.green])
        XCTAssertEqual(6, mins[.blue])
    }

    func testGamePower() throws {
        let game = try XCTUnwrap(CubeGame.parse("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"))
        XCTAssertEqual(48, game.power)

        let games = Day2_2023().parse(sampleInput)
        XCTAssertEqual(48, games[0].power)
        XCTAssertEqual(12, games[1].power)
        XCTAssertEqual(1560, games[2].power)
        XCTAssertEqual(630, games[3].power)
        XCTAssertEqual(36, games[4].power)
    }

    func testPart2() throws {
        let answer = Day2_2023().run(part: 2, sampleInput)
        XCTAssertEqual(2286, answer as? Int)
    }

    func testPart2Answer() throws {
        let answer = Day2_2023().run(part: 2)
        XCTAssertEqual(70265, answer as? Int)
    }
}
