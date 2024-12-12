//
//  Day11_2024Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/11/24.
//

import Testing

struct Day11_2024Tests {

    let sampleData1 = "0 1 10 99 999"
    let sampleData2 = "125 17"
    let realData = "4022724 951333 0 21633 5857 97 702 6"

    let day = Day11_2024()

    @Test func testParsing() async {
        let pebbles1 = day.parse(sampleData1)
        #expect(pebbles1.count == 5)
        #expect(pebbles1[0] == 0)
        #expect(pebbles1[1] == 1)
        #expect(pebbles1[2] == 10)
        #expect(pebbles1[3] == 99)
        #expect(pebbles1[4] == 999)

        let pebbles2 = day.parse(sampleData2)
        #expect(pebbles2.count == 2)

        let pebbles = day.parse(realData)
        #expect(pebbles.count == 8)
    }

    @Test func testBlink() async {
        let pebbles = day.parse(sampleData1)
        #expect(pebbles.count == 5)
        await pebbles.blink()
        #expect(pebbles.count == 7)
        #expect(pebbles[0] == 1)
        #expect(pebbles[1] == 2024)
        #expect(pebbles.stones.last == 2021976)
    }

    @Test func testBlinkingStone() async {
        let pebbles = day.parse(sampleData1)
        let stones = await pebbles.blink(stone: 1000)
        #expect(stones.count == 2)
        #expect(stones[0] == 10)
        #expect(stones[1] == 0)
    }

    @Test func testBlinkIterations() async {
        let pebbles = day.parse(sampleData2)
        #expect(pebbles.count == 2)
        await pebbles.blink(iterations: 6)
        #expect(pebbles.count == 22)
        #expect(pebbles[0] == 2097446912)
        #expect(pebbles[1] == 14168)
        #expect(pebbles[2] == 4048)
        #expect(pebbles.stones.last == 2)

        let pebbles2 = day.parse(sampleData2)
        #expect(pebbles2.count == 2)
        await pebbles2.blink(iterations: 25)
        #expect(pebbles2.count == 55312)
    }

    @Test func testPartOneWithSampleData() async throws {
        let answer = try await #require(day.partOne(input: sampleData2) as? Int)
        #expect(answer == 55312)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 211306)
    }

    @Test func testStoneCounting() async throws {
        let pebbles1 = day.parse(sampleData2)
        let count1 = pebbles1.stoneCount(after: 6)
        #expect(count1 == 22)

        let count2 = pebbles1.stoneCount(after: 25)
        #expect(count2 == 55312)
    }

//    @Test func testPartTwo() async throws {
//        let answer = try await #require(day.run(part: 2) as? Int)
//        #expect(answer == 211306)
//    }

}
