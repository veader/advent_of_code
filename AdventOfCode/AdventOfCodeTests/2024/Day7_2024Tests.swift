//
//  Day7_2024Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/7/24.
//

import Testing
import Foundation

struct Day7_2024Tests {
    let sampleData = """
        190: 10 19
        3267: 81 40 27
        83: 17 5
        156: 15 6
        7290: 6 8 6 15
        161011: 16 10 13
        192: 17 8 14
        21037: 9 7 18 13
        292: 11 6 16 20
        """

    let day = Day7_2024()

    @Test func testParsingEquation() async throws {
        let eq1 = try #require(CalibrationEquation("190: 10 19"))
        #expect(eq1.result == 190)
        #expect(eq1.values.count == 2)

        let eq2 = try #require(CalibrationEquation("3267: 81 40 27"))
        #expect(eq2.result == 3267)
        #expect(eq2.values.count == 3)

        let eq3 = try #require(CalibrationEquation("292: 11 6 16 20"))
        #expect(eq3.result == 292)
        #expect(eq3.values.count == 4)
    }

    @Test func testParsingSampleData() async throws {
        let equations = day.parse(sampleData)
        #expect(equations.count == 9)
    }

    @Test func testValidEquationSearch() async throws {
        let eq1 = try #require(CalibrationEquation("190: 10 19"))
        let results1 = eq1.searchForValidOperations()
        #expect(results1.count == 1)

        let eq2 = try #require(CalibrationEquation("3267: 81 40 27"))
        let results2 = eq2.searchForValidOperations()
        #expect(results2.count == 2)

        let eq3 = try #require(CalibrationEquation("292: 11 6 16 20"))
        let results3 = eq3.searchForValidOperations()
        #expect(results3.count == 1)

        let eq4 = try #require(CalibrationEquation("21037: 9 7 18 13"))
        let results4 = eq4.searchForValidOperations()
        #expect(results4.count == 0)
    }

    @Test func testPartOneWithSampleData() async throws {
        let result = try #require(day.partOne(input: sampleData) as? Int)
        #expect(result == 3749)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 2_654_749_936_343)
    }

    @Test func testValidEquationsSearchWithContactenation() async throws {
        let eq1 = try #require(CalibrationEquation("190: 10 19"))
        let results1 = eq1.searchForValidOperations(useConcatenation: true)
        #expect(results1.count == 1)

        let eq2 = try #require(CalibrationEquation("156: 15 6"))
        let results2 = eq2.searchForValidOperations(useConcatenation: true)
        #expect(results2.count == 1)

        let eq3 = try #require(CalibrationEquation("7290: 6 8 6 15"))
        let results3 = eq3.searchForValidOperations(useConcatenation: true)
        #expect(results3.count == 1)

        let eq4 = try #require(CalibrationEquation("192: 17 8 14"))
        let results4 = eq4.searchForValidOperations(useConcatenation: true)
        #expect(results4.count == 1)
    }

    @Test func testPartTwoWithSampleData() async throws {
        let result = try #require(day.partTwo(input: sampleData) as? Int)
        #expect(result == 11387)
    }

    @Test func testPartTwo() async throws {
        let answer = try await #require(day.run(part: 2) as? Int)
        #expect(answer == 124_060_392_153_684)
    }
}
