//
//  DayFive2025.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/5/25.
//

import Testing

struct DayFive2025 {

    let day = Day5_2025()
    let sampleInput = """
        3-5
        10-14
        16-20
        12-18
        
        1
        5
        8
        11
        17
        32
        """

    @Test func testParsingSampleInput() async throws {
        let (ranges, available) = day.parse(sampleInput)
        #expect(ranges.count == 4)
        #expect(available.count == 6)
    }

    @Test func testPartOneWithSampleData() async throws {
        let answer = try #require(day.partOne(input: sampleInput) as? Int)
        #expect(answer == 3)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 640)
    }

    @Test func testPartTwoWithSampleData() async throws {
        let answer = try #require(day.partTwo(input: sampleInput) as? Int)
        #expect(answer == 14)
    }

    @Test func testPartTwo() async throws {
        let answer = try await #require(day.run(part: 2) as? Int)
        #expect(answer == 365804144481581)
    }

}
