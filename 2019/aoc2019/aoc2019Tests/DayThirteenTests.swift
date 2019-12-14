//
//  DayThirteenTests.swift
//  aoc2019Tests
//
//  Created by Shawn Veader on 12/13/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import XCTest

class DayThirteenTests: XCTestCase {

    func testScreenInput() {
        let screen = ArcadeScreen()
        screen.draw(input: [1,2,3,6,5,4])
        XCTAssertEqual(.paddle, screen.grid[Coordinate(x: 1, y: 2)])
        XCTAssertEqual(.ball, screen.grid[Coordinate(x: 6, y: 5)])
    }

    func testNextCoordinateOnSlope() {
        var answer: Coordinate

        // moving right
        answer = Coordinate.origin.next(on: Coordinate.SlopeType.horizontal(direction: 1))
        XCTAssertEqual(0, answer.y)
        XCTAssertEqual(1, answer.x)

        // moving left
        answer = Coordinate.origin.next(on: Coordinate.SlopeType.horizontal(direction: -1))
        XCTAssertEqual(0, answer.y)
        XCTAssertEqual(-1, answer.x)

        // moving up
        answer = Coordinate.origin.next(on: Coordinate.SlopeType.vertical(direction: 1))
        XCTAssertEqual(1, answer.y)
        XCTAssertEqual(0, answer.x)

        // moving down
        answer = Coordinate.origin.next(on: Coordinate.SlopeType.vertical(direction: -1))
        XCTAssertEqual(-1, answer.y)
        XCTAssertEqual(0, answer.x)

        // moving up and right
        answer = Coordinate.origin.next(on: Coordinate.SlopeType.normal(slope: 1, direction: 1))
        XCTAssertEqual(1, answer.y)
        XCTAssertEqual(1, answer.x)

        // moving up and left
        answer = Coordinate.origin.next(on: Coordinate.SlopeType.normal(slope: -1, direction: 1))
        XCTAssertEqual(1, answer.y)
        XCTAssertEqual(-1, answer.x)

        // moving down and right
        answer = Coordinate.origin.next(on: Coordinate.SlopeType.normal(slope: -1, direction: -1))
        XCTAssertEqual(-1, answer.y)
        XCTAssertEqual(1, answer.x)

        // moving down and left
        answer = Coordinate.origin.next(on: Coordinate.SlopeType.normal(slope: 1, direction: -1))
        XCTAssertEqual(-1, answer.y)
        XCTAssertEqual(-1, answer.x)

    }

    func testPartOneAnswer() {
        let day = DayThirteen()
        let answer = day.run(part: 1) as! Int
        XCTAssertEqual(344, answer)
    }

    func testPartTwoAnswer() {
        XCTAssert(true)
//        let day = DayThirteen()
//        let answer = day.run(part: 2) as! Int
//        XCTAssertEqual(416, answer)
    }
}
