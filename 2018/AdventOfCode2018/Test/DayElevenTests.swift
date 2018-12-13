//
//  DayElevenTests.swift
//  Test
//
//  Created by Shawn Veader on 12/12/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import XCTest

class DayElevenTests: XCTestCase {

    func testCoordinatePowerLevel() {
        var c = Coordinate(x: 3, y: 5)
        XCTAssertEqual(4, c.power(serial: 8))

        c = Coordinate(x: 122, y: 79)
        XCTAssertEqual(-5, c.power(serial: 57))

        c = Coordinate(x: 217, y: 196)
        XCTAssertEqual(0, c.power(serial: 39))

        c = Coordinate(x: 101, y: 153)
        XCTAssertEqual(4, c.power(serial: 71))
    }

}
