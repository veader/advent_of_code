//
//  Day13_2023Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/13/23.
//

import XCTest

final class Day13_2023Tests: XCTestCase {

    let sampleInput = """
        #.##..##.
        ..#.##.#.
        ##......#
        ##......#
        ..#.##.#.
        ..##..##.
        #.#.##.#.

        #...##..#
        #....#..#
        ..##..###
        #####.##.
        #####.##.
        ..##..###
        #....#..#
        """

    func testParsing() throws {
        let patterns = Day13_2023().parse(sampleInput)
        XCTAssertEqual(2, patterns.count)

        let first = try XCTUnwrap(patterns.first)
        XCTAssertEqual(7, first.data.yBounds.count)
        XCTAssertEqual(9, first.data.xBounds.count)
    }

    func testMirrorPatternVerticalDetection() throws {
        let patterns = Day13_2023().parse(sampleInput)
        let pattern = try XCTUnwrap(patterns.first)
        print(pattern.data.printGrid())
        let answer = pattern.reflection()
        XCTAssertEqual(answer, .vertical(x: 5))
    }

    func testMirrorPatternHorizontalDetection() throws {
        let patterns = Day13_2023().parse(sampleInput)
        let pattern = try XCTUnwrap(patterns.last)
        let answer = pattern.reflection()
        XCTAssertEqual(answer, .horizontal(y: 4))
    }

    func testPart1() throws {
        let answer = Day13_2023().run(part: 1, sampleInput)
        XCTAssertEqual(405, answer as? Int)
    }

    func testPart1Answer() throws {
        let answer = Day13_2023().run(part: 1)
        XCTAssertEqual(37975, answer as? Int)
    }
}
