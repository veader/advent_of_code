//
//  DayFourteen2022Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/16/22.
//

import XCTest

final class DayFourteen2022Tests: XCTestCase {

    let sampleInput = """
        498,4 -> 498,6 -> 496,6
        503,4 -> 502,4 -> 502,9 -> 494,9
        """
    func testSimpleParsing() {
        let paths = SandSim.parse(sampleInput)
        XCTAssertEqual(2, paths.count)
        print(paths)
    }
}
