//
//  DayThree2021Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/3/21.
//

import XCTest

class DayThree2021Tests: XCTestCase {

    let sampleInput = """
        00100
        11110
        10110
        10111
        10101
        01111
        00111
        11100
        10000
        11001
        00010
        01010
        """

    func testParsing() {
        let day = DayThree2021()
        let parsed = day.parse(sampleInput)
        XCTAssertEqual(12, parsed.count)
        XCTAssertEqual([0,0,1,0,0], parsed.first)
        XCTAssertEqual([0,1,0,1,0], parsed.last)
    }

    func testRateCalculations() {
        let day = DayThree2021()
        let reports = day.parse(sampleInput)
        let rates = day.calcualtePartOne(reports)
        XCTAssertEqual(22, rates.gamma)
        XCTAssertEqual(9, rates.epsilon)
    }

}
