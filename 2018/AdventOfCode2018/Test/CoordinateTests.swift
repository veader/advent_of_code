//
//  CoordinateTests.swift
//  Test
//
//  Created by Shawn Veader on 12/6/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import XCTest

class CoordinateTests: XCTestCase {

    func testManhattanDistance() {
        XCTAssertEqual(10, Coordinate(x: 0, y: 0).distance(to: Coordinate(x: 5, y: 5)))
        XCTAssertEqual(10, Coordinate(x: 0, y: 0).distance(to: Coordinate(x: -5, y: 5)))
        XCTAssertEqual(10, Coordinate(x: 0, y: 0).distance(to: Coordinate(x: -5, y: -5)))
    }

}
