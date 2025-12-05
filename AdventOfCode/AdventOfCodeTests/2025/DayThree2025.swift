//
//  DayThree2025.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/3/25.
//

import Testing

struct DayThree2025 {

    let day = Day3_2025()
    let sampleInput = """
        987654321111111
        811111111111119
        234234234234278
        818181911112111
        """

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

    @Test("Search of battery packs", arguments: [("234234234234278", 434234234278), ("987654321111111", 987654321111), ("818181911112111", 888911112111)])
    func testSearchOfBatterySelection(input: (String, Int)) async throws {
        let nums = input.0.map(String.init).compactMap(Int.init)
        let answer = await day.searchBatteries(bank: nums)
        #expect(answer == input.1)
    }

    @Test("Calculating joltage", arguments: [([3, 2], 6, 320000), ([], 7, 0), ([1], 3, 100), ([8,7,4,5,4], 5, 87454)])
    func testFindingJoltageFromBatteries(input: ([Int], Int, Int)) async throws {
        let joltage = day.joltage(for: input.0, size: input.1)
        #expect(joltage == input.2)
    }

    @Test func testPartTwoWithSampleData() async throws {
        let answer = try #require(day.partTwo(input: sampleInput) as? Int)
        #expect(answer == 3121910778619)
    }

    @Test func testPartTwo() async throws {
        let answer = try await #require(day.run(part: 2) as? Int)
        #expect(answer == 172740584266849)
    }
}
