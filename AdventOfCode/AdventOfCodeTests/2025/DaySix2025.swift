//
//  DaySix2025.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/5/25.
//

import Testing

struct DaySix2025 {
    let day = Day6_2025()
    let sampleInput = """
        123 328  51 64 
         45 64  387 23 
          6 98  215 314
        *   +   *   +  
        """

    @Test func testParsingSampleInput() async throws {
        let homework = try #require(MathHomework.parse(sampleInput))
        #expect(homework.problems.count == 4)   // columns
        #expect(homework.numbers.count == 3)    // rows
        #expect(homework.operations.count == 4)

        #expect(homework.problems.first?.operation == .multiply)
        #expect(homework.problems.last?.operation ==  .add)
    }

    @Test func testSolvingProblems() async throws {
        let homework = try #require(MathHomework.parse(sampleInput))
        #expect(homework.problems[0].solve() == 33210)
        #expect(homework.problems[1].solve() == 490)
        #expect(homework.problems[2].solve() == 4243455)
        #expect(homework.problems[3].solve() == 401)
    }

    @Test func testSolvingHomework() async throws {
        let homework = try #require(MathHomework.parse(sampleInput))
        #expect(homework.grandTotal() == 4277556)
    }

    @Test func testPartOneWithSampleData() async throws {
        let answer = try #require(day.partOne(input: sampleInput) as? Int)
        #expect(answer == 4277556)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 6757749566978)
    }

    @Test func testParsingDifferently() async throws {
        let homework = try #require(MathHomework.parseDifferently(sampleInput))
        #expect(homework.problems.count == 4)

        let problem1 = homework.problems[0]
        #expect(problem1.values.count == 3)
        #expect(problem1.operation == .add)
        #expect(problem1.solve() == 1058)

        let problem2 = homework.problems[1]
        #expect(problem2.values.count == 3)
        #expect(problem2.operation == .multiply)
        #expect(problem2.solve() == 3253600)
    }

    @Test func testPartTwoWithSampleData() async throws {
        let answer = try #require(day.partTwo(input: sampleInput) as? Int)
        #expect(answer == 3263827)
    }

    @Test func testPartTwo() async throws {
        let answer = try await #require(day.run(part: 2) as? Int)
        #expect(answer == 10603075273949)
    }
}
