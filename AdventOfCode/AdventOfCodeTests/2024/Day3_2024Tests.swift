//
//  Day3_2024Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/3/24.
//

import Testing

struct Day3_2024Tests {

    let sampleData = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
    let day = Day3_2024()

    @Test func testParsingLine() async throws {
        let instructions = day.parse(line: sampleData)
        #expect(instructions.count == 4)

        let first = try #require(instructions.first)
        #expect(first.x == 2)
        #expect(first.y == 4)

        let last = try #require(instructions.last)
        #expect(last.x == 8)
        #expect(last.y == 5)
    }

    @Test func testExecutingInstructions() async throws {
        let instructions = day.parse(line: sampleData)
        let answer = day.execute(instructions: instructions)
        #expect(answer == 161)
    }

    @Test func testPartOneWithSampleData() async throws {
        let answer = try #require(day.partOne(input: sampleData) as? Int)
        #expect(answer == 161)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 170778545)
    }
}
