//
//  DayOne2025.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/2/25.
//

import Testing

struct DayOne2025 {

    let sampleInput = """
        L68
        L30
        R48
        L5
        R60
        L55
        L1
        L99
        R14
        L82
        """

    let day = Day1_2025()

    @Test func parsingCombinationSteps() async throws {
        var step: CombinationStep?

        step = CombinationStep.parse("foo")
        #expect(step == nil)

        step = CombinationStep.parse("L")
        #expect(step == nil)

        step = CombinationStep.parse("L2")
        #expect(step == .left(2))

        step = CombinationStep.parse("R17")
        #expect(step == .right(17))

        step = CombinationStep.parse("R987")
        #expect(step == .right(987))
    }

    @Test func testPartOneWithSampleData() async throws {
        let answer = try #require(day.partOne(input: sampleInput) as? Int)
        #expect(answer == 3)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 999)
    }

}
