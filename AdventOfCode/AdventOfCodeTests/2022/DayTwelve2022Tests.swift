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
        XCTAssertEqual(32, path.count)
    }

    func testPartOne() {
        let answer = DayTwelve2022().partOne(input: sampleInput)
        XCTAssertEqual(31, answer as! Int)
    }

    func testLowestPoints() {
        let algo = HillClimbingAlgo(sampleInput)
        let points = algo.lowestPoints()
        XCTAssertEqual(6, points.count)
        XCTAssertTrue(points.contains(algo.start))
    }

    func testRouteFindingFromLowest() {
        let algo = HillClimbingAlgo(sampleInput)
        let route = algo.shortestRoute()
        XCTAssertNotNil(route)
        XCTAssertEqual(30, route?.count)
    }

    func testRoundTwo() {
        let answer = DayTwelve2022().partTwo(input: sampleInput)
        XCTAssertEqual(29, answer as! Int)
    }

    func testSomething() {
        let answers = [403, 418, 424, 411, 413, 412, 407, 425, 426, 410, 422, 427, 419, 431, 405, 406, 428, 432, 423, 416, 420, 430, 0, 404, 429, 421, 409, 408, 417, 415, 414, 433]
        print(answers.sorted())
    }
}
