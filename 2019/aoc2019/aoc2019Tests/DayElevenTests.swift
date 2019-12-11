//
//  DayElevenTests.swift
//  aoc2019Tests
//
//  Created by Shawn Veader on 12/11/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import XCTest

class DayElevenTests: XCTestCase {

    func testOrientationTurning() {
        var orientation: Orientation

        orientation = Orientation.north
        XCTAssertEqual(.east, orientation.turnRight())
        XCTAssertEqual(.west, orientation.turnLeft())

        orientation = .west
        XCTAssertEqual(.north, orientation.turnRight())
        XCTAssertEqual(.south, orientation.turnLeft())
    }

    func testArrayLastFunc() {
        var arr: Array<Int>

        arr = []
        XCTAssertNil(arr.last(count: 2))

        arr = [1]
        XCTAssertNil(arr.last(count: 2))

        arr = [1,2]
        XCTAssertEqual(arr, arr.last(count: 2))

        arr = [1,2,3,4,5,6,7]
        XCTAssertEqual([6, 7], arr.last(count: 2))
    }

    func testPartOneAnswer() {
        let day = DayEleven()
        let answer = day.run(part: 1) as! Int
        XCTAssertEqual(2226, answer)
    }

    func testPartTwoAnswer() {
        XCTAssert(true)
        // answer is in printed output
//        let day = DayEleven()
//        let answer = day.run(part: 2) as! Int
//        XCTAssertEqual(416, answer)
    }
}
