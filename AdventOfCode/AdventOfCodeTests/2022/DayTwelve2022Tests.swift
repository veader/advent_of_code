//
//  DayTwelve2022Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/12/22.
//

import XCTest

final class DayTwelve2022Tests: XCTestCase {

    let sampleInput = """
        Sabqponm
        abcryxxl
        accszExk
        acctuvwj
        abdefghi
        """

    func testAlgoParsing() {
        let algo = HillClimbingAlgo(sampleInput)
        XCTAssertEqual(0..<8, algo.map.xBounds)
        XCTAssertEqual(0..<5, algo.map.yBounds)
        XCTAssertEqual(Coordinate(x: 0, y: 0), algo.start)
        XCTAssertEqual(Coordinate(x: 5, y: 2), algo.end)
        algo.map.printGrid()
    }

    func testAscentAlgo() {
        let algo = HillClimbingAlgo(sampleInput)
        let path = algo.climb()
        XCTAssertEqual(31, path?.count)
    }

    func testPartOne() {
        let answer = DayTwelve2022().partOne(input: sampleInput)
        XCTAssertEqual(31, answer as! Int)
    }
}
