//
//  Day9_2023Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/9/23.
//

import XCTest

final class Day9_2023Tests: XCTestCase {

    let sampleInput = """
        0 3 6 9 12 15
        1 3 6 10 15 21
        10 13 16 21 30 45
        """

    func testDay9Parsing() throws {
        let readings = Day9_2023().parse(sampleInput)
        XCTAssertEqual(3, readings.count)
        XCTAssertEqual(6, readings[0].readings.count)
        XCTAssertEqual(6, readings[1].readings.count)
        XCTAssertEqual(6, readings[1].readings.count)
    }

    func testReadingProcessing() throws {
        let readings = Day9_2023().parse(sampleInput)
        var reading = readings.first
        var arr = reading?.process()
        XCTAssertEqual(18, arr?.last)

        reading = readings[1]
        arr = reading?.process()
        XCTAssertEqual(28, arr?.last)

        reading = readings[2]
        arr = reading?.process()
        XCTAssertEqual(68, arr?.last)
    }

    func testPart1() async throws {
        let answer = await Day9_2023().run(part: 1, sampleInput)
        XCTAssertEqual(114, answer as? Int)
    }

    func testPart1Answer() async throws {
        let answer = await Day9_2023().run(part: 1)
        XCTAssertEqual(2038472161, answer as? Int)
    }

    func testPart2() async throws {
        let answer = await Day9_2023().run(part: 2, sampleInput)
        XCTAssertEqual(2, answer as? Int)
    }

    func testPart2Answer() async throws {
        let answer = await Day9_2023().run(part: 2)
        XCTAssertEqual(1091, answer as? Int)
    }
}
