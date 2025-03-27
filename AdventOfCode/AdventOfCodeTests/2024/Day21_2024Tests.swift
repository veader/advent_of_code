//
//  Day21_2024Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 1/3/25.
//

import Testing

struct Day21_2024Tests {
    let sampleData = """
        029A
        980A
        179A
        456A
        379A
        """

    let day = Day21_2024()
    let dPad = DPad()

    @Test func testNumPadToDPadTranslation() async throws {
        var moves = dPad.translateNumToDPad("02")
        #expect(moves == [.left, .activate, .up, .activate])

        moves = dPad.translateNumToDPad("024")
        #expect(moves == [.left, .activate, .up, .activate, .left, .up, .activate])

        moves = dPad.translateNumToDPad("30A")
        #expect(moves == [.up, .activate, .left, .down, .activate, .right, .activate])

        moves = dPad.translateNumToDPad("81A")
        #expect(moves == [.up, .up, .up, .left, .activate, .left, .down, .down, .activate, .right, .right, .down, .activate])
    }

    @Test func testDPadToDPadTranslation() async throws {
        let numMoves = dPad.translateNumToDPad("81A")
        #expect(numMoves == [
            .up, .up, .up, .left, .activate,    // 8
            .left, .down, .down, .activate,     // 1
            .right, .right, .down, .activate,   // A
        ])

        let dMoves = dPad.translateDPadToDPad(numMoves)
        #expect(dMoves == [
            .left, .activate,               // ^
            .activate,                      // ^
            .activate,                      // ^
            .down, .left, .activate,        // <
            .right, .right, .up, .activate, // A

            .down, .left, .left, .activate, // <
            .right, .activate,              // v
            .activate,                      // v
            .right, .up, .activate,         // A

            .down, .activate,               // >
            .activate,                      // >
            .left, .activate,               // <
            .right, .up, .activate,         // A
        ])
    }

    @Test func testFullTranslationWithThreeRobots() async throws {
        let moves = dPad.translate("029A")
        #expect(moves.count == 68)
    }

    @Test func testPartOneWithSampleData() async throws {
        let result = try await #require(day.partOne(input: sampleData) as? Int)
        #expect(result == 126384)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 220092)
        // 220092 <- too high
    }

}
