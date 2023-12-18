//
//  Day3_2023Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/3/23.
//

import XCTest

final class Day3_2023Tests: XCTestCase {

    let sampleInput = """
        467..114..
        ...*......
        ..35..633.
        ......#...
        617*......
        .....+.58.
        ..592.....
        ......755.
        ...$.*....
        .664.598..
        """

    func testParsing() throws {
        let (parts, symbols) = Day3_2023().parse(sampleInput)
        XCTAssertEqual(parts.count, 10)
        XCTAssertEqual(symbols.count, 6)
    }

    func testPart1() async throws {
        let answer = await Day3_2023().run(part: 1, sampleInput)
        XCTAssertEqual(4361, answer as? Int)
    }

    func testPart1Answer() async throws {
        let answer = await Day3_2023().run(part: 1)
        XCTAssertEqual(543867, answer as? Int)
    }

    func testPart2() async throws {
        let answer = await Day3_2023().run(part: 2, sampleInput)
        XCTAssertEqual(467835, answer as? Int)
    }

    func testPart2Answer() async throws {
        let answer = await Day3_2023().run(part: 2)
        XCTAssertEqual(79613331, answer as? Int)
    }
}
