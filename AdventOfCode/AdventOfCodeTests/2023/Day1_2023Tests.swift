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

    let sampleInput2 = """
        two1nine
        eightwothree
        abcone2threexyz
        xtwone3four
        4nineeightseven2
        zoneight234
        7pqrstsixteen
        """

    func testParsing() {
        let output = Day1_2023().parse(sampleInput)
        XCTAssertEqual(output.count, 4)
        XCTAssertEqual([1,2], output[0])
        XCTAssertEqual([3,8], output[1])
        XCTAssertEqual([1,5], output[2])
        XCTAssertEqual([7,7], output[3])
    }

    func testPart1() {
        let answer = Day1_2023().run(part: 1, sampleInput)
        XCTAssertEqual(142, answer as? Int)
    }

    func testParsingWithTranslate() {
        let output = Day1_2023().parse(sampleInput2, translate: true)
        XCTAssertEqual(output.count, 7)
        XCTAssertEqual([2,9], output[0])
        XCTAssertEqual([8,3], output[1])
        XCTAssertEqual([1,3], output[2])
        XCTAssertEqual([2,4], output[3])
        XCTAssertEqual([4,2], output[4])
        XCTAssertEqual([1,4], output[5])
        XCTAssertEqual([7,6], output[6])
    }

    func testParsingOdd() {
        var output = Day1_2023().parse("eightsixhnsbnine1twonevrs", translate: false)
        XCTAssertEqual(output.count, 1)
        XCTAssertEqual([1,1], output[0])

        output = Day1_2023().parse("eightsixhnsbnine1twonevrs", translate: true)
        XCTAssertEqual(output.count, 1)
        XCTAssertEqual([8,1], output[0])
    }

    func testPart2() {
        let answer = Day1_2023().run(part: 2, sampleInput2)
        XCTAssertEqual(281, answer as? Int)
    }
}
