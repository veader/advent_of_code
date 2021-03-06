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

    func testPartOneAnswer() {
        let day = DayOne()
        let answer = day.run(part: 1) as! Int
        XCTAssertEqual(3390596, answer)
    }

    func testPartTwo() {
        let day = DayOne()

        var fuel = day.fuelForMass(14)
        XCTAssertEqual(2, fuel + day.fuelCostForMass(fuel))

        fuel = day.fuelForMass(1969)
        XCTAssertEqual(966, fuel + day.fuelCostForMass(fuel))

        fuel = day.fuelForMass(100756)
        XCTAssertEqual(50346, fuel + day.fuelCostForMass(fuel))
    }

    func testPartTwoAnswer() {
        let day = DayOne()
        let answer = day.run(part: 2) as! Int
        XCTAssertEqual(5083024, answer)
    }
}
