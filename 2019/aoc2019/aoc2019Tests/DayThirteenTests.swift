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
        XCTAssertEqual(.horizontalPaddle, screen.grid[Coordinate(x: 1, y: 2)])
        XCTAssertEqual(.ball, screen.grid[Coordinate(x: 6, y: 5)])
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
