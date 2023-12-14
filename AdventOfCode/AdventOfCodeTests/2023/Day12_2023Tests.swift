//
//  Day12_2023Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/13/23.
//

import XCTest

final class Day12_2023Tests: XCTestCase {

    let sampleInput = """
        ???.### 1,1,3
        .??..??...?##. 1,1,3

        ????.#...#... 4,1,1
        ????.######..#####. 1,6,5
        ?###???????? 3,2,1
        """

    let sampleSpring = "???.### 1,1,3"
    let sampleSpring2 = "????.#...#... 4,1,1"
    let sampleSpring3 = "?#?#?#?#?#?#?#? 1,3,1,6"

    func testSpringMapParsing() throws {
        let springMap = try XCTUnwrap(Day12_2023.SpringMap.parse(sampleSpring))
        XCTAssertEqual(3, springMap.springCounts.count)
        XCTAssertEqual([1,1,3], springMap.springCounts)
        XCTAssertEqual(7, springMap.springs.count)
        XCTAssertEqual(Day12_2023.SpringType.unknown, springMap.springs.first)
    }

    func testSpringMapArrangements() throws {
        let springMap = try XCTUnwrap(Day12_2023.SpringMap.parse(sampleSpring))
        _ = springMap.findArrangements()

        let springMap2 = try XCTUnwrap(Day12_2023.SpringMap.parse(sampleSpring2))
        _ = springMap2.findArrangements()

        let springMap3 = try XCTUnwrap(Day12_2023.SpringMap.parse(sampleSpring3))
        _ = springMap3.findArrangements()
    }

    func xtestDay12Parsing() throws {
        let springs = Day12_2023().parse(sampleInput)
        XCTAssertEqual(6, springs.count)
    }
}
