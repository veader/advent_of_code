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

    @Test func testPartTwoWithSampleData() async throws {
        let answer = try #require(day.partTwo(input: sampleInput) as? Int)
        #expect(answer == 6)
    }

    @Test func testPartTwo() async throws {
        let answer = try await #require(day.run(part: 2) as? Int)
        #expect(answer == 5728) // too low
        // 5728 - too low
        // 5734 - nope
        // 6501 - too high
    }

    /*
     After R33 -> 74
     After L74 -> 0
     662 6 62
     After R762 -> 62
     -588 -4 -88
     After L750 -> -88
     After R90 -> 2
     -700 -7 0
     After L802 -> 0
     */
}
