//
//  DayThree2025.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/3/25.
//

import Testing

struct DayThree2025 {

    let sampleInput = """
        987654321111111
        811111111111119
        234234234234278
        818181911112111
        """

    let day = Day3_2025()

    @Test("Finding max battery pairs", arguments: [("987654321111111", 98), ("811111111111119", 89), ("234234234234278", 78), ("818181911112111", 92)])
    func testFindingMaxBatteryPair(input: (String, Int)) async throws {
        let nums = input.0.map(String.init).compactMap(Int.init)
        let pair = day.findMaxBatteryPair(nums)
        #expect(pair == input.1)
    }

    @Test func testPartOneWithSampleData() async throws {
        let answer = try #require(day.partOne(input: sampleInput) as? Int)
        #expect(answer == 357)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 17408)
    }

}
