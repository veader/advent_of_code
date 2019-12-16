//
//  DayFifteenTests.swift
//  aoc2019Tests
//
//  Created by Shawn Veader on 12/16/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import XCTest

class DayFifteenTests: XCTestCase {

    func testArrayRotation() {
        let input = [1,2,3,4,5,6]

        // rotating left (default)
        XCTAssertEqual(input, input.rotate(by: 0))
        XCTAssertEqual([2,3,4,5,6,1], input.rotate(by: 1))
        XCTAssertEqual([3,4,5,6,1,2], input.rotate(by: 2))
        XCTAssertEqual([4,5,6,1,2,3], input.rotate(by: 3))
        XCTAssertEqual([5,6,1,2,3,4], input.rotate(by: 4))
        XCTAssertEqual([6,1,2,3,4,5], input.rotate(by: 5))
        XCTAssertEqual(input, input.rotate(by: 6)) // wrap around

        // rotating right
        XCTAssertEqual([5,6,1,2,3,4], input.rotate(by: -2))
        XCTAssertEqual([4,5,6,1,2,3], input.rotate(by: -3))
    }

}
