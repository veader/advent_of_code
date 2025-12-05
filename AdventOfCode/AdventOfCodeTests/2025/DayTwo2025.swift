//
//  DayTwo2025.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/3/25.
//

import Testing

struct DayTwo2025 {

    let day = Day2_2025()
    let sampleInput = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

    @Test func testRangeSearching() async throws {
        #expect(day.scanForInvalidIDs(11...22) == [11, 22])
        #expect(day.scanForInvalidIDs(95...115) == [99])
        #expect(day.scanForInvalidIDs(998...1012) == [1010])
        #expect(day.scanForInvalidIDs(1188511880...1188511890) == [1188511885])
        #expect(day.scanForInvalidIDs(222220...222224) == [222222])
        #expect(day.scanForInvalidIDs(1698522...1698528) == [])
        #expect(day.scanForInvalidIDs(446443...446449) == [446446])
        #expect(day.scanForInvalidIDs(38593856...38593862) == [38593859])
        #expect(day.scanForInvalidIDs(565653...565659) == [])
        #expect(day.scanForInvalidIDs(824824821...824824827) == [])
        #expect(day.scanForInvalidIDs(2121212118...2121212124) == [])
    }

    @Test func testPartOneWithSampleData() async throws {
        let answer = try #require(day.partOne(input: sampleInput) as? Int)
        #expect(answer == 1227775554)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 24747430309)
    }

    @Test func testSubSequenceFinding() async throws {
        #expect(day.isInvalidSubSequence(565656) == true)
        #expect(day.isInvalidSubSequence(566566) == true)
        #expect(day.isInvalidSubSequence(5656) == true)
        #expect(day.isInvalidSubSequence(123123123) == true)

        #expect(day.isInvalidSubSequence(56) == false)
        #expect(day.isInvalidSubSequence(1188511880) == false)
        #expect(day.isInvalidSubSequence(2121212118) == false)
    }

    @Test func testPartTwoWithSampleData() async throws {
        let answer = try #require(day.partTwo(input: sampleInput) as? Int)
        #expect(answer == 4174379265)
    }

    @Test func testPartTwo() async throws {
        let answer = try await #require(day.run(part: 2) as? Int)
        #expect(answer == 30962646823)
    }
}
