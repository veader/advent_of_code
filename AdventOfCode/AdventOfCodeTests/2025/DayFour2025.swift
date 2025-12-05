//
//  DayFour2025.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/4/25.
//

import Testing

struct DayFour2025 {

    let day = Day4_2025()
    let sampleInput = """
        ..@@.@@@@.
        @@@.@.@.@@
        @@@@@.@.@@
        @.@@@@..@.
        @@.@@@@.@@
        .@@@@@@@.@
        .@.@.@.@@@
        @.@@@.@@@@
        .@@@@@@@@.
        @.@.@@@.@.
        """

    @Test func testParsingInput() async throws {
        let map = day.parse(sampleInput)
        #expect(map.width == 10)
        #expect(map.height == 10)
        #expect(map.itemAt(x: 0, y: 0) == .empty)
        #expect(map.itemAt(x: 0, y: 1) == .roll)
        #expect(map.itemAt(x: 1, y: 1) == .roll)
    }

    @Test func testPartOneWithSampleData() async throws {
        let answer = try #require(day.partOne(input: sampleInput) as? Int)
        #expect(answer == 13)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 1363)
    }

    @Test func testPartTwoWithSampleData() async throws {
        let answer = try #require(day.partTwo(input: sampleInput) as? Int)
        #expect(answer == 43)
    }

    @Test func testPartTwo() async throws {
        let answer = try await #require(day.run(part: 2) as? Int)
        #expect(answer == 8184)
    }

}
