//
//  Day2_2024Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/2/24.
//

import Testing

struct Day2_2024Tests {
    let sampleData = """
        7 6 4 2 1
        1 2 7 8 9
        9 7 6 2 1
        1 3 2 4 5
        8 6 4 4 1
        1 3 6 7 9
        """

    let day = Day2_2024()

    @Test func testPrasingSampleData () async throws {
        let levels = day.parse(sampleData)
        #expect(levels.count == 6)
        #expect(levels[0].count == 5)
    }

    @Test func testLevelSafetyCheck() async throws {
        #expect(day.safetyCheck(level: [7, 6, 4, 2, 1]))
        #expect(!day.safetyCheck(level: [1, 2, 7, 8, 9]))
        #expect(!day.safetyCheck(level: [9, 7, 6, 2, 1]))
        #expect(!day.safetyCheck(level: [1, 3, 2, 4, 5]))
        #expect(!day.safetyCheck(level: [8, 6, 4, 4, 1]))
        #expect(day.safetyCheck(level: [1, 3, 6, 7, 9]))
    }

    @Test func testLevelSafetyDeltaCheck() async throws {
        #expect(day.safetyCheckDeltas(level: [7, 6, 4, 2, 1]))
        #expect(!day.safetyCheckDeltas(level: [1, 2, 7, 8, 9]))
        #expect(!day.safetyCheckDeltas(level: [9, 7, 6, 2, 1]))
        #expect(!day.safetyCheckDeltas(level: [1, 3, 2, 4, 5]))
        #expect(!day.safetyCheckDeltas(level: [8, 6, 4, 4, 1]))
        #expect(day.safetyCheckDeltas(level: [1, 3, 6, 7, 9]))
    }

    @Test func testPartOneWithSampleData() async throws {
        let answer = try #require(day.partOne(input: sampleData) as? Int)
        #expect(answer == 2)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 407)
    }

    @Test func testPossiblySafeLevels() async throws {
        #expect(!day.possiblySafe(level: [1, 2, 7, 8, 9]))
        #expect(!day.possiblySafe(level: [9, 7, 6, 2, 1]))
        #expect(day.possiblySafe(level: [1, 3, 2, 4, 5]))
        #expect(day.possiblySafe(level: [8, 6, 4, 4, 1]))
    }

    @Test func testPartTwoWithSampleData() async throws {
        let answer = try #require(day.partTwo(input: sampleData) as? Int)
        #expect(answer == 4)
    }

    @Test func testPartTwo() async throws {
        let answer = try await #require(day.run(part: 2) as? Int)
        #expect(answer == 459)
    }
}
