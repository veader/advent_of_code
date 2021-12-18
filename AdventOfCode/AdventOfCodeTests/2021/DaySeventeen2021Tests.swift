//
//  DaySeventeen2021Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/17/21.
//

import XCTest

class DaySeventeen2021Tests: XCTestCase {

    func testInBoundsChecking() {
        let trickShot = TrickShot(areaX: 20...30, areaY: (-10)...(-5))

        // check simple X
        XCTAssertTrue(trickShot.inBounds(Coordinate(x: 0, y: 0)))
        XCTAssertTrue(trickShot.inBounds(Coordinate(x: 20, y: 0)))
        XCTAssertTrue(trickShot.inBounds(Coordinate(x: 30, y: 0)))
        XCTAssertFalse(trickShot.inBounds(Coordinate(x: 31, y: 0)))
        XCTAssertFalse(trickShot.inBounds(Coordinate(x: 69, y: 0)))

        // check simple Y
        XCTAssertTrue(trickShot.inBounds(Coordinate(x: 0, y: 20)))
        XCTAssertTrue(trickShot.inBounds(Coordinate(x: 0, y: 40)))
        XCTAssertTrue(trickShot.inBounds(Coordinate(x: 0, y: -5)))
        XCTAssertTrue(trickShot.inBounds(Coordinate(x: 0, y: -10)))
        XCTAssertFalse(trickShot.inBounds(Coordinate(x: 0, y: -11)))
        XCTAssertFalse(trickShot.inBounds(Coordinate(x: 0, y: -42)))

        // check mix X,Y
        XCTAssertTrue(trickShot.inBounds(Coordinate(x: 10, y: 20)))
        XCTAssertTrue(trickShot.inBounds(Coordinate(x: 10, y: -8)))
        XCTAssertTrue(trickShot.inBounds(Coordinate(x: -11, y: -2)))
        XCTAssertFalse(trickShot.inBounds(Coordinate(x: 22, y: -31)))
        XCTAssertFalse(trickShot.inBounds(Coordinate(x: 55, y: -66)))
    }

    func testShotModelerSimpler() {
        let trickShot = TrickShot(areaX: 20...30, areaY: (-10)...(-5))
        trickShot.findShots()
        XCTAssertEqual(45, trickShot.highestHeight)
        XCTAssertEqual(112, trickShot.workingShots.count)

//        trickShot.modelShot(horizontal: 7, vertical: 9, debugPrint: true)
    }
}
