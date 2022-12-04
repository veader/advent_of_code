//
//  DayFour2022Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/4/22.
//

import XCTest

final class DayFour2022Tests: XCTestCase {

    let sampleInput = """
        2-4,6-8
        2-3,4-5
        5-7,7-9
        2-8,3-7
        6-6,4-6
        2-6,4-8
        """

    func testParsing() {
        let parsed = DayFour2022().parse(sampleInput)

        let first = parsed.first!
        XCTAssertEqual(2, first.elf1.first)
        XCTAssertEqual(4, first.elf1.last)
        XCTAssertEqual(6, first.elf2.first)
        XCTAssertEqual(8, first.elf2.last)

        let last = parsed.last!
        XCTAssertEqual(2, last.elf1.first)
        XCTAssertEqual(6, last.elf1.last)
        XCTAssertEqual(4, last.elf2.first)
        XCTAssertEqual(8, last.elf2.last)
    }

    func testOverlap() {
        let noOverlapEasy = DayFour2022.CampSections("2-4,6-8")!
        XCTAssertFalse(noOverlapEasy.fullyOverlaps())

        let noOverlap = DayFour2022.CampSections("0-1,2-40")!
        XCTAssertFalse(noOverlap.fullyOverlaps())

        let partialOverlap = DayFour2022.CampSections("2-6,4-8")!
        XCTAssertFalse(partialOverlap.fullyOverlaps())

        let overlapEasy = DayFour2022.CampSections("2-4,2-4")!
        XCTAssertTrue(overlapEasy.fullyOverlaps())

        let overlaps = DayFour2022.CampSections("2-8,3-7")!
        XCTAssertTrue(overlaps.fullyOverlaps())
    }

    func testPartOne() {
        let answer = DayFour2022().partOne(input: sampleInput)
        XCTAssertEqual(2, answer as! Int)
    }
}
