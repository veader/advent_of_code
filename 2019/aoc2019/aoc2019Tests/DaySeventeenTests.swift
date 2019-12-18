//
//  DaySeventeenTests.swift
//  aoc2019Tests
//
//  Created by Shawn Veader on 12/17/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import XCTest

class DaySeventeenTests: XCTestCase {
    /*
     ..#..........
     ..#..........
     #######...###
     #.#...#...#.#
     #############
     ..#...#...#..
     ..#####...^..
     */

    let testInput = [46, 46, 35, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 10,
                     46, 46, 35, 46, 46, 46, 46, 46, 46, 46, 46, 46, 46, 10,
                     35, 35, 35, 35, 35, 35, 35, 46, 46, 46, 35, 35, 35, 10,
                     35, 46, 35, 46, 46, 46, 35, 46, 46, 46, 35, 46, 35, 10,
                     35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 10,
                     46, 46, 35, 46, 46, 46, 35, 46, 46, 46, 35, 46, 46, 10,
                     46, 46, 35, 35, 35, 35, 35, 46, 46, 46, 35, 46, 46
                    ]

    func testCamera() {
        let camera = Camera(input: testInput)
        camera.printScreen()
    }

    func testIntersections() {
        let camera = Camera(input: testInput)
        let intersections = camera.intersections()
        XCTAssertTrue(intersections.contains(Coordinate(x:  2, y: 2)))
        XCTAssertTrue(intersections.contains(Coordinate(x:  2, y: 4)))
        XCTAssertTrue(intersections.contains(Coordinate(x:  6, y: 4)))
        XCTAssertTrue(intersections.contains(Coordinate(x: 10, y: 4)))
    }

    func testPartOne() {
        let camera = Camera(input: testInput)
        let intersections = camera.intersections()
        let answer = intersections.reduce(0) {  $0 + ($1.x * $1.y) }
        XCTAssertEqual(76, answer)
    }
}
