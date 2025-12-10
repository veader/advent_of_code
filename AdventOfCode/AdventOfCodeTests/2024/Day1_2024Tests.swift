//
//  Day1_2024Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/2/24.
//

import Testing

struct Day1_2024Tests {

    let sampleInput = """
        3   4
        4   3
        2   5
        1   3
        3   9
        3   3
        """

    let day = Day1_2024()

    @Test func testParsingSampleData() async throws {
        let columns = try day.parse(sampleInput)
        #expect(columns.left == [1,2,3,3,3,4])
        #expect(columns.right == [3,3,3,4,5,9])
    }

    @Test func testPartOneWithSampleData() async throws {
        let answer = try #require(day.partOne(input: sampleInput) as? Int)
        #expect(answer == 11)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 2164381)
    }

    @Test func testPartTwoWithSampleData() async throws {
        let answer = try #require(day.partTwo(input: sampleInput) as? Int)
        #expect(answer == 31)
    }

    @Test func testPartTwo() async throws {
        let answer = try await #require(day.run(part: 2) as? Int)
        #expect(answer == 20719933)
    }
}
