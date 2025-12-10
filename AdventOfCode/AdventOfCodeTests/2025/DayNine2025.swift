//
//  DayNine2025.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/9/25.
//

import Testing

struct DayNine2025 {
    let day = Day9_2025()
    let sampleInput = """
        7,1
        11,1
        11,7
        9,7
        9,5
        2,5
        2,3
        7,3
        """

    @Test func testCoordinateParsing() async throws {
        let coordinates = day.parse(sampleInput)
        #expect(coordinates.count == 8)

        let first = try #require(coordinates.first)
        #expect(first.x == 7)
        #expect(first.y == 1)

        let last = try #require(coordinates.last)
        #expect(last.x == 7)
        #expect(last.y == 3)
    }

    @Test func testPartOneWithSampleData() async throws {
        let answer = try #require(day.partOne(input: sampleInput) as? Int)
        #expect(answer == 50)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 4755064176)
    }

}
