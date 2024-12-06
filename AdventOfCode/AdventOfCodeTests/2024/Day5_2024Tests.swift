//
//  Day5_2024Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/5/24.
//

import Testing

struct Day5_2024Tests {
    let sampleData = """
        47|53
        97|13
        97|61
        97|47
        75|29
        61|13
        75|53
        29|13
        97|29
        53|29
        61|53
        97|53
        61|29
        47|13
        75|47
        97|75
        47|61
        75|61
        47|29
        75|13
        53|13

        75,47,61,53,29
        97,61,53,29,13
        75,29,13
        75,97,47,61,53
        61,13,29
        97,13,75,29,47
        """

    let day = Day5_2024()

    @Test func testParsingSampleInput() async throws {
        let instructions = day.parse(sampleData)

        #expect(instructions.orderInstructions.count == 21)
        let order = try #require(instructions.orderInstructions.first)
        #expect(order.page == 47)
        #expect(order.before == 53)

        #expect(instructions.printBatches.count == 6)
        #expect(instructions.printBatches[0].count == 5)
        #expect(instructions.printBatches[2].count == 3)
    }

    @Test func testPagesAfter() async throws {
        let instructions = day.parse(sampleData)

        #expect(instructions.pagesAfter(53).count == 2)
        #expect(instructions.pagesAfter(75).count == 5)
        #expect(instructions.pagesAfter(97).count == 6)
    }

    @Test func testBatchCorrect() async throws {
        let instructions = day.parse(sampleData)
        let batch1 = try #require(instructions.printBatches.first)
        #expect(instructions.isBatchCorrect(batch1))
        let batch2 = try #require(instructions.printBatches[1])
        #expect(instructions.isBatchCorrect(batch2))
        let batch3 = try #require(instructions.printBatches[2])
        #expect(instructions.isBatchCorrect(batch3))
        let batch4 = try #require(instructions.printBatches[3])
        #expect(!instructions.isBatchCorrect(batch4))
    }

    @Test func testPartOneWithSampleData() async throws {
        let answer = try #require(day.partOne(input: sampleData) as? Int)
        #expect(answer == 143)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 4774)
    }

    @Test func testCorrectingBatch() async throws {
        let instructions = day.parse(sampleData)

        let batch1 = try #require(instructions.printBatches.last)
        let correct1 = instructions.fix(batch: batch1)
        #expect(correct1 == [97,75,47,29,13])

        let batch2 = try #require(instructions.printBatches[3])
        let correct2 = instructions.fix(batch: batch2)
        #expect(correct2 == [97,75,47,61,53])

        let batch3 = try #require(instructions.printBatches[4])
        let correct3 = instructions.fix(batch: batch3)
        #expect(correct3 == [61,29,13])
    }

    @Test func testPartTwoWithSampleData() async throws {
        let answer = try #require(day.partTwo(input: sampleData) as? Int)
        #expect(answer == 123)
    }

    @Test func testPartTwo() async throws {
        let answer = try await #require(day.run(part: 2) as? Int)
        #expect(answer == 6004)
    }
}
