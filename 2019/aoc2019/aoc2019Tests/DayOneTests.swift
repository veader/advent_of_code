//
//  DayOneTests.swift
//  aoc2019Tests
//
//  Created by Shawn Veader on 12/1/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import XCTest

class DayOneTests: XCTestCase {

    func testPartOne() {
        let day = DayOne()

        XCTAssertEqual(2, day.fuelForMass(12))
        XCTAssertEqual(2, day.fuelForMass(14))
        XCTAssertEqual(654, day.fuelForMass(1969))
        XCTAssertEqual(33583, day.fuelForMass(100756))
    }
}
