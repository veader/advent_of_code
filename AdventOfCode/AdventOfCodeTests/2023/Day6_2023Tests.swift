//
//  Day6_2023Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/6/23.
//

import XCTest

final class Day6_2023Tests: XCTestCase {

    let sampleInput = """
        Time:      7  15   30
        Distance:  9  40  200
        """

    func testParsing() throws {
        let (times, distances) = Day6_2023().parse(sampleInput)
        XCTAssertNotNil(times)
        XCTAssertNotNil(distances)

        XCTAssertEqual(times?.count, 3)
        XCTAssertEqual(distances?.count, 3)

        XCTAssertEqual(times, [7, 15, 30])
        XCTAssertEqual(distances, [9, 40, 200])
    }

    func testPart1() throws {
        let answer = Day6_2023().run(part: 1, sampleInput)
        XCTAssertEqual(288, answer as? Int)
    }

    func testPart1Answer() throws {
        let answer = Day6_2023().run(part: 1)
        XCTAssertEqual(140220, answer as? Int)
    }

    func testPart2() throws {
        let answer = Day6_2023().run(part: 2, sampleInput)
        XCTAssertEqual(71503, answer as? Int)
    }

    func testPart2Answer() throws {
        let answer = Day6_2023().run(part: 2)
        XCTAssertEqual(39570185, answer as? Int)
    }

    func testBinarySearch() throws {
        var answer = try Day6_2023().calculateAdvancedTimes(for: 30, beating: 200)
        XCTAssertEqual(9, answer)

        answer = try Day6_2023().calculateAdvancedTimes(for: 15, beating: 40)
        XCTAssertEqual(8, answer)
    }
}
