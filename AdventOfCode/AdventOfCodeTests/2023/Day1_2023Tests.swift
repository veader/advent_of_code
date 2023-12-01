//
//  Day1_2023Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/1/23.
//

import XCTest

final class Day1_2023Tests: XCTestCase {

    let sampleInput = """
        1abc2
        pqr3stu8vwx
        a1b2c3d4e5f
        treb7uchet
        """

    func testParsing() {
        let day = Day1_2023()
        let output = day.parse(sampleInput)
        XCTAssertEqual(output.count, 4)
        XCTAssertEqual([1,2], output[0])
        XCTAssertEqual([3,8], output[1])
        XCTAssertEqual([1,2,3,4,5], output[2])
        XCTAssertEqual([7], output[3])
    }

    func testPart1() {
        let day = Day1_2023()
        let answer = day.run(part: 1, sampleInput)
        XCTAssertEqual(142, answer as? Int)
    }
}
