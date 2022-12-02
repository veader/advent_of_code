//
//  DayOne2022Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/1/22.
//

import XCTest

final class DayOne2022Tests: XCTestCase {

    let sampleInput = """
        1000
        2000
        3000

        4000

        5000
        6000

        7000
        8000
        9000

        10000
        """

    func testParsing() {
        let day = DayOne2022()

        let parsed = day.parse(sampleInput)
        XCTAssertEqual(5, parsed.count)

        let firstElf = parsed.first!
        XCTAssertEqual(3, firstElf.snacks.count)

        let lastElf = parsed.last!
        XCTAssertEqual(1, lastElf.snacks.count)
    }

    func testCalorieCount() {
        let day = DayOne2022()

        let parsed = day.parse(sampleInput)
        let firstElf = parsed.first!
        XCTAssertEqual(3, firstElf.snacks.count)
        XCTAssertEqual(6000, firstElf.totalCalories)
    }

    func testMaxCalories() {
        let day = DayOne2022()
        let answer = day.partOne(input: sampleInput)
        XCTAssertEqual(24000, answer as! Int)
    }

    func testTopThreeCalories() {
        let day = DayOne2022()
        let answer = day.partTwo(input: sampleInput)
        XCTAssertEqual(45000, answer as! Int)
    }
}
