//
//  Day18_2023Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/25/23.
//

import XCTest

final class Day18_2023Tests: XCTestCase {
    let sampleInput = """
        R 6 (#70c710)
        D 5 (#0dc571)
        L 2 (#5713f0)
        D 2 (#d2c081)
        R 2 (#59c680)
        D 2 (#411b91)
        L 5 (#8ceee2)
        U 2 (#caa173)
        L 1 (#1b58a2)
        U 2 (#caa171)
        R 2 (#7807d2)
        U 3 (#a77fa3)
        L 2 (#015232)
        U 2 (#7a21e3)
        """

    func testParsingOfDiggingInstruction() {
        let badInst = Day18_2023.DiggingInstruction("asdf")
        XCTAssertNil(badInst)

        let inst1 = Day18_2023.DiggingInstruction("R 11 (#050d70)")
        XCTAssertEqual(.right, inst1?.direction)
        XCTAssertEqual(11, inst1?.distance)
        XCTAssertEqual("#050d70", inst1?.color)

        let inst2 = Day18_2023.DiggingInstruction("U 6 (#264a73)")
        XCTAssertEqual(.up, inst2?.direction)
        XCTAssertEqual(6, inst2?.distance)
        XCTAssertEqual("#264a73", inst2?.color)
    }

    func testParsing() {
        let instructions = Day18_2023().parse(sampleInput)
        XCTAssertEqual(14, instructions.count)
    }

    func testPart1() async {
        let answer = await Day18_2023().run(part: 1, sampleInput)
    }
}
